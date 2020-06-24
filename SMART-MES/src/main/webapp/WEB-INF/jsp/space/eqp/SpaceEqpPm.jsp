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
		var data_div_height = document.body.clientHeight-170;
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
		
		getData();
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
		document.searchForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpPmList.do";
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
	
		
		document.searchForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpPmExcel.do";
		document.searchForm.target = "searchFrame";
		document.searchForm.submit();
	}
	
	
	
	function getEqpList()
	{
		document.searchForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpPmEqpList.do";
		document.searchForm.target = "searchFrame";
		document.searchForm.submit();
	}
	
	
	function setData()
	{
		window.open("<c:url value='/'/>space/eqp/SpaceEqpPmNew.do","eqp_win","scrollbars=yes,toolbar=no,resizable=yes,left=200,top=200,width=700,height=630");
	}
	
	
	
	function getDetailInfo(pm_id)
	{
		window.open("<c:url value='/'/>space/eqp/SpaceEqpPmView.do?pm_id=" + pm_id,"detail_view_win","scrollbars=no,toolbar=no,resizable=yes,left=200,top=200,width=700,height=630");
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
								<div style="width:1100px;border: 1px solid #D5D1B0;">
									<form name="searchForm" method="post">
									<input type="hidden" name="type" value="LIST">
									<table width="100%">
										<tr>
											<td align="center" style="padding:0 10px 0 10p;">
												&nbsp;&nbsp;
												<font color="#FFFFFF"><b>작업 기간</b> : </font>
												<input type="text" name="startDateField" id="startDateField" style="height:17px;width:100px;text-align:center;cursor:pointer" readonly>
												~
												<input type="text" name="endDateField" id="endDateField" style="height:17px;width:100px;text-align:center;cursor:pointer" readonly>
												&nbsp;&nbsp;
												<font color="#FFFFFF"><b>구분</b> : </font>
												<select name="pm_type" id="pm_type" style="width:80px">
													<option value="ALL">-전체-</option>
													<option value="CHECK">정기점검</option>
													<option value="REPAIR">고장/수리</option>
												</select>
												&nbsp;&nbsp;
												<font color="#FFFFFF"><b>설비그룹</b> : </font>
												<select name="eqppart" id="eqppart" onchange="getEqpList()" style="width:100px">
													<option value="ALL">-전체-</option>
													<c:forEach var="result" items="${result}" varStatus="status">
														<option value="${result.EQP_PART}">${result.EQP_PART}</option>
													</c:forEach>
												</select>
												&nbsp;&nbsp;
												<font color="#FFFFFF"><b>설비명</b> : </font>
												<select name="eqpname" id="eqpname" style="width:200px">
													<option value="ALL">-전체-</option>
												</select>
												&nbsp;&nbsp;
												<a href='#' class='AXButton Gray' onclick="getData()">조회</a>
												<a href='#' class='AXButton Gray' onclick="getExcel()">엑셀</a>
												<a href='#' class='AXButton Gray' onclick="setData()">등록</a>
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
								<div id="data_div" class="tableContainer" style="width: 1650px;">
									<table id="data_table" class="fancyTable"> 
										 <thead>
											<tr>
												<th width='100'>구분</th>
												<th width='100'>설비그룹</th>
												<th width='150'>설비명</th>
												<th width='100'>작업일자</th>
												<th width='100'>작업자</th>
												<th width='100'>작업시간</th>
												<th width='950'>작업내용</th>
												<th width='50'>이미지</th>
											</tr>
										</thead>
										<tbody id="data_table_tbody">
											<tr>
												<td></td>
												<td></td>
												<td></td>
												<td></td>
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