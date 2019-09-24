package common;

public class DatabaseConfiguration
{
	private String DBName;

	private String DBIPAddress;

	private String sid;

	private String DBPortNumber;

	private String DBUserId;

	private String DBUserPwd;

	private String TableName;

	private String authenticationTableName;

	public String getDBName()
	{
		return DBName;
	}

	public void setDBName(String dBName)
	{
		DBName = dBName;
	}

	public String getDBIPAddress()
	{
		return DBIPAddress;
	}

	public void setDBIPAddress(String dBIPAddress)
	{
		DBIPAddress = dBIPAddress;
	}

	public String getSid()
	{
		return sid;
	}

	public void setSid(String sid)
	{
		this.sid = sid;
	}

	public String getDBPortNumber()
	{
		return DBPortNumber;
	}

	public void setDBPortNumber(String dBPortNumber)
	{
		DBPortNumber = dBPortNumber;
	}

	public String getDBUserId()
	{
		return DBUserId;
	}

	public void setDBUserId(String dBUserId)
	{
		DBUserId = dBUserId;
	}

	public String getDBUserPwd()
	{
		return DBUserPwd;
	}

	public void setDBUserPwd(String dBUserPwd)
	{
		DBUserPwd = dBUserPwd;
	}

	public String getTableName()
	{
		return TableName;
	}

	public void setTableName(String tableName)
	{
		TableName = tableName;
	}

	public String getAuthenticationTableName()
	{
		return authenticationTableName;
	}

	public void setAuthenticationTableName(String authenticationTableName)
	{
		this.authenticationTableName = authenticationTableName;
	}
}