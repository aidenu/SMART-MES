<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script>
	
	var select_obj = parent.document.getElementById("tool_level_2");
	
	select_obj.options.length = 0;
	
	var option = new Option();

	if("${gubun}" == "LIST")
	{
		option.text = 	"-전체-";
		option.value = "ALL";
	}
	else
	{
		option.text = 	"-선택-";
		option.value = "";
	}
	

	select_obj.options.add(option);
	
	<c:forEach var="result" items="${result}" varStatus="status">

		option = new Option();

		option.text = 	"${result.CHILD_VALUE}";
		option.value = "${result.CHILD_ID}";

		select_obj.options.add(option);
		
	</c:forEach>

</script>