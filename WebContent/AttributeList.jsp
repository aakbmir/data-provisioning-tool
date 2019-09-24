<!DOCTYPE html>
<html lang="">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">
<title>Title Page</title>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet" type="text/css" href="css/jquery.multiselect.css">
<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
<script type="text/javascript">
	function categorySelected() 
	{
		var ddlFruits = document.getElementById("pre-selected-options");
		/* var outputFields = document.getElementById("outputFields"); */
		if (null != ddlFruits.options[ddlFruits.selectedIndex]
		&& null != ddlFruits.options[ddlFruits.selectedIndex].innerHTML)
		{
			/* if (null != outputFields.options[outputFields.selectedIndex]
			&& null != outputFields.options[outputFields.selectedIndex].innerHTML)
			{
				return true;
			}
			else
			{
				document.getElementById('errorMsg').style.display = 'block';
				return false;
			} */
			return true;
		}
		else
		{
			document.getElementById('errorMsg').style.display = 'block';
			return false;
		}
	}
	
	function refresh() {
		history.pushState(null, null, location.href);
		window.onpopstate = function() {
			history.go(1);
		};
		document.getElementById('pre-selected-options').value = null;
		document.getElementById('outputFields').value = null;
	}

	function call() {
		var preSelectedOptions = document.getElementById("pre-selected-options");
		var outputFields = document.getElementById("outputFields");
		
	}
</script>
</head>
<body onload="refresh();document.getElementById('errorMsg').style.display='none';"
	style="background-size: auto; background: url(./img/background.jpg);">
	<form action="MTDFTHomeServlet" method="post">
		<div
			style="position: absolute; left: 50%; transform: translate(-50%, -50%); top: 5%; height: 40px; border-radius: 40px; padding: 10px;">
			<h1 style="color: Black; text-align: center; font-family: Garamond;">Migrated
				Data Provisioning For Functional Testing</h1>
		</div>
		<div
			style="position: absolute;left: 50%;transform: translate(-50%, -50%);top: 20%;height: 40px;border-radius: 40px;padding: 10px;">
			<h4 id="inputTpe"
				style="color: Black; font-family: Garamond; font-size: 22px;margin-left:50px;">Migrated data filter criteria</h4>
			<select name="category" id='pre-selected-options' multiple='multiple' style="height:250px;margin-left: 25%;background-color: #ffff99;" >
				<c:forEach items="${listCategory}" var="category">
					<option
						value="${category.attributeName};${category.attributeType};${category.subAttributesList};${category.tableColumnName}"
						style="height:25px;font-family: garamond; font-size: 18px;" onclick="call();">${category.attributeName}</option>
				</c:forEach>
			</select>
		</div>
		<%-- <div  
			style="display:none;position: absolute;left: 65%;transform: translate(-50%, -50%);top: 20%;height: 40px;border-radius: 40px;padding: 10px;">
			<h4 id="inputTpe"
				style="color: Black; font-family: Garamond; font-size: 22px;margin-left:56px;">Output Displayed fields</h4>
			<select name="outputFields" id='outputFields' multiple='multiple' style="height:250px;margin-left: 25%;background-color: #ffff99;" >
				<c:forEach items="${columnsToDisplayList}" var="outputFields">
					<option
						value="${outputFields.columnName};${outputFields.columnFieldName};"
						style="height:25px;font-family: garamond; font-size: 18px;" onclick="call();">${outputFields.columnFieldName}</option>
				</c:forEach>
			</select>
		</div> --%>
		<div
			style="position: relative; margin-left: 64%; transform: translate(-50%, -50%); margin-top: 30%; height: 40px; border-radius: 40px; padding: 10px;">

			<input type="submit" onclick="return categorySelected();"
				style="background: linear-gradient(to right, rgb(29, 67, 80), rgb(136, 76, 80)); border: none; color: white; padding: 15px 32px; text-align: center; text-decoration: none; display: inline-block; font-size: 16px;">
		</div>

		<div
			style="position: absolute; left: 50%; transform: translate(-50%, -50%); top: 70%; height: 40px; border-radius: 40px; padding: 10px;">
			<h4 id="errorMsg" style="color: red; font-family: Garamond;">Please
				select a filter criteria</h4>
		</div>
		<!-- ends -->
		
		<script src="js/jquery.multiselect.js"></script>
		<script src="js/bootstrap.min.js"></script>
		<script src="js/jquery.min.js"></script>
		<script type="text/javascript">
			// run pre selected options
			$('#pre-selected-options').multiSelect();
			$('#outputFields').multiSelect();
		</script>
	</form>
</body>

</html>
