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
<style>
	.addTable {
		border-spacing: 10px;
		border-collapse: separate;
	}
	
	.modal-dialog {
		max-width: 1000px !important;
	}
</style>
<script>
	

	$(document).ready(function() {
		
		var startDate = $("#startDate").val();
		var endDate = $("#endDate").val();
		
		/**
			. 조회 버튼 클릭
			. parameter
			   - startDate
			   - endDate
		*/
		$("#btn_search").click(function() {
			var startDate = $("#startDate").val();
			var endDate = $("#endDate").val();
			
			$.ajax({
				url : "${pageContext.request.contextPath}/smart/business/SmartBusinessData.do",
				data : {"startDate":startDate, "endDate":endDate},
				type : "POST",
				datatype : "json",
				success : function(data) {
					$('#dataTable').dataTable().fnClearTable();
					$('#dataTable').dataTable().fnDestroy();
					
					$.each(data, function(index, value){
						
						var strHtml = "";
						
						if(value.CURRENT_STATUS == "DELAY") {
							strHtml += "	<tr class='bg-orange text-white'>";
						} else if(value.CURRENT_STATUS == "COMPLETE") {
							strHtml += "	<tr class='bg-blue text-white'>";
						} else {
							strHtml += "	<tr>";
						}
						strHtml += "	<td>"+value.MODEL_NO+"</td>";
						strHtml += "	<td>"+value.PRODUCT_NO+"</td>";
						strHtml += "	<td>"+value.PRODUCT_NAME+"</td>";
						strHtml += "	<td>"+value.ORDER_DATE+"</td>";
						strHtml += "	<td>"+value.DUE_DATE+"</td>";
						strHtml += "	<td>";
						strHtml += "		<div class='btn btn-datatable btn-icon btn-transparent-dark mr-2' id='"+value.MODEL_ID+"_detail'>";
						strHtml += "			<i data-feather='edit'></i>";
						strHtml += "		</div>";
						strHtml += "		<div class='btn btn-datatable btn-icon btn-transparent-dark mr-2' id='"+value.MODEL_ID+"_delete' onclick='delData(\""+value.MODEL_ID+"\")'>";
						strHtml += "			<i data-feather='trash-2'></i>";
						strHtml += "		</div>";
						strHtml += "	</td>";
						strHtml += "</tr>";
						$("#data_table_tbody").append(strHtml);
					});	//$.each
					
					$('#dataTable').DataTable();	//jquery dataTable Plugin reload
					feather.replace();	//data-feather reload
				}	//success
			});	//$.ajax
			
		});	//$("#btn_search").click
		
		
		$('#addModalLayer').on('shown.bs.modal', function () {
		   $('#add_modelno').focus();
		});
		

		$('#modifyModalLayer').on('shown.bs.modal', function () {
		   $('#modify_modelno').focus();
		});
	
		/**
			.신규 등록 버튼 클릭
			.parameter
			 - gubun(add), modelno, productno, productname, productgroup,
			   vendor, businessworker, orderdate, duedate, cadworker, assemblyworker
		*/
		$("#btn_save").click(function() {
			
			var gubun = "add";
			var modelno = $("#add_modelno").val();
			var productno = $("#add_productno").val();
			var productname = $("#add_productname").val();
			var productgroup = $("#add_productgroup").val();
			var vendor = $("#add_vendor").val();
			var businessworker = $("#add_businessworker").val();
			var orderdate = $("#add_orderdate").val();
			var duedate = $("#add_duedate").val();
			var cadworker = $("#add_cadworker").val();
			var assemblyworker = $("#add_assemblyworker").val();
			
			if(modelno == "") {
				alert("<spring:message code="smart.business.modelno.valid" />");
				return;
			}
			if(vendor == "") {
				alert("<spring:message code="smart.business.vendor.valid" />");
				return;
			}
			
			$.ajax({
				
				url : "${pageContext.request.contextPath}/smart/business/SmartBusinessSave.do",
				type : "POST",
				data : {"gubun":gubun, "modelno":modelno, "productno":productno, "productname":productname, "productgroup":productgroup, "vendor":vendor, 
					"businessworker":businessworker, "orderdate":orderdate, "duedate":duedate, "cadworker":cadworker, "assemblyworker":assemblyworker},
				datatype : "text",
				success : function(data) {
					if("EXIST" == data) {
						alert("<spring:message code="smart.business.modelno.exist" />");
					} else if(data.indexOf("ERROR") > -1) {
						alert("<spring:message code="smart.common.save.error" /> :: " + data);
					} else {
						$("#add_modelno").val("");
						$("#add_productno").val("");
						$("#add_productname").val("");
						$("#add_productgroup").val("");
						$("#add_vendor").val("");
						$("#add_businessworker").val("");
						$("#add_cadworker").val("");
						$("#add_assemblyworker").val("");
						
						$('#addModalLayer').modal("hide");
						$("#btn_search").trigger("click");
					}
				}
				
			})	//$.ajax
			
			
			
		});	//$("#btn_save")
		
		
		$(document).on("click", "div[id$='_detail']", function() {
			
			var modelid = this.id.replace("_detail", "");

			$.ajax({
				
				url : "${pageContext.request.contextPath}/smart/business/SmartBusinessView.do",
				type : "POST",
				data : {"modelid":modelid},
				datatype : "json",
				success : function(data){
					
					$('#modifyModalLayer').modal("show");
					$("#modify_modelid").val(modelid);
					
					$.each(data, function(index, value){
						
						$("#modify_modelno").val(value.MODEL_NO);
						$("#modify_productno").val(value.PRODUCT_NO);
						$("#modify_productname").val(value.PRODUCT_NAME);
						$("#modify_productgroup").val(value.PRODUCT_GROUP);
						$("#modify_vendor").val(value.VENDOR);
						$("#modify_businessworker").val(value.BUSINESS_WORKER);
						$("#modify_orderdate").val(value.ORDER_DATE);
						$("#modify_duedate").val(value.DUE_DATE);
						$("#modify_enddate").val(value.END_DATE);
						$("#singleDateDivmodify_enddate span").html(value.END_DATE);	
						
						$("#singleDateDivmodify_orderdate span").html(value.ORDER_DATE);
						$("#singleDateDivmodify_duedate span").html(value.DUE_DATE);
						
						if(value.ASSEMBLY_END_DATE == null) {
							$("#btn_enddate").css("display", "none");
							$("#singleDateDivmodify_enddate").css("display", "none");
						} else if(value.END_DATE == null) {
							$("#btn_enddate").css("display", "");
							$("#singleDateDivmodify_enddate").css("display", "none");
						} else {
							$("#btn_enddate").css("display", "none");
							$("#singleDateDivmodify_enddate").css("display", "");
						}
						
						$("#modify_cadworker").val(value.CAD_WORKER);
						$("#modify_assemblyworker").val(value.ASSEMBLY_WORKER);
						
					});	//$.each
					
				}	//success
			});	//$.ajax

			
		});	//_detail click
		
		
		/**
			.수정 버튼 클릭
			.parameter
			 - gubun(update), modelid, modelno, productno, productname, productgroup,
			   vendor, businessworker, orderdate, duedate, enddate, cadworker, assemblyworker
		*/
		$("#btn_modify").click(function() {
			
			var gubun = "update";
			var modelid = $("#modify_modelid").val();
			var modelno = $("#modify_modelno").val();
			var productno = $("#modify_productno").val();
			var productname = $("#modify_productname").val();
			var productgroup = $("#modify_productgroup").val();
			var vendor = $("#modify_vendor").val();
			var businessworker = $("#modify_businessworker").val();
			var orderdate = $("#modify_orderdate").val();
			var duedate = $("#modify_duedate").val();
			var enddate = $("#modify_enddate").val();
			var cadworker = $("#modify_cadworker").val();
			var assemblyworker = $("#modify_assemblyworker").val();
			
			if(modelno == "") {
				alert("<spring:message code="smart.business.modelno.valid" />");
				return;
			}
			if(vendor == "") {
				alert("<spring:message code="smart.business.vendor.valid" />");
				return;
			}
			
			$.ajax({
				
				url : "${pageContext.request.contextPath}/smart/business/SmartBusinessSave.do",
				type : "POST",
				data : {"gubun":gubun, "modelid":modelid, "modelno":modelno, "productno":productno, "productname":productname, "productgroup":productgroup, "vendor":vendor, 
					"businessworker":businessworker, "orderdate":orderdate, "duedate":duedate, "enddate":enddate, "cadworker":cadworker, "assemblyworker":assemblyworker},
				datatype : "text",
				success : function(data) {
					if("EXIST" == data) {
						alert("<spring:message code="smart.business.modelno.exist" />");
					} else if(data.indexOf("ERROR") > -1) {
						alert("<spring:message code="smart.common.save.error" /> :: " + data);
					} else {
						$("#modify_modelno").val("");
						$("#modify_productno").val("");
						$("#modify_productname").val("");
						$("#modify_productgroup").val("");
						$("#modify_vendor").val("");
						$("#modify_businessworker").val("");
						$("#modify_cadworker").val("");
						$("#modify_assemblyworker").val("");
						
						$('#modifyModalLayer').modal("hide");
						$("#btn_search").trigger("click");
					}
				}
				
			})	//$.ajax
			
			
			
		});	//$("#btn_modify")
		
		
		//납품처리 btn_end Click
		$("#btn_enddate").click(function() {
			
			var msg = "<spring:message code="smart.business.end.confirm" />";
			var modelid = $("#modify_modelid").val();
			
			if(confirm(msg)) {
				$.ajax({
					url : "${pageContext.request.contextPath}/smart/business/SmartBusinessEnd.do",
					data : {"modelid":modelid},
					type : "POST",
					datatype : "text",
					success : function(data) {
						if(data.indexOf("ERROR") > -1) {
							alert("<spring:message code="smart.common.save.error" />");
						} else {
							$("#btn_enddate").css("display", "none");
							$("#singleDateDivmodify_enddate").css("display", "");
							$("#singleDateDivmodify_enddate span").html(data);
							$("#modify_enddate").val(data);
							
							$('#modifyModalLayer').modal("hide");
							$("#btn_search").trigger("click");
						}
					}	//success
				});	//$.ajax
			}
			
		});	//$()
		
	});
	

	/**
		. Delete 버튼 클릭
		. parameter
		  - modelid
	*/
	function delData(modelid) {
		
		if(confirm("<spring:message code="smart.common.delete.is" />")) {
			$.ajax({
				url : "${pageContext.request.contextPath}/smart/business/SmartBusinessDelete.do",
				data : {"modelid":modelid},
				type : "POST",
				datatype : "text",
				success : function(data) {
					
					if(data == "OK") {
						alert("<spring:message code="smart.common.delete.ok" />");
						$("#btn_search").trigger("click");
					} else if(data.indexOf("ERROR") > -1) {
						alert("<spring:message code="smart.common.delete.error" /> \n ["+data+"]");
					}
					
				}	//success
			});	//$.ajax
		}	//if(confirm(msg));
		
	}
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
				<header class="page-header page-header-dark bg-gradient-primary-to-secondary mb-4" id="headerTitle">
					<div class="container-fluid">
						<div class="page-header-content pt-4">
							<div class="row align-items-center justify-content-between">
								<div class="col-auto mt-4">
									<h1 class="page-header-title">
										<div class="page-header-icon"><i data-feather="database"></i></div>
										<span><spring:message code="smart.business.title" /></span>
									</h1>
								</div>
							</div>
						</div>
					</div>
				</header>
				<div class="container-fluid" id="dataContainer">
					<div class="btn btn-datatable btn-icon btn-transparent-dark mr-2" id="headerHide"><i data-feather="chevrons-up"></i></div>
					<div class="btn btn-datatable btn-icon btn-transparent-dark mr-2" id="headerView" style="display:none;"><i data-feather="chevrons-down"></i></div>
					<form name="dataForm" method="post">
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
								<div class="btn btn-outline-primary" id="btn_search"><spring:message code="smart.common.button.search" /></div>
								&nbsp;
								<div class="btn btn-outline-primary" id="btn_add" data-toggle="modal" data-target="#addModalLayer"><spring:message code="smart.common.button.add" /></div>
<%-- 								<div class="btn btn-outline-primary" id="btn_add"><spring:message code="smart.common.button.add" /></div> --%>
								<!-- Modal -->
								<div class="modal fade" id="addModalLayer" tabindex="-1" role="dialog" aria-labelledby="addModalLayerTitle" aria-hidden="true">
								    <div class="modal-dialog modal-dialog-centered" role="document">
								        <div class="modal-content">
								            <div class="modal-header">
								                <h5 class="modal-title" id="addModalLayerTitle"><spring:message code="smart.business.insert.title" /></h5>
								                <button class="close" type="button" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
								            </div>
								            <div class="modal-body">
								                <table class="addTable">
								                	<tr>
								                		<td><spring:message code="smart.business.modelno" /></td>
								                		<td><input class="form-control" id="add_modelno" name="add_modelno"></td>
										    			<td><spring:message code="smart.business.productno" /></td>
										    			<td><input class="form-control" id="add_productno" name="add_productno"></td>
										    			<td><spring:message code="smart.business.productname" /></td>
										    			<td><input class="form-control" id="add_productname" name="add_productname"></td>
								                	</tr>
								                	<tr>
								                		<td><spring:message code="smart.business.productgroup" /></td>
										    			<td><input class="form-control" id="add_productgroup" name="add_productgroup"></td>
										    			<td><spring:message code="smart.business.vendor" /></td>
										    			<td>
										    				<div class="form-group" style="margin-bottom: 0px;">
										    					<select class="form-control form-control-solid" id="add_vendor" name="add_vendor">
										    						<option value=""> -- Select -- </option>
									    							<c:forEach var="resultBasic" items="${resultBasic }" varStatus="status">
									    								<c:if test="${resultBasic.KEY == 'VENDOR'}">
									    									<option value="${resultBasic.VALUE }">${resultBasic.VALUE }</option>
									    								</c:if>
									    							</c:forEach>
									    						</select>
									    					</div>	
										    			</td>
										    			<td><spring:message code="smart.business.businessworker" /></td>
										    			<td>
										    				<div class="form-group" style="margin-bottom: 0px;">
										    					<select class="form-control form-control-solid" id="add_businessworker" name="add_businessworker">
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
								                		<td><spring:message code="smart.business.orderdate" /></td>
									    				<td>
									    					<div class="btn btn-light btn-sm line-height-normal p-2 singleDatePicker" id="singleDateDivadd_orderdate">
															    <i class="mr-2 text-primary" data-feather="calendar"></i>
															    <span></span>
															    <input type="hidden" name="add_orderdate" id="add_orderdate">
															    <i class="ml-1" data-feather="chevron-down"></i>
															</div>
									    				</td>
									    				<td><spring:message code="smart.business.duedate" /></td>
									    				<td>
									    					<div class="btn btn-light btn-sm line-height-normal p-2 singleDatePicker" id="singleDateDivadd_duedate">
															    <i class="mr-2 text-primary" data-feather="calendar"></i>
															    <span></span>
															    <input type="hidden" name="add_duedate" id="add_duedate">
															    <i class="ml-1" data-feather="chevron-down"></i>
															</div>
									    				</td>
									    				<td><spring:message code="smart.business.enddate" /></td>
									    				<td>
<%-- 									    					<div class="btn btn-outline-teal btn-sm" id="btn_enddate"><spring:message code="smart.business.end" /></div> --%>
<!-- 									    					<div class="btn btn-light btn-sm line-height-normal p-2 singleDatePicker" id="singleDateDivadd_enddate"> -->
<!-- 															    <i class="mr-2 text-primary" data-feather="calendar"></i> -->
<%-- 															    <span></span> --%>
<!-- 															    <input type="hidden" name="add_enddate" id="add_enddate"> -->
<!-- 															    <i class="ml-1" data-feather="chevron-down"></i> -->
<!-- 															</div> -->
									    				</td>
								                	</tr>
								                	<tr>
								                		<td><spring:message code="smart.business.cadworker" /></td>
									    				<td>
									    					<div class="form-group" style="margin-bottom: 0px;">
										    					<select class="form-control form-control-solid" id="add_cadworker" name="add_cadworker">
										    						<option value=""> -- Select -- </option>
									    							<c:forEach var="resultUser" items="${resultUser }" varStatus="status">
									    								<c:if test="${resultUser.AUTHOR_CODE == 'ROLE_USER_CAD'}">
									    									<option value="${resultUser.USER_ID }">${resultUser.USER_NM }</option>
									    								</c:if>
									    							</c:forEach>
									    						</select>
									    					</div>	
									    				</td>
									    				<td><spring:message code="smart.business.assemblyworker" /></td>
									    				<td>
									    					<div class="form-group" style="margin-bottom: 0px;">
										    					<select class="form-control form-control-solid" id="add_assemblyworker" name="add_assemblyworker">
										    						<option value=""> -- Select -- </option>
									    							<c:forEach var="resultUser" items="${resultUser }" varStatus="status">
									    								<c:if test="${resultUser.AUTHOR_CODE == 'ROLE_USER_ASSEMBLY'}">
									    									<option value="${resultUser.USER_ID }">${resultUser.USER_NM }</option>
									    								</c:if>
									    							</c:forEach>
									    						</select>
									    					</div>	
									    				</td>
								                	</tr>
								                </table>
								            </div>
								            <div class="modal-footer">
								            	<div class="btn btn-secondary" data-dismiss="modal">닫기</div>
								            	<div class="btn btn-primary" id="btn_save">저장</div>
								            </div>
								        </div>
								    </div>
								</div>
								<!-- Modal -->
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
	                                    <tbody id="data_table_tbody">
	                                    	<tr>
												<td></td>
												<td></td>
												<td></td>
												<td></td>
												<td></td>
												<td></td>
											</tr>
	                                    </tbody>
									</table>
									
									<!-- Modal -->
									<div class="modal fade" id="modifyModalLayer" tabindex="-1" role="dialog" aria-labelledby="modifyModalLayerTitle" aria-hidden="true">
									    <div class="modal-dialog modal-dialog-centered" role="document">
									        <div class="modal-content">
									            <div class="modal-header">
									                <h5 class="modal-title" id="modifytModalLayerTitle"><spring:message code="smart.business.update.title" /></h5>
									                <button class="close" type="button" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
									            </div>
									            <div class="modal-body">
									            	<input type="hidden" id="modify_modelid" name="modify_modelid">
									                <table class="addTable">
									                	<tr>
									                		<td><spring:message code="smart.business.modelno" /></td>
									                		<td><input class="form-control" id="modify_modelno" name="modify_modelno"></td>
											    			<td><spring:message code="smart.business.productno" /></td>
											    			<td><input class="form-control" id="modify_productno" name="modify_productno"></td>
											    			<td><spring:message code="smart.business.productname" /></td>
											    			<td><input class="form-control" id="modify_productname" name="modify_productname"></td>
									                	</tr>
									                	<tr>
									                		<td><spring:message code="smart.business.productgroup" /></td>
											    			<td><input class="form-control" id="modify_productgroup" name="modify_productgroup"></td>
											    			<td><spring:message code="smart.business.vendor" /></td>
											    			<td>
											    				<div class="form-group" style="margin-bottom: 0px;">
											    					<select class="form-control form-control-solid" id="modify_vendor" name="modify_vendor">
											    						<option value=""> -- Select -- </option>
										    							<c:forEach var="resultBasic" items="${resultBasic }" varStatus="status">
										    								<c:if test="${resultBasic.KEY == 'VENDOR'}">
										    									<option value="${resultBasic.VALUE }">${resultBasic.VALUE }</option>
										    								</c:if>
										    							</c:forEach>
										    						</select>
										    					</div>	
											    			</td>
											    			<td><spring:message code="smart.business.businessworker" /></td>
											    			<td>
											    				<div class="form-group" style="margin-bottom: 0px;">
											    					<select class="form-control form-control-solid" id="modify_businessworker" name="modify_businessworker">
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
									                		<td><spring:message code="smart.business.orderdate" /></td>
										    				<td>
										    					<div class="btn btn-light btn-sm line-height-normal p-2 singleDatePicker" id="singleDateDivmodify_orderdate">
																    <i class="mr-2 text-primary" data-feather="calendar"></i>
																    <span></span>
																    <input type="hidden" name="modify_orderdate" id="modify_orderdate">
																    <i class="ml-1" data-feather="chevron-down"></i>
																</div>
										    				</td>
										    				<td><spring:message code="smart.business.duedate" /></td>
										    				<td>
										    					<div class="btn btn-light btn-sm line-height-normal p-2 singleDatePicker" id="singleDateDivmodify_duedate">
																    <i class="mr-2 text-primary" data-feather="calendar"></i>
																    <span></span>
																    <input type="hidden" name="modify_duedate" id="modify_duedate">
																    <i class="ml-1" data-feather="chevron-down"></i>
																</div>
										    				</td>
										    				<td><spring:message code="smart.business.enddate" /></td>
										    				<td>
										    					<div class="btn btn-outline-teal btn-sm" id="btn_enddate"><spring:message code="smart.business.end" /></div>
										    					<div class="btn btn-light btn-sm line-height-normal p-2 singleDatePicker" id="singleDateDivmodify_enddate">
																    <i class="mr-2 text-primary" data-feather="calendar"></i>
																    <span></span>
																    <input type="hidden" name="modify_enddate" id="modify_enddate">
																    <i class="ml-1" data-feather="chevron-down"></i>
																</div>
										    				</td>
									                	</tr>
									                	<tr>
									                		<td><spring:message code="smart.business.cadworker" /></td>
										    				<td>
										    					<div class="form-group" style="margin-bottom: 0px;">
											    					<select class="form-control form-control-solid" id="modify_cadworker" name="modify_cadworker">
											    						<option value=""> -- Select -- </option>
										    							<c:forEach var="resultUser" items="${resultUser }" varStatus="status">
										    								<c:if test="${resultUser.AUTHOR_CODE == 'ROLE_USER_CAD'}">
										    									<option value="${resultUser.USER_ID }">${resultUser.USER_NM }</option>
										    								</c:if>
										    							</c:forEach>
										    						</select>
										    					</div>	
										    				</td>
										    				<td><spring:message code="smart.business.assemblyworker" /></td>
										    				<td>
										    					<div class="form-group" style="margin-bottom: 0px;">
											    					<select class="form-control form-control-solid" id="modify_assemblyworker" name="modify_assemblyworker">
											    						<option value=""> -- Select -- </option>
										    							<c:forEach var="resultUser" items="${resultUser }" varStatus="status">
										    								<c:if test="${resultUser.AUTHOR_CODE == 'ROLE_USER_ASSEMBLY'}">
										    									<option value="${resultUser.USER_ID }">${resultUser.USER_NM }</option>
										    								</c:if>
										    							</c:forEach>
										    						</select>
										    					</div>	
										    				</td>
									                	</tr>
									                </table>
									            </div>
									            <div class="modal-footer">
									            	<div class="btn btn-secondary" data-dismiss="modal">닫기</div>
									            	<div class="btn btn-primary" id="btn_modify">저장</div>
									            </div>
									        </div>
									    </div>
									</div>
									<!-- Modal -->
								</div>
							</div>
						</div>
					</form>
				</div>
			</main>
			<footer class="footer mt-auto footer-light">
				<div class="container-fluid">
					<div class="row">
						<c:import url="/EgovPageLink.do?link=main/nav/SmartFooter" />
					</div>
				</div>
			</footer>
		</div>
	</div>
	
<iframe name="dataFrame" width="0" height="0" style="visibility:hidden"></iframe>
	
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smartscripts.js'/>"></script>
<script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/components/prism-core.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/plugins/autoloader/prism-autoloader.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smart/date-range-picker.js'/>"></script>

<script>
	$(document).ready(function() {
		$("#btn_search").trigger("click");
	})
</script>

</body>
</html>