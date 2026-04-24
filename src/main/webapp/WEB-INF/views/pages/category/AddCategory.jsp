<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="${not empty theme ? theme : 'dark'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${not empty category ? 'Edit' : 'Add'} Category — MoneyTrail</title>
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
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/listcategory">Categories</a></li>
            <li class="breadcrumb-item active">${not empty category ? 'Edit Category' : 'New Category'}</li>
          </ol>
        </nav>
        <h1 class="page-title"><i class="bi bi-tag-fill"></i> ${not empty category ? 'Edit Category' : 'New Category'}</h1>
        <p class="page-subtitle">Categories help organise your income and expense transactions.</p>
      </div>

      <div style="max-width:560px;">
        <div class="form-card">
          <div class="form-card-header">
            <div class="form-card-header-icon"><i class="bi bi-tag-fill"></i></div>
            <div>
              <div class="form-card-title">Category Details</div>
              <div class="form-card-subtitle">All fields marked with * are required</div>
            </div>
          </div>

          <form action="${pageContext.request.contextPath}/${not empty category ? 'updatecategory' : 'savecategory'}"
                method="POST" id="categoryForm" novalidate>

            <c:if test="${not empty category}">
              <input type="hidden" name="categoryId" value="${category.categoryId}">
            </c:if>

            <div class="form-card-body">

              <div class="form-group">
                <label class="form-label" for="categoryName">Category Name <span class="required">*</span></label>
                <div class="input-wrapper">
                  <i class="bi bi-tag input-icon"></i>
                  <input type="text" id="categoryName" name="categoryName" class="form-input has-icon"
                         placeholder="e.g. Food &amp; Dining" required maxlength="100"
                         value="${not empty category ? category.categoryName : ''}">
                </div>
              </div>

              <div class="form-group">
                <label class="form-label">Category Type <span class="required">*</span></label>
                <div class="type-toggle" id="typeTabs">
                  <label class="type-chip ${category.categoryType == 'EXPENSE' || empty category ? 'selected' : ''}">
                    <input type="radio" name="categoryType" value="EXPENSE"
                           ${category.categoryType == 'INCOME' ? '' : 'checked'}>
                    <i class="bi bi-arrow-up-circle-fill" style="color:var(--expense-color);"></i> Expense
                  </label>
                  <label class="type-chip ${category.categoryType == 'INCOME' ? 'selected' : ''}">
                    <input type="radio" name="categoryType" value="INCOME"
                           ${category.categoryType == 'INCOME' ? 'checked' : ''}>
                    <i class="bi bi-arrow-down-circle-fill" style="color:var(--income-color);"></i> Income
                  </label>
                  <label class="type-chip ${category.categoryType == 'BOTH' ? 'selected' : ''}">
                    <input type="radio" name="categoryType" value="BOTH"
                           ${category.categoryType == 'BOTH' ? 'checked' : ''}>
                    <i class="bi bi-arrow-left-right" style="color:var(--accent-500);"></i> Both
                  </label>
                </div>
              </div>

            </div>

            <div class="form-card-footer">
              <a href="${pageContext.request.contextPath}/listcategory" class="btn btn-secondary">
                <i class="bi bi-x me-1"></i> Cancel
              </a>
              <button type="submit" class="btn btn-primary" id="submitBtn">
                <i class="bi bi-check-lg me-1"></i> ${not empty category ? 'Update' : 'Save Category'}
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
  // Type chip toggle
  document.querySelectorAll('.type-chip').forEach(chip => {
    chip.addEventListener('click', function(){
      document.querySelectorAll('.type-chip').forEach(c => c.classList.remove('selected'));
      this.classList.add('selected');
    });
  });
  document.getElementById('categoryForm').addEventListener('submit', function(e){
    if(!this.checkValidity()){ e.preventDefault(); this.classList.add('was-validated'); return; }
    const btn = document.getElementById('submitBtn');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Saving...';
  });
</script>
</body>
</html>
