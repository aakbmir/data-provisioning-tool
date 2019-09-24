package validationPoint;

public class ValidationPointAttributeOrder
{
	private String component;

	private String attributeComponent;

	private String attributeName;

	private String previousValue;

	private String newValue;

	public String getComponent()
	{
		return component;
	}

	public void setComponent(String component)
	{
		this.component = component;
	}

	public String getAttributeComponent()
	{
		return attributeComponent;
	}

	public void setAttributeComponent(String attributeComponent)
	{
		this.attributeComponent = attributeComponent;
	}

	public String getAttributeName()
	{
		return attributeName;
	}

	public void setAttributeName(String attributeName)
	{
		this.attributeName = attributeName;
	}

	public String getPreviousValue()
	{
		return previousValue;
	}

	public void setPreviousValue(String previousValue)
	{
		this.previousValue = previousValue;
	}

	public String getNewValue()
	{
		return newValue;
	}

	public void setNewValue(String newValue)
	{
		this.newValue = newValue;
	}

}