<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Language" content="ko" >
<title><spring:message code="smart.manage.user.title" /></title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>
<script>

	function addUser() {
		window.open("<c:url value='/uss/umt/user/EgovUserInsertView.do'/>", "addPop", "scrollbars=yes,toolbar=no,resizable=yes,left=200,top=200,width=1000,height=425");
	}
	
	function fnDeleteUser(uniqId) {
		if(confirm("<spring:message code="common.delete.msg" />"))
		{
		    document.listForm.checkedIdForDel.value=uniqId;
		    document.listForm.action = "<c:url value='/uss/umt/user/EgovUserDelete.do'/>";
		    document.listForm.submit();
		}
	}
	
	function fnUpdateUser(uniqId) {
		window.open("<c:url value='/uss/umt/user/EgovUserSelectUpdtView.do?selectedId="+uniqId+"'/>", "updatePop", "scrollbars=yes,toolbar=no,resizable=yes,left=200,top=200,width=1000,height=425");
	}
	
	<c:if test="${!empty resultMsg}">alert("<spring:message code="${resultMsg}" />");</c:if>
	
</script>
</head>
<body class="nav-fixed">
	<div>
		<div id="header"><c:import url="/EgovPageLink.do?link=main/nav/SmartHeaderNav" /></div>
	</div>
	<div id="layoutSidenav">
		<div>
			<div id="sidenav"><c:import url="/sym/mms/EgovMainSideNav.do" /></div>
		</div>
		<div id="layoutSidenav_content">
			<main>
				<header class="page-header page-header-dark bg-gradient-primary-to-secondary mb-4">
					<div class="container-fluid">
						<div class="page-header-content pt-4">
							<div class="row align-items-center justify-content-between">
								<div class="col-auto mt-4">
									<h1 class="page-header-title">
										<div class="page-header-icon"><i data-feather="tool"></i></div>
										<span><spring:message code="smart.manage.user.title" /></span>
									</h1>
								</div>
							</div>
						</div>
					</div>
				</header>
				<div class="container-fluid">
					<form name="listForm" method="post">
						<input type="hidden" name="checkedIdForDel">
						<div class="card mb-4">
							<div class="card-header">
								<div class="btn btn-outline-primary" onclick="addUser()"><spring:message code="smart.common.button.add" /></div>
							</div>
							<div class="card-body">
								<div class="datatable table-responsive">
									<table class="table table-bordered table-hover" id="dataTable" width="100%" cellspacing="0">
										<thead>
											<tr>
												<th><spring:message code="smart.manage.user.item.id" /></th>
												<th><spring:message code="smart.manage.user.item.name" /></th>
												<th><spring:message code="smart.manage.user.item.email" /></th>
												<th><spring:message code="smart.manage.user.item.phone" /></th>
												<th><spring:message code="smart.manage.user.item.regdate" /></th>
												<th>Actions</th>
											</tr>
										</thead>
										<tfoot>
											<tr>
												<th><spring:message code="smart.manage.user.item.id" /></th>
												<th><spring:message code="smart.manage.user.item.name" /></th>
												<th><spring:message code="smart.manage.user.item.email" /></th>
												<th><spring:message code="smart.manage.user.item.phone" /></th>
												<th><spring:message code="smart.manage.user.item.regdate" /></th>
												<th>Actions</th>
											</tr>
	                                    </tfoot>
	                                    <tbody>
	                                    	<c:forEach var="result" items="${resultList}" varStatus="status">
	                                    		<tr>
	                                    			<td><c:out value="${result.userId}"/></td>
	                                    			<td><c:out value="${result.userNm}"/></td>
	                                    			<td><c:out value="${result.emailAdres}"/></td>
	                                    			<td><c:out value="${result.moblphonNo}"/></td>
	                                    			<td><c:out value="${result.sbscrbDe}"/></td>
	                                    			<td>
	                                    				<div class="btn btn-datatable btn-icon btn-transparent-dark mr-2" onclick="fnUpdateUser('${result.uniqId}')">
	                                    					<i data-feather="more-vertical"></i>
	                                    				</div>
	                                    				<div class="btn btn-datatable btn-icon btn-transparent-dark" onclick="fnDeleteUser('${result.userTy}:${result.uniqId}')">
	                                    					<i data-feather="trash-2"></i>
	                                    				</div>
	                                    			</td>
	                                    		</tr>
	                                    	</c:forEach>
	                                    </tbody>
									</table>
								</div>
							</div>
						</div>
					</form>
				</div>
			</main>
			<footer class="footer mt-auto footer-light">
				<div class="container-fluid">
					<div class="row">
						<div class="col-md-6 small">Copyright &copy; <spring:message code="smart.header.title" /></div>
					</div>
				</div>
			</footer>
		</div>
	</div>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smartscripts.js'/>"></script>
<script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smart/datatables.js'/>"></script>
</body>
</html>