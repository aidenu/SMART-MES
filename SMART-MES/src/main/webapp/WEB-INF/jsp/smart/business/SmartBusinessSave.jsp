<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script>

		if("${actionresult}" == "OK") {
			alert("<spring:message code="smart.common.save.ok" />");
			parent.self.close();
			parent.opener.$("#btn_search").trigger("click");
		} else if("${actionresult}".indexOf("ERROR")){
			alert("<spring:message code="smart.common.save.error" /> \n [${actionresult}]");
		}

</script>