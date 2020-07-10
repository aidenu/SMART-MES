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
<title><spring:message code="smart.common.alarm.title" /></title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>

<script type="text/javaScript" language="javascript" defer="defer">
	
	

</script>

</head>
<body class="nav-fixed">
	<div class="card card-header-actions">
		<div class="card-header">
			<div class="page-header-icon">
				<i data-feather="bell"></i>
				<spring:message code="smart.common.alarm.title" />
			</div>
			<div class="btn btn-primary btn-sm" onclick="self.close();"><spring:message code="button.close" /></div>
		</div>
		<div class="card-body">
			<div class="datatable table-responsive">
				<table class="table table-bordered table-hover" id="dataTable" width="100%" cellspacing="0">
					<thead>
						<tr>
							<th><spring:message code="smart.common.alarm.sendtime" /></th>
							<th><spring:message code="smart.common.alarm.eventtime" /></th>
							<th><spring:message code="smart.common.alarm.eqpname" /></th>
							<th><spring:message code="smart.common.alarm.desc" /></th>
						</tr>
					</thead>
					<tfoot>
						<tr>
							<th><spring:message code="smart.common.alarm.sendtime" /></th>
							<th><spring:message code="smart.common.alarm.eventtime" /></th>
							<th><spring:message code="smart.common.alarm.eqpname" /></th>
							<th><spring:message code="smart.common.alarm.desc" /></th>
						</tr>
	                      </tfoot>
	                      <tbody>
	                      	<c:forEach var="resultAlarm" items="${resultAlarm}" varStatus="status">
	                      		<tr>
	                      			<td><c:out value="${resultAlarm.ALARM_SEND_TIME}"/></td>
	                      			<td><c:out value="${resutAlarm.EVENT_TIME}"/></td>
	                      			<td><c:out value="${resultAlarm.EQP_NAME}"/></td>
	                      			<td><c:out value="${resultAlarm.ALARM_DESC}"/></td>
	                      		</tr>
	                      	</c:forEach>
	                      </tbody>
				</table>
			</div>
		</div>
	</div>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smartscripts.js'/>"></script>
<script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/assets/demo/datatables-demo.js'/>"></script>
</body>
</html>

