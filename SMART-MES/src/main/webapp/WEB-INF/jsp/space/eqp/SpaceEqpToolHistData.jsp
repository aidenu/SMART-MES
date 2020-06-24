<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript">var jq$ =jQuery.noConflict();</script>
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
	/* 
	var diff = endDateTemp - startDateTemp;
	var currDay = 24 * 60 * 60 * 1000;//시*분*초*밀리세컨
	var currMonth = currDay * 30;
	
	var dateCnt = parseInt(diff/currMonth)+1;
	 */
	
	var displayHeight = parent.document.body.clientHeight-290;
	
	var bottomLineWidth = parent.document.body.clientWidth -750;
	var topLineMaxWidth = parent.document.body.clientWidth -750;
	var mainDisplayRockMaxWidth = parent.document.body.clientWidth-733;
	
	var tableWidth = ((dateCnt+1) * 141)+45;	//+45은 스크롤바 size
	var dataTableWidth = (dateCnt+1) * 141;
	
	var strHtml = new StringBuffer();
	var strTitleHtml = new StringBuffer();
	
	strHtml.append("<tr>");
	
	//좌측 Title
	strHtml.append("	<td>");
	strHtml.append("		<table cellspacing='1' cellpadding='0' border='0' class='main_table'>");
	strHtml.append("			<tr>");
	strHtml.append("				<td width='100px' nowrap height='93' class='TIT_CONT_GRAY_C' rowspan='2'>대분류</td>");
	strHtml.append("				<td width='100px' nowrap class='TIT_CONT_GRAY_C' rowspan='2'>소분류</td>");
	strHtml.append("				<td width='100px' nowrap class='TIT_CONT_GRAY_C' rowspan='2'>파이(mm)</td>");
	strHtml.append("				<td width='100px' nowrap class='TIT_CONT_GRAY_C' rowspan='2'>F/B</td>");
	strHtml.append("				<td width='100px' nowrap class='TIT_CONT_GRAY_C' rowspan='2'>R(mm)</td>");
	strHtml.append("				<td width='100px' nowrap class='TIT_CONT_GRAY_C' rowspan='2'>기장(mm)</td>");
	strHtml.append("				<td width='100px' nowrap class='TIT_CONT_GRAY_C' rowspan='2'>이월재고</td>");
	strHtml.append("			</tr>");
	strHtml.append("		</table>");
	strHtml.append("	</td>");

	//우측 Title
	strHtml.append("	<td>");
	strHtml.append("		<div id='topLine' style='overflow:hidden;width:");strHtml.append(topLineMaxWidth);strHtml.append("px;'>");
	strHtml.append("			<table width='");strHtml.append(dataTableWidth);strHtml.append("px' cellspacing='1' cellpadding='0' border='0' class='main_table'>");//width 는 좌우스크롤시 움직이는 부분 + 30
	
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
	
	strHtml.append("<tr>");
	
	//좌측 품명,사이즈,이월재고 데이터
	strHtml.append("	<td>");
	strHtml.append("		<div id='leftDisplay' style='overflow: hidden;height: ");strHtml.append(displayHeight);strHtml.append("px;'  onscroll='scrollY()'>");
	strHtml.append("			<table cellspacing='1' cellpadding='0' border='0' class='main_table'>");
	<c:forEach var="result" items="${result}" varStatus="status">
		strHtml.append("			<tr title='${result.TOOL_ID}'>");
		strHtml.append("				<td width='100px' height='40' class='BG_WHITE_C' nowrap>${result.TOOL_LEVEL_1}</td>");
		strHtml.append("				<td width='100px' class='BG_WHITE_C'>${result.TOOL_LEVEL_2}</td>");
		strHtml.append("				<td width='100px' class='BG_WHITE_C'>${result.TOOL_PIE}</td>");
		strHtml.append("				<td width='100px' class='BG_WHITE_C'>${result.TOOL_FB}</td>");
		strHtml.append("				<td width='100px' class='BG_WHITE_C'>${result.TOOL_RADIUS}</td>");
		strHtml.append("				<td width='100px' class='BG_WHITE_C'>${result.TOOL_LENGTH}</td>");
		strHtml.append("				<td width='100px' class='BG_WHITE_C'>${result.REMAIN_COUNT}</td>");
		strHtml.append("			</tr>");
	</c:forEach>
	strHtml.append("			</table>");
	strHtml.append("		</div>");
	strHtml.append("	</td>");
	
	//우측 월별 입고/사용량 데이터
	strHtml.append("	<td>");
	strHtml.append("		<div id='mainDisplayRock' style='overflow-y:scroll;overflow-x:hidden;height: ");strHtml.append(displayHeight);strHtml.append("px;max-width:");strHtml.append(mainDisplayRockMaxWidth);strHtml.append("px;width:");strHtml.append(tableWidth);strHtml.append("px;'  onscroll='scrollY()' oncontextmenu='return false;'>");
	strHtml.append("			<table width='");strHtml.append(dataTableWidth);strHtml.append("px' cellspacing='1' cellpadding='0' border='0' class='main_table'>");
	
	<c:forEach var="result" items="${result}" varStatus="status">
		strHtml.append("			<tr title='${result.TOOL_ID}' onmouseover='listMouseOver(this)' onmouseout='listMouseOut(this)'>");
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
	strHtml.append("		<div id='bottomLine' style='overflow-x:scroll;overflow-y:hidden;max-width:");strHtml.append(bottomLineWidth);strHtml.append("px;width:");strHtml.append(tableWidth);strHtml.append("px;' onscroll='scrollX()'>");
	strHtml.append("			<table width='");strHtml.append(tableWidth);strHtml.append("'cellspacing='1' cellpadding='0' border='0'>");
	strHtml.append("				<tr>");
	strHtml.append("					<td height='0' nowrap class='BG_WHITE_RIGHT'></td>");
	strHtml.append("				</tr>");
	strHtml.append("			</table>");
	strHtml.append("		</div>");
	strHtml.append("	</td>");
	strHtml.append("</tr>");
	
	
	parent.jq$("#data_table").empty();
	
	parent.jq$("#data_table").append(strHtml.toString());
	

	parent.document.getElementById("progress_div").style.visibility = "hidden";	
	
	
</script>