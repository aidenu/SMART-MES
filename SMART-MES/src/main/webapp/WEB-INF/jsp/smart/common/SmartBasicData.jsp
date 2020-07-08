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
<title>기준정보관리</title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/spacecommon.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/jquery/prototype.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spacevalidate.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spaceutil.js"/>"/></script>
</head>

<script>

	function getBasicData(level)
	{
		if(level == 0)
		{
			document.dataForm.actionlevel.value = 1;
			document.dataForm.parentid.value = 0;
		}
		else
		{
			if($("level"+level+"_value").length > 1)
			{
				$("level"+level+"_name").value = $("level"+level+"_value").options[$("level"+level+"_value").selectedIndex].text;
				document.dataForm.parentid.value = $("level"+level+"_value").options[$("level"+level+"_value").selectedIndex].value;
			}
			else
			{
				$("level"+level+"_name").value = $("level"+level+"_value").options[0].text;
				document.dataForm.parentid.value = $("level"+level+"_value").options[0].value;
			}
			
			document.dataForm.actionlevel.value = level+1;
		}
		
		//선택한 항목의 하위 항목 화면을 표시한다
		if(level == 1)
		{
			$("td_img_2").style.visibility = "visible";
			$("td_box_2").style.visibility = "visible";
			$("td_img_3").style.visibility = "hidden";
			$("td_box_3").style.visibility = "hidden";
			$("td_img_4").style.visibility = "hidden";
			$("td_box_4").style.visibility = "hidden";
			$("td_img_5").style.visibility = "hidden";
			$("td_box_5").style.visibility = "hidden";
		}
		else if(level == 2)
		{
			$("td_img_3").style.visibility = "visible";
			$("td_box_3").style.visibility = "visible";
			$("td_img_4").style.visibility = "hidden";
			$("td_box_4").style.visibility = "hidden";
			$("td_img_5").style.visibility = "hidden";
			$("td_box_5").style.visibility = "hidden";
		}
		else if(level == 3)
		{
			$("td_img_4").style.visibility = "visible";
			$("td_box_4").style.visibility = "visible";
			$("td_img_5").style.visibility = "hidden";
			$("td_box_5").style.visibility = "hidden";
		}
		else if(level == 4)
		{
			$("td_img_5").style.visibility = "visible";
			$("td_box_5").style.visibility = "visible";
		}
		
		document.dataForm.action="${pageContext.request.contextPath}/smart/common/SmartBasicDataList.do";
		document.dataForm.target = "hiddenFrame";
		document.dataForm.submit();
	}
	
	//추가,수정, 삭제 후 hiddenFrame에서 호출 함
	function getBasicHiddenData(level,parentid)
	{
		document.dataForm.actionlevel.value = level;
		document.dataForm.parentid.value = parentid;
		
		document.dataForm.action="${pageContext.request.contextPath}/smart/common/SmartBasicDataList.do";
		document.dataForm.target = "hiddenFrame";
		document.dataForm.submit();
	}
	
	
	function setBasicData(level,gubun)
	{
		if(gubun == "INSERT")
		{
			//항목값을 입력해야 함
			if($("level"+level+"_name").value == "")
			{
				alert("항목값을 입력해 주세요");
				$("level"+level+"_name").focus();
				return false;
			}
		
			//추가되는 항목값이 기존이 있는 값인지 확인
			if($("level"+level+"_value").length > 0)
			{
				if($("level"+level+"_value").length > 1)
				{
					for(var i=0 ; i<$("level"+level+"_value").length ; i++)
					{
						if($("level"+level+"_name").value == $("level"+level+"_value").options[i].text)
						{
							alert("항목값이 중복 됩니다");
							return false;
						}
					}
				}
				else
				{
					if($("level"+level+"_name").value == $("level"+level+"_value").text)
					{
						alert("항목값이 중복 됩니다");
						return false;
					}
				}
			}
			
			//추가 등록시 첫번째 항목값이면 parentid를 0으로 주고 아니면 상위 항목의 선택된 값을 parentid로 바꿔줌
			if(level == 1)
			{
				document.dataForm.parentid.value = 0;
			}
			else
			{
				//상위 항목 값이 선택되어져 있는지 확인
				if($("level"+(level-1)+"_value").selectedIndex == -1)
				{
					alert("상위 항목을 선택해 주세요");
					return false;
				}
				
				if($("level"+(level-1)+"_value").length > 1)
				{
					document.dataForm.parentid.value = $("level"+(level-1)+"_value").options[$("level"+(level-1)+"_value").selectedIndex].value;
				}
				else
				{
					document.dataForm.parentid.value = $("level"+(level-1)+"_value").options[0].value;
				}
			}
		}
		else if(gubun == "UPDATE")
		{
			//항목값을 입력해야 함
			if($("level"+level+"_name").value == "")
			{
				alert("항목값을 입력해 주세요");
				$("level"+level+"_name").focus();
				return false;
			}
		
			//수정할 항목이 선택되어져 있는지 확인
			if($("level"+level+"_value").selectedIndex == -1)
			{
				alert("수정할 항목을 선택해 주세요");
				return false;
			}
			
			//수정되는 항목값이 기존이 있는 값인지 확인
			if($("level"+level+"_value").length > 0)
			{
				if($("level"+level+"_value").length > 1)
				{
					for(var i=0 ; i<$("level"+level+"_value").length ; i++)
					{
						if($("level"+level+"_name").value == $("level"+level+"_value").options[i].text)
						{
							alert("항목값이 중복 됩니다");
							return false;
						}
					}
				}
				else
				{
					if($("level"+level+"_name").value == $("level"+level+"_value").text)
					{
						alert("항목값이 중복 됩니다");
						return false;
					}
				}
			}
		}
		else
		{
			//항목값을 입력해야 함
			if($("level"+level+"_name").value == "")
			{
				alert("삭제할 항목을 선택해 주세요");
				return false;
			}
			
			//삭제할 항목이 선택되어져 있는지 확인
			if($("level"+level+"_value").selectedIndex == -1)
			{
				alert("삭제할 항목을 선택해 주세요");
				return false;
			}
		}
		
		if(gubun == "INSERT")
		{
			if(!confirm("추가 하시겠습니까?"))
			{
				return;
			}
		}
		else if(gubun == "UPDATE")
		{
			if(!confirm("수정 하시겠습니까?"))
			{
				return;
			}
		}
		else
		{
			if(!confirm("삭제 하시겠습니까?(선택한 항목의 하위 항목값들도 모두 삭제 됩니다)"))
			{
				return;
			}
		}
		
		document.dataForm.actiontype.value = gubun;
		document.dataForm.actionlevel.value = level;
		document.dataForm.childvalue.value = $("level"+level+"_name").value;
		
		if(gubun == "UPDATE" || gubun == "DELETE")
		{
			if($("level"+level+"_value").length > 0)
			{
				if($("level"+level+"_value").length > 1)
				{
					document.dataForm.childid.value = $("level"+level+"_value").options[$("level"+level+"_value").selectedIndex].value;
					document.dataForm.parentid.value = $("level"+level+"_value").options[$("level"+level+"_value").selectedIndex].name;
				}
				else
				{
					document.dataForm.childid.value = $("level"+level+"_value").options[0].value;
					document.dataForm.parentid.value = $("level"+level+"_value").options[0].name;
				}
			}
			else
			{
				document.dataForm.parentid.value = 0;
			}
		}
		
		
		document.dataForm.action="${pageContext.request.contextPath}/smart/common/SmartBasicDataAction.do";
		document.dataForm.target = "hiddenFrame";
		document.dataForm.submit();
	}
	
	
</script>

<body style="background-color: #2c3338;" onload="getBasicData(0)">

<div id="wrap">
	<!-- header 시작 -->
	<div id="header"><c:import url="/EgovPageLink.do?link=main/nav/SmartHeaderNav" /></div>
    <div id="topnavi"><c:import url="/sym/mms/EgovMainMenuHead.do" /></div>
    <div id="subnavi"><c:import url="/sym/mms/EgovMainMenuSub.do" /></div> 
	<!-- //header 끝 -->	
	
	<!-- container 시작 -->
	<form name="dataForm" method="post">
	<input type="hidden" name="actiontype">
	<input type="hidden" name="actionlevel">
	<input type="hidden" name="parentid">
	<input type="hidden" name="childid">
	<input type="hidden" name="childvalue">
	
	<div id="spacecontainer">
		<table>
			<tr><td colspan="3"></td></tr>
			<tr>
				<td  valign="top" align="center">
					<table>
						<tr>
							<td>
								<div style="width:300px;border: 1px solid #D5D1B0;">
									<table width="100%">
										<tr>
											<td width="100%" id="captionTitle">LEVEL 1</td>
										</tr>
									</table>
								</div>
								<div class="tableContainer" style="width:300px;height:370px">
									<table width="100%" border="0" cellpadding="0" cellspacing="0" class="scrollTable">
										<tr>
											<td height="10"></td>
										</tr>
										<tr>
											<td align="center">
												<select name="level1_value" id="level1_value" onchange="getBasicData(1)" size="20" class="multi-select" style="width:250px;height:290px;background-color: #2c3338;color: #FFF;">
												</select>
											</td>
										</tr>
										<tr>
											<td height="10"></td>
										</tr>
										<tr>
											<td align="center">
												<input type="text" name="level1_name" id="level1_name" style="width:250px;height:17px;" onkeyup="checkStrLength(255,this);checkQuota(this)">
												<input type="hidden" name="level1_id" id="level1_id">
											</td>
										</tr>
										<tr>
											<td height="10"></td>
										</tr>
										<tr>
											<td align="center">
												<c:if test="${result == 'ROLE_ADMIN'}">
													<a href='#' class='AXButton Gray' onclick="setBasicData(1,'INSERT')">추가</a>
													&nbsp;
													<a href='#' class='AXButton Gray' onclick="setBasicData(1,'UPDATE')">수정</a>
													&nbsp;
													<a href='#' class='AXButton Gray'  onclick="setBasicData(1,'DELETE')">삭제</a>
												</c:if>
											</td>
										</tr>
									</table>
								</div>
							</td>
							<td id="td_img_2" style="visibility:hidden" width="100" align="center"><img	src="<c:url value='/'/>images/png/Arrow_Left.png" width="20" height="20"/></td>
							<td id="td_box_2" style="visibility:hidden">
								<div style="width:300px;border: 1px solid #D5D1B0;">
									<table width="100%">
										<tr>
											<td width="100%" id="captionTitle">LEVEL 2</td>
										</tr>
									</table>
								</div>
								<div class="tableContainer" style="width:300px;height:370px">
									<table width="100%" border="0" cellpadding="0" cellspacing="0" class="scrollTable">
										<tr>
											<td height="10"></td>
										</tr>
										<tr>
											<td align="center">
												<select name="level2_value" id="level2_value" onchange="getBasicData(2)" size="20" class="multi-select" style="width:250px;height:290px;background-color: #2c3338;color: #FFF;">
												</select>
											</td>
										</tr>
										<tr>
											<td height="10"></td>
										</tr>
										<tr>
											<td align="center">
												<input type="text" name="level2_name" id="level2_name" style="width:250px;height:17px;"  onkeyup="checkStrLength(255,this);checkQuota(this)">
												<input type="hidden" name="level2_id" id="level2_id">
											</td>
										</tr>
										<tr>
											<td height="10"></td>
										</tr>
										<tr>
											<td align="center">
												<a href='#' class='AXButton Gray' onclick="setBasicData(2,'INSERT')">추가</a>
												&nbsp;
												<a href='#' class='AXButton Gray' onclick="setBasicData(2,'UPDATE')">수정</a>
												&nbsp;
												<a href='#' class='AXButton Gray'  onclick="setBasicData(2,'DELETE')">삭제</a>
											</td>
										</tr>
									</table>
								</div>
							</td>
							<td id="td_img_3" style="visibility:hidden" width="100" align="center"><img	src="<c:url value='/'/>images/png/Arrow_Left.png" width="20" height="20"/></td>
							<td id="td_box_3" style="visibility:hidden">
								<div style="width:300px;border: 1px solid #D5D1B0;">
									<table width="100%">
										<tr>
											<td width="100%" id="captionTitle">LEVEL 3</td>
										</tr>
									</table>
								</div>
								<div class="tableContainer" style="width:300px;height:370px">
									<table width="100%" border="0" cellpadding="0" cellspacing="0" class="scrollTable">
										<tr>
											<td height="10"></td>
										</tr>
										<tr>
											<td align="center">
												<select name="level3_value" id="level3_value" onchange="getBasicData(3)" size="20" class="multi-select" style="width:250px;height:290px;background-color: #2c3338;color: #FFF;">
												</select>
											</td>
										</tr>
										<tr>
											<td height="10"></td>
										</tr>
										<tr>
											<td align="center">
												<input type="text" name="level3_name" id="level3_name" style="width:250px;height:17px;" onkeyup="checkStrLength(255,this);checkQuota(this)">
												<input type="hidden" name="level3_id" id="level3_id">
											</td>
										</tr>
										<tr>
											<td height="10"></td>
										</tr>
										<tr>
											<td align="center">
												<a href='#' class='AXButton Gray' onclick="setBasicData(3,'INSERT')">추가</a>
												&nbsp;
												<a href='#' class='AXButton Gray' onclick="setBasicData(3,'UPDATE')">수정</a>
												&nbsp;
												<a href='#' class='AXButton Gray'  onclick="setBasicData(3,'DELETE')">삭제</a>
											</td>
										</tr>
									</table>
								</div>
							</td>
							<td id="td_img_4" style="visibility:hidden" width="100" align="center"><img	src="<c:url value='/'/>images/png/Arrow_Left.png" width="20" height="20"/></td>
							<td id="td_box_4" style="visibility:hidden">
								<div style="width:300px;border: 1px solid #D5D1B0;">
									<table width="100%">
										<tr>
											<td width="100%" id="captionTitle">LEVEL 4</td>
										</tr>
									</table>
								</div>
								<div class="tableContainer" style="width:300px;height:370px">
									<table width="100%" border="0" cellpadding="0" cellspacing="0" class="scrollTable">
										<tr>
											<td height="10"></td>
										</tr>
										<tr>
											<td align="center">
												<select name="level4_value" id="level4_value" onchange="getBasicData(4)" size="20" class="multi-select" style="width:250px;height:290px;background-color: #2c3338;color: #FFF;">
												</select>
											</td>
										</tr>
										<tr>
											<td height="10"></td>
										</tr>
										<tr>
											<td align="center">
												<input type="text" name="level4_name" id="level4_name" style="width:250px;height:17px;" onkeyup="checkStrLength(255,this);checkQuota(this)">
												<input type="hidden" name="level4_id" id="level4_id">
											</td>
										</tr>
										<tr>
											<td height="10"></td>
										</tr>
										<tr>
											<td align="center">
												<a href='#' class='AXButton Gray' onclick="setBasicData(4,'INSERT')">추가</a>
												&nbsp;
												<a href='#' class='AXButton Gray' onclick="setBasicData(4,'UPDATE')">수정</a>
												&nbsp;
												<a href='#' class='AXButton Gray'  onclick="setBasicData(4,'DELETE')">삭제</a>
											</td>
										</tr>
									</table>
								</div>
							</td>
							
							<td id="td_img_5" style="visibility:hidden" width="100" align="center"><img	src="<c:url value='/'/>images/png/Arrow_Left.png" width="20" height="20"/></td>
							<td id="td_box_5" style="visibility:hidden">
								<div style="width:300px;border: 1px solid #D5D1B0;">
									<table width="100%">
										<tr>
											<td width="100%" id="captionTitle">LEVEL 5</td>
										</tr>
									</table>
								</div>
								<div class="tableContainer" style="width:300px;height:370px">
									<table width="100%" border="0" cellpadding="0" cellspacing="0" class="scrollTable">
										<tr>
											<td height="10"></td>
										</tr>
										<tr>
											<td align="center">
												<select name="level5_value" id="level5_value" onchange="getBasicData(5)" size="20" class="multi-select" style="width:250px;height:290px;background-color: #2c3338;color: #FFF;">
												</select>
											</td>
										</tr>
										<tr>
											<td height="10"></td>
										</tr>
										<tr>
											<td align="center">
												<input type="text" name="level5_name" id="level5_name" style="width:250px;height:17px;" onkeyup="checkStrLength(255,this);checkQuota(this)">
												<input type="hidden" name="level5_id" id="level5_id">
											</td>
										</tr>
										<tr>
											<td height="10"></td>
										</tr>
										<tr>
											<td align="center">
												<a href='#' class='AXButton Gray' onclick="setBasicData(5,'INSERT')">추가</a>
												&nbsp;
												<a href='#' class='AXButton Gray' onclick="setBasicData(5,'UPDATE')">수정</a>
												&nbsp;
												<a href='#' class='AXButton Gray'  onclick="setBasicData(5,'DELETE')">삭제</a>
											</td>
										</tr>
									</table>
								</div>
							</td>
							
						</tr>
						<tr><td colspan="7" height="50"></td></tr>
						<tr><td colspan="7" height="50"></td></tr>
						<tr>
							<td colspan="7">
								<table>
									<tr>
										<td id="captionSubTitle" align="center" width="250">범례</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td colspan="7">
								<table>
									<tr>
										<td width="200" id="captionTitle">ACTIVE_FLAG</td>
										<td width="600" align="left" style="padding-left:10px;border: 1px solid #D5D1B0;color: #FFF;">
											. 경광등 색상별 가동,에러,재품카운트 FLAG를 설정<br>
											. LEVEL2 : 색상<br>
											. LEVEL3 : RUNNING - 가동상태, ERROR - 에러상태, PRODUCT - 제품생산 카운트
										</td>
									</tr>
									<tr>
										<td id="captionTitle">EQP_PART</td>
										<td align="left" style="padding-left:10px;border: 1px solid #D5D1B0;color: #FFF;">
											. 설비 그룹별 지정 정보<br>
											. LEVEL2 : 설비 그룹명 <br>
											. LEVEL3 : 그룹별 설비명<br>
											. LEVEL4 : 설비별 MacAddress, UserName 구분(LEVEL3에서 설비 추가시 자동 생성 됨)<br>
											. LEVEL5 : MacAddress 또는 설비 담당자 ID
										</td>
									</tr>
									<tr>
										<td id="captionTitle">FILE_LOCATE</td>
										<td align="left" style="padding-left:10px;border: 1px solid #D5D1B0;color: #FFF;">
											. 설비상태 LOG파일 경로(예: "D:\eqpmanager")
										</td>
									</tr>
									<tr>
										<td id="captionTitle">LAMP_LEVEL</td>
										<td align="left" style="padding-left:10px;border: 1px solid #D5D1B0;color: #FFF;">
											. 설비상태 화면의 경광등 단수 설정(3,4,5 중에 한 숫자만 등록 해야 함)<br>
											. 3 : RED, AMBER, GREEN<br>
											. 4 : RED, AMBER, GREEN, BLUE<br>
											. 5 : RED, AMBER, GREEN, BLUE, WHITE
										</td>
									</tr>
									<tr>
										<td id="captionTitle">LOG_FILE_SAVE_DAY</td>
										<td align="left" style="padding-left:10px;border: 1px solid #D5D1B0;color: #FFF;">
											. 로그 파일 저장 기간 설정(일수, 정수로만 입력 해야 함)
										</td>
									</tr>
									<tr>
										<td id="captionTitle">MONITORING_TIME</td>
										<td align="left" style="padding-left:10px;border: 1px solid #D5D1B0;color: #FFF;">
											. 설비상태 모니터링 Reload Time(단위:초)<br>
											. LEVEL2 : 재조회 시간 선택 리스트(정수로만 입력 해야 함) <br>
											. LEVEL3 : "default" 입력시 해당 시간으로 기본 셋팅
										</td>
									</tr>
									<tr>
										<td id="captionTitle">STANDARD_HOUR</td>
										<td align="left" style="padding-left:10px;border: 1px solid #D5D1B0;color: #FFF;">
											. 설비가동율 계산시 기준이 되는 일 최대 가동시간 기준(정수로만 입력 해야 함)
										</td>
									</tr>
									<tr>
										<td id="captionTitle">TOOL_FILTER</td>
										<td align="left" style="padding-left:10px;border: 1px solid #D5D1B0;color: #FFF;">
											. 공구관리 화면에서 사용하는 필터 정보
										</td>
									</tr>
								</table>
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
	<!-- footer 시작 -->
	<%-- <div id="footer"><c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" /></div> --%>
	<!-- //footer 끝 -->
</div>
<!-- //전체 레이어 끝 -->

<iframe name="hiddenFrame" width="0" hieght="0" style="visibility:hidden"></iframe>

</body>
</html>