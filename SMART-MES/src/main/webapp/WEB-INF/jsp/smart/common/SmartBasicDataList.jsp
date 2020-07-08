<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script>

	if(${actionlevel} == 1 || ${actionlevel} == 2)
	{
		parent.document.getElementById("level2_value").options.length = 0;
		parent.document.getElementById("level3_value").options.length = 0;
		parent.document.getElementById("level4_value").options.length = 0;
		parent.document.getElementById("level5_value").options.length = 0;
		parent.document.getElementById("level2_name").value = "";
		parent.document.getElementById("level3_name").value = "";
		parent.document.getElementById("level4_name").value = "";
		parent.document.getElementById("level5_name").value = "";
	}
	else if(${actionlevel} == 3)
	{
		parent.document.getElementById("level3_value").options.length = 0;
		parent.document.getElementById("level4_value").options.length = 0;
		parent.document.getElementById("level5_value").options.length = 0;
		parent.document.getElementById("level3_name").value = "";
		parent.document.getElementById("level4_name").value = "";
		parent.document.getElementById("level5_name").value = "";
	}
	else if(${actionlevel} == 4)
	{
		parent.document.getElementById("level4_value").options.length = 0;
		parent.document.getElementById("level5_value").options.length = 0;
		parent.document.getElementById("level4_name").value = "";
		parent.document.getElementById("level5_name").value = "";
	}
	else if(${actionlevel} == 5)
	{
		parent.document.getElementById("level5_value").options.length = 0;
		parent.document.getElementById("level5_name").value = "";
	}

	var select_obj = parent.document.getElementById("level${actionlevel}_value");
	
	<c:forEach var="result" items="${basicdatalist}" varStatus="status">
		var option = new Option();

		option.text = 	"${result.child_value}";
		option.value = "${result.child_id}";
		option.name = "${result.parent_id}";
		select_obj.options.add(option);
		
	</c:forEach>


</script>