package common;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class Helper
{
	public static String roundOffBigDecimalValues(BigDecimal value)
	{
		BigDecimal cutted = value.setScale(2, RoundingMode.DOWN);
		return cutted.toString();
	}
	

	public static void invalidateSession(HttpSession session) 
	{
		session.removeAttribute("userEnv");
		session.removeAttribute("categoryList");
		session.removeAttribute("doc");
		session.removeAttribute("DetailedView");
		session.removeAttribute("accountNumber");
		session.removeAttribute("userId");
		session.removeAttribute("searchFieldsList");
		session.removeAttribute("accountDetailsList");
		session.removeAttribute("databaseUpdatedFlag");
		session.removeAttribute("totalNumberOfRecords");
		session.removeAttribute("listCategory");
		session.removeAttribute("accList");
		session.removeAttribute("orList");
		session.removeAttribute("accountNumberList");
		session.removeAttribute("NumberOfAccountsSearched");
	}

	public static String roundOffStringValues(String value)
	{
		BigDecimal newvalue = new BigDecimal(value);
		BigDecimal cutted = newvalue.setScale(2, RoundingMode.DOWN);
		return cutted.toString();
	}

	public static String fetchPreviousValue(HashMap<String, String> previousList, String attributeComponent)
	{
		String previousValue = null;
		for (Map.Entry<String, String> entry : previousList.entrySet())
		{
			if (entry.getKey().equalsIgnoreCase(attributeComponent))
			{
				previousValue = entry.getValue();
				break;
			}
		}
		return previousValue;
	}

	public static DatabaseConfiguration fetchDBConnectionDetails(Document doc, String DBName,HttpSession session)
	{
		DatabaseConfiguration dbconfig = new DatabaseConfiguration();
		NodeList nodeName = doc.getElementsByTagName(DBName);
		for (int i = 0; i < nodeName.getLength(); i++)
		{
			Element element = (Element) nodeName.item(i);
			dbconfig.setDBName(getTagValue("DBName", element));
			dbconfig.setDBIPAddress(getTagValue("DBIPAddress", element));
			dbconfig.setSid(getTagValue("SID", element));
			dbconfig.setDBPortNumber(getTagValue("DBPortNumber", element));
			dbconfig.setDBUserId(getTagValue("TableUserId", element));
			dbconfig.setDBUserPwd(getTagValue("TableUserPwd", element));
			String userEnv = (String)session.getAttribute("userEnv");
			List<String> tableNames = getTagValueFromChildNode("Environments", element);
			for(String tableName: tableNames)
			{
				if(tableName.contains(userEnv))
				{
					String[] tableNameArray = tableName.split(":");
					dbconfig.setTableName(tableNameArray[0]);
					break;
				}
			}
			dbconfig.setAuthenticationTableName(getTagValue("AuthenticateTableName", element));
		}
		return dbconfig;
	}
	
	public static ArrayList<String> getTagValueFromChildNode(String tag, Element element)
	{
		ArrayList<String> tables = new ArrayList<String>();
		if(tag.equalsIgnoreCase("Environments"))
		{
		for (int i = 0; i < element.getChildNodes().getLength(); i++)
		{
			if (element.getNodeType() == Node.ELEMENT_NODE)
			{
				if (element.getElementsByTagName(tag) != null)
				{
					NodeList nodeList = element.getElementsByTagName(tag);
					
					for (int j = 0; j < nodeList.getLength();j++)
					{
						NodeList childElement = (NodeList) nodeList.item(j);
						tables = getTagValueFromChildNod("environment", childElement);
					}
				}
			}
		}
		}
		return tables;
	}

	public static ArrayList<String> getTagValueFromChildNod(String tag, NodeList element)
	{
		ArrayList<String> tables = new ArrayList<String>();
		for (int i = 0; i < element.getLength(); i++)
		{		
			if (element.item(i) != null)
			{
				NodeList nodeList = element.item(i).getChildNodes();
				for (int j = 0; j < nodeList.getLength(); j++)
				{
					Node childElement = (Node) nodeList.item(j);
					if(childElement.getNodeType() == Node.ELEMENT_NODE)
					{
						tables.add(childElement.getTextContent());
					}
				}
			}
		}
		return tables;
	}
	

	public static String getTagValue(String tag, Element element)
	{
		for (int i = 0; i < element.getChildNodes().getLength(); i++)
		{
			if (element.getNodeType() == Node.ELEMENT_NODE)
			{
				if (element.getElementsByTagName(tag).item(i) != null)
				{
					NodeList nodeList = element.getElementsByTagName(tag).item(i).getChildNodes();
					Node node = (Node) nodeList.item(i);
					return node.getNodeValue();
				}
			}
		}
		return "";
	}

	// Method to format date as string
	public static String formatDate(Object date, String pattern)
	{
		SimpleDateFormat sdf = new SimpleDateFormat(pattern);
		String formattedDate = null;
		if (date != null)
		{
			formattedDate = sdf.format(date);
		}
		return formattedDate;
	}

	public static String formatDate(String String, String pattern)
	{
		SimpleDateFormat sdf = new SimpleDateFormat(pattern);
		String formattedDate = null;
		if (String != null)
		{
			formattedDate = sdf.format(String);
		}
		return formattedDate;
	}

	public static Date convertToDate(String String, String pattern) throws ParseException
	{
		Date sdf = new SimpleDateFormat(pattern).parse(String);
		return sdf;
	}
}