<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="${not empty theme ? theme : 'dark'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${not empty vendor ? 'Edit' : 'Add'} Vendor — MoneyTrail</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap-icons.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/variables.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">
</head>
<body>
<div class="sidebar-backdrop" id="sidebarBackdrop"></div>
<div class="app-wrapper">
  <jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>
  <div class="main-area">
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
    <main class="page-content">

      <jsp:include page="/WEB-INF/views/components/alert.jsp"/>

      <div class="page-header">
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard"><i class="bi bi-house"></i></a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/listvendor">Vendors</a></li>
            <li class="breadcrumb-item active">${not empty vendor ? 'Edit Vendor' : 'New Vendor'}</li>
          </ol>
        </nav>
        <h1 class="page-title"><i class="bi bi-shop"></i> ${not empty vendor ? 'Edit Vendor' : 'New Vendor'}</h1>
        <p class="page-subtitle">Vendors are the businesses or individuals you transact with.</p>
      </div>

      <div style="max-width:480px;">
        <div class="form-card">
          <div class="form-card-header">
            <div class="form-card-header-icon" style="background:var(--warning-50);color:var(--warning-600);">
              <i class="bi bi-shop"></i>
            </div>
            <div>
              <div class="form-card-title">Vendor Details</div>
              <div class="form-card-subtitle">All fields marked with * are required</div>
            </div>
          </div>

          <form action="${pageContext.request.contextPath}/${not empty vendor ? 'updatevendor' : 'savevendor'}"
                method="POST" id="vendorForm" novalidate>

            <c:if test="${not empty vendor}">
              <input type="hidden" name="vendorId" value="${vendor.vendorId}">
            </c:if>

            <div class="form-card-body">
              <div class="form-group">
                <label class="form-label" for="vendorName">Vendor Name <span class="required">*</span></label>
                <div class="input-wrapper">
                  <i class="bi bi-shop input-icon"></i>
                  <input type="text" id="vendorName" name="vendorName" class="form-input has-icon"
                         placeholder="e.g. Amazon, Zomato, Electricity Board" required maxlength="100"
                         value="${not empty vendor ? vendor.vendorName : ''}">
                </div>
                <span class="form-help">Enter the full name of the vendor or merchant.</span>
              </div>
            </div>

            <div class="form-card-footer">
              <a href="${pageContext.request.contextPath}/listvendor" class="btn btn-secondary">
                <i class="bi bi-x me-1"></i> Cancel
              </a>
              <button type="submit" class="btn btn-primary" id="submitBtn">
                <i class="bi bi-check-lg me-1"></i> ${not empty vendor ? 'Update Vendor' : 'Save Vendor'}
              </button>
            </div>

          </form>
        </div>
      </div>

    </main>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/app.js"></script>
<script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/js/theme-switcher.js"></script>
<script>
  document.getElementById('vendorForm').addEventListener('submit', function(e){
    if(!this.checkValidity()){ e.preventDefault(); this.classList.add('was-validated'); return; }
    const btn = document.getElementById('submitBtn');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Saving...';
  });
</script>
</body>
</html>
