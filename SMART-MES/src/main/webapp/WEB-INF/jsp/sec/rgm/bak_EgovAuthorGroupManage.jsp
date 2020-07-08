<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<meta http-equiv="content-language" content="ko">
<title><spring:message code="space.manage.user.auth.title" /></title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >

<link href="<c:url value='/css/titlefix/defaultTheme.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/myTheme.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/titlefix/jquery.fixedheadertable.js"/>"/></script>

<script type="text/javaScript" language="javascript" defer="defer">
	
	$(function(){
		$('#data_table').fixedHeaderTable({ fixedColumn: true,height:336,autoShow:true});
	});

	
	function fncCheckAll()
	{
	    var checkField = document.listForm.delYn;
	    
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
	
	
	function fncManageChecked()
	{
	    var resultCheck = false;
	    var checkField = document.listForm.delYn;
	    var checkId = document.listForm.checkId;
	    var selectAuthor = document.listForm.authorManageCombo;
	    var booleanRegYn = document.listForm.regYn;
	    var listMberTyCode = document.listForm.mberTyCode;
	    var returnId = "";
	    var returnAuthor = "";
	    var returnRegYn = "";
	    var returnmberTyCode = "";
	    var checkedCount = 0;
	
	    if(checkField)
	    {
	        if(checkField.length > 1)
	        {
	            for(var i=0; i<checkField.length; i++)
	            {
	                if(checkField[i].checked)
	                {
	                    checkedCount++;
	                    checkField[i].value = checkId[i].value;
	                    
	                    if(returnId == "")
	                    {
	                        returnId = checkField[i].value;
	                        returnAuthor = selectAuthor[i].value;
	                        returnRegYn = booleanRegYn[i].value;
	                        returnmberTyCode = listMberTyCode[i].value;
	                    }
	                    else
	                    {
	                        returnId = returnId + ";" + checkField[i].value;
	                        returnAuthor = returnAuthor + ";" + selectAuthor[i].value;
	                        returnRegYn = returnRegYn + ";" + booleanRegYn[i].value;
	                        returnmberTyCode = returnmberTyCode + ";" + listMberTyCode[i].value;
	                        
	                    }
	                }
	            }
	
	            if(checkedCount > 0)
	            {
	                resultCheck = true;
	            }
	            else
	            {
	                alert("<spring:message code="space.manage.user.auth.alert.noselect" />");
	                resultCheck = false;
	            }
	        }
	        else
	        {
	             if(document.listForm.delYn.checked == false)
	             {
	                alert("<spring:message code="space.manage.user.auth.alert.noselect" />");
	                resultCheck = false;
	            }
	            else 
	            {
	                returnId = checkId.value;
	                returnAuthor = selectAuthor.value;
	                returnRegYn = booleanRegYn.value;
	                returnmberTyCode = listMberTyCode.value;
	
	                resultCheck = true;
	            }
	        } 
	    } 
	    else 
	    {
	        alert("<spring:message code="space.manage.user.auth.alert.noresult" />");
	    }
	    
	    document.listForm.userIds.value = returnId;
	    document.listForm.authorCodes.value = returnAuthor;
	    document.listForm.regYns.value = returnRegYn;
	    document.listForm.mberTyCodes.value = returnmberTyCode;
	
	    return resultCheck;
	}
	
	
	function fncSelectAuthorGroupList(pageNo)
	{
	    //document.listForm.searchCondition.value = "1";
	    document.listForm.pageIndex.value = pageNo;
	    document.listForm.action = "<c:url value='/sec/rgm/EgovAuthorGroupList.do'/>";
	    document.listForm.submit();
	}
	
	
	function fncAddAuthorGroupInsert() 
	{
	    if(!fncManageChecked()) return;
	    
	    if(confirm("<spring:message code="space.common.insertis" />")) 
	    {
	        document.listForm.action = "<c:url value='/sec/rgm/EgovAuthorGroupInsert.do'/>";
	        document.listForm.submit();
	    }
	}
	
	
	function fncAuthorGroupDeleteList() 
	{
	    if(!fncManageChecked()) return;
	
	    if(confirm("<spring:message code="space.common.deleteis" />")) 
	    {
	        document.listForm.action = "<c:url value='/sec/rgm/EgovAuthorGroupDelete.do'/>";
	        document.listForm.submit(); 
	    }
	}
	
	
	function linkPage(pageNo)
	{
		//document.listForm.searchCondition.value = "1";
	    document.listForm.pageIndex.value = pageNo;
	    document.listForm.action = "<c:url value='/sec/rgm/EgovAuthorGroupList.do'/>";
	    document.listForm.submit();
	}
	
	
	function fncSelectAuthorGroupPop() 
	{
	    if(document.listForm.searchCondition.value == '3') 
	    {
	        window.open("<c:url value='/sec/gmt/EgovGroupSearchView.do'/>","notice","height=500, width=800, top=50, left=20, scrollbars=no, resizable=no");
	    } 
	    else 
	    {
	        alert("그룹을 선택하세요.");
	        return;
	    }
	}
	
	
	function onSearchCondition() 
	{
	    document.listForm.searchKeyword.value = "";
	    
	    if(document.listForm.searchCondition.value == '3') 
	    {
	        document.listForm.searchKeyword.readOnly = true;
	    } 
	    else 
	    {
	        document.listForm.searchKeyword.readOnly = false;
	    }
	}
	
	
	function press() 
	{
	    if (event.keyCode==13) 
	    {
	        fncSelectAuthorGroupList('1');
	    }
	}

</script>

</head>

<body style="background-color: #2c3338;">
    
<!-- 전체 레이어 시작 -->
<div id="wrap">
    <!-- header 시작 -->
    <div id="header"><c:import url="/EgovPageLink.do?link=main/inc/EgovIncHeader" /></div>
    <div id="topnavi"><c:import url="/sym/mms/EgovMainMenuHead.do" /></div>        
    <div id="subnavi"><c:import url="/sym/mms/EgovMainMenuSub.do" /></div>    
    
    <form:form name="listForm" action="<c:url value='/sec/rgm/EgovAuthorGroupList.do'/>" method="post">
    <input type="hidden" name="userId"/>
	<input type="hidden" name="userIds"/>
	<input type="hidden" name="authorCodes"/>
	<input type="hidden" name="regYns"/>
	<input type="hidden" name="mberTyCodes"/>
	<input type="hidden" name="pageIndex" value="<c:out value='${authorGroupVO.pageIndex}'/>"/>
    
    
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
												<select name="searchCondition" onchange="onSearchCondition()">
								                    <option value="1" <c:if test="${authorGroupVO.searchCondition == '1'}">selected</c:if> >ID</option>
								                    <option value="2" <c:if test="${authorGroupVO.searchCondition == '2'}">selected</c:if> >NAME</option>
								                </select> 
								                <input name="searchKeyword" type="text" value="<c:out value='${authorGroupVO.searchKeyword}'/>" size="25" onkeypress="press();"/> 
								                <a class='AXButton Gray' href="#LINK" onclick="javascript:fncSelectAuthorGroupList('1')" style="selector-dummy:expression(this.hideFocus=false);"><spring:message code="space.manage.user.auth.button.search" /></a>
		                                        <a class='AXButton Gray' href="#LINK" onclick="javascript:fncAddAuthorGroupInsert()" style="selector-dummy:expression(this.hideFocus=false);"><spring:message code="space.manage.user.auth.button.regist" /></a>
		                                        <a class='AXButton Gray' href="#LINK" onclick="javascript:fncAuthorGroupDeleteList()" style="selector-dummy:expression(this.hideFocus=false);"><spring:message code="space.manage.user.auth.button.cancel" /></a>
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
												<th><input name="checkAll" id="checkAll" type="checkbox" title="Check All" onclick="javascript:fncCheckAll();"/></th>
												<th><spring:message code="space.manage.user.auth.item.id" /></th>
												<th><spring:message code="space.manage.user.auth.item.name" /></th>
												<th><spring:message code="space.manage.user.auth.item.auth" /></th>
												<th><spring:message code="space.manage.user.auth.item.regflag" /></th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="authorGroup" items="${authorGroupList}" varStatus="status">
											<tr>
												<td><input type="checkbox" name="delYn" class="check2"><input type="hidden" name="checkId" value="<c:out value="${authorGroup.uniqId}"/>"/></td>
												<td><font color="#FFF"><c:out value="${authorGroup.userId}"/></font><input type="hidden" name="mberTyCode" value="${authorGroup.mberTyCode}"/></td>
												<td><font color="#FFF"><c:out value="${authorGroup.userNm}"/></font></td>
												<td>
													<select name="authorManageCombo">
											            <c:forEach var="authorManage" items="${authorManageList}" varStatus="status">
											                <option value="<c:out value="${authorManage.authorCode}"/>" <c:if test="${authorManage.authorCode == authorGroup.authorCode}">selected</c:if> ><c:out value="${authorManage.authorNm}"/></option>
											            </c:forEach>
											        </select>
												</td>
												<td><font color="#FFF"><c:out value="${authorGroup.regYn}"/><input type="hidden" name="regYn" value="<c:out value="${authorGroup.regYn}"/>"></font></td>
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
		<!-- 페이지 네비게이션 시작 -->
	    <c:if test="${!empty authorGroupVO.pageIndex }">
	   <table width="1000">
			<tr>
				<td>
					<div id="paging_div">
						<ul class="paging_align"><ui:pagination paginationInfo = "${paginationInfo}" type="image" jsFunction="linkPage" /></ul>
					</div>
				</td>
			</tr>
		</table>
	    </c:if>              
	     <!-- //페이지 네비게이션 끝 -->
	</div>
	</form:form>

</div>
<!-- //전체 레이어 끝 -->
 </body>
</html>