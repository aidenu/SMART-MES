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
<meta http-equiv="Content-Language" content="ko" >
<title>공구이력</title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >

<link href="<c:url value='/css/titlefix/defaultTheme.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/myTheme.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/titlefix/jquery.fixedheadertable.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spacevalidate.js"/>"/></script>

<style type = "text/css">

.main_table {
  border           : solid;
  border-color     : black black #000000;
  border-width     : 0px 0px 0px 0px;
  background-color : #666666;
  text-align       : center;
  font-size        : 12pt;
  table-layout     : fixed;
}

.TIT_CONT_GRAY_A { font-family: "굴림"; font-size: 10pt; color: #000000; background-color: #FCE2A0; line-height: 14pt; font-weight: bold; text-align: center;}
.TIT_CONT_GRAY_B { font-family: "굴림"; font-size: 10pt; color: #000000; background-color: #D5D5AA; line-height: 14pt; font-weight: bold; text-align: center;}
.TIT_CONT_GRAY_C { font-family: "굴림"; font-size: 10pt; color: #000000; background-color: #95CAFF; line-height: 14pt; font-weight: bold; text-align: center;}
.BG_WHITE_C { font-family: "굴림"; font-size: 10pt; color: #000000; background-color: #FFFFFF; line-height: 14pt; text-align: center; ; text-decoration: none}
.BG_WHITE_LEFT   { font-family: "굴림"; font-size: 10pt; color: #000000; background-color: #FFFFFF; text-align: left; ; line-height: 14pt; text-decoration: none}
.BG_WHITE_RIGHT  {  font-size: 10pt; text-decoration: none; color: #000000; line-height: 12pt; font-family: "굴림"; background-color: #FFFFFF; text-align: right}

.BG_GRAY_C { font-family: "굴림"; font-size: 10pt; color: #000000; background-color: #DDDDDD; line-height: 14pt; text-align: center; ; text-decoration: none}
.BG_YELLOW_C { font-family: "굴림"; font-size: 10pt; color: #000000; background-color: #FFFFD4; line-height: 14pt; text-align: center; ; text-decoration: none}

</style>

<script>
	
	window.history.forward();
	
	window.onload = function() {
		var openerX = opener.screenX;
		var openerY = opener.screenY;
		window.moveTo(openerX+50, openerY+50);
	}
	
	function goExcel()
	{
		document.dataForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpToolHistMonthlyExcelDown.do";
		document.dataForm.target = "searchFrame";
		document.dataForm.submit();
	}
	
	function scrollX() {
	    document.all.mainDisplayRock.scrollLeft = document.all.bottomLine.scrollLeft;
	    document.all.topLine.scrollLeft = document.all.bottomLine.scrollLeft;
	}

	function scrollY() {
	    document.all.leftDisplay.scrollTop = document.all.mainDisplayRock.scrollTop;
	    document.all.mainDisplayRock.scrollTop = document.all.leftDisplay.scrollTop;
	}
	
	function listMouseOver(obj) {
		$(obj).children("td").css("backgroundColor", "#FFD47F");
	}
	function listMouseOut(obj) {
		$(obj).children("td").css("backgroundColor", "");
	}
	
</script>

</head>

<body>

<div id="wrap">
	
	<!-- container 시작 -->
	
	<form name="dataForm" method="post">
	<input type="hidden" name="searchDate" value="${searchDate}">
					
	<div id="spacecontainer">
		<table>
			<tr><td colspan="3">&nbsp;</td></tr>
			<tr>
				<td  valign="top">
					<table>
						<tr>
							<td id='btn_layer' align="center">
								<a href='javascript:goExcel()' class='AXButton Green'>엑셀</a>
								&nbsp;
								<a href='#' class='AXButton Green' onclick="self.close()">닫기</a>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td>
								<div style="width:100px;border: 1px solid #D5D1B0;">
									<table width="100%">
										<tr>
											<td id="captionSubTitle" align="center">
												<H1>${searchDate }</H1>
											</td>
										</tr>
									</table>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div>
									<form name="theForm" method="post">
									<table id="data_table" cellpadding="0" cellspacing="0" border="0"> 
											<tr>
												<td>
													<table cellspacing="1" cellpadding="0" border="0" class="main_table">
														<tr>
															<td width="100px" nowrap height="93" class="TIT_CONT_GRAY_C" rowspan="2">대분류</th>
															<td width="100px" nowrap class="TIT_CONT_GRAY_C" rowspan="2">소분류</th>
															<td width="100px" nowrap class="TIT_CONT_GRAY_C" rowspan="2">파이(mm)</th>
															<td width="100px" nowrap class="TIT_CONT_GRAY_C" rowspan="2">F/B</th>
															<td width="100px" nowrap class="TIT_CONT_GRAY_C" rowspan="2">R(mm)</th>
															<td width="100px" nowrap class="TIT_CONT_GRAY_C" rowspan="2">기장(mm)</th>
														</tr>
													</table>
												</td>
												
												<td>
													<div id='topLine' style='overflow:hidden;width:1170px;'>
														<table width="4939px"  cellspacing="1" cellpadding="0" border="0" class="main_table"><!-- width 는 좌우스크롤시 움직이는 부분 + 30  -->
															<tr>
																<td width="100" class="TIT_CONT_GRAY_C" colspan="2" style="border-right: double;">누계</th>
																<c:forEach var="listDate" items="${listDate }" varStatus="dateStatus">
																	<td width="150" height="61" class="TIT_CONT_GRAY_C" colspan="3" style="border-right: double;">${listDate}일</th>	
																</c:forEach>
															</tr>
															<tr>
																<td width="50" class="TIT_CONT_GRAY_C" >입고</th>
																<td width="50" class="TIT_CONT_GRAY_C"  style="border-right: double;">사용</th>
																<c:forEach var="listDate" items="${listDate }" varStatus="dateStatus">
																	<td width="50" height="30" class="TIT_CONT_GRAY_C" >입고</th>
																	<td width="50" class="TIT_CONT_GRAY_C" >사용</th>
																	<td width="50" class="TIT_CONT_GRAY_C" style="border-right: double;">재고</th>
																</c:forEach>
															</tr>
														</table>
													</div>
												</td>
											</tr>
											<tr>
												<td>
													<div id='leftDisplay' style='overflow:hidden; height:650px;' onscroll='scrollY()'>
														<table cellspacing='1' cellpadding='0' border='0' class='main_table'>
															<c:forEach var="result" items="${result }" varStatus="status">
																<tr name="${result.TOOL_ID}">
																	<td width="100px" nowrap height="40px" class="BG_WHITE_C">${result.TOOL_LEVEL_1}</td>
																	<td width="100px" nowrap class="BG_WHITE_C">${result.TOOL_LEVEL_2}</td>
																	<td width="100px" nowrap class="BG_WHITE_C">${result.TOOL_PIE}</td>
																	<td width="100px" nowrap class="BG_WHITE_C">${result.TOOL_FB}</td>
																	<td width="100px" nowrap class="BG_WHITE_C">${result.TOOL_RADIUS}</td>
																	<td width="100px" nowrap class="BG_WHITE_C">${result.TOOL_LENGTH}</td>
																</tr>
															</c:forEach>
														</table> 
													</div>
												</td>
												<td>
													<div id='mainDisplayRock' style='overflow-y:scroll;overflow-x:hidden;height:650px;width:1187px;' onscroll='scrollY()' oncontextmenu='return false;'>
														<table width="4939px" cellspacing="1" cellpadding="0" border="0" class="main_table">
														<c:forEach var="result" items="${result }" varStatus="status">
															<tr name="${result.STOCK_ID }" onmouseover="listMouseOver(this)" onmouseout="listMouseOut(this)">
																<td width="51px" height="40px" class="BG_YELLOW_C">${result.TOTAL_IN }</td>
																<td width="48px" class="BG_YELLOW_C" style="border-right: double;">${result.TOTAL_OUT }</td>
															<c:forEach var="listDate" items="${listDate }" varStatus="statuslist">
																<c:set var="inDate">${listDate}_IN</c:set>
																<c:set var="outDate">${listDate}_OUT</c:set>
																<c:set var="remainDate">${listDate}_REMAIN_CNT</c:set>
																<c:choose>
																	<c:when test="${statuslist.index%2 == 0 }">
																		<td width="51px" height="40px" class="BG_GRAY_C">${result[inDate] }</td>
																		<td width="51px" class="BG_GRAY_C">${result[outDate] }</td>
																		<td width="48px" class="BG_GRAY_C" style="border-right: double;">${result[remainDate] }</td>
																	</c:when>
																	<c:otherwise>
																		<td width="51px" height="40px" class="BG_WHITE_C">${result[inDate] }</td>
																		<td width="51px" class="BG_WHITE_C">${result[outDate] }</td>
																		<td width="48px" class="BG_WHITE_C" style="border-right: double;">${result[remainDate] }</td>
																	</c:otherwise>
																</c:choose>
															</c:forEach>
															</tr>
														</c:forEach>
														</table>
													</div>
												</td>
											</tr>
											<tr>
												<td>
													<table cellspaceing="0" cellpadding="0" border="0">
														<tr>
															<td></td>
														</tr>
													</table>
												</td>
												<td>
													<div id='bottomLine' style='overflow=x:scroll;overflow-y:hidden;width:1170px;' onscroll='scrollX()'>
														<table width="4939px" cellspacing="1" cellpadding="0" border="0">
															<tr>
																<td height="0" nowrap class='BG_WHITE_RIGHT'></td>
															</tr>
														</table>
													</div>
												</td>
											</tr>
									</table>
									</form>
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