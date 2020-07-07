<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Language" content="ko" >
<title>사용자 등록</title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>
<style>
	input {
		height:70% !important;
	}
	select {
		height:70% !important;
	}
</style>
<script>

function fnIdCheck()
{
	var retVal;
    var url = "<c:url value='/uss/umt/cmm/EgovIdDplctCnfirmView.do'/>";
    window.open(url,'','toolbar=no,location=no,status=yes,menubar=no,scrollbars=no,resizable=no,width=580,height=250,top=100,left=100');
}

function fnIsEmail(asValue) {

	var regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;

	return regExp.test(asValue); // 형식에 맞는 경우 true 리턴	

}

//핸드폰 번호 체크 정규식

function fnIsPhoneNm(asValue) {

	var regExp = /^01(?:0|1|[6-9])-(?:\d{3}|\d{4})-\d{4}$/;

	return regExp.test(asValue); // 형식에 맞는 경우 true 리턴

}


function fnInsert()
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
	
	if(document.userManageVO.password.value == "")
	{
		alert("<spring:message code="space.manage.user.alert.passwd" />");
		document.userManageVO.password.focus();
		return;
	}
	
	if(document.userManageVO.password2.value == "")
	{
		alert("<spring:message code="space.manage.user.alert.repasswd" />");
		document.userManageVO.password2.focus();
		return;
	}

    if(document.userManageVO.password.value != document.userManageVO.password2.value)
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

</script>
</head>
<body class="nav-fixed">

	<form:form commandName="userManageVO" action="${pageContext.request.contextPath}/uss/umt/user/EgovUserInsert.do" name="userManageVO" method="post" >
		<div class="card card-header-actions">
		    <div class="card-header">
		    	Add User
		    	<div class="btn btn-primary btn-sm" onclick="fnInsert()">Add</div>
		    </div>
		    <div class="card-body">
		    	<table class="table table-bordered table-hover" id="dataTable" width="100%" cellspacing="0">
		    		<tbody>
		    			<tr>
			    			<td class="card-header">아이디</td>
			    			<td>
			    				<input class="form-control" id="id_view" name="id_view" style="width:60%;display: inherit;" disabled="disabled" placeholder="중복확인으로 등록" readonly>
			    				<form:input path="emplyrId" id="emplyrId" size="20" maxlength="20" cssStyle="display:none" />
			    				&nbsp;
			    				<a href="#" class="btn btn-outline-orange btn-sm" onclick="fnIdCheck()">중복확인</a></td>
			    			<td class="card-header">이름</td>
			    			<td><input class="form-control" id="emplyrNm" name="emplyrNm" placeholder="Name"></td>
			    		</tr>
			    		<tr>
			    			<td class="card-header">비밀번호</td>
			    			<td><input class="form-control" type="password" id="password" name="password" placeholder="Password"></td>
			    			<td class="card-header">비밀번호확인</td>
			    			<td><input class="form-control" type="password" id="password2" name="password2" placeholder="Password"></td>
			    		</tr>
			    		<tr>
			    			<td class="card-header">비밀번호힌트</td>
			    			<td>
								<div class="dropdown">
								    <div class="form-group" style="margin-bottom: 0px;">
								        <select class="form-control form-control-solid" id="passwordHint" name="passwordHint">
								        	<option value=""> -- Select -- </option>
								            <option value="P01">가장 기억에 남는 장소는?</option>
								            <option value="P02">나의 좌우명은?</option>
								            <option value="P03">나의 보물 제1호는?</option>
								            <option value="P04">가장 기억에 남는 선생님 성함은?</option>
								            <option value="P05">다른 사람은 모르는 나만의 신체비밀은?</option>
								        </select>
								    </div>
								</div>
							</td>
			    			<td class="card-header">비밀번호힌트 정답</td>
			    			<td><input class="form-control" id="passwordCnsr" name="passwordCnsr" placeholder="Hint Answer"></td>
			    		</tr>
			    		<tr>
			    			<td class="card-header">이메일</td>
			    			<td><input class="form-control" id="emailAdres" name="emailAdres" placeholder="Email Address"></td>
			    			<td class="card-header">전화번호</td>
			    			<td><input class="form-control" id="moblphonNo" name="moblphonNo" placeholder="Phone Number"></td>
			    		</tr>
		    		</tbody>
		    	</table>
		    </div>
		</div>
		<input type="hidden" name="orgnztId" value="<c:out value='ORGNZT_0000000000000'/>"/>
		<input type="hidden" name="emplyrSttusCode" value="<c:out value='P'/>"/>
		<input type="hidden" name="groupId" value="<c:out value='GROUP_00000000000000'/>"/>
		<input type="hidden" name="searchCondition" value="<c:out value='${userSearchVO.searchCondition}'/>"/>
	    <input type="hidden" name="searchKeyword" value="<c:out value='${userSearchVO.searchKeyword}'/>"/>
	    <input type="hidden" name="sbscrbSttus" value="<c:out value='${userSearchVO.sbscrbSttus}'/>"/>
	    <input type="hidden" name="pageIndex" value="<c:out value='${userSearchVO.pageIndex}'/><c:if test="${userSearchVO.pageIndex eq null}">1</c:if>"/>
	</form:form>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smartscripts.js'/>"></script>
<script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js" crossorigin="anonymous"></script>
<%-- <script src="<c:url value='/assets/demo/datatables-demo.js'/>"></script> --%>
</body>
</html>