/**
 * PERSONAL PORTFOLIO INTERACTION ENGINE — PHAM NGOC HUY
 * - Theme Controller (Dark/Light mode with persistence & system sync)
 * - Scroll Reveal via IntersectionObserver
 * - Active Navigation Link Highlighter
 * - Mobile Navigation Drawer Toggle
 * - Configuration Link Binder (Reads window.SITE_CONFIG from config.js)
 * - CV Language Tab Controller (Tiếng Việt <-> English with sync to Drive links)
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
    const theme = getPreferredTheme();
    applyTheme(theme);

    const toggleBtn = document.getElementById('theme-toggle');
    if (toggleBtn) {
      toggleBtn.addEventListener('click', toggleTheme);
    }

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

    function checkVisible(el) {
      const rect = el.getBoundingClientRect();
      const windowHeight = window.innerHeight || document.documentElement.clientHeight;
      if (rect.top <= windowHeight + 100 && rect.bottom >= -50) {
        el.classList.add('is-visible');
        return true;
      }
      return false;
    }

    // Immediately reveal elements that are already within or near the viewport
    revealElements.forEach(function (el) {
      checkVisible(el);
    });

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
          threshold: 0.01,
          rootMargin: '80px 0px 80px 0px'
        }
      );

      revealElements.forEach(function (el) {
        if (!el.classList.contains('is-visible')) {
          observer.observe(el);
        }
      });
    } else {
      revealElements.forEach(function (el) {
        el.classList.add('is-visible');
      });
    }

    // Safety listener: Reveal elements on scroll or anchor navigation
    window.addEventListener('scroll', function () {
      revealElements.forEach(function (el) {
        if (!el.classList.contains('is-visible')) {
          checkVisible(el);
        }
      });
    }, { passive: true });

    window.addEventListener('hashchange', function () {
      setTimeout(function () {
        revealElements.forEach(function (el) {
          checkVisible(el);
        });
      }, 100);
    });
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

    // Close menu with Escape key
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && navLinks.classList.contains('is-open')) {
        navLinks.classList.remove('is-open');
        navToggle.setAttribute('aria-expanded', 'false');
        navToggle.innerHTML = '☰';
        navToggle.focus();
      }
    });

    // Close menu when clicking any link
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
      const targetPage = href.split('/').pop().split('#')[0] || 'index.html';

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
   * 5. Configuration Link Binder (Site Config from config.js)
   * ------------------------------------------------------------------------ */
  function isValidCvUrl(url) {
    if (!url || typeof url !== 'string') return false;
    const trimmed = url.trim();
    return trimmed !== '' && trimmed !== 'https://drive.google.com/' && trimmed !== 'https://drive.google.com';
  }

  function updateCvDriveButton(lang) {
    const config = window.SITE_CONFIG || {};
    const driveCvBtn = document.getElementById('drive-cv-btn');
    if (!driveCvBtn) return;

    const url = lang === 'en'
      ? (config.driveCvEnUrl || config.driveCvUrl || '')
      : (config.driveCvViUrl || config.driveCvUrl || '');

    if (isValidCvUrl(url)) {
      driveCvBtn.style.display = '';
      driveCvBtn.setAttribute('href', url.trim());
      if (lang === 'en') {
        driveCvBtn.innerHTML = '📄 View English CV (Drive)';
        driveCvBtn.setAttribute('title', 'Open English CV on Google Drive');
      } else {
        driveCvBtn.innerHTML = '📄 Xem CV Tiếng Việt (Drive)';
        driveCvBtn.setAttribute('title', 'Mở file CV Tiếng Việt trên Google Drive');
      }
    } else {
      driveCvBtn.style.display = 'none';
      driveCvBtn.setAttribute('href', '#');
    }
  }

  function initConfigLinks() {
    const config = window.SITE_CONFIG || {};

    // Elements requesting specific config URLs via data-config attribute
    const configElements = document.querySelectorAll('[data-config]');
    configElements.forEach(function (el) {
      const key = el.getAttribute('data-config');
      if (key && config[key] && config[key].trim() !== '') {
        el.setAttribute('href', config[key]);
      }
    });

    // Handle Vietnamese CV buttons
    const viButtons = document.querySelectorAll('.btn-drive-cv-vi');
    const viUrl = config.driveCvViUrl || config.driveCvUrl || '';
    const hasViUrl = isValidCvUrl(viUrl);
    viButtons.forEach(function (btn) {
      if (hasViUrl) {
        btn.setAttribute('href', viUrl.trim());
        btn.style.display = 'inline-flex';
      } else {
        btn.style.display = 'none';
      }
    });

    // Handle English CV buttons
    const enButtons = document.querySelectorAll('.btn-drive-cv-en');
    const enUrl = config.driveCvEnUrl || config.driveCvUrl || '';
    const hasEnUrl = isValidCvUrl(enUrl);
    enButtons.forEach(function (btn) {
      if (hasEnUrl) {
        btn.setAttribute('href', enUrl.trim());
        btn.style.display = 'inline-flex';
      } else {
        btn.style.display = 'none';
      }
    });

    // Dynamic CV empty notice in CV Section
    const cvNotice = document.getElementById('cv-empty-notice');
    if (cvNotice) {
      if (!hasViUrl && !hasEnUrl) {
        cvNotice.style.display = 'inline-flex';
      } else {
        cvNotice.style.display = 'none';
      }
    }

    // Initialize the dynamic Drive CV button on current active tab (default Vietnamese)
    updateCvDriveButton('vi');

    // General fallback for any remaining .btn-drive-cv
    const genericDriveButtons = document.querySelectorAll('.btn-drive-cv');
    genericDriveButtons.forEach(function (btn) {
      btn.addEventListener('click', function (e) {
        const href = btn.getAttribute('href');
        if (!href || href === '#' || href === '') {
          e.preventDefault();
          alert('Vui lòng gắn đường link Google Drive CV của bạn vào file config.js.');
        }
      });
    });

    // Handle Google Play Store download buttons
    const playStoreButtons = document.querySelectorAll('.btn-playstore');
    playStoreButtons.forEach(function (btn) {
      if (config.playStoreUrl && config.playStoreUrl.trim() !== '') {
        btn.setAttribute('href', config.playStoreUrl);
      }
    });
  }

  /* ------------------------------------------------------------------------
   * 6. CV Language Tabs Controller (Tiếng Việt <-> English)
   * ------------------------------------------------------------------------ */
  function initCvTabs() {
    const tabButtons = document.querySelectorAll('.cv-tab-btn');
    const tabPanels = document.querySelectorAll('.cv-tab-panel');

    if (!tabButtons.length || !tabPanels.length) return;

    tabButtons.forEach(function (btn) {
      btn.addEventListener('click', function () {
        const targetLang = btn.getAttribute('data-tab'); // 'vi' or 'en'
        if (!targetLang) return;

        // Update button states
        tabButtons.forEach(function (b) {
          const isActive = b === btn;
          b.classList.toggle('active', isActive);
          b.setAttribute('aria-selected', isActive ? 'true' : 'false');
        });

        // Update panel visibility
        tabPanels.forEach(function (panel) {
          const isMatch = panel.getAttribute('data-lang') === targetLang;
          panel.classList.toggle('active', isMatch);
          if (isMatch) {
            panel.removeAttribute('hidden');
          } else {
            panel.setAttribute('hidden', '');
          }
        });

        // Sync Google Drive button to active language
        updateCvDriveButton(targetLang);
      });
    });
  }

  /* ------------------------------------------------------------------------
   * 7. Bootstrap on DOM Ready
   * ------------------------------------------------------------------------ */
  function onReady() {
    initTheme();
    initScrollReveal();
    initMobileNav();
    initActiveNav();
    initConfigLinks();
    initCvTabs();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', onReady);
  } else {
    onReady();
  }
})();
