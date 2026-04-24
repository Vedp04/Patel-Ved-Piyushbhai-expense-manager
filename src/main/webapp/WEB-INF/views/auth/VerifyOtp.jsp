<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Verify OTP — MoneyTrail</title>
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

      <div style="text-align:center; margin-bottom:var(--sp-6);">
        <div style="width:72px;height:72px;background:linear-gradient(135deg,var(--accent-500),var(--brand-500));border-radius:var(--r-2xl);display:inline-flex;align-items:center;justify-content:center;margin-bottom:var(--sp-4);box-shadow:0 4px 20px rgba(99,102,241,0.3);">
          <i class="bi bi-phone text-white" style="font-size:28px;"></i>
        </div>
        <h2 class="auth-form-title">Check Your Email</h2>
        <p class="auth-form-subtitle">
          We sent a 6-digit code to <strong style="color:var(--text-primary);">${not empty email ? email : 'your email'}</strong>.<br>
          Enter it below to verify your identity.
        </p>
      </div>

      <c:if test="${not empty error}">
        <div class="alert alert-danger d-flex align-items-center gap-2">
          <i class="bi bi-exclamation-circle-fill"></i><div>${error}</div>
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/verify-otp" method="POST" id="otpForm">
        <input type="hidden" name="email" value="${email}">

        <div class="otp-inputs">
          <input type="text" class="otp-digit" maxlength="1" inputmode="numeric" pattern="[0-9]" name="d1" id="d1" autocomplete="off">
          <input type="text" class="otp-digit" maxlength="1" inputmode="numeric" pattern="[0-9]" name="d2" id="d2" autocomplete="off">
          <input type="text" class="otp-digit" maxlength="1" inputmode="numeric" pattern="[0-9]" name="d3" id="d3" autocomplete="off">
          <input type="text" class="otp-digit" maxlength="1" inputmode="numeric" pattern="[0-9]" name="d4" id="d4" autocomplete="off">
          <input type="text" class="otp-digit" maxlength="1" inputmode="numeric" pattern="[0-9]" name="d5" id="d5" autocomplete="off">
          <input type="text" class="otp-digit" maxlength="1" inputmode="numeric" pattern="[0-9]" name="d6" id="d6" autocomplete="off">
        </div>
        <!-- Hidden combined OTP field -->
        <input type="hidden" name="otp" id="otpHidden">

        <button type="submit" class="btn btn-primary btn-lg w-100" id="verifyBtn" disabled>
          <i class="bi bi-check-circle me-2"></i> Verify OTP
        </button>
      </form>

      <div style="text-align:center; margin-top:var(--sp-5);">
        <p style="font-size:var(--text-sm); color:var(--text-muted);">Didn't receive the code?</p>
        <a href="${pageContext.request.contextPath}/forgot-password" class="btn btn-ghost btn-sm mt-2">
          <i class="bi bi-arrow-clockwise me-1"></i> Resend OTP
        </a>
      </div>

    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
<script>
  const digits = document.querySelectorAll('.otp-digit');
  const verifyBtn = document.getElementById('verifyBtn');
  const hiddenOtp = document.getElementById('otpHidden');

  digits.forEach((d, i) => {
    d.addEventListener('input', function(){
      this.value = this.value.replace(/[^0-9]/g,'');
      if(this.value && i < digits.length - 1) digits[i+1].focus();
      updateOtp();
    });
    d.addEventListener('keydown', function(e){
      if(e.key === 'Backspace' && !this.value && i > 0) digits[i-1].focus();
    });
    d.addEventListener('paste', function(e){
      const paste = (e.clipboardData || window.clipboardData).getData('text').replace(/\D/g,'');
      paste.split('').forEach((ch, idx) => { if(digits[idx]) digits[idx].value = ch; });
      updateOtp(); e.preventDefault();
    });
  });

  function updateOtp(){
    let val = Array.from(digits).map(d=>d.value).join('');
    hiddenOtp.value = val;
    verifyBtn.disabled = val.length < 6;
    digits.forEach(d => d.classList.toggle('filled', d.value !== ''));
  }

  document.getElementById('otpForm').addEventListener('submit', function(){
    verifyBtn.disabled = true;
    verifyBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Verifying...';
  });
  digits[0].focus();
</script>
</body>
</html>
