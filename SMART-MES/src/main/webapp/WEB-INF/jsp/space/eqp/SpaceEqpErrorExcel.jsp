<%@ page language="java" contentType="application/vnd.ms-excel;charset=UTF-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
    response.setHeader("Content-Disposition", "attachment; filename=EQP_ERROR_LIST.xls"); 
    response.setHeader("Content-Description", "JSP Generated Data");
%>

<html>
<head>
<META HTTP-EQUIVE="CONTENT-TYPE" CONTENT="TEXT/HTML; CHARSET=UTF-8">
</head>

<body>
	<table border='1'>
		<tr>
			<td align='center' bgcolor='#FFFFFF' colspan='4'><h3><spring:message code="space.status.result.eqp.error.title" /></h3></td>
		</tr>
		<tr>
			<td align='center' bgcolor='#D2CE86' colspan='2'><b><spring:message code="space.status.chart.eqp.search.interval" /> : ${startdate} ~ ${enddate}</b></td>
			<td align='center' bgcolor='#D2CE86' colspan='2'><b><spring:message code="space.status.status.eqp.part" /> : ${eqppart}</b></td>
		</tr>
		<tr>
			<td colspan='4'></td>
		</tr>
		<tr>
			<td align='center' bgcolor='#D2CE86'><b><spring:message code="space.status.chart.eqp.ration.machine" /></b></td>
			<td align='center' bgcolor='#D2CE86'><b><spring:message code="space.status.start.time" /></b></td>
			<td align='center' bgcolor='#D2CE86'><b><spring:message code="space.status.end.time" /></b></td>
			<td align='center' bgcolor='#D2CE86'><b><spring:message code="space.status.elap.time" /></b></td>
		</tr>
		
		<c:forEach var="result" items="${result}" varStatus="status">
	
			<tr bgcolor='#FFFFFF'>
				<td align='center' style='mso-number-format:"\@";'>${result.EQP_NAME}</td>
				<td align='center' style='mso-number-format:"\@";'>${result.START_TIME}</td>
				<td align='center' style='mso-number-format:"\@";'>${result.END_TIME}</td>
				<td align='center' style='mso-number-format:"\@";'>${result.ELAP_TIME}</td>
			</tr>
	
		</c:forEach>
	</table>
</body>
</html>