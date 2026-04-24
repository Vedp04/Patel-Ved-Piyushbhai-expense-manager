<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<header class="app-header" id="appHeader" role="banner">

  <!-- Sidebar toggle -->
  <button type="button" class="header-toggle-btn" id="sidebarToggle" aria-label="Toggle sidebar" title="Toggle sidebar">
    <i class="bi bi-list" style="font-size:20px;"></i>
  </button>

  <!-- Breadcrumb -->
  <nav class="header-breadcrumb" aria-label="Breadcrumb">
    <span class="breadcrumb-item">
      <a href="${pageContext.request.contextPath}/dashboard">
        <i class="bi bi-house-door-fill" style="font-size:13px;"></i>
      </a>
    </span>
    <c:if test="${not empty breadcrumbs}">
      <c:forEach var="crumb" items="${breadcrumbs}" varStatus="status">
        <span class="breadcrumb-sep">›</span>
        <span class="breadcrumb-item ${status.last ? 'active' : ''}">
          <c:choose>
            <c:when test="${status.last}">${crumb.label}</c:when>
            <c:otherwise><a href="${pageContext.request.contextPath}${crumb.url}">${crumb.label}</a></c:otherwise>
          </c:choose>
        </span>
      </c:forEach>
    </c:if>
    <c:if test="${empty breadcrumbs and not empty pageTitle}">
      <span class="breadcrumb-sep">›</span>
      <span class="breadcrumb-item active">${pageTitle}</span>
    </c:if>
  </nav>

  <!-- Spacer -->
  <div class="flex-1"></div>

  <!-- Right Actions -->
  <div class="header-actions">

    <!-- Theme Toggle -->
    <button class="header-btn" id="themeToggle" data-theme-toggle>
	  <i class="bi bi-sun-fill"  data-icon="sun"  style="display:none;"></i>
	  <i class="bi bi-moon-fill" data-icon="moon"></i>
	</button>

    <!-- User Dropdown -->
    <div class="dropdown" id="userDropdown" style="position:relative;">
      <button class="header-btn" id="userDropdownBtn" style="width:auto; padding:0 8px; gap:8px;"
              aria-label="User menu" aria-haspopup="true" aria-expanded="false">
        <div class="avatar avatar-sm" style="background:linear-gradient(135deg,var(--brand-400),var(--accent-500));color:#fff;">
          <c:choose>
            <c:when test="${not empty sessionScope.user.profilePicURL}">
              <img src="${sessionScope.user.profilePicURL}" alt="avatar">
            </c:when>
            <c:otherwise>${user.firstName.substring(0,1)}${user.lastName.substring(0,1)}</c:otherwise>
          </c:choose>
        </div>
        <span class="d-sm-none" style="font-size:var(--text-sm);font-weight:600;">${not empty sessionScope.user.firstName ? sessionScope.user.firstName : 'Account'}</span>
        <i class="bi bi-chevron-down" style="font-size:11px; color:var(--text-muted);"></i>
      </button>

      <div class="dropdown-menu" id="userDropdownMenu" role="menu">
        <div style="padding: var(--sp-3) var(--sp-4) var(--sp-2); border-bottom:1px solid var(--border-color); margin-bottom: var(--sp-2);">
          <div style="font-size:var(--text-sm);font-weight:700;color:var(--text-primary);">${not empty sessionScope.user.firstName ? sessionScope.user.firstName : 'User'}</div>
          <div style="font-size:var(--text-xs);color:var(--text-muted);">${not empty sessionScope.user.email ? sessionScope.user.email : ''}</div>
        </div>
        <a href="${pageContext.request.contextPath}/profile" class="dropdown-item">
          <i class="bi bi-person" style="font-size:14px;"></i> My Profile
        </a>
        <a href="${pageContext.request.contextPath}/settings" class="dropdown-item">
          <i class="bi bi-gear" style="font-size:14px;"></i> Settings
        </a>
        <div class="dropdown-divider"></div>
        <a href="${pageContext.request.contextPath}/logout" class="dropdown-item danger">
          <i class="bi bi-box-arrow-right" style="font-size:14px;"></i> Sign Out
        </a>
      </div>
    </div>

  </div>

</header>
<script src="${pageContext.request.contextPath}/js/app.js"></script>
<script>
(function(){
  // User dropdown toggle
  const btn = document.getElementById('userDropdownBtn');
  const menu = document.getElementById('userDropdownMenu');
  if(btn && menu) {
    btn.addEventListener('click', function(e){
      e.stopPropagation();
      menu.classList.toggle('show');
      btn.setAttribute('aria-expanded', menu.classList.contains('show'));
    });
    document.addEventListener('click', function(){
      menu.classList.remove('show');
      btn.setAttribute('aria-expanded','false');
    });
  }
})();
</script>
