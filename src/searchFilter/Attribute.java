package searchFilter;

import java.util.ArrayList;

public class Attribute
{
	private String attributeName;

	private String attributeType;

	private String subAttributes;

	private ArrayList<String> subAttributesList;

	private String tableColumnName;

	private String firstInputValue;

	private String secondInputValue;

	private boolean valueBeingUsed;

	public String getAttributeName()
	{
		return attributeName;
	}

	public void setAttributeName(String attributeName)
	{
		this.attributeName = attributeName;
	}

	public String getAttributeType()
	{
		return attributeType;
	}

	public void setAttributeType(String attributeType)
	{
		this.attributeType = attributeType;
	}

	public String getSubAttributes()
	{
		return subAttributes;
	}

	public void setSubAttributes(String subAttributes)
	{
		this.subAttributes = subAttributes;
	}

	public ArrayList<String> getSubAttributesList()
	{
		return subAttributesList;
	}

	public void setSubAttributesList(ArrayList<String> subAttributesList)
	{
		this.subAttributesList = subAttributesList;
	}

	public String getTableColumnName()
	{
		return tableColumnName;
	}

	public void setTableColumnName(String tableColumnName)
	{
		this.tableColumnName = tableColumnName;
	}

	public String getFirstInputValue()
	{
		return firstInputValue;
	}

	public void setFirstInputValue(String firstInputValue)
	{
		this.firstInputValue = firstInputValue;
	}

	public String getSecondInputValue()
	{
		return secondInputValue;
	}

	public void setSecondInputValue(String secondInputValue)
	{
		this.secondInputValue = secondInputValue;
	}

	public boolean isValueBeingUsed()
	{
		return valueBeingUsed;
	}

	public void setValueBeingUsed(boolean valueBeingUsed)
	{
		this.valueBeingUsed = valueBeingUsed;
	}

}