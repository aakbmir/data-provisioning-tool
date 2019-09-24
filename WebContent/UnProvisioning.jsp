<!DOCTYPE html>
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
<%@ page import="common.*"%>
<%@ page import="java.util.*"%>
<link rel="stylesheet" type="text/css" href="css/homePage.css">

<style>
/* width */
::-webkit-scrollbar {
	width: 12px;
}

/* Track */
::-webkit-scrollbar-track {
	box-shadow: inset 0 0 50px white;
	border-radius: 5px
}

/* Handle */
::-webkit-scrollbar-thumb {
	background: linear-gradient(to right, rgb(136, 76, 80), rgb(29, 67, 80));
	border-radius: 3px;
}

/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
	background: linear-gradient(to right, rgb(136, 76, 80), rgb(29, 67, 80));
}
</style>
<script>
	function refresh() {
		history.pushState(null, null, location.href);
		window.onpopstate = function() {
			history.go(1);
		};
	}

	function selectAllCheckboxes() {
		var checkboxes = document.getElementsByName("checkboxes");

		var buttonValue = document.getElementById('selectAll').value;
		if (buttonValue == 'Select') {
			for (var i = 0; i < checkboxes.length; i++) {
				checkboxes[i].checked = true;
				document.getElementById('selectAll').value = 'Unselect';
			}
		} else if (buttonValue == 'Unselect') {
			for (var i = 0; i < checkboxes.length; i++) {
				checkboxes[i].checked = false;
				document.getElementById('selectAll').value = 'Select';
			}
		}
		return false;
	}

	function validateInputFields() {
		var checkboxes = document.getElementsByName("checkboxes");
		var checkboxArray = [];
		for (var i = 0; i < checkboxes.length; i++) {
			if (checkboxes[i].checked) {
				checkboxArray.push(i);
			}
		}
		document.getElementById('accountSelected').value = checkboxArray;
		return true;
	}

	function validateInput() {
		var checkboxes = document.getElementsByName("checkboxes");
		var checkboxArray = [];
		for (var i = 0; i < checkboxes.length; i++) {
			if (checkboxes[i].checked) {
				return true;
			}
		}
		return false;
	}
</script>
</head>
<body onload="createButtons();onload();"
	onsubmit="return validateInputFields();"
	style="background-size: auto; background: url(./img/background.jpg)">
	<form action="UnprovisionAccountsServlet" method="post">
		<%
			ArrayList<AccountDetails> myList = new ArrayList<AccountDetails>();
			myList = (ArrayList) request.getAttribute("userProvisionedList");
		%>
		<input type="submit" value="Log Out" name="Logout" style="float: right;outline: none;border: none;color: black;padding: 8px 15px;font-size: 18px;border-radius: 5px;">
		<div id="userProvisionedList"
			style="height: 90%;background-size: auto;top: 3%;left: 5%;width: 90%;position: fixed;display: block;">

			<div style="height: 90%; overflow: auto;">
				<%
					if (null != myList && !myList.isEmpty()) {
				%>
				<table style="margin-top: 3%; width: 100%; border: 1px solid black;">
					<tr
						style="background-color: darkgrey; color: white; text-align: left;">
						<td
							style="width: 8%; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							<input type="submit" id="selectAll" value="Select"
							onclick="return selectAllCheckboxes();" name="selectAll"
							style="text-decoration-line: underline; outline: none; cursor: pointer; border: none; background-color: transparent; color: black; font-size: 16px;">
						</td>
						<td
							style="width: 8%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							Account Number</td>
						<td
							style="width: 8%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							Principal Brand</td>
						<td
							style="width: 8%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							Agr Type</td>
						<td
							style="width: 8%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							Next Statement Date</td>
						<td
							style="width: 8%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							OTB</td>
						<td
							style="width: 8%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							Current AIR</td>
						<td
							style="width: 8%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							Credit Limit</td>
						<td
							style="width: 8%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							Test Case No.</td>
						<td
							style="width: 8%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							Phase</td>
						<td
							style="width: 20%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							BPA</td>
					</tr>
					<%
						for (int i = 0; i < myList.size(); i++) {
					%>
					<tr>
						<td
							style="text-align: center; color: black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
							<input style="width: 15px; height: 15px;" type="checkbox"
							name="checkboxes" id="checkbox(<%out.print(i);%>)" /> <input
							type="hidden" name="accountSelected" id="accountSelected"
							value="" />
						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">

							<%
								out.println(myList.get(i).getAccountNumber());
							%>
						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">

							<%
								out.println(myList.get(i).getBrand());
							%>
						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
							<%
								out.println(myList.get(i).getAgrCode());
							%>
						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
							<%
								out.println(myList.get(i).getNextStatementDate());
							%>
						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
							<%
								out.println(myList.get(i).getOTB());
							%>
						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
							<%
								out.println(myList.get(i).getAir());
							%>
						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
							<%
								out.println(myList.get(i).getCreditLimit());
							%>
						</td>

						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-family: serif; padding: 5px; padding-left: 5px;">
							<%
								out.println(myList.get(i).getReservedTcNo() + " - " + myList.get(i).getReservedBy());
							%>
						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-family: serif; padding: 5px; padding-left: 5px;">
							<%
								out.println(myList.get(i).getPhase());
							%>

						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-family: serif; padding: 5px; padding-left: 5px;">
							<%
								out.println(myList.get(i).getBPA());
							%>

						</td>

					</tr>
					<%
						}
						} else {
					%>
					<p style="text-align: center; font-size: 22px; margin-top: 10%;">
						No Data Provisioned</p>

					<%
						}
					%>
				</table>

			</div>
			<div>
				<table
					style="border-image: none; left: 40%; width: 20%; position: absolute;">
					<tr>
						<%
							if (null != myList && !myList.isEmpty()) {
						%>
						<td style="width: 50%; text-align: center; line-height: 66px;">
							<input type="submit" name="Unprovision" id="unprovisionButton"
							value="Unprovision" onclick="return validateInput();"
							style="padding: 7px 7px;border-radius: 5px;border: currentColor;border-image: none;width: 80%;color: black;font-size: 18px;" />
						</td>
						<%
							}
						%>

						<td style="width: 100%; text-align: center; line-height: 66px;"><input
							type="submit" name="Close" id="closeButton" value="Close"
							style="padding: 7px 7px;border-radius: 5px;border: currentColor;border-image: none;width: 70%;color: black;font-size: 18px;" /></td>
					</tr>
				</table>
			</div>
		</div>


	</form>
</body>
</html>