<!DOCTYPE html>
<html lang="">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Title Page</title>
<link rel="stylesheet" type="text/css" href="css/homePage.css">

<style>
select::-ms-expand {
	background-color: rgb(47, 54, 64);
	border: none;
	color: white;
}

::placeholder {
	color: black;
	opacity: 0.8;
	font-size: 14px;
}
</style>
<script type="text/javascript">
	function ForgotUsernameScreen(id) {

		if (id == 'forgotButton') {
			document.getElementById('signInDiv').style.display = 'none';
			document.getElementById('signUpDiv').style.display = 'none';
			document.getElementById('forgotDiv').style.display = 'block';
		} else if (id == 'loginButton') {
			document.getElementById('signInDiv').style.display = 'block';
			document.getElementById('signUpDiv').style.display = 'block';
			document.getElementById('forgotDiv').style.display = 'none';
		}
		return false;
	}

	function refresh() {
		history.pushState(null, null, location.href);
		window.onpopstate = function() {
			history.go(1);
		};
	}

	function ValidateAttributes(id) {

		var fname = new Boolean(true);
		var lname = new Boolean(true);
		var uname = new Boolean(true);
		if (id == "signin") {

			var user = document.getElementById('signInUserName').value;
			if (user.length == 0) {
				document.getElementById('userNameSignInError').style.display = 'block';
				fname = false;
			} else {
				document.getElementById('userNameSignInError').style.display = 'none';
				fname = true;
			}
		} else if (id = "signup") {

			var firstName = document.getElementById('firstName').value;
			var lastName = document.getElementById('lastName').value
			var userName = document.getElementById('SignUpUserName').value;

			if (firstName.length == 0) {
				document.getElementById('FirstNameError').style.visibility = 'visible';
				fname = false;
			} else {
				document.getElementById('FirstNameError').style.visibility = 'hidden';
				fname = true;
			}

			if (lastName.length == 0) {
				document.getElementById('LastNameError').style.visibility = 'visible';

				lname = false;
			} else {
				document.getElementById('LastNameError').style.visibility = 'hidden';
				lname = true;
			}

			if (userName.length == 0) {
				document.getElementById('SignUpUserNameError').style.visibility = 'visible';
				uname = false;
			} else {
				document.getElementById('SignUpUserNameError').style.visibility = 'hidden';
				uname = true;
			}
		}

		if (fname == true) {
			if (lname == true) {
				if (uname == true) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	function Clear() {
		document.getElementById('FirstNameError').style.visibility = 'hidden';
		document.getElementById('LastNameError').style.visibility = 'hidden';
		document.getElementById('SignUpUserNameError').style.visibility = 'hidden';
		document.getElementById('userNameSignInError').style.display = 'none';
	}

	function onload() {
		document.getElementById('forgotUsername').disabled = true;
<%if (null != request.getAttribute("retrievedUsername")) {%>
	document.getElementById('signInDiv').style.display = 'none';
		document.getElementById('signUpDiv').style.display = 'none';
		document.getElementById('forgotDiv').style.display = 'block';
<%} else {%>
	document.getElementById('forgotDiv').style.display = 'none';
		document.getElementById('signInDiv').style.display = 'block';
		document.getElementById('signUpDiv').style.display = 'block';
<%}%>
	}

	function enableContinueButton() {

		var firstName = document.getElementById('forgetfirstName').value;
		var lastName = document.getElementById('forgetlastName').value;
		if (firstName.length > 0 && lastName.length > 0) {
			document.getElementById('forgotUsername').disabled = false;
			document.getElementById('forgotUsername').style.backgroundColor = 'aquamarine';
		} else {
			document.getElementById('forgotUsername').disabled = true;
			document.getElementById('forgotUsername').style.backgroundColor = 'transparent';
		}
	}
</script>
</head>

<body onload="onload();refresh();Clear();"
	style="background: linear-gradient(to right, rgb(74, 194, 154), rgb(189, 255, 243));">

	<div
		style="bottom: 10%; top: 5%; border-radius: 15px; position: absolute; height: 90%; width: 80%;">
		<input type="submit" style="display: none" id="hiddenbutton"
			name="nameLogin">
		<div style="border-radius: 50%;border-right: 60px solid aquamarine;width: 52%;position: absolute;height: 60%;top: 16%;">
			<div style="text-shadow: 4px 4px darkcyan;padding-top:30px;padding-right:130px;font-size:64px;color: cornsilk; text-align: right; font-family: Garamond;">Welcome to</div>
				<br/>
			<div style="text-shadow: 4px 4px darkcyan;padding-right:130px;font-size:64px;color: cornsilk; text-align: right; font-family: Garamond;">Data Provisioning</div>
			<br/>
			<div style="text-shadow: 4px 4px darkcyan;padding-right:130px;font-size:64px;color: cornsilk; text-align: right; font-family: Garamond;">For Functional</div>
			<br/>
			<div style="text-shadow: 4px 4px darkcyan;padding-right:130px;font-size:64px;color: cornsilk; text-align: right; font-family: Garamond;">Testing</div>
		</div>
		<form autocomplete="off" action="RegisterServlet" method="post">
			<div id="signUpDiv"
				style="top: 35%;border-radius: 10px;background-color: cadetblue;float: left;width: 45%;position: absolute;height: 55%;padding: 10px;left: 75%;text-align: center;display: block;">

				<table style="width: 60%;position: absolute;left: 3%;">
					<tr>
						<td
							style="text-align: left; font-size: 18px; font-weight: bold; line-height: 65px;"><span
							style="color: white">New User?</span></td>
					</tr>
					<tr>
						<td style="text-align: left;"><input autocomplete="off"
							type="text" id="firstName" name="firstName"
							style="outline: none; border-radius: 5px; border: none; height: 35px; width: 100%; background-color: cornsilk; color: black; padding: 0px 6px; font-size: 16px;"
							placeholder="First Name"></td>
					</tr>
					<tr>
						<td style="text-align: left;height:35px"><span id="FirstNameError"
							style="line-height: 1px; color: yellow"> * First Name is required</span></td>
					</tr>
					<tr>
						<td style="text-align: left;"><input autocomplete="off"
							type="text" id="lastName" name="lastName"
							style="outline: none; border-radius: 5px; border: none; height: 35px; width: 100%; background-color: cornsilk; color: black; padding: 0px 6px; font-size: 16px;"
							placeholder="Last Name"></td>
					</tr>
					<tr>
						<td style="text-align: left;height:35px"><span id="LastNameError"
							style="line-height: 1px; color: yellow">* Last Name is required
								</span></td>
					</tr>
					<tr>
						<td style="text-align: left;"><input autocomplete="off"
							type="text" id="SignUpUserName" name="SignUpUserName"
							style="outline: none; border-radius: 5px; border: none; height: 35px; width: 100%; background-color: cornsilk; color: black; padding: 0px 6px; font-size: 16px;"
							placeholder="Username"></td>
					</tr>
					<tr>
						<td style="text-align: left;height:35px"><span id="SignUpUserNameError"
							style="line-height: 1px; color: yellow">* Username  is required
								</span></td>
					</tr>
					<tr>
						<td style="text-align: right;"><input type="submit"
							id="signup" value="Sign Up"
							onclick="return ValidateAttributes(this.id);" name="SignUp"
							style="outline: none; cursor: pointer; border-radius: 5px; border: none; height: 35px; width: 95px; background-color: aquamarine; color: black; padding: 6px 6px; font-size: 16px;">
						</td>
					</tr>
					<tr>
						<td style="text-align: center;">
							<%
								if (request.getAttribute("confirmationMessage") != null) {
							%> <span id=""
							style="line-height: 1px; color: green; font-size: 18px"> <%
 	out.print(request.getAttribute("confirmationMessage"));
 %>
						</span> <%
 	}
 %> <%
 	if (request.getAttribute("SignupErrorMsg") != null) {
 %> <span id="" style="line-height: 25px; color: yellow; font-size: 18px;">
								<%
									out.print(request.getAttribute("SignupErrorMsg"));
								%>
						</span> <%
 	}
 %>
						</td>
					</tr>
				</table>
			</div>
		</form>
		<form autocomplete="off" action="AuthenticationServlet" method="post">
			<div id="signInDiv"
				style="border-radius: 10px;background-color: cadetblue;float: left;width: 45%;position: absolute;height: 20%;padding: 10px;left: 75%;text-align: center;display: block;">

				<table style="width: 95%; position: absolute; left: 3%;">
					<tr>
						<td
							style="text-align: left; font-size: 18px; font-weight: bold; line-height: 40px;"><span
							style="color: white">Existing Users</span></td>
					</tr>
					<tr>
						<td style="text-align: left; width: 38%;"><input
							autocomplete="off" class="search-tx" type="text"
							name="signInUserName" id="signInUserName"
							style="outline: none; border-radius: 5px; border: none; height: 35px; width: 95%; background-color: cornsilk; color: black; padding: 0px 6px; font-size: 16px;"
							placeholder="Username"></td>
						<td style="width: 38%;"><select name="env"
							style="outline: none; border-radius: 5px; border: none; height: 35px; width: 95%; background-color: cornsilk; color: black; padding: 0px 6px; font-size: 16px;">
								<option style="color: white; opacity: 0.8;">PIPE-C</option>
								<option>PIPE-D</option>
						</select></td>
						<td style="width: 24%;"><input type="submit" id="signin"
							value="Sign In" onclick="return ValidateAttributes(this.id);"
							name="SignIn"
							style="outline: none; cursor: pointer; border-radius: 5px; border: none; height: 35px; width: 95px; background-color: aquamarine; color: black; padding: 6px 6px; font-size: 16px;">
						</td>
					</tr>
					<tr>
						<td colspan="2"><span id="userNameSignInError"
							style="line-height: 1px; color: yellow">* Username is required</span> <%
 	if (request.getAttribute("LoginErrorMsg") != null) {
 %> <span id="signInUserNameError"
							style="line-height: 1px; color: yellow; font-size: 18px;"> <%
 	out.print(request.getAttribute("LoginErrorMsg"));
 %>
						</span> <%
 	}
 %></td>
						<td style="text-align: center"><a href="#"
							style="color: antiquewhite; font-size: 16px; font-weight: bold; line-height: 50px;"
							onclick="return ForgotUsernameScreen('forgotButton');">Forgot
								Username?</a></td>

					</tr>

				</table>


			</div>


			<div id="forgotDiv"
				style="border-radius: 10px;background-color: cadetblue;float: left;width: 45%;position: absolute;height: 25%;padding: 10px;left: 75%;text-align: center;display: block;">
				
				
				<table style="width: 95%; position: absolute; left: 3%;">
					<tr>
						<td
							style="text-align: left; font-size: 18px; font-weight: bold; line-height: 40px;"><span
							style="color: white">Forgot Password</span></td>
							<td colspan="2" style="text-align:right"><a href="#"
							style="color: antiquewhite; font-size: 16px; font-weight: bold; line-height: 50px;"
							onclick="return ForgotUsernameScreen('loginButton');">Cancel
								and return to Log in</a></td>
					</tr>
					<tr style="height: 15px">
						<td style="text-align: left; color: yellow; width: 30%">* All fields Required</td>
					</tr>
					<tr>
						<td style="text-align: left; width: 38%;"><input onkeyup="enableContinueButton()"
							autocomplete="off" class="search-tx" type="text"
							name="forgetfirstName" id="forgetfirstName"
							style="outline: none; border-radius: 5px; border: none; height: 35px; width: 95%; background-color: cornsilk; color: black; padding: 0px 6px; font-size: 16px;"
							placeholder="First Name"></td>
						<td style="width: 38%;"><input onkeyup="enableContinueButton()"
							autocomplete="off" class="search-tx" type="text"
							name="forgetlastName" id="forgetlastName"
							style="outline: none; border-radius: 5px; border: none; height: 35px; width: 95%; background-color: cornsilk; color: black; padding: 0px 6px; font-size: 16px;"
							placeholder="last Name"></td>
						<td style="width: 24%;"><input type="submit" id="forgotUsername"
							value="Continue"
							name="forgotUsername"
							style="outline: none; cursor: pointer; border-radius: 5px; border: none; height: 35px; width: 95px; background-color: transparent; color: black; padding: 6px 6px; font-size: 16px;">
						</td>
					</tr>
					<tr>
						<td colspan="2" style="color: yellow; font-size: 17px">
							<%
								if (null != request.getAttribute("retrievedUsername")) {
									out.print(request.getAttribute("retrievedUsername"));
								}
							%>
						</td>
					</tr>

				</table>
				
				
			</div>

		</form>
	</div>

</body>
</html>
