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
<title><spring:message code="smart.cad.partlist.title" /></title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<link href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" rel="stylesheet" crossorigin="anonymous" />
<link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
<link rel="stylesheet" href="<c:url value='/css/smart/frappe-gantt.css'/>" />
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smart/frappe-gantt.js'/>"></script>
<style>
	
	#addScheduleLayer {
		display: none;
		position: absolute;
		top: 50%;
		left: 30%;
		width: 500px;
	}
	
</style>
<script>
	
	
	$(document).ready(function() {
		
		
		/**
			. Close Button Click
		*/
		$("#btn_close").click(function() {
			self.close();
		});
		
		
		/**
			. Add Button Click
			. 일정 추가 Layer view
		*/
		$("#btn_add").click(function() {
			$("#addScheduleLayer").show();
			$("#addScheduleName").focus();
		});
		
		/**
			. Layer Close Button Click
			. 일정 Layer hidden
		*/
		$("#addScheduleLayerClose").click(function() {
			
			$("#addScheduleName").val('');
			$("#dependSchedule").val('');
			
			var date = new Date();
			var today = "";
			if(date.getMonth() < 10) {
				today = date.getFullYear() + "-" + "0" + (date.getMonth()+1) + "-" + date.getDate();
			} else {
				today = date.getFullYear() + "-" + (date.getMonth()+1) + "-" + date.getDate();
			}
			$("#singleDateDivstartdate span").html(today);
			$("#startdate").val(today);
			
			$("#singleDateDivenddate span").html(today);
			$("#enddate").val(today);
			
			$("#addScheduleLayer").hide();
		});
		
		/**
			. Layer Insert Button Click
			. 일정 추가 
			. Parameter
			   : modelid, scheduleName, dependSchedule, startdate, enddate
		*/
		$("#addScheduleLayerInsert").click(function() {
			
			var modelid = $("#modelid").val();
			var modelno = $("#modelno").val();
			var scheduleName = $("#addScheduleName").val();
			var dependSchedule = $("#dependSchedule").val();
			var startdate = $("#startdate").val();
			var enddate = $("#enddate").val();
			if(startdate.replace(/-/gi, "") > enddate.replace(/-/gi, "")) {
				alert("<spring:message code="smart.common.date.validation.startend" />");
			}
			
			$.ajax({
				
				url : "${pageContext.request.contextPath}/smart/process/SmartScheduleView.do",
				type : "POST",
				data : {"modelid":modelid, "scheduleName":scheduleName, "dependSchedule":dependSchedule,
						"startdate":startdate, "enddate":enddate},
				datatype : "text",
				success : function(data) {
					if(data == "OK") {
						alert("<spring:message code="smart.common.save.ok" />");
						
						$("#addScheduleLayerClose").click();
						
						$.ajax({
							
							url : "${pageContext.request.contextPath}/smart/process/SmartScheduleViewData.do",
							type : "POST",
							data : {"modelid":modelid},
							datatype : "json",
							success : function(data) {
								
							}
							
						});
						
					} else if(data.indexOf("ERROR") > -1) {
						alert("<spring:message code="smart.common.save.error" /> \n " + data);
					}
				}
				
			});
			
		});
		
		
	});
	
	
</script>
</head>
<body class="nav-fixed">

		
		<form name="dataForm" method="post" >
			<input type="hidden" name="modelid" id="modelid" value="${modelid }">
			<input type="hidden" name="modelno" id="modelid" value="${modelno }">
			<div class="card mb-4">
				<div class="card card-header-actions">
					 <div class="card-header">
				    	${modelno } <spring:message code="smart.process.schedule.title" />
				    	<div>
				    		<div class="btn btn-primary btn-sm" id="btn_add"><spring:message code="smart.common.button.insert" /></div>
					    	&nbsp;
					    	<div class="btn btn-primary btn-sm" id="btn_close"><spring:message code="smart.common.button.close" /></div>
				    	</div>
				    </div>
				    
				    <div class="card-body">
						<div class="datatable table-responsive">
							<div class="gantt-target"></div>
					    </div>
					    <script>
							var tasks = [
								<c:forEach var="result" items="${result}" varStatus="status">
									
									<c:choose>
										<c:when test="${status.last}">
											{
												start:"${result.START_DATE}",
												end: "${result.END_DATE}",
												name: "${result.TASK_NAME}",
												id: "${result.TASK_ID}",
												<c:if test="${not empty result.DEPEND_TASK}">
													dependencies: "${result.DEPEND_TASK}",
												</c:if>
												progress: "${result.PROGRESS_RATE}"
											}
										</c:when>
										<c:otherwise>
											{
												start:"${result.START_DATE}",
												end: "${result.END_DATE}",
												name: "${result.TASK_NAME}",
												id: "${result.TASK_ID}",
												<c:if test="${not empty result.DEPEND_TASK}">
													dependencies: "${result.DEPEND_TASK}",
												</c:if>
												progress: "${result.PROGRESS_RATE}"
											},
										</c:otherwise>
									</c:choose>
									
								</c:forEach>
							]
							var gantt_chart = new Gantt(".gantt-target", tasks, {
								on_click: function (task) {
									console.log(task.name);
								},
								on_date_change: function(task, start, end) {
									console.log(start, end);
								},
								on_progress_change: function(task, progress) {
									console.log(task, progress);
								},
								on_view_change: function(mode) {
									console.log(mode);
								},
								view_mode: 'Day',
								language: 'kr'
							});
							console.log(gantt_chart);
						</script>
				    </div>
			    	
			    	<!-- Schedule Add layer-->
					<div class="col-lg-6" id="addScheduleLayer">
						<div class="card bg-dark text-center pricing-detailed-behind">
							<div class="card-header justify-content-center py-4">
								<h5 class="mb-0 text-white"><spring:message code="smart.process.schedule.add.layer.title" /></h5>
							</div>
							<div class="card-body text-white-50 p-5">
								<input class="form-control" id="addScheduleName" name="addScheduleName" placeholder="<spring:message code="smart.process.schedule.name" />">
								<br>
								<div class="btn btn-light btn-sm line-height-normal p-2 singleDatePicker" id="singleDateDivstartdate">
								    <i class="mr-2 text-primary" data-feather="calendar"></i>
								    <span></span>
								    <input type="hidden" name="startdate" id="startdate">
								    <i class="ml-1" data-feather="chevron-down"></i>
								</div>
								~
								<div class="btn btn-light btn-sm line-height-normal p-2 singleDatePicker" id="singleDateDivenddate">
								    <i class="mr-2 text-primary" data-feather="calendar"></i>
								    <span></span>
								    <input type="hidden" name="enddate" id="enddate">
								    <i class="ml-1" data-feather="chevron-down"></i>
								</div>
								<br><br>
								<div class="form-group" style="margin-bottom: 0px;">
			    					<select class="form-control form-control-solid" id="dependSchedule" name="dependSchedule">
			    						<option value=""> -- Select -- </option>
		    							<c:forEach var="result" items="${result }" varStatus="status">
		    								<c:if test="${result.TASK_ID != '0' }">
		    									<option value="${result.TASK_ID }">${result.TASK_NAME }</option>
		    								</c:if>
		    							</c:forEach>
		    						</select>
		    					</div>
							</div>
							<div class="card-footer bg-gray-800 text-white d-flex align-items-center justify-content-center">
								<div class="btn btn-outline-light" id="addScheduleLayerInsert"><spring:message code="smart.common.button.add" /></div>
								&nbsp;&nbsp;
								<div class="btn btn-outline-light" id="addScheduleLayerClose"><spring:message code="smart.common.button.close" /></div>
							</div>
						</div>
					</div>
					
			    </div>
			</div>
            
		</form>
		   
		    
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smartscripts.js'/>"></script>
<script src="<c:url value='/js/smart/datatables.js'/>"></script>
<script src="<c:url value='/js/smart/smartvalidate.js'/>"></script>
<script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/components/prism-core.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/plugins/autoloader/prism-autoloader.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smart/date-range-picker.js'/>"></script>

<iframe name="hiddenFrame" width="0" height="0" style="visibility:hidden"></iframe>
</body>
</html>