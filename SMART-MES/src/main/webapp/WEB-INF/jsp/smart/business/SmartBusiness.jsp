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
<title><spring:message code="smart.business.title" /></title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<link href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" rel="stylesheet" crossorigin="anonymous" />
<link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>
<script>
	

	$(document).ready(function() {
		var startDate = $("#startDate").val();
		var endDate = $("#endDate").val();
		
		$.ajax({
			url : "${pageContext.request.contextPath}/smart/business/SmartBusinessData.do",
			data : {"startDate" : startDate, "endDate" : endDate},
			method : "POST",
			success : function(data) {
				console.log("STEP2 Success");
			}
		});
		
		$("#btn_search").click(function() {
			var startDate = $("#startDate").val();
			var endDate = $("#endDate").val();
			
			$.ajax({
				url : "${pageContext.request.contextPath}/smart/business/SmartBusinessData.do",
				data : {"startDate" : startDate, "endDate" : endDate},
				method : "POST",
				success : function(data) {
					console.log("STEP2 Success");
				}
			});
			
		});
		
	});
	
	
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
				<div class="page-header pb-10 page-header-dark bg-gradient-primary-to-secondary">
					<div class="container-fluid">
						<div class="page-header-content">
							<h1 class="page-header-title">
								<div class="page-header-icon"><i data-feather="database"></i></div>
									<span><spring:message code="smart.business.title" /></span>
							</h1>
						</div>
					</div>
				</div>
				<div class="container-fluid mt-n10">
					<form name="listForm" method="post">
						<div class="card mb-4">
							<div class="card-header">
								<div class="btn btn-light btn-sm line-height-normal p-3" id="dateRange">
								    <i class="mr-2 text-primary" data-feather="calendar"></i>
								    <span></span>
								    <input type="hidden" name="startDate" id="startDate">
								    <input type="hidden" name="endDate" id="endDate">
								    <i class="ml-1" data-feather="chevron-down"></i>
								</div>
								&nbsp;
								<div class="btn btn-outline-primary" id="btn_search">조회</div>
								&nbsp;
								<div class="btn btn-outline-primary" onclick="btn_add">Add</div>
							</div>
							<div class="card-body">
								<div class="datatable table-responsive">
									<table class="table table-bordered table-hover" id="dataTable" width="100%" cellspacing="0">
										<thead>
											<tr>
												<th><spring:message code="smart.business.modelno" /></th>
												<th><spring:message code="smart.business.productno" /></th>
												<th><spring:message code="smart.business.productname" /></th>
												<th><spring:message code="smart.business.orderdate" /></th>
												<th><spring:message code="smart.business.duedate" /></th>
												<th>Detail</th>
											</tr>
										</thead>
										<tfoot>
											<tr>
												<th><spring:message code="smart.business.modelno" /></th>
												<th><spring:message code="smart.business.productno" /></th>
												<th><spring:message code="smart.business.productname" /></th>
												<th><spring:message code="smart.business.orderdate" /></th>
												<th><spring:message code="smart.business.duedate" /></th>
												<th>Detail</th>
											</tr>
	                                    </tfoot>
	                                    <tbody>
	                                    	<c:forEach var="result" items="${resultList}" varStatus="status">
	                                    		<tr>
	                                    			<td><c:out value="${result.MODEL_NO}"/></td>
	                                    			<td><c:out value="${result.PRODUCT_NO}"/></td>
	                                    			<td><c:out value="${result.PRODUCT_NAME}"/></td>
	                                    			<td><c:out value="${result.ORDER_DATE}"/></td>
	                                    			<td><c:out value="${result.DUE_DATE}"/></td>
	                                    			<td>
	                                    				<div class="btn btn-datatable btn-icon btn-transparent-dark mr-2" id="${result.MODEL_ID }_detail">
	                                    					<i data-feather="edit"></i>
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
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smartscripts.js'/>"></script>
<script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/components/prism-core.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/plugins/autoloader/prism-autoloader.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smart/date-range-picker.js'/>"></script>
<script src="<c:url value='/js/smart/datatables.js'/>"></script>
</body>
</html>