<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>

<script>

$(document).ready(function() {
	
	//Alarm List View
	$("#btnViewAlarm").click(function() {
		
		window.open("<c:url value='/smart/common/SmartAlarmList.do'/>", "alarmListPop", "scrollbars=yes,toolbar=no,resizable=yes,left=200,top=200,width=1000,height=738");
		
	});
	
	$('#accountModalLayer').on('shown.bs.modal', function () {
	   $('#currentPassword').focus();
	});
	
	
	$("#btn_chgpw").click(function() {
		
		var currentPassword = $("#currentPassword").val();
		var newPassword = $("#newPassword").val();
		var confirmPassword = $("#confirmPassword").val();
		
		$.ajax({
			
			url : "${pageContext.request.contextPath}/smart/common/SmartChangePassword.do",
			data : {"currentPassword":currentPassword, "newPassword":newPassword, "confirmPassword":confirmPassword},
			type : "POST",
			datatype : "text",
			success : function(data) {
				if(data == "CURRENTPASSWORD_INVALID") {
					alert("<spring:message code="smart.manage.user.alert.current.passwd.invalid" />");
				} else if(data == "CONFIRMPASSWORD_INVALID") {
					alert("<spring:message code="smart.manage.user.alert.confirm.passwd.invalid" />");
				} else {
					alert("<spring:message code="smart.manage.user.alert.change.passwd.valid" />");

					$("#currentPassword").val("");
					$("#newPassword").val("");
					$("#confirmPassword").val("");

					$('#accountModalLayer').modal("hide");
				}
				
			}	//success
			
			
		});	//$.ajax
		
	});	//$("#btn_save")
	
});
	
</script>

	<nav class="topnav navbar navbar-expand shadow navbar-light bg-white" id="sidenavAccordion">
		<a class="navbar-brand d-none d-sm-block" href="<c:url value='/'/>uat/uia/actionMain.do">SMART MES</a>
			<button class="btn btn-icon btn-transparent-dark order-1 order-lg-0 mr-lg-2" id="sidebarToggle" href="#">
				<i data-feather="menu"></i>
            </button>
            <ul class="navbar-nav align-items-center ml-auto">
				<li class="nav-item dropdown no-caret mr-3 dropdown-notifications">
					<a class="btn btn-icon btn-transparent-dark dropdown-toggle" id="navbarDropdownAlerts" href="javascript:void(0);" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
						<i data-feather="bell"></i>
					</a>
					<div class="dropdown-menu dropdown-menu-right border-0 shadow animated--fade-in-up" id="alarmdropdown" aria-labelledby="navbarDropdownAlerts">
						<h6 class="dropdown-header dropdown-notifications-header">
							<i class="mr-2" data-feather="bell"></i>
							Alerts Center
						</h6>
						<c:forEach var="resultAlarm" items="${resultAlarm }" varStatus="status">
							<c:if test="${status.index < 3 }">
								<div class="dropdown-item dropdown-notifications-item" href="#!" 
									data-toggle="tooltip" data-placement="bottom" title="" data-original-title="${resultAlarm.ALARM_DESC }">
									<div class="dropdown-notifications-item-icon bg-warning">
										<i data-feather="activity"></i>
									</div>
									<div class="dropdown-notifications-item-content">
										<div class="dropdown-notifications-item-content-details">${resultAlarm.ALARM_SEND_TIME }</div>
										<div class="dropdown-notifications-item-content-text">${resultAlarm.ALARM_DESC }</div>
									</div>
								</div>
							</c:if>
						</c:forEach>
						<div class="dropdown-item dropdown-notifications-footer" id="btnViewAlarm">View All Alerts</div>
					</div>
				</li>
				<li class="nav-item dropdown no-caret mr-3 dropdown-user">
					<a class="btn btn-icon btn-transparent-dark dropdown-toggle" id="navbarDropdownUserImage" href="javascript:void(0);" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
						<img class="img-fluid" src="<c:url value='/'/>images/smart/loginImg.png"/>
					</a>
					<div class="dropdown-menu dropdown-menu-right border-0 shadow animated--fade-in-up" aria-labelledby="navbarDropdownUserImage">
						<h6 class="dropdown-header d-flex align-items-center">
							<img class="dropdown-user-img" src="<c:url value='/'/>images/smart/loginImg.png" />
							<div class="dropdown-user-details">
								<div class="dropdown-user-details-name">${userid }(${username })</div>
								<div class="dropdown-user-details-email">${useremail }</div>
							</div>
						</h6>
						<div class="dropdown-divider"></div>
						<a class="dropdown-item" href="#!" data-toggle="modal" data-target="#accountModalLayer">
							<div class="dropdown-item-icon"><i data-feather="settings"></i></div>
							Account
						</a>
						<a class="dropdown-item" href="<c:url value='/uat/uia/actionLogout.do'/>">
							<div class="dropdown-item-icon">
								<i data-feather="log-out"></i>
							</div>
							Logout
						</a>
					</div>
				</li>
			</ul>
		</nav>
		<!-- 	==============	Haeder Navigation ======================= -->
		
		<!-- Modal -->
		<div class="modal fade" id="accountModalLayer" tabindex="-1" role="dialog" aria-labelledby="accountModalLayerTitle" aria-hidden="true">
		    <div class="modal-dialog modal-dialog-centered" role="document">
		        <div class="modal-content">
		            <div class="modal-header">
		                <h5 class="modal-title" id="accountModalLayerTitle"><spring:message code="smart.manage.user.changepassword.title" /></h5>
		                <button class="close" type="button" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
		            </div>
		            <div class="modal-body">
		                <div class="form-group">
                             <label class="small mb-1" for="currentPassword">Current Password</label>
                             <input class="form-control" id="currentPassword" type="password" placeholder="Enter current password" />
                         </div>
                         <!-- Form Group (new password)-->
                         <div class="form-group">
                             <label class="small mb-1" for="newPassword">New Password</label>
                             <input class="form-control" id="newPassword" type="password" placeholder="Enter new password" />
                         </div>
                         <!-- Form Group (confirm password)-->
                         <div class="form-group">
                             <label class="small mb-1" for="confirmPassword">Confirm Password</label>
                             <input class="form-control" id="confirmPassword" type="password" placeholder="Confirm new password" />
                         </div>
		            </div>
		            <div class="modal-footer">
		            	<div class="btn btn-secondary" data-dismiss="modal">닫기</div>
		            	<div class="btn btn-primary" id="btn_chgpw">저장</div>
		            </div>
		        </div>
		    </div>
		</div>
		<!-- Modal -->
		
