<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="${not empty theme ? theme : 'dark'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Expenses &#8212; MoneyTrail</title>
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
            <li class="breadcrumb-item active">Expenses</li>
          </ol>
        </nav>
        <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
          <div>
            <h1 class="page-title"><i class="bi bi-arrow-up-circle-fill" style="color:var(--expense-color);"></i> Expenses</h1>
            <p class="page-subtitle">View, manage and track all your expense transactions</p>
          </div>
          <a href="${pageContext.request.contextPath}/addexpense" class="btn btn-danger">
            <i class="bi bi-plus-lg me-1"></i> Add Expense
          </a>
        </div>
      </div>

      <!-- Summary Strip -->
      <c:if test="${expensePage.totalElements > 0}">
        <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:var(--sp-4);margin-bottom:var(--sp-5);">
          <div class="card" style="border-left:3px solid var(--expense-color);">
            <div class="card-body" style="padding:var(--sp-4);">
              <div style="font-size:var(--text-xs);font-weight:600;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.06em;">Total Expenses</div>
              <div style="font-size:var(--text-2xl);font-weight:700;color:var(--expense-color);font-family:var(--font-mono);margin-top:4px;">
                &#8377;<fmt:formatNumber value="${totalExpenseAmount}" pattern="#,##0.00"/>
              </div>
            </div>
          </div>
          <div class="card">
            <div class="card-body" style="padding:var(--sp-4);">
              <div style="font-size:var(--text-xs);font-weight:600;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.06em;">Transactions</div>
              <div style="font-size:var(--text-2xl);font-weight:700;color:var(--text-primary);margin-top:4px;">${expensePage.totalElements}</div>
            </div>
          </div>
          <div class="card">
            <div class="card-body" style="padding:var(--sp-4);">
              <div style="font-size:var(--text-xs);font-weight:600;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.06em;">Avg. Expense</div>
              <div style="font-size:var(--text-2xl);font-weight:700;color:var(--text-primary);font-family:var(--font-mono);margin-top:4px;">
                &#8377;<fmt:formatNumber value="${expensePage.totalElements > 0 ? totalExpenseAmount / expensePage.totalElements : 0}" pattern="#,##0.00"/>
              </div>
            </div>
          </div>
        </div>
      </c:if>

      <div class="card">
        <div class="card-header">
          <div class="card-title">
            All Expenses
            <span class="badge badge-neutral ms-2">${expensePage.totalElements}</span>
          </div>
          <form method="get" action="${pageContext.request.contextPath}/listexpense" class="d-flex align-items-center gap-2 flex-wrap">
            <div class="search-box" style="min-width:220px;">
              <i class="bi bi-search" style="color:var(--text-muted);font-size:13px;"></i>
              <input type="text" name="keyword" value="${keyword}" placeholder="Search expenses...">
            </div>
            <input type="hidden" name="sortBy"    value="${sortBy}">
            <input type="hidden" name="direction" value="${direction}">
            <input type="hidden" name="size"      value="${expensePage.size}">
            <button type="submit" class="btn btn-secondary btn-sm">Search</button>
            <c:if test="${not empty keyword}">
              <a href="${pageContext.request.contextPath}/listexpense" class="btn btn-secondary btn-sm">Clear</a>
            </c:if>
          </form>
        </div>
        <div class="card-body p-0">
          <c:choose>
            <c:when test="${expensePage.totalElements == 0}">
              <div class="empty-state">
                <div class="empty-state-icon" style="color:var(--expense-color);background:var(--danger-50);">
                  <i class="bi bi-arrow-up-circle-fill"></i>
                </div>
                <p class="empty-state-title">No expenses recorded</p>
                <p class="empty-state-desc">Start adding expenses to track your spending and gain financial insights.</p>
                <a href="${pageContext.request.contextPath}/addexpense" class="btn btn-danger mt-3">
                  <i class="bi bi-plus-lg me-1"></i> Add Expense
                </a>
              </div>
            </c:when>
            <c:otherwise>
              <%-- Build base URL for pagination links --%>
              <c:url value="/listexpense" var="baseUrl">
                <c:param name="keyword" value="${keyword}"/>
                <c:param name="size"    value="${expensePage.size}"/>
              </c:url>
              <div class="table-responsive">
                <table class="table" id="expTable">
                  <thead>
                    <tr>
                      <th>#</th>
                      <th>
                        <c:url value="/listexpense" var="sortUrlDesc">
                          <c:param name="keyword"   value="${keyword}"/>
                          <c:param name="sortBy"    value="description"/>
                          <c:param name="direction" value="${sortBy == 'description' && direction == 'asc' ? 'desc' : 'asc'}"/>
                          <c:param name="size"      value="${expensePage.size}"/>
                          <c:param name="page"      value="0"/>
                        </c:url>
                        <a href="${sortUrlDesc}" style="color:inherit;text-decoration:none;">
                          Description
                          <c:choose>
                            <c:when test="${sortBy == 'description' && direction == 'asc'}"><i class="bi bi-arrow-up-short"></i></c:when>
                            <c:when test="${sortBy == 'description' && direction == 'desc'}"><i class="bi bi-arrow-down-short"></i></c:when>
                            <c:otherwise><i class="bi bi-arrow-down-up" style="opacity:0.3;"></i></c:otherwise>
                          </c:choose>
                        </a>
                      </th>
                      <th>Category</th>
                      <th>Vendor</th>
                      <th>Account</th>
                      <th>
                        <c:url value="/listexpense" var="sortUrlDate">
                          <c:param name="keyword"   value="${keyword}"/>
                          <c:param name="sortBy"    value="expenseDate"/>
                          <c:param name="direction" value="${sortBy == 'expenseDate' && direction == 'asc' ? 'desc' : 'asc'}"/>
                          <c:param name="size"      value="${expensePage.size}"/>
                          <c:param name="page"      value="0"/>
                        </c:url>
                        <a href="${sortUrlDate}" style="color:inherit;text-decoration:none;">
                          Date
                          <c:choose>
                            <c:when test="${sortBy == 'expenseDate' && direction == 'asc'}"><i class="bi bi-arrow-up-short"></i></c:when>
                            <c:when test="${sortBy == 'expenseDate' && direction == 'desc'}"><i class="bi bi-arrow-down-short"></i></c:when>
                            <c:otherwise><i class="bi bi-arrow-down-up" style="opacity:0.3;"></i></c:otherwise>
                          </c:choose>
                        </a>
                      </th>
                      <th>Mode</th>
                      <th>Status</th>
                      <th>
                        <c:url value="/listexpense" var="sortUrlAmt">
                          <c:param name="keyword"   value="${keyword}"/>
                          <c:param name="sortBy"    value="amount"/>
                          <c:param name="direction" value="${sortBy == 'amount' && direction == 'asc' ? 'desc' : 'asc'}"/>
                          <c:param name="size"      value="${expensePage.size}"/>
                          <c:param name="page"      value="0"/>
                        </c:url>
                        <a href="${sortUrlAmt}" style="color:inherit;text-decoration:none;">
                          Amount
                          <c:choose>
                            <c:when test="${sortBy == 'amount' && direction == 'asc'}"><i class="bi bi-arrow-up-short"></i></c:when>
                            <c:when test="${sortBy == 'amount' && direction == 'desc'}"><i class="bi bi-arrow-down-short"></i></c:when>
                            <c:otherwise><i class="bi bi-arrow-down-up" style="opacity:0.3;"></i></c:otherwise>
                          </c:choose>
                        </a>
                      </th>
                      <th class="text-center">Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="exp" items="${expensePage.content}" varStatus="st">
                      <tr>
                        <td class="text-muted-color text-sm">${expensePage.number * expensePage.size + st.index + 1}</td>
                        <td>
                          <div class="fw-600 text-sm">${not empty exp.description ? exp.description : '&#8212;'}</div>
                          <div class="text-xs text-muted-color">${exp.subCategoryId != null ? subCategoryMap[exp.subCategoryId] : ''}</div>
                        </td>
                        <td>
                          <span class="badge badge-danger">${exp.categoryId != null ? categoryMap[exp.categoryId] : '&#8212;'}</span>
                        </td>
                        <td class="text-sm text-muted-color">${exp.vendorId != null ? vendorMap[exp.vendorId] : '&#8212;'}</td>
                        <td class="text-sm text-muted-color">${exp.accountId != null ? accountMap[exp.accountId] : '&#8212;'}</td>
                        <td>
                          <span class="text-sm" style="font-family:var(--font-mono);color:var(--text-secondary);">
                            ${exp.expenseDate.dayOfMonth} ${exp.expenseDate.month} ${exp.expenseDate.year}
                          </span>
                        </td>
                        <td>
                          <span class="badge badge-neutral">${not empty exp.paymentMode ? exp.paymentMode : '&#8212;'}</span>
                        </td>
                        <td>
                          <c:set var="status" value="${exp.statusId != null ? statusMap[exp.statusId] : null}" />
                          <span class="badge 
                              ${status == 'Paid' ? 'badge-success badge-dot' 
                              : status == 'PartialPaid' ? 'badge-warning badge-dot' 
                              : status == 'Unpaid' ? 'badge-danger badge-dot' 
                              : 'badge-neutral badge-dot'}">
                              ${status != null ? status : '&#8212;'}
                          </span>
                        </td>
                        <td>
                          <span class="fw-700 text-sm text-expense" style="font-family:var(--font-mono);">
                            &#8722;&#8377;<fmt:formatNumber value="${exp.amount}" pattern="#,##0.00"/>
                          </span>
                        </td>
                        <td class="text-center">
                          <div class="action-btns">
                            <a href="${pageContext.request.contextPath}/editexpense?expenseId=${exp.expenseId}"
                               class="btn-icon edit" title="Edit">
                              <i class="bi bi-pencil"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/deleteexpense?expenseId=${exp.expenseId}"
                               class="btn-icon del" title="Delete"
                               onclick="return confirmDelete('expense #${exp.expenseId}')">
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
                  Showing ${expensePage.number * expensePage.size + 1}&#8211;${expensePage.number * expensePage.size + expensePage.numberOfElements}
                  of ${expensePage.totalElements} expense(s)
                  <c:if test="${not empty keyword}"> for "<strong>${keyword}</strong>"</c:if>
                </span>
                <c:if test="${expensePage.totalPages > 1}">
                  <div class="pagination">
                    <c:choose>
                      <c:when test="${expensePage.first}">
                        <button class="page-btn" disabled><i class="bi bi-chevron-left"></i></button>
                      </c:when>
                      <c:otherwise>
                        <a href="${baseUrl}&sortBy=${sortBy}&direction=${direction}&page=${expensePage.number - 1}" class="page-btn"><i class="bi bi-chevron-left"></i></a>
                      </c:otherwise>
                    </c:choose>
                    <c:set var="startPage" value="${expensePage.number > 2 ? expensePage.number - 2 : 0}"/>
                    <c:set var="endPage"   value="${expensePage.number + 2 < expensePage.totalPages ? expensePage.number + 2 : expensePage.totalPages - 1}"/>
                    <c:forEach begin="${startPage}" end="${endPage}" var="p">
                      <a href="${baseUrl}&sortBy=${sortBy}&direction=${direction}&page=${p}"
                         class="page-btn ${p == expensePage.number ? 'active' : ''}">${p + 1}</a>
                    </c:forEach>
                    <c:choose>
                      <c:when test="${expensePage.last}">
                        <button class="page-btn" disabled><i class="bi bi-chevron-right"></i></button>
                      </c:when>
                      <c:otherwise>
                        <a href="${baseUrl}&sortBy=${sortBy}&direction=${direction}&page=${expensePage.number + 1}" class="page-btn"><i class="bi bi-chevron-right"></i></a>
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
  return confirm('Delete ' + name + '? This cannot be undone.');
}
</script>
</body>
</html>
