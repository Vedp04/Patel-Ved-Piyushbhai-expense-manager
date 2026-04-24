<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Forgot Password — MoneyTrail</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap-icons.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/variables.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">
</head>
<body>

<div class="auth-shell" style="grid-template-columns:1fr;">
  <div class="auth-form-side" style="background:var(--bg-app);">
    <div class="auth-form-box">

      <a href="${pageContext.request.contextPath}/login"
         style="display:inline-flex;align-items:center;gap:6px;color:var(--text-muted);font-size:var(--text-sm);font-weight:500;text-decoration:none;margin-bottom:var(--sp-6);">
        <i class="bi bi-arrow-left"></i> Back to Sign In
      </a>

      <div style="text-align:center;margin-bottom:var(--sp-6);">
        <div style="width:72px;height:72px;background:linear-gradient(135deg,var(--brand-500),var(--accent-500));border-radius:var(--r-2xl);display:inline-flex;align-items:center;justify-content:center;margin-bottom:var(--sp-4);box-shadow:var(--shadow-brand);">
          <i class="bi bi-shield-lock-fill text-white" style="font-size:28px;"></i>
        </div>
        <h2 class="auth-form-title">Forgot Password?</h2>
        <p class="auth-form-subtitle">Enter your registered email and we'll send you a 6-digit OTP to reset your password.</p>
      </div>

      <c:if test="${not empty error}">
        <div class="alert alert-danger d-flex align-items-center gap-2">
          <i class="bi bi-exclamation-circle-fill"></i><div>${error}</div>
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/send-otp" method="POST" id="forgotForm">
        <div class="form-group">
          <label class="form-label" for="email">Registered Email <span class="required">*</span></label>
          <div class="input-wrapper">
            <i class="bi bi-envelope input-icon"></i>
            <input type="email" id="email" name="email" class="form-input has-icon"
                   placeholder="you@example.com" required autocomplete="email">
          </div>
          <span class="form-help">We'll send a 6-digit verification OTP to this address.</span>
        </div>

        <button type="submit" class="btn btn-primary btn-lg w-100" id="sendBtn">
          <i class="bi bi-send me-2"></i> Send OTP
        </button>
      </form>

      <p class="auth-footer-text mt-4">
        Remembered your password? <a href="${pageContext.request.contextPath}/login">Sign in</a>
      </p>

    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
<script>
  document.getElementById('forgotForm').addEventListener('submit', function(){
    const btn = document.getElementById('sendBtn');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Sending OTP...';
  });
</script>
</body>
</html>
