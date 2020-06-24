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
<title>일별 가동 현황</title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >

<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript">var jq$ =jQuery.noConflict();</script>
<script type="text/javascript" src="<c:url value="/js/jquery/prototype.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/titlefix/jquery.fixedheadertable.js"/>"/></script>
<link href="<c:url value='/css/titlefix/defaultTheme.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/myTheme.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/spacevalidate.js"/>"/></script>
</head>

<body style="background-color: #2c3338;">

<div id="wrap">
	<!-- container 시작 -->
	<div id="spacecontainer">
		<table>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td  valign="top">
					<table width="100%">
						<tr>
							<td>
								<table width="100%">
									<tr>
										<td width="100%" id="captionTitle">상태별 진행 시간</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td height="5"></td></tr>
						<tr>
							<td>
								<table width="100%">
									<tr>
										<td width="50%" id="captionTitle">설비명</td>
										<td width="50%" id="captionSubTitle" align="left" style="padding-left:10px">${eqpname}</td>
									</tr>
									<tr>
										<td width="50%" id="captionTitle">조회일</td>
										<td width="50%" id="captionSubTitle" align="left" style="padding-left:10px">${searchdate}</td>
									</tr>
									<tr>
										<td width="50%" id="captionTitle">GREEN</td>
										<td width="50%" id="captionSubTitle" align="left" style="padding-left:10px">${GREEN_TIME}</td>
									</tr>
									<tr>
										<td width="50%" id="captionTitle">AMBER</td>
										<td width="50%" id="captionSubTitle" align="left" style="padding-left:10px">${AMBER_TIME}</td>
									</tr>
									<tr>
										<td width="50%" id="captionTitle">RED</td>
										<td width="50%" id="captionSubTitle" align="left" style="padding-left:10px">${RED_TIME}</td>
									</tr>
									<tr>
										<td width="50%" id="captionTitle">NORMAL</td>
										<td width="50%" id="captionSubTitle" align="left" style="padding-left:10px">${NORMAL_TIME}</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td height="5"></td></tr>
						<tr>
							<td align="center">
								<div id="btn_layer" style="width:470px;">
									<a href='#' class='AXButton Green' onclick="self.close()"><spring:message code="space.common.button.close" /></a>
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


</body>
</html>