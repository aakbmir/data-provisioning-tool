package common;

public class ConsumptionDetails
{
	private String accountNumber;

	private String reservedTcNo;

	private String reservedBy;

	private String accountUsedForTC;

	private String accountUsageDate;

	private String TCStatus;

	public String getAccountNumber()
	{
		return accountNumber;
	}

	public void setAccountNumber(String accountNumber)
	{
		this.accountNumber = accountNumber;
	}

	public String getReservedTcNo()
	{
		return reservedTcNo;
	}

	public void setReservedTcNo(String reservedTcNo)
	{
		this.reservedTcNo = reservedTcNo;
	}

	public String getReservedBy()
	{
		return reservedBy;
	}

	public void setReservedBy(String reservedBy)
	{
		this.reservedBy = reservedBy;
	}

	public String getAccountUsedForTC()
	{
		return accountUsedForTC;
	}

	public void setAccountUsedForTC(String accountUsedForTC)
	{
		this.accountUsedForTC = accountUsedForTC;
	}

	public String getAccountUsageDate()
	{
		return accountUsageDate;
	}

	public void setAccountUsageDate(String accountUsageDate)
	{
		this.accountUsageDate = accountUsageDate;
	}

	public String getTCStatus()
	{
		return TCStatus;
	}

	public void setTCStatus(String tCStatus)
	{
		TCStatus = tCStatus;
	}

}