<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Language" content="ko" >

<title><spring:message code="space.manage.program.title" /></title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >

<link href="<c:url value='/css/titlefix/defaultTheme.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/myTheme.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/titlefix/jquery.fixedheadertable.js"/>"/></script>

<script language="javascript1.2" type="text/javaScript">
	
	$(function(){
		var div_height = document.body.clientHeight-200;
		$('#data_table').fixedHeaderTable({ fixedColumn: true,height:div_height,autoShow:true});
	});

	
	function fCheckAll() 
	{
	    var checkField = document.progrmManageForm.checkField;
	    
	    if(document.getElementById("checkAll").checked)
	    {
	        if(checkField) 
	        {
	            if(checkField.length > 1) 
	            {
	                for(var i=0; i < checkField.length; i++) 
	                {
	                    checkField[i].checked = true;
	                }
	            } 
	            else 
	            {
	                checkField.checked = true;
	            }
	        }
	    } 
	    else 
	    {
	        if(checkField) 
	        {
	            if(checkField.length > 1) 
	            {
	                for(var j=0; j < checkField.length; j++) 
	                {
	                    checkField[j].checked = false;
	                }
	            } 
	            else 
	            {
	                checkField.checked = false;
	            }
	        }
	    }
	}
	
	
	function fDeleteProgrmManageList() 
	{
	    var checkField = document.progrmManageForm.checkField;
	    var ProgrmFileNm = document.progrmManageForm.checkProgrmFileNm;
	    var checkProgrmFileNms = "";
	    var checkedCount = 0;
	    
	    if(checkField) 
	    {
	        if(checkField.length > 1) 
	        {
	            for(var i=0; i < checkField.length; i++) 
	            {
	                if(checkField[i].checked) 
	                {
	                    checkProgrmFileNms += ((checkedCount==0? "" : ",") + ProgrmFileNm[i].value);
	                    checkedCount++;
	                }
	            }
	        } 
	        else 
	        {
	            if(checkField.checked) 
	            {
	                checkProgrmFileNms = ProgrmFileNm.value;
	            }
	        }
	    }   
	
	    document.progrmManageForm.checkedProgrmFileNmForDel.value=checkProgrmFileNms;
	    document.progrmManageForm.action = "<c:url value='/sym/prm/EgovProgrmManageListDelete.do'/>";
	    document.progrmManageForm.submit(); 
	}
	
	
	function linkPage(pageNo)
	{
		//  document.menuManageForm.searchKeyword.value = 
	    document.progrmManageForm.pageIndex.value = pageNo;
	    document.progrmManageForm.action = "<c:url value='/sym/prm/EgovProgramListManageSelect.do'/>";
	    document.progrmManageForm.submit();
	}
	
	
	function selectProgramListManage() 
	{ 
	    document.progrmManageForm.pageIndex.value = 1;
	    document.progrmManageForm.action = "<c:url value='/sym/prm/EgovProgramListManageSelect.do'/>";
	    document.progrmManageForm.submit(); 
	}
	
	
	function insertProgramListManage() 
	{
	    document.progrmManageForm.action = "<c:url value='/sym/prm/EgovProgramListRegist.do'/>";
	    document.progrmManageForm.submit(); 
	}
	
	
	function selectUpdtProgramListDetail(progrmFileNm) 
	{
	    document.progrmManageForm.tmp_progrmNm.value = progrmFileNm;
	    document.progrmManageForm.action = "<c:url value='/sym/prm/EgovProgramListDetailSelectUpdt.do'/>";
	    document.progrmManageForm.submit(); 
	}
	
	
	function fn_FocusStart()
	{
		var objFocus = document.getElementById('F1');
		objFocus.focus();
	}
	
	<c:if test="${!empty resultMsg}">alert("${resultMsg}");</c:if>

</script>
</head>

<body style="background-color: #2c3338;">

<!-- 전체 레이어 시작 -->
<div id="wrap">
    <!-- header 시작 -->
    <div id="header"><c:import url="/EgovPageLink.do?link=main/inc/EgovIncHeader" /></div>
    <div id="topnavi"><c:import url="/sym/mms/EgovMainMenuHead.do" /></div>    
    <div id="subnavi"><c:import url="/sym/mms/EgovMainMenuSub.do" /></div>    
    <!-- //header 끝 --> 
    
    <form name="progrmManageForm" action ="<c:url value='/sym/prm/EgovProgramListManageSelect.do'/>" method="post">
    <input name="pageIndex" type="hidden" value="<c:out value='${searchVO.pageIndex}'/>"/>
    <input type="hidden" name="searchCondition"/>
	<input name="checkedProgrmFileNmForDel" type="hidden" />
	<input type="hidden" name="cmd">
	<input type="hidden" name="tmp_progrmNm">
    
    
    <div id="spacecontainer">
		<table width="100%">
			<tr><td colspan="3" height="3"></td></tr>
			<tr>
				<td valign="top">
					<table>
						<tr>
							<td width="*">
								<div style="width:1000px;border: 1px solid #D5D1B0;">
									<table width="100%">
										<tr>
											<td id="captionSubTitle" align="center" style="background-color: #2c3338;">
												 <font color="#FFF"><spring:message code="space.manage.program.item.hangulname" /> : </font>
								                <input name="searchKeyword" type="text" size="50" value="<c:out value='${searchVO.searchKeyword}'/>"  maxlength="60" id="F1">  
								                <a class='AXButton Gray' href="#LINK" onclick="javascript:selectProgramListManage(); return false;" ><spring:message code="button.search" /></a>
		                                        <a class='AXButton Gray' href="<c:url value='/sym/mpm/EgovProgramListRegist.do'/>" onclick="insertProgramListManage(); return false;"><spring:message code="button.create" /></a>                              
		                                        <a class='AXButton Gray' href="#LINK" onclick="fDeleteProgrmManageList(); return false;"><spring:message code="button.delete" /></a>
											</td>
										</tr>
									</table>
								</div>
							</td>
						</tr>
						<tr>
							<td colspan="3">
								<div class="tableContainer" style="width:1000px;">
									<table id="data_table" class="fancyTable"> 
										<thead>
											<tr>
												<th><input type="checkbox" name="checkAll" id="checkAll" class="check2" onclick="javascript:fCheckAll();"></th>
												<th><spring:message code="space.manage.program.item.filename" /></th>
												<th><spring:message code="space.manage.program.item.hangulname" /></th>
												<th><spring:message code="space.manage.program.item.url" /></th>
												<th><spring:message code="space.manage.program.item.desc" /></th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="result" items="${list_progrmmanage}" varStatus="status">
											<tr>
												<td><input type="checkbox" name="checkField" class="check2"><input name="checkProgrmFileNm" type="hidden" value="<c:out value='${result.progrmFileNm}'/>"/></td>
												<td><a href="<c:url value='/sym/prm/EgovProgramListDetailSelectUpdt.do'/>?tmp_progrmNm=<c:out value="${result.progrmFileNm}"/>"  onclick="selectUpdtProgramListDetail('<c:out value="${result.progrmFileNm}"/>'); return false;"><font color="#FFF"><c:out value="${result.progrmFileNm}"/></font></a></td>
												<td><font color="#FFF"><c:out value="${result.progrmKoreanNm}"/></font></td>
												<td><font color="#FFF"><c:out value="${result.URL}"/></font></td>
												<td><font color="#FFF"><c:out value="${result.progrmDc}"/></font></td>
											</tr>
											</c:forEach>
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
	</form>
	
</div>
<!-- //전체 레이어 끝 -->
 </body>
</html>