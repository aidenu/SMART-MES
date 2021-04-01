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
<link href="<c:url value='/css/jquery/Chart.min.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/titlefix/jquery.fixedheadertable.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spaceutil.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/jquery/Chart.js"/>"/></script>
<script src="https://cdn.amcharts.com/lib/4/core.js"></script>
<script src="https://cdn.amcharts.com/lib/4/charts.js"></script>
<script src="https://cdn.amcharts.com/lib/4/themes/animated.js"></script>
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
			bodyHtml.append("	<div class='eqp-tab-cls tab-pane py-5 py-xl-10 fade show active' id='${result.EQP_NAME}' role='tabpanel' aria-labelledby='${result.EQP_NAME}-tab'>");
		</c:when>
		<c:otherwise>
			bodyHtml.append("	<div class='eqp-tab-cls tab-pane py-5 py-xl-10 fade show active' id='${result.EQP_NAME}' role='tabpanel' aria-labelledby='${result.EQP_NAME}-tab'>");
		</c:otherwise>
	</c:choose>
	
	bodyHtml.append("	    <div class='row justify-content-center'>");
	bodyHtml.append("	        <div class='col-xxl-6 col-xl-12'>");
	bodyHtml.append("				<h3 class='text-primary'>${result.EQP_NAME}</h3>");
	
	<c:forEach var="resultStack" items="${resultStack}" varStatus="stackStatus">
		<c:if test="${result.EQP_NAME == resultStack.EQP_NAME_VIEW}">
			bodyHtml.append("				<div class='row'>");

			bodyHtml.append("					<div class='col-lg-4'>");
            bodyHtml.append("						<div class='card mb-4'>");
       		bodyHtml.append("							<div class='card-header'><spring:message code="smart.eqp.status.pie.title" /></div>");
			bodyHtml.append("							<div class='card-body'>");
			bodyHtml.append("								<div class='chart-pie'><canvas id='${result.EQP_NAME}_pie' width='100%' height='50'></canvas></div>");
			bodyHtml.append("							</div>");
			bodyHtml.append("							<div class='card-footer small text-muted'></div>");
			bodyHtml.append("						</div>");
			bodyHtml.append("					</div>");
			
			bodyHtml.append("					<div class='col-lg-8'>");
			bodyHtml.append("						<div class='card mb-4'>");
       		bodyHtml.append("							<div class='card-header'><spring:message code="smart.eqp.status.timeline.title" /></div>");
			bodyHtml.append("							<div class='card-body'>");
			
// 			bodyHtml.append("								<div class='chart-bar'><canvas id='${result.EQP_NAME}_timeline' width='100%' height='38'></canvas></div>");
			bodyHtml.append("								<div id='${result.EQP_NAME}_timeline'></div>");
			
			bodyHtml.append("							</div>");
			bodyHtml.append("							<div class='card-footer small text-muted'></div>");
			bodyHtml.append("						</div>");
			bodyHtml.append("					</div>");
			
		    bodyHtml.append("				</div>");
		</c:if>
	</c:forEach>
	
	
	bodyHtml.append("	        </div>");
	bodyHtml.append("	    </div>");	//<div class='row justify-content-center'
	bodyHtml.append("	</div>");	//<div class='tab-pane'
	
</c:forEach>
bodyHtml.append("</div>");	//<div class='tab-content' id='cardTabContent'>
	
	
parent.$("#data_header").empty();
parent.$("#data_header").append(headerHtml.toString());
parent.$("#data_body").empty();
parent.$("#data_body").append(bodyHtml.toString());

<c:forEach var="resultStack" items="${resultStack}" varStatus="stackStatus">

	new Chart(parent.document.getElementById("${resultStack.EQP_NAME_VIEW}_pie"), {
	    type: "doughnut",
	    data: {
	        labels: ["ACTIVE", "READY", "ERROR", "STOP"],
	        datasets: [{
	            data: ["${resultStack.ACTIVE_TIME}", "${resultStack.READY_TIME}", "${resultStack.ERROR_TIME}", "${resultStack.STOP_TIME}"],
	            backgroundColor: [
	                "#00AC69",
	                "#F4A100",
	                "#E81500",
	                "#687281"
	            ],
	            hoverBackgroundColor: [
	            	"#00AC69",
	                "#F4A100",
	                "#E81500",
	                "#687281"
	            ],
	            hoverBorderColor: "rgba(234, 236, 244, 1)"
	        }]
	    },
	    options: {
	        maintainAspectRatio: false,
	        tooltips: {
	            backgroundColor: "rgb(255,255,255)",
	            bodyFontColor: "#858796",
	            borderColor: "#dddfeb",
	            borderWidth: 1,
	            xPadding: 15,
	            yPadding: 15,
	            displayColors: false,
	            caretPadding: 10
	        },
	        legend: {
	            display: false
	        },
	        cutoutPercentage: 80
	    }
	});
	
	<c:if test="${!stackStatus.first}">
		parent.$("#${resultStack.EQP_NAME_VIEW}").removeClass("show");
		parent.$("#${resultStack.EQP_NAME_VIEW}").removeClass("active");
	</c:if>
</c:forEach>


<c:forEach var="resultStack" items="${resultStack}" varStatus="stackStatus">
	
	am4core.ready(function() {
	
		// Themes begin
		am4core.useTheme(am4themes_animated);
		// Themes end
	
		var chart = am4core.create("${resultStack.EQP_NAME_VIEW}_timeline", am4charts.XYChart);
		chart.hiddenState.properties.opacity = 0; // this creates initial fade-in
	
		chart.paddingRight = 30;
		chart.dateFormatter.inputDateFormat = "yyyy-MM-dd HH:mm";
	
		var colorSet = new am4core.ColorSet();
		colorSet.saturation = 0.4;
	
		chart.data = [ {
		  "category": "Module #1",
		  "start": "2016-01-01",
		  "end": "2016-01-14",
		  "color": colorSet.getIndex(0).brighten(0),
		  "task": "Gathering requirements"
		}, {
		  "category": "Module #1",
		  "start": "2016-01-16",
		  "end": "2016-01-27",
		  "color": colorSet.getIndex(0).brighten(0.4),
		  "task": "Producing specifications"
		}, {
		  "category": "Module #1",
		  "start": "2016-02-05",
		  "end": "2016-04-18",
		  "color": colorSet.getIndex(0).brighten(0.8),
		  "task": "Development"
		}, {
		  "category": "Module #1",
		  "start": "2016-04-18",
		  "end": "2016-04-30",
		  "color": colorSet.getIndex(0).brighten(1.2),
		  "task": "Testing and QA"
		}, {
		  "category": "Module #2",
		  "start": "2016-01-08",
		  "end": "2016-01-10",
		  "color": colorSet.getIndex(2).brighten(0),
		  "task": "Gathering requirements"
		}, {
		  "category": "Module #2",
		  "start": "2016-01-12",
		  "end": "2016-01-15",
		  "color": colorSet.getIndex(2).brighten(0.4),
		  "task": "Producing specifications"
		}, {
		  "category": "Module #2",
		  "start": "2016-01-16",
		  "end": "2016-02-05",
		  "color": colorSet.getIndex(2).brighten(0.8),
		  "task": "Development"
		}, {
		  "category": "Module #2",
		  "start": "2016-02-10",
		  "end": "2016-02-18",
		  "color": colorSet.getIndex(2).brighten(1.2),
		  "task": "Testing and QA"
		}, {
		  "category": "Module #3",
		  "start": "2016-01-02",
		  "end": "2016-01-08",
		  "color": colorSet.getIndex(4).brighten(0),
		  "task": "Gathering requirements"
		}, {
		  "category": "Module #3",
		  "start": "2016-01-08",
		  "end": "2016-01-16",
		  "color": colorSet.getIndex(4).brighten(0.4),
		  "task": "Producing specifications"
		}, {
		  "category": "Module #3",
		  "start": "2016-01-19",
		  "end": "2016-03-01",
		  "color": colorSet.getIndex(4).brighten(0.8),
		  "task": "Development"
		}, {
		  "category": "Module #3",
		  "start": "2016-03-12",
		  "end": "2016-04-05",
		  "color": colorSet.getIndex(4).brighten(1.2),
		  "task": "Testing and QA"
		}, {
		  "category": "Module #4",
		  "start": "2016-01-01",
		  "end": "2016-01-19",
		  "color": colorSet.getIndex(6).brighten(0),
		  "task": "Gathering requirements"
		}, {
		  "category": "Module #4",
		  "start": "2016-01-19",
		  "end": "2016-02-03",
		  "color": colorSet.getIndex(6).brighten(0.4),
		  "task": "Producing specifications"
		}, {
		  "category": "Module #4",
		  "start": "2016-03-20",
		  "end": "2016-04-25",
		  "color": colorSet.getIndex(6).brighten(0.8),
		  "task": "Development"
		}, {
		  "category": "Module #4",
		  "start": "2016-04-27",
		  "end": "2016-05-15",
		  "color": colorSet.getIndex(6).brighten(1.2),
		  "task": "Testing and QA"
		}, {
		  "category": "Module #5",
		  "start": "2016-01-01",
		  "end": "2016-01-12",
		  "color": colorSet.getIndex(8).brighten(0),
		  "task": "Gathering requirements"
		}, {
		  "category": "Module #5",
		  "start": "2016-01-12",
		  "end": "2016-01-19",
		  "color": colorSet.getIndex(8).brighten(0.4),
		  "task": "Producing specifications"
		}, {
		  "category": "Module #5",
		  "start": "2016-01-19",
		  "end": "2016-03-01",
		  "color": colorSet.getIndex(8).brighten(0.8),
		  "task": "Development"
		}, {
		  "category": "Module #5",
		  "start": "2016-03-08",
		  "end": "2016-03-30",
		  "color": colorSet.getIndex(8).brighten(1.2),
		  "task": "Testing and QA"
		} ];
	
		chart.dateFormatter.dateFormat = "yyyy-MM-dd";
		chart.dateFormatter.inputDateFormat = "yyyy-MM-dd";
	
		var categoryAxis = chart.yAxes.push(new am4charts.CategoryAxis());
		categoryAxis.dataFields.category = "category";
		categoryAxis.renderer.grid.template.location = 0;
		categoryAxis.renderer.inversed = true;
	
		var dateAxis = chart.xAxes.push(new am4charts.DateAxis());
		dateAxis.renderer.minGridDistance = 70;
		dateAxis.baseInterval = { count: 1, timeUnit: "day" };
		// dateAxis.max = new Date(2018, 0, 1, 24, 0, 0, 0).getTime();
		//dateAxis.strictMinMax = true;
		dateAxis.renderer.tooltipLocation = 0;
	
		var series1 = chart.series.push(new am4charts.ColumnSeries());
		series1.columns.template.height = am4core.percent(70);
		series1.columns.template.tooltipText = "{task}: [bold]{openDateX}[/] - [bold]{dateX}[/]";
	
		series1.dataFields.openDateX = "start";
		series1.dataFields.dateX = "end";
		series1.dataFields.categoryY = "category";
		series1.columns.template.propertyFields.fill = "color"; // get color from data
		series1.columns.template.propertyFields.stroke = "color";
		series1.columns.template.strokeOpacity = 1;
	
		chart.scrollbarX = new am4core.Scrollbar();

	}); // end am4core.ready()
	
</c:forEach>

</script>