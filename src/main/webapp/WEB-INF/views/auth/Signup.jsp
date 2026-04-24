<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Create Account — MoneyTrail</title>
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
      <h1 class="auth-panel-title">Start Your<br>Financial Journey.</h1>
      <p class="auth-panel-desc">Join thousands who track their money with MoneyTrail. It's free and takes less than 2 minutes to get started.</p>
      <div class="auth-features">
        <div class="auth-feature">
          <div class="auth-feature-icon"><i class="bi bi-lightning-charge text-white" style="font-size:17px;"></i></div>
          <div class="auth-feature-text"><strong>Instant Setup</strong><span>Ready in under 2 minutes</span></div>
        </div>
        <div class="auth-feature">
          <div class="auth-feature-icon"><i class="bi bi-bar-chart-fill text-white" style="font-size:17px;"></i></div>
          <div class="auth-feature-text"><strong>Rich Reports</strong><span>Understand your spending patterns</span></div>
        </div>
        <div class="auth-feature">
          <div class="auth-feature-icon"><i class="bi bi-cloud-check text-white" style="font-size:17px;"></i></div>
          <div class="auth-feature-text"><strong>Always Synced</strong><span>Access from anywhere, anytime</span></div>
        </div>
      </div>
    </div>
  </div>

  <!-- RIGHT FORM -->
  <div class="auth-form-side">
    <div class="auth-form-box">

      <h2 class="auth-form-title">Create account</h2>
      <p class="auth-form-subtitle">Fill in your details to get started with MoneyTrail</p>

      <c:if test="${not empty error}">
        <div class="alert alert-danger d-flex align-items-center gap-2">
          <i class="bi bi-exclamation-circle-fill"></i><div>${error}</div>
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/register" method="POST" id="signupForm" enctype="multipart/form-data" novalidate>

        <!-- First Name + Last Name -->
        <div class="form-row">
          <div class="form-group">
            <label class="form-label" for="firstName">First Name <span class="required">*</span></label>
            <div class="input-wrapper">
              <i class="bi bi-person input-icon"></i>
              <input type="text" id="firstName" name="firstName" class="form-input has-icon"
                     placeholder="John" required value="${not empty param.firstName ? param.firstName : ''}">
            </div>
          </div>
          <div class="form-group">
            <label class="form-label" for="lastName">Last Name <span class="required">*</span></label>
            <div class="input-wrapper">
              <i class="bi bi-person input-icon"></i>
              <input type="text" id="lastName" name="lastName" class="form-input has-icon"
                     placeholder="Doe" required value="${not empty param.lastName ? param.lastName : ''}">
            </div>
          </div>
        </div>

        <!-- Email -->
        <div class="form-group">
          <label class="form-label" for="email">Email Address <span class="required">*</span></label>
          <div class="input-wrapper">
            <i class="bi bi-envelope input-icon"></i>
            <input type="email" id="email" name="email" class="form-input has-icon"
                   placeholder="you@example.com" required autocomplete="email"
                   value="${not empty param.email ? param.email : ''}">
          </div>
        </div>

        <!-- Contact Number + Birth Year -->
        <div class="form-row">
          <div class="form-group">
            <label class="form-label" for="contactNum">Contact Number</label>
            <div class="input-wrapper">
              <i class="bi bi-telephone input-icon"></i>
              <input type="tel" id="contactNum" name="contactNum" class="form-input has-icon"
                     placeholder="+91 98765 43210" maxlength="15"
                     value="${not empty param.contactNum ? param.contactNum : ''}">
            </div>
          </div>
          <div class="form-group">
            <label class="form-label" for="birthYear">Birth Year</label>
            <div class="input-wrapper">
              <i class="bi bi-calendar3 input-icon"></i>
              <input type="number" id="birthYear" name="birthYear" class="form-input has-icon"
                     placeholder="2000" min="1900" max="2015"
                     value="${not empty param.birthYear ? param.birthYear : ''}">
            </div>
          </div>
        </div>

        <!-- Gender -->
        <div class="form-group">
          <label class="form-label">Gender</label>
          <div style="display:flex; gap:var(--sp-4); flex-wrap:wrap; margin-top:var(--sp-1);">
            <label style="display:flex;align-items:center;gap:var(--sp-2);cursor:pointer;font-size:var(--text-sm);color:var(--text-primary);">
              <input type="radio" name="gender" value="Male"
                     ${param.gender == 'Male' ? 'checked' : ''}
                     style="accent-color:var(--brand-500);width:16px;height:16px;"> Male
            </label>
            <label style="display:flex;align-items:center;gap:var(--sp-2);cursor:pointer;font-size:var(--text-sm);color:var(--text-primary);">
              <input type="radio" name="gender" value="Female"
                     ${param.gender == 'Female' ? 'checked' : ''}
                     style="accent-color:var(--brand-500);width:16px;height:16px;"> Female
            </label>
            <label style="display:flex;align-items:center;gap:var(--sp-2);cursor:pointer;font-size:var(--text-sm);color:var(--text-primary);">
              <input type="radio" name="gender" value="Other"
                     ${param.gender == 'Other' ? 'checked' : ''}
                     style="accent-color:var(--brand-500);width:16px;height:16px;"> Other
            </label>
          </div>
        </div>

        <!-- Password -->
        <div class="form-group">
          <label class="form-label" for="password">Password <span class="required">*</span></label>
          <div class="input-wrapper">
            <i class="bi bi-lock input-icon"></i>
            <input type="password" id="password" name="password" class="form-input has-icon has-icon-right"
                   placeholder="Min 8 characters" required minlength="8" autocomplete="new-password">
            <button type="button" class="input-icon-right" id="pwToggle"><i class="bi bi-eye" id="pwIcon"></i></button>
          </div>
          <div class="pw-strength" id="pwStrength" style="display:none;">
            <div class="pw-bars">
              <div class="pw-bar" id="bar1"></div>
              <div class="pw-bar" id="bar2"></div>
              <div class="pw-bar" id="bar3"></div>
              <div class="pw-bar" id="bar4"></div>
            </div>
            <div class="pw-label" id="pwLabel">Weak</div>
          </div>
        </div>
        <div class="form-group">
		  <label class="form-label" for="confirmPassword">Confirm Password <span class="required">*</span></label>
		  <div class="input-wrapper">
		    <i class="bi bi-lock-fill input-icon"></i>
		    <input type="password" id="confirmPassword" name="confirmPassword" 
		           class="form-input has-icon" placeholder="Repeat password" required>
		  </div>
		  <div class="form-hint" id="confirmHint" style="display:none;color:var(--danger-500);font-size:var(--text-xs);">
		    <i class="bi bi-exclamation-circle me-1"></i>Passwords do not match
		  </div>
		</div>
        
        <!-- Profile Picture -->
		<div class="form-group">
		  <label class="form-label" for="profilePic">Profile Picture</label>
		  <div class="input-wrapper">
		    <i class="bi bi-image input-icon"></i>
		    <input type="file" id="profilePic" name="profilePic"
		           class="form-input has-icon"
		           accept="image/*"
		           style="padding-top:6px;">
		  </div>
		</div>

        <!-- Terms -->
        <div class="form-group" style="flex-direction:row; align-items:flex-start; gap:var(--sp-2);">
          <input type="checkbox" class="form-check-input mt-1" id="terms" name="terms" required>
          <label class="form-check-label" for="terms">
            I agree to the <a href="#" style="color:var(--brand-500);">Terms of Service</a> and
            <a href="#" style="color:var(--brand-500);">Privacy Policy</a>
          </label>
        </div>

        <button type="submit" class="btn btn-primary btn-lg w-100 mt-2" id="signupBtn">
          <i class="bi bi-person-plus me-2"></i> Create Account
        </button>

      </form>

      <p class="auth-footer-text mt-4">
        Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in →</a>
      </p>

    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
<script>
  // Password toggle
  document.getElementById('pwToggle').addEventListener('click', function () {
    const pw = document.getElementById('password');
    const ic = document.getElementById('pwIcon');
    pw.type = pw.type === 'password' ? 'text' : 'password';
    ic.className = pw.type === 'password' ? 'bi bi-eye' : 'bi bi-eye-slash';
  });

  // Password strength meter
  document.getElementById('password').addEventListener('input', function () {
    const v = this.value;
    const s = document.getElementById('pwStrength');
    if (!v) { s.style.display = 'none'; return; }
    s.style.display = 'block';
    let score = 0;
    if (v.length >= 8) score++;
    if (/[A-Z]/.test(v)) score++;
    if (/[0-9]/.test(v)) score++;
    if (/[^A-Za-z0-9]/.test(v)) score++;
    const cls = score <= 1 ? 'weak' : score <= 2 ? 'medium' : 'strong';
    ['bar1','bar2','bar3','bar4'].forEach(function (b, i) {
      const el = document.getElementById(b);
      el.className = 'pw-bar' + (i < score ? ' ' + cls : '');
    });
    document.getElementById('pwLabel').textContent = score <= 1 ? 'Weak' : score <= 2 ? 'Medium' : 'Strong';

    // Re-check confirm match live
    checkConfirm();
  });

  // Confirm password match check
  function checkConfirm() {
    const pw = document.getElementById('password').value;
    const cp = document.getElementById('confirmPassword').value;
    const hint = document.getElementById('confirmHint');
    if (cp.length > 0) {
      hint.style.display = pw !== cp ? 'block' : 'none';
    } else {
      hint.style.display = 'none';
    }
  }
  document.getElementById('confirmPassword').addEventListener('input', checkConfirm);

  // Submit button loader + confirm validation
  document.getElementById('signupForm').addEventListener('submit', function (e) {
    const pw  = document.getElementById('password').value;
    const cp  = document.getElementById('confirmPassword').value;
    if (pw !== cp) {
      e.preventDefault();
      document.getElementById('confirmHint').style.display = 'block';
      document.getElementById('confirmPassword').focus();
      return;
    }
    const btn = document.getElementById('signupBtn');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Creating account...';
  });
</script>
</body>
</html>
