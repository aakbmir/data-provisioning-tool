package logging;

import java.io.File;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.PropertyConfigurator;

import common.CommonConstants;

public class LogConfig implements ServletContextListener
{

	private static final String CLASS_NAME = "LogConfig";

	private static final String PACKAGE_NAME = "logging";

	@Override
	public void contextDestroyed(ServletContextEvent sce)
	{
	}

	@Override
	public void contextInitialized(ServletContextEvent sce)
	{
		final String METHOD_NAME = "contextInitialized";
		try
		{
			ServletContext ctx = sce.getServletContext();
			String logFile = ctx.getRealPath("/");
			String propFile = ctx.getRealPath("/WEB-INF");
			File attributeFile = new File(propFile, "/attributes.xml");
			boolean exists = attributeFile.exists();
			if(!exists)
			{
				attributeFile = new File(CommonConstants.ATTRIBUTE_FILE_NEWTEST,"/attributes.xml");
				exists = attributeFile.exists();
			}
			System.setProperty("userPath", logFile);
			File propertiesFile = new File(propFile, "/log4j.properties");
			PropertyConfigurator.configure(propertiesFile.toString());
		}
		catch (Exception e)
		{
			LogHelper.error(PACKAGE_NAME, CLASS_NAME, METHOD_NAME, e.getMessage(), e);
		}
	}
}