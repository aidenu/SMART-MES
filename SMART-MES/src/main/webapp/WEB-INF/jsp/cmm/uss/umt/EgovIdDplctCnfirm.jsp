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
<title><spring:message code="smart.manage.user.popup.title" /></title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>

<script type="text/javaScript">
	
	window.onload= function() {
		document.checkForm.checkId.focus();
	}
	
	function fnCheckId()
	{
		if(document.checkForm.checkId.value=="")
		{
			alert("<spring:message code="smart.manage.user.alert.duplicate" />");
			document.checkForm.focus();
	        return;
		}
		
		if(fnCheckNotKorean(document.checkForm.checkId.value))
		{
			document.checkForm.submit();
	    }
		else
		{
	    	alert("<spring:message code="smart.manage.user.alert.hangul" />");
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
	        alert("<spring:message code="smart.manage.user.alert.exist" />");
	        return;
	    }
	    else
	    {
	    	alert("<spring:message code="smart.manage.user.alert.confirm.duplicate" />");
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
<body leftmargin="5px">
    <form name="checkForm" action ="<c:url value='/uss/umt/cmm/EgovIdDplctCnfirm.do'/>">
    <input type="submit" id="invisible" class="invisible"/>

	<div class="card card-header-actions">
	    <div class="card-body">
	    	<table class="table table-bordered table-hover" id="dataTable" width="100%" cellspacing="0">
	    		<tbody>
	    			<tr>
						<td class="card-header"><spring:message code="smart.manage.user.item.useid" /></td>
						<td>
							<input type="hidden" name="resultId" value="<c:out value="${checkId}"/>" />
				            <input type="hidden" name="usedCnt" value="<c:out value="${usedCnt}"/>" />
				            <input class="form-control" name="checkId" value="<c:out value="${checkId}"/>" size="25" maxlength="20"  />
						</td>
					</tr>
					<tr>
						<td class="card-header"><spring:message code="smart.manage.user.item.result" /></td>
						<td>
							<c:choose>
			                <c:when test="${usedCnt eq -1}"><spring:message code="smart.manage.user.alert.confirm.duplicate" /></c:when>
			                <c:when test="${usedCnt eq 0}">${checkId} <spring:message code="smart.manage.user.alert.canuse.id" /></c:when>
			                <c:otherwise>${checkId} <spring:message code="smart.manage.user.alert.cannot.id" /></c:otherwise>
			                </c:choose>
						</td>
					</tr>
	    		</tbody>
	    	</table>
	    </div>
	    <!-- 버튼 시작(상세지정 style로 div에 지정) -->
	    <div align="center">
			<table>
				<tr>
					<td>
			            <a class='btn btn-success btn-sm' href="#LINK" onclick="javascript:fnCheckId(); return false;"><spring:message code="button.inquire" /></a>
					    <a class='btn btn-success btn-sm' href="#LINK" onclick="javascript:fnReturnId(); return false;"><spring:message code="button.use" /></a>
					    <a class='btn btn-success btn-sm' href="#LINK" onclick="javascript:fnClose(); return false;"><spring:message code="button.close" /></a>
					</td>
				</tr>
			</table>
	    </div>
	</div>
	
    
    </form>
    
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smartscripts.js'/>"></script>
<script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js" crossorigin="anonymous"></script>
</body>
</html>