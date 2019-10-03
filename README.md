# Test Data Self-Provisioning Framework

# Objective: - 
The objective of this application is to provide a timely availability of test data for the test case executions in a testing environment. The complexity of provisioning appropriate test data is directly proportional to the complexity of the test case. Hence having a framework and tool that simplifies test data provisioning will expedite the test execution. The more complex the test execution more the value that can be derived from the simplification achieved due to the test data self-provisioning tool.


# Prerequisites: -
 • An application server or web server to deploy the war file (Like Tomcat or WebSphere) • A Relational Database (Like Oracle) containing the test data to be provisioned • A attribute.xml file containing the details of the database, tables, attributes and their datatype (attribute.xml is provided in the git hub) • A unique key to identify the records in the table. • Eclipse or any other IDE along with a server to perform any project specific changes in the code.
 
 
# Installation: - 
• Import the code in the IDE • Configure the build path • Make necessary changes in the attribute.xml with the details of respective tables. • Specify the attribute.xml path in the code and run the application.


# Module Structure: - • Packages
1.	src.userValidation: Contains files related registering and login features.
2.	src.searchFilter: Contains files related to self-provisioning of test data, unique key searching functionality, un-provisioning of the test data.
3.	src.ValidationPoint: Contains files related to Pre and Post-Test execution validation of the attributes of the test data.
4.	src.logging: Contains code related to the logging mechanism.


# Deployment: - 
• Create a war file using the eclipse IDE • Deploy the war file in the server (Like Tomcat, WebSphere, etc) • Open the application URL post deployment to access the application


# Running the Application: - 
• Open the application URL in a web browser • Register into the application (for First Time users only) • Login into the application using the credentials created while registering. • Choose the specific functionality required for the Test case and proceed.


# Built With: - 
• Java (Servlet and JSP) • HTML and CSS • JavaScript • RDMS(Oracle)


# License: 
NA
