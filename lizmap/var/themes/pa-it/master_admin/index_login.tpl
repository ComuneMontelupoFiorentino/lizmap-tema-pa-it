{* =====================================================================
   OVERRIDE TEMA pa-it (stile Bootstrap Italia) - layout pagine di accesso
   Usato da: login, password dimenticata, creazione account (jcommunity).
   Basato su: app/themes/default/master_admin/index_login.tpl di Lizmap 3.9.0
   (attenzione: l'originale NON è in modules/, ma in app/themes/default/)
   Modifiche: stesso header e footer della home (view/main.tpl), stile del
   modulo in css/bi-login.css.
   Qui la variabile $title (nome del portale) NON esiste: il nome è scritto
   a mano in due punti, marcati "NOME PORTALE". Se lo cambi nell'amministrazione
   di Lizmap, cambialo anche qui.
   ===================================================================== *}

{* --- CSS: le prime 7 righe sono quelle dell'originale, non toccarle --- *}
{meta_html assets 'bootstrap'}

{meta_html css $j_basepath.'assets/css/main.css'}
{meta_html css $j_basepath.'assets/css/admin.css'}
{meta_html css $j_basepath.'assets/css/media.css'}

{meta_html csstheme 'css/main.css'}
{meta_html csstheme 'css/admin.css'}
{meta_html csstheme 'css/media.css'}
{meta_html csstheme 'css/bi-layout.css'}
{meta_html csstheme 'css/bi-login.css'}

<a class="bi-skiplink" href="#content">Vai ai contenuti</a>
<a class="bi-skiplink" href="#bi-footer">Vai al footer</a>

<div id="bi-page-wrapper" class="bi-login-page">
  <div id="header" class="bi-header">
    {* --- Fascia slim: ente a sinistra, menu a destra (come nella home) --- *}
    <div class="bi-header-slim">
      <div class="bi-container bi-header-slim-inner">
        <a class="bi-ente" href="https://www.comune.montelupo-fiorentino.fi.it/" target="_blank" rel="noopener">Comune di Montelupo Fiorentino</a>

        <div id="headermenu" class="navbar">
          <div id="auth" class="navbar-inner">
            <ul class="nav bi-custom-menu">
              <li><a href="https://rekla.comune.montelupo-fiorentino.fi.it/wp-admin/edit.php?post_type=richiesta_assistenza" target="_blank" rel="noopener"><span>Rekla</span></a></li>
              <li><a href="https://dati.toscana.it/organization/comune-di-montelupo-fiorentino" target="_blank" rel="noopener"><span>Opendata</span></a></li>
            </ul>
            {* Al posto del menu utente (qui l'utente non è collegato):
               solo il ritorno alla pagina principale, come nell'originale *}
            <ul class="nav pull-right">
              <li class="home">
                <a href="{jurl 'view~default:index'}">
                  <span class="icon"></span>
                  <span class="text">{@view~default.home.title@}</span>
                </a>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>

    {* --- Fascia centrale: logo e nome del portale
           (il titolo della pagina, es. "Accedi", è nel riquadro sotto) --- *}
    <div class="bi-header-center">
      <div class="bi-container bi-header-center-inner">
        <a class="bi-brand" href="{jurl 'view~default:index'}">
          <div id="logo"></div>
          <div id="title">
            <p class="bi-site-name">PROSIT - COMUNE DI MONTELUPO FIORENTINO</p>{* NOME PORTALE *}
          </div>
        </a>
      </div>
    </div>
  </div>

  <div id="content" class="container">
    <div class="bi-login-card">
      <h1 class="bi-login-title">{$page_title|eschtml}</h1>
      {$MAIN}
    </div>
  </div>
</div>

{* --- Footer istituzionale (uguale a quello della home) --- *}
<footer id="bi-footer" class="bi-footer">
  <div class="bi-footer-main">
    <div class="bi-container">
      <div class="bi-footer-brand">
        <div class="bi-footer-brand-left">
          <img class="bi-footer-logo-ente" src="{$j_themepath.'css/img/logo.png'}" alt=""/>
          <span class="bi-footer-title">PROSIT - COMUNE DI MONTELUPO FIORENTINO</span>{* NOME PORTALE *}
        </div>
        <div class="bi-footer-brand-right">
          <a class="bi-footer-logo-lizmap" href="https://www.lizmap.com" target="_blank" rel="noopener" title="Realizzato con Lizmap">
            <img src="{$j_themepath.'css/img/logo_footer.png'}" alt="Lizmap"/>
          </a>
        </div>
      </div>
      <div class="bi-footer-cols">
        <div>
          <h4>Contatti</h4>
          <p>
            Comune di Montelupo Fiorentino<br/>
            Viale Cento Fiori, 34 – 50056 Montelupo Fiorentino (FI) <br/>
            Codice fiscale / P. IVA: 00614510485 <br/>
            PEC: <a href="mailto:comune.montelupo-fiorentino@postacert.toscana.it">comune.montelupo-fiorentino@postacert.toscana.it</a>
          </p>
        </div>
        <div>
          <h4>Link utili</h4>
          <ul>
            <li><a href="https://www.comune.montelupo-fiorentino.fi.it/">Sito istituzionale</a></li>
            <li><a href="https://dati.toscana.it/dataset/?organization=comune-di-montelupo-fiorentino">Open data</a></li>
            <li><a href="https://www.comune.montelupo-fiorentino.fi.it/comune-in-chiaro/">Comune in chiaro</a></li>
          </ul>
        </div>
        <div>
          <h4>Servizio</h4>
          <p>Portale cartografico realizzato con Lizmap.</p>
        </div>
      </div>
    </div>
  </div>
  <div class="bi-footer-small">
    <div class="bi-container">
      <ul>
        <li><a href="https://www.comune.montelupo-fiorentino.fi.it/privacy-policy/">Privacy</a></li>
        <li><a href="https://www.comune.montelupo-fiorentino.fi.it/note-legali/">Note legali</a></li>
        <li><a href="https://form.agid.gov.it/">Dichiarazione di accessibilità</a></li>
      </ul>
    </div>
  </div>
</footer>
