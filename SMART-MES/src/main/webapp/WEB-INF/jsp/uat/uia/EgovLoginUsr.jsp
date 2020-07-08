<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<html >
<head>
<title>Login - SMART MES</title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.4.1.min.js" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smartscripts.js'/>"></script>
<script type="text/javascript">
	
	if("${sessionmessage}" == "session expire")
	{
		alert('<spring:message code="space.common.alert.session.expire" />');
	}
	
	function actionLogin() {

		if (document.loginForm.id.value == "") {
			alert("아이디를 입력하세요");
			return false;
		} else if (document.loginForm.password.value == "") {
			alert("비밀번호를 입력하세요");
			return false;
		} else {
			document.loginForm.action = "<c:url value='/uat/uia/actionSecurityLogin.do'/>";
			document.loginForm.target = "";
			document.loginForm.submit();
		}
	}

	
	function fnInit() {
		var message = document.loginForm.message.value;
		
		if (message != "" ) {
			alert(message); 
			document.loginForm.action = "<c:url value='/uat/uia/egovLoginUsr.do'/>";
            document.loginForm.target = "_top";
            document.loginForm.submit();
		}
		
		document.loginForm.id.focus();
	}

</script>
</head>


<body class="align" onload="fnInit();">
	<div id="layoutAuthentication">
		<div id="layoutAuthentication_content">
			<main>
				<div class="container">
					<div class="row justify-content-center">
						<div class="col-lg-5">
							<div class="card shadow-lg border-0 rounded-lg mt-5">
								<div class="card-header justify-content-center"><h3 class="font-weight-light my-4">Login</h3></div>
								<div class="card-body">
									<form name="loginForm" method="POST">
										<input type="hidden" name="message" value="${message}" />
										<input type="hidden" name="userSe" value="USR" />
										<input name="j_username" type="hidden" />
										<div class="form-group">
											<label class="small mb-1" for="id">ID</label>
											<input class="form-control py-4" id="id" name="id" type="text"  placeholder="Enter ID" />
										</div>
										<div class="form-group">
											<label class="small mb-1" for="password">Password</label>
											<input class="form-control py-4" id="password" name="password" type="password" onkeydown="javascript:if(event.keyCode == 13) { actionLogin(); }" placeholder="Enter password" />
										</div>
										<div class="form-group d-flex align-items-center justify-content-between mt-4 mb-0">
											<div class="btn btn-primary" onclick="actionLogin()">Login</div>
										</div>
									</form>
								</div>
								<div class="card-footer text-center"></div>
							</div>
						</div>
					</div>
				</div>
			</main>
		</div>
		<div id="layoutAuthentication_footer">
			<footer class="footer mt-auto footer-dark">
				<div class="container-fluid">
					<div class="row">
						<div class="col-md-6 small">Copyright &copy; <spring:message code="smart.header.title" /></div>
					</div>
				</div>
			</footer>
		</div>
	</div>

</body>
</html>
