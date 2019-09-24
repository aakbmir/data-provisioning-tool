<!DOCTYPE html>
<%@page import="common.AccountDetails"%>
<html lang="">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">
<title>Title Page</title>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="searchFilter.*"%>
<%@ page import="java.util.*"%>
<link rel="stylesheet" type="text/css" href="css/homePage.css">
<script type="text/javascript">
	
	
function hidePopup(id)
{

		if(id=='AllColumnsDisplay')
		{
			document.getElementById('AllColumnsDisplay').style.display = "none";
		}
		else if (id=='userProvisionedList')
		{
			document.getElementById('userProvisionedList').style.display = "none";
		}
		else if (id=='validationPopupClose')
		{
			document.getElementById('ValidationDisplay').style.display = "none";
		}
		document.getElementById('foobar').style.opacity = '1';
		document.getElementById('accountDetails').style.opacity = '1';
		return false;
	}
	
	function onload() {
<%if (null != request.getAttribute("AllColumnsDisplay")) {%>
	document.getElementById('foobar').style.opacity = '0.1';
		document.getElementById('accountDetails').style.opacity = '0.1';
<%} else if (request.getAttribute("userProvisionedList") != null || request.getAttribute("userProvisionednullList") != null) {%>
	document.getElementById('foobar').style.opacity = '0.1';
		document.getElementById('accountDetails').style.opacity = '0.1';
<%}  else if (request.getAttribute("ValidationDisplay") != null) {%>
	document.getElementById('foobar').style.opacity = '0.1';
		document.getElementById('accountDetails').style.opacity = '0.1';
<%}
 else {%>
	document.getElementById('foobar').style.opacity = '1';
		document.getElementById('accountDetails').style.opacity = '1';
<%}%>
	}
</script>
</head>
<body onload="onload();"
	style="background-size: auto; background: url(./img/background.jpg);">
	<form action="FilterAccountServlet" method="post"
		onsubmit="validateInputFields();">
		<div id="foobar" style="padding-right: 1%; padding: 1%; width: 20%;">
			<div style="width: 100%">
				<table style="width: 100%">
					<tr>
						<td style="width: 60%; color: black; font-size: 20px;">Account
							Numbers Searched: ${NumberOfAccountsSearched}</td>
					</tr>
					<tr>
						<td style="Width: 60%; color: black; visibility: hidden;">.</td>
					</tr>
				</table>
			</div>
			<%
				ArrayList<AccountDetails> myList = new ArrayList<AccountDetails>();
				myList = (ArrayList) session.getAttribute("accountNumberList");
				if (null != myList && !myList.isEmpty())
				{
					for (int i = 0; i < myList.size(); i++)
					{
			%>
			<div style="Width: 100%">
				<table style="Width: 100%">
					<tr>
						<%
							if (myList.get(i).getColor().equalsIgnoreCase("red"))
									{
						%>
						<td style="Width: 60%; font-size: 18px; color: red">
							<%
								out.println(myList.get(i).getAccountNumber());
							%>
						</td>
						<%
							}
									else
									{
						%>
						<td style="Width: 60%; font-size: 18px; color: black">
							<%
								out.println(myList.get(i).getAccountNumber());
							%>
						</td>
						<%
							}
						%>
					
					<tr>
					<tr>
						<td
							style="line-height: 1px; Width: 60%; color: black; visibility: hidden;">.</td>
					</tr>
				</table>
			</div>
			<%
				}
				}
			%>
			<input type="submit" name="BackButton" value="Back" id="BackButton"
				style="border: none; color: black; padding: 10px 20px; outline: none; font-size: 18px; border-radius: 5px; width: 40%">


		</div>
	</form>
	<jsp:include page="Provisioning.jsp"></jsp:include>
</body>
</html>