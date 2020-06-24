<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<link href="<c:url value='/css/titlefix/defaultTheme.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/myTheme.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/titlefix/jquery.fixedheadertable.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spaceutil.js"/>"/></script>
<script>


var strHtml = new StringBuffer();
		
<c:forEach var="result" items="${result}" varStatus="status">
	
	strHtml.append("<tr title='${result.UNIQUE_ID}'>");
	strHtml.append("<td><c:if test="${result.CONFIRM_FLAG == 'N'}"><input type='checkbox' name='checklist' id='${result.UNIQUE_ID}_check'></c:if></td>");
	strHtml.append("<td><font color='#<c:choose><c:when test="${result.CONFIRM_FLAG == 'N'}">FC9B90</c:when><c:otherwise>FFFFFF</c:otherwise></c:choose>'>${result.EQP_NAME}</font></td>");
	
	strHtml.append("<td><font color='#<c:choose><c:when test="${result.CONFIRM_FLAG == 'N'}">FC9B90</c:when><c:otherwise>FFFFFF</c:otherwise></c:choose>'>");
	
	if("${result.ALARM_GUBUN}" == "DEAD")
	{
		strHtml.append("전원");
	}
	else if("${result.ALARM_GUBUN}" == "RED")
	{
		strHtml.append("오류");
	}
	
	strHtml.append("</font></td>");
	
	strHtml.append("<td><font color='#<c:choose><c:when test="${result.CONFIRM_FLAG == 'N'}">FC9B90</c:when><c:otherwise>FFFFFF</c:otherwise></c:choose>'>${result.ALARM_SEND_TIME}</font></td>");
	strHtml.append("<td><font color='#<c:choose><c:when test="${result.CONFIRM_FLAG == 'N'}">FC9B90</c:when><c:otherwise>FFFFFF</c:otherwise></c:choose>'>${result.ALARM_CONFIRM_TIME}</font></td>");
	strHtml.append("<td style='text-align:left;'><font color='#<c:choose><c:when test="${result.CONFIRM_FLAG == 'N'}">FC9B90</c:when><c:otherwise>FFFFFF</c:otherwise></c:choose>'>&nbsp;${result.ALARM_DESC}</font></td>");
	strHtml.append("</tr>");
				
</c:forEach>

parent.jq$("#data_table_tbody").empty();

parent.jq$("#data_table_tbody").append(strHtml.toString());

parent.document.getElementById("progress_div").style.visibility = "hidden";

</script>