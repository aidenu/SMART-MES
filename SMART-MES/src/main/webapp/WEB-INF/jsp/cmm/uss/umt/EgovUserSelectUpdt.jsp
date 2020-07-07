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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<meta http-equiv="content-language" content="ko">
<title><spring:message code="space.manage.user.title" /></title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>

<script type="text/javaScript" language="javascript" defer="defer">
	
	function fnIsEmail(asValue) {
	
		var regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
	
		return regExp.test(asValue); // 형식에 맞는 경우 true 리턴	
	
	}
	
	//핸드폰 번호 체크 정규식
	
	function fnIsPhoneNm(asValue) {
	
		var regExp = /^01(?:0|1|[6-9])-(?:\d{3}|\d{4})-\d{4}$/;
	
		return regExp.test(asValue); // 형식에 맞는 경우 true 리턴
	
	}

	function fnUpdate()
	{
		if(document.userManageVO.emplyrId.value == "")
		{
			alert("<spring:message code="space.manage.user.alert.id" />");
			return;
		}
		
		if(document.userManageVO.emplyrNm.value == "")
		{
			alert("<spring:message code="space.manage.user.alert.name" />");
			document.userManageVO.emplyrNm.focus();
			return;
		}
		
		if(document.userManageVO.newpassword.value != document.userManageVO.newpassword2.value)
	    {
	        alert("<spring:message code="fail.user.passwordUpdate2" />");
	        return;
	    }
		
		if(document.userManageVO.emailAdres.value != "") {
	    	var emailValid = fnIsEmail(document.userManageVO.emailAdres.value);
	    	if(!emailValid) {
	    		alert("<spring:message code="fail.user.emailValid" />");
	    		document.userManageVO.emailAdres.focus();
	    		return;
	    	}
	    }
	    
	    if(document.userManageVO.moblphonNo.value != "") {
	    	var phoneValid = fnIsPhoneNm(document.userManageVO.moblphonNo.value);
	    	if(!phoneValid) {
	    		alert("<spring:message code="fail.user.phoneValid" />");
	    		document.userManageVO.moblphonNo.focus();
	    		return;
	    	}
	    }
		
	    document.userManageVO.submit();
	}
	
	
	function fn_egov_inqire_cert()
	{
	    var url = '/uat/uia/EgovGpkiRegist.do';
	    var popupwidth = '500';
	    var popupheight = '400';
	    var title = '인증서';
	
	    Top = (window.screen.height - popupheight) / 3;
	    Left = (window.screen.width - popupwidth) / 2;
	    
	    if (Top < 0) Top = 0;
	    if (Left < 0) Left = 0;
	    
	    Future = "fullscreen=no,toolbar=no,location=no,directories=no,status=no,menubar=no, scrollbars=no,resizable=no,left=" + Left + ",top=" + Top + ",width=" + popupwidth + ",height=" + popupheight;
	    PopUpWindow = window.open(url, title, Future)
	    PopUpWindow.focus();
	}
	
	function fn_egov_dn_info_setting(dn)
	{
	    var frm = document.userManageVO;
	    
	    frm.subDn.value = dn;
	}

</script>

</head>
<body class="nav-fixed">
	<form:form commandName="userManageVO" action="${pageContext.request.contextPath}/uss/umt/user/EgovUserSelectUpdt.do" name="userManageVO" method="post" >
		<div class="card card-header-actions">
		    <div class="card-header">
		    	Update User
		    	<div>
			    	<div class="btn btn-primary btn-sm" onclick="fnUpdate();"><spring:message code="button.save" /></div>
			    	<div class="btn btn-primary btn-sm" onclick="self.close();"><spring:message code="button.close" /></div>
			    </div>
		    </div>
		    <div class="card-body">
		    	<table class="table table-bordered table-hover" id="dataTable" width="100%" cellspacing="0">
		    		<tbody>
		    			<tr>
			    			<td class="card-header">아이디</td>
			    			<td>
			    				<input class="form-control" id="id_view" name="id_view" style="width:60%;display: inherit;" disabled="disabled" value="${userManageVO.emplyrId }" readonly>
			    				<form:input path="emplyrId" id="emplyrId" size="20" maxlength="20" value="${userManageVO.emplyrId }" cssStyle="display:none" />
			    				<input name="uniqId" id="uniqId" title="uniqId" type="hidden" size="20" value="<c:out value='${userManageVO.uniqId}'/>"/>
			    			<td class="card-header">이름</td>
			    			<td><input class="form-control" id="emplyrNm" name="emplyrNm" value="${userManageVO.emplyrNm }" placeholder="Name"></td>
			    		</tr>
			    		<tr>
			    			<td class="card-header">이메일</td>
			    			<td><input class="form-control" id="emailAdres" name="emailAdres" value="${userManageVO.emailAdres }" placeholder="Email Address"></td>
			    			<td class="card-header">전화번호</td>
			    			<td><input class="form-control" id="moblphonNo" name="moblphonNo" value="${userManageVO.moblphonNo }" placeholder="Phone Number"></td>
			    		</tr>
			    		<tr>
			    			<td class="card-header">변경후 비밀번호</td>
			    			<td><input class="form-control" id="newpassword" name="newpassword" type="password" placeholder="새로운 비밀번호"></td>
			    			<td class="card-header">변경후 비밀번호 확인</td>
			    			<td><input class="form-control" id="newpassword2" name="newpassword2" type="password" placeholder="새로운 비밀번호 확인"></td>
			    		</tr>
		    		</tbody>
		    	</table>
		    </div>
		</div>
		<input type="hidden" name="orgnztId" value="<c:out value='ORGNZT_0000000000000'/>"/>
		<input type="hidden" name="emplyrSttusCode" value="<c:out value='P'/>"/>
		<input type="hidden" name="groupId" value="<c:out value='GROUP_00000000000000'/>"/>
		<input name="checkedIdForDel" type="hidden" />
		<input type="hidden" name="searchCondition" value="<c:out value='${userSearchVO.searchCondition}'/>"/>
	    <input type="hidden" name="searchKeyword" value="<c:out value='${userSearchVO.searchKeyword}'/>"/>
	    <input type="hidden" name="sbscrbSttus" value="<c:out value='${userSearchVO.sbscrbSttus}'/>"/>
	    <input type="hidden" name="pageIndex" value="<c:out value='${userSearchVO.pageIndex}'/>"/>
	    <input type="hidden" name="userTyForPassword" value="<c:out value='${userManageVO.userTy}'/>" />
	    <form:hidden path="password" />
	</form:form>
    
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smartscripts.js'/>"></script>
<script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js" crossorigin="anonymous"></script>
<%-- <script src="<c:url value='/assets/demo/datatables-demo.js'/>"></script> --%>
</body>
</html>

