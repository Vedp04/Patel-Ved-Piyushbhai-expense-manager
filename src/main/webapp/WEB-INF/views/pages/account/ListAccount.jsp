<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="${not empty theme ? theme : 'dark'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Accounts — MoneyTrail</title>
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
            <li class="breadcrumb-item active">Accounts</li>
          </ol>
        </nav>
        <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
          <div>
            <h1 class="page-title"><i class="bi bi-bank2"></i> Accounts</h1>
            <p class="page-subtitle">Manage your bank accounts, wallets, and cash holdings</p>
          </div>
          <a href="${pageContext.request.contextPath}/addaccount" class="btn btn-primary">
            <i class="bi bi-plus-lg me-1"></i> Add Account
          </a>
        </div>
      </div>

      <div class="card">
        <div class="card-header">
          <div class="card-title">
            All Accounts
            <span class="badge badge-neutral ms-2">${accountPage.totalElements}</span>
          </div>
          <form method="get" action="${pageContext.request.contextPath}/listaccount" class="d-flex align-items-center gap-2">
            <div class="search-box" style="min-width:240px;">
              <i class="bi bi-search" style="color:var(--text-muted);font-size:13px;"></i>
              <input type="text" name="keyword" value="${keyword}" placeholder="Search accounts...">
            </div>
            <input type="hidden" name="sortBy"    value="${sortBy}">
            <input type="hidden" name="direction" value="${direction}">
            <input type="hidden" name="size"      value="${accountPage.size}">
            <button type="submit" class="btn btn-secondary btn-sm">Search</button>
            <c:if test="${not empty keyword}">
              <a href="${pageContext.request.contextPath}/listaccount" class="btn btn-secondary btn-sm">Clear</a>
            </c:if>
          </form>
        </div>
        <div class="card-body p-0">
          <c:choose>
            <c:when test="${accountPage.totalElements == 0}">
              <div class="empty-state">
                <div class="empty-state-icon"><i class="bi bi-bank2"></i></div>
                <p class="empty-state-title">No accounts yet</p>
                <p class="empty-state-desc">Add your first account to start tracking balances and transactions.</p>
                <a href="${pageContext.request.contextPath}/addaccount" class="btn btn-primary mt-3">
                  <i class="bi bi-plus-lg me-1"></i> Add Account
                </a>
              </div>
            </c:when>
            <c:otherwise>
              <%-- Build base URL for sort/pagination links --%>
              <c:url value="/listaccount" var="baseUrl">
                <c:param name="keyword"   value="${keyword}"/>
                <c:param name="size"      value="${accountPage.size}"/>
              </c:url>
              <div class="table-responsive">
                <table class="table" id="accountTable">
                  <thead>
                    <tr>
                      <th>#</th>
                      <th>
                        <c:url value="/listaccount" var="sortUrlName">
                          <c:param name="keyword"   value="${keyword}"/>
                          <c:param name="sortBy"    value="accountName"/>
                          <c:param name="direction" value="${sortBy == 'accountName' && direction == 'asc' ? 'desc' : 'asc'}"/>
                          <c:param name="size"      value="${accountPage.size}"/>
                          <c:param name="page"      value="0"/>
                        </c:url>
                        <a href="${sortUrlName}" style="color:inherit;text-decoration:none;">
                          Account
                          <c:choose>
                            <c:when test="${sortBy == 'accountName' && direction == 'asc'}"><i class="bi bi-arrow-up-short"></i></c:when>
                            <c:when test="${sortBy == 'accountName' && direction == 'desc'}"><i class="bi bi-arrow-down-short"></i></c:when>
                            <c:otherwise><i class="bi bi-arrow-down-up" style="opacity:0.3;"></i></c:otherwise>
                          </c:choose>
                        </a>
                      </th>
                      <th>
                        <c:url value="/listaccount" var="sortUrlType">
                          <c:param name="keyword"   value="${keyword}"/>
                          <c:param name="sortBy"    value="accountType"/>
                          <c:param name="direction" value="${sortBy == 'accountType' && direction == 'asc' ? 'desc' : 'asc'}"/>
                          <c:param name="size"      value="${accountPage.size}"/>
                          <c:param name="page"      value="0"/>
                        </c:url>
                        <a href="${sortUrlType}" style="color:inherit;text-decoration:none;">
                          Type
                          <c:choose>
                            <c:when test="${sortBy == 'accountType' && direction == 'asc'}"><i class="bi bi-arrow-up-short"></i></c:when>
                            <c:when test="${sortBy == 'accountType' && direction == 'desc'}"><i class="bi bi-arrow-down-short"></i></c:when>
                            <c:otherwise><i class="bi bi-arrow-down-up" style="opacity:0.3;"></i></c:otherwise>
                          </c:choose>
                        </a>
                      </th>
                      <th>Bank</th>
                      <th>
                        <c:url value="/listaccount" var="sortUrlBalance">
                          <c:param name="keyword"   value="${keyword}"/>
                          <c:param name="sortBy"    value="openingBalance"/>
                          <c:param name="direction" value="${sortBy == 'openingBalance' && direction == 'asc' ? 'desc' : 'asc'}"/>
                          <c:param name="size"      value="${accountPage.size}"/>
                          <c:param name="page"      value="0"/>
                        </c:url>
                        <a href="${sortUrlBalance}" style="color:inherit;text-decoration:none;">
                          Opening Balance
                          <c:choose>
                            <c:when test="${sortBy == 'openingBalance' && direction == 'asc'}"><i class="bi bi-arrow-up-short"></i></c:when>
                            <c:when test="${sortBy == 'openingBalance' && direction == 'desc'}"><i class="bi bi-arrow-down-short"></i></c:when>
                            <c:otherwise><i class="bi bi-arrow-down-up" style="opacity:0.3;"></i></c:otherwise>
                          </c:choose>
                        </a>
                      </th>
                      <th>Default</th>
                      <th class="text-center">Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="acc" items="${accountPage.content}" varStatus="st">
                      <tr>
                        <td class="text-muted-color text-sm">${accountPage.number * accountPage.size + st.index + 1}</td>
                        <td>
                          <div class="d-flex align-items-center gap-3">
                            <div class="vendor-initial" style="background:var(--brand-50);color:var(--brand-600);">
                              <i class="bi bi-bank2" style="font-size:15px;"></i>
                            </div>
                            <div>
                              <div class="fw-600 text-sm">${acc.accountName}</div>
                              <div class="text-xs text-muted-color">ID: #${acc.accountId}</div>
                            </div>
                          </div>
                        </td>
                        <td>
                          <span class="badge badge-accent">${acc.accountType}</span>
                        </td>
                        <td class="text-sm text-muted-color">${acc.bankName}</td>
                        <td>
                          <span class="fw-600 text-sm" style="font-family:var(--font-mono);">
                            ₹<fmt:formatNumber value="${acc.openingBalance}" pattern="#,##0.00"/>
                          </span>
                        </td>
                        <td>
                          <c:choose>
                            <c:when test="${acc.exDefault}">
                              <span class="badge badge-success badge-dot">Default</span>
                            </c:when>
                            <c:otherwise>
                              <span class="text-muted-color text-xs">—</span>
                            </c:otherwise>
                          </c:choose>
                        </td>
                        <td class="text-center">
                          <div class="action-btns">
                            <a href="${pageContext.request.contextPath}/editaccount?accountId=${acc.accountId}"
                               class="btn-icon edit" title="Edit Account">
                              <i class="bi bi-pencil"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/deleteaccount?accountId=${acc.accountId}"
                               class="btn-icon del" title="Delete Account"
                               onclick="return confirmDelete('${acc.accountName}')">
                              <i class="bi bi-trash"></i>
                            </a>
                          </div>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>
              <%-- Pagination Controls --%>
              <div class="d-flex align-items-center justify-content-between px-5 py-3" style="border-top:1px solid var(--border-color);">
                <span class="text-sm text-muted-color">
                  <c:choose>
                    <c:when test="${accountPage.totalElements == 0}">No accounts found</c:when>
                    <c:otherwise>
                      Showing ${accountPage.number * accountPage.size + 1}–${accountPage.number * accountPage.size + accountPage.numberOfElements}
                      of ${accountPage.totalElements} account(s)
                      <c:if test="${not empty keyword}"> for "<strong>${keyword}</strong>"</c:if>
                    </c:otherwise>
                  </c:choose>
                </span>
                <c:if test="${accountPage.totalPages > 1}">
                  <div class="pagination">
                    <c:choose>
                      <c:when test="${accountPage.first}">
                        <button class="page-btn" disabled><i class="bi bi-chevron-left"></i></button>
                      </c:when>
                      <c:otherwise>
                        <a href="${baseUrl}&sortBy=${sortBy}&direction=${direction}&page=${accountPage.number - 1}" class="page-btn"><i class="bi bi-chevron-left"></i></a>
                      </c:otherwise>
                    </c:choose>
                    <c:set var="startPage" value="${accountPage.number > 2 ? accountPage.number - 2 : 0}"/>
                    <c:set var="endPage"   value="${accountPage.number + 2 < accountPage.totalPages ? accountPage.number + 2 : accountPage.totalPages - 1}"/>
                    <c:forEach begin="${startPage}" end="${endPage}" var="p">
                      <a href="${baseUrl}&sortBy=${sortBy}&direction=${direction}&page=${p}"
                         class="page-btn ${p == accountPage.number ? 'active' : ''}">${p + 1}</a>
                    </c:forEach>
                    <c:choose>
                      <c:when test="${accountPage.last}">
                        <button class="page-btn" disabled><i class="bi bi-chevron-right"></i></button>
                      </c:when>
                      <c:otherwise>
                        <a href="${baseUrl}&sortBy=${sortBy}&direction=${direction}&page=${accountPage.number + 1}" class="page-btn"><i class="bi bi-chevron-right"></i></a>
                      </c:otherwise>
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
function confirmDelete(name) {
  return confirm('Delete account "' + name + '"?\nThis action cannot be undone.');
}
</script>
</body>
</html>
