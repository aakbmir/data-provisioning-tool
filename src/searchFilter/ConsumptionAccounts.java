package searchFilter;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.StringTokenizer;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.CommonConstants;
import common.ConsumptionDetails;
import common.DatabaseConnection;
import common.Helper;
import logging.LogHelper;
import userValidation.Authentication;

public class ConsumptionAccounts extends HttpServlet
{
	private static final long serialVersionUID = 1298354747863407644L;

	private static final String CLASS_NAME = "FilterAccount";

	private static final String PACKAGE_NAME = "userValidation";

	private String MessageDetails = "";

	private ArrayList<ConsumptionDetails> accountDetailsList = null;

	private ArrayList<ConsumptionDetails> accountNumberList = null;

	private String errorMessage;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, java.io.IOException
	{
		HttpSession session = request.getSession();
		Connection conn = null;
		request.setAttribute("DbConnectionIssue", null);

		if (null != request.getParameter("ConsumptionSearchSubmitButton"))
		{
			accountNumberList = new ArrayList<ConsumptionDetails>();
			String accountNumbers = request.getParameter("AccountNumberText");
			StringTokenizer stringtokenizer = new StringTokenizer(accountNumbers, CommonConstants.SEMI_COLON);
			while (stringtokenizer.hasMoreTokens())
			{
				ConsumptionDetails consumptionDetails = new ConsumptionDetails();
				String accountNum = stringtokenizer.nextToken().replaceAll("\r\n", "");
				consumptionDetails.setAccountNumber(accountNum);
				accountNumberList.add(consumptionDetails);
			}
			searchSubmitButton(request, conn, session, accountNumberList);
			RequestDispatcher dispatcher = request.getRequestDispatcher("/Consumption.jsp");
			dispatcher.forward(request, response);
		}
		else if (null != request.getParameter("Close") || null != request.getParameter("consumption"))
		{
			RequestDispatcher dispatcher = request.getRequestDispatcher("/UserOptions.jsp");
			dispatcher.forward(request, response);
		}
		else if (null != request.getParameter("submit"))
		{


			String selectedCheckBoxes = request.getParameter("accountSelected");
			String[] selectedCheckBoxArray = selectedCheckBoxes.split(",");
			
			try
			{
				conn = DatabaseConnection.getDBConnection(Authentication.dbconfig);
			}
			catch (SQLException e1)
			{
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			String accUsedForTC = "";
			String usedDate = "";
			String tcStatus = "";
			String accountNumber = "";
			String reservedTcNo = "";

			String query = "";
			int ind;
			int tcNumber;

			for (int i = 0; i < selectedCheckBoxArray.length; i++)
			{
				int index = Integer.parseInt(selectedCheckBoxArray[i]);
				ConsumptionDetails accObj = accountDetailsList.get(index);
				accountNumber = accObj.getAccountNumber();
				reservedTcNo = accObj.getReservedTcNo();
				ind = index;
				accUsedForTC = request.getParameter("accUsedNameAttr" + ind);
				usedDate = request.getParameter("usedDateNameAttr" + ind);
				tcStatus = request.getParameter("tcStatusNameAttr" + ind);
				tcNumber = Integer.parseInt(reservedTcNo);
				Date date;
				try
				{
					date = Helper.convertToDate(usedDate, "yyyy-MM-dd");

					query = "Insert into fdt_account_consump_tracker(ACCOUNT_NUMBER,RESERVED_TC_NO,ACCT_USED_FOR_TC,ACCT_USAGE_DATE,TC_STATUS) values (?,?,?,?,?)";

					updateTableStatus(conn, query, accountNumber, tcNumber, accUsedForTC, date, tcStatus);
				}
				catch (ParseException e)
				{
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				catch (Exception e)
				{
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				

			}
			RequestDispatcher dispatcher = request.getRequestDispatcher("/Consumption.jsp");
			dispatcher.forward(request, response);
		}
	}

	private static void updateTableStatus(Connection conn, String query, String accountNumber, int testCaseNumber, String accUsedForTC, Date usedDate, String tcStatus) throws Exception
	{
		PreparedStatement pstmt = null;

		java.sql.Date dateSql = new java.sql.Date(usedDate.getTime());
		pstmt = conn.prepareStatement(query);
		pstmt.setString(1, accountNumber);
		pstmt.setInt(2, testCaseNumber);

		pstmt.setString(3, accUsedForTC);
		pstmt.setDate(4, dateSql);
		pstmt.setString(5, tcStatus);
		pstmt.executeUpdate();
		pstmt.close();

	}

	private void searchSubmitButton(HttpServletRequest request, Connection conn, HttpSession session, ArrayList<ConsumptionDetails> accountNumberList)
	{
		final String METHOD_NAME = "searchSubmitButton";
		try
		{

			String query = "Select * from " + Authentication.dbconfig.getTableName() + " where RESERVED_TC_NO is not null and account_number in (";
			for (ConsumptionDetails atr : accountNumberList)
			{
				query = query + "'" + atr.getAccountNumber() + "',";
			}
			query = query.substring(0, query.length() - 1);
			query = query + ")";
			LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, query, null);
			conn = DatabaseConnection.getDBConnection(Authentication.dbconfig);

			accountDetailsList = searchAccountDetails(conn, query);

			if (accountDetailsList != null || accountDetailsList.isEmpty())
			{
				MessageDetails = "No records found for the search criteria.";
			}
			else
			{
				MessageDetails = "";
			}

			request.setAttribute("accountDetailsList", accountDetailsList);

			request.setAttribute("MessageDetails", MessageDetails);
		}
		catch (SQLException e)
		{
			LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
			request.setAttribute("DbConnectionIssue", e.getMessage());
		}

	}

	// Method to perform the account search and store the values in a list
	public ArrayList<ConsumptionDetails> searchAccountDetails(Connection conn, String query) throws SQLException
	{
		final String METHOD_NAME = "searchAccountDetails";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<ConsumptionDetails> accountDetailsList = new ArrayList<ConsumptionDetails>();
		try
		{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while (rs.next())
			{
				ConsumptionDetails accountDetails = new ConsumptionDetails();
				String accountNumber = rs.getString("ACCOUNT_NUMBER");
				String reservedBy = rs.getString("RESERVED_BY");
				int reservedTcNo = rs.getInt("RESERVED_TC_NO");

				if (null != accountNumber && !accountNumber.equals(""))
				{
					accountDetails.setAccountNumber(accountNumber);
				}

				if (null != reservedBy)
				{
					accountDetails.setReservedBy(reservedBy.substring(0, 1).toUpperCase() + reservedBy.substring(1).toLowerCase());
				}
				else
				{
					accountDetails.setReservedBy(null);
				}

				if (reservedTcNo == 0)
				{
					accountDetails.setReservedTcNo(null);
				}
				else
				{
					accountDetails.setReservedTcNo(String.valueOf(reservedTcNo));
				}
				boolean existFlag = false;
				for (ConsumptionDetails acc : accountDetailsList)
				{
					if (acc.getAccountNumber().equalsIgnoreCase(accountDetails.getAccountNumber()))
					{
						existFlag = true;
					}
				}
				if (!existFlag)
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

	public String getErrorMessage()
	{
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage)
	{
		this.errorMessage = errorMessage;
	}

}