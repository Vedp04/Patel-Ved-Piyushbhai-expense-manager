<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sign In — MoneyTrail</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap-icons.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/variables.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">
</head>
<body>

<div class="auth-shell">

  <!-- LEFT PANEL -->
  <div class="auth-panel">
    <div class="auth-panel-brand">
      <div class="auth-panel-logo"><i class="bi bi-currency-rupee text-white" style="font-size:22px;"></i></div>
      <div class="auth-panel-name">MoneyTrail</div>
    </div>
    <div class="auth-panel-body">
      <h1 class="auth-panel-title">Track Every Rupee.<br>Control Your Future.</h1>
      <p class="auth-panel-desc">Manage income, expenses, vendors, and budgets in one unified platform. Built for clarity, speed, and financial awareness.</p>
      <div class="auth-features">
        <div class="auth-feature">
          <div class="auth-feature-icon"><i class="bi bi-graph-up-arrow text-white" style="font-size:17px;"></i></div>
          <div class="auth-feature-text"><strong>Smart Analytics</strong><span>Visual insights for better decisions</span></div>
        </div>
        <div class="auth-feature">
          <div class="auth-feature-icon"><i class="bi bi-wallet2 text-white" style="font-size:17px;"></i></div>
          <div class="auth-feature-text"><strong>Expense Tracking</strong><span>Track every transaction easily</span></div>
        </div>
        <div class="auth-feature">
          <div class="auth-feature-icon"><i class="bi bi-shield-lock text-white" style="font-size:17px;"></i></div>
          <div class="auth-feature-text"><strong>Secure System</strong><span>Your data is fully protected</span></div>
        </div>
      </div>
    </div>
  </div>

  <!-- RIGHT FORM -->
  <div class="auth-form-side">
    <div class="auth-form-box">

      <h2 class="auth-form-title">Welcome back</h2>
      <p class="auth-form-subtitle">Sign in to your MoneyTrail account to continue</p>

      <c:if test="${not empty error}">
        <div class="alert alert-danger d-flex align-items-center gap-2">
          <i class="bi bi-exclamation-circle-fill"></i><div>${error}</div>
        </div>
      </c:if>
      <c:if test="${not empty success}">
        <div class="alert alert-success d-flex align-items-center gap-2">
          <i class="bi bi-check-circle-fill"></i><div>${success}</div>
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/authenticate" method="POST" id="loginForm" novalidate>

        <div class="form-group">
          <label class="form-label" for="email">Email Address<span class="required">*</span></label>
          <div class="input-wrapper">
            <i class="bi bi-envelope input-icon"></i>
            <input type="email" id="email" name="email" class="form-input has-icon"
                   placeholder="you@example.com" required autocomplete="email"
                   value="${not empty param.email ? param.email : ''}">
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="password">
            Password <span class="required">*</span>
            <a href="${pageContext.request.contextPath}/forgot-password" class="text-sm fw-600" style="color:var(--brand-500);">Forgot?</a>
          </label>
          <div class="input-wrapper">
            <i class="bi bi-lock input-icon"></i>
            <input type="password" id="password" name="password" class="form-input has-icon has-icon-right"
                   placeholder="Enter your password" required autocomplete="current-password">
            <button type="button" class="input-icon-right" id="pwToggle" aria-label="Toggle password">
              <i class="bi bi-eye" id="pwIcon"></i>
            </button>
          </div>
        </div>

        <div class="form-group" style="flex-direction:row; align-items:center; gap:var(--sp-2);">
          <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe">
          <label class="form-check-label" for="rememberMe">Keep me signed in</label>
        </div>

        <button type="submit" class="btn btn-primary btn-lg w-100 mt-2" id="loginBtn">
          <i class="bi bi-arrow-right-circle me-2"></i> Sign In
        </button>

      </form>

      <div class="auth-divider">or</div>

      <p class="auth-footer-text">
        Don't have an account? <a href="${pageContext.request.contextPath}/signup">Create one →</a>
      </p>

    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
<script>
  // Password toggle
  document.getElementById('pwToggle').addEventListener('click', function(){
    const pw = document.getElementById('password');
    const ic = document.getElementById('pwIcon');
    if(pw.type === 'password'){
      pw.type = 'text';
      ic.className = 'bi bi-eye-slash';
    } else {
      pw.type = 'password';
      ic.className = 'bi bi-eye';
    }
  });
  // Submit spinner
  document.getElementById('loginForm').addEventListener('submit', function(){
    const btn = document.getElementById('loginBtn');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Signing in...';
  });
</script>
</body>
</html>
