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
	
	function openValidationPointsPopUp(accountNumber)
	{
		document.getElementById('OpenValidationPoints').value = accountNumber;
	}
	
	function refresh() {
		history.pushState(null, null, location.href);
		window.onpopstate = function() {
			history.go(1);
		};
	}

	function validateInputFields() {

		var checkboxes = document.getElementsByName("checkboxes");
		var checkboxArray = [];
		var textValue = document.getElementsByClassName("TestCaseId");

		for (var i = 0; i < checkboxes.length; i++) {
			if (checkboxes[i].checked) {

				if (textValue[i].value == '') {

					alert("Please enter the Test Case number for the selected check box.");
					return false;
				} else {
					checkboxArray.push(i);
				}
			}
		}
		document.getElementById('accountSelected').value = checkboxArray;
		return true;
	}


function selectAllCheckboxes()
{
	var checkboxes = document.getElementsByName("checkboxes");
	
	var buttonValue = document.getElementById('selectAll').value;
	if(buttonValue == 'Select')
	{
		for (var i = 0; i < checkboxes.length; i++)
		{
		checkboxes[i].checked = true;
		document.getElementById('selectAll').value = 'Unselect';
		}
	}
	else if(buttonValue == 'Unselect')
	{
		for (var i = 0; i < checkboxes.length; i++)
		{
		checkboxes[i].checked = false;
		document.getElementById('selectAll').value = 'Select';
		}
	}
	enableProvision();
	return false;
}

function enterbulkTcNo()
{
	var enteredvalue = prompt("Enter Tc No");
	if(enteredvalue == null)
	{
	return false;
	}
	var textValue = document.getElementsByClassName("TestCaseId");
	if(enteredvalue.length >0)
	{
	for (var i = 0; i < textValue.length; i++)
	{
		textValue[i].value = enteredvalue;
	}
	}
	enableProvision();
	return false;
}

function enterbulkPhase()
{
	var enteredvalue = prompt("Enter 1 for FDT1\nEnter 2 for FDT2");
	if(enteredvalue == null)
	{
	return false;
	}
	if(enteredvalue == 1)
	{
		enteredvalue = 'FDT1';
	}
	else if (enteredvalue == 2)
	{
		enteredvalue = 'FDT2';
	}
	else
	{
		return false;
	}
	var textValue = document.getElementsByClassName("Phase");
	if(enteredvalue.length > 0)
	{
		
		for (var i = 0; i < textValue.length; i++)
		{
			
			textValue[i].value = enteredvalue;
		}
	}
	enableProvision();
	return false;
}



function enterbulkBPA()
{
	var enteredvalue = prompt(" Enter 1 for Account Opening\n Enter 2 for Arrears Management\n Enter 3 for Billing and Statement Generation\n Enter 4 for Create and Market Customer Offer\n Enter 5 for Customer and Account Management\n Enter 6 for Insurance\n Enter 7 for Make and Process Payments\n Enter 8 for MI Zeus\n Enter 9 for Miscellaneous\n Enter 10 for Order Management");
	
	if(enteredvalue == null)
	{
		return false;
	}
	if(enteredvalue == 1)
	{
		enteredvalue = 'Account Opening';
	}
	else if (enteredvalue == 2)
	{
		enteredvalue = 'Arrears Management';
	}
	else if (enteredvalue == 3)
	{
		enteredvalue = 'Billing and Statement Generation';
	}
	else if (enteredvalue == 4)
	{
		enteredvalue = 'Create and Market Customer Offer';
	}
	else if (enteredvalue == 5)
	{
		enteredvalue = 'Customer and Account Management';
	}
	else if (enteredvalue == 6)
	{
		enteredvalue = 'Insurance';
	}
	else if (enteredvalue == 7)
	{
		enteredvalue = 'Make and Process Payments';
	}
	else if (enteredvalue == 8)
	{
		enteredvalue = 'MI Zeus';
	}
	else if (enteredvalue == 9)
	{
		enteredvalue = 'Miscellaneous';
	}
	else if (enteredvalue == 10)
	{
		enteredvalue = 'Order Management';
	}
	else
	{
		return false;
	}
	var textValue = document.getElementsByClassName("BPA");
	
	if(enteredvalue.length > 0)
	{
		
		for (var i = 0; i < textValue.length; i++)
		{
			
			textValue[i].value = enteredvalue;
		}
	}
	enableProvision();
	return false;
}


	function enableProvision() {

		var checkboxes = document.getElementsByName("checkboxes");
		var checkboxArray = [];
		var textValue = document.getElementsByClassName("TestCaseId");
		var phaseValue = document.getElementsByClassName("Phase");
		var bpaValue = document.getElementsByClassName("BPA");
		
		var bool = false;
		
		for (var i = 0; i < checkboxes.length; i++)
		{
			if(checkboxes[i].disabled){
				continue;
			}
			if (checkboxes[i].checked){
				
				if(textValue[i].value != '' &&  phaseValue[i].value != '' && bpaValue[i].value != ''){
				 		bool = true;
				}
				else 
					{
						bool = false; break;
					}
				}else{
						if(textValue[i].value != '' ||  phaseValue[i].value != '' || bpaValue[i].value != ''){
				 		bool = false; break;
				}
				}
				
		}
		
		if (bool) {
			document.getElementById('ProvisionButton').disabled = false;
			document.getElementById('ProvisionButton').style.backgroundColor = 'cornflowerblue';
		} else {
			document.getElementById('ProvisionButton').disabled = true;
			document.getElementById('ProvisionButton').style.backgroundColor = 'grey';

		}
	}
	
	function checkInputValues(evt)
	{
	
		var charCode=(evt.which)?evt.which:event.keyCode;
		if(charCode >31 && (charCode <48 || charCode >57))
		{
			return false;
		}
		return true;
	}
</script>
</head>
<body onload="createButtons();onload();"
	style="background-size: auto; background: url(./img/background.jpg);">

	<form action="FilterAccountServlet" method="post"
		onsubmit="return validateInputFields();">
		<div id="accountDetails"
			style="overflow-y: auto; overflow-x: auto; position: fixed; float: right; width: 72%; margin-left: 26%; top: 1%; min-height: 100px; max-height: 90%">
			<input type="submit" value="Log Out" name="Logout" style="float: right;outline: none;border: none;color: black;padding: 8px 15px;font-size: 18px;border-radius: 5px;">
			<%
				ArrayList<AccountDetails> accList = (ArrayList<AccountDetails>) session.getAttribute("accountDetailsList");
				String databaseUpdatedFlag = (String) session.getAttribute("databaseUpdatedFlag");

				if (null != accList && !accList.isEmpty() && databaseUpdatedFlag.equals("false"))
				{
			%>
			<table id="tabledata"
				style="overflow: auto; height: 90%; border: 1px solid black; width: 100%;">
				<tr>
					<td colspan="9"
						style="font-size: 18px; font-family: serif; padding: 5px; padding-left: 5px; color: white;">
						<label style="font-size: 18px; font-family: serif; color: black;">
							Total number of records found:</label> <label
						style="font-size: 20px; font-family: serif; color: black;">
							${totalNumberOfRecords}</label> <input type="hidden"
						value="${Navigation}" name="Navigation"> <input
						type="hidden" name="accountSelected" id="accountSelected" value="" />
					</td>
					<td colspan="1"><input type="submit" name="ProvisionButton"
						id="ProvisionButton" disabled
						style="margin-right: 10%; border: none; width: 100px; cursor: pointer; color: black; font-family: serif; outline: none; font-size: 22px; padding: 3px; border-radius: 5px;"
						value="Provision"> <br /></td>
				</tr>
				<tr
					style="background-color: darkgrey; color: white; text-align: left;">
					<td
						style="width: 5%; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
						<input type="submit" id="selectAll" value="Select"
						onclick="return selectAllCheckboxes();" name="selectAll"
						style="text-decoration-line: underline; outline: none; cursor: pointer; border: none; background-color: transparent; color: black; font-size: 16px;">
					</td>
					<td
						style="width: 10%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
						Account Number</td>
					<td
						style="width: 7%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
						Principal Brand</td>
					<td
						style="width: 10%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
						Agr Code</td>
					<td
						style="width: 12%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
						Next Statement Date</td>
					<td
						style="width: 10%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
						OTB</td>
					<td
						style="width: 7%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
						Current AIR</td>
					<td
						style="width: 10%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
						Credit Limit</td>
					<td
						style="width: 10%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
						<input type="submit" id="Test Case No" value="TC No"
						onclick="return enterbulkTcNo();" name="Test Case No."
						style="text-decoration-line: underline; outline: none; cursor: pointer; border: none; background-color: transparent; color: black; font-size: 16px;">
					</td>
					<td
						style="width: 10%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
						<input type="submit" id="phase" value="Phase"
						onclick="return enterbulkPhase();" name="Phase"
						style="text-decoration-line: underline; outline: none; cursor: pointer; border: none; background-color: transparent; color: black; font-size: 16px;">
					</td>
					<td
						style="width: 10%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
						<input type="submit" id="BPA" value="BPA"
						onclick="return enterbulkBPA();" name="BPA"
						style="text-decoration-line: underline; outline: none; cursor: pointer; border: none; background-color: transparent; color: black; font-size: 16px;">
					</td>
				</tr>
				<%
					ArrayList<AccountDetails> myList = new ArrayList<AccountDetails>();
						myList = (ArrayList) session.getAttribute("accountDetailsList");
						if (null != myList && !myList.isEmpty())
						{

							for (int i = 0; i < myList.size(); i++)
							{
				%>
				<tr>
					<td
						style="text-align: center; color: black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
						<%
							if (myList.get(i).getReservedBy() != null && !myList.get(i).getReservedBy().equalsIgnoreCase(""))
										{
						%> <input style="width: 17px; height: 17px; display: none"
						disabled type="checkbox" name="checkboxes"
						id="checkbox(<%out.print(i);%>)" onclick="enableProvision();" />
						<%
 	}
 				else
 				{
				 %> <input style="width: 17px; height: 17px;" type="checkbox"
						name="checkboxes" id="checkbox(<%out.print(i);%>)"
						onclick="enableProvision();" /> <%
 				}
 				 %>
					</td>
					<td
						style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">

						<input type="submit" id="signin"
						title="Click here to view Further Details"
						value="<%out.println(myList.get(i).getAccountNumber());%>"
						name="DetailedView"
						style="text-decoration-line: underline; outline: none; cursor: pointer; border: none; background-color: transparent; color: black; font-size: 16px;">

					</td>
					<td
						style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">

						<input type="submit" id="validationPoints"
						title="Click here to Validation Points"
						value="<%out.println(myList.get(i).getBrand());%>"
						name="ValidationPoints"
						onclick="openValidationPointsPopUp('<%=myList.get(i).getAccountNumber()%>')"
						style="text-decoration-line: underline; outline: none; cursor: pointer; border: none; background-color: transparent; color: black; font-size: 16px;">

						<input type="hidden" id="OpenValidationPoints" value=""
						name="OpenValidationPoints">
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
							if (myList.get(i).getReservedTcNo() != null && !myList.get(i).getReservedTcNo().equalsIgnoreCase("") 
							&& myList.get(i).getReservedBy() != null && !myList.get(i).getReservedBy().equalsIgnoreCase("") )
							{
						%> <input style="width: 100px; font-size: 15px;" type="text"
						class="TestCaseId" autocomplete="off" disabled="disabled"
						name="TestCaseId<%out.print(i);%>"
						id="TestCaseId<%out.print(i);%>"
						value=" <%out.print(myList.get(i).getReservedTcNo().concat(" ( ").concat(myList.get(i).getReservedBy().concat(")")));%>" />
						<%
							}
							else if (myList.get(i).getReservedTcNo() != null && !myList.get(i).getReservedTcNo().equalsIgnoreCase(""))
							
							{
						%> <input style="width: 100px; font-size: 15px;" type="text"
						class="TestCaseId" autocomplete="off" disabled="disabled"
						name="TestCaseId<%out.print(i);%>"
						id="TestCaseId<%out.print(i);%>"
						value=" <%out.print(myList.get(i).getReservedTcNo());%>" /> <%
							}
							else
							{
						%> <input style="width: 100px; font-size: 15px;" type="text"
						class="TestCaseId" autocomplete="off"
						onkeypress="return checkInputValues(event)"
						name="TestCaseId<%out.print(i);%>"
						id="TestCaseId<%out.print(i);%>" onkeyup="enableProvision();" />

						<%} %>
					</td>
					<td
						style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-family: serif; padding: 5px; padding-left: 5px;">
						<%
							if (myList.get(i).getPhase() != null && !myList.get(i).getPhase().equalsIgnoreCase(""))
							{
						%> <input style="width: 100px; font-size: 15px;" type="text"
						class="Phase" autocomplete="off" disabled="disabled"
						title="<%out.print(myList.get(i).getPhase());%>"
						name="Phase<%out.print(i);%>" id="Phase<%out.print(i);%>"
						value=" <%out.print(myList.get(i).getPhase());%>" /> <%
							}
							else
							{
						%> <select style="width: 100px; font-size: 15px;" class="Phase"
						name="Phase<%out.print(i);%>" id="Phase<%out.print(i);%>"
						onchange="enableProvision();">
							<option value="">Please Select</option>
							<option value="FDT1">FDT1</option>
							<option value="FDT2">FDT2</option>
					</select> <%
							}
						%>

					</td>
					<td
						style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-family: serif; padding: 5px; padding-left: 5px;">
						<%
							if (myList.get(i).getBPA() != null && !myList.get(i).getBPA().equalsIgnoreCase(""))
							{
						%> <input style="width: 100px; font-size: 15px;" type="text"
						class="BPA" autocomplete="off" disabled="disabled"
						title="<%out.print(myList.get(i).getBPA());%>"
						name="BPA<%out.print(i);%>" id="BPA<%out.print(i);%>"
						value=" <%out.print(myList.get(i).getBPA());%>" /> <%
							}
							else
							{
						%> <select style="width: 100px; font-size: 15px;" class="BPA"
						name="BPA<%out.print(i);%>" id="BPA<%out.print(i);%>"
						onchange="enableProvision();">
							<option value="">Please Select</option>
							<option value="Account Opening">Account Opening</option>
							<option value="Arrears Management">Arrears Management</option>
							<option value="Billing and Statement Generation">Billing
								and Statement Generation</option>
							<option value="Create and Market Customer Offer">Create
								and Market Customer Offer</option>
							<option value="Customer and Account Management">Customer
								and Account Management</option>
							<option value="Insurance">Insurance</option>
							<option value="Make and Process Payments">Make and
								Process Payments</option>
							<option value="MI Zeus">MI Zeus</option>
							<option value="Miscellaneous">Miscellaneous</option>
							<option value="Order Management">Order Management</option>
					</select> <%
							}
						%>

					</td>

				</tr>
				<%
					}
						}
				%>
			</table>
			<%
				}
				else
				{
			%>
			<p style="font-size: 22px; margin-left: 20%; margin-top: 10%;">
				<c:out value="${MessageDetails}"></c:out>
			</p>
			<%
				}
			%>

		</div>

		<%
			if (request.getAttribute("AllColumnsDisplay") != null)
			{
		%>
		<div id="AllColumnsDisplay"
			style="background-size: auto; background: lightgray; overflow: auto; border: 5px solid black; top: 3%; left: 5%; width: 90%; height: 90%; position: fixed; display: block;">
			<div>
				<c:forEach items="${AllColumnsDisplay}" var="accDetail"
					varStatus="counter">
					<ul style="list-style: none; margin-bottom: 10px;">
						<li
							style="width: 250px; float: left; font-size: 16px; font-family: serif; padding: 10px 40px; display: inline-block;"><span
							style="color: black"><c:out
									value="${accDetail.columnName}"></c:out> <br /></span><span
							style="color: teal"> <c:out
									value="${accDetail.columnType}"></c:out></span></li>
					</ul>

				</c:forEach>

			</div>

			<table style="width: 100%;">
				<tr>
					<td style="line-height: 66px; text-align: center; width: 100%;"><input
						type="submit" name="Close" id="closeButton" value="Close"
						onclick="return hidePopup('AllColumnsDisplay');"
						style="border: none; color: black; padding: 7px 7px; outline: none; font-size: 18px; border-radius: 5px; width: 75px;" /></td>
				</tr>
			</table>
		</div>
		<%
			}
		%>

		<%
			if (request.getAttribute("userProvisionedList") != null || request.getAttribute("userProvisionednullList") != null)
			{
		%>
		<div id="userProvisionedList"
			style="background-size: auto; background: lightgray; overflow: auto; border: 5px solid black; top: 3%; left: 31%; width: 40%; height: 90%; position: fixed; display: block;">
			<div>
				<%
					ArrayList<AccountDetails> myList = new ArrayList<AccountDetails>();
						myList = (ArrayList) request.getAttribute("userProvisionedList");
						if (null != myList && !myList.isEmpty())
						{
				%>
				<table
					style="margin-top: 3%; width: 90%; margin-left: 5%; margin-right: 5%; border: 1px solid black;">

					<tr
						style="background-color: darkgrey; color: white; text-align: left;">
						<td
							style="width: 10%; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							Choose</td>
						<td
							style="width: 10%; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							Account Number</td>
						<td
							style="width: 10%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							Brand</td>
						<td
							style="width: 10%; border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							Account Status</td>
						<td
							style="width: 10%; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							Reserved Tc No</td>
						<td
							style="width: 10%; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
							Reserved Date</td>
					</tr>
					<%
						for (int i = 0; i < myList.size(); i++)
								{
					%>
					<tr>
						<td
							style="text-align: center; color: black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">

							<input style="width: 30%; height: 80%;" type="checkbox"
							name="checkboxes" id="checkbox(<%out.print(i);%>)"
							onclick="enableProvision();" />
						</td>
						<td
							style="text-align: center; color: black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
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
								out.println(myList.get(i).getAccountStatus());
							%>
						</td>

						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
							<%
								out.println(myList.get(i).getReservedTcNo());
							%>
						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
							<%
								out.println(myList.get(i).getReservedDate());
							%>
						</td>
					</tr>
					<%
						}
							}
							else
							{
					%>
					<p style="text-align: center; font-size: 22px; margin-top: 10%;">
						No Data Provisioned</p>

					<%
						}
					%>
				</table>

			</div>

			<table style="width: 100%;">
				<tr>
					<td style="line-height: 66px; text-align: center; width: 100%;"><input
						type="submit" name="Close" id="closeButton" value="Close"
						onclick="return hidePopup('userProvisionedList');"
						style="border: none; color: black; padding: 7px 7px; outline: none; font-size: 18px; border-radius: 5px; width: 75px;" /></td>
				</tr>
			</table>
		</div>
		<%
			}
		%>

		<%
			if (request.getAttribute("ValidationDisplay") != null)
			{
		%>

		<div id="ValidationDisplay"
			style="background-size: auto; background: lightgray; overflow: auto; border: 5px solid black; top: 3%; left: 20%; width: 60%; height: 90%; position: fixed; display: block;">

			<div style="text-align: center; font-size: 20px; padding-top: 20px;">

				<table style="width: 100%;">
					<tr>
						<td style="padding-right: 20px; width: 60%; text-align: right;">Account
							Level</td>
						<td style="text-align: right; padding-right: 7%;"><a
							href="http://10.164.93.60:7003/ANext/ETLOnlineLogin.jsp"
							style="font-size: 18px; color: blue;" id="Link tp MDT"
							target="_blank"> Link To MDT</a></td>
				</table>

			</div>

			<div class="limiter" id="accountLevelDiv">
				<%
					if (null != request.getAttribute("showValidationAccountDetails"))
						{
				%>

				<div>
					<table
						style="width: 90%; margin-left: 5%; margin-right: 5%; border: 1px solid black;">
						<thead>
							<tr>
								<th
									style="text-align: left; color: black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; width: 25%;">Component</th>
								<th
									style="border-left: 1px solid black; text-align: left; color: black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; width: 25%">Attribute</th>
								<th
									style="border-left: 1px solid black; text-align: left; color: black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; width: 25%">Previous
									Value</th>
								<th
									style="border-left: 1px solid black; text-align: left; color: black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; width: 25%">New
									Value</th>

							</tr>
						</thead>
						<tbody>
							<c:forEach items="${accountDetailsSingleList}" var="accDetail"
								varStatus="counter">
								<tr>
									<td
										style="text-align: left; color: black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;"><c:out
											value="${accDetail.component}"></c:out></td>
									<td
										style="border-left: 1px solid black; text-align: left; color: black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;"><c:out
											value="${accDetail.attributeName}"></c:out></td>
									<td
										style="border-left: 1px solid black; text-align: left; color: black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;"><c:out
											value="${accDetail.previousValue}"></c:out></td>
									<td
										style="border-left: 1px solid black; text-align: left; color: black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;"><c:out
											value="${accDetail.newValue}"></c:out></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>

				<%
					}
				%>
			</div>
			<div>

				<div style="text-align: center; font-size: 20px; padding-top: 20px;">
					<a href="" style="text-decoration: none; color: black"
						id="orderLevel" onclick="return expandOrderDiv();"> Order
						Level</a>
				</div>
				<div class="limiter" id="orderLevelDiv">
					<%
						if (null != request.getAttribute("showValidationOrderDetails"))
							{
					%>
					<div class="container-table100">

						<table
							style="width: 90%; margin-left: 5%; margin-right: 5%; border: 1px solid black;">
							<thead>
								<tr class="table100-head">
									<th
										style="text-align: left; color: black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; width: 25%;">Component</th>
									<th
										style="border-left: 1px solid black; text-align: left; color: black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; width: 25%">Attribute</th>
									<th
										style="border-left: 1px solid black; text-align: left; color: black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; width: 25%">Previous
										Value</th>
									<th
										style="border-left: 1px solid black; text-align: left; color: black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; width: 25%">New
										Value</th>

								</tr>
							</thead>
							<tbody>
								<c:forEach items="${orderDetailsSingleList}" var="accDetail"
									varStatus="counter">
									<tr>
										<td
											style="text-align: left; color: black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;"><c:out
												value="${accDetail.component}"></c:out></td>
										<td
											style="border-left: 1px solid black; text-align: left; color: black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;"><c:out
												value="${accDetail.attributeName}"></c:out></td>
										<td
											style="border-left: 1px solid black; text-align: left; color: black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;"><c:out
												value="${accDetail.previousValue}"></c:out></td>
										<td
											style="border-left: 1px solid black; text-align: left; color: black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;"><c:out
												value="${accDetail.newValue}"></c:out></td>
									</tr>
								</c:forEach>
							</tbody>
						</table>

					</div>
					<%
						}
					%>
				</div>
				<br />
				<table style="width: 100%;">
					<tr>
						<td style="width: 50%; padding-left: 36%;"><input
							type="submit" name="Close" id="closeButton" value="Close"
							onclick="return hidePopup('validationPopupClose');"
							style="text-decoration: unset; border: 1px solid black; background-color: darkslategrey; color: white; padding: 3px;" /></td>
						<%-- <td style="width: 50%; padding-right: 36%; text-align: right;"><input class="button"
							type="submit" name="update" id="updateButton" value="Update" title="update"
							onclick="setValueInRequest('<%=request.getAttribute("orderDetailsSingleList")%>','<%=request.getAttribute("accountDetailsSingleList")%>');"
							style="text-decoration: unset; border: 1px solid black; background-color: darkslategrey; color: white; padding: 3px;" />
							<input type="text" name="acList" id="acList" value=""
							style="display: none" /> <input type="text" name="orList"
							id="orList" value="" style="display: none" /></td> --%>
					</tr>
				</table>
			</div>
		</div>
		<%} %>
	</form>
</body>
</html>