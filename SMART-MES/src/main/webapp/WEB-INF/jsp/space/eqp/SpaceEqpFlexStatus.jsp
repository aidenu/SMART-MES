<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Language" content="ko" >
<title></title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/jquery/jquery-ui.css'/>" rel="stylesheet" type="text/css" >

<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-ui.js"/>"/></script>
<script type="text/javascript">var jq$ =jQuery.noConflict();</script>
<script type="text/javascript" src="<c:url value="/js/jquery/prototype.js"/>"/></script>
<link href="<c:url value='/css/titlefix/defaultTheme.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/myTheme.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/spacevalidate.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spaceutil.js"/>"/></script>

<style>
    
    /* for MS계열 브라우저 */
	@keyframes blink {
	 50% {background-color: #F5F1F1;}
/* 	 50% {background-color: yellow;} */
	}
	 
	/* for Chrome, Safari */
	@-webkit-keyframes blink {
	 50% {background-color: #F5F1F1;}
/* 	 50% {background-color: yellow;} */
	}
	
	
	.eqpbox {
		position:absolute !important;
		text-align:center;
		color: #000000;
		padding: 5px;
		border-radius: 10px 10px 10px 10px;
		display:-webkit-box;
		-webkit-box-pack:center;
		-webkit-box-align:center;
						
		<c:if test="${userrole == 'ROLE_ADMIN' || userrole == 'ROLE_USER_MANAGER'}">
			cursor: move;
		</c:if>
	}

	
	
	.blinkcss {
	 font-weight:bold;
	 animation: blink 1s step-end infinite;
	 -webkit-animation: blink 1s step-end infinite;
	}
	
	.float-shadow {
	  box-shadow: 0 0 1px transparent;
	  position: relative;
	  -webkit-transition-duration: 0.3s;
	  transition-duration: 0.3s;
	  -webkit-transition-property: transform;
	  transition-property: transform;
	}
	.float-shadow:before {
		pointer-events: none;
		position: absolute;
		z-index: -1;
		content: '';
		top: 100%;
		left: 5%;
		height: 10px;
		width: 90%;
		opacity: 1;
		background: -webkit-radial-gradient(center, ellipse, rgba(0, 0, 0, 0.35) 0%, transparent 80%);
		background: radial-gradient(ellipse at center, rgba(0, 0, 0, 0.35) 0%, transparent 80%);
		/* W3C */
		-webkit-transition-duration: 0.3s;
		transition-duration: 0.3s;
		-webkit-transition-property: transform, opacity;
		transition-property: transform, opacity;
	}
	.float-shadow:hover, .float-shadow:focus, .float-shadow:active {
		-webkit-transform: translateY(0);
		transform: translateY(0);
		/* move the element up by 5px */
	}
	.float-shadow:hover:before, .float-shadow:focus:before, .float-shadow:active:before {
		opacity: 1;
		-webkit-transform: translateY(0);
		transform: translateY(0);
		/* move the element down by 5px (it will stay in place because it's attached to the element that also moves up 5px) */
	}
	
	
</style>

<script>
	
	window.onload = function() {
		getStatusData();
	}
	
	var second = 61;
	var orgin_second = 61;
	var timer;
	
	function change_second()
	{
		second = Number(jq$("#reload_time").val())+1;
	}
	
	function startTimer()
	{
		if(second == 0)
		{
			second = orgin_second;
			
			getStatusData();
		}
		
		second = second -1;	    
	    //document.getElementById('reload_timer').innerText = second+"s";
	    document.getElementById('reload_timer').innerHTML = "<font color=white>" + second+"s</font>";
	    timer = setTimeout(function(){startTimer()},1000);
	}
	
	
	function endTimer()
	{
		second = orgin_second;
		clearTimeout(timer);
	}
	
	
	function getStatusData()
	{
// 		document.getElementById("progress_div").style.visibility = "visible";
		document.searchForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpFlexStatusData.do";
		document.searchForm.target = "searchFrame";
		document.searchForm.submit();
	}
	
	
	
	function setSave()
	{
		var strData = "";
		
		var eqpcnt = jq$("div[id^='eqpbox_']").length;
		
		if(eqpcnt > 0)
		{
			for(var i=0; i<eqpcnt ; i++)
			{
				strData += document.getElementById("process_" + jq$("div[id^='eqpbox_']")[i].id).value + "♬";//PROCESS_ID
				strData += document.getElementById("eqpname_" + jq$("div[id^='eqpbox_']")[i].id).value + "♬";//EQP_NAME
				strData += jq$("div[id^='eqpbox_']")[i].style.left.replace("px","") + "♬";//LEFT
				strData += jq$("div[id^='eqpbox_']")[i].style.top.replace("px","") + "♬";//TOP
				strData += jq$("div[id^='eqpbox_']")[i].style.width.replace("px","") + "♬";//WIDTH
				strData += jq$("div[id^='eqpbox_']")[i].style.height.replace("px","") + "♩";//HEIGHT
			}
			
			strData = strData.substring(0,strData.length-1);//모든 설정이 끝나면 마지막에 붙는  ♩ 는 떼어 낸다
			
			if(confirm("현재 설정으로 저장 하시겠습니까?"))
			{
				document.getElementById("progress_div").style.visibility = "visible";
				document.searchForm.arraystr.value = strData;
				
				document.searchForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpFlexStatusSave.do";
				document.searchForm.target = "searchFrame";
				document.searchForm.submit();
			}
		}
	}
	
	
	function setDrag(id)
	{
		jq$("#"+id).resizable().draggable();
	}
	
		
	function resizeDiv(id) 
	{
		var widthSize = Number(document.getElementById(id).style.width.replace("px", ""));
		var heightSize = Number(document.getElementById(id).style.height.replace("px", ""));
		var titleSize = 0;
		var contentSize = 0;

		if(widthSize > heightSize)
		{
   			titleSize = heightSize * 0.2;
   			contentSize = heightSize * 0.3;
		}
		else
		{
   			titleSize = widthSize * 0.2;
   			contentSize = widthSize * 0.3;
		}

		document.getElementById("title_"+id).style.fontSize = titleSize+"px";
		document.getElementById("content_"+id).style.fontSize = contentSize+"px";
	}
		
</script>
</head>

<body style="background-color: #2c3338;">

<div id="wrap">
	<!-- header 시작 -->
	<div id="header"><c:import url="/EgovPageLink.do?link=main/inc/EgovIncHeader" /></div>
    <div id="topnavi"><c:import url="/sym/mms/EgovMainMenuHead.do" /></div>
    <div id="subnavi"><c:import url="/sym/mms/EgovMainMenuSub.do" /></div> 
	<!-- //header 끝 -->	
	
	<!-- container 시작 -->
	<div id="spacecontainer">
		<table width="99%">
			<tr><td height="3"></td></tr>
			<tr>
				<td valign="top" width="100%">
					<table width="100%">
						<tr>
							<td width="*">
								<c:choose>
									<c:when test="${userrole == 'ROLE_ADMIN' || userrole == 'ROLE_USER_MANAGER'}">
										<div style="width:150px;text-align:center;border: 1px solid #D5D1B0;background-color: #2c3338;">
											<form name="searchForm" method="post">
											<input type="hidden" name="arraystr">
											<input type="hidden" name="userrole" value="${userrole}">
												<table width="100%" cellspacing="0" cellpadding="0">
													<tr>
														<td height="35">
															<a href='#' class='AXButton Gray' onclick="getStatusData()"><spring:message code="space.common.button.search" /></a>
															<a href='#' class='AXButton Red' onclick="setSave()">저장</a>
														</td>
													</tr>
												</table>
											</form>
										</div>
									</c:when>
									<c:otherwise>
										<div style="width:300px;text-align:center;border: 1px solid #D5D1B0;">
											<form name="searchForm" method="post">
											<input type="hidden" name="arraystr">
											<input type="hidden" name="userrole" value="${userrole}">
												<table width="100%" cellspacing="0" cellpadding="0">
													<tr>
														<td height="35">
															&nbsp;
															<font color="#FFFFFF">재조회 :</font>
															<select name="reload_time" id="reload_time" style="width:65px;" onchange="change_second()">
																<c:forEach var="resultTime" items="${resultTime }" varStatus="status">
																	<option value="${resultTime.MONITORING_TIME }" <c:if test="${resultTime.DEFAULT_TIME == 'default' }">selected</c:if>>${resultTime.MONITORING_TIME }</option>
																</c:forEach>
															</select>
														</td>
														<td width="20" id="reload_icon"></td>
														<td width="30" id="reload_timer"></td>
														<td >
															<a href='#' class='AXButton Gray' onclick="getStatusData()"><spring:message code="space.common.button.search" /></a>
														</td>
													</tr>
												</table>
											</form>
										</div>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr>
							<td height="10"></td>
						</tr>
						<tr>
							<td width="100%">
								<div id="drag_div" oncontextmenu="return false" style="width:100%;">
									
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	
	<!-- footer 시작 -->
	<%-- <div id="footer"><c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" /></div> --%>
	<!-- //footer 끝 -->
</div>
<!-- //전체 레이어 끝 -->

<div id="progress_div" style="position:absolute;width:100%;height:100%;top:0;left:0;background-color:#DCDCED;opacity:0.5;visibility:hidden;z-index:1">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
		<tr>
			<td align=center><img src="<c:url value='/'/>images/space/progressdisc.gif" width="30" height="30" border="0"></td>
		</tr>
	</table>
</div>

<form name="dataForm" method="post"></form>
<iframe name="searchFrame" width="0" hieght="0" style="display:none"></iframe>
</body>
</html>