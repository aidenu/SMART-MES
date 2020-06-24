<%@ page language="java" contentType="application/vnd.ms-excel;charset=UTF-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
    response.setHeader("Content-Disposition", "attachment; filename=EqpToolHistData.xls"); 
    response.setHeader("Content-Description", "JSP Generated Data");
%>

<html>
<head>
<META HTTP-EQUIVE="CONTENT-TYPE" CONTENT="TEXT/HTML; CHARSET=UTF-8">
</head>

<body>
	<table border='1'>
		<tr>
			<td bgcolor='#D9D900' align='center'>${startDate }~${endDate }</td>
		</tr>
		<tr>
			<td>
				<table border='1'>
					<tr>
						<td align='center' bgcolor='#EDB752' rowspan='2'>대분류</td>
						<td align='center' bgcolor='#EDB752' rowspan='2'>소분류</td>
						<td align='center' bgcolor='#EDB752' rowspan='2'>파이(mm)</td>
						<td align='center' bgcolor='#EDB752' rowspan='2'>F/B</td>
						<td align='center' bgcolor='#EDB752' rowspan='2'>R(mm)</td>
						<td align='center' bgcolor='#EDB752' rowspan='2'>기장(mm)</td>
						<td align='center' bgcolor='#EDB752' rowspan='2'>이월재고</td>
					</tr>
				</table>
			</td>
			<td>
				<table border='1'>
					<tr>
						<c:forEach var="listDate" items="${listDate }" varStatus="dateStatus">
							<td align='center' bgcolor='#EDB752' colspan="2" style='mso-number-format:"\@";'>${listDate }</th>	
						</c:forEach>
						<td align='center' bgcolor='#EDB752' colspan="2">누계</th>
					</tr>
					<tr>
						<c:forEach var="listDate" items="${listDate }" varStatus="dateStatus">
							<td align='center' bgcolor='#EDB752' >입고</th>
							<td align='center' bgcolor='#EDB752'>사용</th>
						</c:forEach>
						<td align='center' bgcolor='#EDB752'>입고</th>
						<td align='center' bgcolor='#EDB752'>사용</th>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<table border='1'>
					<c:forEach var="result" items="${result }" varStatus="status">
						<tr>
							<td align='center'>${result.TOOL_LEVEL_1}</td>
							<td align='center'>${result.TOOL_LEVEL_2}</td>
							<td align='center'>${result.TOOL_PIE}</td>
							<td align='center'>${result.TOOL_FB}</td>
							<td align='center'>${result.TOOL_RADIUS}</td>
							<td align='center'>${result.TOOL_LENGTH}</td>
							<td align='center'>${result.REMAIN_COUNT}</td>
						</tr>
					</c:forEach>
				</table> 
			</td>
			<td>
				<table border='1'>
				<c:forEach var="result" items="${result }" varStatus="status">
					<tr>
					<c:forEach var="listDate" items="${listDate }" varStatus="statuslist">
						<c:set var="inDate">${listDate}_IN</c:set>
						<c:set var="outDate">${listDate}_OUT</c:set>
						<td align='center'>${result[inDate] }</td>
						<td align='center'>${result[outDate] }</td>
					</c:forEach>
						<td align='center'>${result.TOTAL_IN }</td>
						<td align='center'>${result.TOTAL_OUT }</td>
					</tr>
				</c:forEach>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>