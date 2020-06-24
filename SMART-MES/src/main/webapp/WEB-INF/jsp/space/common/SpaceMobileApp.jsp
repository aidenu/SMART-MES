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
<title>어플 설치</title>
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

<script>

	function goPlayStore()
	{
		window.open("https://play.google.com/store/apps/details?id=co.kr.app.eqpmanager&hl=ko");
	}
	
	
	function goAppStore()
	{
		window.open("https://apps.apple.com/us/app/%EC%84%A4%EB%B9%84-%EB%AA%A8%EB%8B%88%ED%84%B0%EB%A7%81-%EC%8B%9C%EC%8A%A4%ED%85%9C/id1303363913");
	}
	
</script>

</head>

<body>

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
										<td width="100%" id="captionTitle">모바일 앱 설치 방법 안내</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td height="5"></td></tr>
						<tr>
							<td>
								<div class="tableContainer" style="width:570px;">
									<H2>&nbsp;1. 안드로이드 설치 방법</H2>
									<br>
									<H1>&nbsp;&nbsp;1) 플레이스토어에서 "설비 모니터링 시스템" 검색</H1>	
									<br>
									<H1>&nbsp;&nbsp;2) <img	src="<c:url value='/'/>images/png/ic_launcher.png" width="30" height="30" style="cursor:pointer" onclick="goPlayStore()" /> 모양의 설비 모니터링 시스템 앱을 설치</H1>	
									<br>
									<H1>&nbsp;&nbsp;3) 첫번째 입력 항목에는 귀사에서 사용하는 외부에서 접속가능한 
									<br>&nbsp;&nbsp;&nbsp;&nbsp;IP 주소(***.***.***.***:8090/eqpmanager)를 입력 하시면 됩니다.</H1>	
									<br>
									<H2>&nbsp;2. IOS 설치 방법</H2>
									<br>
									<H1>&nbsp;&nbsp;1) 앱스토어에서 "설비 모니터링 시스템" 검색</H1>	
									<br>
									<H1>&nbsp;&nbsp;2) <img	src="<c:url value='/'/>images/png/ic_launcher.png" width="30" height="30" style="cursor:pointer" onclick="goAppStore()" /> 모양의 설비 모니터링 시스템 앱을 설치</H1>
									<br>
									<H1>&nbsp;&nbsp;3) 첫번째 입력 항목에는 귀사에서 사용하는 외부에서 접속가능한 
									<br>&nbsp;&nbsp;&nbsp;&nbsp;IP 주소(***.***.***.***:8090/eqpmanager)를 입력 하시면 됩니다.</H1>	
									<br>
								</div>
							</td>
						</tr>
						<tr><td height="5"></td></tr>
						<tr>
							<td align="center">
								<div id="btn_layer" style="width:570px;">
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