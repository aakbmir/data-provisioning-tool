<!DOCTYPE html>
<html lang="">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Title Page</title>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet" type="text/css" href="css/jquery.multiselect.css">
<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="css/userOptions.css">
<script src="js/jquery.multiselect.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/jquery.min.js"></script>
<style>
card::hover 
{
	background:cadetblue;
}</style>
<script type="text/javascript">
	// run pre selected options
	$('#pre-selected-options').multiSelect();
</script>
<script type="text/javascript">
	function displayCriteria(selectedId) {
	
		if (selectedId == "FilterCardSection") {
			document.getElementById('SearchCriteria').style.display = 'none';
			document.getElementById('ConsumptionCriteria').style.display = 'none';
			document.getElementById('FilterCriteria').style.display = 'block';
			document.getElementById('ConsumptionCardSection').style.display = 'none';
			document.getElementById('FilterCardSection').style.display = 'none';
			document.getElementById('SearchCardSection').style.display = 'none';
			document.getElementById('UnprovisionCardSection').style.display = 'none';
			
		} else if (selectedId == "SearchCardSection") {
			document.getElementById('SearchCriteria').style.display = 'block';
			document.getElementById('ConsumptionCriteria').style.display = 'none';
			document.getElementById('FilterCriteria').style.display = 'none';
			document.getElementById('ConsumptionCardSection').style.display = 'none';
			document.getElementById('FilterCardSection').style.display = 'none';
			document.getElementById('SearchCardSection').style.display = 'none';
			document.getElementById('UnprovisionCardSection').style.display = 'none';
		}
		else if (selectedId == "ConsumptionCardSection") {
			document.getElementById('SearchCriteria').style.display = 'none';
			document.getElementById('ConsumptionCriteria').style.display = 'block';
			document.getElementById('FilterCriteria').style.display = 'none';
			document.getElementById('ConsumptionCardSection').style.display = 'none';
			document.getElementById('FilterCardSection').style.display = 'none';
			document.getElementById('SearchCardSection').style.display = 'none';
			document.getElementById('UnprovisionCardSection').style.display = 'none';
		}
		else if (selectedId == "UnprovisionCardSection") {
			document.getElementById('SearchCriteria').style.display = 'none';
			document.getElementById('ConsumptionCriteria').style.display = 'none';
			document.getElementById('FilterCriteria').style.display = 'none';
			document.getElementById('ConsumptionCardSection').style.display = 'none';
			document.getElementById('FilterCardSection').style.display = 'none';
			document.getElementById('SearchCardSection').style.display = 'none';
			document.getElementById('UnprovisionCardSection').style.display = 'none';
			document.getElementById('unprovisionButton').click();
			
		}
	}

	function resetValues()
	{
		document.getElementById('FilterCriteria').style.display = 'none';
		document.getElementById('SearchCriteria').style.display = 'none';
		document.getElementById('ConsumptionCriteria').style.display = 'none';
		
		document.getElementById('AccountErrorMsg').style.display = 'none';
		document.getElementById('FilterErrorMsg').style.display = 'none';
		document.getElementById('ConsumptionAccountErrorMsg').style.display = 'none';
		
		document.getElementById('FilterCardSection').style.display = 'block';
		document.getElementById('SearchCardSection').style.display = 'block'; 
		document.getElementById('ConsumptionCardSection').style.display = 'block';
		document.getElementById('UnprovisionCardSection').style.display = 'block';
		
		return false;
	}
	
	function clearValues(){
		document.getElementById('ConsumptionAccountNumberText').value='';
		document.getElementById('SearchAccountNumberText').value='';
	}

	function categorySelected() {
		var ddlFruits = document.getElementById('pre-selected-options');
		if (null != ddlFruits.options[ddlFruits.selectedIndex]
				&& null != ddlFruits.options[ddlFruits.selectedIndex].innerHTML) {
			return true;
		} else {
			document.getElementById('FilterErrorMsg').style.display = 'block';
			return false;
		}
	}

	function validateInput(selectedId)
	{
		
		var textEntered;
		if (selectedId == "searchSubmit") 
		{
			textEntered = document.getElementById('SearchAccountNumberText').value;
		}
		else if (selectedId == "ConsumptionSubmit") 
		{
			textEntered = document.getElementById('ConsumptionAccountNumberText').value;
		}
		if( textEntered.length == 0)
		{
			if (selectedId == "searchSubmit") 
			{
				document.getElementById('AccountErrorMsg').style.display = 'block';
			}
			else if (selectedId == "ConsumptionSubmit") 
			{
				document.getElementById('ConsumptionAccountErrorMsg').style.display = 'block';
			}
			return false;
		}
		var err;
		var code,i,len;
		
		for(i=0,len=textEntered.length;i<len;i++)
		{
			code = textEntered.charCodeAt(i);
			if(code==10 || code==59 || (code > 47 && code < 58) || (code > 64 && code < 91) || (code > 96 && code < 123))
			{
				
			}
			else
			{
				if (selectedId == "searchSubmit") 
				{
					document.getElementById('AccountErrorMsg').style.display = 'block';
				}
				else if (selectedId == "ConsumptionSubmit") 
				{
					document.getElementById('ConsumptionAccountErrorMsg').style.display = 'block';
				}
				err='error';
			}
		}

		if(err == 'error')
		{
			return false;
		}
/* 		if (textEntered.length == 0) {
			document.getElementById('AccountErrorMsg').style.display = 'block';
			return false;
		}
		else
		{
			if(/[^a-zA-Z0-9;\r\n]/.test(textEntered))
			{
				document.getElementById('AccountErrorMsg').style.display = 'block';
				return false;
			}
			else
			{
				return true;
			}
		} */
	}

	function refresh() {
		history.pushState(null, null, location.href);
		window.onpopstate = function() {
			history.go(1);
		};
		document.getElementById('pre-selected-options').value = null;

	}

	function onValueSelect() {
		document.getElementById('FilterErrorMsg').style.display = 'none';
	}

	function onload() {
	
		document.getElementById('FilterCriteria').style.display = 'none';
		document.getElementById('SearchCriteria').style.display = 'none';
		document.getElementById('ConsumptionCriteria').style.display = 'none';
		document.getElementById('AccountErrorMsg').style.display = 'none';
		document.getElementById('FilterErrorMsg').style.display = 'none';
		document.getElementById('ConsumptionAccountErrorMsg').style.display = 'none';
	}
</script>
<body onload="refresh();onload();"
	style="background: url(./img/background.jpg);">
	<form autocomplete="off" action="FilterAccountServlet" method="post">
	<div
		style="width:75%;left: 25%;position: relative;padding: 10px;">
		<span style="color: Black; font-size:36px;text-align: center; font-family: Garamond;">
			Data Provisioning For Functional Testing</span>
			<input type="submit" value="Log Out" name="Logout" style="float:right;outline: none; background: cadetblue; border: none; color: white; padding: 5px 15px; 
			font-size: 16px; border-radius: 5px;">
	</div>
	</form>
	<div class="">
		<form autocomplete="off" action="FilterAccountServlet" method="post">
			<div id="FilterCardSection"  class="card"
				onclick="displayCriteria(this.id);" onmouseover="this.style.color='black';this.style.background='linear-gradient(to right, rgb(74, 194, 154), rgb(189, 255, 243))';" onmouseout="this.style.color='white';this.style.background='linear-gradient(rgb(29, 67, 80), rgb(136, 76, 80))';" style="box-shadow:10px -10px darkcyan;border-radius:5px;top: 25%;height: 400px;background: linear-gradient(rgb(29, 67, 80), rgb(136, 76, 80));width: 300px;padding: 20px;text-align: center;overflow: hidden;position: absolute;left: 6%;color: white;cursor: pointer;">
					<p style="font-size: 18px;font-weight: bold;height:35%;" >Self-Data Provisioning for accounts based on various filter criteria's</p>
					<div class="image">
						<img src="img/Filter.png" style="border-radius: 50%;width: 100px;">
					</div>
					<div style="top: 10%;position: relative;">
						<h4>
							Filter Accounts Section<br/> <br/> <span style="font-size: 13px;color: aqua;" >Click Here</span>
						</h4>
					</div>
			</div>


			<div id="FilterCriteria">
				<div id="FilterSection"
					style="position: absolute; left: 50%; transform: translate(-50%, -50%); top: 20%; height: 40px; border-radius: 40px; padding: 10px;">
					<h4 id="inputTpe"
						style="color: Black; font-family: Garamond; font-size: 22px; margin-left: 50px;">
						Migrated data filter criteria</h4>
					<select name="category" id='pre-selected-options'
						multiple='multiple'
						style="height: 300px; margin-left: 10%; background-color: #ffff99;width:100%">
						<c:forEach items="${listCategory}" var="category">
							<option
								value="${category.attributeName};${category.attributeType};${category.subAttributesList};${category.tableColumnName}"
								style="height: 25px; font-family: garamond; font-size: 18px;"
								onclick="onValueSelect();">${category.attributeName}</option>
						</c:forEach>
					</select>
				</div>

				<div id="FilterButtonsBar"
					style="text-align: center; position: absolute; left: 51.5%; transform: translate(-50%, -50%); top: 70%; height: 40px; border-radius: 40px; padding: 10px; width: 100%;">
					
					<input type="submit" onclick="return resetValues();" value="Reset"
						style="outline: none; background: cadetblue; border: none; color: white; padding: 13px 25px; font-size: 16px; border-radius: 5px;">
				
					<input type="submit" onclick="return categorySelected();"
						name="FilterSubmitButton" value="Submit"
						style="outline: none; background: cadetblue; border: none; color: white; padding: 13px 25px; font-size: 16px; border-radius: 5px;">
				</div>
				<div
					style="position: absolute; left: 52%; transform: translate(-50%, -50%); top: 85%; height: 40px; border-radius: 40px; padding: 10px;">
					<h4 id="FilterErrorMsg" style="color: red; font-family: Garamond;">Select
						atleast one filter criteria</h4>
				</div>
			</div>
			
	
		</form>
		<form autocomplete="off" action="FilterAccountServlet" method="post">
			<div id="SearchCardSection" class=""
				onclick="displayCriteria(this.id);" onmouseover="this.style.color='black';this.style.background='linear-gradient(to right, rgb(74, 194, 154), rgb(189, 255, 243))';" onmouseout="this.style.color='white';this.style.background='linear-gradient(rgb(29, 67, 80), rgb(136, 76, 80))';" style="box-shadow:10px -10px darkcyan;border-radius:5px;top: 25%;height: 400px;background: linear-gradient(rgb(29, 67, 80), rgb(136, 76, 80));width: 300px;padding: 20px;text-align: center;overflow: hidden;position: absolute;left: 28%;color: white;cursor: pointer;">
					<p style="font-size: 18px;font-weight: bold;height:35%;">Provisioning based on specific account numbers.</p>
					<div class="image">
						<img src="img/Search.png" style="border-radius: 50%;width: 100px;">
					</div>
					<div style="top: 10%;position: relative;">
						<h4>
							Search Accounts Section<br/> <br/><span style="font-size: 13px;color: aqua;">Click Here</span>
						</h4>
					</div>
				
			</div>

			<div id="SearchCriteria">
				<div id="SearchSection"
					style="position: absolute; left: 50%; transform: translate(-50%, -50%); top: 20%; height: 40px; border-radius: 40px; padding: 10px;">
					<h4 id="inputTpe"
						style="color: Black; font-family: Garamond; font-size: 22px; text-align: center">Enter
						Account Numbers and/or Agreement Codes</h4>
					<textarea id="SearchAccountNumberText" name="AccountNumberText"
						placeholder="For multiple Account Numbers/Agreement codes use semiColon(;) eg: 50338031;50338435"
						rows="8" cols="50" style="background-color: #ffff99;width: 450px;height: 160px;"></textarea>
				</div>

				<div id="SearchButtonsBar"
					style="align-items: center;position: absolute;left: 36%;top: 60%;height: 20%;border-radius: 40px;padding: 10px;width: 30%;">
					

					
					
					<input type="submit" onclick="return resetValues();" value="Reset"
						style="width:30%;outline: none; background: cadetblue; border: none; color: white; padding: 13px 25px; font-size: 16px; border-radius: 5px;">
					<input type="button" onclick="return clearValues();" value="Clear"
						style="outline: none; background: cadetblue; border: none; color: white;padding: 13px 25px; font-size: 16px; border-radius: 5px;width:30%;">
					<input type="submit" onclick="return validateInput(this.id);" id="searchSubmit" name="SearchSubmitButton"
						value="Submit" style="width:30%;outline: none; background: cadetblue; border: none; color: white; padding: 13px 25px; font-size: 16px; border-radius: 5px;">
				</div>
				<div
					style="position: absolute; left: 52%; transform: translate(-50%, -50%); top: 70%; height: 40px; border-radius: 40px; padding: 10px;">
					<h4 id="AccountErrorMsg" style="color: red; font-family: Garamond;">Account number is either null or contains characters that are not allowed.</h4>						
				</div>
			</div>
		</form>
		
		<form autocomplete="off" action="ConsumptionAccountServlet" method="post">
			<div id="ConsumptionCardSection" class=""
				onclick="displayCriteria(this.id);" onmouseover="this.style.color='black';this.style.background='linear-gradient(to right, rgb(74, 194, 154), rgb(189, 255, 243))';" onmouseout="this.style.color='white';this.style.background='linear-gradient(rgb(29, 67, 80), rgb(136, 76, 80))';"  style="box-shadow:10px -10px darkcyan;border-radius:5px;top: 25%;height: 400px;background: linear-gradient(rgb(29, 67, 80), rgb(136, 76, 80));width: 300px;padding: 20px;text-align: center;overflow: hidden;cursor: pointer;position: absolute;left: 50%;color: white;">
					<p style="font-size: 18px;font-weight: bold;height:35%;" >Track Consumption of Reserved Accounts</p>
					<div class="image">
						<img src="img/Search.png" style="border-radius: 50%;width: 100px;">
					</div>
					<div style="top: 10%;position: relative;">
						<h4>
							Consumption section<br/> <br/><span style="font-size: 13px;color: aqua;">Click Here</span>
						</h4>
					</div>
			</div>

			<div id="ConsumptionCriteria">
				<div id="ConsumptionSection"
					style="position: absolute; left: 50%; transform: translate(-50%, -50%); top: 20%; height: 40px; border-radius: 40px; padding: 10px;">
					<h4 id="inputTpe"
						style="color: Black; font-family: Garamond; font-size: 22px; text-align: center">Enter
						Account Numbers</h4>
					<textarea id="ConsumptionAccountNumberText" name="AccountNumberText"
						placeholder="For multiple Account Numbers use semiColon(;) eg: 50338031;50338435"
						rows="8" cols="50" style="background-color: #ffff99;"></textarea>
				</div>

				<div id="ConsumptionSearchButtonsBar"
					style="position: absolute;left: 38%;top: 60%;height: 20%;border-radius: 40px;padding: 10px;width: 26%;">
					
					<input type="submit" onclick="return resetValues();" value="Reset"
						style="width: 30%;outline: none;background: cadetblue;border: none;color: white;padding: 13px 25px;font-size: 16px;border-radius: 5px;">
					<input type="button" onclick="return clearValues();" value="Clear"
						style="width: 30%;outline: none;background: cadetblue;border: none;color: white;padding: 13px 25px;font-size: 16px;border-radius: 5px;">
					<input type="submit" onclick="return validateInput(this.id);" id="ConsumptionSubmit"
					name="ConsumptionSearchSubmitButton" value="Submit"
						style="width: 30%;outline: none;background: cadetblue;border: none;color: white;padding: 13px 25px;font-size: 16px;border-radius: 5px;">
				</div>

				<div
					style="position: absolute; left: 52%; transform: translate(-50%, -50%); top: 70%; height: 40px; border-radius: 40px; padding: 10px;">
					<h4 id="ConsumptionAccountErrorMsg" style="color: red; font-family: Garamond;">comp Account number is either null or contains characters that are not allowed.</h4>						
				</div>
			</div>
		</form>
		
		<form autocomplete="off" action="UnprovisionAccountsServlet" method="post">
			<div id="UnprovisionCardSection" class="" 
				onclick="displayCriteria(this.id);" onmouseover="this.style.color='black';this.style.background='linear-gradient(to right, rgb(74, 194, 154), rgb(189, 255, 243))';" onmouseout="this.style.color='white';this.style.background='linear-gradient(rgb(29, 67, 80), rgb(136, 76, 80))';"  style="box-shadow:10px -10px darkcyan;top: 25%;height: 400px;background: linear-gradient(rgb(29, 67, 80), rgb(136, 76, 80));width: 300px;padding: 20px;text-align: center;overflow: hidden;cursor: pointer;position: absolute;left: 72%;color: white;border-radius:5px">
					<p style="font-size: 18px;font-weight: bold;height:35%;" >View provisioned list and Unprovision account numbers</p>
					<div class="image">
						<img src="img/Search.png" style="border-radius: 50%;width: 100px;">
					</div>
					<div style="top: 10%;position: relative;">
						<h4>
							Unprovision section<br/> <br/><span style="font-size: 13px;color: aqua;">Click Here</span>
						</h4>
					</div>
					<input id="unprovisionButton" type="submit" style="display:none" name="unprovision" value="unprovision">
			</div>
		</form>
	</div>
	
</body>
</head>
</html>