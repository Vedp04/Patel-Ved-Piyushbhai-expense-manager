<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="${not empty theme ? theme : 'dark'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Insights — MoneyTrail</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap-icons.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/variables.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/insights.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
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
            <h1 class="page-title">
              <i class="bi bi-bar-chart-line-fill"></i> Insights
            </h1>
			<p class="page-subtitle">Visual breakdown of your income, expenses, and financial health</p>
          </div>
          <!-- Month Filter -->
          <div class="filter-row">
            <span style="font-size:var(--text-xs);color:var(--text-muted);font-weight:600;">FILTER:</span>
            <a href="?period=month" class="filter-chip ${empty param.period || param.period == 'month' ? 'active' : ''}">
              <i class="bi bi-calendar3"></i> This Month
            </a>
            <a href="?period=quarter" class="filter-chip ${param.period == 'quarter' ? 'active' : ''}">
              <i class="bi bi-calendar-range"></i> Quarter
            </a>
            <a href="?period=year" class="filter-chip ${param.period == 'year' ? 'active' : ''}">
              <i class="bi bi-calendar"></i> This Year
            </a>
            <a href="?period=all" class="filter-chip ${param.period == 'all' ? 'active' : ''}">
              <i class="bi bi-infinity"></i> All Time
            </a>
          </div>
        </div>
      </div>
		
		

      <%-- =========================================
           KPI STRIP — 4 summary cards
      ========================================= --%>
      <div class="kpi-strip">

        <!-- Total Income -->
        <div class="kpi-card" style="border-left:3px solid var(--income-color);">
          <div class="kpi-icon" style="background:var(--success-50);color:var(--income-color);">
            <i class="bi bi-arrow-down-circle-fill"></i>
          </div>
          <div>
            <div class="kpi-label">Total Income</div>
            <div class="kpi-value" style="color:var(--income-color);">
              ₹<fmt:formatNumber value="${not empty totalIncome ? totalIncome : 0}" pattern="#,##0"/>
            </div>
            <div class="kpi-sub">${not empty incomeCount ? incomeCount : 0} transactions</div>
          </div>
        </div>
		
        <!-- Total Expense -->
        <div class="kpi-card" style="border-left:3px solid var(--expense-color);">
          <div class="kpi-icon" style="background:var(--danger-50);color:var(--expense-color);">
            <i class="bi bi-arrow-up-circle-fill"></i>
          </div>
          <div>
            <div class="kpi-label">Total Expenses</div>
            <div class="kpi-value" style="color:var(--expense-color);">
              ₹<fmt:formatNumber value="${not empty totalExpense ? totalExpense : 0}" pattern="#,##0"/>
            </div>
            <div class="kpi-sub">${not empty expenseCount ? expenseCount : 0} transactions</div>
          </div>
        </div>

        <!-- Net Savings -->
        <div class="kpi-card" style="border-left:3px solid var(--brand-500);">
          <div class="kpi-icon" style="background:var(--brand-50);color:var(--brand-600);">
            <i class="bi bi-piggy-bank-fill"></i>
          </div>
          <div>
            <div class="kpi-label">Net Savings</div>
            <div class="kpi-value" style="color:var(--brand-500);">
              ₹<fmt:formatNumber value="${not empty balance ? balance : 0}" pattern="#,##0"/>
            </div>
            <div class="kpi-sub">
              <c:choose>
                <c:when test="${totalIncome > 0}">
                  <fmt:formatNumber value="${savingsRate}" pattern="#0.0"/>% savings rate
                </c:when>
                <c:otherwise>0% savings rate</c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>

        <!-- Top Category -->
        <div class="kpi-card" style="border-left:3px solid var(--accent-500);">
          <div class="kpi-icon" style="background:var(--accent-50);color:var(--accent-600);">
            <i class="bi bi-fire"></i>
          </div>
          <div>
            <div class="kpi-label">Biggest Category</div>
            <div class="kpi-value" style="font-size:var(--text-base);">
              ${not empty topCategory ? topCategory : 'N/A'}
            </div>
            <div class="kpi-sub">
              <c:if test="${not empty topCategoryAmount}">
                ₹<fmt:formatNumber value="${topCategoryAmount}" pattern="#,##0"/> spent
              </c:if>
            </div>
          </div>
        </div>

      </div>

      <%-- =========================================
           ROW 1: Income vs Expense Bar + Savings Rate Ring
      ========================================= --%>
      <div class="insights-grid" style="grid-template-columns: 2fr 1fr;">

        <!-- Monthly Income vs Expense Bar Chart -->
        <div class="chart-card">
          <div class="chart-card-header">
            <div>
              <div class="chart-card-title">
                <i class="bi bi-bar-chart-fill" style="color:var(--brand-500);"></i>
                Income vs Expenses
              </div>
              <div class="chart-card-subtitle">Monthly comparison — last 6 months</div>
            </div>
          </div>
          <div class="chart-card-body">
            <c:choose>
              <c:when test="${not empty monthLabels}">
                <canvas id="incomeExpenseBar" style="max-height:280px;"></canvas>
              </c:when>
              <c:otherwise>
                <div class="chart-empty">
                  <i class="bi bi-bar-chart"></i>
                  <span>No data yet — add some income and expenses to see trends</span>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <!-- Savings Rate Doughnut -->
        <div class="chart-card">
          <div class="chart-card-header">
            <div>
              <div class="chart-card-title">
                <i class="bi bi-percent" style="color:var(--brand-500);"></i>
                Savings Rate
              </div>
              <div class="chart-card-subtitle">Income retained as savings</div>
            </div>
          </div>
          <div class="chart-card-body">
            <div class="ring-wrap">
              <canvas id="savingsRing" style="max-height:180px; max-width:180px;"></canvas>
              <div style="text-align:center;">
                <div class="ring-value" style="color:var(--brand-500);" id="savingsRateLabel">
                  <c:choose>
                    <c:when test="${totalIncome > 0}">
                      <fmt:formatNumber value="${savingsRate}" pattern="#0.0"/>%
                    </c:when>
                    <c:otherwise>0%</c:otherwise>
                  </c:choose>
                </div>
                <div class="ring-label">of income saved</div>
              </div>
            </div>
          </div>
        </div>

      </div>

      <%-- =========================================
           ROW 2: Expense by Category Pie + Legend
      ========================================= --%>
      <div class="insights-grid">

        <!-- Expense Category Pie Chart -->
        <div class="chart-card">
          <div class="chart-card-header">
            <div>
              <div class="chart-card-title">
                <i class="bi bi-pie-chart-fill" style="color:var(--expense-color);"></i>
                Expense by Category
              </div>
              <div class="chart-card-subtitle">Where your money is going</div>
            </div>
          </div>
          <div class="chart-card-body" style="display:flex; align-items:center; gap:var(--sp-6); flex-wrap:wrap;">
            <div style="flex:0 0 220px;">
              <c:choose>
                <c:when test="${not empty categoryTotals}">
                  <canvas id="expensePie" style="max-height:220px;"></canvas>
                </c:when>
                <c:otherwise>
                  <div class="chart-empty">
                    <i class="bi bi-pie-chart"></i>
                    <span>No expenses yet</span>
                  </div>
                </c:otherwise>
              </c:choose>
            </div>
            <div style="flex:1; min-width:180px;">
              <ul class="legend-list" id="expenseLegend">
                <c:forEach var="entry" items="${categoryTotals}" varStatus="loop">
                  <li class="legend-item">
                    <span class="legend-dot" style="background:${chartColors[loop.index % 8]};"></span>
                    <span class="legend-name">${entry.key}</span>
                    <div class="legend-bar-wrap">
                      <div class="legend-bar-fill" style="background:${chartColors[loop.index % 8]}; width:${categoryPercent[entry.key]}%;"></div>
                    </div>
                    <span class="legend-amount">₹<fmt:formatNumber value="${entry.value}" pattern="#,##0"/></span>
                  </li>
                </c:forEach>
                <c:if test="${empty categoryTotals}">
                  <li style="color:var(--text-muted);font-size:var(--text-sm);">No data available</li>
                </c:if>
              </ul>
            </div>
          </div>
        </div>

        <!-- Income by Source Pie Chart -->
        <div class="chart-card">
          <div class="chart-card-header">
            <div>
              <div class="chart-card-title">
                <i class="bi bi-pie-chart-fill" style="color:var(--income-color);"></i>
                Income by Source
              </div>
              <div class="chart-card-subtitle">Where your money comes from</div>
            </div>
          </div>
          <div class="chart-card-body" style="display:flex; align-items:center; gap:var(--sp-6); flex-wrap:wrap;">
            <div style="flex:0 0 220px;">
              <c:choose>
                <c:when test="${not empty incomeTotals}">
                  <canvas id="incomePie" style="max-height:220px;"></canvas>
                </c:when>
                <c:otherwise>
                  <div class="chart-empty">
                    <i class="bi bi-pie-chart"></i>
                    <span>No income yet</span>
                  </div>
                </c:otherwise>
              </c:choose>
            </div>
            <div style="flex:1; min-width:180px;">
              <ul class="legend-list">
                <c:forEach var="entry" items="${incomeTotals}" varStatus="loop">
                  <li class="legend-item">
                    <span class="legend-dot" style="background:${incomeColors[loop.index % 6]};"></span>
                    <span class="legend-name">${entry.key}</span>
                    <div class="legend-bar-wrap">
                      <div class="legend-bar-fill" style="background:${incomeColors[loop.index % 6]}; width:${totalIncome > 0 ? (entry.value / totalIncome * 100) : 0}%;"></div>
                    </div>
                    <span class="legend-amount">₹<fmt:formatNumber value="${entry.value}" pattern="#,##0"/></span>
                  </li>
                </c:forEach>
                <c:if test="${empty incomeTotals}">
                  <li style="color:var(--text-muted);font-size:var(--text-sm);">No data available</li>
                </c:if>
              </ul>
            </div>
          </div>
        </div>

      </div>

      <%-- =========================================
           ROW 3: Top 5 Expenses Bar + Payment Mode Donut
      ========================================= --%>
      <div class="insights-grid">

        <!-- Top 5 Expense Categories Horizontal Bar -->
        <div class="chart-card">
          <div class="chart-card-header">
            <div>
              <div class="chart-card-title">
                <i class="bi bi-list-ol" style="color:var(--warning-500);"></i>
                Top Spending Categories
              </div>
              <div class="chart-card-subtitle">Ranked by total amount spent</div>
            </div>
          </div>
          <div class="chart-card-body">
            <c:choose>
              <c:when test="${not empty categoryTotals}">
                <canvas id="topCategoriesBar" style="max-height:260px;"></canvas>
              </c:when>
              <c:otherwise>
                <div class="chart-empty">
                  <i class="bi bi-list-task"></i>
                  <span>No expense categories yet</span>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <!-- Payment Mode Doughnut -->
        <div class="chart-card">
          <div class="chart-card-header">
            <div>
              <div class="chart-card-title">
                <i class="bi bi-credit-card-fill" style="color:var(--accent-500);"></i>
                Payment Modes
              </div>
              <div class="chart-card-subtitle">How you pay your expenses</div>
            </div>
          </div>
          <div class="chart-card-body" style="display:flex; flex-direction:column; align-items:center; gap:var(--sp-4);">
            <c:choose>
              <c:when test="${not empty paymentModeTotals}">
                <canvas id="paymentModePie" style="max-height:200px; max-width:200px;"></canvas>
              </c:when>
              <c:otherwise>
                <div class="chart-empty">
                  <i class="bi bi-credit-card"></i>
                  <span>No payment data yet</span>
                </div>
              </c:otherwise>
            </c:choose>
            <ul class="legend-list" style="width:100%; max-width:260px;">
              <c:forEach var="entry" items="${paymentModeTotals}" varStatus="loop">
                <li class="legend-item">
                  <span class="legend-dot" style="background:${modeColors[loop.index % 7]};"></span>
                  <span class="legend-name">${entry.key}</span>
                  <span class="legend-amount">₹<fmt:formatNumber value="${entry.value}" pattern="#,##0"/></span>
                </li>
              </c:forEach>
            </ul>
          </div>
        </div>

      </div>

      <%-- =========================================
           ROW 4: Cumulative Balance Line Chart (full width)
      ========================================= --%>
      <div class="insights-grid-full">
        <div class="chart-card">
          <div class="chart-card-header">
            <div>
              <div class="chart-card-title">
                <i class="bi bi-graph-up-arrow" style="color:var(--brand-500);"></i>
                Balance Trend
              </div>
              <div class="chart-card-subtitle">Running net balance over time</div>
            </div>
          </div>
          <div class="chart-card-body">
            <c:choose>
              <c:when test="${not empty balanceTrendLabels}">
                <canvas id="balanceLine" style="max-height:260px;"></canvas>
              </c:when>
              <c:otherwise>
                <div class="chart-empty">
                  <i class="bi bi-graph-up"></i>
                  <span>Add income and expenses to see your balance trend over time</span>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <%-- =========================================
           ROW 5: 3 mini stat cards
      ========================================= --%>
      <div class="insights-grid-3">

        <!-- Avg Daily Spend -->
        <div class="chart-card">
          <div class="chart-card-body-sm" style="display:flex; align-items:center; gap:var(--sp-4);">
            <div style="width:46px;height:46px;background:var(--danger-50);border-radius:var(--r-xl);display:flex;align-items:center;justify-content:center;color:var(--expense-color);font-size:20px;flex-shrink:0;">
              <i class="bi bi-calendar-day"></i>
            </div>
            <div>
              <div class="kpi-label">Avg Daily Spend</div>
              <div class="kpi-value" style="font-size:var(--text-lg); color:var(--expense-color);">
                ₹<fmt:formatNumber value="${not empty avgDailySpend ? avgDailySpend : 0}" pattern="#,##0.00"/>
              </div>
              <div class="kpi-sub">per day this month</div>
            </div>
          </div>
        </div>

        <!-- Largest Single Expense -->
        <div class="chart-card">
          <div class="chart-card-body-sm" style="display:flex; align-items:center; gap:var(--sp-4);">
            <div style="width:46px;height:46px;background:var(--warning-50);border-radius:var(--r-xl);display:flex;align-items:center;justify-content:center;color:var(--warning-600);font-size:20px;flex-shrink:0;">
              <i class="bi bi-exclamation-triangle-fill"></i>
            </div>
            <div>
              <div class="kpi-label">Largest Expense</div>
              <div class="kpi-value" style="font-size:var(--text-lg); color:var(--warning-600);">
                ₹<fmt:formatNumber value="${not empty maxExpense ? maxExpense : 0}" pattern="#,##0.00"/>
              </div>
              <div class="kpi-sub">${not empty maxExpenseDesc ? maxExpenseDesc : 'N/A'}</div>
            </div>
          </div>
        </div>

        <!-- Account with Most Activity -->
        <div class="chart-card">
          <div class="chart-card-body-sm" style="display:flex; align-items:center; gap:var(--sp-4);">
            <div style="width:46px;height:46px;background:var(--brand-50);border-radius:var(--r-xl);display:flex;align-items:center;justify-content:center;color:var(--brand-500);font-size:20px;flex-shrink:0;">
              <i class="bi bi-bank2"></i>
            </div>
            <div>
              <div class="kpi-label">Most Used Account</div>
              <div class="kpi-value" style="font-size:var(--text-base);">
                ${not empty topAccount ? topAccount : 'N/A'}
              </div>
              <div class="kpi-sub">
                <c:if test="${not empty topAccountTxns}">${topAccountTxns} transactions</c:if>
              </div>
            </div>
          </div>
        </div>
        </div>
		<div class="report-card">
		  <p class="report-card__title">
		    <%-- PDF icon --%>
		    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#e11d48"
		         stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
		      <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
		      <polyline points="14 2 14 8 20 8"/>
		      <line x1="9" y1="13" x2="15" y2="13"/>
		      <line x1="9" y1="17" x2="15" y2="17"/>
		      <line x1="12" y1="9"  x2="12" y2="9"/>
		    </svg>
		    Download Transactions Report
		  </p>
		  <p class="report-card__subtitle">Export a date-wise PDF of all income and expenses.</p>
		
		  <form id="reportForm"
		        action="${pageContext.request.contextPath}/reports/transactions/pdf"
		        method="get"
		        onsubmit="return validateReportForm()">
		
		    <div class="report-card__fields">
		
		      <div class="report-card__field">
		        <label class="report-card__label" for="fromDate">From</label>
		        <input class="report-card__input" type="date" id="fromDate" name="from" required
		               max="${today}" />
		      </div>
		
		      <div class="report-card__field">
		        <label class="report-card__label" for="toDate">To</label>
		        <input class="report-card__input" type="date" id="toDate" name="to" required
		               max="${today}" />
		      </div>
		
		      <button class="report-card__btn" type="submit">
		        <%-- Download arrow icon --%>
		        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
		             stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
		          <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
		          <polyline points="7 10 12 15 17 10"/>
		          <line x1="12" y1="15" x2="12" y2="3"/>
		        </svg>
		        Export PDF
		      </button>
		
		    </div>
		
		    <p class="report-card__error" id="reportFormError"></p>
		  </form>
		</div>

    </main>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
  </div>
</div>

<!-- =============================================
     Chart.js
============================================= -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/app.js"></script>
<script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/js/theme-switcher.js"></script>

<script>
(function () {
  'use strict';

  // Theme configuration
  const root = document.documentElement;
  const isDark = root.getAttribute('data-theme') === 'dark';
  const gridColor = isDark ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.06)';
  const tickColor = isDark ? '#64748b' : '#94a3b8';
  const fontFamily = getComputedStyle(root).getPropertyValue('--font-sans').trim() || 'DM Sans, sans-serif';

  // Apply global chart defaults
  Chart.defaults.font.family = fontFamily;
  Chart.defaults.font.size = 12;
  Chart.defaults.color = tickColor;
  Chart.defaults.plugins.legend.labels.boxWidth = 10;
  Chart.defaults.plugins.legend.labels.padding = 14;

  // Color palettes
  const EXPENSE_PALETTE = ['#ef4444', '#f97316', '#eab308', '#8b5cf6', '#06b6d4', '#ec4899', '#14b8a6', '#f59e0b'];
  const INCOME_PALETTE = ['#12b383', '#22c55e', '#4ade80', '#86efac', '#6ee7b7', '#a7f3d0'];
  const MODE_PALETTE = ['#6366f1', '#f59e0b', '#12b383', '#ef4444', '#0ea5e9', '#8b5cf6', '#ec4899'];

  // Extract data from server-rendered JSTL variables
  const expLabels = [<c:forEach var="e" items="${categoryTotals}" varStatus="s">"${e.key}"<c:if test="${!s.last}">,</c:if></c:forEach>];
  const expValues = [<c:forEach var="e" items="${categoryTotals}" varStatus="s">${e.value.doubleValue()}<c:if test="${!s.last}">,</c:if></c:forEach>];
  const incLabels = [<c:forEach var="e" items="${incomeTotals}" varStatus="s">"${e.key}"<c:if test="${!s.last}">,</c:if></c:forEach>];
  const incValues = [<c:forEach var="e" items="${incomeTotals}" varStatus="s">${e.value.doubleValue()}<c:if test="${!s.last}">,</c:if></c:forEach>];
  const monthLabels = [<c:forEach var="m" items="${monthLabels}" varStatus="s">"${m}"<c:if test="${!s.last}">,</c:if></c:forEach>];
  const monthIncome = [<c:forEach var="v" items="${monthIncomeData}" varStatus="s">${v}<c:if test="${!s.last}">,</c:if></c:forEach>];
  const monthExpense = [<c:forEach var="v" items="${monthExpenseData}" varStatus="s">${v}<c:if test="${!s.last}">,</c:if></c:forEach>];
  const modeLabels = [<c:forEach var="e" items="${paymentModeTotals}" varStatus="s">"${e.key}"<c:if test="${!s.last}">,</c:if></c:forEach>];
  const modeValues = [<c:forEach var="e" items="${paymentModeTotals}" varStatus="s">${e.value.doubleValue()}<c:if test="${!s.last}">,</c:if></c:forEach>];
  const trendLabels = [<c:forEach var="l" items="${balanceTrendLabels}" varStatus="s">"${l}"<c:if test="${!s.last}">,</c:if></c:forEach>];
  const trendValues = [<c:forEach var="v" items="${balanceTrendValues}" varStatus="s">${v}<c:if test="${!s.last}">,</c:if></c:forEach>];

  // Raw metrics from server
  const totalIncome = parseFloat("${not empty totalIncome ? totalIncome : 0}") || 0;
  const totalExpense = parseFloat("${not empty totalExpense ? totalExpense : 0}") || 0;
  const balance = parseFloat("${not empty balance ? balance : 0}") || 0;
  const savingsRate = totalIncome > 0 ? Math.min(100, Math.max(0, ((totalIncome - totalExpense) / totalIncome) * 100)) : 0;

  // Universal tooltip formatter
  const formatTooltip = (ctx) => {
    const label = ctx.label || ctx.dataset.label || '';
    const value = ctx.raw ?? ctx.parsed?.y ?? ctx.parsed?.x ?? ctx.parsed ?? 0;
    return `${label}: ₹${value.toLocaleString('en-IN')}`;
  };

  // Universal axis formatter
  const formatAxis = (v) => v >= 1000 ? '₹' + (v / 1000).toFixed(0) + 'K' : '₹' + v;

  // ─── 1. SUMMARY OVERVIEW DOUGHNUT ───
  if (document.getElementById('summaryChart')) {
    new Chart(document.getElementById('summaryChart'), {
      type: 'doughnut',
      data: {
        labels: ['Income', 'Expenses', 'Savings'],
        datasets: [{
          data: [totalIncome, totalExpense, balance],
          backgroundColor: ['#12b383', '#ef4444', '#6366f1'],
          borderWidth: 2,
          borderColor: isDark ? '#111827' : '#ffffff',
          hoverBorderWidth: 0
        }]
      },
      options: {
        responsive: true,
        cutout: '65%',
        plugins: {
          legend: { position: 'bottom', labels: { usePointStyle: true } },
          tooltip: { enabled: true, callbacks: { label: formatTooltip } }
        }
      }
    });
  }

  // ─── 2. EXPENSE CATEGORY PIE ───
  if (expLabels.length && document.getElementById('expensePie')) {
    new Chart(document.getElementById('expensePie'), {
      type: 'doughnut',
      data: {
        labels: expLabels,
        datasets: [{
          data: expValues,
          backgroundColor: EXPENSE_PALETTE,
          borderWidth: 2,
          borderColor: isDark ? '#111827' : '#ffffff',
          hoverBorderWidth: 0
        }]
      },
      options: {
        responsive: true,
        cutout: '0%',
        plugins: {
          legend: { display: false },
          tooltip: { enabled: true, callbacks: { label: formatTooltip } }
        }
      }
    });
  }

  // ─── 3. INCOME SOURCE PIE ───
  if (incLabels.length && document.getElementById('incomePie')) {
    new Chart(document.getElementById('incomePie'), {
      type: 'doughnut',
      data: {
        labels: incLabels,
        datasets: [{
          data: incValues,
          backgroundColor: INCOME_PALETTE,
          borderWidth: 2,
          borderColor: isDark ? '#111827' : '#ffffff',
          hoverBorderWidth: 0
        }]
      },
      options: {
        responsive: true,
        cutout: '0%',
        plugins: {
          legend: { display: false },
          tooltip: { enabled: true, callbacks: { label: formatTooltip } }
        }
      }
    });
  }

  // ─── 4. MONTHLY INCOME vs EXPENSE BAR ───
  if (monthLabels.length && document.getElementById('incomeExpenseBar')) {
    new Chart(document.getElementById('incomeExpenseBar'), {
      type: 'bar',
      data: {
        labels: monthLabels,
        datasets: [
          {
            label: 'Income',
            data: monthIncome,
            backgroundColor: 'rgba(18,179,131,0.85)',
            borderRadius: 6,
            borderSkipped: false,
            barPercentage: 0.55,
            hoverBackgroundColor: 'rgba(18,179,131,1)'
          },
          {
            label: 'Expenses',
            data: monthExpense,
            backgroundColor: 'rgba(239,68,68,0.85)',
            borderRadius: 6,
            borderSkipped: false,
            barPercentage: 0.55,
            hoverBackgroundColor: 'rgba(239,68,68,1)'
          }
        ]
      },
      options: {
        responsive: true,
        interaction: { mode: 'index', intersect: false },
        plugins: {
          legend: { position: 'top', labels: { usePointStyle: true, pointStyleWidth: 8 } },
          tooltip: { enabled: true, callbacks: { label: formatTooltip } }
        },
        scales: {
          x: { grid: { color: gridColor }, ticks: { color: tickColor } },
          y: { beginAtZero: true, grid: { color: gridColor }, ticks: { color: tickColor, callback: formatAxis } }
        }
      }
    });
  }

  // ─── 5. SAVINGS RATE RING ───
  if (document.getElementById('savingsRing')) {
    const savingsColor = savingsRate >= 20 ? '#12b383' : savingsRate >= 10 ? '#f59e0b' : '#ef4444';
    new Chart(document.getElementById('savingsRing'), {
      type: 'doughnut',
      data: {
        datasets: [{
          data: [savingsRate, 100 - savingsRate],
          backgroundColor: [savingsColor, isDark ? '#1a2236' : '#f1f5f9'],
          borderWidth: 0,
          hoverBorderWidth: 0
        }]
      },
      options: {
        responsive: true,
        cutout: '78%',
        plugins: {
          legend: { display: false },
          tooltip: { enabled: true, callbacks: { label: formatTooltip } }
        }
      }
    });
  }

  // ─── 6. TOP CATEGORIES HORIZONTAL BAR ───
  if (expLabels.length && document.getElementById('topCategoriesBar')) {
    const combined = expLabels.map((l, i) => ({ label: l, value: expValues[i] }));
    combined.sort((a, b) => b.value - a.value);
    const top = combined.slice(0, 6);

    new Chart(document.getElementById('topCategoriesBar'), {
      type: 'bar',
      data: {
        labels: top.map(t => t.label),
        datasets: [{
          label: 'Amount Spent',
          data: top.map(t => t.value),
          backgroundColor: top.map((_, i) => EXPENSE_PALETTE[i % EXPENSE_PALETTE.length]),
          borderRadius: 6,
          borderSkipped: false,
          barPercentage: 0.6,
          hoverBackgroundColor: top.map((_, i) => {
            const color = EXPENSE_PALETTE[i % EXPENSE_PALETTE.length];
            return color.replace('0.', '1.'); // Increase opacity on hover
          })
        }]
      },
      options: {
        indexAxis: 'y',
        responsive: true,
        plugins: {
          legend: { display: false },
          tooltip: { enabled: true, callbacks: { label: formatTooltip } }
        },
        scales: {
          x: { beginAtZero: true, grid: { color: gridColor }, ticks: { color: tickColor, callback: formatAxis } },
          y: { grid: { display: false }, ticks: { color: tickColor } }
        }
      }
    });
  }

  // ─── 7. PAYMENT MODE PIE ───
  if (modeLabels.length && document.getElementById('paymentModePie')) {
    new Chart(document.getElementById('paymentModePie'), {
      type: 'doughnut',
      data: {
        labels: modeLabels,
        datasets: [{
          data: modeValues,
          backgroundColor: MODE_PALETTE,
          borderWidth: 2,
          borderColor: isDark ? '#111827' : '#ffffff',
          hoverBorderWidth: 0
        }]
      },
      options: {
        responsive: true,
        cutout: '65%',
        plugins: {
          legend: { display: false },
          tooltip: { enabled: true, callbacks: { label: formatTooltip } }
        }
      }
    });
  }

  // ─── 8. BALANCE TREND LINE ───
  if (trendLabels.length && document.getElementById('balanceLine')) {
    new Chart(document.getElementById('balanceLine'), {
      type: 'line',
      data: {
        labels: trendLabels,
        datasets: [{
          label: 'Net Balance',
          data: trendValues,
          borderColor: 'rgba(18,179,131,0.9)',
          backgroundColor: 'rgba(18,179,131,0.08)',
          fill: true,
          tension: 0.4,
          borderWidth: 2.5,
          pointRadius: 4,
          pointBackgroundColor: 'rgba(18,179,131,0.9)',
          pointBorderColor: isDark ? '#111827' : '#fff',
          pointBorderWidth: 2,
          pointHoverRadius: 6,
          hoverBorderWidth: 3
        }]
      },
      options: {
        responsive: true,
        interaction: { mode: 'index', intersect: false },
        plugins: {
          legend: { display: false },
          tooltip: { enabled: true, callbacks: { label: formatTooltip } }
        },
        scales: {
          x: { grid: { color: gridColor }, ticks: { color: tickColor } },
          y: { grid: { color: gridColor }, ticks: { color: tickColor, callback: formatAxis } }
        }
      }
    });
  }
})();
</script>

</body>
</html>