package userValidation;

import java.io.File;
import java.io.FileNotFoundException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;

import common.CommonConstants;
import common.DatabaseConfiguration;
import common.DatabaseConnection;
import common.Helper;
import common.QueryConstants;
import logging.LogHelper;
import searchFilter.Attribute;

public class Register extends HttpServlet
{
	private static final long serialVersionUID = 1298354747863407644L;

	private static final String CLASS_NAME = "Register";

	private static final String PACKAGE_NAME = "userValidation";

	public static ArrayList<Attribute> attributeList = null;

	public static DatabaseConfiguration dbconfig = null;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, java.io.IOException
	{
		final String METHOD_NAME = "doPost";
		if (null != request.getParameter("SignUp"))
		{
			String firstName = request.getParameter(CommonConstants.FIRST_NAME);
			String lastName = request.getParameter(CommonConstants.LAST_NAME);
			String username = request.getParameter(CommonConstants.SIGN_UP_USER_NAME);
			try
			{
				boolean isDataInserted = false;
				getServletConfig().getServletContext().getRealPath("/");
				ServletContext ctx = getServletConfig().getServletContext();
				String propFile = ctx.getRealPath("/");
				File attributeFile = new File(propFile, "WEB-INF/attributes.xml");
				DocumentBuilder dBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
				Document doc = dBuilder.parse(attributeFile);
				DatabaseConfiguration dbconfig = Helper.fetchDBConnectionDetails(doc, CommonConstants.PROVISIONAL_DB,request.getSession());
				Connection conn = DatabaseConnection.getDBConnection(dbconfig);
				isDataInserted = insertDataInDB(firstName, lastName, username, conn);
				if (isDataInserted)
				{
					request.setAttribute("confirmationMessage", CommonConstants.REGISTRATION_SUCCESS);
					RequestDispatcher dispatcher = request.getRequestDispatcher("/homePage.jsp");
					dispatcher.forward(request, response);
				}
				else
				{
					request.setAttribute("SignupErrorMsg", CommonConstants.REGISTRATION_FAILURE);
					RequestDispatcher dispatcher = request.getRequestDispatcher("/homePage.jsp");
					dispatcher.forward(request, response);
				}
			}
			catch (SQLIntegrityConstraintViolationException e)
			{
				LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, CommonConstants.ALREADY_REGISTERED, e);
				request.setAttribute("SignupErrorMsg", CommonConstants.ALREADY_REGISTERED);
				RequestDispatcher dispatcher = request.getRequestDispatcher("/homePage.jsp");
				dispatcher.forward(request, response);
			}
			catch (FileNotFoundException fn)
			{
				LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, CommonConstants.CONFIG_ISSUE, fn);
				request.setAttribute("SignupErrorMsg", CommonConstants.CONFIG_ISSUE);
				RequestDispatcher dispatcher = request.getRequestDispatcher("/homePage.jsp");
				dispatcher.forward(request, response);
			}
			catch (Exception exp)
			{
				LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, CommonConstants.REGISTRATION_FAILURE, exp);
				request.setAttribute("SignupErrorMsg", CommonConstants.REGISTRATION_FAILURE);
				RequestDispatcher dispatcher = request.getRequestDispatcher("/homePage.jsp");
				dispatcher.forward(request, response);
			}
		}
	}

	private boolean insertDataInDB(String firstName, String lastName, String username, Connection conn) throws SQLIntegrityConstraintViolationException
	{
		final String METHOD_NAME = "insertDataInDB";
		String query = QueryConstants.REGISTER_QUERY;
		PreparedStatement pstmt = null;
		boolean inserted = false;
		try
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, firstName);
			pstmt.setString(2, lastName);
			pstmt.setString(3, username.toUpperCase());
			pstmt.setString(4, "N");
			pstmt.execute();
			inserted = true;
		}
		catch (SQLIntegrityConstraintViolationException e)
		{
			LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
			throw e;
		}
		catch (Exception e)
		{
			LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
		}
		finally
		{
			pstmt = null;
			conn = null;
		}
		return inserted;
	}

}