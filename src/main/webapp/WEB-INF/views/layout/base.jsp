<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="${not empty theme ? theme : 'dark'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="color-scheme" content="dark light">
  <title>${not empty pageTitle ? pageTitle : 'Dashboard'} — MoneyTrail</title>

  <!-- Stylesheets -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap-icons.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/variables.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">

  <c:if test="${not empty extraCss}">
    <c:forEach var="cssFile" items="${extraCss}">
      <link rel="stylesheet" href="${pageContext.request.contextPath}/css/${cssFile}">
    </c:forEach>
  </c:if>
</head>
<body>

<div class="sidebar-backdrop" id="sidebarBackdrop"></div>

<div class="app-wrapper">

  <!-- SIDEBAR -->
  <jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>

  <!-- MAIN AREA -->
  <div class="main-area">

    <!-- HEADER -->
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>

    <!-- CONTENT -->
    <main class="page-content">

      <!-- ALERTS -->
      <jsp:include page="/WEB-INF/views/components/alert.jsp"/>

      <!-- CONTENT PAGE -->
      <jsp:include page="${contentPage}" flush="true"/>

    </main>

    <!-- FOOTER -->
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

  </div>
</div>

<!-- Toast Container -->
<div class="toast-container" id="toastContainer" aria-live="polite" aria-atomic="true"></div>

<!-- Core JS -->
<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/app.js"></script>
<script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/js/theme-switcher.js"></script>

<c:if test="${not empty extraJs}">
  <c:forEach var="jsFile" items="${extraJs}">
    <script src="${pageContext.request.contextPath}/js/${jsFile}"></script>
  </c:forEach>
</c:if>

<c:if test="${not empty inlineScript}">
  <script>${inlineScript}</script>
</c:if>

</body>
</html>
