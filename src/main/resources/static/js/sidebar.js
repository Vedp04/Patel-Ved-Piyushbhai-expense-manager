/* ============================================================
   MONEYTRAIL — SIDEBAR.JS
   Sidebar behaviour (already integrated in app.js, this is the
   standalone version for inclusion order compatibility)
   ============================================================ */

(function () {
  'use strict';

  const sidebar  = document.getElementById('sidebar');
  const backdrop = document.getElementById('sidebarBackdrop');
  const toggleBtn = document.getElementById('sidebarToggle');

  if (!sidebar) return;

  let mobileMenuOpen = false;

  function isMobile() { return window.innerWidth <= 1024; }

  function open() {
    sidebar.classList.add('open');
    mobileMenuOpen = true;
    if (backdrop) backdrop.classList.add('active');
    document.body.style.overflow = 'hidden';
  }

  function close() {
    sidebar.classList.remove('open');
    mobileMenuOpen = false;
    if (backdrop) backdrop.classList.remove('active');
    document.body.style.overflow = '';
  }

  function collapseDesktop() {
    const now = document.body.classList.toggle('sidebar-collapsed');
    try { localStorage.setItem('mt_sidebar_collapsed', now ? '1' : '0'); } catch(e){}
  }

  function normalizePath(pathname) {
    if (!pathname) return '/';
    let p = pathname;
    if (p !== '/' && p.endsWith('/')) p = p.slice(0, -1);
    return p || '/';
  }

  // Restore on load
  try {
    if (!isMobile() && localStorage.getItem('mt_sidebar_collapsed') === '1') {
      document.body.classList.add('sidebar-collapsed');
    }
  } catch(e){}

  if (toggleBtn) {
    toggleBtn.addEventListener('click', function (e) {
      e.stopPropagation();
      isMobile() ? (sidebar.classList.contains('open') ? close() : open()) : collapseDesktop();
    });
  }

  if (backdrop) backdrop.addEventListener('click', close);

  // Keyboard: Escape closes
  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape' && sidebar.classList.contains('open')) close();
  });

  window.addEventListener('resize', function () {
    if (!isMobile() && mobileMenuOpen) close();
  });

  // Mark active nav link (robust to absolute URLs, query/hash, and trailing slashes)
  const currentPath = normalizePath(window.location.pathname);
  sidebar.querySelectorAll('.nav-item').forEach(function (a) {
    const href = a.getAttribute('href');
    if (!href || href === '#') return;

    let linkPath = '';
    try {
      linkPath = normalizePath(new URL(href, window.location.origin).pathname);
    } catch (e) {
      linkPath = normalizePath((href || '').split('?')[0].split('#')[0]);
    }

    if (!linkPath) return;
    if (currentPath === linkPath || (linkPath !== '/' && currentPath.startsWith(linkPath + '/'))) {
      a.classList.add('active');
    }
  });

})();