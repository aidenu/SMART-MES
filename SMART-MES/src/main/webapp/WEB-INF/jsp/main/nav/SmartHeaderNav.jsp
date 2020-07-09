<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


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
					<div class="dropdown-menu dropdown-menu-right border-0 shadow animated--fade-in-up" aria-labelledby="navbarDropdownAlerts">
						<h6 class="dropdown-header dropdown-notifications-header">
							<i class="mr-2" data-feather="bell"></i>
							Alerts Center
						</h6>
						<a class="dropdown-item dropdown-notifications-item" href="#!">
							<div class="dropdown-notifications-item-icon bg-warning">
								<i data-feather="activity"></i>
							</div>
							<div class="dropdown-notifications-item-content">
								<div class="dropdown-notifications-item-content-details">December 29, 2019</div>
								<div class="dropdown-notifications-item-content-text">This is an alert message. It's nothing serious, but it requires your attention.</div>
							</div>
						</a>
						<a class="dropdown-item dropdown-notifications-item" href="#!">
							<div class="dropdown-notifications-item-icon bg-info">
								<i data-feather="bar-chart"></i>
							</div>
							<div class="dropdown-notifications-item-content">
								<div class="dropdown-notifications-item-content-details">December 22, 2019</div>
								<div class="dropdown-notifications-item-content-text">A new monthly report is ready. Click here to view!</div>
							</div>
						</a>
						<a class="dropdown-item dropdown-notifications-item" href="#!">
							<div class="dropdown-notifications-item-icon bg-danger">
								<i class="fas fa-exclamation-triangle"></i>
							</div>
							<div class="dropdown-notifications-item-content">
								<div class="dropdown-notifications-item-content-details">December 8, 2019</div>
								<div class="dropdown-notifications-item-content-text">Critical system failure, systems shutting down.</div>
							</div>
						</a>
						<a class="dropdown-item dropdown-notifications-item" href="#!">
							<div class="dropdown-notifications-item-icon bg-success">
								<i data-feather="user-plus"></i>
							</div>
							<div class="dropdown-notifications-item-content">
								<div class="dropdown-notifications-item-content-details">December 2, 2019</div>
								<div class="dropdown-notifications-item-content-text">New user request. Woody has requested access to the organization.</div>
							</div>
						</a>
						<a class="dropdown-item dropdown-notifications-footer" href="#!">View All Alerts</a>
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
						<a class="dropdown-item" href="#!">
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
