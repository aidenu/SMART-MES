<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	java.util.Calendar calendar = java.util.Calendar.getInstance();
	java.util.Date date = calendar.getTime();
	String lm_sEndMonth = (new java.text.SimpleDateFormat("yyyy-MM").format(date));
	calendar.add(java.util.Calendar.MONTH, -2);
	date = calendar.getTime();
	String lm_sStartMonth = (new java.text.SimpleDateFormat("yyyy-MM").format(date));
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Language" content="ko" >
<title></title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/jquery/jquery.monthpicker-0.1.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/jquery/calendarview.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/defaultTheme.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/myTheme.css'/>" rel="stylesheet" type="text/css" >

<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.monthpicker-0.1.js"/>"/></script>
<script type="text/javascript">var jq$ =jQuery.noConflict();</script>
<script type="text/javascript" src="<c:url value="/js/jquery/prototype.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/jquery/calendarview.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/titlefix/jquery.fixedheadertable.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spacevalidate.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spaceutil.js"/>"/></script>
<style>
	
	.google-visualization-tooltip { 

            width: 100px !important;
            border: none !important;
            border-radius: 10px !important;
            text-align: center !important;
            background-color: #2c3338!important;
            position: absolute !important;
            font-size:  10px !important;

          }

</style>
<script>
	
	var enddate = new Date();
	enddate.setDate(enddate.getDate()-1);
	var endyear = enddate.getFullYear();
	var endmonth = enddate.getMonth()+1;
	var endday = enddate.getDate();
	
	if(endmonth<10) endmonth = "0" + endmonth;
	if(endday<10) endday = "0" + endday;
	
	var endfullday = endyear + "-" + endmonth + "-" + endday;
	
	var startdate = new Date();
	startdate.setDate(startdate.getDate()-7);
	
	startyear = startdate.getFullYear();
	startmonth = startdate.getMonth()+1;
	startday = startdate.getDate();
	
	if(startmonth<10) startmonth = "0" + startmonth;
	if(startday<10) startday = "0" + startday;
	
	var startfullday = startyear + "-" + startmonth + "-" + startday;
	
	var div_height;
	var div_width;
	jq$(function(){
		div_height = document.body.clientHeight;
		div_width = document.body.clientWidth;
	});
	
	window.onload = function() {
		
		// 날짜 입력 항목 초기화
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
		
		if("${startDateField}" == "")
		{
			$("startDateField").value = startfullday;
		}
		else
		{
			$("startDateField").value = "${startDateField}"; 
		}
		
		if("${endDateField}" == "")
		{
			$("endDateField").value = endfullday;
		}
		else
		{
			$("endDateField").value = "${endDateField}"; 
		}
		
		jq$(".month").monthPicker();
	}
	
	function swapCalendar(gubun){
		if(gubun == "MONTH"){
			document.getElementById("month_div").style.display = "block";
			document.getElementById("day_div").style.display = "none";
		} else{
			document.getElementById("month_div").style.display = "none";
			document.getElementById("day_div").style.display = "block";
		}
	}
	
	function getData(){
		
		if(document.searchForm.datetype.value == "DAY") {
			startDate = document.searchForm.startDateField.value.replace(/-/g,"");
			endDate = document.searchForm.endDateField.value.replace(/-/g,"");
			if(endDate < startDate){
				alert("<spring:message code="space.common.alert.date.search.validate" />");
				return;
			}
			dateCnt = calDateRange(document.searchForm.startDateField.value,document.searchForm.endDateField.value);
			if(dateCnt > 30)
			{
				alert("<spring:message code="space.common.alert.date.count.validate" />");
				return;
			}
		}
		else
		{
			startDate = document.searchForm.startMonth.value.replace(/-/g,"");
			endDate = document.searchForm.endMonth.value.replace(/-/g,"");
			if(endDate <= startDate){
				alert("<spring:message code="space.common.alert.month.search.validate" />");
				return;
			}
			
			dateCnt = calDateRangeMonth(document.searchForm.startMonth.value,document.searchForm.endMonth.value);
			if(dateCnt > 12)
			{
				alert("<spring:message code="space.common.alert.month.count.validate" />");
				return;
			}
		}
		
		if(document.searchForm.eqp_part.value == "") {
			alert("<spring:message code="space.status.chart.eqp.alert.eqppart" />");
			return;
		}
		
		document.getElementById("progress_div").style.visibility = "visible";
		document.searchForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpRunningData.do";
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
	
	<table width="100%">
		<tr><td height="3"></td></tr>
		<tr>
			<td valign="top">
				<table>
					<tr>
						<td width="*" align="left">
							<div style="width:570px;border: 1px solid #D5D1B0;">
								<form name="searchForm" method="post">
								<input type="hidden" name="datecnt">
								<table>
									<tr>
										<td align="center" style="padding:0 10px 0 10px">
											<input type="radio" name="datetype" value="MONTH" onchange="swapCalendar('MONTH')" checked><font color="#FFFFFF"><spring:message code="space.status.chart.eqp.search.month" /></font>
											<input type="radio" name="datetype" value="DAY" onchange="swapCalendar('DAY')"><font color="#FFFFFF"><spring:message code="space.status.chart.eqp.search.day" /></font>
										</td>
										<td align="center" style="padding:0 10px 0 10px">
											<div id="month_div" style="display:block">
												<input type="text" name="startMonth" id="searchMonth" class="month" style="width:70px;text-align:center;cursor:pointer" value="<%=lm_sStartMonth%>" readonly>
												~
												<input type="text" name="endMonth" id="searchMonth" class="month" style="width:70px;text-align:center;cursor:pointer" value="<%=lm_sEndMonth%>" readonly>
											</div>
											<div id="day_div" style="display:none">
												<input type="text" name="startDateField" id="startDateField" style="height:17px;width:100px;text-align:center;cursor:pointer" readonly>
												~
												<input type="text" name="endDateField" id="endDateField" style="height:17px;width:100px;text-align:center;cursor:pointer" readonly>
											</div>
										</td>
										
										<td align="center" style="padding:0 10px 0 10px">
											<font color="#FFFFFF"><spring:message code="space.status.status.eqp.part" /> : </font>
											<select name="eqp_part" id="eqp_part">
												<option value="">-선택-</option>
												<c:forEach var="resultBasic" items="${resultBasic }" varStatus="status">
													<option value="${resultBasic.EQP_PART }">${resultBasic.EQP_PART }</option>
												</c:forEach>
											</select>
										</td>
										
										<td align="center" style="padding:0 0 0 0">
											<a href='#' class='AXButton Gray' onclick="getData()"><font color="#FFFFFF"><spring:message code="space.common.button.search" /></font></a>
										</td>
									</tr>
								</table>
								</form>
							</div>
						</td>
					</tr>
					<tr><td height="3"></td></tr>
					<tr>
						<td style="vertical-align: top;">
							<div>
								<div id="chart_div"></div>
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