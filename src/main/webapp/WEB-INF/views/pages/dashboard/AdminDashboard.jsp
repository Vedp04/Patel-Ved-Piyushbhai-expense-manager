<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="${not empty theme ? theme : 'dark'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard — MoneyTrail</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap-icons.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/variables.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>
<div class="sidebar-backdrop" id="sidebarBackdrop"></div>
<div class="app-wrapper">
  <jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>
  <div class="main-area">
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
    <main class="page-content">

      <jsp:include page="/WEB-INF/views/components/alert.jsp"/>

      <!-- PAGE HEADER -->
      <div class="page-header">
        <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
          <div>
            <h1 class="page-title"><i class="bi bi-shield-fill-check"></i> Admin Dashboard</h1>
            <p class="page-subtitle">Platform-wide overview and management controls</p>
          </div>
          <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/listuser" class="btn btn-secondary btn-sm">
              <i class="bi bi-people me-1"></i> Manage Users
            </a>
          </div>
        </div>
      </div>

      <!-- =============================================
           4 BIG STAT CARDS
           Total Users | Active Users | Total Vendors | Total Categories
      ============================================= -->
      <div class="stats-grid" style="grid-template-columns: repeat(4, 1fr); margin-bottom: var(--sp-6);">

        <!-- Total Users -->
        <div class="stat-card" style="border-left: 3px solid var(--brand-500);">
          <div class="stat-card-icon" style="background:var(--brand-50);color:var(--brand-600);">
            <i class="bi bi-people-fill"></i>
          </div>
          <div class="stat-card-label">Total Users</div>
          <div class="stat-card-value">${not empty totalUsers ? totalUsers : 0}</div>
          <span class="stat-card-change up"><i class="bi bi-arrow-up"></i> Registered</span>
          <div class="stat-card-bg-icon"><i class="bi bi-people"></i></div>
        </div>

        <!-- Active Users -->
        <div class="stat-card" style="border-left: 3px solid var(--success-600, #16a34a);">
          <div class="stat-card-icon" style="background:var(--success-50);color:var(--success-600);">
            <i class="bi bi-person-check-fill"></i>
          </div>
          <div class="stat-card-label">Active Users</div>
          <div class="stat-card-value">${not empty activeUsers ? activeUsers : 0}</div>
          <span class="stat-card-change up"><i class="bi bi-circle-fill" style="font-size:8px;"></i> Online</span>
          <div class="stat-card-bg-icon"><i class="bi bi-person-check"></i></div>
        </div>

        <!-- Total Vendors -->
        <div class="stat-card stat-vendor" style="border-left: 3px solid var(--budget-color);">
          <div class="stat-card-icon"><i class="bi bi-shop"></i></div>
          <div class="stat-card-label">Total Vendors</div>
          <div class="stat-card-value">${not empty totalVendors ? totalVendors : 0}</div>
          <span class="stat-card-change up"><i class="bi bi-building"></i> Registered</span>
          <div class="stat-card-bg-icon"><i class="bi bi-shop"></i></div>
        </div>

        <!-- Total Categories -->
        <div class="stat-card" style="border-left: 3px solid var(--accent-500);">
          <div class="stat-card-icon" style="background:var(--accent-50);color:var(--accent-600);">
            <i class="bi bi-tag-fill"></i>
          </div>
          <div class="stat-card-label">Total Categories</div>
          <div class="stat-card-value">${not empty totalCategories ? totalCategories : 0}</div>
          <span class="stat-card-change up"><i class="bi bi-grid"></i> Listed</span>
          <div class="stat-card-bg-icon"><i class="bi bi-tag"></i></div>
        </div>

      </div>

      <!-- =============================================
           3 SMALL STAT CARDS
           Sub-Categories | Inactive Users | New This Week
      ============================================= -->
      <div class="admin-stats" style="margin-bottom: var(--sp-6);">

        <!-- Sub-Categories -->
        <div class="card">
          <div class="card-body" style="display:flex;align-items:center;gap:var(--sp-4);">
            <div style="width:48px;height:48px;background:var(--warning-50);border-radius:var(--r-xl);display:flex;align-items:center;justify-content:center;color:var(--warning-600);font-size:22px;flex-shrink:0;">
              <i class="bi bi-diagram-3-fill"></i>
            </div>
            <div>
              <div style="font-size:var(--text-xs);font-weight:600;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.06em;">Sub-Categories</div>
              <div style="font-size:var(--text-2xl);font-weight:700;color:var(--text-primary);letter-spacing:-0.04em;">${not empty totalSubCategories ? totalSubCategories : 0}</div>
            </div>
          </div>
        </div>

        <!-- Inactive Users (computed: totalUsers - activeUsers) -->
        <div class="card">
          <div class="card-body" style="display:flex;align-items:center;gap:var(--sp-4);">
            <div style="width:48px;height:48px;background:var(--danger-50);border-radius:var(--r-xl);display:flex;align-items:center;justify-content:center;color:var(--danger-600);font-size:22px;flex-shrink:0;">
              <i class="bi bi-person-x-fill"></i>
            </div>
            <div>
              <div style="font-size:var(--text-xs);font-weight:600;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.06em;">Inactive Users</div>
              <div style="font-size:var(--text-2xl);font-weight:700;color:var(--text-primary);letter-spacing:-0.04em;">
                ${(not empty totalUsers and not empty activeUsers) ? totalUsers - activeUsers : 0}
              </div>
            </div>
          </div>
        </div>

        <!-- New Users This Week (sum of last7Days userGrowth) -->
        <div class="card">
          <div class="card-body" style="display:flex;align-items:center;gap:var(--sp-4);">
            <div style="width:48px;height:48px;background:var(--brand-50);border-radius:var(--r-xl);display:flex;align-items:center;justify-content:center;color:var(--brand-500);font-size:22px;flex-shrink:0;">
              <i class="bi bi-person-plus-fill"></i>
            </div>
            <div>
              <div style="font-size:var(--text-xs);font-weight:600;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.06em;">New This Week</div>
              <div style="font-size:var(--text-2xl);font-weight:700;color:var(--text-primary);letter-spacing:-0.04em;">
                <c:set var="weekTotal" value="${0}"/>
                <c:forEach var="g" items="${userGrowth}">
                  <c:set var="weekTotal" value="${weekTotal + g}"/>
                </c:forEach>
                ${weekTotal}
              </div>
            </div>
          </div>
        </div>

      </div>

      <!-- CONTENT GRID -->
      <div class="content-grid">

        <!-- Recent Users Table -->
        <div class="card">
          <div class="card-header">
            <div class="card-title">
              <i class="bi bi-people-fill" style="color:var(--brand-500);"></i> Recent Users
            </div>
            <a href="${pageContext.request.contextPath}/listuser" class="btn btn-ghost btn-sm">
              View all <i class="bi bi-arrow-right"></i>
            </a>
          </div>
          <div class="card-body p-0">
            <c:choose>
              <c:when test="${empty userList}">
                <div class="empty-state" style="padding:var(--sp-10);">
                  <div class="empty-state-icon"><i class="bi bi-people"></i></div>
                  <p class="empty-state-title">No users yet</p>
                </div>
              </c:when>
              <c:otherwise>
                <div class="table-responsive">
                  <table class="table">
                    <thead>
                      <tr>
                        <th>#</th>
                        <th>User</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th class="text-center">Action</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="u" items="${userList}" varStatus="st">
                        <tr>
                          <td class="text-muted-color text-sm">${st.index + 1}</td>
                          <td>
                            <div style="display:flex;align-items:center;gap:var(--sp-2);">
                              <div class="vendor-initial" style="background:linear-gradient(135deg,var(--brand-400),var(--accent-500));color:#fff;">
                                ${not empty u.firstName ? u.firstName.substring(0,1).toUpperCase() : 'U'}
                              </div>
                              <div>
                                <div class="fw-600 text-sm">${u.firstName}</div>
                                <div class="text-xs text-muted-color">${u.email}</div>
                              </div>
                            </div>
                          </td>
                          <td>
                            <span class="badge ${u.role == 'Admin' ? 'badge-accent' : 'badge-neutral'}">${u.role}</span>
                          </td>
                          <td>
                            <span class="badge ${u.active ? 'badge-success badge-dot' : 'badge-danger badge-dot'}">
                              ${u.active ? 'Active' : 'Inactive'}
                            </span>
                          </td>
                          <td class="text-center">
                            <a href="${pageContext.request.contextPath}/viewuser?userId=${u.userId}" class="btn-icon edit" title="View">
                              <i class="bi bi-eye"></i>
                            </a>
                          </td>
                        </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <!-- Right Panel -->
        <div style="display:flex;flex-direction:column;gap:var(--sp-4);">

          <!-- User Growth Chart -->
          <div class="card">
            <div class="card-header">
              <div class="card-title">
                <i class="bi bi-graph-up-arrow" style="color:var(--accent-500);"></i> User Growth (Last 7 Days)
              </div>
            </div>
            <div class="card-body">
              <canvas id="userChart" style="max-height:260px;"></canvas>
            </div>
          </div>

          <!-- Admin Quick Actions -->
          <div class="card">
            <div class="card-header">
              <div class="card-title">Admin Actions</div>
            </div>
            <div class="card-body" style="display:flex;flex-direction:column;gap:var(--sp-2);padding:var(--sp-4);">
              <a href="${pageContext.request.contextPath}/addcategory" class="btn btn-secondary" style="justify-content:flex-start;">
                <i class="bi bi-tag-fill" style="color:var(--accent-500);"></i> Add Category
              </a>
              <a href="${pageContext.request.contextPath}/addsubcategory" class="btn btn-secondary" style="justify-content:flex-start;">
                <i class="bi bi-diagram-3-fill" style="color:var(--warning-500);"></i> Add Sub-Category
              </a>
              <a href="${pageContext.request.contextPath}/addvendor" class="btn btn-secondary" style="justify-content:flex-start;">
                <i class="bi bi-shop" style="color:var(--budget-color);"></i> Add Vendor
              </a>
              <a href="${pageContext.request.contextPath}/listuser" class="btn btn-secondary" style="justify-content:flex-start;">
                <i class="bi bi-people-fill" style="color:var(--brand-500);"></i> All Users
              </a>
            </div>
          </div>

        </div>
      </div>

    </main>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
  const labels = [
    <c:forEach var="d" items="${last7Days}" varStatus="s">
      "${d}"<c:if test="${!s.last}">,</c:if>
    </c:forEach>
  ];

  const data = [
    <c:forEach var="g" items="${userGrowth}" varStatus="s">
      ${g}<c:if test="${!s.last}">,</c:if>
    </c:forEach>
  ];

  new Chart(document.getElementById('userChart'), {
    type: 'line',
    data: {
      labels: labels,
      datasets: [{
        label: 'Users Registered',
        data: data,
        borderWidth: 2,
        tension: 0.3,
        fill: true
      }]
    },
    options: {
      responsive: true,
      plugins: { legend: { display: false } },
      scales: {
        y: { beginAtZero: true, ticks: { stepSize: 1 } }
      }
    }
  });
</script>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/app.js"></script>
<script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/js/theme-switcher.js"></script>
</body>
</html>
