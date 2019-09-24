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
<%@ page import="java.util.*"%>
<link rel="stylesheet" type="text/css" href="css/homePage.css">

<script>

function hidePopup(id)
{
		if(id== 'AllColumnsDisplay')
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
	
	function createButtons() {
		var foo = document.getElementById("foobar");

		var spaceNode = document.createTextNode("  ");
		//create submit button
		var button = document.createElement("input");
		button.setAttribute('type', "submit");
		button.setAttribute('ID', "searchButton");
		button.setAttribute('value', "Search");
		button.setAttribute('name', "searchFilterButton");
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
			var val = "${attribute.secondInputValue}";
			var op = new Option();
			var subAttributes = "${subList}";
			op.value = subAttributes;
			op.text = subAttributes;
			if(op.text == val)
			{
				op.setAttribute("selected", val);
			}
			element.options.add(op);
			</c:forEach>
			element.options.add
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
			firstElement.setAttribute("value", "${attribute.firstInputValue}");
			firstElement.setAttribute("select", "input");
			var lbl = document.createElement('label'); // CREATE LABEL.
			lbl.setAttribute('for', 'prodName');
			lbl.appendChild(document.createTextNode('k'));
			cell2.appendChild(firstElement);
			cell2.appendChild(output);
		} else if (attributeType === 'Date') {
			var element = document.createElement("input");
			element.style.width = "125px";
			element.title = "Date Format: YYYY-MM-DD";
		}

		//Assign different attributes to the element.
		element.setAttribute("type", attributeType);
		element.setAttribute('id', attributeName);
		element.setAttribute("name", attributeName);
		element.setAttribute("value", "${attribute.secondInputValue}");
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
<body onload="createButtons();onload();"
	style="background-size: auto; background: url(./img/background.jpg)">
	<form action="FilterAccountServlet" method="post"
		onsubmit="validateInputFields();">
		<div id="foobar" style="padding-right: 1%; padding: 1%; width: 20%;"></div>
		<jsp:include page="Provisioning.jsp"></jsp:include>

	</form>
</body>
</html>