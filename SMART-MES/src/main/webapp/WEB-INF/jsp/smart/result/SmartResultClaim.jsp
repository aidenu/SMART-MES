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
<title><spring:message code="smart.result.claim.title" /></title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<link href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" rel="stylesheet" crossorigin="anonymous" />
<link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>
<script>

	$(document).ready(function() {
		
		/**
			. 조회 버튼 클릭
			. parameter none
		*/
		$("#btn_search").click(function() {
			
			var startDate = $("#startDate").val();
			var endDate = $("#endDate").val();
			var totalModifyCnt = 0;
			var totalModifyPrice = 0;
			
			$.ajax({
				url : "${pageContext.request.contextPath}/smart/result/SmartResultClaimData.do",
				data : {"startDate":startDate, "endDate":endDate},
				type : "POST",
				datatype : "json",
				success : function(data) {
					
					$('#dataTable').dataTable().fnClearTable();
					$('#dataTable').dataTable().fnDestroy();
					
					var strHtml = "";
					
					$.each(data, function(index, value){
						
						strHtml += "<tr>";
						strHtml += "		<td>"+value.MODEL_NO+"</td>";
						strHtml += "		<td>"+value.PART_GROUP_NO+"</td>";
						strHtml += "		<td>"+value.PART_GROUP_NAME+"</td>";
						strHtml += "		<td>"+value.WORK_NAME+"</td>";
						strHtml += "		<td>"+value.USER_NM+"</td>";
						strHtml += "		<td>"+value.WORK_END_DATE+"</td>";
						strHtml += "		<td>"+value.MODIFY_PRICE+"</td>";
						strHtml += "</tr>";
						
						totalModifyCnt++;
						totalModifyPrice = Number(totalModifyPrice) + Number(value.MODIFY_PRICE_NUM);
						
					});
					
					$("#data_table_tbody").append(strHtml);
					$('#dataTable').DataTable();	//jquery dataTable Plugin reload
					feather.replace();	//data-feather reload
					
					$("#totalModify").empty();
					$("#totalModify").append(totalModifyCnt+"건, "+totalModifyPrice.toLocaleString()+"원");
					
					
				}	//success
			});	//$.ajax
			
		});	//$("#btn_search").click
		
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
				<header class="page-header page-header-dark bg-gradient-primary-to-secondary mb-4" id="headerTitle">
					<div class="container-fluid">
						<div class="page-header-content pt-4">
							<div class="row align-items-center justify-content-between">
								<div class="col-auto mt-4">
									<h1 class="page-header-title">
										<div class="page-header-icon"><i data-feather="database"></i></div>
										<span><spring:message code="smart.result.claim.title" /></span>
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
							<div class="card card-header-actions">
								<div class="card-header">
									<div>
										<div class="btn btn-light btn-sm line-height-normal p-3" id="dateRange">
										    <i class="mr-2 text-primary" data-feather="calendar"></i>
										    <span></span>
										    <input type="hidden" name="startDate" id="startDate">
										    <input type="hidden" name="endDate" id="endDate">
										    <i class="ml-1" data-feather="chevron-down"></i>
										</div>
										&nbsp;
										<div class="btn btn-outline-primary" id="btn_search"><spring:message code="smart.common.button.search" /></div>
									</div>
									&nbsp;
									<div>
										Total :
										<span id="totalModify"></span>
									</div>
								</div>
								<div class="card-body">
									<div class="datatable table-responsive">
										<table class="table table-bordered table-hover" id="dataTable" width="100%" cellspacing="0">
											<colgroup>
												<col width="20%">
												<col width="20%">
												<col width="20%">
												<col width="10%">
												<col width="10%">
												<col width="10%">
												<col width="10%">
											</colgroup>
											<thead>
												<tr>
													<th scope="col"><spring:message code="smart.business.modelno" /></th>
													<th scope="col"><spring:message code="smart.cad.partlist.partgroupno" /></th>
													<th scope="col"><spring:message code="smart.cad.partlist.partgroupname" /></th>
													<th scope="col">공정</th>
													<th scope="col">작업자</th>
													<th scope="col">작업일시</th>
													<th scope="col">수/개조 비용</th>
												</tr>
											</thead>
											<tfoot>
												<tr>
													<th scope="col"><spring:message code="smart.business.modelno" /></th>
													<th scope="col"><spring:message code="smart.cad.partlist.partgroupno" /></th>
													<th scope="col"><spring:message code="smart.cad.partlist.partgroupname" /></th>
													<th scope="col">공정</th>
													<th scope="col">작업자</th>
													<th scope="col">작업일시</th>
													<th scope="col">수/개조 비용</th>
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
													<td></td>
												</tr>
		                                    </tbody>
										</table>
									</div>
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
<script src="<c:url value='/js/smart/datatables.js'/>"></script>
<script src="<c:url value='/js/smartscripts.js'/>"></script>
<script src="<c:url value='/js/smart/smartvalidate.js'/>"></script>
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
	});
</script>

</body>
</html>