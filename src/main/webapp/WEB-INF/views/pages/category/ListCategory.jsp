<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="${not empty theme ? theme : 'dark'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Categories — MoneyTrail</title>
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
            <li class="breadcrumb-item active">Categories</li>
          </ol>
        </nav>
        <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
          <div>
            <h1 class="page-title"><i class="bi bi-tag-fill"></i> Categories</h1>
            <p class="page-subtitle">Organise your transactions with income and expense categories</p>
          </div>
          <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/listsubcategory" class="btn btn-secondary"><i class="bi bi-diagram-3 me-1"></i> Sub-Categories</a>
            <a href="${pageContext.request.contextPath}/addcategory" class="btn btn-primary"><i class="bi bi-plus-lg me-1"></i> Add Category</a>
          </div>
        </div>
      </div>
      <div class="card">
        <div class="card-header">
          <div class="card-title">All Categories <span class="badge badge-neutral ms-2">${categoryPage.totalElements}</span></div>
          <form method="get" action="${pageContext.request.contextPath}/listcategory" class="d-flex align-items-center gap-2">
            <div class="search-box" style="min-width:240px;">
              <i class="bi bi-search" style="color:var(--text-muted);font-size:13px;"></i>
              <input type="text" name="keyword" value="${keyword}" placeholder="Search categories...">
            </div>
            <input type="hidden" name="sortBy"    value="${sortBy}">
            <input type="hidden" name="direction" value="${direction}">
            <input type="hidden" name="size"      value="${categoryPage.size}">
            <button type="submit" class="btn btn-secondary btn-sm">Search</button>
            <c:if test="${not empty keyword}"><a href="${pageContext.request.contextPath}/listcategory" class="btn btn-secondary btn-sm">Clear</a></c:if>
          </form>
        </div>
        <div class="card-body p-0">
          <c:choose>
            <c:when test="${categoryPage.totalElements == 0}">
              <div class="empty-state">
                <div class="empty-state-icon"><i class="bi bi-tag"></i></div>
                <p class="empty-state-title">No categories yet</p>
                <p class="empty-state-desc">Add categories to group your income and expense transactions.</p>
                <a href="${pageContext.request.contextPath}/addcategory" class="btn btn-primary mt-3"><i class="bi bi-plus-lg me-1"></i> Add Category</a>
              </div>
            </c:when>
            <c:otherwise>
              <c:url value="/listcategory" var="baseUrl">
                <c:param name="keyword" value="${keyword}"/>
                <c:param name="size"    value="${categoryPage.size}"/>
              </c:url>
              <div class="table-responsive">
                <table class="table" id="categoryTable">
                  <thead>
                    <tr>
                      <th>#</th>
                      <th>
                        <c:url value="/listcategory" var="sortUrlName">
                          <c:param name="keyword"   value="${keyword}"/>
                          <c:param name="sortBy"    value="categoryName"/>
                          <c:param name="direction" value="${sortBy == 'categoryName' && direction == 'asc' ? 'desc' : 'asc'}"/>
                          <c:param name="size"      value="${categoryPage.size}"/>
                          <c:param name="page"      value="0"/>
                        </c:url>
                        <a href="${sortUrlName}" style="color:inherit;text-decoration:none;">
                          Category Name
                          <c:choose>
                            <c:when test="${sortBy == 'categoryName' && direction == 'asc'}"><i class="bi bi-arrow-up-short"></i></c:when>
                            <c:when test="${sortBy == 'categoryName' && direction == 'desc'}"><i class="bi bi-arrow-down-short"></i></c:when>
                            <c:otherwise><i class="bi bi-arrow-down-up" style="opacity:0.3;"></i></c:otherwise>
                          </c:choose>
                        </a>
                      </th>
                      <th>
                        <c:url value="/listcategory" var="sortUrlType">
                          <c:param name="keyword"   value="${keyword}"/>
                          <c:param name="sortBy"    value="categoryType"/>
                          <c:param name="direction" value="${sortBy == 'categoryType' && direction == 'asc' ? 'desc' : 'asc'}"/>
                          <c:param name="size"      value="${categoryPage.size}"/>
                          <c:param name="page"      value="0"/>
                        </c:url>
                        <a href="${sortUrlType}" style="color:inherit;text-decoration:none;">
                          Type
                          <c:choose>
                            <c:when test="${sortBy == 'categoryType' && direction == 'asc'}"><i class="bi bi-arrow-up-short"></i></c:when>
                            <c:when test="${sortBy == 'categoryType' && direction == 'desc'}"><i class="bi bi-arrow-down-short"></i></c:when>
                            <c:otherwise><i class="bi bi-arrow-down-up" style="opacity:0.3;"></i></c:otherwise>
                          </c:choose>
                        </a>
                      </th>
                      <th class="text-center">Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="cat" items="${categoryPage.content}" varStatus="st">
                      <tr>
                        <td class="text-muted-color text-sm">${categoryPage.number * categoryPage.size + st.index + 1}</td>
                        <td>
                          <div class="d-flex align-items-center gap-3">
                            <div class="vendor-initial"
                                 style="background:${cat.categoryType == 'INCOME' ? 'var(--success-50)' : cat.categoryType == 'EXPENSE' ? 'var(--danger-50)' : 'var(--accent-50)'};
                                        color:${cat.categoryType == 'INCOME' ? 'var(--income-color)' : cat.categoryType == 'EXPENSE' ? 'var(--expense-color)' : 'var(--accent-500)'};">
                              <i class="bi bi-tag-fill" style="font-size:14px;"></i>
                            </div>
                            <div>
                              <div class="fw-600 text-sm">${cat.categoryName}</div>
                              <div class="text-xs text-muted-color">ID: #${cat.categoryId}</div>
                            </div>
                          </div>
                        </td>
                        <td>
                          <c:choose>
                            <c:when test="${cat.categoryType == 'INCOME'}"><span class="badge badge-success"><i class="bi bi-arrow-down-circle-fill me-1"></i>Income</span></c:when>
                            <c:when test="${cat.categoryType == 'EXPENSE'}"><span class="badge badge-danger"><i class="bi bi-arrow-up-circle-fill me-1"></i>Expense</span></c:when>
                            <c:otherwise><span class="badge badge-accent"><i class="bi bi-arrow-left-right me-1"></i>Both</span></c:otherwise>
                          </c:choose>
                        </td>
                        <td class="text-center">
                          <div class="action-btns">
                            <a href="${pageContext.request.contextPath}/editcategory?categoryId=${cat.categoryId}" class="btn-icon edit" title="Edit"><i class="bi bi-pencil"></i></a>
                            <a href="${pageContext.request.contextPath}/deletecategory?categoryId=${cat.categoryId}" class="btn-icon del" title="Delete" onclick="return confirmDelete('${cat.categoryName}')"><i class="bi bi-trash"></i></a>
                          </div>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>
              <div class="d-flex align-items-center justify-content-between px-5 py-3" style="border-top:1px solid var(--border-color);">
                <span class="text-sm text-muted-color">
                  Showing ${categoryPage.number * categoryPage.size + 1}–${categoryPage.number * categoryPage.size + categoryPage.numberOfElements}
                  of ${categoryPage.totalElements} categor${categoryPage.totalElements == 1 ? 'y' : 'ies'}
                  <c:if test="${not empty keyword}"> for "<strong>${keyword}</strong>"</c:if>
                </span>
                <c:if test="${categoryPage.totalPages > 1}">
                  <div class="pagination">
                    <c:choose>
                      <c:when test="${categoryPage.first}"><button class="page-btn" disabled><i class="bi bi-chevron-left"></i></button></c:when>
                      <c:otherwise><a href="${baseUrl}&sortBy=${sortBy}&direction=${direction}&page=${categoryPage.number - 1}" class="page-btn"><i class="bi bi-chevron-left"></i></a></c:otherwise>
                    </c:choose>
                    <c:set var="startPage" value="${categoryPage.number > 2 ? categoryPage.number - 2 : 0}"/>
                    <c:set var="endPage"   value="${categoryPage.number + 2 < categoryPage.totalPages ? categoryPage.number + 2 : categoryPage.totalPages - 1}"/>
                    <c:forEach begin="${startPage}" end="${endPage}" var="p">
                      <a href="${baseUrl}&sortBy=${sortBy}&direction=${direction}&page=${p}" class="page-btn ${p == categoryPage.number ? 'active' : ''}">${p + 1}</a>
                    </c:forEach>
                    <c:choose>
                      <c:when test="${categoryPage.last}"><button class="page-btn" disabled><i class="bi bi-chevron-right"></i></button></c:when>
                      <c:otherwise><a href="${baseUrl}&sortBy=${sortBy}&direction=${direction}&page=${categoryPage.number + 1}" class="page-btn"><i class="bi bi-chevron-right"></i></a></c:otherwise>
                    </c:choose>
                  </div>
                </c:if>
              </div>
            </c:otherwise>
          </c:choose>
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
function confirmDelete(name) { return confirm('Delete category "' + name + '"? This cannot be undone.'); }
</script>
</body>
</html>
