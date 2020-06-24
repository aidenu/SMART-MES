<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<link href="<c:url value='/css/egovframework/mbl/cmm/jquery.mobile-1.4.5.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/egovframework/mbl/cmm/EgovMobile-1.4.5.css'/>" rel="stylesheet" type="text/css" >

<script type="text/javascript" src="<c:url value="/js/egovframework/mbl/cmm/jquery-1.11.2.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/egovframework/mbl/cmm/jquery.mobile-1.4.5.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/egovframework/mbl/cmm/EgovMobile-1.4.5.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spaceutil.js"/>"/></script>
<script>

var strHtml = new StringBuffer();

<c:forEach var="result" items="${alarmlist}" varStatus="status">

	strHtml.append("<tr>");
	strHtml.append("<td width='100%'>");
	strHtml.append("<table border=0 cellspacing=1 cellpadding=0 bgcolor='#000000' width='100%'>");
	strHtml.append("<tr>");
	strHtml.append("<td width='10%' align='center' rowspan='2' bgcolor='#FFFFFF'><input type='checkbox' name='checkList' id='${result.UNIQUE_ID}'></td>");
	strHtml.append("<td width='90%' align='center' bgcolor='#FFFFFF' onclick='getAlarmInfo(\"${result.UNIQUE_ID}\")'>${result.ALARM_SEND_TIME}</td>");
	strHtml.append("</tr>");
	strHtml.append("<tr>");
	strHtml.append("<td align='left' bgcolor='#FFFFFF' style='wihte-break:break-all' onclick='getAlarmInfo(\"${result.UNIQUE_ID}\")'>${result.ALARM_DESC}</td>");
	strHtml.append("</tr>");
	strHtml.append("</table>");
	strHtml.append("</td>");
	strHtml.append("</tr>");
			
</c:forEach>

parent.$("#data_table").append(strHtml.toString());
parent.document.dataForm.pageno.value = ${pageno}+1;
parent.$.mobile.loading( "hide" );

	
</script>
