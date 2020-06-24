<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	java.util.Calendar calendar = java.util.Calendar.getInstance();
	java.util.Date date = calendar.getTime();
	String lm_sMonth = (new java.text.SimpleDateFormat("yyyy-MM").format(date));
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

<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript">var jq$ =jQuery.noConflict();</script>
<script type="text/javascript" src="<c:url value="/js/jquery/prototype.js"/>"/></script>
<link href="<c:url value='/css/jquery/calendarview.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/jquery/calendarview.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.monthpicker-0.1.js"/>"/></script>
<link href="<c:url value='/css/titlefix/defaultTheme.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/myTheme.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/titlefix/jquery.fixedheadertable.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spacevalidate.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spaceutil.js"/>"/></script>

<style type = "text/css">

.main_table {
  border           : solid;
  border-color     : black black #000000;
  border-width     : 0px 0px 0px 0px;
  background-color : #666666;
  text-align       : center;
  font-size        : 12pt;
  table-layout     : fixed;
}
 
.TIT_CONT_GRAY_A { font-family: "굴림"; font-size: 10pt; color: #000000; background-color: #FCE2A0; line-height: 14pt; font-weight: bold; text-align: center;}
.TIT_CONT_GRAY_B { font-family: "굴림"; font-size: 10pt; color: #000000; background-color: #D5D5AA; line-height: 14pt; font-weight: bold; text-align: center;}
.TIT_CONT_GRAY_C { font-family: "굴림"; font-size: 10pt; color: #000000; background-color: #95CAFF; line-height: 14pt; font-weight: bold; text-align: center;}
.BG_WHITE_C { font-family: "굴림"; font-size: 10pt; color: #000000; background-color: #FFFFFF; line-height: 14pt; text-align: center; ; text-decoration: none}
.BG_WHITE_LEFT   { font-family: "굴림"; font-size: 10pt; color: #000000; background-color: #FFFFFF; text-align: left; ; line-height: 14pt; text-decoration: none}
.BG_WHITE_RIGHT  {  font-size: 10pt; text-decoration: none; color: #000000; line-height: 12pt; font-family: "굴림"; background-color: #FFFFFF; text-align: right}

.BG_GRAY_C { font-family: "굴림"; font-size: 10pt; color: #000000; background-color: #DDDDDD; line-height: 14pt; text-align: center; ; text-decoration: none}
.BG_YELLOW_C { font-family: "굴림"; font-size: 10pt; color: #000000; background-color: #FFFFD4; line-height: 14pt; text-align: center; ; text-decoration: none}

</style>


<script>


// 	jq$(function(){
// 		var data_div_height = document.body.clientHeight-190;
// 		data_height = data_div_height;
// 		jq$('#data_table').fixedHeaderTable({ fixedColumn: true,height:data_div_height,autoShow:true});
		
// 	});
	
	
	window.onload = function() {
		jq$(".month").monthPicker();
	}
	
	
	function getData()
	{
		var startDate = document.dataForm.startDate.value.replace(/-/g,"");
		var endDate = document.dataForm.endDate.value.replace(/-/g,"");
		
		if(endDate < startDate)
		{
			alert("<spring:message code="space.common.alert.date.search.validate" />");
			return;
		}
		
		document.getElementById("progress_div").style.visibility = "visible";
		
		document.dataForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpToolHistData.do";
		document.dataForm.target = "dataFrame";
		document.dataForm.submit();
	}
	
	
	function getMonthlyData(searchDate)
	{
 		window.open("<c:url value='/'/>space/eqp/SpaceEqpToolHistMonthly.do?searchDate="+searchDate,"eqp_hist","scrollbars=yes,toolbar=no,resizable=yes,left=200,top=200,width=1830,height=890");
	}
	
	
	function goExcel()
	{
		document.dataForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpToolHistExcelDown.do";
		document.dataForm.target = "searchFrame";
		document.dataForm.submit();
	}
	
	
	function scrollX() {
	    document.all.mainDisplayRock.scrollLeft = document.all.bottomLine.scrollLeft;
	    document.all.topLine.scrollLeft = document.all.bottomLine.scrollLeft;
	}

	function scrollY() {
	    document.all.leftDisplay.scrollTop = document.all.mainDisplayRock.scrollTop;
	    document.all.mainDisplayRock.scrollTop = document.all.leftDisplay.scrollTop;
	}
	
	function listMouseOver(obj) {
		jq$(obj).children("td").css("backgroundColor", "#FFD47F");
	}
	function listMouseOut(obj) {
		jq$(obj).children("td").css("backgroundColor", "");
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
			<tr><td colspan="3" height="3"></td></tr>
			<tr>
				<td valign="top">
					<form name="dataForm" method="post">
					<table>
						<tr>
							<td width="*">
								<div style="width:400px;border:1px solid #D5D1B0;">
									<table width="100%">
										<tr>
											<td align="center">
												<input type="text" name="startDate" id="startDate" class="month" style="height:17px;width:95px;text-align:center;" value="<%=lm_sMonth%>" readonly>
												~
												<input type="text" name="endDate" id="endDate" class="month" style="height:17px;width:95px;text-align:center;" value="<%=lm_sMonth%>" readonly>
												&nbsp;&nbsp;
												<a href='#' class='AXButton Gray' onclick="getData()">&nbsp;&nbsp;<spring:message code="space.common.button.search" />&nbsp;&nbsp;</a>
												&nbsp;&nbsp;
												<a href='javascript:goExcel()' class='AXButton Gray'>&nbsp;&nbsp;<spring:message code="space.common.button.excel" />&nbsp;&nbsp;</a>
											</t d>
										</tr> 
									</table>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div>
									<table id="data_table" cellpadding="0" cellspacing="0" border="0"> 
										
									</table>
								</div>
							</td>
						</tr>
					</table>
					</form>
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

<iframe name="dataFrame" width="0" hieght="0" style="display:none"></iframe>
<iframe name="searchFrame" width="0" hieght="0" style="display:none"></iframe>
</body>
</html>