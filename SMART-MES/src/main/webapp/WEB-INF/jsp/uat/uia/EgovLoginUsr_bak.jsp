<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<%
	String ExpireDate = (String)session.getAttribute("expiremsg");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Language" content="ko">
<title>로그인</title>
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/login.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >

<script type="text/javascript">
<!--
	
	if("${sessionmessage}" == "session expire")
	{
		alert("<spring:message code="space.common.alert.session.expire" />");
	}
	
	if("<%=ExpireDate%>" != "null" && "<%=ExpireDate%>" != "")
	{
		alert("<%=ExpireDate%>");
		<%
			session.setAttribute("expiremsg","");
		%>
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
			document.loginForm.submit();
		}
	}

	function setCookie(name, value, expires) {
		document.cookie = name + "=" + escape(value) + "; path=/; expires="
				+ expires.toGMTString();
	}

	function getCookie(Name) {
		var search = Name + "="
		if (document.cookie.length > 0) { // 쿠키가 설정되어 있다면
			offset = document.cookie.indexOf(search)
			if (offset != -1) { // 쿠키가 존재하면
				offset += search.length
				// set index of beginning of value
				end = document.cookie.indexOf(";", offset)
				// 쿠키 값의 마지막 위치 인덱스 번호 설정
				if (end == -1)
					end = document.cookie.length
				return unescape(document.cookie.substring(offset, end))
			}
		}
		return "";
	}

	function saveid(form) {
		var expdate = new Date();
		// 기본적으로 30일동안 기억하게 함. 일수를 조절하려면 * 30에서 숫자를 조절하면 됨
		if (form.checkId.checked)
			expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 30); // 30일
		else
			expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
		setCookie("saveid", form.id.value, expdate);
	}

	function getid(form) {
		form.checkId.checked = ((form.id.value = getCookie("saveid")) != "");
	}

	function fnInit() {
		var message = document.loginForm.message.value;
		
		if (message != "" ) {
			alert(message); 
		}
		getid(document.loginForm);
		
		document.loginForm.id.focus();
	}
//-->
</script>
</head>
<body  onload="fnInit();">
	<noscript>자바스크립트를 지원하지 않는 브라우저에서는 일부 기능을 사용하실 수 없습니다.</noscript>
	<!-- 전체 레이어 시작 -->
	<div id="wrap">
		<!-- header 시작 -->
		<div id="header">
			<c:import url="/EgovPageLink.do?link=main/inc/EgovIncHeader" />
		</div>
		<div id="topnavi">
			<c:import url="/sym/mms/EgovMainMenuHead.do" />
		</div>
		<div id="subnavi"></div>
		<!-- //header 끝 -->
		<!-- container 시작 -->
		<div id="container">
			<!-- content 시작 -->
			<div id="content">
				<div id="login_title_div">
					<img src="<c:url value='/' />images/login/img_logintitle.gif" />
				</div>
				<div class="user_login">
					<form:form name="loginForm" method="post">
						<fieldset>
							<div class="user_login_ultop">
								<ul>
									<li><label for="id"><spring:message code="login.id" /></label> <input type="text"
										class="input_style" id="id" name="id"
										maxlength="15" /></li>
									<li><label for="password"><spring:message code="login.pass" /></label> <input
										type="password" class="input_style" maxlength="25"
										id="password" name="password"
										onkeydown="javascript:if (event.keyCode == 13) { actionLogin(); }" />
									</li>
									<li><input type="checkbox" name="checkId"
										onclick="javascript:saveid(this.form);"
										id="checkId" /><spring:message code="login.idsave" /></li>
								</ul>
								&nbsp;<a class='AXButtonLarge Blue' href="#LINK" onclick="javascript:actionLogin()"><spring:message code="button.login" /></a>
							</div>
						</fieldset>
						<input type="hidden" name="message" value="${message}" />
						<input type="hidden" name="userSe" value="USR" />
						<input name="j_username" type="hidden" />
					</form:form>
				</div>
			</div>
			<!-- //content 끝 -->
		</div>
		<!-- //container 끝 -->
		<!-- footer 시작 -->
		<div id="footer">
			<c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
		</div>
		<!-- //footer 끝 -->
	</div>
	<!-- //전체 레이어 끝 -->
</body>
</html>