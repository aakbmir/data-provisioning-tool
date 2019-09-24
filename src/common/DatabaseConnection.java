package common;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import logging.LogHelper;

public class DatabaseConnection
{

	private static final String CLASS_NAME = "DatabaseConnection";

	private static final String PACKAGE_NAME = "commonPackage";

	public static Connection getDBConnection(DatabaseConfiguration dbconfig) throws SQLException
	{
		final String METHOD_NAME = "getDBConnection";
		Connection conn = null;
		try
		{
			Class.forName(CommonConstants.DRIVER_CLASS_NAME);
			conn = DriverManager.getConnection(CommonConstants.THIN_CLIENT + dbconfig.getDBIPAddress() + ":" + dbconfig.getDBPortNumber() + ":" + dbconfig.getSid() + "",
					"" + dbconfig.getDBUserId() + "", "" + dbconfig.getDBUserPwd() + "");
		}
		catch (Exception e)
		{
			LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
			throw new SQLException("Unable to connection to " + dbconfig.getDBName() + " Database.");
		}
		return conn;
	}
}