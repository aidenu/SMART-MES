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

<title><spring:message code="space.manage.program.title" /></title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<script type="text/javascript" src="<c:url value="/validator.do"/>"></script>
<validator:javascript formName="progrmManageVO" staticJavascript="false" xhtml="true" cdata="false"/>
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >

<script type="text/javaScript" language="javascript">


	function updateProgramListManage(form) 
	{
	    if(confirm("<spring:message code="common.save.msg" />"))
	    {
	        if(!validateProgrmManageVO(form))
	        {          
	            return;
	        }
	        else
	        {
	            form.action="<c:url value='/'/>sym/prm/EgovProgramListDetailSelectUpdt.do";
	            form.submit();
	        }
	    }
	}
	
	
	function deleteProgramListManage(form) 
	{
	    if(confirm("<spring:message code="common.delete.msg" />"))
	    {
	        form.action="<c:url value='/'/>sym/prm/EgovProgramListManageDelete.do";
	        form.submit();
	    }
	}
	
	
	function selectList()
	{
	    location.href = "<c:url value='/'/>sym/prm/EgovProgramListManageSelect.do";
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
    

	<form:form commandName="progrmManageVO" action="/sym/prm/EgovProgramListDetailSelectUpdt.do">
	<input name="cmd" type="hidden" value="<c:out value='update'/>"/>
	
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
											<td id="captionTitle" align="center"><spring:message code="space.manage.program.item.filename" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<input type="text" disabled="disabled" value="<c:out value="${progrmManageVO.progrmFileNm  }"/>" >
											    <form:input  path="progrmFileNm" size="50"  maxlength="50" cssStyle="display:none" />
											    <form:errors path="progrmFileNm"/>
											</td>
										</tr>
										<tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.program.item.location" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<form:input  path="progrmStrePath" size="50"  maxlength="50" />
						      					<form:errors path="progrmStrePath"/>
											</td>
										</tr>
										<tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.program.item.hangulname" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<form:input path="progrmKoreanNm" size="50"  maxlength="50" />
						     				 	<form:errors path="progrmKoreanNm" />
											</td>
										</tr>
										<tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.program.item.url" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<form:input path="URL" size="50"  maxlength="60" title="URL" />
						      					<form:errors path="URL" />
											</td>
										</tr>
										<tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.program.item.desc" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<form:textarea path="progrmDc" rows="5" cols="60"/>
						      					<form:errors path="progrmDc"/>
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
					<a class='AXButton Gray' href="<c:url value='/sym/mpm/EgovProgramListManageSelect.do'/>" onclick="selectList(); return false;"><spring:message code="button.list" /></a>
					<a class='AXButton Gray' href="#LINK" onclick="javascript:updateProgramListManage(document.getElementById('progrmManageVO')); return false;"><spring:message code="button.save" /></a>
					<a class='AXButton Gray' href="<c:url value='/sym/prm/EgovProgramListManageDelete.do'/>?progrmFileNm=<c:out value="${progrmManageVO.progrmFileNm  }"/>" onclick="deleteProgramListManage(document.getElementById('progrmManageVO')); return false;"><spring:message code="button.delete" /></a>
				</td>
			</tr>
		</table>
    </div>

</div>
<!-- //전체 레이어 끝 -->
</body>
</html>

