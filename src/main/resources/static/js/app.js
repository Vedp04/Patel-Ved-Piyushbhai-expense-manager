/* ============================================================
   MONEYTRAIL — APP.JS
   Core application logic
   ============================================================ */

(function () {
  'use strict';

  /* ── SIDEBAR TOGGLE ──────────────────────────────────── */
  const sidebar      = document.getElementById('sidebar');
  const sidebarToggle = document.getElementById('sidebarToggle');
  const backdrop     = document.getElementById('sidebarBackdrop');
  const COLLAPSED_KEY = 'mt_sidebar_collapsed';

  function isMobile() { return window.innerWidth <= 1024; }

  function openSidebarMobile() {
    sidebar && sidebar.classList.add('open');
    backdrop && backdrop.classList.add('active');
    document.body.style.overflow = 'hidden';
  }

  function closeSidebarMobile() {
    sidebar && sidebar.classList.remove('open');
    backdrop && backdrop.classList.remove('active');
    document.body.style.overflow = '';
  }

  function toggleDesktopCollapse() {
    const collapsed = document.body.classList.toggle('sidebar-collapsed');
    localStorage.setItem(COLLAPSED_KEY, collapsed ? '1' : '0');
  }

  // Restore collapse state on desktop
  if (!isMobile() && localStorage.getItem(COLLAPSED_KEY) === '1') {
    document.body.classList.add('sidebar-collapsed');
  }

  if (sidebarToggle) {
    sidebarToggle.addEventListener('click', function () {
      if (isMobile()) {
        sidebar && sidebar.classList.contains('open') ? closeSidebarMobile() : openSidebarMobile();
      } else {
        toggleDesktopCollapse();
      }
    });
  }

  backdrop && backdrop.addEventListener('click', closeSidebarMobile);

  window.addEventListener('resize', function () {
    if (!isMobile()) {
      closeSidebarMobile();
      document.body.style.overflow = '';
    }
  });

  /* ── ACTIVE NAV ITEM ─────────────────────────────────── */
  const currentPath = window.location.pathname;
  document.querySelectorAll('.nav-item').forEach(function (item) {
    const href = item.getAttribute('href');
    if (href && currentPath.includes(href.split('?')[0])) {
      item.classList.add('active');
    }
  });

  /* ── DROPDOWN (generic) ──────────────────────────────── */
  document.addEventListener('click', function (e) {
    const btn = e.target.closest('[data-dropdown-toggle]');
    if (btn) {
      e.stopPropagation();
      const targetId = btn.dataset.dropdownToggle;
      const menu = document.getElementById(targetId + '-menu');
      if (menu) {
        const isOpen = menu.classList.contains('show');
        document.querySelectorAll('.dropdown-menu.show').forEach(m => m.classList.remove('show'));
        if (!isOpen) menu.classList.add('show');
        btn.setAttribute('aria-expanded', !isOpen);
      }
    } else {
      document.querySelectorAll('.dropdown-menu.show').forEach(m => m.classList.remove('show'));
    }
  });

  /* ── TABLE FILTER ────────────────────────────────────── */
  window.filterTable = function (query, tableId) {
    const table = document.getElementById(tableId);
    if (!table) return;
    const q = query.toLowerCase().trim();
    table.querySelectorAll('tbody tr').forEach(function (row) {
      row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
    });
  };

  /* ── CONFIRM DELETE ──────────────────────────────────── */
  window.confirmDelete = function (name) {
    return confirm('Are you sure you want to delete "' + name + '"?\n\nThis action cannot be undone.');
  };

  /* ── TOAST ───────────────────────────────────────────── */
  window.showToast = function (message, type) {
    type = type || 'success';
    const container = document.getElementById('toastContainer');
    if (!container) return;
    const colors = {
      success: { bg: 'var(--success-500)', icon: 'bi-check-circle-fill' },
      danger:  { bg: 'var(--danger-500)',  icon: 'bi-exclamation-circle-fill' },
      warning: { bg: 'var(--warning-500)', icon: 'bi-exclamation-triangle-fill' },
      info:    { bg: 'var(--accent-500)',  icon: 'bi-info-circle-fill' }
    };
    const c = colors[type] || colors.success;
    const toast = document.createElement('div');
    toast.className = 'toast';
    toast.innerHTML = '<i class="bi ' + c.icon + '" style="color:' + c.bg + ';font-size:18px;flex-shrink:0;"></i>' +
                      '<span style="flex:1;">' + message + '</span>' +
                      '<button onclick="this.closest(\'.toast\').remove()" style="background:none;border:none;cursor:pointer;color:var(--text-muted);font-size:16px;">×</button>';
    container.appendChild(toast);
    setTimeout(function () {
      toast.style.opacity = '0';
      toast.style.transition = 'opacity 0.4s';
      setTimeout(function () { toast.remove(); }, 400);
    }, 4000);
  };

  /* ── AMOUNT FORMATTING ───────────────────────────────── */
  document.querySelectorAll('input[type="number"][name="amount"]').forEach(function (input) {
    input.addEventListener('blur', function () {
      if (this.value && !isNaN(this.value)) {
        this.value = parseFloat(this.value).toFixed(2);
      }
    });
  });

  /* ── DATE DEFAULT ────────────────────────────────────── */
  document.querySelectorAll('input[type="date"]').forEach(function (input) {
    if (!input.value && !input.dataset.noDefault) {
      input.value = new Date().toISOString().split('T')[0];
    }
  });

})();

document.addEventListener('click', function (e) {
  const btn = e.target.closest('.toggle-user-btn');
  if (!btn) return;

  const userId = btn.dataset.userId;
  const name   = btn.dataset.userName;
  const active = btn.dataset.active === 'true';

  const action = active ? 'Deactivate' : 'Activate';

  if (!confirm(`${action} user ${name}?`)) return;

  // Create form dynamically (POST)
  const form = document.createElement('form');
  form.method = 'POST';
  form.action = `${contextPath}/toggleuser`;

  const input = document.createElement('input');
  input.type = 'hidden';
  input.name = 'userId';
  input.value = userId;

  form.appendChild(input);
  document.body.appendChild(form);
  form.submit();
});

// Add to app.js or inline in each list page
document.querySelectorAll('.btn-icon.del').forEach(btn => {
  btn.addEventListener('click', function(e) {
    if(!confirm('Delete this item? This cannot be undone.')) {
      e.preventDefault();
    }
  });
});