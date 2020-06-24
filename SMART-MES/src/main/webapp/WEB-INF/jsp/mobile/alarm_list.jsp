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

<script>

	$(document).ready(function (){
		
		$(window).scroll(function (){
			
			if($(window).scrollTop() == $(document).height() - $(window).height()){ //최하단의 위치값과 동일여부
				getHiddenList();
			} 
		});
		
		getHiddenList();
	}); 
	

	function init()
	{
		$.mobile.loader.prototype.options.text = "loading";
		$.mobile.loader.prototype.options.textVisible = false;
		$.mobile.loader.prototype.options.theme = "a";
		$.mobile.loader.prototype.options.html = "";
	}
	
	function getAlarmList()
	{
			
		$.mobile.loading( 'show', {
		text: "Loading Page...",
		textVisible: true,
		theme: "b",
		textonly: true,
		html: ""
		});
		
		document.dataForm.action = "${pageContext.request.contextPath}/mobile/alarm_list.do";
		document.dataForm.target = "";
		document.dataForm.submit();
	}
	
	
	function getHiddenList()
	{
		$.mobile.loading( 'show', {
			text: "Loading Page...",
			textVisible: true,
			theme: "b",
			textonly: true,
			html: ""
			});
			
			document.dataForm.action = "${pageContext.request.contextPath}/mobile/alarm_list_hidden.do";
			document.dataForm.target = "hiddenFrame";
			document.dataForm.submit();
	}
	
	
	function setAlarmConfirm()
	{
		var strData = "";
		var rowcnt = ${fn:length(alarmlist)};
		var checkcnt = 0;
		
		if(rowcnt < 2)
		{
		   if(document.dataForm.checkList.checked)
		   {
		      strData += document.dataForm.checkList.id;
		      strData += "|";
		      checkcnt ++;
		   }
		}
		else
		{
		   for(var i=0 ; i<rowcnt ; i++)
		   {
		      if(document.dataForm.checkList[i].checked)
		      {
		         strData += document.dataForm.checkList[i].id;
		         strData += "|";
		         checkcnt ++;
		      }
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
				document.getElementById("btn_layer").style.display = "none";
				
				$.mobile.loading( 'show', {
				text: "Saving Page...",
				textVisible: true,
				theme: "b",
				textonly: true,
				html: ""
				});
				
				document.dataForm.arrayid.value = strData.substring(0,strData.length-1);
				
				document.dataForm.action="${pageContext.request.contextPath}/mobile/alarm_confirm.do";
				document.dataForm.target = "hiddenFrame";
				document.dataForm.submit();
			}
		}
	}
	
	function selfReload()
	{
		location.reload(); 
	}
				
</script>
</head>

<body onload="init()">
<form name="dataForm">
<input type="hidden" name="userid" value="${userid}">
<input type="hidden" name="arrayid">
<input type="hidden" name="uniqueid">
<input type="hidden" name="pageno">

<header data-tap-toggle="false" data-position="fixed" data-theme="a" data-role="header">
    <h1><spring:message code="space.common.alarm.title" />(${userid})</h1>
</header>

<br>

<div data-role="controlgroup" class="checkList">
	<ul data-role="listview" data-inset="false" id="group_1">
		<table id="data_table" width="100%">
			<c:if test="${fn:length(alarmlist)>0}">
				<c:forEach var="result" items="${alarmlist}" varStatus="status">
					<tr>
						<td width="100%">
							<table border=0 cellspacing=1 cellpadding=0 bgcolor="#000000" width="100%">
								<tr>
									<td width="10%" align="center" rowspan="2" bgcolor="#FFFFFF"><input type='checkbox' name="checkList" id="${result.UNIQUE_ID}"></td>
									<td width="90%" align="center" bgcolor="#FFFFFF">${result.ALARM_SEND_TIME}</td>
								</tr>
								<tr>
									 <%-- <td align="left" bgcolor="#FFFFFF"><p>&nbsp;${fn:substring(result.ALARM_DESC, 0, 30)}...</p></td> --%>
									 <td align="left" bgcolor="#FFFFFF" style="wihte-break:break-all">${result.ALARM_DESC}</td>
								</tr>
							</table>
						</td>
					</tr>
				</c:forEach>
			</c:if>
		</table>
		
		<c:if test="${fn:length(alarmlist)==0}">
			<li data-icon="false" style="text-align:center"><spring:message code="space.common.search.nodata" /></li>
		</c:if>
 	</ul>
</div>

<br>

<footer data-tap-toggle="false" data-position="fixed" data-theme="a" data-role="footer" data-hide-during-focus="">
	<div  style="text-align: center;" id="btn_layer">
		<a href="#" data-role="button" data-theme="a" onclick="setAlarmConfirm()"><spring:message code="space.common.alarm.button.confirm" /></a>
		<a href="#" data-role="button" data-theme="a" onclick="getAlarmList()"><spring:message code="space.common.button.search" /></a>
	</div>
</footer>

</form>

<iframe name="hiddenFrame" width="0" hieght="0" style="visibility:hidden"></iframe>
</body>
</html>