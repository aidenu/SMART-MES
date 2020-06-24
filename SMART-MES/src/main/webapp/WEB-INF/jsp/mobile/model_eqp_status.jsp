<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" /> 
<link href="<c:url value='/css/egovframework/mbl/cmm/jquery.mobile-1.4.5.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/egovframework/mbl/cmm/EgovMobile-1.4.5.css'/>" rel="stylesheet" type="text/css" >

<script type="text/javascript" src="<c:url value="/js/egovframework/mbl/cmm/jquery-1.11.2.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/egovframework/mbl/cmm/jquery.mobile-1.4.5.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/egovframework/mbl/cmm/EgovMobile-1.4.5.js"/>"/></script>

<script type="text/javascript" src="<c:url value="/js/spacevalidate.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spaceutil.js"/>"/></script>

<script>

var second = 61;
var orgin_second = 61;
var timer;

function startTimer()
{
	if(second == 0)
	{
		second = orgin_second;
		
		self_reload();
	}
	
	second = second -1;	    
    document.getElementById('reload_timer').innerText = second+"s";
    timer = setTimeout(function(){startTimer()},1000);
}


function endTimer()
{
	second = orgin_second;
	clearTimeout(timer);
}


function self_reload()
{
	window.location.reload();
}
	
    
function init()
{
	document.getElementById('reload_icon').innerHTML = "<img	src='<c:url value='/'/>images/space/reload.gif' width='15' height='15' />";
	second = 61;
	orgin_second = 61;
	endTimer();
	startTimer();
}


</script>
</head>

<body onload="init()">

<header data-tap-toggle="false" data-position="fixed" data-theme="a" data-role="header">
    <h1><spring:message code="space.common.item.eqp.status" /></h1>
</header>
<br>
<form name="dataForm" method="post">
<table width="100%">
	<tr>
		<td width="*">
			<div style="width:100px;border: 1px solid #D5D1B0;">
				<table width="100%">
					<tr>
						<td width="20" id="reload_icon"></td>
						<td width="30" id="reload_timer"></td>
						<td><a href='#' class='AXButton Blue' onclick="self_reload()"><spring:message code="space.common.button.search" /></a></td>
					</tr>
				</table>
			</div>
		</td>
		<td><spring:message code="space.mobile.info.landscape" /></td>
	</tr>
	<tr>
		<td colspan="2">
			<table id="data_table" width='100%' cellpadding="0" cellspacing="1" border="0" bgcolor="#4B4B4B">
				<tr  bgcolor="#6E6E6E">
					<td width='25%' align="center"><font color="#FFF"><spring:message code="space.common.button.eqp.name" /></font></td>
					<td width='10%' align="center"><font color="#FFF"><spring:message code="space.common.item.status" /></font></td>
					<td width='15%' align="center"><font color="#FFF"><spring:message code="space.mobile.eqp.user.name" /></font></td>
				</tr>
				<c:forEach var="result" items="${resultStatus}" varStatus="status">
				<tr bgcolor="<c:choose><c:when test="${result.RED_STATUS == 'ON' }">#FF3300</c:when><c:when test="${result.AMBER_STATUS == 'ON' }">#FFCC00</c:when><c:when test="${result.GREEN_STATUS == 'ON' }">#00E600</c:when><c:when test="${result.BLUE_STATUS == 'ON' }">#33CCFF</c:when><c:when test="${result.WHITE_STATUS == 'ON' }">#F9F9F9</c:when><c:otherwise>#FFFFFF</c:otherwise></c:choose>">
					<td align="center">${result.EQP_NAME}</td>
					<td align="center" <c:if test="${result.ACTIVE_FLAG == 'ACTIVE'}">style="border:5px solid #F9F900"</c:if>>
						<c:choose>
							<c:when test="${result.RED_STATUS == 'ON' }">
								오류
							</c:when>
							<c:when test="${result.AMBER_STATUS == 'ON' }">
								대기중
							</c:when>
							<c:when test="${result.GREEN_STATUS == 'ON' }">
								가동중
							</c:when>
							<c:when test="${result.BLUE_STATUS == 'ON' }">
								BLUE
							</c:when>
							<c:when test="${result.WHITE_STATUS == 'ON' }">
								WHITE
							</c:when>
							<c:otherwise>
								대기중
							</c:otherwise>
						</c:choose>
					</td>
					<td align="center">${result.USER_NAME}</td>
				</tr>
				</c:forEach>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>