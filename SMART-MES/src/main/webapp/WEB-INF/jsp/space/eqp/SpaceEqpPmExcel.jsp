<%@ page language="java" contentType="application/vnd.ms-excel;charset=UTF-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
    response.setHeader("Content-Disposition", "attachment; filename=EqpPmData.xls"); 
    response.setHeader("Content-Description", "JSP Generated Data");
%>

<html>
<head>
<META HTTP-EQUIVE="CONTENT-TYPE" CONTENT="TEXT/HTML; CHARSET=UTF-8">
</head>

<body>
	<table border='1'>
		<tr>
			<td align='center' bgcolor='#EDB752'>구분</td>
			<td align='center' bgcolor='#EDB752'>설비그룹</td>
			<td align='center' bgcolor='#EDB752'>설비명</td>
			<td align='center' bgcolor='#EDB752'>작업일자</td>
			<td align='center' bgcolor='#EDB752'>작업자</td>
			<td align='center' bgcolor='#EDB752'>작업시간</td>
			<td align='center' bgcolor='#EDB752'>작업비용</td>
			<td align='center' bgcolor='#EDB752'>작업내용</td>
			<td align='center' bgcolor='#EDB752'>비고</td>
		</tr>
		
		<c:forEach var="result" items="${result}" varStatus="status">
	
			<tr>
				<td align='center' style='mso-number-format:"\@";'>${result.PM_TYPE}</td>
				<td align='center' style='mso-number-format:"\@";'>${result.PM_EQPPART}</td>
				<td align='center' style='mso-number-format:"\@";'>${result.PM_EQP}</td>
				<td align='center' style='mso-number-format:"\@";'>${result.PM_DATE}</td>
				<td align='center' style='mso-number-format:"\@";'>${result.PM_WORKER_NAME}</td>
				<td align='center' style='mso-number-format:"\@";'>${result.PM_HOUR}</td>
				<td align='center' style='mso-number-format:"\@";'>${result.PM_COST}</td>
				<td align='center' style='mso-number-format:"\@";'>${result.PM_DETAIL}</td>
				<td align='center' style='mso-number-format:"\@";'>${result.PM_DESC}</td>
			</tr>
	
		</c:forEach>
		
	</table>
</body>
</html>