package validationPoint;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import common.ColumnsDisplayed;
import common.Helper;
import common.QueryConstants;
import logging.LogHelper;

public class DatabaseService
{

	public static ArrayList<ValidationPointAttributeAccount> fetchAccountValuesFromDB(Connection connFinnancier, Connection connCIM, Connection connCAM, String accountNumber, String agr_code,
			String userInput, Document doc) throws SQLException
	{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ValidationPointAttributeAccount validationPointAttribute = null;
		ArrayList<ValidationPointAttributeAccount> validationPointAttributeList = new ArrayList<ValidationPointAttributeAccount>();
		try
		{
			Connection conn = null;
			ArrayList<ColumnsDisplayed> columnsToDisplayList = fetchColumnToDisplayList(doc, "AccountDisplayList");

			for (ColumnsDisplayed col : columnsToDisplayList)
			{
				validationPointAttribute = new ValidationPointAttributeAccount();
				String query = col.getColumnName();
				String[] attributes = col.getColumnType().split("_");
				validationPointAttribute.setComponent(attributes[1]);
				validationPointAttribute.setAttributeName(attributes[0]);
				validationPointAttribute.setAttributeComponent(attributes[0] + " " + attributes[1]);
				conn = getConnectionName(attributes[1], connFinnancier, connCIM, connCAM);
				LogHelper.error("validationPoint", "DatabaseService", "fetchAccountValuesFromDB", query, null);
				pstmt = conn.prepareStatement(query.toString());
				if (attributes[1].equalsIgnoreCase("Financier"))
				{
					pstmt.setString(1, agr_code);
				}
				else
				{
					pstmt.setString(1, accountNumber);
				}
				rs = pstmt.executeQuery();
				ResultSetMetaData resultSet = rs.getMetaData();
				while (rs.next())
				{
					for (int i = 1; i <= resultSet.getColumnCount(); i++)
					{
						try
						{
							String obj = findResultSet(rs, resultSet, i);
							validationPointAttribute.setNewValue(obj);
						}
						catch (Exception e)
						{
							validationPointAttribute.setNewValue("Error while retrieving value from DB");
						}
					}
				}
				validationPointAttributeList.add(validationPointAttribute);

			}

		}
		catch (Exception e)
		{
			System.out.println(e.getMessage());
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

		return validationPointAttributeList;
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

	private static Connection getConnectionName(String attributeName, Connection connFinnancier, Connection connCIM, Connection connCAM)
	{
		Connection conn = null;
		if (attributeName.equalsIgnoreCase("Financier"))
		{
			conn = connFinnancier;
		}
		else if (attributeName.equalsIgnoreCase("CIM"))
		{
			conn = connCIM;
		}
		if (attributeName.equalsIgnoreCase("CAM"))
		{
			conn = connCAM;
		}

		return conn;

	}

	public static ArrayList<ValidationPointAttributeOrder> fetchOrderValuesFromDB(Connection connSP, Connection connFinnancier, Connection connCIM, Connection connCAM, String accountNumber,
			String agr_code, String userInput, Document doc) throws SQLException
	{

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ValidationPointAttributeOrder validationPointAttribute = null;
		ArrayList<ValidationPointAttributeOrder> validationPointAttributeList = new ArrayList<ValidationPointAttributeOrder>();
		try
		{
			Connection conn = null;
			ArrayList<ColumnsDisplayed> columnsToDisplayList = fetchColumnToDisplayList(doc, "OrderDisplayList");

			for (ColumnsDisplayed col : columnsToDisplayList)
			{
				validationPointAttribute = new ValidationPointAttributeOrder();
				String query = col.getColumnName();
				String[] attributes = col.getColumnType().split("_");
				validationPointAttribute.setComponent(attributes[1]);
				validationPointAttribute.setAttributeName(attributes[0]);
				validationPointAttribute.setAttributeComponent(attributes[0] + " " + attributes[1]);
				conn = getConnectionName(attributes[1], connFinnancier, connCIM, connCAM);
				
				pstmt = conn.prepareStatement(query.toString());
				if (attributes[1].equalsIgnoreCase("Financier"))
				{
					pstmt.setString(1, agr_code);
				}
				else
				{
					pstmt.setString(1, accountNumber);
				}
				rs = pstmt.executeQuery();
				ResultSetMetaData resultSet = rs.getMetaData();
				while (rs.next())
				{
					for (int i = 1; i <= resultSet.getColumnCount(); i++)
					{
						try
						{
							String obj = findResultSet(rs, resultSet, i);
							validationPointAttribute.setNewValue(obj);
						}
						catch (Exception e)
						{
							validationPointAttribute.setNewValue("Error while retrieving value from DB");
						}
					}
				}
				validationPointAttributeList.add(validationPointAttribute);

			}

		}
		catch (Exception e)
		{
			System.out.println(e.getMessage());
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

		return validationPointAttributeList;

	}

	public static HashMap<String, String> fetchPreviousValues(Connection connDP, String accountNumber) throws SQLException
	{

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ResultSetMetaData resultSetMetaData = null;
		int count = 0;
		HashMap<String, String> map = new HashMap<String, String>();
		try
		{
			String query = QueryConstants.PREVIOUS_VALUES;
			pstmt = connDP.prepareStatement(query);
			pstmt.setString(1, accountNumber);
			rs = pstmt.executeQuery();
			resultSetMetaData = rs.getMetaData();
			while (rs.next())
			{
				if (count == 0)
				{
					int j = 1;
					for (int i = 0; i < resultSetMetaData.getColumnCount(); i++)
					{
						if (resultSetMetaData.getColumnName(j).equalsIgnoreCase("CIM_NEXT_STATEMENT_DATE"))
						{
							map.put("Next Statement Date CIM", Helper.formatDate(rs.getDate(j), "yyyy-MM-dd"));
						}
						if (resultSetMetaData.getColumnName(j).equalsIgnoreCase("FIN_NEXT_STATEMENT_DATE"))
						{
							map.put("Next Statement Date Financier", Helper.formatDate(rs.getDate(j), "yyyy-MM-dd"));
						}
						if (resultSetMetaData.getColumnName(j).equalsIgnoreCase("FIN_OPEN_TO_BUY"))
						{
							map.put("Open To Buy Financier", rs.getString(j));
						}
						if (resultSetMetaData.getColumnName(j).equalsIgnoreCase("CAM_BNPL_ELIGIBILITY_IND"))
						{
							map.put("BNPL Eligibility Ind CAM", rs.getString(j));
						}
						if (resultSetMetaData.getColumnName(j).equalsIgnoreCase("CIM_BNPL_ELIGIBILITY_IND"))
						{
							map.put("BNPL Eligibility CIM", rs.getString(j));
						}
						if (resultSetMetaData.getColumnName(j).equalsIgnoreCase("CIM_USER_PROFILE_NUMBER"))
						{
							map.put("User Profile Number CIM", rs.getString(j));
						}
						if (resultSetMetaData.getColumnName(j).equalsIgnoreCase("CIM_PAYMENT_DUE_DAY"))
						{
							map.put("Payment Due Day CIM", rs.getString(j));
						}
						if (resultSetMetaData.getColumnName(j).equalsIgnoreCase("FIN_PAYMENT_DUE_DATE"))
						{
							map.put("Payment Due Date Financier", Helper.formatDate(rs.getDate(j), "yyyy-MM-dd"));
						}
						if (resultSetMetaData.getColumnName(j).equalsIgnoreCase("CIM_POST_CODE"))
						{
							map.put("Post Code CIM", rs.getString(j));
						}
						if (resultSetMetaData.getColumnName(j).equalsIgnoreCase("CAM_BRAND"))
						{
							map.put("Principal Brand CAM", rs.getString(j));
						}
						if (resultSetMetaData.getColumnName(j).equalsIgnoreCase("CIM_ARREARS_INDICATOR"))
						{
							map.put("Arrears Indicator CIM", rs.getString(j));
						}
						if (resultSetMetaData.getColumnName(j).equalsIgnoreCase("FIN_ARREARS_INDICATOR"))
						{
							map.put("Arrears Indicator Financier", rs.getString(j));
						}
						if (resultSetMetaData.getColumnName(j).equalsIgnoreCase("CAM_ORDER_COUNT"))
						{
							map.put("Number of Orders CAM", rs.getString(j));
						}
						if (resultSetMetaData.getColumnName(j).equalsIgnoreCase("FIN_OVERALL_BALANCE"))
						{
							map.put("Overall Balance Financier", rs.getString(j));
						}
						if (resultSetMetaData.getColumnName(j).equalsIgnoreCase("FIN_OFFERS"))
						{
							map.put("Misc Financier", rs.getString(j));
						}
						if (resultSetMetaData.getColumnName(j).equalsIgnoreCase("FIN_APR"))
						{
							map.put("APR Financier", rs.getString(j));
						}
						j++;
					}
					count++;
				}
			}
		}
		catch (Exception e)
		{
			System.out.println("gone in error");
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
		return map;
	}

	public static void insertValuesInDB(Connection connDP, ArrayList<ValidationPointAttributeAccount> accList, ArrayList<ValidationPointAttributeOrder> orList, String accountNumber)
			throws SQLException, ParseException
	{
		try
		{
			PreparedStatement pstmt = null;
			String sql = QueryConstants.VALIDATION_POINT_INSERT;
			pstmt = connDP.prepareStatement(sql);
			pstmt.setString(1, accountNumber);
			pstmt.setDate(2, new java.sql.Date(System.currentTimeMillis()));
			for (ValidationPointAttributeAccount list : accList)
			{
				if (list.getAttributeComponent().equalsIgnoreCase("Next Statement Date CIM"))
				{
					if (null != list.getNewValue())
					{
						java.sql.Date dat = java.sql.Date.valueOf(list.getNewValue());
						pstmt.setDate(3, (java.sql.Date) dat);
					}
					else
					{
						pstmt.setDate(3, null);
					}
				}
				else if (list.getAttributeComponent().equalsIgnoreCase("Next Statement Date Financier"))
				{
					if (null != list.getNewValue())
					{
						java.sql.Date dat = java.sql.Date.valueOf(list.getNewValue());
						pstmt.setDate(4, (java.sql.Date) dat);
					}
					else
					{
						pstmt.setDate(4, null);
					}
				}
				else if (list.getAttributeComponent().equalsIgnoreCase("Open To Buy Financier"))
				{
					if (list.getNewValue() != null)
					{
						pstmt.setBigDecimal(5, new BigDecimal(list.getNewValue()));
					}
					else
					{
						pstmt.setBigDecimal(5, null);
					}
				}
				else if (list.getAttributeComponent().equalsIgnoreCase("BNPL Eligibility Ind CAM"))
				{
					if (list.getNewValue() != null)
					{
						pstmt.setBigDecimal(6, new BigDecimal(list.getNewValue()));
					}
					else
					{
						pstmt.setBigDecimal(6, null);
					}
				}
				else if (list.getAttributeComponent().equalsIgnoreCase("BNPL Eligibility CIM"))
				{
					if (list.getNewValue() != null)
					{
						pstmt.setBigDecimal(7, new BigDecimal(list.getNewValue()));
					}
					else
					{
						pstmt.setBigDecimal(7, null);
					}
				}
				else if (list.getAttributeComponent().equalsIgnoreCase("User Profile Number CIM"))
				{
					if (list.getNewValue() != null)
					{
						pstmt.setString(8, list.getNewValue());
					}
					else
					{
						pstmt.setString(8, null);
					}
				}
				else if (list.getAttributeComponent().equalsIgnoreCase("Payment Due Day CIM"))
				{
					if (list.getNewValue() != null)
					{
						pstmt.setBigDecimal(9, new BigDecimal(list.getNewValue()));
					}
					else
					{
						pstmt.setBigDecimal(9, null);
					}
				}
				else if (list.getAttributeComponent().equalsIgnoreCase("Payment Due Date Financier"))
				{
					if (list.getNewValue() != null)
					{
						java.sql.Date dat = java.sql.Date.valueOf(list.getNewValue());
						pstmt.setDate(10, (java.sql.Date) dat);
					}
					else
					{
						pstmt.setDate(10, null);
					}
				}
				else if (list.getAttributeComponent().equalsIgnoreCase("Post Code CIM"))
				{
					if (list.getNewValue() != null)
					{
						pstmt.setString(11, list.getNewValue());
					}
					else
					{
						pstmt.setString(11, null);
					}
				}
				else if (list.getAttributeComponent().equalsIgnoreCase("Principal Brand CAM"))
				{
					if (list.getNewValue() != null)
					{
						pstmt.setString(12, list.getNewValue());
					}
					else
					{
						pstmt.setString(12, null);
					}
				}
				else if (list.getAttributeComponent().equalsIgnoreCase("Arrears Indicator CIM"))
				{
					if (list.getNewValue() != null)
					{
						pstmt.setBigDecimal(13, new BigDecimal(list.getNewValue()));
					}
					else
					{
						pstmt.setBigDecimal(13, null);
					}
				}
				else if (list.getAttributeComponent().equalsIgnoreCase("Arrears Indicator Financier"))
				{
					if (list.getNewValue() != null)
					{
						pstmt.setBigDecimal(14, new BigDecimal(list.getNewValue()));
					}
					else
					{
						pstmt.setBigDecimal(14, null);
					}
				}

			}

			for (ValidationPointAttributeOrder list : orList)
			{

				if (list.getAttributeComponent().equalsIgnoreCase("Number of Orders CAM"))
				{
					if (null != list.getNewValue())
					{
						pstmt.setBigDecimal(15, new BigDecimal(list.getNewValue()));
					}
					else
					{
						pstmt.setBigDecimal(15, null);
					}
				}
				else if (list.getAttributeComponent().equalsIgnoreCase("Overall Balance Financier"))
				{
					if (null != list.getNewValue())
					{
						pstmt.setBigDecimal(16, new BigDecimal(list.getNewValue()));
					}
					else
					{
						pstmt.setBigDecimal(16, null);
					}
				}
				else if (list.getAttributeComponent().equalsIgnoreCase("Misc Financier"))
				{
					if (null != list.getNewValue())
					{
						pstmt.setString(17, list.getNewValue());
					}
					else
					{
						pstmt.setString(17, null);
					}
				}
				else if (list.getAttributeComponent().equalsIgnoreCase("APR Financier"))
				{
					if (null != list.getNewValue())
					{
						pstmt.setBigDecimal(18, new BigDecimal(list.getNewValue()));
					}
					else
					{
						pstmt.setBigDecimal(18, null);
					}
				}
			}
			pstmt.executeUpdate();
		}
		catch (Exception e)
		{
			System.out.println(e.getMessage());
		}
	}

	private static ArrayList<ColumnsDisplayed> fetchColumnToDisplayList(Document doc, String attributeName)
	{
		ArrayList<ColumnsDisplayed> columnsToDisplayList = null;
		ColumnsDisplayed columnDisplayed;
		NodeList nodeName = doc.getElementsByTagName(attributeName);
		columnsToDisplayList = new ArrayList<ColumnsDisplayed>();

		for (int i = 0; i < nodeName.getLength(); i++)
		{
			columnDisplayed = new ColumnsDisplayed();
			Element element = (Element) nodeName.item(i);
			columnDisplayed.setColumnName(Helper.getTagValue("Query", element));
			columnDisplayed.setColumnType(Helper.getTagValue("ComponentName", element));
			columnsToDisplayList.add(columnDisplayed);
		}
		return columnsToDisplayList;
	}
	
	public static String fetchAgreementCodeFromSP(String accountNumber, Connection connCIM, Connection connFinnancier, String userInput) throws SQLException
	{
		String financier_agreement_code = null;
		PreparedStatement pstmt;
		//StringBuilder creditAccountNumberQuery = new StringBuilder();
		String query = QueryConstants.AGR_CODE;
		//creditAccountNumberQuery.append(query.replace(CommonConstants.PLACEHOLDER, userInput));
		pstmt = connCIM.prepareStatement(query);
		pstmt.setString(1, accountNumber);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next())
		{
			financier_agreement_code = rs.getString("credit_account_number");
			break;
		}
		return financier_agreement_code;
	}
}