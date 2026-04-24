<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="${not empty theme ? theme : 'dark'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard — MoneyTrail</title>
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

      <!-- WELCOME BAR -->
      <div class="welcome-bar">
        <div class="welcome-text">
          <div class="welcome-title">Good ${timeOfDay}, ${not empty sessionScope.user.firstName ? sessionScope.user.firstName : 'there'} 👋</div>
          <div class="welcome-subtitle">Here's your financial overview for <strong>${currentMonthName}</strong></div>
        </div>
        <div class="welcome-actions">
          <a href="${pageContext.request.contextPath}/addexpense" class="btn">
            <i class="bi bi-plus-lg me-1"></i> Add Expense
          </a>
          <a href="${pageContext.request.contextPath}/addincome" class="btn">
            <i class="bi bi-plus-lg me-1"></i> Add Income
          </a>
        </div>
      </div>

      <!-- STATS GRID -->
      <div class="stats-grid">

        <div class="stat-card stat-income">
          <div class="stat-card-icon"><i class="bi bi-arrow-up-circle-fill"></i></div>
          <div class="stat-card-label">Total Income</div>
          <div class="stat-card-value">
            <fmt:formatNumber value="${not empty totalIncome ? totalIncome : 0}" type="currency" currencySymbol="₹" maxFractionDigits="0"/>
          </div>
          <span class="stat-card-change up"><i class="bi bi-arrow-up"></i> This Month</span>
          <div class="stat-card-bg-icon"><i class="bi bi-arrow-up-circle"></i></div>
        </div>

        <div class="stat-card stat-expense">
          <div class="stat-card-icon"><i class="bi bi-arrow-down-circle-fill"></i></div>
          <div class="stat-card-label">Total Expenses</div>
          <div class="stat-card-value">
            <fmt:formatNumber value="${not empty totalExpense ? totalExpense : 0}" type="currency" currencySymbol="₹" maxFractionDigits="0"/>
          </div>
          <span class="stat-card-change down"><i class="bi bi-arrow-down"></i> This Month</span>
          <div class="stat-card-bg-icon"><i class="bi bi-arrow-down-circle"></i></div>
        </div>

        <div class="stat-card stat-balance">
          <div class="stat-card-icon"><i class="bi bi-wallet2"></i></div>
          <div class="stat-card-label">Net Balance</div>
          <div class="stat-card-value" style="color:${balance >= 0 ? 'var(--income-color)' : 'var(--expense-color)'};">
            <fmt:formatNumber value="${not empty balance ? balance : 0}" type="currency" currencySymbol="₹" maxFractionDigits="0"/>
          </div>
          <span class="stat-card-change up"><i class="bi bi-check-circle"></i> Available</span>
          <div class="stat-card-bg-icon"><i class="bi bi-wallet2"></i></div>
        </div>

        <div class="stat-card stat-vendor">
          <div class="stat-card-icon"><i class="bi bi-shop"></i></div>
          <div class="stat-card-label">Total Vendors</div>
          <div class="stat-card-value">${not empty totalVendors ? totalVendors : 0}</div>
          <span class="stat-card-change up"><i class="bi bi-building"></i> Registered</span>
          <div class="stat-card-bg-icon"><i class="bi bi-shop"></i></div>
        </div>

      </div>

      <!-- CONTENT GRID -->
      <div class="content-grid">

        <!-- Recent Expenses -->
        <div class="card">
          <div class="card-header">
            <div class="card-title"><i class="bi bi-clock-history" style="color:var(--brand-500);"></i> Recent Transactions</div>
            <a href="${pageContext.request.contextPath}/listexpense" class="btn btn-ghost btn-sm">View all <i class="bi bi-arrow-right"></i></a>
          </div>
          <div class="card-body p-0">
            <c:choose>
              <c:when test="${empty recentExpenses}">
                <div class="empty-state" style="padding:var(--sp-10);">
                  <div class="empty-state-icon"><i class="bi bi-receipt"></i></div>
                  <p class="empty-state-title">No transactions yet</p>
                  <p class="empty-state-desc">Add your first expense to see it here.</p>
                  <a href="${pageContext.request.contextPath}/addexpense" class="btn btn-primary mt-3">
                    <i class="bi bi-plus-lg me-1"></i> Add Expense
                  </a>
                </div>
              </c:when>
              <c:otherwise>
                <c:forEach var="exp" items="${recentExpenses}">
                  <div class="txn-item">
                    <div class="txn-icon expense"><i class="bi bi-arrow-up-circle-fill"></i></div>
                    <div class="txn-info">
                      <div class="txn-name">${not empty exp.description ? exp.description : 'Expense'}</div>
                      <div class="txn-meta">
                        ${exp.expenseDate}
                      </div>
                    </div>
                    <div class="txn-amount expense">
                      −<fmt:formatNumber value="${exp.amount}" type="currency" currencySymbol="₹" maxFractionDigits="2"/>
                    </div>
                  </div>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <!-- Summary Panel -->
        <div style="display:flex; flex-direction:column; gap:var(--sp-4);">

          <!-- Chart placeholder -->
          <div class="card">
            <div class="card-header">
              <div class="card-title"><i class="bi bi-pie-chart-fill" style="color:var(--accent-500);"></i> Spending Breakdown</div>
            </div>
            <div class="card-body">
              <canvas id="spendingChart" style="max-height:220px;"></canvas>
            </div>
          </div>

          <!-- Quick Actions -->
          <div class="card">
            <div class="card-header">
              <div class="card-title">Quick Actions</div>
            </div>
            <div class="card-body" style="display:flex; flex-direction:column; gap:var(--sp-2); padding:var(--sp-4);">
              <a href="${pageContext.request.contextPath}/addexpense" class="btn btn-secondary" style="justify-content:flex-start;">
                <i class="bi bi-arrow-up-circle-fill" style="color:var(--expense-color);"></i> Add Expense
              </a>
              <a href="${pageContext.request.contextPath}/addincome" class="btn btn-secondary" style="justify-content:flex-start;">
                <i class="bi bi-arrow-down-circle-fill" style="color:var(--income-color);"></i> Add Income
              </a>
              <a href="${pageContext.request.contextPath}/addaccount" class="btn btn-secondary" style="justify-content:flex-start;">
                <i class="bi bi-bank2" style="color:var(--balance-color);"></i> New Account
              </a>
              <a href="${pageContext.request.contextPath}/addvendor" class="btn btn-secondary" style="justify-content:flex-start;">
                <i class="bi bi-shop" style="color:var(--budget-color);"></i> Add Vendor
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
  const income = ${totalIncome};
  const expense = ${totalExpense};
  const balance = ${balance};

  new Chart(document.getElementById('spendingChart'), {
    type: 'doughnut',
    data: {
      labels: ['Income', 'Expenses', 'Balance'],
      datasets: [{
        data: [income, expense, balance],
        backgroundColor: ['#12b383', '#ef4444', '#6366f1'],
        borderWidth: 0
      }]
    },
    options: {
      responsive: true,
      cutout: '70%',
      plugins: { legend: { position: 'bottom' } }
    }
  });
</script>
<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/app.js"></script>
<script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/js/theme-switcher.js"></script>
</body>
</html>
