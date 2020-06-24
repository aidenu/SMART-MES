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
<title><spring:message code="space.common.alarm.title" /></title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >

<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript">var jq$ =jQuery.noConflict();</script>
<script type="text/javascript" src="<c:url value="/js/jquery/prototype.js"/>"/></script>
<link href="<c:url value='/css/jquery/calendarview.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/jquery/calendarview.js"/>"/></script>
<link href="<c:url value='/css/titlefix/defaultTheme.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/myTheme.css'/>" rel="stylesheet" type="text/css" >
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
	startdate.setDate(startdate.getDate()-7);
	
	startyear = startdate.getFullYear();
	startmonth = startdate.getMonth()+1;
	startday = startdate.getDate();
	
	if(startmonth<10) startmonth = "0" + startmonth;
	if(startday<10) startday = "0" + startday;
	
	var startfullday = startyear + "-" + startmonth + "-" + startday;
	
	jq$(function()
	{
		var data_div_height = document.body.clientHeight-120;
		
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
		
		getAlarmList();
	}
	
	
	function getAlarmList()
	{
		startDate = document.theForm.startDateField.value.replace(/-/g,"");
		endDate = document.theForm.endDateField.value.replace(/-/g,"");
		
		if(endDate <= startDate)
		{
			alert("<spring:message code="space.common.alert.date.search.validate" />");
			return;
		}
		
		dateCnt = calDateRange(document.theForm.startDateField.value,document.theForm.endDateField.value);
		
		if(dateCnt > 356)
		{
			alert("<spring:message code="space.common.alert.year.count.validate" />");
			return;
		}
		
		document.theForm.action="${pageContext.request.contextPath}/space/common/SpaceAlarmList.do";
		document.theForm.target = "searchFrame";
		document.theForm.submit();
	}
	
	
	function setAlarmConfirm()
	{
		var strData = "";
		var rowcnt = jq$('#data_table tr').length;
		var checkcnt = 0;
		
		for(var i=1 ; i<rowcnt ; i++)
		{
			if(document.getElementById(jq$('#data_table tr')[i].title+"_check") != null && document.getElementById(jq$('#data_table tr')[i].title+"_check").checked)
			{
				strData += jq$('#data_table tr')[i].title;
				strData += "♩";
				checkcnt ++;
			}
		}
		
		if(checkcnt == 0)
		{
			alert("<spring:message code="space.common.alert.noselect" />");
		}
		else
		{
			if(confirm("<spring:message code="space.common.alert.alarm.modify" />"))
			{
				document.getElementById("progress_div").style.visibility = "visible";
				document.theForm.arrayid.value = strData.substring(0,strData.length-1);
				
				document.theForm.action="${pageContext.request.contextPath}/space/common/SpaceAlarmSave.do";
				document.theForm.target = "searchFrame";
				document.theForm.submit();
			}
		}
	}
	
	
	function setSwapcheck(obj)
	{
		if(obj.checked)
		{
			if(document.theForm.checklist.length > 1)
			{
				for(var i=0 ; i<document.theForm.checklist.length ; i++)
				{
					document.theForm.checklist[i].checked = true;
				}
			}
			else
			{
				document.theForm.checklist.checked = true;
			}
		}
		else
		{
			if(document.theForm.checklist.length > 1)
			{
				for(var i=0 ; i<document.theForm.checklist.length ; i++)
				{
					document.theForm.checklist[i].checked = false;
				}
			}
			else
			{
				document.theForm.checklist.checked = false;
			}
		}
	}
			
</script>
</head>

<body style="background-color: #2c3338;">

<div id="wrap">
	<form name="theForm" method="post">
	<input type="hidden" name="arrayid">
	<!-- container 시작 -->
	<div id="spacecontainer">
		<table>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td  valign="top">
					<table width="100%">
						<tr>
							<td id="captionSubTitle" align="center" width="350" style="background-color: #2c3338;">
								<input type="text" name="startDateField" id="startDateField" style="height:17px;width:100px;text-align:center" readonly>
								<font color="#FFFFFF">~</font>
								<input type="text" name="endDateField" id="endDateField" style="height:17px;width:100px;text-align:center" readonly>
								&nbsp;
								<select name="gubun" onChange="getAlarmList()" style="border : gray 1px solid">
									<option value="ALL">-전체-</option>
									<option value="NEW"><spring:message code="space.common.alarm.item.new" /></option>
									<option value="CONFIRM"><spring:message code="space.common.alarm.item.confirm" /></option>
								 </select>
								 &nbsp;
								<a href='#' class='AXButton Gray' onclick="getAlarmList()"><spring:message code="space.common.button.search" /></a>
							</td>
						</tr>
						<tr>
							<td>
								<div class="tableContainer" style="width:1000px;">
									<table id="data_table" class="fancyTable" > 
										<thead>
											<tr>
												<th width='50'><input type='checkbox' name="selChkAll" onclick='setSwapcheck(this);'></th>
												<th width="100"><spring:message code="space.status.chart.eqp.ration.machine" /></th>
												<th width="100"><spring:message code="space.common.alarm.item.gubun" /></th>
												<th width="150"><spring:message code="space.common.alarm.item.recieve.time" /></th>
												<th width="150"><spring:message code="space.common.alarm.item.confirm.time" /></th>
												<th width="500"><spring:message code="space.common.alarm.item.desc" /></th>
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
											</tr> 
										</tbody>
									</table>
								</div>
							</td>
						</tr>
						<tr><td height="5"></td></tr>
						<tr>
							<td align="center">
								<div id="btn_layer" style="width:1000px;">
									<a href='#' class='AXButton Gray' onclick="setAlarmConfirm()"><spring:message code="space.common.alarm.button.confirm" /></a>
									<a href='#' class='AXButton Gray' onclick="self.close()"><spring:message code="space.common.button.close" /></a>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		</td>
			</tr>
	</div>
	</form>
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