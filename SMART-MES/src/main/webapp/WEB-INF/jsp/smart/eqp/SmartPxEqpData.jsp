<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript">var $ =jQuery.noConflict();</script>
<link href="<c:url value='/css/titlefix/defaultTheme.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/myTheme.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/titlefix/jquery.fixedheadertable.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spaceutil.js"/>"/></script>
<script>
	

var stopFlag = ["0"];
var activeFlag = ["3"];
//var readyFlag = ["1", "4", "5", "6", "7", "20", "21", "30", "90"];		//active, error 상태 외에는 전부 ready
var errorFlag = ["2"];

var headerHtml = new StringBuffer();
var bodyHtml = new StringBuffer();

headerHtml.append("<div class='nav nav-pills nav-justified flex-column flex-xl-row nav-wizard' id='cardTab' role='tablist'>");
<!-- Header Wizard navigation -->
<c:forEach var="result" items="${result}" varStatus="status">
	<!-- Wizard navigation item -->
	<c:choose>
		<c:when test="${status.first}">
			headerHtml.append("		<a class='nav-item nav-link active' id='${result.EQP_NAME}-tab' href='#${result.EQP_NAME}' data-toggle='tab' role='tab' aria-controls='wizard1' aria-selected='true'>");
		</c:when>
		<c:otherwise>
			headerHtml.append("		<a class='nav-item nav-link' id='${result.EQP_NAME}-tab' href='#${result.EQP_NAME}' data-toggle='tab' role='tab' aria-controls='wizard1' aria-selected='true'>");
		</c:otherwise>
	</c:choose>
	
	if(activeFlag.indexOf("${result.EQP_FLAG}") > -1) {
		headerHtml.append("			<i class='fas fa-circle fa-2x mr-1 text-green'></i>");
	} else if(errorFlag.indexOf("${result.EQP_FLAG}") > -1) {
		headerHtml.append("			<i class='fas fa-circle fa-2x mr-1 text-red'></i>");
	} else if(stopFlag.indexOf("${result.EQP_FLAG}") > -1) {
		headerHtml.append("			<i class='fas fa-circle fa-2x mr-1 text-gray'></i>");
	} else{
		headerHtml.append("			<i class='fas fa-circle fa-2x mr-1 text-yellow'></i>");
	}
	
	headerHtml.append("			<div class='wizard-step-text'>");
	headerHtml.append("				<div class='wizard-step-text-name'>${result.EQP_NAME}</div>");
	headerHtml.append("			</div>");
	headerHtml.append("		</a>");
	
</c:forEach>
headerHtml.append("</div>");
	
	
bodyHtml.append("<div class='tab-content' id='cardTabContent'>");
<c:forEach var="result" items="${result}" varStatus="status">

	<!-- Wizard tab pane item -->
	<c:choose>
		<c:when test="${status.first}">
			bodyHtml.append("	<div class='tab-pane py-5 py-xl-10 fade show active' id='${result.EQP_NAME}' role='tabpanel' aria-labelledby='${result.EQP_NAME}-tab'>");
		</c:when>
		<c:otherwise>
			bodyHtml.append("	<div class='tab-pane py-5 py-xl-10 fade' id='${result.EQP_NAME}' role='tabpanel' aria-labelledby='${result.EQP_NAME}-tab'>");
		</c:otherwise>
	</c:choose>
	
	bodyHtml.append("	    <div class='row justify-content-center'>");
	bodyHtml.append("	        <div class='col-xxl-6 col-xl-8'>");
	bodyHtml.append("	            <h3 class='text-primary'>${result.EQP_NAME}</h3>");
	bodyHtml.append("	            <h5 class='card-title'>${result.EQP_NAME}</h5>");
	bodyHtml.append("	            <form>");
	bodyHtml.append("	                <div class='form-group'>");
	bodyHtml.append("	                    <label class='small mb-1' for='inputUsername'>Username (how your name will appear to other users on the site)</label>");
	bodyHtml.append("	                    <input class='form-control' id='inputUsername' type='text' placeholder='Enter your username' value='username' />");
	bodyHtml.append("	                </div>");
	bodyHtml.append("	                <div class='form-row'>");
	bodyHtml.append("	                    <div class='form-group col-md-6'>");
	bodyHtml.append("	                        <label class='small mb-1' for='inputFirstName'>First name</label>");
	bodyHtml.append("	                        <input class='form-control' id='inputFirstName' type='text' placeholder='Enter your first name' value='Valerie' />");
	bodyHtml.append("	                    </div>");
	bodyHtml.append("	                    <div class='form-group col-md-6'>");
	bodyHtml.append("	                        <label class='small mb-1' for='inputLastName'>Last name</label>");
	bodyHtml.append("	                        <input class='form-control' id='inputLastName' type='text' placeholder='Enter your last name' value='Luna' />");
	bodyHtml.append("	                    </div>");
	bodyHtml.append("	                </div>");
	bodyHtml.append("	                <div class='form-row'>");
	bodyHtml.append("	                    <div class='form-group col-md-6'>");
	bodyHtml.append("	                        <label class='small mb-1' for='inputOrgName'>Organization name</label>");
	bodyHtml.append("	                        <input class='form-control' id='inputOrgName' type='text' placeholder='Enter your organization name' value='Start Bootstrap' />");
	bodyHtml.append("	                    </div>");
	bodyHtml.append("	                    <div class='form-group col-md-6'>");
	bodyHtml.append("	                        <label class='small mb-1' for='inputLocation'>Location</label>");
	bodyHtml.append("	                        <input class='form-control' id='inputLocation' type='text' placeholder='Enter your location' value='San Francisco, CA' />");
	bodyHtml.append("	                    </div>");
	bodyHtml.append("	                </div>");
	bodyHtml.append("	                <div class='form-group'>");
	bodyHtml.append("	                    <label class='small mb-1' for='inputEmailAddress'>Email address</label>");
	bodyHtml.append("	                    <input class='form-control' id='inputEmailAddress' type='email' placeholder='Enter your email address' value='name@example.com' />");
	bodyHtml.append("	                </div>");
	bodyHtml.append("	                <div class='form-row'>");
	bodyHtml.append("	                    <div class='form-group col-md-6 mb-md-0'>");
	bodyHtml.append("	                        <label class='small mb-1' for='inputPhone'>Phone number</label>");
	bodyHtml.append("	                        <input class='form-control' id='inputPhone' type='tel' placeholder='Enter your phone number' value='555-123-4567' />");
	bodyHtml.append("	                    </div>");
	bodyHtml.append("	                    <div class='form-group col-md-6 mb-0'>");
	bodyHtml.append("	                        <label class='small mb-1' for='inputBirthday'>Birthday</label>");
	bodyHtml.append("	                        <input class='form-control' id='inputBirthday' type='text' name='birthday' placeholder='Enter your birthday' value='06/10/1988' />");
	bodyHtml.append("	                    </div>");
	bodyHtml.append("	                </div>");
	bodyHtml.append("	                <hr class='my-4' />");
	bodyHtml.append("	                <div class='d-flex justify-content-between'>");
	bodyHtml.append("	                    <button class='btn btn-light disabled' type='button' disabled>Previous</button>");
	bodyHtml.append("	                    <button class='btn btn-primary' type='button'>Next</button>");
	bodyHtml.append("	                </div>");
	bodyHtml.append("	            </form>");
	bodyHtml.append("	        </div>");
	bodyHtml.append("	    </div>");
	bodyHtml.append("	</div>");
	
</c:forEach>
bodyHtml.append("</div>");
	
	
parent.$("#data_header").empty();
parent.$("#data_header").append(headerHtml.toString());
parent.$("#data_body").empty();
parent.$("#data_body").append(bodyHtml.toString());

</script>