<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="${not empty theme ? theme : 'dark'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Profile — MoneyTrail</title>
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

      <!-- PAGE HEADER -->
      <div class="page-header">
        <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
          <div>
            <h1 class="page-title"><i class="bi bi-person-circle"></i> My Profile</h1>
            <p class="page-subtitle">Manage your personal information and account settings</p>
          </div>
        </div>
      </div>

      <div style="display:grid;grid-template-columns:300px 1fr;gap:var(--sp-6);align-items:start;">

        <!-- =====================
             LEFT: Profile Card
        ===================== -->
        <div style="display:flex;flex-direction:column;gap:var(--sp-4);">

          <!-- Avatar Card -->
          <div class="card">
            <div class="card-body" style="display:flex;flex-direction:column;align-items:center;gap:var(--sp-4);padding:var(--sp-8) var(--sp-4);">

              <!-- Avatar -->
              <div style="position:relative;">
                <c:choose>
                  <c:when test="${not empty sessionScope.user.profilePicURL}">
                    <img src="${sessionScope.user.profilePicURL}"
                         alt="Profile"
                         style="width:100px;height:100px;border-radius:50%;object-fit:cover;border:3px solid var(--brand-500);">
                  </c:when>
                  <c:otherwise>
                    <div style="width:100px;height:100px;border-radius:50%;background:linear-gradient(135deg,var(--brand-400),var(--accent-500));display:flex;align-items:center;justify-content:center;font-size:38px;font-weight:700;color:#fff;border:3px solid var(--brand-500);">
                      ${not empty sessionScope.user.firstName ? sessionScope.user.firstName.substring(0,1).toUpperCase() : 'U'}
                    </div>
                  </c:otherwise>
                </c:choose>
                <!-- Upload trigger badge -->
                <label for="profilePicUpload" style="position:absolute;bottom:2px;right:2px;width:28px;height:28px;background:var(--brand-500);border-radius:50%;display:flex;align-items:center;justify-content:center;cursor:pointer;border:2px solid var(--bg-surface);" title="Change photo">
                  <i class="bi bi-camera-fill" style="font-size:12px;color:#fff;"></i>
                </label>
              </div>

              <!-- Name & Role -->
              <div style="text-align:center;">
                <div style="font-size:var(--text-lg);font-weight:700;color:var(--text-primary);">
                  ${not empty sessionScope.user.firstName ? sessionScope.user.firstName : ''}
                  ${not empty sessionScope.user.lastName ? sessionScope.user.lastName : ''}
                </div>
                <div style="margin-top:var(--sp-1);">
                  <span class="badge ${sessionScope.user.role == 'Admin' ? 'badge-accent' : 'badge-neutral'}">${not empty sessionScope.user.role ? sessionScope.user.role : 'User'}</span>
                </div>
                <div style="font-size:var(--text-xs);color:var(--text-muted);margin-top:var(--sp-2);">
                  <i class="bi bi-envelope me-1"></i>${not empty sessionScope.user.email ? sessionScope.user.email : ''}
                </div>
              </div>

              <!-- Status Badge -->
              <span class="badge ${sessionScope.user.active ? 'badge-success badge-dot' : 'badge-danger badge-dot'}" style="font-size:var(--text-xs);">
                ${sessionScope.user.active ? 'Active Account' : 'Inactive Account'}
              </span>

            </div>
          </div>

          <!-- Info Summary Card -->
          <div class="card">
            <div class="card-header">
              <div class="card-title"><i class="bi bi-info-circle" style="color:var(--brand-500);"></i> Account Info</div>
            </div>
            <div class="card-body" style="padding:var(--sp-4);display:flex;flex-direction:column;gap:var(--sp-3);">

              <div style="display:flex;justify-content:space-between;align-items:center;font-size:var(--text-sm);">
                <span style="color:var(--text-muted);">Member Since</span>
                <span style="font-weight:600;color:var(--text-primary);">${not empty sessionScope.user.creatAtDate ? sessionScope.user.creatAtDate : '—'}</span>
              </div>
              <div style="height:1px;background:var(--border-color);"></div>

              <div style="display:flex;justify-content:space-between;align-items:center;font-size:var(--text-sm);">
                <span style="color:var(--text-muted);">Gender</span>
                <span style="font-weight:600;color:var(--text-primary);">${not empty sessionScope.user.gender ? sessionScope.user.gender : '—'}</span>
              </div>
              <div style="height:1px;background:var(--border-color);"></div>

              <div style="display:flex;justify-content:space-between;align-items:center;font-size:var(--text-sm);">
                <span style="color:var(--text-muted);">Birth Year</span>
                <span style="font-weight:600;color:var(--text-primary);">${not empty sessionScope.user.birthYear ? sessionScope.user.birthYear : '—'}</span>
              </div>
              <div style="height:1px;background:var(--border-color);"></div>

              <div style="display:flex;justify-content:space-between;align-items:center;font-size:var(--text-sm);">
                <span style="color:var(--text-muted);">Contact</span>
                <span style="font-weight:600;color:var(--text-primary);">${not empty sessionScope.user.contactNum ? sessionScope.user.contactNum : '—'}</span>
              </div>

            </div>
          </div>

        </div>

        <!-- =====================
             RIGHT: Edit Form
        ===================== -->
        <div style="display:flex;flex-direction:column;gap:var(--sp-4);">

          <!-- Personal Info Form -->
          <div class="card">
            <div class="card-header">
              <div class="card-title"><i class="bi bi-pencil-square" style="color:var(--accent-500);"></i> Edit Personal Info</div>
            </div>
            <div class="card-body" style="padding:var(--sp-6);">

              <form action="${pageContext.request.contextPath}/profile/update" method="POST"
                    id="profileForm" enctype="multipart/form-data" novalidate>

                <input type="hidden" name="userId" value="${sessionScope.user.userId}">

                <!-- Hidden file input triggered by camera badge -->
                <input type="file" id="profilePicUpload" name="profilePic" accept="image/*" style="display:none;">

                <!-- First Name + Last Name -->
                <div class="form-row" style="margin-bottom:var(--sp-4);">
                  <div class="form-group">
                    <label class="form-label" for="firstName">First Name <span class="required">*</span></label>
                    <div class="input-wrapper">
                      <i class="bi bi-person input-icon"></i>
                      <input type="text" id="firstName" name="firstName" class="form-input has-icon"
                             placeholder="John" required
                             value="${not empty sessionScope.user.firstName ? sessionScope.user.firstName : ''}">
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="form-label" for="lastName">Last Name <span class="required">*</span></label>
                    <div class="input-wrapper">
                      <i class="bi bi-person input-icon"></i>
                      <input type="text" id="lastName" name="lastName" class="form-input has-icon"
                             placeholder="Doe" required
                             value="${not empty sessionScope.user.lastName ? sessionScope.user.lastName : ''}">
                    </div>
                  </div>
                </div>

                <!-- Email -->
                <div class="form-group" style="margin-bottom:var(--sp-4);">
                  <label class="form-label" for="email">Email Address <span class="required">*</span></label>
                  <div class="input-wrapper">
                    <i class="bi bi-envelope input-icon"></i>
                    <input type="email" id="email" name="email" class="form-input has-icon"
                           placeholder="you@example.com" required
                           value="${not empty sessionScope.user.email ? sessionScope.user.email : ''}">
                  </div>
                </div>

                <!-- Contact + Birth Year -->
                <div class="form-row" style="margin-bottom:var(--sp-4);">
                  <div class="form-group">
                    <label class="form-label" for="contactNum">Contact Number</label>
                    <div class="input-wrapper">
                      <i class="bi bi-telephone input-icon"></i>
                      <input type="tel" id="contactNum" name="contactNum" class="form-input has-icon"
                             placeholder="+91 98765 43210" maxlength="15"
                             value="${not empty sessionScope.user.contactNum ? sessionScope.user.contactNum : ''}">
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="form-label" for="birthYear">Birth Year</label>
                    <div class="input-wrapper">
                      <i class="bi bi-calendar3 input-icon"></i>
                      <input type="number" id="birthYear" name="birthYear" class="form-input has-icon"
                             placeholder="2000" min="1900" max="2015"
                             value="${not empty sessionScope.user.birthYear ? sessionScope.user.birthYear : ''}">
                    </div>
                  </div>
                </div>

                <!-- Gender -->
                <div class="form-group" style="margin-bottom:var(--sp-6);">
                  <label class="form-label">Gender</label>
                  <div style="display:flex;gap:var(--sp-4);flex-wrap:wrap;margin-top:var(--sp-1);">
                    <label style="display:flex;align-items:center;gap:var(--sp-2);cursor:pointer;font-size:var(--text-sm);color:var(--text-primary);">
                      <input type="radio" name="gender" value="Male"
                             ${sessionScope.user.gender == 'Male' ? 'checked' : ''}
                             style="accent-color:var(--brand-500);width:16px;height:16px;"> Male
                    </label>
                    <label style="display:flex;align-items:center;gap:var(--sp-2);cursor:pointer;font-size:var(--text-sm);color:var(--text-primary);">
                      <input type="radio" name="gender" value="Female"
                             ${sessionScope.user.gender == 'Female' ? 'checked' : ''}
                             style="accent-color:var(--brand-500);width:16px;height:16px;"> Female
                    </label>
                    <label style="display:flex;align-items:center;gap:var(--sp-2);cursor:pointer;font-size:var(--text-sm);color:var(--text-primary);">
                      <input type="radio" name="gender" value="Other"
                             ${sessionScope.user.gender == 'Other' ? 'checked' : ''}
                             style="accent-color:var(--brand-500);width:16px;height:16px;"> Other
                    </label>
                  </div>
                </div>

                <!-- Submit -->
                <div class="d-flex gap-3">
                  <button type="submit" class="btn btn-primary" id="saveBtn">
                    <i class="bi bi-check2-circle me-2"></i> Save Changes
                  </button>
                  <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                    <i class="bi bi-x-circle me-1"></i> Cancel
                  </a>
                </div>

              </form>
            </div>
          </div>

          <!-- Change Password Card -->
          <div class="card">
            <div class="card-header">
              <div class="card-title"><i class="bi bi-shield-lock" style="color:var(--warning-500);"></i> Change Password</div>
            </div>
            <div class="card-body" style="padding:var(--sp-6);">

              <form action="${pageContext.request.contextPath}/profile/change-password" method="POST"
                    id="pwForm" novalidate>

                <input type="hidden" name="userId" value="${sessionScope.user.userId}">

                <div class="form-group" style="margin-bottom:var(--sp-4);">
                  <label class="form-label" for="currentPassword">Current Password <span class="required">*</span></label>
                  <div class="input-wrapper">
                    <i class="bi bi-lock input-icon"></i>
                    <input type="password" id="currentPassword" name="currentPassword"
                           class="form-input has-icon has-icon-right"
                           placeholder="Enter current password" required autocomplete="current-password">
                    <button type="button" class="input-icon-right" onclick="togglePw('currentPassword', 'icCurrent')">
                      <i class="bi bi-eye" id="icCurrent"></i>
                    </button>
                  </div>
                </div>

                <div class="form-row" style="margin-bottom:var(--sp-4);">
                  <div class="form-group">
                    <label class="form-label" for="newPassword">New Password <span class="required">*</span></label>
                    <div class="input-wrapper">
                      <i class="bi bi-lock-fill input-icon"></i>
                      <input type="password" id="newPassword" name="newPassword"
                             class="form-input has-icon has-icon-right"
                             placeholder="Min 8 characters" required minlength="8" autocomplete="new-password">
                      <button type="button" class="input-icon-right" onclick="togglePw('newPassword', 'icNew')">
                        <i class="bi bi-eye" id="icNew"></i>
                      </button>
                    </div>
                    <!-- Strength meter -->
                    <div class="pw-strength" id="pwStrength" style="display:none;margin-top:var(--sp-2);">
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
                    <label class="form-label" for="confirmNewPassword">Confirm New Password <span class="required">*</span></label>
                    <div class="input-wrapper">
                      <i class="bi bi-lock-fill input-icon"></i>
                      <input type="password" id="confirmNewPassword" name="confirmNewPassword"
                             class="form-input has-icon"
                             placeholder="Repeat new password" required autocomplete="new-password">
                    </div>
                    <div class="form-hint" id="confirmHint" style="display:none;color:var(--danger-500);font-size:var(--text-xs);margin-top:var(--sp-1);">
                      <i class="bi bi-exclamation-circle me-1"></i>Passwords do not match
                    </div>
                  </div>
                </div>

                <button type="submit" class="btn btn-warning" id="pwBtn">
                  <i class="bi bi-shield-check me-2"></i> Update Password
                </button>

              </form>
            </div>
          </div>

        </div>
      </div>

    </main>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
  </div>
</div>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
<script>
  // Generic password toggle
  function togglePw(inputId, iconId) {
    const input = document.getElementById(inputId);
    const icon  = document.getElementById(iconId);
    input.type  = input.type === 'password' ? 'text' : 'password';
    icon.className = input.type === 'password' ? 'bi bi-eye' : 'bi bi-eye-slash';
  }

  // Password strength meter
  document.getElementById('newPassword').addEventListener('input', function () {
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
      document.getElementById(b).className = 'pw-bar' + (i < score ? ' ' + cls : '');
    });
    document.getElementById('pwLabel').textContent = score <= 1 ? 'Weak' : score <= 2 ? 'Medium' : 'Strong';
    checkConfirm();
  });

  // Confirm match
  function checkConfirm() {
    const np   = document.getElementById('newPassword').value;
    const cp   = document.getElementById('confirmNewPassword').value;
    const hint = document.getElementById('confirmHint');
    hint.style.display = (cp.length > 0 && np !== cp) ? 'block' : 'none';
  }
  document.getElementById('confirmNewPassword').addEventListener('input', checkConfirm);

  // Password form submit guard
  document.getElementById('pwForm').addEventListener('submit', function (e) {
    const np = document.getElementById('newPassword').value;
    const cp = document.getElementById('confirmNewPassword').value;
    if (np !== cp) {
      e.preventDefault();
      document.getElementById('confirmHint').style.display = 'block';
      document.getElementById('confirmNewPassword').focus();
      return;
    }
    const btn = document.getElementById('pwBtn');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Updating...';
  });

  // Profile form submit loader
  document.getElementById('profileForm').addEventListener('submit', function () {
    const btn = document.getElementById('saveBtn');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Saving...';
  });

  // Profile pic preview on file select
  document.getElementById('profilePicUpload').addEventListener('change', function () {
    if (this.files && this.files[0]) {
      document.getElementById('profileForm').submit();
    }
  });
</script>
<script src="${pageContext.request.contextPath}/js/app.js"></script>
<script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/js/theme-switcher.js"></script>
</body>
</html>
