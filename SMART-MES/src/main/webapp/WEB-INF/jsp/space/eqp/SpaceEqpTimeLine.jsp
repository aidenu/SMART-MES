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
<link href="<c:url value='/css/jquery/calendarview.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/defaultTheme.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/myTheme.css'/>" rel="stylesheet" type="text/css" >

<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript">var jq$ =jQuery.noConflict();</script>
<script type="text/javascript" src="<c:url value="/js/jquery/prototype.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/jquery/calendarview.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spacevalidate.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spaceutil.js"/>"/></script>
<style>

#timeline text {
	fill : #FFF;
}

</style>
<script>
	
	var searchdate = new Date();
	
	var searchyear = searchdate.getFullYear();
	var searchmonth = searchdate.getMonth()+1;
	var searchday = searchdate.getDate();
	
	if(searchmonth<10) searchmonth = "0" + searchmonth;
	if(searchday<10) searchday = "0" + searchday;
	
	var searchfullday = searchyear + "-" + searchmonth + "-" + searchday;
	
	
	window.onload = function() {
		
		// 날짜 입력 항목 초기화
		Calendar.setup(
		          {
		            dateField: 'searchdate',
		            triggerElement: 'searchdate'
		          }
		)
		
		document.getElementById("timeline").style.width = (window.innerWidth-10) + "px";
		document.getElementById("timeline").style.height = (window.innerHeight-200) + "px";
		
		$("searchdate").value = searchfullday;
	}
	
	
	function getData()
	{
		document.getElementById("progress_div").style.visibility = "visible";
		
		document.searchForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpTimeLineData.do";
		document.searchForm.target = "searchFrame";
		document.searchForm.submit();
	}
	
	
	function getDetail(eqpname)
	{
		window.open("${pageContext.request.contextPath}/space/eqp/SpaceEqpTimeLineDetail.do?searchdate=" + document.searchForm.searchdate.value + "&eqpname=" + eqpname,"detail-win","scrollbars=yes,toolbar=no,resizable=yes,left=200,top=200,width=500,height=320");
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
	
	<table width="100%">
		<tr><td height="3"></td></tr>
		<tr>
			<td valign="top">
				<table>
					<tr>
						<td width="*">
							<div style="width:260px;border: 1px solid #D5D1B0;display:inline-block">
								<form name="searchForm" method="post">
								
								<table>
									<tr>
										<td align="center" style="padding:0 10px 0 10p;">
											&nbsp;&nbsp;
											<font color="#FFFFFF">조회일 : </font>
											<input type="text" name="searchdate" id="searchdate" style="height:17px;width:100px;text-align:center;cursor:pointer" readonly>
											&nbsp;&nbsp;
											<a href='#' class='AXButton Gray' onclick="getData()"><font color="#FFFFFF"><spring:message code="space.common.button.search" /></font></a>
										</td>
									</tr>
								</table>
								</form>
							</div>
							<div id="gathering_time" style="display:inline-block;width:500px;text-align:center;"></div>
						</td>
					</tr>
					<tr><td height="3"></td></tr>
					<tr>
						<td>
							<div id="timeline" style="background-color:#2c3338;">
								
							</div>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>

	
<div id="progress_div" style="position:absolute;width:100%;height:100%;top:0;left:0;background-color:#DCDCED;opacity:0.5;visibility:hidden;z-index:1">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
		<tr>
			<td align=center><img src="<c:url value='/'/>images/space/progressdisc.gif" width="30" height="30" border="0"></td>
		</tr>
	</table>
</div>
<iframe name="searchFrame" width="0" hieght="0" style="display:none"></iframe>

</body>
</html>