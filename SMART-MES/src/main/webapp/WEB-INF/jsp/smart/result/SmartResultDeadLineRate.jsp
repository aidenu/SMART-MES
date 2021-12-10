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
<title><spring:message code="smart.result.deadline.rate.title" /></title>
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
			
			var year = $("#year").val();
			
			$.ajax({
				url : "${pageContext.request.contextPath}/smart/result/SmartResultDeadLineRateData.do",
				data : {"year":year},
				type : "POST",
				datatype : "json",
				success : function(data) {
					
					let total_cnt_sum = 0;
					let deadline_cnt_sum = 0;
					let over_deadline_cnt_sum = 0;
					let deadline_ratio_sum = 0;
					
					
					$.each(data, function(index, value) {
						
						let {
							MONTH_ : month,
							TOTAL_CNT : total_cnt,
							DEADLINE_CNT : deadline_cnt,
							OVER_DEADLINE_CNT : over_deadline_cnt,
							DEADLINE_RATIO : deadline_ratio
						} = value;
						

						$("#total_cnt_"+month).empty();
						$("#deadline_cnt_"+month).empty();
						$("#over_deadline_cnt_"+month).empty();
						$("#deadline_ratio_"+month).empty();
						
						$("#total_cnt_"+month).append(total_cnt);
						$("#deadline_cnt_"+month).append(deadline_cnt);
						$("#over_deadline_cnt_"+month).append(over_deadline_cnt);
						$("#deadline_ratio_"+month).append(deadline_ratio);
						
						total_cnt_sum += total_cnt;
						deadline_cnt_sum += deadline_cnt;
						over_deadline_cnt_sum += over_deadline_cnt;
						
					});	//$.each
					
					
					$("#total_cnt_total").empty();
					$("#deadline_cnt_total").empty();
					$("#over_deadline_cnt_total").empty();
					$("#deadline_ratio_total").empty();
					
					$("#total_cnt_total").append(total_cnt_sum);
					$("#deadline_cnt_total").append(deadline_cnt_sum);
					$("#over_deadline_cnt_total").append(over_deadline_cnt_sum);
					
					if(total_cnt_sum != 0) {
						deadline_ratio_sum = Math.round(deadline_cnt_sum / total_cnt_sum * 100);
					}
					$("#deadline_ratio_total").append(deadline_ratio_sum+"%");	
					
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
										<span><spring:message code="smart.result.deadline.rate.title" /></span>
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
								년도 : 
								<div style="display: inline-flex;">
									<select class="form-control form-control-solid" name="year" id="year">
										<c:set var="now" value="<%=new java.util.Date()%>" />
										<fmt:formatDate value="${now}" pattern="yyyy" var="yearStart"/> 
										<c:forEach begin="0" end="10" var="result" step="1">
											<option value="<c:out value="${yearStart - result}" />"><c:out value="${yearStart - result}" /></option>
										</c:forEach>
									</select>
								</div>
								&nbsp;
								<div class="btn btn-outline-primary" id="btn_search"><spring:message code="smart.common.button.search" /></div>
							</div>
							<div class="card-body">
								<div class="table-responsive">
									<table class="table mb-0">
                                        <thead>
                                            <tr>
                                            	<th class="border-gray-200" scope="col">구분</th>
                                                <th class="border-gray-200" scope="col">1월</th>
                                                <th class="border-gray-200" scope="col">2월</th>
                                                <th class="border-gray-200" scope="col">3월</th>
                                                <th class="border-gray-200" scope="col">4월</th>
                                                <th class="border-gray-200" scope="col">5월</th>
                                                <th class="border-gray-200" scope="col">6월</th>
                                                <th class="border-gray-200" scope="col">7월</th>
                                                <th class="border-gray-200" scope="col">8월</th>
                                                <th class="border-gray-200" scope="col">9월</th>
                                                <th class="border-gray-200" scope="col">10월</th>
                                                <th class="border-gray-200" scope="col">11월</th>
                                                <th class="border-gray-200" scope="col">12월</th>
                                                <th class="border-gray-200 text-primary" scope="col">합계</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>건수</td>
                                                <td id="total_cnt_1"></td>
                                                <td id="total_cnt_2"></td>
                                                <td id="total_cnt_3"></td>
                                                <td id="total_cnt_4"></td>
                                                <td id="total_cnt_5"></td>
                                                <td id="total_cnt_6"></td>
                                                <td id="total_cnt_7"></td>
                                                <td id="total_cnt_8"></td>
                                                <td id="total_cnt_9"></td>
                                                <td id="total_cnt_10"></td>
                                                <td id="total_cnt_11"></td>
                                                <td id="total_cnt_12"></td>
                                                <td id="total_cnt_total" class="text-primary"></td>
                                            </tr>
                                            <tr>
                                                <td>납기준수</td>
                                                <td id="deadline_cnt_1"></td>
                                                <td id="deadline_cnt_2"></td>
                                                <td id="deadline_cnt_3"></td>
                                                <td id="deadline_cnt_4"></td>
                                                <td id="deadline_cnt_5"></td>
                                                <td id="deadline_cnt_6"></td>
                                                <td id="deadline_cnt_7"></td>
                                                <td id="deadline_cnt_8"></td>
                                                <td id="deadline_cnt_9"></td>
                                                <td id="deadline_cnt_10"></td>
                                                <td id="deadline_cnt_11"></td>
                                                <td id="deadline_cnt_12"></td>
                                                <td id="deadline_cnt_total" class="text-primary"></td>
                                            </tr>
                                            <tr>
                                                <td>납기미준수</td>
                                                <td id="over_deadline_cnt_1"></td>
                                                <td id="over_deadline_cnt_2"></td>
                                                <td id="over_deadline_cnt_3"></td>
                                                <td id="over_deadline_cnt_4"></td>
                                                <td id="over_deadline_cnt_5"></td>
                                                <td id="over_deadline_cnt_6"></td>
                                                <td id="over_deadline_cnt_7"></td>
                                                <td id="over_deadline_cnt_8"></td>
                                                <td id="over_deadline_cnt_9"></td>
                                                <td id="over_deadline_cnt_10"></td>
                                                <td id="over_deadline_cnt_11"></td>
                                                <td id="over_deadline_cnt_12"></td>
                                                <td id="over_deadline_cnt_total" class="text-primary"></td>
                                            </tr>
                                            <tr>
                                                <td>납기준수율</td>
                                                <td id="deadline_ratio_1"></td>
                                                <td id="deadline_ratio_2"></td>
                                                <td id="deadline_ratio_3"></td>
                                                <td id="deadline_ratio_4"></td>
                                                <td id="deadline_ratio_5"></td>
                                                <td id="deadline_ratio_6"></td>
                                                <td id="deadline_ratio_7"></td>
                                                <td id="deadline_ratio_8"></td>
                                                <td id="deadline_ratio_9"></td>
                                                <td id="deadline_ratio_10"></td>
                                                <td id="deadline_ratio_11"></td>
                                                <td id="deadline_ratio_12"></td>
                                                <td id="deadline_ratio_total" class="text-primary"></td>
                                            </tr>
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