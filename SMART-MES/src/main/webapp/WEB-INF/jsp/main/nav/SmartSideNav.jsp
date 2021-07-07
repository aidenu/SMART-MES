<%--
  Class Name : EgovIncTopnav.jsp
  Description : 상단메뉴화면(include)
  Modification Information
 
      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2011.08.31   JJY       경량환경 버전 생성
 
    author   : 실행환경개발팀 JJY
    since    : 2011.08.31 
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<!-- topmenu start -->


<script type="text/javascript">

    function getLastLink(baseMenuNo){
    	var tNode = new Array;
        for (var i = 0; i < document.menuListForm.tmp_menuNm.length; i++) {
            tNode[i] = document.menuListForm.tmp_menuNm[i].value;
            var nValue = tNode[i].split("|");
            //선택된 메뉴(baseMenuNo)의 하위 메뉴중 첫번재 메뉴의 링크정보를 리턴한다.
            if (nValue[1]==baseMenuNo) {
                if(nValue[5]!="dir" && nValue[5]!="" && nValue[5]!="/"){
                    //링크정보가 있으면 링크정보를 리턴한다.
                    if(nValue[5].indexOf("?")>0)
                    {
                    	return nValue[5]+"&currentMenuNo=" + nValue[0];
                    }
                    else
                    {
                    	return nValue[5]+"?currentMenuNo=" + nValue[0];
                    }
                }else{
                    //링크정보가 없으면 하위 메뉴중 첫번째 메뉴의 링크정보를 리턴한다.
                    return getLastLink(nValue[0]);
                }
            }
        }
    }
    function goMenuPage(baseMenuNo){
    	document.getElementById("baseMenuNo").value=baseMenuNo;
    	document.getElementById("link").value="forward:"+getLastLink(baseMenuNo);
        //document.menuListForm.chkURL.value=url;
        document.menuListForm.action = "<c:url value='/EgovPageLink.do'/>";
        document.menuListForm.submit();
    }
    function actionLogout()
    {
        document.selectOne.action = "<c:url value='/uat/uia/actionLogout.do'/>";
        document.selectOne.submit();
        //document.location.href = "<c:url value='/j_spring_security_logout'/>";
    }

</script>

<div id="layoutSidenav_nav">
	<nav class="sidenav shadow-right sidenav-light">
		<div class="sidenav-menu">
			<div class="nav accordion" id="accordionSidenav">
				<div class="sidenav-menu-heading">Core</div>
				<a class="nav-link" href="<c:url value='/'/>smart/common/SmartDashBoard.do">
					<div class="nav-link-icon">
						<i data-feather="activity"></i>
					</div>
					대시보드
				</a>
				
				<div class="sidenav-menu-heading">Interface</div>
				<%-- Header Menu --%>
				<c:forEach var="result" items="${list_headmenu}" varStatus="status">
					<c:if test="${result.menuNm != '대시보드' }">
						<a class="nav-link collapsed" href="javascript:void(0);" data-toggle="collapse" data-target="#sub_${result.menuNo}" aria-expanded="false" aria-controls="sub_${result.menuNo}">
							<div class="nav-link-icon">
								<i data-feather="layout"></i>
							</div>
							${result.menuNm}
							<div class="sidenav-collapse-arrow">
								<i class="fas fa-angle-down"></i>
							</div>
						</a>
						
						<%--SubMenu --%>
						<div class="collapse" id="sub_${result.menuNo }" data-parent="#accordionSidenav">
							<nav class="sidenav-menu-nested nav accordion" id="accordionSidenav${result.menuNo }">
								<c:forEach var="resultmenu" items="${list_menulist}" varStatus="status" > 
									<c:if test="${result.menuNo == resultmenu.upperMenuId }">
										<a class="nav-link" href="${pageContext.request.contextPath}${resultmenu.chkURL}?currentMenuNo=${resultmenu.menuNo}">${resultmenu.menuNm }</a>
									</c:if>
						        </c:forEach>
							</nav>
						</div>
					</c:if>
			    </c:forEach>
			</div>
		</div>
		<div class="sidenav-footer">
			<div class="sidenav-footer-content">
				<div class="sidenav-footer-title">SMART MES</div>
				<div class="sidenav-footer-subtitle">CopyRight(c) MITech<br>All Rights Reserved</div>
			</div>
		</div>
	</nav>
</div>
