<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Language" content="ko" >

<title><spring:message code="space.manage.menulist.title" /></title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<script type="text/javascript" src="<c:url value="/validator.do"/>"></script>
<validator:javascript formName="menuManageVO" staticJavascript="false" xhtml="true" cdata="false"/>
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >

<script type="text/javaScript">

	function updateMenuManage(form) 
	{
	    if(!validateMenuManageVO(form))
	    {            
	        return;
	    }
	    else
	    {
	    	if(confirm("<spring:message code='common.save.msg' />"))
	    	{
	        	form.action="<c:url value='/sym/mnu/mpm/EgovMenuDetailSelectUpdt.do'/>";
	         	form.submit();
	    	}
	    }
	}
	
	
	function deleteMenuManage(form) 
	{
	    if(confirm("<spring:message code='common.delete.msg' />"))
	    {
	        form.action="<c:url value='/sym/mnu/mpm/EgovMenuManageDelete.do'/>";
	        form.submit();
	    }
	}
	
	
	function searchFileNm() 
	{
	    document.all.tmp_SearchElementName.value = "progrmFileNm";
	    window.open("<c:url value='/sym/prm/EgovProgramListSearch.do'/>",'','width=750,height=500');
	}
	
	
	function selectList()
	{
	    location.href = "<c:url value='/sym/mnu/mpm/EgovMenuManageSelect.do'/>";
	}
	
	
	function press() 
	{
	    if (event.keyCode==13) 
	    {
	        searchFileNm();    // 원래 검색 function 호출
	    }
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
    

	<form:form commandName="menuManageVO" name="menuManageVO" action ="<c:url value='/sym/mnu/mpm/EgovMenuDetailSelectUpdt.do' />" method="post">
	<input type="hidden" name="tmp_SearchElementName" value=""/>
	<input type="hidden" name="tmp_SearchElementVal" value=""/>
	<input name="cmd"    type="hidden"   value="update"/>
	<input type="hidden" name="relateImageNm" value="">
	<input type="hidden" name="relateImagePath" value="">
	
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
											<td id="captionTitle" align="center"><spring:message code="space.manage.menulist.item.no" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<c:out value="${menuManageVO.menuNo}"/> 
                              					<form:hidden path="menuNo" />
                              					<form:errors path="menuNo" />
											</td>
										</tr>
										<tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.menulist.item.index" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<form:input path="menuOrdr" size="10" maxlength="10" />
                              					<form:errors path="menuOrdr" />
											</td>
										</tr>
										<tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.menulist.item.name" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<form:input path="menuNm" size="30" maxlength="30"/>
                              					<form:errors path="menuNm" />
											</td>
										</tr>
										<tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.menulist.item.parent" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<form:input path="upperMenuId" size="10" maxlength="10"/>
                              					<form:errors path="upperMenuId" />
											</td>
										</tr>
										<tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.menulist.item.filename" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<input type="text" name="progrmFileNm_view" size="60" disabled="disabled" value="${menuManageVO.progrmFileNm}">
				                                <form:input path="progrmFileNm" size="60" maxlength="60" cssStyle="display:none" />
				                                <form:errors path="progrmFileNm" />
				                                <a class='AXButtonSmall Red' href="<c:url value='/sym/prm/EgovProgramListSearch.do'/>?tmp_SearchElementName=progrmFileNm" target="_blank" onclick="javascript:searchFileNm(); return false;" style="selector-dummy:expression(this.hideFocus=false);" ><spring:message code="space.manage.menulist.button.filesearch" /></a>
											</td>
										</tr>
										<tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.menulist.item.desc" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<form:textarea path="menuDc" rows="5" cols="60" cssClass="txaClass"/>
						      					<form:errors path="menuDc"/>
											</td>
										</tr>
									</table>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	</form:form>

	<div style="width:1000px" align="center">
		<table>
			<tr>
				<td>
					<a class='AXButton Gray' href="<c:url value='/sym/mnu/mpm/EgovMenuManageSelect.do'/>" onclick="javascript:selectList(); return false;"><spring:message code="button.list" /></a>
					<a class='AXButton Gray' href="#LINK" onclick="javascript:updateMenuManage(document.getElementById('menuManageVO')); return false;"><spring:message code="button.save" /></a>
					<a class='AXButton Gray' href="#LINK" onclick="deleteMenuManage(document.getElementById('menuManageVO')); return false;"><spring:message code="button.delete" /></a>
				</td>
			</tr>
		</table>
    </div>

</div>
<!-- //전체 레이어 끝 -->
</body>
</html>

