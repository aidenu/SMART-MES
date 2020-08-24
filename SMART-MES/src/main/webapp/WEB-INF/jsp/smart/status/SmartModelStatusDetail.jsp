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
<title><spring:message code="smart.status.part.title" /></title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<link href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" rel="stylesheet" crossorigin="anonymous" />
<link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>

<style>
	th, td {
		text-align: center;
	}
	
	.procbox {
		width: 130px;
		float: left;
		margin: 5px;
	}
	
	.workbox {
		text-align: left;
	}
	
	.blink {
		animation: blink 1s linear infinite;
	}
	
	@keyframes blink{
		0%{opacity: 0;}
		50%{opacity: .5;}
		100%{opacity: 1;}
	}
</style>
<script>
	
	$(document).ready(function() {
		
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
				    	<spring:message code="smart.status.part.title" />
				    	<div>
					    	<div class="btn btn-primary btn-sm" id="btn_close"><spring:message code="smart.common.button.close" /></div>
				    	</div>
				    </div>
				    
				    <div class="card-body">
						<div class="datatable table-responsive">
							<table class="table table-bordered table-hover" id="dataTable" width="100%" cellspacing="0">
								<colgroup>
									<col width='6%'>
									<col width='10%'>
									<col width='6%'>
									<col>
								</colgroup>
					    		<thead>
					    			<tr>
					    				<th scope="col"><spring:message code="smart.cad.partlist.partgroupno" /></th>
					    				<th scope="col"><spring:message code="smart.cad.partlist.partgroupname" /></th>
					    				<th scope="col"><spring:message code="smart.cad.partlist.partgroupcount" /></th>
					    				<th scope="col"></th>
					    			</tr>
					    		</thead>
					    		<tfoot>
					    			<tr>
					    				<th scope="col"><spring:message code="smart.cad.partlist.partgroupno" /></th>
					    				<th scope="col"><spring:message code="smart.cad.partlist.partgroupname" /></th>
					    				<th scope="col"><spring:message code="smart.cad.partlist.partgroupcount" /></th>
					    				<th scope="col"></th>
					    			</tr>
					    		</tfoot>
					    		<tbody id="data_table_tbody">
					    			<c:forEach var="result" items="${result }" varStatus="status">
					    				<tr>
						    				<td>${result.PART_GROUP_NO }</td>
						    				<td>${result.PART_GROUP_NAME }</td>
						    				<td>${result.PART_GROUP_COUNT }</td>
						    				<td>
						    					<c:forEach var="resultWork" items="${resultWork }" varStatus="workStatus">
						    						<c:if test="${result.PART_GROUP_ID == resultWork.PART_GROUP_ID }">
						    							<c:choose>
							    							<c:when test="${resultWork.WORK_END_DATE ne null }">
							    								<div class="border border-lg rounded procbox">
										    						<div class="b-1 bg-blue text-white border-bottom">
										    							${resultWork.WORK_NAME }
										    						</div>
										    						<div class="p-1 small workbox">
										    							실행 : 
										    							<br>
										    							<span class="font-weight-bolder text-blue">${resultWork.WORK_DATE }</span>
										    							<br>
										    							계획 :
										    							<br>
										    							${resultWork.PLAN_DATE } 
										    						</div>
										    					</div>
							    							</c:when>
							    							<c:when test="${resultWork.WORK_START_DATE ne null && resultWork.WORK_END_DATE eq null }">
							    								<div class="border border-lg rounded procbox">
										    						<div class="b-1 bg-teal text-white border-bottom">
										    							${resultWork.WORK_NAME }
										    						</div>
										    						<div class="p-1 small workbox">
										    							실행 : 
										    							<br>
										    							<span class="font-weight-bolder text-teal">${resultWork.WORK_DATE }</span>
										    							<br>
										    							<c:choose>
										    								<c:when test="${resultWork.PLAN_DELAY == 'DELAY' }">
										    									<span class="font-weight-bolder text-red blink">
										    										계획 :
													    							<br>
													    							${resultWork.PLAN_DATE }
										    									</span>
										    								</c:when>
										    								<c:otherwise>
										    									계획 :
												    							<br>
												    							${resultWork.PLAN_DATE }
										    								</c:otherwise>
										    							</c:choose>
										    						</div>
										    					</div>
							    							</c:when>
							    							<c:otherwise>
							    								<div class="border border-lg rounded procbox">
										    						<div class="b-1 bg-light border-bottom">
										    							${resultWork.WORK_NAME }
										    						</div>
										    						<div class="p-1 small workbox">
										    							실행 : 
										    							<br><br>
										    							<c:choose>
										    								<c:when test="${resultWork.PLAN_DELAY == 'DELAY' }">
										    									<span class="font-weight-bolder text-red blink">
										    										계획 :
													    							<br>
													    							${resultWork.PLAN_DATE }
										    									</span>
										    								</c:when>
										    								<c:otherwise>
										    									계획 :
												    							<br>
												    							${resultWork.PLAN_DATE }
										    								</c:otherwise>
										    							</c:choose>
										    						</div>
										    					</div>
							    							</c:otherwise>
							    						</c:choose>
						    						</c:if>
						    					</c:forEach>
						    				</td>
						    			</tr>
					    			</c:forEach>
			                     </tbody>
					    	</table>
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