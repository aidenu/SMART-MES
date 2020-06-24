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
<title></title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/jquery/calendarview.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/defaultTheme.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/myTheme.css'/>" rel="stylesheet" type="text/css" >

<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript">var jq$ =jQuery.noConflict();</script>
<script type="text/javascript" src="<c:url value="/js/jquery/prototype.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/jquery/calendarview.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/titlefix/jquery.fixedheadertable.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spacevalidate.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spaceutil.js"/>"/></script>
<script>
		
	jq$(function()
	{
		var data_div_height = document.body.clientHeight-170;;
		jq$('#data_table').fixedHeaderTable({ fixedColumn: true,height:data_div_height,autoShow:true});
	});
	
	
	window.onload = function() {
		getData();
	}
	
	
	function getData()
	{
		document.getElementById("progress_div").style.visibility = "visible";
		document.searchForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpToolManageList.do";
		document.searchForm.target = "searchFrame";
		document.searchForm.submit();
	}
	
	
	
	function getExcel()
	{
		document.searchForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpToolManageExcel.do";
		document.searchForm.target = "searchFrame";
		document.searchForm.submit();
	}
	
	
	function getToolLevelList()
	{
		document.searchForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpToolLevelList.do?gubun=LIST";
		document.searchForm.target = "searchFrame";
		document.searchForm.submit();
	}
	
	
	function setInsert()
	{
		window.open("<c:url value='/'/>space/eqp/SpaceEqpToolInsert.do","tool_win","scrollbars=yes,toolbar=no,resizable=yes,left=200,top=200,width=500,height=300");
	}
	
	
	
	function setSaveData()
	{
		var strData = "";
		var rowcnt = jq$('#data_table_tbody tr').length;
		
		for(var i=0 ; i<rowcnt ; i++)
		{
			if(document.getElementById(jq$('#data_table_tbody tr')[i].title+"_unit").value == "")
			{
				alert("단가를 입력해 주세요");
				document.getElementById(jq$('#data_table_tbody tr')[i].title+"_unit").focus();
				return;
			}
			
			if(document.getElementById(jq$('#data_table_tbody tr')[i].title+"_safe").value == "")
			{
				alert("안전재고를 입력해 주세요");
				document.getElementById(jq$('#data_table_tbody tr')[i].title+"_safe").focus();
				return;
			}
			
			/* if(document.getElementById(jq$('#data_table_tbody tr')[i].title+"_current").value == "")
			{
				alert("현재고를 입력해 주세요");
				document.getElementById(jq$('#data_table_tbody tr')[i].title+"_current").focus();
				return;
			} */
			
			strData += jq$('#data_table_tbody tr')[i].title + "♬";
			//strData += document.getElementById(jq$('#data_table_tbody tr')[i].title+"_level1").value + "♬";
			//strData += document.getElementById(jq$('#data_table_tbody tr')[i].title+"_level2").value + "♬";
			//strData += document.getElementById(jq$('#data_table_tbody tr')[i].title+"_pie").value + "♬";
			//strData += document.getElementById(jq$('#data_table_tbody tr')[i].title+"_fb").value + "♬";
			//strData += document.getElementById(jq$('#data_table_tbody tr')[i].title+"_radius").value + "♬";
			//strData += document.getElementById(jq$('#data_table_tbody tr')[i].title+"_length").value + "♬";
			strData += document.getElementById(jq$('#data_table_tbody tr')[i].title+"_unit").value + "♬";
			strData += document.getElementById(jq$('#data_table_tbody tr')[i].title+"_safe").value + "♩";
			//strData += document.getElementById(jq$('#data_table_tbody tr')[i].title+"_current").value + "♩";
		}
		
		if(strData == "")
		{
			alert("저장할 데이터가 없습니다");
		}
		else
		{
			if(confirm("<spring:message code="space.common.saveis" />"))
			{
				document.getElementById("progress_div").style.visibility = "visible";
				document.searchForm.arraystr.value = strData.substring(0,strData.length-1);
				
				document.searchForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpToolManageSave.do?actiontype=SAVE";
				document.searchForm.target = "searchFrame";
				document.searchForm.submit();
			}
		}
	}
	
	
	function setDeleteData()
	{
		var strData = "";
		var rowcnt = jq$('#data_table_tbody tr').length;
		var checkcnt = 0;
		
		for(var i=0 ; i<rowcnt ; i++)
		{
			if(document.getElementById(jq$('#data_table_tbody tr')[i].title+"_check").checked)
			{
				strData += jq$('#data_table_tbody tr')[i].title;
				strData += "♩";
				checkcnt ++;
			}
		}
		
		if(checkcnt == 0)
		{
			alert("<spring:message code="space.common.alert.noselect" />");
		}
		else
		{
			if(confirm("<spring:message code="space.common.deleteis" />"))
			{
				document.getElementById("progress_div").style.visibility = "visible";
				document.searchForm.arraystr.value = strData.substring(0,strData.length-1);
				
				document.searchForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpToolManageSave.do?actiontype=DELETE";
				document.searchForm.target = "searchFrame";
				document.searchForm.submit();
			}
		}
	}
	
	
	
	function setStockData(gubun)
	{
		var strData = "";
		var rowcnt = jq$('#data_table_tbody tr').length;
		var checkcnt = 0;
		
		var msg = "입고 처리 하시겠습니까?";
		
		if(gubun == "OUT")
		{
			msg = "출고 처리 하시겠습니까?";
		}
		
		for(var i=0 ; i<rowcnt ; i++)
		{
			if(document.getElementById(jq$('#data_table_tbody tr')[i].title+"_check").checked)
			{
				if(document.getElementById(jq$('#data_table_tbody tr')[i].title+"_stock").value == "")
				{
					alert("입출고 수량을 입력해 주세요");
					document.getElementById(jq$('#data_table_tbody tr')[i].title+"_stock").focus();
					return;
				}
				
				strData += jq$('#data_table_tbody tr')[i].title + "♬";
				strData += document.getElementById(jq$('#data_table_tbody tr')[i].title+"_level1").value + "♬";
				strData += document.getElementById(jq$('#data_table_tbody tr')[i].title+"_level2").value + "♬";
				strData += document.getElementById(jq$('#data_table_tbody tr')[i].title+"_pie").value + "♬";
				strData += document.getElementById(jq$('#data_table_tbody tr')[i].title+"_fb").value + "♬";
				strData += document.getElementById(jq$('#data_table_tbody tr')[i].title+"_radius").value + "♬";
				strData += document.getElementById(jq$('#data_table_tbody tr')[i].title+"_length").value + "♬";
				strData += document.getElementById(jq$('#data_table_tbody tr')[i].title+"_stock").value + "♩";
				
				checkcnt ++;
			}
		}
		
		if(checkcnt == 0)
		{
			alert("선택하신 항목이 없습니다");
		}
		else
		{
			if(confirm(msg))
			{
				document.getElementById("progress_div").style.visibility = "visible";
				document.searchForm.arraystr.value = strData.substring(0,strData.length-1);
				
				document.searchForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpToolManageStock.do?actiontype=" +gubun;
				document.searchForm.target = "searchFrame";
				document.searchForm.submit();
			}
		}
	}
	
</script>
</head>

<body style="background-color: #2c3338;">

<div id="wrap">
	<!-- header 시작 -->
	<div id="header"><c:import url="/EgovPageLink.do?link=main/inc/EgovIncHeader" /></div>
    <div id="topnavi"><c:import url="/sym/mms/EgovMainMenuHead.do" /></div>
    <div id="subnavi"><c:import url="/sym/mms/EgovMainMenuSub.do" /></div> 
	<!-- //header 끝 -->	
	
	<table width="100%">
			<tr><td height="3"></td></tr>
			<tr>
				<td valign="top">
					<table>
						<tr>
							<td width="*">
								<div style="width:1200px;border: 1px solid #D5D1B0;">
									<form name="searchForm" method="post">
									<input type="hidden" name="arraystr">
									<table width="100%">
										<tr>
											<td align="center" style="padding:0 10px 0 10px">
												<font color="#FFFFFF"><b>대분류</b> : </font>
												<select name="tool_level_1" id="tool_level_1" onchange="getToolLevelList()">
													<option value="ALL">-전체-</option>
													<c:forEach var="result" items="${result}" varStatus="status">
														<option value="${result.CHILD_ID}">${result.CHILD_VALUE}</option>
													</c:forEach>
												</select>
												&nbsp;&nbsp;
												<font color="#FFFFFF"><b>소분류</b> : </font>
												<select name="tool_level_2" id="tool_level_2">
													<option value="ALL">-전체-</option>
												</select>
												&nbsp;&nbsp;
												<font color="#FFFFFF"><b>파이</b> : </font>
												<input type="text" name="tool_pie" style="height:17px;width:50px;text-align:center;" value="" onkeyup="onlyNum(this);">
												&nbsp;&nbsp;
												<font color="#FFFFFF"><b>F/B</b> : </font>
												<select name="tool_fb">
													<option value="ALL">-전체-</option>
													<option value="F">F</option>
													<option value="B">B</option>
												</select>
												&nbsp;&nbsp;
												<font color="#FFFFFF"><b>R</b> : </font>
												<input type="text" name="tool_radius" style="height:17px;width:50px;text-align:center;" value="" onkeyup="onlyNum(this);">
												&nbsp;&nbsp;
												<font color="#FFFFFF"><b>기장</b> : </font>
												<input type="text" name="tool_length" style="height:17px;width:50px;text-align:center;" value="" onkeyup="onlyNum(this);">
											</td>
											
											<td align="center" style="padding:0 0 0 0">
												<a href='#' class='AXButton Gray' onclick="getData()"><spring:message code="space.common.button.search" /></a>
												<a href='#' class='AXButton Gray' onclick="setSaveData()">저장</a>
												<a href='#' class='AXButton Gray' onclick="setStockData('IN')">입고</a>
												<a href='#' class='AXButton Gray' onclick="setStockData('OUT')">출고</a>
												<a href='#' class='AXButton Gray' onclick="setInsert()">추가</a>
												<a href='#' class='AXButton Gray' onclick="getExcel()"><spring:message code="space.common.button.excel" /></a>
												<a href='#' class='AXButton Red' onclick="setDeleteData()">삭제</a>
											</td>
										</tr>
									</table>
									</form>
								</div>
							</td>
						</tr>
						<tr><td height="3"></td></tr>
						<tr>
							<td>
								<div id="data_div" class="tableContainer" style="width: 1200px;">
									<table id="data_table" class="fancyTable"> 
										 <thead>
											<tr>
												<th width='175'>대분류</th>
												<th width='175'>소분류</th>
												<th width='100'>파이(mm)</th>
												<th width='100'>F/B</th>
												<th width='100'>R(mm)</th>
												<th width='100'>기장(mm)</th>
												<th width='50'>선택</th>
												<th width='100'>단가(원)</th>
												<th width='100'>안전재고(EA)</th>
												<th width='100'>현재고(EA)</th>
												<th width='100'>입출고(EA)</th>
											</tr>
										</thead>
										<tbody id="data_table_tbody">
											<tr>
												<td></td>
												<td></td>
												<td></td>
												<td></td>
												<td></td>
												<td></td>
												<td></td>
												<td></td>
												<td></td>
												<td></td>
												<td></td>
											</tr>
										</tbody>
									</table>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
</div>

	
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