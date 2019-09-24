package searchFilter;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.AccountDetails;
import common.DatabaseConnection;
import common.Helper;
import logging.LogHelper;
import userValidation.Authentication;

public class UnprovisionAccounts extends HttpServlet
{
	private static final long serialVersionUID = 1298354747863407644L;

	private static final String CLASS_NAME = "FilterAccount";

	private static final String PACKAGE_NAME = "userValidation";

	private ArrayList<AccountDetails> userProvisionedList = null;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, java.io.IOException
	{
		String METHOD_NAME = "doPost";
		HttpSession session = request.getSession();
		Connection conn = null;
		try
		{
			if (null != request.getParameter("unprovision"))
			{
				fetchUnprovisionedList(request,session,conn);
				RequestDispatcher dispatcher = request.getRequestDispatcher("/UnProvisioning.jsp");
				dispatcher.forward(request, response);
			}
			else if (null != request.getParameter("Logout"))
			{
				Helper.invalidateSession(session);
				session.invalidate();
				RequestDispatcher dispatcher = request.getRequestDispatcher("/homePage.jsp");
				dispatcher.forward(request, response);
			}
			else if (null != request.getParameter("Close"))
			{
				RequestDispatcher dispatcher = request.getRequestDispatcher("/UserOptions.jsp");
				dispatcher.forward(request, response);
			}
			else if (null != request.getParameter("Unprovision"))
			{
				String selectedCheckBoxes = request.getParameter("accountSelected");
				String query = "";
				String[] selectedCheckBoxArray = selectedCheckBoxes.split(",");
				conn = DatabaseConnection.getDBConnection(Authentication.dbconfig);
				ArrayList<String> accountNumberList = new ArrayList<String>();

				for (int i = 0; i < selectedCheckBoxArray.length; i++)
				{
					int index = Integer.parseInt(selectedCheckBoxArray[i]);
					AccountDetails accObj = userProvisionedList.get(index);

					accountNumberList.add(accObj.getAccountNumber());
				}
				query = "Update " + Authentication.dbconfig.getTableName()
						+ " set RESERVED_TC_NO=null, RESERVED_BY=null, RESERVED_DATE=null, RESERVED_BPA=null,RESERVED_FDT_PHASE=null where ACCOUNT_NUMBER in (";

				for (String atr : accountNumberList)
				{
					query = query + "'" + atr + "',";
				}
				query = query.substring(0, query.length() - 1);
				query = query + ")";
				
				updateTableStatus(conn, query);
				
				fetchUnprovisionedList(request,session,conn);
				RequestDispatcher dispatcher = request.getRequestDispatcher("/UnProvisioning.jsp");
				dispatcher.forward(request, response);
			}
		}
		catch (SQLException e)
		{
			LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
			request.setAttribute("DbConnectionIssue", e.getMessage());
		}
		catch (Exception e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private void fetchUnprovisionedList(HttpServletRequest request, HttpSession session, Connection conn) throws SQLException
	{
		String METHOD_NAME = "fetchUnprovisionedList";
		String query = "Select * from " + Authentication.dbconfig.getTableName() + " where RESERVED_BY = ";
		String userId = (String) session.getAttribute("userId");
		query = query + "'" + userId.toUpperCase() + "'";
		LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, query, null);
		conn = DatabaseConnection.getDBConnection(Authentication.dbconfig);
		userProvisionedList = new ArrayList<AccountDetails>();
		userProvisionedList = searchAccountDetails(conn, query);

		if (userProvisionedList.isEmpty())
		{
			request.setAttribute("userProvisionednullList", "null");
		}
		else
		{
			request.setAttribute("userProvisionedList", userProvisionedList);
		}
		request.setAttribute("Navigation", "Search");
		
		
	}

	private static void updateTableStatus(Connection conn, String query) throws Exception
	{
		PreparedStatement pstmt = null;
		pstmt = conn.prepareStatement(query);
		pstmt.executeUpdate();
		pstmt.close();
	}

	// Method to perform the account search and store the values in a list
	public ArrayList<AccountDetails> searchAccountDetails(Connection conn, String query) throws SQLException
	{
		final String METHOD_NAME = "searchAccountDetails";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<AccountDetails> accountDetailsList = new ArrayList<AccountDetails>();
		try
		{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while (rs.next())
			{
				AccountDetails accountDetails = new AccountDetails();
				String accountNumber = rs.getString("ACCOUNT_NUMBER");
				String brand = rs.getString("PRINCIPAL_BRAND");
				String agrCode = rs.getString("agr_code");
				String next_statement_date = rs.getString("NEXT_STATEMENT_DATE_CIM");
				Double air = rs.getDouble("CURRENT_AIR");
				Double creditLimit = rs.getDouble("CREDIT_MONETARY_LIMIT");
				Double otb = rs.getDouble("OTB_CAM");
				String reservedBy = rs.getString("RESERVED_BY");
				int reservedTcNo = rs.getInt("RESERVED_TC_NO");
				Date reservedDate = rs.getDate("RESERVED_DATE");
				int accountStatus = rs.getInt("current_account_status");
				String phase = rs.getString("RESERVED_FDT_PHASE");
				String bpa = rs.getString("RESERVED_BPA");

				if (null != accountNumber && !accountNumber.equals(""))
				{
					accountDetails.setAccountNumber(accountNumber);
				}
				if (null != brand && !brand.equals(""))
				{
					accountDetails.setBrand(brand);
				}
				if (null != agrCode && !agrCode.equals(""))
				{
					accountDetails.setAgrCode(agrCode);
				}

				if (null != next_statement_date)
				{
					accountDetails.setNextStatementDate(next_statement_date);
				}
				if (null != reservedBy)
				{
					accountDetails.setReservedBy(reservedBy.substring(0, 1).toUpperCase() + reservedBy.substring(1).toLowerCase());
				}
				else
				{
					accountDetails.setReservedBy(null);
				}
				if (null != reservedDate)
				{
					accountDetails.setReservedDate(reservedDate);
				}
				if (reservedTcNo == 0)
				{
					accountDetails.setReservedTcNo(null);
				}
				else
				{
					accountDetails.setReservedTcNo(String.valueOf(reservedTcNo));
				}

				if (null != phase && !phase.equals(""))
				{
					accountDetails.setPhase(phase);
				}
				if (null != bpa && !bpa.equals(""))
				{
					accountDetails.setBPA(bpa);
				}
				accountDetails.setAccountStatus(accountStatus);
				accountDetails.setOTB(otb);
				accountDetails.setAir(air);
				accountDetails.setCreditLimit(creditLimit);
				if (accountDetails.getBPA() == null || (accountDetails.getBPA() != null && !accountDetails.getBPA().contains("DO NOT USE")))
				{
					accountDetailsList.add(accountDetails);
				}
			}
		}
		catch (SQLException e)
		{
			LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
			throw e;
		}
		finally
		{
			if (null != conn)
			{
				conn.close();
			}
			if (null != rs)
			{
				rs.close();
			}
			if (null != pstmt)
			{
				pstmt.close();
			}
		}
		return accountDetailsList;
	}

	public ArrayList<AccountDetails> getUserProvisionedList()
	{
		return userProvisionedList;
	}

	public void setUserProvisionedList(ArrayList<AccountDetails> userProvisionedList)
	{
		this.userProvisionedList = userProvisionedList;
	}

}