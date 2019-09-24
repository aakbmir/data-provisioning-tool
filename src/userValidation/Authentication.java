package userValidation;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import common.CommonConstants;
import common.DatabaseConfiguration;
import common.DatabaseConnection;
import common.Helper;
import logging.LogHelper;
import searchFilter.Attribute;

public class Authentication extends HttpServlet
{
	private static final long serialVersionUID = 1298354747863407644L;

	private static final String CLASS_NAME = "Authentication";

	private static final String PACKAGE_NAME = "userValidation";

	public static ArrayList<Attribute> attributeList = null;

	public static DatabaseConfiguration dbconfig = null;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, java.io.IOException
	{
		final String METHOD_NAME = "doPost";
		LogHelper.error("LogConfig", "LogConfig", "LogConfig", "LogConfig", null);
		HttpSession session = request.getSession();
		File attributeFile = lookUpAttributeFile();
		DocumentBuilder dBuilder = null;
		try
		{
			dBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();

			Document doc = dBuilder.parse(attributeFile);

			session.setAttribute("doc", doc);
			String userEnv = request.getParameter("env");
			session.setAttribute("userEnv", userEnv);
			dbconfig = Helper.fetchDBConnectionDetails(doc, CommonConstants.PROVISIONAL_DB,session);
			if (null != request.getParameter("SignIn"))
			{
				
				try
				{

					String signInUserName = request.getParameter(CommonConstants.SIGN_IN_USER_NAME);
					session.setAttribute("userId", signInUserName);
					if (validate(signInUserName))
					{
						attributeList = fetchAttributeList(doc);
						// columnsToDisplayList = fetchColumnToDiplayList(doc);
						session.setAttribute("listCategory", attributeList);
						RequestDispatcher dispatcher = request.getRequestDispatcher("/UserOptions.jsp");
						dispatcher.forward(request, response);
					}
					else
					{
						request.setAttribute("LoginErrorMsg", CommonConstants.LOGIN_FAILURE);
						RequestDispatcher dispatcher = request.getRequestDispatcher("/homePage.jsp");
						dispatcher.forward(request, response);
					}
				}
				
				catch (SQLException e)
				{
					LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
					request.setAttribute("LoginErrorMsg", e.getMessage());
					RequestDispatcher dispatcher = request.getRequestDispatcher("/homePage.jsp");
					dispatcher.forward(request, response);
				}
				catch (Exception e1)
				{
					LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e1.getMessage(), e1);
					request.setAttribute("LoginErrorMsg", e1.getMessage());
					RequestDispatcher dispatcher = request.getRequestDispatcher("/homePage.jsp");
					dispatcher.forward(request, response);
				}
			}
			else if (null != request.getParameter("forgotUsername"))
			{
				try
				{
					String firstName = request.getParameter("forgetfirstName");
					String lastName = request.getParameter("forgetlastName");
					String username = fetchUsername(firstName, lastName);
					if (username == null)
					{

						request.setAttribute("retrievedUsername", CommonConstants.USERNAME_NOT_FOUND);
						RequestDispatcher dispatcher = request.getRequestDispatcher("/homePage.jsp");
						dispatcher.forward(request, response);
					}
					else
					{
						request.setAttribute("LoginErrorMsg", "Your Username is : " + username);
						RequestDispatcher dispatcher = request.getRequestDispatcher("/homePage.jsp");
						dispatcher.forward(request, response);
					}
				}
				catch (SQLException e)
				{
					LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, CommonConstants.USERNAME_ERROR, e);
					request.setAttribute("LoginErrorMsg", CommonConstants.USERNAME_ERROR);
					RequestDispatcher dispatcher = request.getRequestDispatcher("/homePage.jsp");
					dispatcher.forward(request, response);
				}
				catch (Exception e)
				{
					LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, CommonConstants.USERNAME_ERROR, e);
					request.setAttribute("LoginErrorMsg", CommonConstants.USERNAME_ERROR);
					RequestDispatcher dispatcher = request.getRequestDispatcher("/homePage.jsp");
					dispatcher.forward(request, response);
				}

			}

		}
		catch (ParserConfigurationException e)
		{
			LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, CommonConstants.CONFIG_ISSUE, e);
			request.setAttribute("LoginErrorMsg", CommonConstants.CONFIG_ISSUE);
			RequestDispatcher dispatcher = request.getRequestDispatcher("/homePage.jsp");
			dispatcher.forward(request, response);
		}
		catch (SAXException e)
		{
			LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, CommonConstants.CONFIG_ISSUE, e);
			request.setAttribute("LoginErrorMsg", CommonConstants.CONFIG_ISSUE);
			RequestDispatcher dispatcher = request.getRequestDispatcher("/homePage.jsp");
			dispatcher.forward(request, response);
		}
	}

	private File lookUpAttributeFile()
	{
		File attributeFile =null;
		try
		{
			ServletContext ctx = getServletConfig().getServletContext();
			String propFile = ctx.getRealPath("/WEB-INF");
			attributeFile = new File(propFile, "/attributes.xml");
			boolean exists = attributeFile.exists();
			if(!exists)
			{
				attributeFile = new File(CommonConstants.ATTRIBUTE_FILE_NEWTEST,"/attributes.xml");
				exists = attributeFile.exists();
			}
		}
		catch(Exception e)
		{
			
		}
		return attributeFile;
	}

	private String fetchUsername(String firstName, String lastName) throws Exception
	{
		final String METHOD_NAME = "fetchUsername";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		String username = null;
		try
		{
			conn = DatabaseConnection.getDBConnection(dbconfig);
			String query = "Select * from " + Authentication.dbconfig.getAuthenticationTableName() + " where UPPER(FIRST_NAME) = ? and UPPER(LAST_NAME) = ?";
			LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, query, null);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, firstName.toUpperCase());
			pstmt.setString(2, lastName.toUpperCase());
			rs = pstmt.executeQuery();
			while (rs.next())
			{
				username = rs.getString("USER_ID");
			}
		}
		catch (SQLException e)
		{
			LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
			throw e;
		}
		catch (Exception e)
		{
			LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
			throw e;
		}
		finally
		{
			pstmt = null;
			rs = null;
			conn = null;
		}
		return username;

	}

	public ArrayList<Attribute> fetchAttributeList(Document doc)
	{
		NodeList nodeList = doc.getElementsByTagName("Attribute");
		List<Attribute> attributesList = new ArrayList<Attribute>();
		for (int i = 0; i < nodeList.getLength(); i++)
		{
			attributesList.add(getAttributes(doc, nodeList.item(i)));
		}
		if (attributesList != null && !attributesList.isEmpty())
		{
			attributeList = new ArrayList<Attribute>();
			for (int i = 0; i < attributesList.size(); i++)
			{
				attributeList.add(attributesList.get(i));
			}
		}
		return attributeList;
	}

	/*
	 * public ArrayList<ColumnsDisplayed> fetchColumnToDiplayList(Document doc)
	 * { ColumnsDisplayed columnDisplayed; NodeList nodeName =
	 * doc.getElementsByTagName("ColumnToDisplay"); columnsToDisplayList = new
	 * ArrayList<ColumnsDisplayed>(); for (int i = 0; i < nodeName.getLength();
	 * i++) { columnDisplayed = new ColumnsDisplayed(); Element element =
	 * (Element) nodeName.item(i);
	 * columnDisplayed.setColumnName(Helper.getTagValue("column-name",
	 * element));
	 * columnDisplayed.setColumnType(Helper.getTagValue("column-type",
	 * element)); columnsToDisplayList.add(columnDisplayed); } return
	 * columnsToDisplayList; }
	 */

	private static Attribute getAttributes(Document doc, Node node)
	{
		Attribute att = new Attribute();
		if (node.getNodeType() == Node.ELEMENT_NODE)
		{
			Element element = (Element) node;
			String attrName = Helper.getTagValue("attribute-name", element);

			if (attrName != null && !attrName.equalsIgnoreCase(""))
			{
				StringTokenizer st = new StringTokenizer(attrName, CommonConstants.SEMI_COLON);
				while (st.hasMoreTokens())
				{
					att.setAttributeName(st.nextToken());
					att.setTableColumnName(st.nextToken());
				}
			}
			att.setAttributeType(Helper.getTagValue("attribute-type", element));
			att.setSubAttributes(Helper.getTagValue("Sub-attributes", element));
			if (att.getSubAttributes() != null && !att.getSubAttributes().equalsIgnoreCase(""))
			{
				att.setSubAttributesList(new ArrayList<String>());
				StringTokenizer st = new StringTokenizer(att.getSubAttributes(), CommonConstants.SEMI_COLON);
				while (st.hasMoreTokens())
				{
					att.getSubAttributesList().add(st.nextToken());
				}
			}
		}
		return att;
	}

	private boolean validate(String userID) throws Exception
	{
		final String METHOD_NAME = "validate";
		boolean isExist = false;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try
		{
			conn = DatabaseConnection.getDBConnection(dbconfig);
			String query = "Select * from " + Authentication.dbconfig.getAuthenticationTableName() + " where user_id =?";
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, userID.toUpperCase());
			rs = pstmt.executeQuery();
			while (rs.next())
			{
				isExist = true;
			}
		}
		catch (SQLException e)
		{
			LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
			throw e;
		}
		catch (Exception e)
		{
			LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
			throw e;
		}
		finally
		{
			pstmt = null;
			rs = null;
			conn = null;
		}
		return isExist;
	}

}