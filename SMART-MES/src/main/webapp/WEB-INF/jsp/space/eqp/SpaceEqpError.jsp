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
<script type="text/javascript" src="<c:url value="/js/titlefix/jquery.fixedheadertable.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spacevalidate.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spaceutil.js"/>"/></script>
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
	startdate.setDate(startdate.getDate()-30);
	
	startyear = startdate.getFullYear();
	startmonth = startdate.getMonth()+1;
	startday = startdate.getDate();
	
	if(startmonth<10) startmonth = "0" + startmonth;
	if(startday<10) startday = "0" + startday;
	
	var startfullday = startyear + "-" + startmonth + "-" + startday;
	
	
	jq$(function()
	{
		var data_div_height = document.body.clientHeight-170;;
		jq$('#data_table').fixedHeaderTable({ fixedColumn: true,height:data_div_height,autoShow:true});
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
		
		$("startDateField").value = startfullday;
		$("endDateField").value = endfullday;
		
		jq$("#data_table_tbody").empty();
	}
	
	
	function getData()
	{
		startDate = document.searchForm.startDateField.value.replace(/-/g,"");
		endDate = document.searchForm.endDateField.value.replace(/-/g,"");
		
		if(endDate <= startDate)
		{
			alert("<spring:message code="space.common.alert.date.search.validate" />");
			return;
		}
		
		var dateCnt = calDateRange(document.searchForm.startDateField.value,document.searchForm.endDateField.value);
		
		if(dateCnt > 365)
		{
			alert("<spring:message code="space.common.alert.year.count.validate" />");
			return;
		}
	
		document.getElementById("progress_div").style.visibility = "visible";
		document.searchForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpErrorData.do";
		document.searchForm.target = "searchFrame";
		document.searchForm.submit();
	}
	
	
	
	function getExcel()
	{
		startDate = document.searchForm.startDateField.value.replace(/-/g,"");
		endDate = document.searchForm.endDateField.value.replace(/-/g,"");
		
		if(endDate <= startDate)
		{
			alert("<spring:message code="space.common.alert.date.search.validate" />");
			return;
		}
		
		dateCnt = calDateRange(document.searchForm.startDateField.value,document.searchForm.endDateField.value);
		
		if(dateCnt > 365)
		{
			alert("<spring:message code="space.common.alert.year.count.validate" />");
			return;
		}
	
		
		document.searchForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpErrorExcel.do";
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
							<td width="*">
								<div style="width:560px;border: 1px solid #D5D1B0;">
									<form name="searchForm" method="post">
									<input type="hidden" name="datecnt">
									<table>
										<tr>
											<td align="center" style="padding:0 10px 0 10p;">
												&nbsp;&nbsp;
												<font color="#FFFFFF"><spring:message code="space.status.chart.eqp.search.interval" /> : </font>
												<input type="text" name="startDateField" id="startDateField" style="height:17px;width:100px;text-align:center;cursor:pointer" readonly>
												~
												<input type="text" name="endDateField" id="endDateField" style="height:17px;width:100px;text-align:center;cursor:pointer" readonly>
											</td>
											<td align="center" style="padding:0 10px 0 10px">
												<font color="#FFFFFF"><spring:message code="space.status.status.eqp.part" /> : </font>
												<select name="eqp_part" id="eqp_part">
													<option value="ALL">-전체-</option>
													<c:forEach var="resultBasic" items="${resultBasic }" varStatus="status">
														<option value="${resultBasic.EQP_PART }">${resultBasic.EQP_PART }</option>
													</c:forEach>
												</select>
											</td>
											
											<td align="center" style="padding:0 0 0 0">
												<a href='#' class='AXButton Gray' onclick="getData()"><font color="#FFFFFF"><spring:message code="space.common.button.search" /></font></a>
												<a href='#' class='AXButton Gray' onclick="getExcel()"><font color="#FFFFFF"><spring:message code="space.common.button.excel" /></font></a>
											</td>
										</tr>
									</table>
									</form>
								</div>
							</td>
						</tr>
						<tr><td height="3"></td></tr>
						<tr>
							<td>
								<div id="data_div" class="tableContainer" style="width: 1000px;">
									<table id="data_table" class="fancyTable"> 
										 <thead>
											<tr>
												<th width='200'><spring:message code="space.status.chart.eqp.ration.machine" /></th>
												<th width='300'><spring:message code="space.status.start.time" /></th>
												<th width='300'><spring:message code="space.status.end.time" /></th>
												<th width='200'><spring:message code="space.status.elap.time" /></th>
											</tr>
										</thead>
										<tbody id="data_table_tbody">
											<tr>
												<td></td>
												<td></td>
												<td></td>
												<td></td>
											</tr>
										</tbody>
									</table>
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