<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	java.util.Calendar calendar = java.util.Calendar.getInstance();
	calendar.add(java.util.Calendar.DAY_OF_YEAR, -1);
	java.util.Date date = calendar.getTime();
	String lm_sEndDate = (new java.text.SimpleDateFormat("yyyy-MM-dd").format(date));
	calendar.add(java.util.Calendar.DAY_OF_YEAR, -29);
	date = calendar.getTime();
	String lm_sStartDate = (new java.text.SimpleDateFormat("yyyy-MM-dd").format(date));
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Language" content="ko" >
<title>로그조회</title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >

<link href="<c:url value='/css/titlefix/defaultTheme.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/myTheme.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript">var jq$ =jQuery.noConflict();</script>
<script type="text/javascript" src="<c:url value="/js/jquery/prototype.js"/>"/></script>
<link href="<c:url value='/css/jquery/calendarview.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/jquery/calendarview.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/titlefix/jquery.fixedheadertable.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/blink.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spaceutil.js"/>"/></script>

<script>

	jq$(function(){
		data_div_height = 636;
		data_height = data_div_height;
		jq$('#data_table').fixedHeaderTable({ fixedColumn: true,height:data_div_height,autoShow:true});
	});
	
	
	window.onload = function() {
		
		Calendar.setup(
		          {
		            dateField: 'startDateField',
		            triggerElement: 'startDateField'
		          }
		)
		
		Calendar.setup(
		          {
		            dateField: 'endDateField',
		            triggerElement: 'endDateField'
		          }
		)
	}
	
	
	// 조회 버튼 클릭시 현재 검색 조건을 등록하고 조회 함
	function setSearchCondition()
	{
		var startDate = document.searchForm.startDateField.value.replace(/-/g,"");
		var endDate = document.searchForm.endDateField.value.replace(/-/g,"");
		
		if(endDate <= startDate)
		{
			alert("<spring:message code="space.common.alert.date.search.validate" />");
			return;
		}
			
		var dateCnt = calDateRange(document.searchForm.startDateField.value,document.searchForm.endDateField.value);
		
		if(dateCnt > 30)
		{
			alert("<spring:message code="space.common.alert.count.validate" />");
			return;
		}
		
		document.searchForm.action="${pageContext.request.contextPath}/space/common/SpaceLogInfoList.do";
		document.searchForm.target = "searchFrame";
		document.searchForm.submit();
	}
	
	
	function linkPage(pageNo){
		document.searchForm.pageno.value = pageNo;
		document.searchForm.action="${pageContext.request.contextPath}/space/common/SpaceLogInfoList.do";
		document.searchForm.target = "searchFrame";
		document.searchForm.submit();
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
		<table width="100%">
			<tr><td height="3"></td></tr>
			<tr>
				<td valign="top">
					<table>
						<tr>
							<td width="*">
								<div style="width:300px;border: 1px solid #D5D1B0;">
									<form name="searchForm" method="post">
									<input type="hidden" name="pageno" value="1">
									<table width="100%">
										<tr>
											<td id="captionSubTitle" align="center" style="background-color: #2c3338;">
												<input type="text" name="startDateField" id="startDateField" style="height:17px;width:95px;text-align:center;" value="<%=lm_sStartDate%>" readonly>
												~
												<input type="text" name="endDateField" id="endDateField" style="height:17px;width:95px;text-align:center;" value="<%=lm_sEndDate%>" readonly>
												&nbsp;
												<a href='#' class='AXButton Gray' onclick="setSearchCondition()">&nbsp;&nbsp;<spring:message code="space.common.button.search" />&nbsp;&nbsp;</a>
											</td>
										</tr>
									</table>
									</form>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="tableContainer" style="width:1150px;">
									<table id="data_table" class="fancyTable"> 
										<thead>
											<tr>
												<th width="50">NO</th>
												<th width="200">EVENT_TIME</th>
												<th width="200">MAC_ADDRESS</th>
												<th width="100">RED_FLAG</th>
												<th width="100">AMBER_FLAG</th>
												<th width="100">GREEN_FLAG</th>
												<th width="100">BLUE_FLAG</th>
												<th width="100">WHITE_FLAG</th>
												<th width="100">BUZZER_FLAG</th>
												<th width="100">WDTMONITORING</th>
											</tr>
										</thead>
										<tbody>
											
										</tbody>
									</table>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<!-- 페이지 네비게이션 시작 -->
	    <table width="1150px">
			<tr>
				<td align="center">
					<div id="paging_div">
					</div>
				</td>
			</tr>
		</table>
	     <!-- //페이지 네비게이션 끝 -->
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

<iframe name="searchFrame" width="0" hieght="0" style="display:none"></iframe>
</body>
</html>