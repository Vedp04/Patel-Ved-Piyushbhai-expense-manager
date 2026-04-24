<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="${not empty theme ? theme : 'dark'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>View User — MoneyTrail</title>
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
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/listuser">Users</a></li>
            <li class="breadcrumb-item active">View User</li>
          </ol>
        </nav>
        <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
          <h1 class="page-title"><i class="bi bi-person-fill"></i> User Profile</h1>
          <a href="${pageContext.request.contextPath}/listuser" class="btn btn-secondary btn-sm">
            <i class="bi bi-arrow-left me-1"></i> Back to Users
          </a>
        </div>
      </div>

      <div style="max-width:700px; display:flex; flex-direction:column; gap:var(--sp-4);">

        <!-- User Card -->
        <div class="card">
          <div class="card-body" style="padding:var(--sp-6);">
            <div class="d-flex align-items-center gap-5 flex-wrap">
              <div style="width:80px;height:80px;border-radius:var(--r-2xl);background:linear-gradient(135deg,var(--brand-400),var(--accent-500));display:flex;align-items:center;justify-content:center;color:#fff;font-size:var(--text-3xl);font-weight:700;flex-shrink:0;">
                ${not empty user.firstName ? user.firstName.substring(0,1).toUpperCase() : 'U'}
              </div>
              <div style="flex:1;">
                <div style="font-size:var(--text-2xl);font-weight:700;color:var(--text-primary);letter-spacing:-0.04em;">${user.firstName}</div>
                <div style="font-size:var(--text-sm);color:var(--text-muted);margin-top:4px;">${user.email}</div>
                <div style="display:flex;align-items:center;gap:var(--sp-2);margin-top:var(--sp-3);">
                  <span class="badge ${user.role == 'Admin' ? 'badge-accent' : 'badge-neutral'}">${user.role}</span>
                  <span class="badge ${user.active ? 'badge-success badge-dot' : 'badge-danger badge-dot'}">
                    ${user.active ? 'Active' : 'Inactive'}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Details Card -->
        <div class="card">
          <div class="card-header">
            <div class="card-title">Account Information</div>
          </div>
          <div class="card-body">
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:var(--sp-5);">
              <div>
                <div style="font-size:var(--text-xs);font-weight:600;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.06em;margin-bottom:4px;">User ID</div>
                <div class="fw-600 text-sm" style="font-family:var(--font-mono);">#${user.userId}</div>
              </div>
              <div>
                <div style="font-size:var(--text-xs);font-weight:600;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.06em;margin-bottom:4px;">Full Name</div>
                <div class="fw-600 text-sm">${user.firstName}</div>
              </div>
              <div>
                <div style="font-size:var(--text-xs);font-weight:600;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.06em;margin-bottom:4px;">Email Address</div>
                <div class="fw-600 text-sm">${user.email}</div>
              </div>
              <div>
                <div style="font-size:var(--text-xs);font-weight:600;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.06em;margin-bottom:4px;">Role</div>
                <span class="badge ${user.role == 'Admin' ? 'badge-accent' : 'badge-neutral'}">${user.role}</span>
              </div>
              <div>
                <div style="font-size:var(--text-xs);font-weight:600;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.06em;margin-bottom:4px;">Account Status</div>
                <span class="badge ${user.active ? 'badge-success badge-dot' : 'badge-danger badge-dot'}">
                  ${user.active ? 'Active' : 'Inactive'}
                </span>
              </div>
              <c:if test="${not empty user.creatAtDate}">
                <div>
                  <div style="font-size:var(--text-xs);font-weight:600;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.06em;margin-bottom:4px;">Joined</div>
                  <div class="fw-600 text-sm">
                    ${user.creatAtDate.dayOfMonth} 
					${user.creatAtDate.month} 
					${user.creatAtDate.year}
                  </div>
                </div>
              </c:if>
            </div>
          </div>
          <div class="card-footer" style="display:flex;gap:var(--sp-3);">
			  <form action="${pageContext.request.contextPath}/toggleuser" method="post">
			    <input type="hidden" name="userId" value="${user.userId}" />
			
			    <button type="submit"
			      class="btn btn-${user.active ? 'danger' : 'success'} btn-sm"
			      onclick="return confirm('${user.active ? 'Deactivate' : 'Activate'} this user?')">
			
			      <i class="bi bi-person-${user.active ? 'dash' : 'check'} me-1"></i>
			      ${user.active ? 'Deactivate User' : 'Activate User'}
			
			    </button>
			  </form>
			
			</div>
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
</body>
</html>
