<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="${not empty theme ? theme : 'dark'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Vendors — MoneyTrail</title>
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
            <li class="breadcrumb-item active">Vendors</li>
          </ol>
        </nav>
        <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
          <div>
            <h1 class="page-title"><i class="bi bi-shop"></i> Vendors</h1>
            <p class="page-subtitle">Manage the vendors and suppliers linked to your expense transactions</p>
          </div>
          <a href="${pageContext.request.contextPath}/addvendor" class="btn btn-primary">
            <i class="bi bi-plus-lg me-1"></i> Add Vendor
          </a>
        </div>
      </div>
      <div class="card">
        <div class="card-header">
          <div class="card-title">All Vendors <span class="badge badge-neutral ms-2">${vendorPage.totalElements}</span></div>
          <form method="get" action="${pageContext.request.contextPath}/listvendor" class="d-flex align-items-center gap-2">
            <div class="search-box" style="min-width:240px;">
              <i class="bi bi-search" style="color:var(--text-muted);font-size:13px;"></i>
              <input type="text" name="keyword" value="${keyword}" placeholder="Search vendors...">
            </div>
            <input type="hidden" name="sortBy"    value="${sortBy}">
            <input type="hidden" name="direction" value="${direction}">
            <input type="hidden" name="size"      value="${vendorPage.size}">
            <button type="submit" class="btn btn-secondary btn-sm">Search</button>
            <c:if test="${not empty keyword}"><a href="${pageContext.request.contextPath}/listvendor" class="btn btn-secondary btn-sm">Clear</a></c:if>
          </form>
        </div>
        <div class="card-body p-0">
          <c:choose>
            <c:when test="${vendorPage.totalElements == 0}">
              <div class="empty-state">
                <div class="empty-state-icon"><i class="bi bi-shop"></i></div>
                <p class="empty-state-title">No vendors yet</p>
                <p class="empty-state-desc">Add vendors to associate them with your expense transactions for better tracking.</p>
                <a href="${pageContext.request.contextPath}/addvendor" class="btn btn-primary mt-3"><i class="bi bi-plus-lg me-1"></i> Add Vendor</a>
              </div>
            </c:when>
            <c:otherwise>
              <c:url value="/listvendor" var="baseUrl">
                <c:param name="keyword" value="${keyword}"/>
                <c:param name="size"    value="${vendorPage.size}"/>
              </c:url>
              <div class="table-responsive">
                <table class="table" id="vendorTable">
                  <thead>
                    <tr>
                      <th>#</th>
                      <th>
                        <c:url value="/listvendor" var="sortUrlName">
                          <c:param name="keyword"   value="${keyword}"/>
                          <c:param name="sortBy"    value="vendorName"/>
                          <c:param name="direction" value="${sortBy == 'vendorName' && direction == 'asc' ? 'desc' : 'asc'}"/>
                          <c:param name="size"      value="${vendorPage.size}"/>
                          <c:param name="page"      value="0"/>
                        </c:url>
                        <a href="${sortUrlName}" style="color:inherit;text-decoration:none;">
                          Vendor
                          <c:choose>
                            <c:when test="${sortBy == 'vendorName' && direction == 'asc'}"><i class="bi bi-arrow-up-short"></i></c:when>
                            <c:when test="${sortBy == 'vendorName' && direction == 'desc'}"><i class="bi bi-arrow-down-short"></i></c:when>
                            <c:otherwise><i class="bi bi-arrow-down-up" style="opacity:0.3;"></i></c:otherwise>
                          </c:choose>
                        </a>
                      </th>
                      <th class="text-center">Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="vendor" items="${vendorPage.content}" varStatus="st">
                      <tr>
                        <td class="text-muted-color text-sm">${vendorPage.number * vendorPage.size + st.index + 1}</td>
                        <td>
                          <div class="d-flex align-items-center gap-3">
                            <div class="vendor-initial" style="background:var(--warning-50);color:var(--warning-600);font-weight:700;font-size:var(--text-base);">
                              ${not empty vendor.vendorName ? vendor.vendorName.substring(0,1).toUpperCase() : 'V'}
                            </div>
                            <div>
                              <div class="fw-600 text-sm">${vendor.vendorName}</div>
                              <div class="text-xs text-muted-color">ID: #${vendor.vendorId}</div>
                            </div>
                          </div>
                        </td>
                        <td class="text-center">
                          <div class="action-btns">
                            <a href="${pageContext.request.contextPath}/editvendor?vendorId=${vendor.vendorId}" class="btn-icon edit" title="Edit Vendor"><i class="bi bi-pencil"></i></a>
                            <a href="${pageContext.request.contextPath}/deletevendor?vendorId=${vendor.vendorId}" class="btn-icon del" title="Delete Vendor" onclick="return confirmDelete('${vendor.vendorName}')"><i class="bi bi-trash"></i></a>
                          </div>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>
              <div class="d-flex align-items-center justify-content-between px-5 py-3" style="border-top:1px solid var(--border-color);">
                <span class="text-sm text-muted-color">
                  Showing ${vendorPage.number * vendorPage.size + 1}–${vendorPage.number * vendorPage.size + vendorPage.numberOfElements}
                  of ${vendorPage.totalElements} vendor(s)
                  <c:if test="${not empty keyword}"> for "<strong>${keyword}</strong>"</c:if>
                </span>
                <c:if test="${vendorPage.totalPages > 1}">
                  <div class="pagination">
                    <c:choose>
                      <c:when test="${vendorPage.first}"><button class="page-btn" disabled><i class="bi bi-chevron-left"></i></button></c:when>
                      <c:otherwise><a href="${baseUrl}&sortBy=${sortBy}&direction=${direction}&page=${vendorPage.number - 1}" class="page-btn"><i class="bi bi-chevron-left"></i></a></c:otherwise>
                    </c:choose>
                    <c:set var="startPage" value="${vendorPage.number > 2 ? vendorPage.number - 2 : 0}"/>
                    <c:set var="endPage"   value="${vendorPage.number + 2 < vendorPage.totalPages ? vendorPage.number + 2 : vendorPage.totalPages - 1}"/>
                    <c:forEach begin="${startPage}" end="${endPage}" var="p">
                      <a href="${baseUrl}&sortBy=${sortBy}&direction=${direction}&page=${p}" class="page-btn ${p == vendorPage.number ? 'active' : ''}">${p + 1}</a>
                    </c:forEach>
                    <c:choose>
                      <c:when test="${vendorPage.last}"><button class="page-btn" disabled><i class="bi bi-chevron-right"></i></button></c:when>
                      <c:otherwise><a href="${baseUrl}&sortBy=${sortBy}&direction=${direction}&page=${vendorPage.number + 1}" class="page-btn"><i class="bi bi-chevron-right"></i></a></c:otherwise>
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
function confirmDelete(name) { return confirm('Delete vendor "' + name + '"?\nThis action cannot be undone.'); }
</script>
</body>
</html>
