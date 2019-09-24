package searchFilter;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.StringTokenizer;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.w3c.dom.Document;

import common.AccountDetails;
import common.ColumnsDisplayed;
import common.CommonConstants;
import common.DatabaseConfiguration;
import common.DatabaseConnection;
import common.Helper;
import logging.LogHelper;
import userValidation.Authentication;
import validationPoint.DatabaseService;
import validationPoint.ValidationPointAttributeAccount;
import validationPoint.ValidationPointAttributeOrder;

public class FilterAccount extends HttpServlet
{
	private static final long serialVersionUID = 1298354747863407644L;

	private static final String CLASS_NAME = "FilterAccount";

	private static final String PACKAGE_NAME = "userValidation";

	private int totalNumberOfRecords = 0;

	private int NumberOfAccountsSearched = 0;

	private String MessageDetails = "";

	private ArrayList<AccountDetails> accountDetailsList = null;

	private ArrayList<AccountDetails> accountNumberList = null;

	private String errorMessage;

	private ArrayList<ValidationPointAttributeAccount> validationAccountList = null;

	private HashMap<String, String> validationPreviousList = null;

	private ArrayList<ValidationPointAttributeOrder> validationOrderList = null;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, java.io.IOException
	{
		String METHOD_NAME = "doPost";
		HttpSession session = request.getSession();
		Connection conn = null;
		String navigationURL = request.getParameter("Navigation");
		request.setAttribute("DbConnectionIssue", null);
		if (null != request.getParameter("Logout"))
		{
			Helper.invalidateSession(session);
			session.invalidate();
			RequestDispatcher dispatcher = request.getRequestDispatcher("/homePage.jsp");
			dispatcher.forward(request, response);
		}
		else if (null != request.getParameter("FilterSubmitButton"))
		{
			METHOD_NAME = "FilterSubmitButton";
			session.setAttribute("databaseUpdatedFlag", "false");
			request.setAttribute("accountDetailsSingleList", "");
			request.setAttribute("showValidationOrderDetails", null);
			request.setAttribute("showValidationAccountDetails", null);
			request.setAttribute("orderDetailsSingleList", "");
			String[] selectedCatagoryList = request.getParameterValues("category");
			if (selectedCatagoryList != null)
			{
				ArrayList<Attribute> categoryList = new ArrayList<Attribute>();
				Attribute attribute = null;
				for (int i = 0; i < selectedCatagoryList.length; i++)
				{
					attribute = new Attribute();
					String[] split = selectedCatagoryList[i].split(CommonConstants.SEMI_COLON);
					for (int k = 0; k < split.length; k++)
					{
						if (k == 0)
						{
							attribute.setAttributeName(split[k]);
						}
						else if (k == 1)
						{
							attribute.setAttributeType(split[k]);
						}
						else if (k == 2)
						{
							attribute.setSubAttributes(split[k]);
							if (attribute.getSubAttributes() != null && !attribute.getSubAttributes().equalsIgnoreCase(CommonConstants.EMPTY_STRING))
							{
								attribute.setSubAttributesList(new ArrayList<String>());
								StringTokenizer st = new StringTokenizer(attribute.getSubAttributes(), CommonConstants.COMMA);
								while (st.hasMoreTokens())
								{
									StringBuilder stt = new StringBuilder();
									String stk = st.nextToken();
									if (stk.contains(CommonConstants.OPENING_BRACKET))
									{
										stt.append(stk.replace(CommonConstants.OPENING_BRACKET, CommonConstants.EMPTY_STRING));
									}
									else if (stk.contains(CommonConstants.CLOSING_BRACKET))
									{
										stt.append(stk.replace(CommonConstants.CLOSING_BRACKET, CommonConstants.EMPTY_STRING));
									}
									else
									{
										stt.append(stk);
									}
									attribute.getSubAttributesList().add(stt.toString());
								}
							}
						}
						else if (k == 3)
						{
							attribute.setTableColumnName(split[k]);
						}
					}
					categoryList.add(attribute);
				}
				request.setAttribute("Navigation", "Filter");
				session.setAttribute("searchFieldsList", null);
				session.setAttribute("accountDetailsList", null);
				session.setAttribute("categoryList", categoryList);
				RequestDispatcher dispatcher = request.getRequestDispatcher("/DynamicFilterSection.jsp");
				dispatcher.forward(request, response);
			}
		}
		else if (null != request.getParameter("searchFilterButton"))
		{
			METHOD_NAME = "searchFilterButton";
			session.setAttribute("databaseUpdatedFlag", "false");
			request.setAttribute("accountDetailsSingleList", "");
			request.setAttribute("showValidationOrderDetails", null);
			request.setAttribute("showValidationAccountDetails", null);
			request.setAttribute("orderDetailsSingleList", "");

			try
			{
				ArrayList<Attribute> cateogoryListNew = new ArrayList<Attribute>();
				ArrayList<String> searchFieldsList = new ArrayList<String>();
				String query = "Select * from " + Authentication.dbconfig.getTableName() + " where RESERVED_TC_NO is null and ";
				boolean insertAnd = false;
				ArrayList<Attribute> attributeLst = (ArrayList<Attribute>) session.getAttribute("categoryList");
				String rowNum = request.getParameter("noOfRecords");
				for (Attribute atr : attributeLst)
				{
					String[] userInputValues = request.getParameterValues(atr.getAttributeName());
					String firstValue = null;
					String secondvalue = null;
					String formattedfirstValue = null;
					if (userInputValues.length == 1)
					{
						firstValue = userInputValues[0].trim();
						if (firstValue.contains("-"))
						{
							Date date = Helper.convertToDate(firstValue, "yyyy-MM-dd");
							formattedfirstValue = Helper.formatDate(date, "dd-MMM-yyyy").toUpperCase();
						}
						if (formattedfirstValue != null)
						{
							atr.setSecondInputValue(formattedfirstValue);
						}
						else
						{
							atr.setSecondInputValue(firstValue);
						}
						atr.setValueBeingUsed(true);
						if (insertAnd)
						{
							query = query + " and " + atr.getTableColumnName() + "= '" + atr.getSecondInputValue() + "'";
						}
						else
						{
							query = query + atr.getTableColumnName() + "= '" + atr.getSecondInputValue() + "'";
							insertAnd = true;
						}
						atr.setSecondInputValue(firstValue);
					}
					else if (userInputValues.length > 1)
					{
						firstValue = userInputValues[0].trim();
						secondvalue = userInputValues[1].trim();
						atr.setFirstInputValue(firstValue);
						atr.setSecondInputValue(secondvalue);
						atr.setValueBeingUsed(true);
						if (insertAnd)
						{
							query = query + " and " + atr.getTableColumnName() + " between '" + atr.getFirstInputValue() + "' and '" + atr.getSecondInputValue() + "'";

						}
						else
						{
							query = query + atr.getTableColumnName() + " between '" + atr.getFirstInputValue() + "' and '" + atr.getSecondInputValue() + "'";
							insertAnd = true;
						}
					}
					searchFieldsList.add(atr.getAttributeName());
					cateogoryListNew.add(atr);
				}
				query = query + " and rownum <= " + rowNum;
				LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, query, null);
				session.setAttribute("categoryList", cateogoryListNew);
				conn = DatabaseConnection.getDBConnection(Authentication.dbconfig);
				MessageDetails = "";
				totalNumberOfRecords = 0;
				accountDetailsList = searchAccountDetails(conn, query);
				if (totalNumberOfRecords == 0)
				{
					MessageDetails = "No records found for the search criteria.";
				}
				else
				{
					MessageDetails = "";
				}
				request.setAttribute("Navigation", "Filter");
				session.setAttribute("searchFieldsList", searchFieldsList);
				session.setAttribute("accountDetailsList", accountDetailsList);
				session.setAttribute("totalNumberOfRecords", totalNumberOfRecords);
				session.setAttribute("databaseUpdatedFlag", "false");
				request.setAttribute("MessageDetails", MessageDetails);
				RequestDispatcher dispatcher = request.getRequestDispatcher("/DynamicFilterSection.jsp");
				dispatcher.forward(request, response);
			}
			catch (Exception e)
			{
				LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
				throw new ServletException("Error in retrieving data(SeachAccountDetails class)" + e.getMessage());
			}
			finally
			{
				try
				{
					if (conn != null)
						conn.close();
				}
				catch (SQLException e)
				{
					LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
					e.printStackTrace();
				}
			}

		}
		else if (null != request.getParameter("ProvisionButton") && null != request.getParameter("accountSelected") && !request.getParameter("accountSelected").isEmpty())
		{
			METHOD_NAME = "ProvisionButton accountSelected";
			request.setAttribute("accountDetailsSingleList", "");
			request.setAttribute("showValidationOrderDetails", null);
			request.setAttribute("showValidationAccountDetails", null);
			request.setAttribute("orderDetailsSingleList", "");
			try
			{
				MessageDetails = "";
				String selectedCheckBoxes = request.getParameter("accountSelected");
				String accountNumberSelected = "";
				String testCaseNumber = "";
				String phase = "";
				String bpa;
				String[] selectedCheckBoxArray = selectedCheckBoxes.split(",");
				conn = DatabaseConnection.getDBConnection(Authentication.dbconfig);
				String query = "";
				int testNo;
				int ind;
				int row = 0;
				totalNumberOfRecords = 0;

				for (int i = 0; i < selectedCheckBoxArray.length; i++)
				{
					int index = Integer.parseInt(selectedCheckBoxArray[i]);
					AccountDetails accObj = accountDetailsList.get(index);
					accountNumberSelected = accObj.getAccountNumber();
					ind = index;
					testCaseNumber = request.getParameter("TestCaseId" + ind);
					phase = request.getParameter("Phase" + ind);
					bpa = request.getParameter("BPA" + ind);
					testNo = Integer.parseInt(testCaseNumber);
					boolean isAccountNumberReserved = false;
					isAccountNumberReserved = checkAccountNumberStatus(conn, accountNumberSelected);
					if (!isAccountNumberReserved)
					{
						query = "Update " + Authentication.dbconfig.getTableName()
								+ " set RESERVED_TC_NO=?, RESERVED_BY=?, RESERVED_DATE=?, RESERVED_BPA=?,RESERVED_FDT_PHASE=? where ACCOUNT_NUMBER=?";
						LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, query, null);
						row = updateTableStatus(conn, query, accountNumberSelected, testNo, row, bpa, phase, request);
						MessageDetails = "Database updated successfully. Impacted row count in database: " + row;
					}
					else
					{
						MessageDetails = "Database updated is not update as this has been already reserved";
					}
				}

				request.setAttribute("MessageDetails", MessageDetails);

				if (navigationURL != null && navigationURL.equalsIgnoreCase("Filter"))
				{

					session.setAttribute("databaseUpdatedFlag", "true");
					request.setAttribute("MessageDetails", MessageDetails);
					request.setAttribute("Navigation", "Filter");
					session.getAttribute("categoryList");
					RequestDispatcher dispatcher = request.getRequestDispatcher("/DynamicFilterSection.jsp");
					dispatcher.forward(request, response);
				}
				else if (navigationURL != null && navigationURL.equalsIgnoreCase("Search"))
				{
					request.setAttribute("Navigation", "Search");
					searchSubmitButton(request, conn, session, accountNumberList);
					RequestDispatcher dispatcher = request.getRequestDispatcher("/AccountSearchSection.jsp");
					dispatcher.forward(request, response);
				}
			}
			catch (Exception e)
			{
				LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
				MessageDetails = "Error in updating the database" + e.getMessage();
			}
		}
		else if (null != request.getParameter("SearchSubmitButton"))
		{
			METHOD_NAME = "SearchSubmitButton";
			request.setAttribute("accountDetailsSingleList", "");
			request.setAttribute("showValidationOrderDetails", null);
			request.setAttribute("showValidationAccountDetails", null);
			request.setAttribute("orderDetailsSingleList", "");
			accountNumberList = new ArrayList<AccountDetails>();
			String accountNumbers = request.getParameter("AccountNumberText");
			StringTokenizer stringtokenizer = new StringTokenizer(accountNumbers, CommonConstants.SEMI_COLON);
			while (stringtokenizer.hasMoreTokens())
			{
				AccountDetails accDetail = new AccountDetails();
				
				String accountNum = stringtokenizer.nextToken().replaceAll("\r\n", "");
				accDetail.setAccountNumber(accountNum);
				accountNumberList.add(accDetail);
			}
			searchSubmitButton(request, conn, session, accountNumberList);
			RequestDispatcher dispatcher = request.getRequestDispatcher("/AccountSearchSection.jsp");
			dispatcher.forward(request, response);

		}
		else if (request.getParameter("BackButton") != null)
		{
			METHOD_NAME = "BackButton";
			request.setAttribute("accountDetailsSingleList", "");
			request.setAttribute("showValidationOrderDetails", null);
			request.setAttribute("showValidationAccountDetails", null);
			request.setAttribute("orderDetailsSingleList", "");
			Document doc = (Document) session.getAttribute("doc");
			Authentication userHome = new Authentication();
			Authentication.attributeList = userHome.fetchAttributeList(doc);
			session.setAttribute("listCategory", Authentication.attributeList);
			RequestDispatcher dispatcher = request.getRequestDispatcher("/UserOptions.jsp");
			dispatcher.forward(request, response);
		}
		else if (request.getParameter("DetailedView") != null)
		{
			METHOD_NAME = "BackButton";
			try
			{
				request.setAttribute("accountDetailsSingleList", "");
				request.setAttribute("showValidationOrderDetails", null);
				request.setAttribute("showValidationAccountDetails", null);
				request.setAttribute("orderDetailsSingleList", "");
				String accountNumber = request.getParameter("DetailedView");
				if (accountNumber == null)
				{
					accountNumber = (String) session.getAttribute("DetailedView");
				}
				String query = "Select * from " + Authentication.dbconfig.getTableName() + " where account_number = ";
				query = query + "'" + accountNumber.trim() + "'";
				LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, query, null);
				conn = DatabaseConnection.getDBConnection(Authentication.dbconfig);
				MessageDetails = "";
				totalNumberOfRecords = 0;
				ArrayList<ColumnsDisplayed> AllColumnsDisplay = new ArrayList<ColumnsDisplayed>();
				AllColumnsDisplay = fetchAccountDetails(conn, query);
				request.setAttribute("AllColumnsDisplay", AllColumnsDisplay);

				if (navigationURL != null && navigationURL.equalsIgnoreCase("Filter"))
				{
					request.setAttribute("Navigation", "Filter");
					RequestDispatcher dispatcher = request.getRequestDispatcher("/DynamicFilterSection.jsp");
					dispatcher.forward(request, response);
				}
				else if (navigationURL != null && navigationURL.equalsIgnoreCase("Search"))
				{
					request.setAttribute("Navigation", "Search");
					RequestDispatcher dispatcher = request.getRequestDispatcher("/AccountSearchSection.jsp");
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
				LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
			}

		}
		else if (null != request.getParameter("ValidationPoints"))
		{
			METHOD_NAME = "ValidationPoints";
			validationAccountList = null;
			validationOrderList = null;

			String accountNumber = request.getParameter("OpenValidationPoints");
			accountNumber = accountNumber.toUpperCase();
			request.setAttribute("accountDetailsSingleList", "");
			request.setAttribute("showValidationOrderDetails", null);
			request.setAttribute("showValidationAccountDetails", null);
			request.setAttribute("orderDetailsSingleList", "");

			try
			{
				listFilesForFolder(null, request, response, accountNumber, "submit");
				if (validationAccountList != null && !validationAccountList.isEmpty())
				{
					for (ValidationPointAttributeAccount componentObj : validationAccountList)
					{
						componentObj.setPreviousValue(Helper.fetchPreviousValue(validationPreviousList, componentObj.getAttributeComponent()));
					}
				}
				if (validationOrderList != null && !validationOrderList.isEmpty())
				{
					for (ValidationPointAttributeOrder componentObj : validationOrderList)
					{
						componentObj.setPreviousValue(Helper.fetchPreviousValue(validationPreviousList, componentObj.getAttributeComponent()));
					}
				}
				if (null == errorMessage)
				{
					request.setAttribute("accountDetailsSingleList", validationAccountList);
					session.setAttribute("accList", validationAccountList);
					if (validationAccountList != null && !validationAccountList.isEmpty())
					{
						request.setAttribute("ValidationDisplay", "display");
						request.setAttribute("showValidationAccountDetails", "true");
					}

					request.setAttribute("orderDetailsSingleList", validationOrderList);
					session.setAttribute("orList", validationOrderList);
					if (validationOrderList != null && !validationOrderList.isEmpty())
					{
						request.setAttribute("ValidationDisplay", "display");
						request.setAttribute("showValidationOrderDetails", "true");
					}
				}
				request.setAttribute("errorMessage", errorMessage);
			}
			catch (SQLException e)
			{
				LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
				request.setAttribute("errorMessage", errorMessage);
			}
			catch (Exception e)
			{
				LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
			}
			if (navigationURL != null && navigationURL.equalsIgnoreCase("Filter"))
			{
				request.setAttribute("Navigation", "Filter");
				RequestDispatcher dispatcher = request.getRequestDispatcher("/DynamicFilterSection.jsp");
				dispatcher.forward(request, response);
			}
			else if (navigationURL != null && navigationURL.equalsIgnoreCase("Search"))
			{
				request.setAttribute("Navigation", "Search");
				RequestDispatcher dispatcher = request.getRequestDispatcher("/AccountSearchSection.jsp");
				dispatcher.forward(request, response);
			}

		}
		else if (request.getParameter("update") != null)
		{
			METHOD_NAME = "Update";
			validationAccountList = null;
			validationOrderList = null;
			String accountNumber = request.getParameter("Account Number");

			if (accountNumber == null)
			{
				accountNumber = (String) session.getAttribute("accountNumber");
			}
			try
			{
				listFilesForFolder(null, request, response, accountNumber, "update");
			}
			catch (Exception e)
			{
				LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
			}
		}
	}


	private boolean checkAccountNumberStatus(Connection conn, String accountNumberSelected) throws SQLException
	{
		boolean flag = false;
		String query = "select RESERVED_BY from " + Authentication.dbconfig.getTableName() + " where ACCOUNT_NUMBER=?";
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		pstmt = conn.prepareStatement(query);
		pstmt.setString(1, accountNumberSelected);
		rs = pstmt.executeQuery();
		while (rs.next())
		{
			if (null != rs.getString("RESERVED_BY"))
			{
				flag = true;
			}
		}
		return flag;
	}

	private ArrayList<ColumnsDisplayed> fetchAccountDetails(Connection conn, String query) throws SQLException
	{
		final String METHOD_NAME = "fetchAccountDetails";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		totalNumberOfRecords = 0;
		ArrayList<ColumnsDisplayed> columnsDisplayedList = new ArrayList<ColumnsDisplayed>();
		ColumnsDisplayed columnsDisplay = null;
		try
		{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData resultSet = rs.getMetaData();
			while (rs.next())
			{

				for (int i = 1; i <= resultSet.getColumnCount(); i++)
				{
					try
					{
						columnsDisplay = new ColumnsDisplayed();
						String obj = findResultSet(rs, resultSet, i);
						columnsDisplay.setColumnName(resultSet.getColumnName(i));
						columnsDisplay.setColumnType(obj);
						columnsDisplayedList.add(columnsDisplay);
					}
					catch (Exception e)
					{
						LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
					}
				}
			}

		}
		catch (Exception e)
		{
			LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
			MessageDetails = "Error in retrieving the values from the database." + e.getMessage();
		}
		finally
		{
			if (null != rs)
			{
				rs.close();
			}
			if (null != pstmt)
			{
				pstmt.close();
			}
		}
		return columnsDisplayedList;

	}

	private void searchSubmitButton(HttpServletRequest request, Connection conn, HttpSession session, ArrayList<AccountDetails> accountNumberList)
	{
		final String METHOD_NAME = "searchSubmitButton";
		try
		{
			String query = "Select * from " + Authentication.dbconfig.getTableName() + " where account_number in (";
			NumberOfAccountsSearched = 0;
			for (AccountDetails atr : accountNumberList)
			{
				query = query + "'" + atr.getAccountNumber() + "',";
			}
			query = query.substring(0, query.length() - 1);
			query = query + ") or agr_code in (";
			
			for (AccountDetails atr : accountNumberList)
			{
				query = query + "'" + atr.getAccountNumber() + "',";
			}
			NumberOfAccountsSearched = accountNumberList.size();
			query = query.substring(0, query.length() - 1);
			query = query + ")";
			LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, query, null);
			conn = DatabaseConnection.getDBConnection(Authentication.dbconfig);

			accountDetailsList = searchAccountDetails(conn, query);

			if (totalNumberOfRecords == 0)
			{
				MessageDetails = "No records found for the search criteria.";
			}
			else
			{
				MessageDetails = "";
			}
			for (AccountDetails accountNumberDetails : accountNumberList)
			{
				for (AccountDetails accDetails : accountDetailsList)
				{
					if ((accDetails.getAccountNumber().equalsIgnoreCase(accountNumberDetails.getAccountNumber()))
							|| (accDetails.getAgrCode().equalsIgnoreCase(accountNumberDetails.getAccountNumber())))
					{
						accountNumberDetails.setColor("Black");
					}
				}
			}
			request.setAttribute("Navigation", "Search");
			session.setAttribute("accountNumberList", accountNumberList);
			session.setAttribute("accountDetailsList", accountDetailsList);
			session.setAttribute("totalNumberOfRecords", totalNumberOfRecords);
			session.setAttribute("NumberOfAccountsSearched", NumberOfAccountsSearched);
			session.setAttribute("databaseUpdatedFlag", "false");
			request.setAttribute("MessageDetails", MessageDetails);
		}
		catch (SQLException e)
		{
			LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
			request.setAttribute("DbConnectionIssue", e.getMessage());
		}

	}

	// Method to perform the account search and store the values in a list
	public ArrayList<AccountDetails> searchAccountDetails(Connection conn, String query) throws SQLException
	{
		final String METHOD_NAME = "searchAccountDetails";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		totalNumberOfRecords = 0;
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
				if(accountDetails.getBPA() ==  null || (accountDetails.getBPA() != null && !accountDetails.getBPA().contains("DO NOT USE")))
				{
					totalNumberOfRecords++;
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

	private static int updateTableStatus(Connection conn, String query, String accountNumber, int testCaseNumber, int row, String bpa, String phase, HttpServletRequest request) throws Exception
	{
		PreparedStatement pstmt = null;
		Date date = new Date();
		java.sql.Date dateSql = new java.sql.Date(date.getTime());
		pstmt = conn.prepareStatement(query);
		pstmt.setInt(1, testCaseNumber);
		String userId = (String) request.getSession().getAttribute("userId");

		pstmt.setString(2, userId.toUpperCase());

		pstmt.setDate(3, dateSql);
		pstmt.setString(4, bpa);
		pstmt.setString(5, phase);
		pstmt.setString(6, accountNumber);

		row = row + pstmt.executeUpdate();
		pstmt.close();
		return row;
	}

	public String getErrorMessage()
	{
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage)
	{
		this.errorMessage = errorMessage;
	}

	private static String findResultSet(ResultSet rs, ResultSetMetaData resultSet, int columnType) throws SQLException
	{
		Object returnValue = null;
		if (resultSet.getColumnType(columnType) == 2 || resultSet.getColumnType(columnType) == 3 || resultSet.getColumnType(columnType) == 8)
		{
			returnValue = rs.getBigDecimal(resultSet.getColumnName(columnType));
		}
		else if (resultSet.getColumnType(columnType) == 4)
		{
		}
		else if (resultSet.getColumnType(columnType) == 12)
		{
			returnValue = rs.getString(resultSet.getColumnName(columnType));
		}
		else if (resultSet.getColumnType(columnType) == 91)
		{
		}
		else if (resultSet.getColumnType(columnType) == 92)
		{
		}
		else if (resultSet.getColumnType(columnType) == 93)
		{
			returnValue = rs.getDate(resultSet.getColumnName(columnType));
			returnValue = Helper.formatDate(returnValue, "yyyy-MM-dd");

		}
		if (returnValue != null)
		{
			return returnValue.toString();
		}
		else
		{
			return null;
		}

	}

	private void listFilesForFolder(String userInput, HttpServletRequest request, HttpServletResponse response, String accountNumber, String button) throws Exception
	{
		final String METHOD_NAME = "listFilesForFolder";
		DatabaseConfiguration dbConfig = null;
		Connection connDP = null;
		Connection connSP = null;
		Connection connCIM = null;
		Connection connCAM = null;
		Connection connFinnancier = null;
		String message = null;
		try
		{
			HttpSession session = request.getSession();
			Document doc = (Document) session.getAttribute("doc");
			StringBuilder errorMsg = new StringBuilder();

			try
			{
				dbConfig = new DatabaseConfiguration();
				dbConfig = Helper.fetchDBConnectionDetails(doc, "SPDatabaseConfiguration", session);
				connSP = DatabaseConnection.getDBConnection(dbConfig);
				if (connSP == null)
				{
					errorMsg = new StringBuilder();
					message = CommonConstants.DATABASE_CONNECTION_FAILURE;
					errorMsg.append(message.replace(CommonConstants.PLACEHOLDER, CommonConstants.SP));
					errorMsg.append(message.replace(CommonConstants.INVALID_CREDENTIALS, CommonConstants.SP));
					errorMessage = errorMsg.toString();
				}
			}
			catch (Exception e)
			{
				LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage() + " - SP ", e);
				errorMsg = new StringBuilder();
				message = CommonConstants.DATABASE_CONNECTION_FAILURE;
				errorMsg.append(message.replace(CommonConstants.PLACEHOLDER, CommonConstants.SP));
				errorMsg.append(message.replace(CommonConstants.INVALID_CREDENTIALS, CommonConstants.SP));
				errorMessage = errorMsg.toString();
			}
			try
			{
				dbConfig = new DatabaseConfiguration();
				dbConfig = Helper.fetchDBConnectionDetails(doc, "CAMDatabaseConfiguration",session);
				connCAM = DatabaseConnection.getDBConnection(dbConfig);
				if (connCAM == null)
				{
					errorMsg = new StringBuilder();
					message = CommonConstants.DATABASE_CONNECTION_FAILURE;
					errorMsg.append(message.replace(CommonConstants.PLACEHOLDER, CommonConstants.CAM));
					errorMsg.append(message.replace(CommonConstants.INVALID_CREDENTIALS, CommonConstants.CAM));
					errorMessage = errorMsg.toString();
				}
			}
			catch (Exception e)
			{
				LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage() + " - CAM ", e);
				errorMsg = new StringBuilder();
				message = CommonConstants.DATABASE_CONNECTION_FAILURE;
				errorMsg.append(message.replace(CommonConstants.PLACEHOLDER, CommonConstants.CAM));
				errorMsg.append(message.replace(CommonConstants.INVALID_CREDENTIALS, CommonConstants.CAM));
				errorMessage = errorMsg.toString();
			}

			try
			{
				dbConfig = new DatabaseConfiguration();
				dbConfig = Helper.fetchDBConnectionDetails(doc, "FinancierDatabaseConfiguration",session);
				connFinnancier = DatabaseConnection.getDBConnection(dbConfig);
				if (null == connFinnancier)
				{
					errorMsg = new StringBuilder();
					message = CommonConstants.DATABASE_CONNECTION_FAILURE;
					errorMsg.append(message.replace(CommonConstants.PLACEHOLDER, CommonConstants.FINANCIER));
					errorMsg.append(message.replace(CommonConstants.INVALID_CREDENTIALS, CommonConstants.FINANCIER));
					errorMessage = errorMsg.toString();
				}
			}
			catch (Exception e)
			{
				LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage() + " - FINANCIER ", e);
				errorMsg = new StringBuilder();
				message = CommonConstants.DATABASE_CONNECTION_FAILURE;
				errorMsg.append(message.replace(CommonConstants.PLACEHOLDER, CommonConstants.FINANCIER));
				errorMsg.append(message.replace(CommonConstants.INVALID_CREDENTIALS, CommonConstants.FINANCIER));
				errorMessage = errorMsg.toString();
			}

			try
			{
				dbConfig = new DatabaseConfiguration();
				dbConfig = Helper.fetchDBConnectionDetails(doc, "CIMDatabaseConfiguration",session);
				connCIM = DatabaseConnection.getDBConnection(dbConfig);
				if (null == connCIM)
				{
					errorMsg = new StringBuilder();
					message = CommonConstants.DATABASE_CONNECTION_FAILURE;
					errorMsg.append(message.replace(CommonConstants.PLACEHOLDER, CommonConstants.CIM));
					errorMsg.append(message.replace(CommonConstants.INVALID_CREDENTIALS, CommonConstants.CIM));
					errorMessage = errorMsg.toString();
				}
			}
			catch (Exception e)
			{
				LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage() + " - CIM ", e);
				errorMsg = new StringBuilder();
				message = CommonConstants.DATABASE_CONNECTION_FAILURE;
				errorMsg.append(message.replace(CommonConstants.PLACEHOLDER, CommonConstants.CIM));
				errorMsg.append(message.replace(CommonConstants.INVALID_CREDENTIALS, CommonConstants.CIM));
				errorMessage = errorMsg.toString();
			}

			try
			{
				dbConfig = new DatabaseConfiguration();
				dbConfig = Helper.fetchDBConnectionDetails(doc, "ProvisionalDatabaseConfiguration",session);
				connDP = DatabaseConnection.getDBConnection(dbConfig);
				if (null == connDP)
				{
					errorMsg = new StringBuilder();
					message = CommonConstants.DATABASE_CONNECTION_FAILURE;
					errorMsg.append(message.replace(CommonConstants.PLACEHOLDER, CommonConstants.DP));
					errorMsg.append(message.replace(CommonConstants.INVALID_CREDENTIALS, CommonConstants.DP));
					errorMessage = errorMsg.toString();
				}
			}
			catch (Exception e)
			{
				LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage() + " - DP ", e);
				errorMsg = new StringBuilder();
				message = CommonConstants.DATABASE_CONNECTION_FAILURE;
				errorMsg.append(message.replace(CommonConstants.PLACEHOLDER, CommonConstants.DP));
				errorMsg.append(message.replace(CommonConstants.INVALID_CREDENTIALS, CommonConstants.DP));
				errorMessage = errorMsg.toString();
			}

			if (errorMessage == null && button.equalsIgnoreCase("Submit"))
			{
				String financierAgreementCode = DatabaseService.fetchAgreementCodeFromSP(accountNumber, connCIM, connFinnancier, null);
				validationPreviousList = DatabaseService.fetchPreviousValues(connDP, accountNumber);
				validationAccountList = DatabaseService.fetchAccountValuesFromDB(connFinnancier, connCIM, connCAM, accountNumber, financierAgreementCode, null, doc);
				validationOrderList = DatabaseService.fetchOrderValuesFromDB(connSP, connFinnancier, connCIM, connCAM, accountNumber, financierAgreementCode, null, doc);
			}
			else if (errorMessage == null && button.equalsIgnoreCase("update"))
			{

				ArrayList<ValidationPointAttributeAccount> accList = (ArrayList<ValidationPointAttributeAccount>) request.getSession().getAttribute("accList");
				ArrayList<ValidationPointAttributeOrder> orList = (ArrayList<ValidationPointAttributeOrder>) request.getSession().getAttribute("orList");
				DatabaseService.insertValuesInDB(connDP, accList, orList, accountNumber);
			}
		}
		catch (Exception e)
		{
			LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
		}

		finally
		{
			if (null != connSP)
			{
				connSP.close();
			}
			if (null != connFinnancier)
			{
				connFinnancier.close();
			}
			if (null != connCIM)
			{
				connCIM.close();
			}
			if (null != connCAM)
			{
				connCAM.close();
			}
			if (null != connDP)
			{
				connDP.close();
			}
		}
	}
}