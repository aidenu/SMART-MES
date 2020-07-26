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

<script>
	
	
	$(document).ready(function() {
		
		
		/**
			. Close Button Click
		*/
		$("#btn_close").click(function() {
			self.close();
		});
		
	});
	
	
</script>
</head>
<body class="nav-fixed">

		
		<form name="dataForm" method="post" >
			<input type="hidden" name="modelid" id="modelid" value="${modelid }">
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