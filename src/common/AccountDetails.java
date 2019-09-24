package common;

import java.util.Date;

public class AccountDetails
{
	private String accountNumber;

	private String brand;

	private String agrCode;

	private String nextStatementDate;

	private Double air;

	private Double creditLimit;

	private Double OTB;

	private int accountStatus;

	private String color = "red";

	private String reservedTcNo;

	private String reservedBy;

	private Date reservedDate;

	private String phase;

	private String BPA;

	public String getAccountNumber()
	{
		return accountNumber;
	}

	public void setAccountNumber(String accountNumber)
	{
		this.accountNumber = accountNumber;
	}

	public String getBrand()
	{
		return brand;
	}

	public void setBrand(String brand)
	{
		this.brand = brand;
	}

	public String getAgrCode()
	{
		return agrCode;
	}

	public void setAgrCode(String agrCode)
	{
		this.agrCode = agrCode;
	}

	public String getNextStatementDate()
	{
		return nextStatementDate;
	}

	public void setNextStatementDate(String nextStatementDate)
	{
		this.nextStatementDate = nextStatementDate;
	}

	public Double getAir()
	{
		return air;
	}

	public void setAir(Double air)
	{
		this.air = air;
	}

	public Double getCreditLimit()
	{
		return creditLimit;
	}

	public void setCreditLimit(Double creditLimit)
	{
		this.creditLimit = creditLimit;
	}

	public Double getOTB()
	{
		return OTB;
	}

	public void setOTB(Double oTB)
	{
		OTB = oTB;
	}

	public int getAccountStatus()
	{
		return accountStatus;
	}

	public void setAccountStatus(int accountStatus)
	{
		this.accountStatus = accountStatus;
	}

	public String getColor()
	{
		return color;
	}

	public void setColor(String color)
	{
		this.color = color;
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

	public Date getReservedDate()
	{
		return reservedDate;
	}

	public void setReservedDate(Date reservedDate)
	{
		this.reservedDate = reservedDate;
	}

	public String getPhase()
	{
		return phase;
	}

	public void setPhase(String phase)
	{
		this.phase = phase;
	}

	public String getBPA()
	{
		return BPA;
	}

	public void setBPA(String bPA)
	{
		BPA = bPA;
	}
}