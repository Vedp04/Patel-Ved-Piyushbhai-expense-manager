<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reset Password — MoneyTrail</title>
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
        <div style="width:72px;height:72px;background:linear-gradient(135deg,var(--success-500),var(--brand-500));border-radius:var(--r-2xl);display:inline-flex;align-items:center;justify-content:center;margin-bottom:var(--sp-4);">
          <i class="bi bi-key-fill text-white" style="font-size:28px;"></i>
        </div>
        <h2 class="auth-form-title">Set New Password</h2>
        <p class="auth-form-subtitle">Choose a strong password for your account. Make it unique and hard to guess.</p>
      </div>

      <c:if test="${not empty error}">
        <div class="alert alert-danger d-flex align-items-center gap-2">
          <i class="bi bi-exclamation-circle-fill"></i><div>${error}</div>
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/reset-password" method="POST" id="resetForm">
        <input type="hidden" name="email" value="${email}">
        <input type="hidden" name="otp"   value="${otp}">

        <div class="form-group">
          <label class="form-label" for="password">New Password <span class="required">*</span></label>
          <div class="input-wrapper">
            <i class="bi bi-lock input-icon"></i>
            <input type="password" id="password" name="password" class="form-input has-icon has-icon-right"
                   placeholder="Min 8 characters" required minlength="8" autocomplete="new-password">
            <button type="button" class="input-icon-right" id="pwToggle"><i class="bi bi-eye" id="pwIcon"></i></button>
          </div>
          <div class="pw-strength" id="pwStrength" style="display:none;">
            <div class="pw-bars">
              <div class="pw-bar" id="b1"></div><div class="pw-bar" id="b2"></div>
              <div class="pw-bar" id="b3"></div><div class="pw-bar" id="b4"></div>
            </div>
            <div class="pw-label" id="pwLabel"></div>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="confirmPassword">Confirm New Password <span class="required">*</span></label>
          <div class="input-wrapper">
            <i class="bi bi-lock-fill input-icon"></i>
            <input type="password" id="confirmPassword" name="confirmPassword" class="form-input has-icon"
                   placeholder="Repeat password" required autocomplete="new-password">
          </div>
          <div class="form-error" id="matchError" style="display:none;"><i class="bi bi-x-circle"></i> Passwords do not match</div>
        </div>

        <button type="submit" class="btn btn-primary btn-lg w-100" id="resetBtn">
          <i class="bi bi-check-circle me-2"></i> Reset Password
        </button>
      </form>

    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
<script>
  document.getElementById('pwToggle').addEventListener('click', function(){
    const pw = document.getElementById('password');
    const ic = document.getElementById('pwIcon');
    pw.type = pw.type === 'password' ? 'text' : 'password';
    ic.className = pw.type === 'password' ? 'bi bi-eye' : 'bi bi-eye-slash';
  });
  document.getElementById('password').addEventListener('input', function(){
    const v = this.value, s = document.getElementById('pwStrength');
    if(!v){ s.style.display='none'; return; } s.style.display='block';
    let sc = 0;
    if(v.length>=8) sc++; if(/[A-Z]/.test(v)) sc++; if(/[0-9]/.test(v)) sc++; if(/[^A-Za-z0-9]/.test(v)) sc++;
    const cl = sc<=1?'weak':sc<=2?'medium':'strong';
    ['b1','b2','b3','b4'].forEach((b,i)=>{ document.getElementById(b).className='pw-bar'+(i<sc?' '+cl:''); });
    document.getElementById('pwLabel').textContent = sc<=1?'Weak':sc<=2?'Medium':'Strong';
  });
  document.getElementById('confirmPassword').addEventListener('input', function(){
    const match = this.value === document.getElementById('password').value;
    document.getElementById('matchError').style.display = (!match && this.value) ? 'flex' : 'none';
  });
  document.getElementById('resetForm').addEventListener('submit', function(e){
    const pw = document.getElementById('password').value;
    const cpw = document.getElementById('confirmPassword').value;
    if(pw !== cpw){ e.preventDefault(); document.getElementById('matchError').style.display='flex'; return; }
    const btn = document.getElementById('resetBtn');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Updating...';
  });
</script>
</body>
</html>
