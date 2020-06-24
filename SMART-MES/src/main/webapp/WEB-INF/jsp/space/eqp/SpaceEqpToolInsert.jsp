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
<title>공구 추가</title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >

<link href="<c:url value='/css/titlefix/defaultTheme.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/myTheme.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/titlefix/jquery.fixedheadertable.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spacevalidate.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spaceutil.js"/>"/></script>

<script>
	
	function getToolLevelList()
	{
		document.dataForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpToolLevelList.do?gubun=INSERT";
		document.dataForm.target = "searchFrame";
		document.dataForm.submit();
	}
	
	
	
	function setSaveData()
	{
		if(document.dataForm.tool_level_1.value == "")
		{
			alert("대분류를 선택해 주세요");
			document.dataForm.tool_level_1.focus();
			return;
		}
		
		if(document.dataForm.tool_level_2.value == "")
		{
			alert("소분류를 선택해 주세요");
			document.dataForm.tool_level_2.focus();
			return;
		}
		
		if(document.dataForm.tool_pie.value == "")
		{
			alert("파이값을 입력해 주세요");
			document.dataForm.tool_pie.focus();
			return;
		}
		
		if(document.dataForm.tool_fb.value == "")
		{
			alert("F/B를 선택해 주세요");
			document.dataForm.tool_fb.focus();
			return;
		}
		
		if(document.dataForm.tool_radius.value == "")
		{
			alert("R값을 입력해 주세요");
			document.dataForm.tool_radius.focus();
			return;
		}
		
		if(document.dataForm.tool_length.value == "")
		{
			alert("기장값을 입력해 주세요");
			document.dataForm.tool_length.focus();
			return;
		}
		
		if(document.dataForm.tool_unit.value == "")
		{
			alert("단가를 입력해 주세요");
			document.dataForm.tool_unit.focus();
			return;
		}
		
		if(document.dataForm.tool_safe.value == "")
		{
			alert("안전재고를 입력해 주세요");
			document.dataForm.tool_safe.focus();
			return;
		}
		
		if(document.dataForm.tool_current.value == "")
		{
			alert("입고수량을 입력해 주세요");
			document.dataForm.tool_current.focus();
			return;
		}
		
		if(confirm("입력하신 값으로 공구를 추가 하시겠습니까?"))
		{
			document.getElementById("progress_div").style.visibility = "visible";
			document.dataForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpToolInsertSave.do";
			document.dataForm.target = "searchFrame";
			document.dataForm.submit();
		}
	}
	
</script>
</head>

<body style="background-color: #2c3338;">
<form name="dataForm" method="post">

<div id="wrap">
	<div id="spacecontainer">
		<table>
			<tr><td colspan="3">&nbsp;</td></tr>
			<tr>
				<td  valign="top">
					<table>
						<tr>
							<td>
								<div style="width:200px;border: 1px solid #D5D1B0;">
									<table width="100%">
										<tr>
											<td id="captionSubTitle" align="center">공구 추가</td>
										</tr>
									</table>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="tableContainer" style="width:470px;">
									
									<table width="100%">
										<tr>
											<td width="20%" id="captionTitle">대분류</td>
											<td width="30%" id="captionSubTitle" align="left" style="padding-left:10px">
												<select name="tool_level_1" id="tool_level_1" onchange="getToolLevelList()" style="width:120px">
													<option value="">-선택-</option>
													<c:forEach var="result" items="${result}" varStatus="status">
														<option value="${result.CHILD_ID}">${result.CHILD_VALUE}</option>
													</c:forEach>
												</select>
											</td>
											<td width="20%" id="captionTitle">소분류</td>
											<td width="30%" id="captionSubTitle" align="left" style="padding-left:10px">
												<select name="tool_level_2" id="tool_level_2" style="width:120px">
													<option value="">-선택-</option>
												</select>
											</td>
										</tr>
										<tr>
											<td width="20%" id="captionTitle">파이(mm)</td>
											<td width="30%" id="captionSubTitle" align="left" style="padding-left:10px">
												<input type="text" name="tool_pie" style="height:17px;width:120px;text-align:center;" value="" onkeyup="onlyNum(this);">
											</td>
											<td width="20%" id="captionTitle">F/B</td>
											<td width="30%" id="captionSubTitle" align="left" style="padding-left:10px">
												<select name="tool_fb" style="width:120px">
													<option value="">-선택-</option>
													<option value="F">F</option>
													<option value="B">B</option>
												</select>
											</td>
										</tr>
										<tr>
											<td width="20%" id="captionTitle">R(mm)</td>
											<td width="30%" id="captionSubTitle" align="left" style="padding-left:10px">
												<input type="text" name="tool_radius" style="height:17px;width:120px;text-align:center;" value="" onkeyup="onlyNum(this);">
											</td>
											<td width="20%" id="captionTitle">기장(mm)</td>
											<td width="30%" id="captionSubTitle" align="left" style="padding-left:10px">
												<input type="text" name="tool_length" style="height:17px;width:120px;text-align:center;" value="" onkeyup="onlyNum(this);">
											</td>
										</tr>
										<tr>
											<td width="20%" id="captionTitle">단가(원)</td>
											<td width="30%" id="captionSubTitle" align="left" style="padding-left:10px">
												<input type="text" name="tool_unit" style="height:17px;width:120px;text-align:center;" value="" onkeyup="onlyNum(this);this.value=this.value.comma();">
											</td>
											<td width="20%" id="captionTitle">안전재고(EA)</td>
											<td width="30%" id="captionSubTitle" align="left" style="padding-left:10px">
												<input type="text" name="tool_safe" style="height:17px;width:120px;text-align:center;" value="" onkeyup="onlyNum(this);">
											</td>
										</tr>
										<tr>
											<td width="20%" id="captionTitle">입고수량(EA)</td>
											<td width="80%" id="captionSubTitle" align="left" style="padding-left:10px" colspan="3">
												<input type="text" name="tool_current" style="height:17px;width:120px;text-align:center;" value="" onkeyup="onlyNum(this);">
											</td>
										</tr>
									</table>
									
								</div>
							</td>
						</tr>
						
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td id='btn_layer' align="center">
								<a href='#' class='AXButton Gray' onclick="setSaveData()"><spring:message code="space.common.button.save" /></a>
								&nbsp;
								<a href='#' class='AXButton Gray' onclick="self.close()"><spring:message code="space.common.button.close" /></a>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
</div>
<!-- //전체 레이어 끝 -->
</form>

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