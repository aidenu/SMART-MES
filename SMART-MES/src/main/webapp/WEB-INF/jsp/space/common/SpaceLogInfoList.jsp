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
	var strTitleHtml = new StringBuffer();
	var strOldProductValue = new StringBuffer();
	parent.arrProductNo = new Array();
	
	strTitleHtml.append("<thead>");
	strTitleHtml.append("<tr>");
	strTitleHtml.append("<th width='50'>NO</th>");
	strTitleHtml.append("<th width='200'>EVENT_TIME</th>");
	strTitleHtml.append("<th width='200'>MAC_ADDRESS</th>");
	strTitleHtml.append("<th width='100'>RED_FLAG</th>");
	strTitleHtml.append("<th width='100'>AMBER_FLAG</th>");
	strTitleHtml.append("<th width='100'>GREEN_FLAG</th>");
	strTitleHtml.append("<th width='100'>BLUE_FLAG</th>");
	strTitleHtml.append("<th width='100'>WHITE_FLAG</th>");
	strTitleHtml.append("<th width='100'>BUZZER_FLAG</th>");
	strTitleHtml.append("<th width='100'>WDTMONITORING</th>");
	strTitleHtml.append("</tr>");
	strTitleHtml.append("</thead>");
	strTitleHtml.append("<tbody>");
	
	
	<c:forEach var="result" items="${result}" varStatus="status">

		strHtml.append("<tr>");
		strHtml.append("<td><font color='#FFFFFF'>${result.RNUM}</font></td>");
		strHtml.append("<td><font color='#FFFFFF'>${result.EVENT_TIME}</font></td>");
		strHtml.append("<td><font color='#FFFFFF'>${result.MAC_ADDRESS}</font></td>");
		strHtml.append("<td><font color='#FFFFFF'>${result.RED_FLAG}</font></td>");
		strHtml.append("<td><font color='#FFFFFF'>${result.AMBER_FLAG}</font></td>");
		strHtml.append("<td><font color='#FFFFFF'>${result.GREEN_FLAG}</font></td>");
		strHtml.append("<td><font color='#FFFFFF'>${result.BLUE_FLAG}</font></td>");
		strHtml.append("<td><font color='#FFFFFF'>${result.WHITE_FLAG}</font></td>");
		strHtml.append("<td><font color='#FFFFFF'>${result.BUZZER_FLAG}</font></td>");
		strHtml.append("<td><font color='#FFFFFF'>${result.WDTMONITORING}</font></td>");
		strHtml.append("</tr>");
				
	</c:forEach>
	
	strHtml.append("</tbody>");
	
	strTitleHtml.append(strHtml.toString());
	
	parent.jq$("#data_table").empty();
	parent.jq$("#data_table").append(strTitleHtml.toString());
	parent.jq$('#data_table').fixedHeaderTable({ fixedColumn: true,height:parent.data_height,autoShow:true});
	
	parent.jq$("#paging_div").empty();
	parent.jq$('#paging_div').append("<font color='#FFFFFF'>${paginationInfo}</font>"); 	
 	
</script>

