<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Language" content="ko" >

<title><spring:message code="smart.manage.auth.title" /></title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >

<script language="javascript1.2" type="text/javaScript" src="<c:url value='/js/EgovMenuCreat.js'/>"></script>

<script language="javascript1.2" type="text/javaScript">

	var imgpath = "<c:url value='/'/>images/tree/";

	function selectMenuCreatTmp() 
	{
	    document.menuCreatManageForm.action = "<c:url value='/sym/mpm/EgovMenuCreatSelect.do'/>";
	    document.menuCreatManageForm.submit();
	}
	
	
	function fInsertMenuCreat() 
	{
	    var checkField = document.menuCreatManageForm.checkField;
	    var checkMenuNos = "";
	    var checkedCount = 0;
	    
	    if(checkField) 
	    {
	        if(checkField.length > 1) 
	        {
	            for(var i=0; i < checkField.length; i++) 
	            {
	                if(checkField[i].checked) 
	                {
	                    checkMenuNos += ((checkedCount==0? "" : ",") + checkField[i].value);
	                    checkedCount++;
	                }
	            }
	        } 
	        else 
	        {
	            if(checkField.checked) 
	            {
	                checkMenuNos = checkField.value;
	            }
	        }
	    }   
	    
	    document.menuCreatManageForm.checkedMenuNoForInsert.value=checkMenuNos;
	    document.menuCreatManageForm.checkedAuthorForInsert.value=document.menuCreatManageForm.authorCode.value;
	    document.menuCreatManageForm.action = "<c:url value='/sym/mnu/mcm/EgovMenuCreatInsert.do'/>";
	    document.menuCreatManageForm.submit(); 
	}
	
	
	function fMenuCreatSiteMap() 
	{
	    id = document.menuCreatManageForm.authorCode.value;
	    window.open("<c:url value='/sym/mpm/EgovMenuCreatSiteMapSelect.do'/>?authorCode="+id,'Pop_SiteMap','scrollbars=yes, width=550, height=700');
	}
	
	<c:if test="${!empty resultMsg}">alert("${resultMsg}");</c:if>

</script>

</head>

<body style="background-color: #2c3338;">

<!-- 전체 레이어 시작 -->
<div id="wrap">
    
    <form name="menuCreatManageForm" action ="/sym/mpm/EgovMenuCreatSiteMapSelect.do" method="post">
	<input type="submit" id="invisible" class="invisible"/>
	<input name="checkedMenuNoForInsert" type="hidden" >
	<input name="checkedAuthorForInsert"  type="hidden" >
	<input type="hidden" name="req_menuNo">
    
    <div id="spacecontainer">
		<table width="100%">
			<tr><td colspan="3" height="3"></td></tr>
			<tr>
				<td valign="top">
					<table>
						<tr>
							<td width="*">
								<div style="width:500px;border: 1px solid #D5D1B0;">
									<table width="100%">
										<tr>
											<td id="captionSubTitle" align="center" style="background-color: #2c3338;">
												 <font color="#FFF"><spring:message code="space.manage.menu.item.code" /> : </font>
								                <input name="authorCode" type="text" size="30"  maxlength="30" value="${resultVO.authorCode}" readonly> 
								                <a class='AXButton Gray' href="#LINK" onclick="fInsertMenuCreat(); return false;"><spring:message code="space.manage.menu.button.menucreate" /></a>
								                <a class='AXButton Gray' href="#LINK" onclick="self.close()"><spring:message code="space.manage.menu.button.close" /></a>
											</td>
										</tr>
									</table>
								</div>
							</td>
						</tr>
						<tr>
							<td colspan="3">
								<div class="tableContainer" style="width:500px;">
									<c:forEach var="result1" items="${list_menulist}" varStatus="status" > 
                            			<input type="hidden" name="tmp_menuNmVal" value="${result1.menuNo}|${result1.upperMenuId}|${result1.menuNm}|${result1.progrmFileNm}|${result1.chkYeoBu}|">
                        			</c:forEach>
	                    			<table  cellpadding="0" cellspacing="0">
	                        			<tr>
							    			<td width='20'>&nbsp;</td>
							    			<td >
								    			<div class="tree" >
								        			<script language="javascript" type="text/javaScript">
											            var chk_Object = true;
											            var chk_browse = "";
											            
											            if (eval(document.menuCreatManageForm.authorCode)=="[object]") chk_browse = "IE";
											            if (eval(document.menuCreatManageForm.authorCode)=="[object NodeList]") chk_browse = "Fox";
											            if (eval(document.menuCreatManageForm.authorCode)=="[object Collection]") chk_browse = "safai";
											
											            var Tree = new Array;
											            
											            if(chk_browse=="IE"&&eval(document.menuCreatManageForm.tmp_menuNmVal)!="[object]")
											            {
											               alert("<spring:message code="space.manage.menu.alert.nodata" />");
											               chk_Object = false;
											            }
											            
											            if(chk_browse=="Fox"&&eval(document.menuCreatManageForm.tmp_menuNmVal)!="[object NodeList]")
											            {
											               alert("<spring:message code="space.manage.menu.alert.nodata" />");
											               chk_Object = false;
											            }
											            
											            if(chk_browse=="safai"&&eval(document.menuCreatManageForm.tmp_menuNmVal)!="[object Collection]")
											            {
											                   alert("<spring:message code="space.manage.menu.alert.nodata" />");
											                   chk_Object = false;
											            }
											            
											            if( chk_Object )
											            {
											                for (var j = 0; j < document.menuCreatManageForm.tmp_menuNmVal.length; j++) 
											                {
											                    Tree[j] = document.menuCreatManageForm.tmp_menuNmVal[j].value;
											                }
											                
											                createTree(Tree);
											            }
											            else
											            {
											                alert("<spring:message code="space.manage.menu.alert.nomenu" />");
											                window.close();
											            }
											        </script>
								    			</div>
						       				</td> 
						   				</tr>
									</table>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	</form>
	
</div>            
    
    
 </body>
</html>