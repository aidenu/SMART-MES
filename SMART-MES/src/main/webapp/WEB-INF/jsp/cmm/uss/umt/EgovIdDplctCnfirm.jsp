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
<title><spring:message code="space.manage.user.popup.title" /></title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >
<base target="_self">
<script type="text/javascript" src="<c:url value='/js/showModalDialogCallee.js'/>" ></script>
<script type="text/javaScript">
	
	function fnCheckId()
	{
		if(document.checkForm.checkId.value=="")
		{
			alert("<spring:message code="space.manage.user.alert.duplicate" />");
			document.checkForm.focus();
	        return;
		}
		
		if(fnCheckNotKorean(document.checkForm.checkId.value))
		{
			document.checkForm.submit();
	    }
		else
		{
	    	alert("<spring:message code="space.manage.user.alert.hangul" />");
	        return;
	    }
	}
	
	
	function fnReturnId()
	{
		var retVal="";
		
	    if (document.checkForm.usedCnt.value == 0)
	    {
		    retVal = document.checkForm.resultId.value;
		    opener.document.userManageVO.emplyrId.value = retVal;
		    opener.document.userManageVO.id_view.value = retVal;
		    self.close();
	    }
	    else if (document.checkForm.usedCnt.value == 1)
	    {
	        alert("<spring:message code="space.manage.user.alert.exist" />");
	        return;
	    }
	    else
	    {
	    	alert("<spring:message code="space.manage.user.alert.confirm.duplicate" />");
	        return;
	    }
	}
	
	
	function fnClose()
	{
	    var retVal="";
	    window.returnValue = retVal; 
	    window.close();
	}
	
	
	function fnCheckNotKorean(koreanStr)
	{                  
	    for(var i=0;i<koreanStr.length;i++)
	    {
	        var koreanChar = koreanStr.charCodeAt(i);
	        
	        if( !( 0xAC00 <= koreanChar && koreanChar <= 0xD7A3 ) && !( 0x3131 <= koreanChar && koreanChar <= 0x318E ) )
	        { 
	        }
	        else
	        {
	            //hangul finding....
	            return false;
	        }
	    }
	    
	    return true;
	}

</script>

</head>
<body leftmargin="5px" style="background-color: #2c3338;">
    <form name="checkForm" action ="<c:url value='/uss/umt/cmm/EgovIdDplctCnfirm.do'/>">
    <input type="submit" id="invisible" class="invisible"/>

	<div id="spacecontainer">
		<table width="100%">
			<tr><td height="3"></td></tr>
			<tr>
				<td valign="top">
					<table>
						<tr>
							<td width="*">
								<div style="width:400px;border: 1px solid #D5D1B0;">
									<table width="100%">
										<tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.user.item.useid" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<input type="hidden" name="resultId" value="<c:out value="${checkId}"/>" />
									            <input type="hidden" name="usedCnt" value="<c:out value="${usedCnt}"/>" />
									            <input type="text" name="checkId" value="<c:out value="${checkId}"/>" size="25" maxlength="20"  />
											</td>
										</tr>
										<tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.user.item.result" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<c:choose>
								                <c:when test="${usedCnt eq -1}"><spring:message code="space.manage.user.alert.confirm.duplicate" /></c:when>
								                <c:when test="${usedCnt eq 0}">${checkId} <spring:message code="space.manage.user.alert.canuse.id" /></c:when>
								                <c:otherwise>${checkId} <spring:message code="space.manage.user.alert.cannot.id" /></c:otherwise>
								                </c:choose>
											</td>
										</tr>
									</table>
									</form>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	
    <!-- 버튼 시작(상세지정 style로 div에 지정) -->
    <div style="width:400px" align="center">
		<table>
			<tr>
				<td>
		            <a class='AXButton Gray' href="#LINK" onclick="javascript:fnCheckId(); return false;"><spring:message code="button.inquire" /></a>
				    <a class='AXButton Gray' href="#LINK" onclick="javascript:fnReturnId(); return false;"><spring:message code="button.use" /></a>
				    <a class='AXButton Gray' href="#LINK" onclick="javascript:fnClose(); return false;"><spring:message code="button.close" /></a>
				</td>
			</tr>
		</table>
    </div>
    </form>
    
</body>
</html>