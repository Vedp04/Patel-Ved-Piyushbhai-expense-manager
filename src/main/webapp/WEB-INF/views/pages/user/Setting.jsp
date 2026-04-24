<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="${not empty theme ? theme : 'dark'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Settings — MoneyTrail</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap-icons.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/variables.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
  <style>
    .settings-nav { display:flex; flex-direction:column; gap:2px; }
    .settings-nav-item {
      display:flex; align-items:center; gap:var(--sp-3);
      padding:var(--sp-3) var(--sp-4); border-radius:var(--r-lg);
      font-size:var(--text-sm); font-weight:500; color:var(--text-muted);
      cursor:pointer; border:none; background:transparent; text-align:left;
      transition:background 0.15s, color 0.15s;
    }
    .settings-nav-item:hover { background:var(--bg-hover); color:var(--text-primary); }
    .settings-nav-item.active { background:var(--brand-50); color:var(--brand-600); }
    .settings-nav-item i { font-size:16px; width:18px; text-align:center; }

    .settings-section { display:none; }
    .settings-section.active { display:block; }

    .setting-row {
      display:flex; align-items:center; justify-content:space-between;
      padding:var(--sp-4) 0; border-bottom:1px solid var(--border-color);
      gap:var(--sp-4);
    }
    .setting-row:last-child { border-bottom:none; padding-bottom:0; }
    .setting-row-info { flex:1; }
    .setting-row-label { font-size:var(--text-sm); font-weight:600; color:var(--text-primary); }
    .setting-row-desc  { font-size:var(--text-xs); color:var(--text-muted); margin-top:2px; }

    /* Toggle switch */
    .toggle-switch { position:relative; display:inline-block; width:44px; height:24px; flex-shrink:0; }
    .toggle-switch input { opacity:0; width:0; height:0; }
    .toggle-slider {
      position:absolute; cursor:pointer; inset:0;
      background:var(--border-color); border-radius:24px;
      transition:background 0.2s;
    }
    .toggle-slider:before {
      content:''; position:absolute;
      width:18px; height:18px; left:3px; bottom:3px;
      background:#fff; border-radius:50%; transition:transform 0.2s;
    }
    .toggle-switch input:checked + .toggle-slider { background:var(--brand-500); }
    .toggle-switch input:checked + .toggle-slider:before { transform:translateX(20px); }

    /* Theme selector tiles */
    .theme-tiles { display:flex; gap:var(--sp-3); flex-wrap:wrap; }
    .theme-tile {
      width:80px; cursor:pointer; border-radius:var(--r-lg);
      border:2px solid var(--border-color); overflow:hidden;
      transition:border-color 0.15s; text-align:center;
    }
    .theme-tile:hover { border-color:var(--brand-400); }
    .theme-tile.selected { border-color:var(--brand-500); }
    .theme-tile-preview {
      height:48px; display:flex; flex-direction:column;
      gap:4px; padding:6px;
    }
    .theme-tile-bar { border-radius:2px; height:6px; }
    .theme-tile-label { font-size:11px; font-weight:600; padding:4px 0; color:var(--text-muted); }
    .theme-tile.selected .theme-tile-label { color:var(--brand-500); }

    /* Danger zone */
    .danger-action {
      display:flex; align-items:center; justify-content:space-between;
      padding:var(--sp-4); border-radius:var(--r-lg);
      border:1px solid var(--danger-200, #fca5a5); background:var(--danger-50);
      gap:var(--sp-4); margin-bottom:var(--sp-3);
    }
    .danger-action:last-child { margin-bottom:0; }
    .danger-action-info .danger-action-label { font-size:var(--text-sm); font-weight:600; color:var(--danger-700, #b91c1c); }
    .danger-action-info .danger-action-desc  { font-size:var(--text-xs); color:var(--danger-500, #ef4444); margin-top:2px; }
  </style>
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
        <div>
          <h1 class="page-title"><i class="bi bi-gear-fill"></i> Settings</h1>
          <p class="page-subtitle">Manage your preferences, notifications, and account</p>
        </div>
      </div>

      <!-- SETTINGS LAYOUT -->
      <div style="display:grid;grid-template-columns:220px 1fr;gap:var(--sp-6);align-items:start;">

        <!-- LEFT NAV -->
        <div class="card" style="position:sticky;top:var(--sp-6);">
          <div class="card-body" style="padding:var(--sp-3);">
            <nav class="settings-nav">
              <button class="settings-nav-item active" onclick="showSection('appearance', this)">
                <i class="bi bi-palette"></i> Appearance
              </button>
              <button class="settings-nav-item" onclick="showSection('danger', this)">
                <i class="bi bi-exclamation-triangle" style="color:var(--danger-500);"></i>
                <span style="color:var(--danger-500);">Danger Zone</span>
              </button>
            </nav>
          </div>
        </div>

        <!-- RIGHT CONTENT -->
        <div>

          <!-- ========================
               1. APPEARANCE
          ======================== -->
          <div class="settings-section active" id="section-appearance">
            <div class="card">
              <div class="card-header">
                <div class="card-title"><i class="bi bi-palette" style="color:var(--brand-500);"></i> Appearance</div>
              </div>
              <div class="card-body" style="padding:var(--sp-6);">

                <!-- Theme -->
                <div class="setting-row" style="flex-direction:column;align-items:flex-start;gap:var(--sp-4);">
                  <div class="setting-row-info">
                    <div class="setting-row-label">Theme</div>
                    <div class="setting-row-desc">Choose how MoneyTrail looks on your device</div>
                  </div>
                  <div class="theme-tiles">

                    <!-- Light -->
<label class="theme-tile ${not empty theme and theme == 'light' ? 'selected' : ''}" id="tile-light"
       onclick="applyTheme('light')">
  <input type="radio" name="themeChoice" value="light" style="display:none;"
         ${not empty theme and theme == 'light' ? 'checked' : ''}>
  <div class="theme-tile-preview" style="background:#f8f9fa;">
    <div class="theme-tile-bar" style="background:#dee2e6;width:100%;"></div>
    <div class="theme-tile-bar" style="background:#adb5bd;width:70%;"></div>
    <div class="theme-tile-bar" style="background:#ced4da;width:50%;"></div>
  </div>
  <div class="theme-tile-label">Light</div>
</label>

<!-- Dark -->
<label class="theme-tile ${empty theme or theme == 'dark' ? 'selected' : ''}" id="tile-dark"
       onclick="applyTheme('dark')">
  <input type="radio" name="themeChoice" value="dark" style="display:none;"
         ${empty theme or theme == 'dark' ? 'checked' : ''}>
  <div class="theme-tile-preview" style="background:#1a1d23;">
    <div class="theme-tile-bar" style="background:#2d3139;width:100%;"></div>
    <div class="theme-tile-bar" style="background:#3d4149;width:70%;"></div>
    <div class="theme-tile-bar" style="background:#2d3139;width:50%;"></div>
  </div>
  <div class="theme-tile-label">Dark</div>
</label>

<!-- System -->
<label class="theme-tile ${not empty theme and theme == 'system' ? 'selected' : ''}" id="tile-system"
       onclick="applyTheme('system')">
  <input type="radio" name="themeChoice" value="system" style="display:none;"
         ${not empty theme and theme == 'system' ? 'checked' : ''}>
  <div class="theme-tile-preview" style="background:linear-gradient(135deg,#f8f9fa 50%,#1a1d23 50%);">
    <div class="theme-tile-bar" style="background:rgba(100,100,100,0.3);width:100%;"></div>
    <div class="theme-tile-bar" style="background:rgba(100,100,100,0.2);width:70%;"></div>
    <div class="theme-tile-bar" style="background:rgba(100,100,100,0.3);width:50%;"></div>
  </div>
  <div class="theme-tile-label">System</div>
</label>

                  </div>
                </div>
              </div>
            </div>
          </div>

		<!-- ========================
               2. DANGER ZONE
          ======================== -->
          <div class="settings-section" id="section-danger">
            <div class="card" style="border:1px solid var(--danger-200, #fca5a5);">
              <div class="card-header" style="border-bottom:1px solid var(--danger-200, #fca5a5);">
                <div class="card-title" style="color:var(--danger-600);">
                  <i class="bi bi-exclamation-triangle-fill"></i> Danger Zone
                </div>
              </div>
              <div class="card-body" style="padding:var(--sp-6);">

                <p style="font-size:var(--text-sm);color:var(--text-muted);margin-bottom:var(--sp-5);">
                  Actions in this section are <strong style="color:var(--danger-500);">irreversible</strong>. Please proceed with caution.
                </p>

                <!-- Deactivate Account -->
                <div class="danger-action">
                  <div class="danger-action-info">
                    <div class="danger-action-label"><i class="bi bi-person-dash me-2"></i>Deactivate Account</div>
                    <div class="danger-action-desc">Temporarily disable your account. You can reactivate it by logging back in.</div>
                  </div>
                  <button type="button" class="btn btn-sm"
                          style="background:transparent;border:1px solid var(--danger-500);color:var(--danger-500);flex-shrink:0;"
                          onclick="confirmAction('deactivate')">
                    Deactivate
                  </button>
                </div>

                <!-- Clear All Transactions -->
                <div class="danger-action">
                  <div class="danger-action-info">
                    <div class="danger-action-label"><i class="bi bi-trash3 me-2"></i>Clear All Transactions</div>
                    <div class="danger-action-desc">Permanently delete all your transaction history. This cannot be undone.</div>
                  </div>
                  <button type="button" class="btn btn-sm"
                          style="background:transparent;border:1px solid var(--danger-500);color:var(--danger-500);flex-shrink:0;"
                          onclick="confirmAction('clearTransactions')">
                    Clear Data
                  </button>
                </div>

                <!-- Delete Account -->
                <div class="danger-action" style="border-color:var(--danger-500);background:var(--danger-50);">
                  <div class="danger-action-info">
                    <div class="danger-action-label" style="color:var(--danger-700, #b91c1c);"><i class="bi bi-person-x-fill me-2"></i>Delete Account</div>
                    <div class="danger-action-desc">Permanently delete your account and all associated data. This action cannot be reversed.</div>
                  </div>
                  <button type="button" class="btn btn-sm btn-danger" style="flex-shrink:0;"
                          onclick="confirmAction('delete')">
                    Delete Account
                  </button>
                </div>

              </div>
            </div>
          </div>

        </div>
      </div>

    </main>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
  </div>
</div>

<!-- Confirm Modal -->
<div class="modal fade" id="confirmModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header" style="border-bottom:1px solid var(--border-color);">
        <h5 class="modal-title" id="confirmModalTitle" style="color:var(--danger-600);font-size:var(--text-base);font-weight:700;"></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body" style="font-size:var(--text-sm);color:var(--text-muted);" id="confirmModalBody"></div>
      <div class="modal-footer" style="border-top:1px solid var(--border-color);">
        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
        <button type="button" id="confirmModalBtn" class="btn btn-danger btn-sm">Confirm</button>
      </div>
    </div>
  </div>
</div>

<form id="dangerActionForm" method="post" style="display:none;">
  <input type="hidden" name="confirm" id="dangerActionConfirm" value="yes">
</form>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
<script>
  // ── Section switcher ──────────────────────────────────────────
  function showSection(id, el) {
    document.querySelectorAll('.settings-section').forEach(function (s) { s.classList.remove('active'); });
    document.querySelectorAll('.settings-nav-item').forEach(function (n) { n.classList.remove('active'); });
    var section = document.getElementById('section-' + id);
    if (section) section.classList.add('active');
    if (el) el.classList.add('active');
  }

  function applyTheme(theme) {
	  const html = document.documentElement;
	  const sunIcon  = document.querySelector('[data-icon="sun"]');
	  const moonIcon = document.querySelector('[data-icon="moon"]');

	  // Resolve effective theme for 'system'
	  let effectiveDark;
	  if (theme === 'system') {
	    effectiveDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
	  } else {
	    effectiveDark = (theme === 'dark');
	  }

	  // Apply dark class (same as toggle button does)
	  if (effectiveDark) {
	    html.classList.add('dark');
	  } else {
	    html.classList.remove('dark');
	  }

	  // Sync toggle button icons (same logic as the toggle button)
	  if (sunIcon && moonIcon) {
	    sunIcon.style.display  = effectiveDark ? 'inline-block' : 'none';
	    moonIcon.style.display = effectiveDark ? 'none' : 'inline-block';
	  }

	  // Update selected tile highlight
	  document.querySelectorAll('.theme-tile').forEach(t => t.classList.remove('selected'));
	  const activeTile = document.getElementById('tile-' + theme);
	  if (activeTile) {
	    activeTile.classList.add('selected');
	    activeTile.querySelector('input[type="radio"]').checked = true;
	  }

	  // Persist to localStorage (same as toggle button saves state)
	  localStorage.setItem('theme', theme);
	}

	// On page load — restore saved theme and keep toggle button in sync
	(function () {
	  const saved = localStorage.getItem('theme') || '${not empty theme ? theme : "dark"}';
	  applyTheme(saved);

	  // Keep toggle button working the same way — clicking it cycles dark ↔ light
	  const toggleBtn = document.getElementById('themeToggle');
	  if (toggleBtn) {
	    toggleBtn.addEventListener('click', function () {
	      const isDark = document.documentElement.classList.contains('dark');
	      applyTheme(isDark ? 'light' : 'dark');
	    });
	  }

	  // React to system preference changes when 'system' is active
	  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function () {
	    if (localStorage.getItem('theme') === 'system') {
	      applyTheme('system');
	    }
	  });
	})();

  // ── Generic preference saver (localStorage) ───────────────────
  function savePref(key, value) {
    localStorage.setItem('mt_pref_' + key, value);
  }

  // ── Restore saved prefs on load ───────────────────────────────
  (function () {
    var savedTheme = localStorage.getItem('mt_theme') || 'dark';
    applyTheme(savedTheme);
    var themeInput = document.querySelector('input[name="themeChoice"][value="' + savedTheme + '"]');
    if (themeInput) themeInput.checked = true;

    var prefs = ['compactMode','sidebarCollapsed','emailNotif','weeklyReport',
                 'budgetAlert','txnNotif','securityAlert'];
    prefs.forEach(function (p) {
      var saved = localStorage.getItem('mt_pref_' + p);
      if (saved !== null) {
        var el = document.getElementById(p);
        if (el) el.checked = (saved === 'true');
      }
    });
  })();

  // ── Danger zone confirm modal ─────────────────────────────────
  var dangerConfig = {
    deactivate: {
      title: 'Deactivate Account',
      body:  'Your account will be disabled. You can reactivate it by signing back in. Are you sure?',
      href:  '${pageContext.request.contextPath}/profile/deactivate'
    },
    clearTransactions: {
      title: 'Clear All Transactions',
      body:  'This will permanently delete every transaction record in your account. This cannot be undone. Are you absolutely sure?',
      href:  '${pageContext.request.contextPath}/profile/clear-transactions'
    },
    delete: {
      title: 'Delete Account Permanently',
      body:  'Your account, profile, and all data will be permanently removed. This action is irreversible. Type your password to confirm in the next step.',
      href:  '${pageContext.request.contextPath}/profile/delete'
    }
  };

  function confirmAction(type) {
    var cfg = dangerConfig[type];
    if (!cfg) {
      console.error('Unknown danger action type:', type);
      return;
    }
    document.getElementById('confirmModalTitle').textContent = cfg.title;
    document.getElementById('confirmModalBody').textContent  = cfg.body;
    var confirmBtn = document.getElementById('confirmModalBtn');
    confirmBtn.onclick = function () {
      var form = document.getElementById('dangerActionForm');
      form.action = cfg.href;
      form.submit();
    };
    new bootstrap.Modal(document.getElementById('confirmModal')).show();
  }
</script>
<script src="${pageContext.request.contextPath}/js/app.js"></script>
<script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/js/theme-switcher.js"></script>
</body>
</html>
