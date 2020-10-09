<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript">var $ =jQuery.noConflict();</script>
<link href="<c:url value='/css/titlefix/defaultTheme.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/myTheme.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/titlefix/jquery.fixedheadertable.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spaceutil.js"/>"/></script>
<script>

		
	var startDate = "${startDate}";
	var endDate = "${endDate}";
	
	//시작일과 종료일 개월수 구하기
	var arr1 = startDate.split('-');
	var arr2 = endDate.split('-');
	var startDateTemp = new Date(arr1[0], arr1[1]);
	var endDateTemp = new Date(arr2[0], arr2[1]);
	
	dateCnt = 0;
	if(arr1[0] == arr2[0]) {
		dateCnt = arr2[1] - arr1[1] + 1;
	} else {
		dateCnt = Math.round((endDateTemp.getTime()-startDateTemp.getTime())/(1000*60*60*24*365/12))+1;
	}
	
	var displayHeight = parent.document.body.clientHeight-630;
	
	var strHtml = new StringBuffer();
	var strTitleHtml = new StringBuffer();
	
	
	
	//좌측 Title
	strTitleHtml.append("<tr>");
	strTitleHtml.append("	<td>");
	strTitleHtml.append("		<table cellspacing='1' cellpadding='0' border='0' class='main_table'>");
	strTitleHtml.append("			<tr>");
	strTitleHtml.append("				<td nowrap height='91' class='TIT_CONT_GRAY_C' style='width:40%;'>부품명</td>");
	strTitleHtml.append("				<td nowrap class='TIT_CONT_GRAY_C' style='width:40%;'>사이즈</td>");
	strTitleHtml.append("				<td nowrap class='TIT_CONT_GRAY_C' style='width:20%;'>이월재고</td>");
	strTitleHtml.append("			</tr>");
	strTitleHtml.append("		</table>");
	strTitleHtml.append("	</td>");
	strTitleHtml.append("</tr>");
	
	//좌측 품명,사이즈,이월재고 데이터
	strTitleHtml.append("<tr>");
	strTitleHtml.append("	<td>");
	strTitleHtml.append("		<div id='leftDisplay' style='overflow: hidden;height:");strTitleHtml.append(displayHeight);strTitleHtml.append("px;'  onscroll='scrollY()'>");
	strTitleHtml.append("			<table cellspacing='1' cellpadding='0' border='0' class='main_table'>");
	<c:forEach var="result" items="${result}" varStatus="status">
		strTitleHtml.append("			<tr title='${result.STOCK_ID}'>");
		strTitleHtml.append("				<td height='40' class='BG_WHITE_C' nowrap style='width:40%;'>${result.STOCK_NAME}</td>");
		strTitleHtml.append("				<td class='BG_WHITE_C' style='width:40%;'>${result.STOCK_SIZE}</td>");
		strTitleHtml.append("				<td class='BG_WHITE_C' style='width:20%;'>${result.REMAIN_COUNT}</td>");
		strTitleHtml.append("			</tr>");
	</c:forEach>
	strTitleHtml.append("			</table>");
	strTitleHtml.append("		</div>");
	strTitleHtml.append("	</td>");
	strTitleHtml.append("</tr>");

	parent.$("#data_table_head").empty();
	parent.$("#data_table_head").append(strTitleHtml.toString());
	
	
	//우측 Title
	strHtml.append("<tr>");
	strHtml.append("	<td>");
	strHtml.append("		<div id='topLine' style='overflow:hidden;width:calc(100% - 17px);'>");
	strHtml.append("			<table cellspacing='1' cellpadding='0' border='0' class='main_table'>");//width 는 좌우스크롤시 움직이는 부분 + 30
	
	strHtml.append("				<tr>");
	var nextDateTemp = startDateTemp;
	var nextDate = "";	//컬럼 타이틀(년월을 합친 최종 date)
	var nextYear = "";	//컬럼 타이틀(년)
	var nextMonth = "";	//컬럼 타이틀(월)
	for(var i=0; i<dateCnt; i++){
		if(i==0)
			nextDateTemp.setMonth(nextDateTemp.getMonth()+0);
		else
			nextDateTemp.setMonth(nextDateTemp.getMonth()+1);
		nextYear = nextDateTemp.getFullYear();
		nextMonth = nextDateTemp.getMonth();
		if(nextMonth == "0"){
			//12월의 경우 다음년도와 0으로 나옴...
			nextYear = nextYear-1;
			nextMonth = "12";
		}
		if(nextMonth < 10)
			nextMonth = "0"+nextMonth;
		nextDate = nextYear+'-'+nextMonth;	
		strHtml.append("				<td width='140px' height='61' class='TIT_CONT_GRAY_C' colspan='2' style='cursor:pointer;' onclick='getMonthlyData(\"");strHtml.append(nextDate);strHtml.append("\")' >");strHtml.append(nextDate);strHtml.append("</td>");
	}
	strHtml.append("					<td width='140px' class='TIT_CONT_GRAY_C' colspan='2'>누계</td>");
	strHtml.append("				</tr>");
	strHtml.append("				<tr>");
	for(var i=0; i<dateCnt; i++){
		strHtml.append("				<td width='70px' height='30' class='TIT_CONT_GRAY_C'>입고</td>");
		strHtml.append("				<td width='70px' class='TIT_CONT_GRAY_C'>사용</td>");
	}
	strHtml.append("					<td width='70px' height='30' class='TIT_CONT_GRAY_C'>입고</td>");
	strHtml.append("					<td width='70px' class='TIT_CONT_GRAY_C'>사용</td>");
	strHtml.append("				</tr>");
	strHtml.append("			</table>");
	strHtml.append("		</div>");
	strHtml.append("	</td>");
	strHtml.append("</tr>");
	
	
	//우측 월별 입고/사용량 데이터
	strHtml.append("<tr>");
	strHtml.append("	<td>");
	strHtml.append("		<div id='mainDisplayRock' style='overflow-y:scroll;overflow-x:hidden;height:");strHtml.append(displayHeight);strHtml.append("px;'  onscroll='scrollY()' oncontextmenu='return false;'>");
	strHtml.append("			<table cellspacing='1' cellpadding='0' border='0' class='main_table'>");
	
	<c:forEach var="result" items="${result}" varStatus="status">
		strHtml.append("			<tr title='${result.STOCK_ID}' onmouseover='listMouseOver(this)' onmouseout='listMouseOut(this)'>");
		<c:forEach var="listDate" items="${listDate}" varStatus="statuslist">
			<c:set var="inDate">${listDate}_IN</c:set>
			<c:set var="outDate">${listDate}_OUT</c:set>
			<c:choose>
				<c:when test="${statuslist.index%2 == 0}">
					strHtml.append("		<td width='70px' height='40' class='BG_GRAY_C'>${result[inDate]}</td>");
					strHtml.append("		<td width='70px' class='BG_GRAY_C'>${result[outDate]}</td>");
				</c:when>
				<c:otherwise>
					strHtml.append("		<td width='70px' height='40' class='BG_WHITE_C'>${result[inDate]}</td>");
					strHtml.append("		<td width='70px' class='BG_WHITE_C'>${result[outDate]}</td>");
				</c:otherwise>
			</c:choose>
		</c:forEach>
		strHtml.append("			<td width='70px' height='40' class='BG_YELLOW_C'>${result.TOTAL_IN}</td>");
		strHtml.append("			<td width='70px' class='BG_YELLOW_C'>${result.TOTAL_OUT}</td>");
		strHtml.append("			</tr>");
	</c:forEach>
	
	strHtml.append("			</table>");
	strHtml.append("		</div>");
	strHtml.append("	</td>");
	
	strHtml.append("</tr>");
	
	strHtml.append("<tr>");
	strHtml.append("	<td>");
	strHtml.append("		<table cellspacing='0' cellpadding='0' border='0'>");
	strHtml.append("			<tr>");
	strHtml.append("				<td></td>");
	strHtml.append("			</tr>");
	strHtml.append("		</table>");
	strHtml.append("	</td>");
	strHtml.append("	<td>");
	strHtml.append("		<div id='bottomLine' style='overflow-x:scroll;overflow-y:hidden;' onscroll='scrollX()'>");
	strHtml.append("			<table cellspacing='1' cellpadding='0' border='0'>");
	strHtml.append("				<tr>");
	strHtml.append("					<td height='0' nowrap class='BG_WHITE_RIGHT'></td>");
	strHtml.append("				</tr>");
	strHtml.append("			</table>");
	strHtml.append("		</div>");
	strHtml.append("	</td>");
	strHtml.append("</tr>");
	
	parent.$("#data_table_main").empty();
	parent.$("#data_table_main").append(strHtml.toString());

</script>