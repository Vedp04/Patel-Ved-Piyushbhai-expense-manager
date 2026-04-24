<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="${not empty theme ? theme : 'dark'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${not empty subCategory ? 'Edit' : 'Add'} Sub-Category — MoneyTrail</title>
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
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/listsubcategory">Sub-Categories</a></li>
            <li class="breadcrumb-item active">${not empty subCategory ? 'Edit Sub-Category' : 'New Sub-Category'}</li>
          </ol>
        </nav>
        <h1 class="page-title"><i class="bi bi-diagram-3-fill"></i> ${not empty subCategory ? 'Edit Sub-Category' : 'New Sub-Category'}</h1>
        <p class="page-subtitle">Sub-categories provide finer detail under each main category.</p>
      </div>

      <div style="max-width:560px;">
        <div class="form-card">
          <div class="form-card-header">
            <div class="form-card-header-icon"><i class="bi bi-diagram-3-fill"></i></div>
            <div>
              <div class="form-card-title">Sub-Category Details</div>
              <div class="form-card-subtitle">All fields marked with * are required</div>
            </div>
          </div>

          <form action="${pageContext.request.contextPath}/${not empty subCategory ? 'updatesubcategory' : 'savesubcategory'}"
                method="POST" id="subCategoryForm" novalidate>

            <c:if test="${not empty subCategory}">
              <input type="hidden" name="subCategoryId" value="${subCategory.subCategoryId}">
            </c:if>

            <div class="form-card-body">

              <div class="form-group">
                <label class="form-label" for="categoryId">Parent Category <span class="required">*</span></label>
                <select id="categoryId" name="categoryId" class="form-select" required>
                  <option value="">— Select Category —</option>
                  <c:forEach var="cat" items="${categoryList}">
                    <option value="${cat.categoryId}"
                            ${not empty subCategory && subCategory.categoryId == cat.categoryId ? 'selected' : ''}>
                      ${cat.categoryName} (${cat.categoryType})
                    </option>
                  </c:forEach>
                </select>
              </div>

              <div class="form-group">
                <label class="form-label" for="subCategoryName">Sub-Category Name <span class="required">*</span></label>
                <div class="input-wrapper">
                  <i class="bi bi-diagram-3 input-icon"></i>
                  <input type="text" id="subCategoryName" name="subCategoryName" class="form-input has-icon"
                         placeholder="e.g. Groceries" required maxlength="100"
                         value="${not empty subCategory ? subCategory.subCategoryName : ''}">
                </div>
              </div>

            </div>

            <div class="form-card-footer">
              <a href="${pageContext.request.contextPath}/listsubcategory" class="btn btn-secondary">
                <i class="bi bi-x me-1"></i> Cancel
              </a>
              <button type="submit" class="btn btn-primary" id="submitBtn">
                <i class="bi bi-check-lg me-1"></i> ${not empty subCategory ? 'Update' : 'Save Sub-Category'}
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
  document.getElementById('subCategoryForm').addEventListener('submit', function(e){
    if(!this.checkValidity()){ e.preventDefault(); this.classList.add('was-validated'); return; }
    const btn = document.getElementById('submitBtn');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Saving...';
  });
</script>
</body>
</html>
