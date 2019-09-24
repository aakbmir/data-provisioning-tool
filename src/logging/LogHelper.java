package logging;

import org.apache.log4j.Logger;

public class LogHelper
{

	public static Logger logger = Logger.getLogger(LogHelper.class);

	public static void error(String packageName, String className, String methodName, String errorMessage, Throwable t)
	{
		logger.info("Error Occured");
		logger.info(packageName + " " + className + " " + methodName + " " + errorMessage + " " + t);
	}

}