<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="sidebar" id="sidebar" role="navigation" aria-label="Main navigation">

  <!-- BRAND -->
  <div class="sidebar-brand">
    <div class="sidebar-logo">
      <i class="bi bi-currency-rupee"></i>
    </div>
    <span class="sidebar-brand-name">MoneyTrail</span>
    <span class="sidebar-brand-tag">Beta</span>
  </div>

  <div class="sidebar-nav">

    <!-- ================= USER SIDEBAR ================= -->
    <c:if test="${sessionScope.user.role == 'Customer'}">

      <!-- MAIN -->
      <span class="sidebar-section-label">Main</span>

      <a href="${pageContext.request.contextPath}/dashboard"
         class="nav-item ${activeMenu == 'dashboard' ? 'active' : ''}">
        <span class="nav-icon"><i class="bi bi-grid-1x2-fill"></i></span>
        <span class="nav-label">Dashboard</span>
      </a>

      <a href="${pageContext.request.contextPath}/listexpense"
         class="nav-item ${activeMenu == 'expense' ? 'active' : ''}">
        <span class="nav-icon"><i class="bi bi-arrow-down-circle-fill"></i></span>
        <span class="nav-label">Expenses</span>
      </a>

      <a href="${pageContext.request.contextPath}/listincome"
         class="nav-item ${activeMenu == 'income' ? 'active' : ''}">
        <span class="nav-icon"><i class="bi bi-arrow-up-circle-fill"></i></span>
        <span class="nav-label">Income</span>
      </a>

      <!-- ACCOUNTS -->
      <span class="sidebar-section-label">Accounts</span>

      <a href="${pageContext.request.contextPath}/listaccount"
         class="nav-item ${activeMenu == 'account' ? 'active' : ''}">
        <span class="nav-icon"><i class="bi bi-bank2"></i></span>
        <span class="nav-label">Accounts</span>
      </a>

      <!-- MANAGEMENT -->
      <span class="sidebar-section-label">Manage</span>

      <a href="${pageContext.request.contextPath}/listcategory"
         class="nav-item ${activeMenu == 'category' ? 'active' : ''}">
        <span class="nav-icon"><i class="bi bi-tag-fill"></i></span>
        <span class="nav-label">Categories</span>
      </a>

      <a href="${pageContext.request.contextPath}/listsubcategory"
         class="nav-item ${activeMenu == 'subcategory' ? 'active' : ''}">
        <span class="nav-icon"><i class="bi bi-diagram-3-fill"></i></span>
        <span class="nav-label">Sub-Categories</span>
      </a>

      <a href="${pageContext.request.contextPath}/listvendor"
         class="nav-item ${activeMenu == 'vendor' ? 'active' : ''}">
        <span class="nav-icon"><i class="bi bi-shop"></i></span>
        <span class="nav-label">Vendors</span>
      </a>

      <!-- INSIGHTS -->
      <span class="sidebar-section-label">Insights</span>

      <a href="${pageContext.request.contextPath}/insights"
         class="nav-item ${activeMenu == 'insights' ? 'active' : ''}">
        <span class="nav-icon"><i class="bi bi-bar-chart-line-fill"></i></span>
        <span class="nav-label">Overview</span>
      </a>

    </c:if>


    <!-- ================= ADMIN SIDEBAR ================= -->
    <c:if test="${sessionScope.user.role == 'Admin'}">

      <!-- ADMIN MAIN -->
      <span class="sidebar-section-label">Admin</span>

      <a href="${pageContext.request.contextPath}/dashboard"
         class="nav-item ${activeMenu == 'admin' ? 'active' : ''}">
        <span class="nav-icon"><i class="bi bi-shield-fill-check"></i></span>
        <span class="nav-label">Dashboard</span>
      </a>

      <!-- USER MANAGEMENT -->
      <span class="sidebar-section-label">Users</span>

      <a href="${pageContext.request.contextPath}/listuser"
         class="nav-item ${activeMenu == 'users' ? 'active' : ''}">
        <span class="nav-icon"><i class="bi bi-people-fill"></i></span>
        <span class="nav-label">All Users</span>
      </a>

      <!-- DATA MANAGEMENT -->
      <span class="sidebar-section-label">Data</span>

      <a href="${pageContext.request.contextPath}/listcategory"
         class="nav-item ${activeMenu == 'category' ? 'active' : ''}">
        <span class="nav-icon"><i class="bi bi-tag-fill"></i></span>
        <span class="nav-label">Categories</span>
      </a>

      <a href="${pageContext.request.contextPath}/listsubcategory"
         class="nav-item ${activeMenu == 'subcategory' ? 'active' : ''}">
        <span class="nav-icon"><i class="bi bi-diagram-3-fill"></i></span>
        <span class="nav-label">Sub-Categories</span>
      </a>

      <a href="${pageContext.request.contextPath}/listvendor"
         class="nav-item ${activeMenu == 'vendor' ? 'active' : ''}">
        <span class="nav-icon"><i class="bi bi-shop"></i></span>
        <span class="nav-label">Vendors</span>
      </a>

      <!-- TRANSACTIONS -->
      <span class="sidebar-section-label">Transactions</span>

      <a href="${pageContext.request.contextPath}/admin/transactions"
         class="nav-item ${activeMenu == 'transactions' ? 'active' : ''}">
        <span class="nav-icon"><i class="bi bi-cash-stack"></i></span>
        <span class="nav-label">All Transactions</span>
      </a>

      <!-- SETTINGS -->
      <span class="sidebar-section-label">System</span>

      <a href="${pageContext.request.contextPath}/settings"
         class="nav-item ${activeMenu == 'settings' ? 'active' : ''}">
        <span class="nav-icon"><i class="bi bi-gear-fill"></i></span>
        <span class="nav-label">Settings</span>
      </a>

    </c:if>


    <!-- COMMON (BOTH) -->
    <span class="sidebar-section-label">Account</span>

    <a href="${pageContext.request.contextPath}/profile"
       class="nav-item ${activeMenu == 'profile' ? 'active' : ''}">
      <span class="nav-icon"><i class="bi bi-person-fill"></i></span>
      <span class="nav-label">Profile</span>
    </a>

  </div>

  <!-- FOOTER -->
  <div class="sidebar-footer">
    <div class="sidebar-user">
      <div class="sidebar-avatar">
        <c:choose>
          <c:when test="${not empty sessionScope.user.profilePicURL}">
            <img src="${sessionScope.user.profilePicURL}" alt="${sessionScope.user.firstName}">
          </c:when>
          <c:otherwise>
            ${user.firstName.substring(0,1)}${user.lastName.substring(0,1)}
          </c:otherwise>
        </c:choose>
      </div>
      <div class="sidebar-user-info">
        <div class="sidebar-user-name">
          ${not empty sessionScope.user.firstName ? sessionScope.user.firstName : 'User'}
        </div>
        <div class="sidebar-user-role">
          ${not empty sessionScope.user.role ? sessionScope.user.role : 'Member'}
        </div>
      </div>
    </div>
  </div>

</nav>