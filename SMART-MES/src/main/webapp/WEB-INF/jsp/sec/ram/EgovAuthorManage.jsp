<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<meta http-equiv="content-language" content="ko">
<title><spring:message code="space.manage.auth.title" /></title>
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
		var div_height = document.body.clientHeight-200;
		$('#data_table').fixedHeaderTable({ fixedColumn: true,height:336,autoShow:true});
	});
	
	
	function fnCheckAll()
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
	    var checkField = document.listForm.delYn;
	    var checkId = document.listForm.checkId;
	    var returnValue = "";
	
	    var returnBoolean = false;
	    var checkCount = 0;
	
	    if(checkField)
	    {
	        if(checkField.length > 1)
	        {
	            for(var i=0; i<checkField.length; i++)
	            {
	                if(checkField[i].checked)
	                {
	                    checkField[i].value = checkId[i].value;
	                    
	                    if(returnValue == "")
	                        returnValue = checkField[i].value;
	                    else 
	                        returnValue = returnValue + ";" + checkField[i].value;
	                    checkCount++;
	                }
	            }
	            
	            if(checkCount > 0)
	            {
	                returnBoolean = true;
	            }
				else
	            {
	                alert("<spring:message code="space.manage.auth.alert.noselect" />");
	                returnBoolean = false;
	            }
	        }
	        else
	        {
	            if(document.listForm.delYn.checked == false)
	            {
	                alert("<spring:message code="space.manage.auth.alert.noselect" />");
	                returnBoolean = false;
	            }
	            else
	            {
	                returnValue = checkId.value;
	                returnBoolean = true;
	            }
	        }
	    }
	    else
	    {
	        alert("<spring:message code="space.manage.auth.alert.noresult" />");
	    }
	
	    document.listForm.authorCodes.value = returnValue;
	
	    return returnBoolean;
	}
	
	
	function fncSelectAuthorList(pageNo)
	{
	    document.listForm.searchCondition.value = "1";
	    document.listForm.pageIndex.value = pageNo;
	    document.listForm.action = "<c:url value='/sec/ram/EgovAuthorList.do'/>";
	    document.listForm.submit();
	}
	
	
	function fncSelectAuthor(author)
	{
	    document.listForm.authorCode.value = author;
	    document.listForm.action = "<c:url value='/sec/ram/EgovAuthor.do'/>";
	    document.listForm.submit();     
	}
	
	
	function fncAddAuthorInsert()
	{
	    location.replace("<c:url value='/sec/ram/EgovAuthorInsertView.do'/>"); 
	}
	
	
	function fncAuthorDeleteList()
	{
	    if(fncManageChecked())
	    {    
	        if(confirm("<spring:message code="space.common.deleteis" />"))
	        {
	            document.listForm.action = "<c:url value='/sec/ram/EgovAuthorListDelete.do'/>";
	            document.listForm.submit();
	        } 
	    }
	}
	
	
	function fncAddAuthorView()
	{
	    document.listForm.action = "<c:url value='/sec/ram/EgovAuthorUpdate.do'/>";
	    document.listForm.submit();     
	}
	
	
	function fncSelectAuthorRole(author)
	{
	    document.listForm.searchKeyword.value = author;
	    document.listForm.action = "<c:url value='/sec/ram/EgovAuthorRoleList.do'/>";
	    document.listForm.submit();     
	}
	
	
	function linkPage(pageNo)
	{
	    document.listForm.searchCondition.value = "1";
	    document.listForm.pageIndex.value = pageNo;
	    document.listForm.action = "<c:url value='/sec/ram/EgovAuthorList.do'/>";
	    document.listForm.submit();
	}
	
	
	function press()
	{
	    if (event.keyCode==13)
	    {
	        fncSelectAuthorList('1');
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
    <!-- //header 끝 --> 
    
    <form name="listForm" action="<c:url value='/sec/ram/EgovAuthorList.do'/>" method="post">
    <input type="hidden" name="authorCode"/>
	<input type="hidden" name="authorCodes"/>
	<input type="hidden" name="pageIndex" value="<c:out value='${authorManageVO.pageIndex}'/>"/>
	<input type="hidden" name="searchCondition"/>
    
    
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
												 <font color="#FFF"><spring:message code="space.manage.auth.item.name" /> :</font> 
								                <input name="searchKeyword" type="text" value="<c:out value='${authorManageVO.searchKeyword}'/>" size="25" onkeypress="press();" /> 
								                <a class='AXButton Gray' href="#LINK" onclick="javascript:fncSelectAuthorList('1')" style="selector-dummy:expression(this.hideFocus=false);"><spring:message code="button.search" /></a>
		                                        <a class='AXButton Gray' href="#LINK" onclick="javascript:fncAddAuthorInsert()" style="selector-dummy:expression(this.hideFocus=false);"><spring:message code="button.create" /></a>
		                                        <a class='AXButton Gray' href="#LINK" onclick="javascript:fncAuthorDeleteList()" style="selector-dummy:expression(this.hideFocus=false);"><spring:message code="button.delete" /></a>
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
												<th><input name="checkAll" id="checkAll" type="checkbox" title="Check All" onclick="javascript:fnCheckAll();"/></th>
												<th><spring:message code="space.manage.auth.item.code" /></th>
												<th><spring:message code="space.manage.auth.item.name" /></th>
												<th><spring:message code="space.manage.auth.item.desc" /></th>
												<th><spring:message code="space.manage.auth.item.regdate" /></th>
												<th><spring:message code="space.manage.auth.item.role" /></th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="author" items="${authorList}" varStatus="status">
											<tr>
												<td><input type="checkbox" name="delYn" class="check2" title="선택"><input type="hidden" name="checkId" value="<c:out value="${author.authorCode}"/>" /></td>
												<td><a href="#LINK" onclick="javascript:fncSelectAuthor('<c:out value="${author.authorCode}"/>')"><font color="#FFF"><c:out value="${author.authorCode}"/></font></a></td>
												<td><font color="#FFF"><c:out value="${author.authorNm}"/></font></td>
												<td><font color="#FFF"><c:out value="${author.authorDc}"/></font></td>
												<td><font color="#FFF"><c:out value="${author.authorCreatDe}"/></font></td>
												<td><a href="#LINK" onclick="javascript:fncSelectAuthorRole('<c:out value="${author.authorCode}"/>')"><img src="<c:url value='/images/img_search.gif'/>" width="15" height="15" align="middle" alt="롤 정보"></a></td>
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
	    <c:if test="${!empty authorManageVO.pageIndex }">
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
	</form>
	
</div>
<!-- //전체 레이어 끝 -->
 </body>
</html>