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

	function validateInputFields() {

		var checkboxes = document.getElementsByClassName("tcStatus");
		var checkboxArray = [];

		for (var i = 0; i < checkboxes.length; i++) {

			if (checkboxes[i].value != null
					&& checkboxes[i].value != 'Please select') {
				checkboxArray.push(i);
			}
		}
		document.getElementById('accountSelected').value = checkboxArray;
		return true;

	}

	function enableSubmit() {

		var accUsed = document.getElementsByClassName("accUsed");
		var usedByDate = document.getElementsByClassName("usedDate");
		var tcPassStatus = document.getElementsByClassName("tcStatus");

		var bool = true;

		for (var i = 0; i < accUsed.length; i++) {

			if (accUsed[i].value == '' || usedByDate[i].value == ''
					|| tcPassStatus[i].value == '') {

				bool = false;
				break;
			}

		}
		if (bool) {
			document.getElementById('performSubmit').disabled = false;
			document.getElementById('performSubmit').style.backgroundColor = 'cornflowerblue';
		} else {
			document.getElementById('performSubmit').disabled = true;
			document.getElementById('performSubmit').style.backgroundColor = 'grey';

		}
	}
</script>
</head>
<body onload="createButtons();onload();"
	style="background-size: auto; background: url(./img/background.jpg);">
	<form action="ConsumptionAccountServlet" method="post"
		onsubmit="return validateInputFields();">

		<div id="consumptionList"
			style="background-size: auto; overflow: auto; top: 3%; left: 10%; width: 80%; height: 90%; position: fixed; display: block;">
			<div>
				<%
					ArrayList<ConsumptionDetails> myList = new ArrayList<ConsumptionDetails>();
					myList = (ArrayList) request.getAttribute("accountDetailsList");
					if (null != myList && !myList.isEmpty())
					{
				%>
				<table style="margin-top: 3%; width: 100%; border: 1px solid black;">

					<tr
						style="background-color: darkgrey; color: white; text-align: left;">
						<td
							style="width: 10%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							Account Number</td>
						<td
							style="width: 10%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							Reserved TC No</td>
						<td
							style="width: 10%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							Reserved By</td>
						<td
							style="width: 10%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							Account Used for TC</td>
						<td
							style="width: 10%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							Account Usage Date</td>
						<td
							style="width: 10%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							TC Status</td>

					</tr>
					<%
						for (int i = 0; i < myList.size(); i++)
							{
					%>
					<tr>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
							<input type="text" name="accNo<%out.print(i);%>"
							value="<%out.print(myList.get(i).getAccountNumber());%>" disabled />
						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
							<input name="reservedTcNo<%out.print(i);%>"
							value="<%out.print(myList.get(i).getReservedTcNo());%>" disabled />
						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
							<input name="reservedBy<%out.print(i);%>"
							value="<%out.print(myList.get(i).getReservedBy());%>" disabled />

						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
							<select name="accUsedNameAttr<%out.print(i);%>" class="accUsed"
							onchange="enableSubmit();">
								<option selected="selected" value="">Please select</option>
								<option value="Yes">Yes</option>
								<option value="No">No</option>
						</select> <input type="hidden" name="accountSelected" id="accountSelected"
							value="" />
						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
							<input autocomplete="off" type="date" pattern="MM-DD-YYYY"
							placeholder="MM-DD-YYYY" name="usedDateNameAttr<%out.print(i);%>"
							class="usedDate" id="usedDate" onchange="enableSubmit();">
						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
							<select name="tcStatusNameAttr<%out.print(i);%>" class="tcStatus"
							onchange="enableSubmit();">
								<option selected="selected" value="">Please select</option>
								<option value="Pass">Pass</option>
								<option value="Fail">Fail</option>
								<option value="In Progress">In Progress</option>
						</select>
						</td>


					</tr>
					<%
						}
					%>
				</table>
				<%
					}
					else
					{
				%>
				<table style="margin-top: 3%; width: 100%;">

					<tr style="text-align: center;">
						<td
							style="width: 100%; font-size: 25px; font-family: serif; color: black;">
							Records Updated</td>
					</tr>
				</table>
				<%
					}
				%>
			</div>

			<table
				style="border-image: none; left: 40%; width: 20%; position: absolute;">
				<tr>
					<%
						if (null != myList && !myList.isEmpty())
						{
					%>
					<td style="width: 50%; text-align: center; line-height: 66px;"><input
						type="submit" name="submit" id="performSubmit" value="Submit"
						disabled
						style="padding: 7px 7px;border-radius: 5px;border: currentColor;border-image: none;width: 50%;color: black;font-size: 18px;" /></td>
					<%
						}
					%>
					<td style="width: 100%; text-align: center; line-height: 66px;"><input
						type="submit" name="Close" id="closeButton" value="Close"
						style="padding: 7px 7px;border-radius: 5px;border: currentColor;border-image: none;width: 50%;color: black;font-size: 18px;" /></td>
				</tr>
			</table>

		</div>
	</form>
</body>
</html>