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
<%@ page import="common.*"%>
<%@ page import="java.util.*"%>
<link rel="stylesheet" type="text/css" href="css/jquery.multiselect.css">
<link rel="stylesheet" type="text/css" href="css/style.css">

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
	function onload() {
<%if (null != request.getAttribute("SingleView")) {%>
	document.getElementById('foobar').style.opacity = '0.1';
		document.getElementById('accountDetails').style.opacity = '0.1';
<%} else {%>
	document.getElementById('foobar').style.opacity = '1';
		document.getElementById('accountDetails').style.opacity = '1';
<%}%>
	}

	function setValueInRequest(orderList, accountList) {
		document.getElementById('acList').value = accountList;
		document.getElementById('orList').value = orderList;
	}

	function hidePopup() {
		document.getElementById('compliancePopUp').style.display = "none";
		document.getElementById('foobar').style.opacity = '1';
		document.getElementById('accountDetails').style.opacity = '1';
		return false;
	}
	function refresh() {
		history.pushState(null, null, location.href);
		window.onpopstate = function() {
			history.go(1);
		};
	}
	function createButtons() {
		var foo = document.getElementById("foobar");

		var spaceNode = document
				.createTextNode("  ");
		//create submit button
		var button = document.createElement("input");
		button.setAttribute('type', "submit");
		button.setAttribute('ID', "searchButton");
		button.setAttribute('value', "Search");
		button.setAttribute('name', "searchButton");
		button.style.border = "none";
		button.style.color = "black";
		button.style.backgroundcolor = "black";
		button.style.padding = "10px 20px";
		button.style.outline = "none";
		button.style.fontSize = "18px";
		button.style.borderRadius = "10px";
		button.style.width = "40%";
		
		
		var backbutton = document.createElement("input");
		backbutton.setAttribute('type', "submit");
		backbutton.setAttribute('ID', "BackButton");
		backbutton.setAttribute('value', "Back");
		backbutton.setAttribute('name', "BackButton");
		backbutton.style.border = "none";
		backbutton.style.color = "black";
		backbutton.style.backgroundcolor = "black";
		backbutton.style.padding = "10px 20px";
		backbutton.style.outline = "none";
		backbutton.style.fontSize = "18px";
		backbutton.style.borderRadius = "10px";
		backbutton.style.width = "40%";

		//create table
		var mainDiv = document.createElement("div");
		mainDiv.style.width = "100%";
		var mainTable = document.createElement("table");
		mainTable.style.width = "100%";
		var mainRow1 = mainTable.insertRow(0);
		var mainNode1 = document
				.createTextNode("Please select the corresponding values");
		var mainCell1 = mainRow1.insertCell(0);
		mainCell1.style.width = "60%";
		mainCell1.style.color = "black";
		mainCell1.style.fontSize = "20px";
		mainCell1.appendChild(mainNode1);
		var mainRow2 = mainTable.insertRow(1);
		var mainNode2 = document.createTextNode(".");
		var mainCell2 = mainRow2.insertCell(0);
		mainCell2.style.width = "60%";
		mainCell2.style.color = "black";
		mainCell2.style.visibility = "hidden";
		mainCell2.appendChild(mainNode2);
		mainDiv.appendChild(mainTable);
		foo.appendChild(mainDiv);

		//create no of records attribute
		var recordDiv = document.createElement("div");
		recordDiv.style.width = "100%";
		var recordTable = document.createElement("table");
		recordTable.style.width = "100%";
		var mainRecordRow1 = recordTable.insertRow(0);
		var mainTableNode1 = document.createTextNode("Number of Records:");
		var mainTableCell1 = mainRecordRow1.insertCell(0);
		mainTableCell1.style.width = "60%";
		mainTableCell1.style.color = "red";
		mainTableCell1.style.fontSize = "20px";
		mainTableCell1.appendChild(mainTableNode1);
		var mainTableCell2 = mainRecordRow1.insertCell(1);
		var CellElement = document.createElement("input");
		CellElement.style.width = "125px";
		CellElement.setAttribute("type", "noOfRecords");
		CellElement.setAttribute('id', "noOfRecords");
		CellElement.setAttribute("name", "noOfRecords");
		CellElement.setAttribute("select", "noOfRecords");
		CellElement.setAttribute("value", "100");
		var lbl = document.createElement('label'); // CREATE LABEL.
		lbl.setAttribute('for', 'prodName');
		lbl.appendChild(document.createTextNode('k'));
		mainTableCell2.appendChild(CellElement);
		var mainRecordRow2 = recordTable.insertRow(1);
		var maiTableNode2 = document.createTextNode(".");
		var mainTableCell22 = mainRecordRow2.insertCell(0);
		mainTableCell22.style.width = "60%";
		mainTableCell22.style.color = "black";
		mainTableCell22.style.visibility = "hidden";
		mainTableCell22.appendChild(maiTableNode2);
		recordDiv.appendChild(recordTable);
		foo.appendChild(recordDiv);

		//loop on the fields in xml to create dymanic fields
		<c:forEach items="${categoryList}" var="attribute" varStatus="counter">
		var attributeType = "${attribute.attributeType}";
		var attributeName = "${attribute.attributeName}";
		var attributeNae = "${attribute.subAttributesList}";
		var id = "Input${counter.count}";
		//Create an input type dynamically.
		var para = document.createElement("div");
		para.style.width = "100%";
		//para.style.padding-bottom = "1%";

		var span = document.createElement("table");
		span.style.width = "100%";

		var row = span.insertRow(0);
		var node = document
				.createTextNode("${attribute.attributeName}" + " : ");
		var cell1 = row.insertCell(0);
		cell1.style.width = "60%";
		cell1.style.color = "black";
		cell1.style.fontSize = "18px";
		var cell2 = row.insertCell(1);
		cell1.appendChild(node);

		var row2 = span.insertRow(1);
		var node2 = document.createTextNode(".");
		var cell21 = row2.insertCell(0);
		cell21.style.width = "60%";
		cell21.style.color = "black";
		var cell22 = row2.insertCell(1);
		cell21.style.visibility = "hidden";
		cell21.appendChild(node2);

		if (attributeType === 'DropDown') {
			var element = document.createElement("select");
			element.style.width = "130px";
			<c:forEach items="${attribute.subAttributesList}" var="subList" varStatus="counter">
			var op = new Option();
			var subAttributes = "${subList}";
			op.value = subAttributes;
			op.text = subAttributes;
			element.options.add(op);
			</c:forEach>
			element.setAttribute("value", attributeType);
		} else if (attributeType === 'Input') {
			var element = document.createElement("input");
			element.style.width = "125px";
		} else if (attributeType === 'Label') {
			var element = document.createElement("input");
			var output = document.createTextNode(" - ");
			element.style.width = "40px";
			var firstElement = document.createElement("input");
			firstElement.style.width = "40px";
			firstElement.setAttribute("type", "input");
			firstElement.setAttribute('id', attributeName);
			firstElement.setAttribute("name", attributeName);
			firstElement.setAttribute("select", "input");
			var lbl = document.createElement('label'); // CREATE LABEL.
			lbl.setAttribute('for', 'prodName');
			lbl.appendChild(document.createTextNode('k'));
			cell2.appendChild(firstElement);
			cell2.appendChild(output);
		} else if (attributeType === 'Date') {
			var element = document.createElement("input");
			element.style.width = "125px";
			element.title = "Date Format: dd/mm/yyyy";
		}

		//Assign different attributes to the element.
		element.setAttribute("type", attributeType);
		element.setAttribute('id', attributeName);
		element.setAttribute("name", attributeName);
		element.setAttribute("select", attributeType);
		var lbl = document.createElement('label'); // CREATE LABEL.
		lbl.setAttribute('for', 'prodName');
		lbl.appendChild(document.createTextNode('k'));
		cell2.appendChild(element);
		para.appendChild(span);
		foo.appendChild(para);
		//foo.appendChild(element);

		</c:forEach>

		foo.appendChild(button);
		foo.appendChild(spaceNode);
		foo.appendChild(backbutton);
	}

	function validateInput() {
		<c:forEach items="${categoryList}" var="attribute" >

		var attributeName = "${attribute.attributeName}";
		var inputElement = document.getElementById(attributeName);
		if (inputElement.value == '') {
			alert("Please enter all the fields.");
			return false;
		}
		</c:forEach>
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

	function enableProvision() {

		var checkboxes = document.getElementsByName("checkboxes");
		var checkboxArray = [];
		var textValue = document.getElementsByClassName("TestCaseId");
		var bool = true;
		for (var i = 0; i < checkboxes.length; i++) {

			if (checkboxes[i].checked && textValue[i].value == '') {
				bool = false;
				break;
			}
			if (textValue[i].value != '' && !checkboxes[i].checked) {
				bool = false;
				break;
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
	
	
</script>
</head>
<body onload="createButtons();onload();"
	style="background-size: auto; background: url(./img/3.jpg);">

	<form action="SearchAccountServlet" method="post"
		onsubmit="validateInputFields();">
		<div id="foobar" style="padding-right: 1%; padding: 1%; width: 20%;"></div>

		<!--  <input
			type="submit" name="searchButton" id="searchButton"
			style="border: none; margin-left: 41%; margin-top: 2%; cursor: pointer; background-color: cadetblue; color: white; font-family: serif; outline: none; font-size: 25px; padding: 3px; border-radius: 22px; width: 10%;"
			value="Search"> <br /> -->


		<div id="accountDetails"
			style="overflow-y: auto; overflow-x: auto; position: fixed; float: right; width: 72%; margin-left: 26%; top: 5%; min-height: 100px; max-height: 90%">
			<%
				ArrayList<AccountDetails> accList = (ArrayList<AccountDetails>) session.getAttribute("accountDetailsList");
				String databaseUpdatedFlag = (String) session.getAttribute("databaseUpdatedFlag");

				if (null != accList && !accList.isEmpty() && databaseUpdatedFlag.equals("false"))
				{
			%>
			<table id="tabledata"
				style="overflow: auto; height: 90%; border: 1px solid black; width: 100%;">
				<tr>
					<td colspan="6"
						style="font-size: 18px; font-family: serif; padding: 5px; padding-left: 5px; color: white;">
						<label style="font-size: 18px; font-family: serif; color: black;">
							Total number of records found:</label> <label
						style="font-size: 20px; font-family: serif; color: black;">
							${totalNumberOfRecords}</label>

					</td>
					<td colspan="3"><input type="submit" name="ProvisionButton"
						id="ProvisionButton" disabled
						style="border: none; margin-left: 57%; width: 24%; cursor: pointer; color: black; font-family: serif; outline: none; font-size: 22px; padding: 3px; border-radius: 8px;"
						value="Provision"> <br /></td>
				</tr>
				<tr
					style="background-color: darkgrey; color: white; text-align: left;">
					<td
						style="font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
						Choose</td>
					<td
						style="border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
						Account Number</td>
					<td
						style="border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
						Principal Brand</td>
					<td
						style="border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
						Account Type</td>
					<td
						style="border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
						Next Statement Date</td>
					<td
						style="border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
						OTB</td>
					<td
						style="border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
						Current AIR</td>
					<td
						style="border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
						Credit Limit</td>
					<td
						style="border-left: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px; border-top: 1px solid black; color: black;">
						Test Case No.</td>
				</tr>

				<c:forEach items="${accountDetailsList}" var="accountDetail"
					varStatus="counter">
					<tr>
						<td
							style="text-align: center; color: black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
							<input style="width: 30%; height: 80%;" type="checkbox"
							name="checkboxes" id="checkbox${counter.count}"
							onclick="enableProvision();" />

						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">

							<input type="submit" id="signin"
							value="${accountDetail.accountNumber}"
							onmouseout="showPopup(this.id);"
							onclick="return ValidateAttributes(this.id);"
							name="Account Number"
							style="text-decoration-line: underline; outline: none; cursor: pointer; border: none; background-color: transparent; color: black; font-size: 16px;">

						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
							<c:out value="${accountDetail.brand}"></c:out>
						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
							<c:out value="${accountDetail.accountType}"></c:out>
						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
							<c:out value="${accountDetail.next_statement_date}"></c:out>
						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
							<c:out value="${accountDetail.OTB}"></c:out>
						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
							<c:out value="${accountDetail.air}"></c:out>
						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-size: 16px; font-family: serif; padding: 5px; padding-left: 5px;">
							<c:out value="${accountDetail.creditLimit}"></c:out>
						</td>
						<td
							style="color: black; border-left: 1px solid black; border-top: 1px solid black; font-family: serif; padding: 5px; padding-left: 5px;">
							<input style="font-size: 15px;" type="text" class="TestCaseId"
							name="TestCaseId${counter.count}" id="TestCaseId${counter.count}"
							onkeyup="enableProvision();" />
						</td>
					</tr>
				</c:forEach>
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
			<input type="hidden" name="accountSelected" id="accountSelected"
				value="" />
		</div>
		<%
			if (request.getAttribute("SingleView") != null)
			{
		%>

		<div id="compliancePopUp"
			style="background-size: auto; background: url(./img/3.jpg); overflow: auto; border: 5px solid black; top: 3%; left: 20%; width: 60%; height: 90%; position: fixed; display: block;">

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
					if (null != request.getAttribute("showAccountDetails"))
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
						if (null != request.getAttribute("showOrdersDetails"))
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
								<c:forEach items="${orderDetailsList}" var="accDetail"
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
							onclick="return hidePopup();"
							style="text-decoration: unset; border: 1px solid black; background-color: darkslategrey; color: white; padding: 3px;" /></td>
						<td style="width: 50%; padding-right: 36%; text-align: right;"><input class="button"
							type="submit" name="update" id="updateButton" value="Update" onmouseover="hello" 
							onclick="setValueInRequest('<%=request.getAttribute("orderDetailsList")%>','<%=request.getAttribute("accountDetailsList")%>');"
							style="text-decoration: unset; border: 1px solid black; background-color: darkslategrey; color: white; padding: 3px;" />
							<input type="text" name="acList" id="acList" value=""
							style="display: none" /> <input type="text" name="orList"
							id="orList" value="" style="display: none" /></td>
					</tr>
				</table>
			</div>
		</div>
		<%} %>
	</form>
</body>
</html>