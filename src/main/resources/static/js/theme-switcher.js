// ── Theme Tiles ──────────────────────────────────────────────
function applyTheme(theme) {
  let effective = theme;
  if (theme === 'system') {
    effective = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  }

  document.documentElement.dataset.theme = effective;
  localStorage.setItem('theme', theme);

  document.querySelectorAll('.theme-tile').forEach(t => t.classList.remove('selected'));
  const activeTile = document.getElementById('tile-' + theme);
  if (activeTile) {
    activeTile.classList.add('selected');
    activeTile.querySelector('input[type="radio"]').checked = true;
  }
}
// ─────────────────────────────────────────────────────────────

document.addEventListener('DOMContentLoaded', () => {
  // ... your existing code
});

document.addEventListener('DOMContentLoaded', () => {
  const btns = document.querySelectorAll('[data-theme-toggle]');

  function setTheme(theme) {
    document.documentElement.dataset.theme = theme;
    localStorage.setItem('theme', theme);
  }

  function toggleTheme() {
    const current = document.documentElement.dataset.theme || 'light';
    const next = current === 'light' ? 'dark' : 'light';
    setTheme(next);

    // ✅ PATCH 1 — sync tile when toggle button clicked
    document.querySelectorAll('.theme-tile').forEach(t => t.classList.remove('selected'));
    const activeTile = document.getElementById('tile-' + next);
    if (activeTile) {
      activeTile.classList.add('selected');
      activeTile.querySelector('input[type="radio"]').checked = true;
    }
  }

  function syncIcons(theme) {
    btns.forEach(btn => {
      const sunIcon  = btn.querySelector('[data-icon="sun"]');
      const moonIcon = btn.querySelector('[data-icon="moon"]');
      if (sunIcon)  sunIcon.style.display  = theme === 'dark'  ? '' : 'none';
      if (moonIcon) moonIcon.style.display = theme === 'light' ? '' : 'none';
    });
  }

  btns.forEach(btn => btn.addEventListener('click', toggleTheme));

  const observer = new MutationObserver(() => {
    syncIcons(document.documentElement.dataset.theme || 'light');
  });
  observer.observe(document.documentElement, {
    attributes: true,
    attributeFilter: ['data-theme']
  });

  // ✅ PATCH 2 — replace the old single line: setTheme(saved) / syncIcons(saved)
  const saved = localStorage.getItem('theme') || 'light';
  if (saved === 'system') {
    applyTheme('system');
  } else {
    setTheme(saved);
    syncIcons(saved);
  }

  // ✅ PATCH 3 — add at the very end, before closing });
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
    if (localStorage.getItem('theme') === 'system') {
      applyTheme('system');
    }
  });

}); // ← closing of DOMContentLoaded