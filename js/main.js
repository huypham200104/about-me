/**
 * PERSONAL PORTFOLIO INTERACTION ENGINE — PHAM NGOC HUY
 * - Theme Controller (Dark/Light mode with persistence & system sync)
 * - Scroll Reveal via IntersectionObserver
 * - Active Navigation Link Highlighter
 * - Mobile Navigation Drawer Toggle
 */

(function () {
  'use strict';

  const STORAGE_KEY = 'pnh_theme';

  /* ------------------------------------------------------------------------
   * 0. Safe Storage Utilities (Exception-proof for Private Browsing / Iframes)
   * ------------------------------------------------------------------------ */
  function safeGetStorage(key) {
    try {
      return localStorage.getItem(key);
    } catch (e) {
      return null;
    }
  }

  function safeSetStorage(key, value) {
    try {
      localStorage.setItem(key, value);
    } catch (e) {
      // Storage blocked or quota exceeded; proceed in-memory gracefully
    }
  }

  /* ------------------------------------------------------------------------
   * 1. Theme Controller
   * ------------------------------------------------------------------------ */
  function getPreferredTheme() {
    const saved = safeGetStorage(STORAGE_KEY);
    if (saved === 'dark' || saved === 'light') {
      return saved;
    }
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      return 'dark';
    }
    return 'light';
  }

  function applyTheme(theme) {
    const root = document.documentElement;
    const toggleBtn = document.getElementById('theme-toggle');
    const isEnglish = (root.getAttribute('lang') || '').toLowerCase().startsWith('en');

    if (theme === 'dark') {
      root.setAttribute('data-theme', 'dark');
      if (toggleBtn) {
        toggleBtn.innerHTML = '☀️';
        const label = isEnglish ? 'Switch to Light Mode' : 'Chuyển sang giao diện sáng (Light Mode)';
        toggleBtn.setAttribute('aria-label', label);
        toggleBtn.setAttribute('title', label);
      }
    } else {
      root.removeAttribute('data-theme');
      if (toggleBtn) {
        toggleBtn.innerHTML = '🌙';
        const label = isEnglish ? 'Switch to Dark Mode' : 'Chuyển sang giao diện tối (Dark Mode)';
        toggleBtn.setAttribute('aria-label', label);
        toggleBtn.setAttribute('title', label);
      }
    }
  }

  function toggleTheme() {
    const current = document.documentElement.getAttribute('data-theme') === 'dark' ? 'dark' : 'light';
    const next = current === 'dark' ? 'light' : 'dark';
    safeSetStorage(STORAGE_KEY, next);
    applyTheme(next);
  }

  function initTheme() {
    // Apply immediate preferred theme
    const theme = getPreferredTheme();
    applyTheme(theme);

    const toggleBtn = document.getElementById('theme-toggle');
    if (toggleBtn) {
      toggleBtn.addEventListener('click', toggleTheme);
    }

    // Listen for OS scheme changes if user hasn't set manual preference
    if (window.matchMedia) {
      window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function (e) {
        if (!safeGetStorage(STORAGE_KEY)) {
          applyTheme(e.matches ? 'dark' : 'light');
        }
      });
    }
  }

  /* ------------------------------------------------------------------------
   * 2. Scroll Reveal (IntersectionObserver)
   * ------------------------------------------------------------------------ */
  function initScrollReveal() {
    const revealElements = document.querySelectorAll('.reveal');
    if (!revealElements.length) return;

    if ('IntersectionObserver' in window) {
      const observer = new IntersectionObserver(
        function (entries, obs) {
          entries.forEach(function (entry) {
            if (entry.isIntersecting) {
              entry.target.classList.add('is-visible');
              obs.unobserve(entry.target);
            }
          });
        },
        {
          threshold: 0.12,
          rootMargin: '0px 0px -30px 0px'
        }
      );

      revealElements.forEach(function (el) {
        observer.observe(el);
      });
    } else {
      // Fallback for older browsers: show elements immediately
      revealElements.forEach(function (el) {
        el.classList.add('is-visible');
      });
    }
  }

  /* ------------------------------------------------------------------------
   * 3. Mobile Navigation Menu
   * ------------------------------------------------------------------------ */
  function initMobileNav() {
    const navToggle = document.getElementById('nav-toggle');
    const navLinks = document.getElementById('nav-links');

    if (!navToggle || !navLinks) return;

    navToggle.addEventListener('click', function (e) {
      e.stopPropagation();
      const isOpen = navLinks.classList.toggle('is-open');
      navToggle.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
      navToggle.innerHTML = isOpen ? '✕' : '☰';
    });

    // Close menu when clicking outside
    document.addEventListener('click', function (e) {
      if (!navLinks.contains(e.target) && e.target !== navToggle) {
        if (navLinks.classList.contains('is-open')) {
          navLinks.classList.remove('is-open');
          navToggle.setAttribute('aria-expanded', 'false');
          navToggle.innerHTML = '☰';
        }
      }
    });

    // Close menu with Escape key (Keyboard accessibility)
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && navLinks.classList.contains('is-open')) {
        navLinks.classList.remove('is-open');
        navToggle.setAttribute('aria-expanded', 'false');
        navToggle.innerHTML = '☰';
        navToggle.focus();
      }
    });

    // Close menu when a link is clicked
    navLinks.querySelectorAll('a').forEach(function (link) {
      link.addEventListener('click', function () {
        if (navLinks.classList.contains('is-open')) {
          navLinks.classList.remove('is-open');
          navToggle.setAttribute('aria-expanded', 'false');
          navToggle.innerHTML = '☰';
        }
      });
    });
  }

  /* ------------------------------------------------------------------------
   * 4. Active Navigation State Detection
   * ------------------------------------------------------------------------ */
  function initActiveNav() {
    const currentPath = window.location.pathname.split('/').pop() || 'index.html';
    const navLinks = document.querySelectorAll('.nav-link');

    navLinks.forEach(function (link) {
      const href = link.getAttribute('href');
      if (!href) return;
      const targetPage = href.split('/').pop() || 'index.html';

      // Match exact page or default index
      const isIndexMatch = (currentPath === '' || currentPath === 'index.html') && (targetPage === 'index.html' || targetPage === './');
      if (currentPath === targetPage || isIndexMatch) {
        link.classList.add('active');
        link.setAttribute('aria-current', 'page');
      } else {
        link.classList.remove('active');
        link.removeAttribute('aria-current');
      }
    });
  }

  /* ------------------------------------------------------------------------
   * 5. Bootstrap on DOM Ready
   * ------------------------------------------------------------------------ */
  function onReady() {
    initTheme();
    initScrollReveal();
    initMobileNav();
    initActiveNav();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', onReady);
  } else {
    onReady();
  }
})();
