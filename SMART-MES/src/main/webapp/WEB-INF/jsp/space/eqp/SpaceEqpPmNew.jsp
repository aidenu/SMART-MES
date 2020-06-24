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
<title>설비PM 추가</title>
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
	
	var todate = new Date();
	
	var toyear = todate.getFullYear();
	var tomonth = todate.getMonth()+1;
	var today = todate.getDate();
	
	if(tomonth<10) tomonth = "0" + tomonth;
	if(today<10) today = "0" + today;
	
	var tofullday = toyear + "-" + tomonth + "-" + today;

	window.onload = function() {
		
		// 날짜 입력 항목 초기화
		Calendar.setup(
		          {
		            dateField: 'pm_date',
		            triggerElement: 'pm_date'
		          }
		)
		
		$("pm_date").value = tofullday;
	}


	function getEqpList()
	{
		document.dataForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpPmEqpList.do?type=INSERT";
		document.dataForm.target = "searchFrame";
		document.dataForm.submit();
	}
	
	
	
	function setSaveData()
	{
		if(document.dataForm.pm_type.value == "")
		{
			alert("구분을 선택해 주세요");
			document.dataForm.pm_type.focus();
			return;
		}
		
		if(document.dataForm.eqppart.value == "")
		{
			alert("설비그룹을 선택해 주세요");
			document.dataForm.eqppart.focus();
			return;
		}
		
		if(document.dataForm.eqpname.value == "")
		{
			alert("설비명을 선택해 주세요");
			document.dataForm.eqpname.focus();
			return;
		}
		
		
		if(document.dataForm.pm_detail.value == "")
		{
			alert("작업내용을 입력해 주세요");
			document.dataForm.pm_detail.focus();
			return;
		}
		
		if(confirm("입력하신 값으로 설비PM을 추가 하시겠습니까?"))
		{
			document.getElementById("progress_div").style.visibility = "visible";
			document.dataForm.action="${pageContext.request.contextPath}/space/eqp/SpaceEqpPmSave.do?actiontype=NEW";
			document.dataForm.target = "searchFrame";
			document.dataForm.submit();
		}
	}
	
	
	
	function HandleBrowseClick(itemIndex)
	{
		document.getElementById('item_image_'+itemIndex).value = '';
	    var fileinput = document.getElementById("item_image_"+itemIndex);
	    fileinput.click();
	}
	
	
	function selectFolder(e,itemIndex)
	{
		var theFiles = e.target.files;
		var filename = "";
		var imageType = /image.*/;
		
		//폴더가 선택되면 기존 이미지는 지워준다
		document.getElementById("preview_"+itemIndex).src = "";
				
		for (var i=0, file; file=theFiles[i]; i++)
		{
			filename = file.name;
		
			if(file.size > 1000000)//이미지 사이즈는 1M 이하만 등록 가능
			{
				alert("이미지 사이즈는 1M 이하만 등록 가능 합니다.");
				return false;
				break;
			}
		
			if(file.type.match(imageType))//선택된 폴더에서 이미지 파일을 화면에 보여준다 
			{
				var imagereader = new FileReader();
				
				imagereader.onload = function(file){
					document.getElementById("preview_"+itemIndex).src = this.result;
					document.getElementById("preview_"+itemIndex).width = 150;
					document.getElementById("preview_"+itemIndex).height = 150;
				};
		
				imagereader.readAsDataURL(file);
			}
			else
			{
				alert("등록 가능한 이미지 파일은 gif,jpg,jpeg,bmp,png 파일 입니다");
				document.getElementById("preview_"+itemIndex).src = "<c:url value='/'/>images/png/no_image_item.png";
				return false;
				break;
			}
		}
	} 
	
</script>
</head>

<body style="background-color: #2c3338;">
<form name="dataForm" method="post" enctype="multipart/form-data">

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
											<td id="captionSubTitle" align="center">설비PM 추가</td>
										</tr>
									</table>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="tableContainer" style="width:670px;">
									
									<table width="100%">
										<tr>
											<td width="10%" id="captionTitle">구분</td>
											<td width="20%" id="captionSubTitle" align="left" style="padding-left:10px">
												<select name="pm_type" id="pm_type" style="width:80px">
													<option value="">-선택-</option>
													<option value="CHECK">정기점검</option>
													<option value="REPAIR">고장/수리</option>
												</select>
											</td>
											<td width="10%" id="captionTitle">설비그룹</td>
											<td width="20%" id="captionSubTitle" align="left" style="padding-left:10px">
												<select name="eqppart" id="eqppart" onchange="getEqpList()" style="width:100px">
													<option value="">-선택-</option>
													<c:forEach var="result" items="${result}" varStatus="status">
														<option value="${result.EQP_PART}">${result.EQP_PART}</option>
													</c:forEach>
												</select>
											</td>
											<td width="10%" id="captionTitle">설비명</td>
											<td width="30%" id="captionSubTitle" align="left" style="padding-left:10px">
												<select name="eqpname" id="eqpname" style="width:200px">
													<option value="">-선택-</option>
												</select>
											</td>
										</tr>
										<tr>
											<td id="captionTitle">작업<br>일자</td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<input type="text" name="pm_date" id="pm_date" style="height:17px;width:80px;text-align:center;cursor:pointer" readonly>
											</td>
											<td id="captionTitle">작업자</td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												${username}
											</td>
											<td id="captionTitle">작업<br>시간</td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<input type="text" name="pm_hour" style="height:17px;width:80px;text-align:center;" value="" onkeyup="onlyNum(this);"> 시간
											</td>
										</tr>
										<tr>
											<td id="captionTitle">작업<br>비용</td>
											<td id="captionSubTitle" align="left" style="padding-left:10px" colspan="5">
												<input type="text" name="pm_cost" style="height:17px;width:80px;text-align:center;" value="" onkeyup="onlyNum(this);this.value=this.value.comma();"> 원
											</td>
										</tr>
										<tr>
											<td id="captionTitle">작업<br>내용</td>
											<td id="captionSubTitle" align="left" style="padding-left:10px" colspan="5">
												<textarea name="pm_detail" id="pm_detail" style="height:47px;width:590px;" onkeyup="checkStrLength(500,this);checkQuota(this)"></textarea>
											</td>
										</tr>
										<tr>
											<td id="captionTitle">비고</td>
											<td id="captionSubTitle" align="left" style="padding-left:10px" colspan="5">
												<textarea name="pm_desc" id="pm_desc" style="height:47px;width:590px;" onkeyup="checkStrLength(500,this);checkQuota(this)"></textarea>
											</td>
										</tr>
									</table>
									<br>
									<table width="100%">
										<tr>
											<td width="50%" id="captionTitle" colspan="2">작업전</td>
											<td width="50%" id="captionTitle" colspan="2">작업후</td>
										</tr>
										<tr>
											<td width="25%" id="captionSubTitle" align="center" style="width:200px;height:200px;text-align:center">
												<input type="file" name="file_image_1" id="item_image_1" style="display:none" onChange="selectFolder(event,1)">
												<a href="#" class="AXButtonSmall Red" onclick="HandleBrowseClick(1)">이미지선택</a>
												<br><br>
												<img	id="preview_1" src="<c:url value='/'/>images/png/no_image_item.png" />
											</td>
											<td width="25%" id="captionSubTitle" align="center" style="width:200px;height:200px;text-align:center">
												<input type="file" name="file_image_2" id="item_image_2" style="display:none" onChange="selectFolder(event,2)">
												<a href="#" class="AXButtonSmall Red" onclick="HandleBrowseClick(2)">이미지선택</a>
												<br><br>
												<img	id="preview_2" src="<c:url value='/'/>images/png/no_image_item.png" />
											</td>
											<td width="25%" id="captionSubTitle" align="center" style="width:200px;height:200px;text-align:center">
												<input type="file" name="file_image_3" id="item_image_3" style="display:none" onChange="selectFolder(event,3)">
												<a href="#" class="AXButtonSmall Red" onclick="HandleBrowseClick(3)">이미지선택</a>
												<br><br>
												<img	id="preview_3" src="<c:url value='/'/>images/png/no_image_item.png" />
											</td>
											<td width="25%" id="captionSubTitle" align="center" style="width:200px;height:200px;text-align:center">
												<input type="file" name="file_image_4" id="item_image_4" style="display:none" onChange="selectFolder(event,4)">
												<a href="#" class="AXButtonSmall Red" onclick="HandleBrowseClick(4)">이미지선택</a>
												<br><br>
												<img	id="preview_4" src="<c:url value='/'/>images/png/no_image_item.png" />
											</td>
										</tr>
									</table>
								</div>
							</td>
						</tr>
						
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td id='btn_layer' align="center">
								<a href='#' class='AXButton Gray' onclick="setSaveData()">등록</a>
								&nbsp;
								<a href='#' class='AXButton Gray' onclick="self.close()">닫기</a>
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