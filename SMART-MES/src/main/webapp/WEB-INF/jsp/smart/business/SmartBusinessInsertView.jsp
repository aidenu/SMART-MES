<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Language" content="ko" >
<title><spring:message code="smart.business.insert.title" /></title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" crossorigin="anonymous" />
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>
<style>
	#dataTable > td {
		height: 60px !important;
	}
</style>
<script>

	$(document).ready(function() {
		
		//Close Button
		$("#btn_close").click(function() {
			self.close();
		});
		
		//Add Button
		$("#btn_add").click(function() {
			
		});
		
	});
	
</script>
</head>
<body class="nav-fixed">

	<form name="dataForm" method="post" >
		<div class="card card-header-actions">
		    <div class="card-header">
		    	Add Model
		    	<div>
			    	<div class="btn btn-primary btn-sm" id="btn_add">Add</div>
			    	&nbsp;
			    	<div class="btn btn-primary btn-sm" id="btn_close">Close</div>
		    	</div>
		    </div>
		    <div class="card-body">
		    	<table class="table table-bordered table-hover" id="dataTable" width="100%" cellspacing="0">
		    		<tbody>
		    			<tr>
			    			<td class="card-header"><spring:message code="smart.business.modelno" /></td>
			    			<td>	<input class="form-control" id="modelno" name="modelno" placeholder="<spring:message code="smart.business.modelno" />"></td>
			    			<td class="card-header"><spring:message code="smart.business.productno" /></td>
			    			<td><input class="form-control" id="productno" name="productno" placeholder="<spring:message code="smart.business.productno" />"></td>
			    			<td class="card-header"><spring:message code="smart.business.productname" /></td>
			    			<td><input class="form-control" id="productname" name="productname" placeholder="<spring:message code="smart.business.productname" />"></td>
			    		</tr>
			    		<tr>
			    			<td class="card-header"><spring:message code="smart.business.productgroup" /></td>
			    			<td><input class="form-control" id="productgroup" name="productgroup" placeholder="<spring:message code="smart.business.productgroup" />"></td>
			    			<td class="card-header"><spring:message code="smart.business.vendor" /></td>
			    			<td>
			    				<div class="form-group" style="margin-bottom: 0px;">
			    					<select class="form-control form-control-solid" id="vendor" name="vendor">
			    						<option value=""> -- Select -- </option>
		    							<c:forEach var="resultBasic" items="${resultBasic }" varStatus="status">
		    								<c:if test="${resultBasic.KEY == 'VENDOR'}">
		    									<option value="${resultBasic.VALUE }">${resultBasic.VALUE }</option>
		    								</c:if>
		    							</c:forEach>
		    						</select>
		    					</div>	
			    			</td>
			    			<td class="card-header"><spring:message code="smart.business.businessworker" /></td>
			    			<td>
			    				<div class="form-group" style="margin-bottom: 0px;">
			    					<select class="form-control form-control-solid" id="businessworker" name="businessworker">
			    						<option value=""> -- Select -- </option>
		    							<c:forEach var="resultUser" items="${resultUser }" varStatus="status">
		    								<c:if test="${resultUser.AUTHOR_CODE == 'ROLE_USER_SYSOP' || resultUser.AUTHOR_CODE == 'ROLE_USER_BUSINESS'}">
		    									<option value="${resultUser.USER_ID }" <c:if test="${resultUser.USER_ID == userid }">selected</c:if>>${resultUser.USER_NM }</option>
		    								</c:if>
		    							</c:forEach>
		    						</select>
		    					</div>	
			    			</td>
			    		</tr>
			    		<tr>
							<td class="card-header"><spring:message code="smart.business.orderdate" /></td>
		    				<td>
		    					<div class="btn btn-light btn-sm line-height-normal p-2 singleDatePicker" id="singleDateDivorderdate">
								    <i class="mr-2 text-primary" data-feather="calendar"></i>
								    <span></span>
								    <input type="hidden" name="orderdate" id="orderdate">
								    <i class="ml-1" data-feather="chevron-down"></i>
								</div>
		    				</td>
		    				<td class="card-header"><spring:message code="smart.business.duedate" /></td>
		    				<td>
		    					<div class="btn btn-light btn-sm line-height-normal p-2 singleDatePicker" id="singleDateDivduedate">
								    <i class="mr-2 text-primary" data-feather="calendar"></i>
								    <span></span>
								    <input type="hidden" name="duedate" id="duedate">
								    <i class="ml-1" data-feather="chevron-down"></i>
								</div>
		    				</td>
			    		</tr>
			    		<tr>
			    			<td class="card-header"><spring:message code="smart.business.cadworker" /></td>
		    				<td>
		    					<div class="form-group" style="margin-bottom: 0px;">
			    					<select class="form-control form-control-solid" id="cadworker" name="cadworker">
			    						<option value=""> -- Select -- </option>
		    							<c:forEach var="resultUser" items="${resultUser }" varStatus="status">
		    								<c:if test="${resultUser.AUTHOR_CODE == 'ROLE_USER_CAD'}">
		    									<option value="${resultUser.USER_ID }" <c:if test="${resultUser.USER_ID == userid }">selected</c:if>>${resultUser.USER_NM }</option>
		    								</c:if>
		    							</c:forEach>
		    						</select>
		    					</div>	
		    				</td>
		    				<td class="card-header"><spring:message code="smart.business.assemblyworker" /></td>
		    				<td>
		    					<div class="form-group" style="margin-bottom: 0px;">
			    					<select class="form-control form-control-solid" id="assemblyworker" name="assemblyworker">
			    						<option value=""> -- Select -- </option>
		    							<c:forEach var="resultUser" items="${resultUser }" varStatus="status">
		    								<c:if test="${resultUser.AUTHOR_CODE == 'ROLE_USER_CAD'}">
		    									<option value="${resultUser.USER_ID }" <c:if test="${resultUser.USER_ID == userid }">selected</c:if>>${resultUser.USER_NM }</option>
		    								</c:if>
		    							</c:forEach>
		    						</select>
		    					</div>	
		    				</td>
			    		</tr>
		    		</tbody>
		    	</table>
		    </div>
		</div>
	</form>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smartscripts.js'/>"></script>
<script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js" crossorigin="anonymous"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
<script src="<c:url value='/js/smart/date-range-picker.js'/>"></script>
</body>
</html>