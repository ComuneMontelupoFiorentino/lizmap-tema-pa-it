/* =====================================================================
   TEMA pa-it - comportamenti della home
   Caricato da var/themes/pa-it/view/main.tpl con
     {meta_html js $j_themepath.'js/bi-page.js'}
   - popup "Informazioni sul servizio" (pulsante i accanto al titolo)
   - pulsante "torna all'inizio"
   Nessuna dipendenza (non usa jQuery né Bootstrap di Lizmap).
   ===================================================================== */
(function () {
  'use strict';

  /* Elementi "dietro" il popup: mentre è aperto diventano inerti
     (non raggiungibili con Tab né dagli screen reader). */
  var BACKGROUND_SELECTORS = ['#bi-page-wrapper', '#bi-footer', '.bi-skiplink', '#bi-back-to-top'];

  var FOCUSABLE = 'a[href], button:not([disabled]), input:not([disabled]), ' +
    'select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])';

  var setBackgroundInert = function (inert) {
    BACKGROUND_SELECTORS.forEach(function (selector) {
      Array.prototype.forEach.call(document.querySelectorAll(selector), function (el) {
        if (inert) {
          el.setAttribute('inert', '');
          el.setAttribute('aria-hidden', 'true');
        } else {
          el.removeAttribute('inert');
          el.removeAttribute('aria-hidden');
        }
      });
    });
  };

  /* ---------------- Popup informazioni ---------------- */
  var initServiceInfo = function () {
    var trigger = document.getElementById('bi-service-info-trigger');
    var overlay = document.getElementById('bi-service-info');
    if (!trigger || !overlay) return;

    var dialog = overlay.querySelector('.bi-info-dialog');
    var previousFocus = null;

    var focusableInDialog = function () {
      return Array.prototype.filter.call(dialog.querySelectorAll(FOCUSABLE), function (el) {
        return el.offsetParent !== null; // solo elementi visibili
      });
    };

    var openInfo = function () {
      previousFocus = document.activeElement;
      overlay.hidden = false;
      document.body.classList.add('bi-modal-open');
      trigger.setAttribute('aria-expanded', 'true');
      setBackgroundInert(true);
      dialog.scrollTop = 0;
      // il focus va sul titolo: lo screen reader legge subito di cosa si tratta
      var title = dialog.querySelector('#bi-info-title');
      (title || dialog).focus();
    };

    var closeInfo = function () {
      if (overlay.hidden) return;
      overlay.hidden = true;
      document.body.classList.remove('bi-modal-open');
      trigger.setAttribute('aria-expanded', 'false');
      setBackgroundInert(false);
      if (previousFocus && typeof previousFocus.focus === 'function') {
        previousFocus.focus();
      }
    };

    trigger.setAttribute('aria-expanded', 'false');
    trigger.addEventListener('click', openInfo);

    Array.prototype.forEach.call(overlay.querySelectorAll('.bi-info-close'), function (button) {
      button.addEventListener('click', closeInfo);
    });

    // clic sullo sfondo scuro (fuori dal riquadro) = chiudi
    overlay.addEventListener('click', function (event) {
      if (event.target === overlay) closeInfo();
    });

    document.addEventListener('keydown', function (event) {
      if (overlay.hidden) return;

      if (event.key === 'Escape' || event.key === 'Esc') {
        event.preventDefault();
        closeInfo();
        return;
      }

      // Tab resta dentro il popup (anche nei browser senza supporto per inert)
      if (event.key === 'Tab') {
        var items = focusableInDialog();
        if (!items.length) {
          event.preventDefault();
          return;
        }
        var first = items[0];
        var last = items[items.length - 1];
        var active = document.activeElement;
        var outside = !dialog.contains(active);

        if (event.shiftKey && (active === first || outside || active === dialog)) {
          event.preventDefault();
          last.focus();
        } else if (!event.shiftKey && (active === last || outside)) {
          event.preventDefault();
          first.focus();
        }
      }
    });
  };

  /* ---------------- Torna all'inizio ---------------- */
  var initBackToTop = function () {
    var topButton = document.getElementById('bi-back-to-top');
    if (!topButton) return;

    var ticking = false;

    var updateTopButton = function () {
      var position = window.pageYOffset || document.documentElement.scrollTop || 0;
      topButton.classList.toggle('bi-back-to-top-visible', position > 250);
      ticking = false;
    };

    window.addEventListener('scroll', function () {
      if (!ticking) {
        ticking = true;
        window.requestAnimationFrame(updateTopButton);
      }
    }, { passive: true });

    topButton.addEventListener('click', function () {
      var reduce = window.matchMedia &&
        window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      window.scrollTo({ top: 0, behavior: reduce ? 'auto' : 'smooth' });

      // Il pulsante sparisce in cima: spostiamo il focus all'inizio della
      // pagina, così chi usa la tastiera non resta su un elemento nascosto.
      var target = document.getElementById('header');
      if (target) {
        if (!target.hasAttribute('tabindex')) target.setAttribute('tabindex', '-1');
        try {
          target.focus({ preventScroll: true });
        } catch (e) {
          target.focus();
        }
      }
    });

    updateTopButton();
  };

  var init = function () {
    initServiceInfo();
    initBackToTop();
  };

  // lo script è caricato nell'<head>: aspettiamo che la pagina sia pronta
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
