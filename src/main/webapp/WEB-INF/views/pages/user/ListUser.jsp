<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="${not empty theme ? theme : 'dark'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Users — MoneyTrail</title>
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
            <li class="breadcrumb-item active">Users</li>
          </ol>
        </nav>
        <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
          <div>
            <h1 class="page-title"><i class="bi bi-people-fill"></i> Users</h1>
            <p class="page-subtitle">Manage platform users and their access roles</p>
          </div>
        </div>
      </div>
      <div class="card">
        <div class="card-header">
          <div class="card-title">All Users <span class="badge badge-neutral ms-2">${userPage.totalElements}</span></div>
          <form method="get" action="${pageContext.request.contextPath}/listuser" class="d-flex align-items-center gap-2">
            <div class="search-box" style="min-width:240px;">
              <i class="bi bi-search" style="color:var(--text-muted);font-size:13px;"></i>
              <input type="text" name="keyword" value="${keyword}" placeholder="Search users...">
            </div>
            <input type="hidden" name="sortBy"    value="${sortBy}">
            <input type="hidden" name="direction" value="${direction}">
            <input type="hidden" name="size"      value="${userPage.size}">
            <button type="submit" class="btn btn-secondary btn-sm">Search</button>
            <c:if test="${not empty keyword}"><a href="${pageContext.request.contextPath}/listuser" class="btn btn-secondary btn-sm">Clear</a></c:if>
          </form>
        </div>
        <div class="card-body p-0">
          <c:choose>
            <c:when test="${userPage.totalElements == 0}">
              <div class="empty-state">
                <div class="empty-state-icon"><i class="bi bi-people"></i></div>
                <p class="empty-state-title">No users found</p>
                <p class="empty-state-desc">Users who sign up will appear here.</p>
              </div>
            </c:when>
            <c:otherwise>
              <c:url value="/listuser" var="baseUrl">
                <c:param name="keyword" value="${keyword}"/>
                <c:param name="size"    value="${userPage.size}"/>
              </c:url>
              <div class="table-responsive">
                <table class="table" id="userTable">
                  <thead>
                    <tr>
                      <th>#</th>
                      <th>
                        <c:url value="/listuser" var="sortUrlName">
                          <c:param name="keyword"   value="${keyword}"/>
                          <c:param name="sortBy"    value="firstName"/>
                          <c:param name="direction" value="${sortBy == 'firstName' && direction == 'asc' ? 'desc' : 'asc'}"/>
                          <c:param name="size"      value="${userPage.size}"/>
                          <c:param name="page"      value="0"/>
                        </c:url>
                        <a href="${sortUrlName}" style="color:inherit;text-decoration:none;">
                          User
                          <c:choose>
                            <c:when test="${sortBy == 'firstName' && direction == 'asc'}"><i class="bi bi-arrow-up-short"></i></c:when>
                            <c:when test="${sortBy == 'firstName' && direction == 'desc'}"><i class="bi bi-arrow-down-short"></i></c:when>
                            <c:otherwise><i class="bi bi-arrow-down-up" style="opacity:0.3;"></i></c:otherwise>
                          </c:choose>
                        </a>
                      </th>
                      <th>
                        <c:url value="/listuser" var="sortUrlEmail">
                          <c:param name="keyword"   value="${keyword}"/>
                          <c:param name="sortBy"    value="email"/>
                          <c:param name="direction" value="${sortBy == 'email' && direction == 'asc' ? 'desc' : 'asc'}"/>
                          <c:param name="size"      value="${userPage.size}"/>
                          <c:param name="page"      value="0"/>
                        </c:url>
                        <a href="${sortUrlEmail}" style="color:inherit;text-decoration:none;">
                          Email
                          <c:choose>
                            <c:when test="${sortBy == 'email' && direction == 'asc'}"><i class="bi bi-arrow-up-short"></i></c:when>
                            <c:when test="${sortBy == 'email' && direction == 'desc'}"><i class="bi bi-arrow-down-short"></i></c:when>
                            <c:otherwise><i class="bi bi-arrow-down-up" style="opacity:0.3;"></i></c:otherwise>
                          </c:choose>
                        </a>
                      </th>
                      <th>Role</th>
                      <th>Status</th>
                      <th class="text-center">Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="u" items="${userPage.content}" varStatus="st">
                      <tr>
                        <td class="text-muted-color text-sm">${userPage.number * userPage.size + st.index + 1}</td>
                        <td>
                          <div class="d-flex align-items-center gap-3">
                            <div class="vendor-initial" style="background:linear-gradient(135deg,var(--brand-400),var(--accent-500));color:#fff;">
                              ${not empty u.firstName ? u.firstName.substring(0,1).toUpperCase() : 'U'}
                            </div>
                            <div>
                              <div class="fw-600 text-sm">${u.firstName}</div>
                              <div class="text-xs text-muted-color">ID: #${u.userId}</div>
                            </div>
                          </div>
                        </td>
                        <td class="text-sm text-muted-color">${u.email}</td>
                        <td><span class="badge ${u.role == 'ADMIN' ? 'badge-accent' : 'badge-neutral'}">${u.role}</span></td>
                        <td>
                          <span class="badge ${u.active ? 'badge-success badge-dot' : 'badge-danger badge-dot'}">
                            ${u.active ? 'Active' : 'Inactive'}
                          </span>
                        </td>
                        <td class="text-center">
                          <div class="action-btns">
                            <a href="${pageContext.request.contextPath}/viewuser?userId=${u.userId}" class="btn-icon edit" title="View User"><i class="bi bi-eye"></i></a>
                            <a href="${pageContext.request.contextPath}/deleteuser?userId=${u.userId}" class="btn-icon del" title="Delete" onclick="return confirmDelete('${u.firstName}')"><i class="bi bi-trash"></i></a>
                            <button class="btn-icon toggle-user-btn" data-user-id="${u.userId}" data-user-name="${u.firstName}" data-active="${u.active}" title="${u.active ? 'Deactivate' : 'Activate'}">
                              <i class="bi bi-${u.active ? 'person-dash' : 'person-check'}"></i>
                            </button>
                          </div>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>
              <div class="d-flex align-items-center justify-content-between px-5 py-3" style="border-top:1px solid var(--border-color);">
                <span class="text-sm text-muted-color">
                  Showing ${userPage.number * userPage.size + 1}–${userPage.number * userPage.size + userPage.numberOfElements}
                  of ${userPage.totalElements} user(s)
                  <c:if test="${not empty keyword}"> for "<strong>${keyword}</strong>"</c:if>
                </span>
                <c:if test="${userPage.totalPages > 1}">
                  <div class="pagination">
                    <c:choose>
                      <c:when test="${userPage.first}"><button class="page-btn" disabled><i class="bi bi-chevron-left"></i></button></c:when>
                      <c:otherwise><a href="${baseUrl}&sortBy=${sortBy}&direction=${direction}&page=${userPage.number - 1}" class="page-btn"><i class="bi bi-chevron-left"></i></a></c:otherwise>
                    </c:choose>
                    <c:set var="startPage" value="${userPage.number > 2 ? userPage.number - 2 : 0}"/>
                    <c:set var="endPage"   value="${userPage.number + 2 < userPage.totalPages ? userPage.number + 2 : userPage.totalPages - 1}"/>
                    <c:forEach begin="${startPage}" end="${endPage}" var="p">
                      <a href="${baseUrl}&sortBy=${sortBy}&direction=${direction}&page=${p}" class="page-btn ${p == userPage.number ? 'active' : ''}">${p + 1}</a>
                    </c:forEach>
                    <c:choose>
                      <c:when test="${userPage.last}"><button class="page-btn" disabled><i class="bi bi-chevron-right"></i></button></c:when>
                      <c:otherwise><a href="${baseUrl}&sortBy=${sortBy}&direction=${direction}&page=${userPage.number + 1}" class="page-btn"><i class="bi bi-chevron-right"></i></a></c:otherwise>
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
<script>const contextPath = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/js/app.js"></script>
<script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/js/theme-switcher.js"></script>
<script>
function confirmDelete(name) { return confirm('Delete user "' + name + '"? This cannot be undone.'); }
</script>
</body>
</html>
