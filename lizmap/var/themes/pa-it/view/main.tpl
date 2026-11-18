{* =====================================================================
   OVERRIDE TEMA pa-it (stile Bootstrap Italia) - home di Lizmap
   Basato su: modules/view/templates/main.tpl di Lizmap 3.9.0
   Originale di riferimento: originali/<versione>/modules/view/templates/main.tpl
   nel repository lizmap-tema-pa-it
   Modifiche: header a due fasce, skip link, footer istituzionale,
   footer sticky e fix loghi mobile, menu personalizzato nella fascia slim,
   pulsante (i) con popup informazioni, pulsante "torna su".
   JavaScript: www/themes/pa-it/js/bi-page.js (niente JS in questo file).
   ===================================================================== *}
{meta_html csstheme 'css/main.css'}
{meta_html csstheme 'css/media.css'}
{meta_html csstheme 'css/bi-layout.css'}
{meta_html js $j_themepath.'js/bi-page.js'}

<a class="bi-skiplink" href="#content">Vai ai contenuti</a>
<a class="bi-skiplink" href="#bi-footer">Vai al footer</a>

<div id="bi-page-wrapper">
  <div id="header" class="bi-header">
    {* --- Fascia slim: menu personalizzato a sinistra/centro, ente e menu utente a destra --- *}
    <div class="bi-header-slim">
      <div class="bi-container bi-header-slim-inner">
        <a class="bi-ente" href="https://www.comune.montelupo-fiorentino.fi.it/" target="_blank" rel="noopener">Comune di Montelupo Fiorentino</a>

        <div id="headermenu" class="navbar">
          <div id="auth" class="navbar-inner">
            
            {* --- NUOVO MENU ORIZZONTALE PERSONALIZZATO --- *}
            <ul class="nav bi-custom-menu">
              <li><a href="https://rekla.comune.montelupo-fiorentino.fi.it/wp-admin/edit.php?post_type=richiesta_assistenza" target="_blank" rel="noopener"><span>Rekla</span></a></li>
              <li><a href="https://dati.toscana.it/organization/comune-di-montelupo-fiorentino" target="_blank" rel="noopener"><span>Opendata</span></a></li>
            </ul>
            {* -------------------------------------------- *}

            <ul class="nav pull-right">
              {if $showHomeLink}
              <li class="home">
                <a href="{jurl 'view~default:index'}" rel="tooltip" data-original-title="{@view~default.home.title@}" data-placement="bottom">
                  <span class="icon"></span>
                  <span class="text"><b>{@view~default.home.title@}</b></span>
                </a>
              </li>
              {/if}
              {include 'lizmap~user_menu'}
            </ul>
          </div>
        </div>
      </div>
    </div>

    {* --- Fascia centrale: logo e titolo --- *}
    <div class="bi-header-center">
      <div class="bi-container bi-header-center-inner">
        <a class="bi-brand" href="{jurl 'view~default:index'}">
          <div id="logo"></div>
          <div id="title">
            <h1>{$title}</h1>
            <h2>Comune di Montelupo Fiorentino</h2>
          </div>
        </a>

        <button
          id="bi-service-info-trigger"
          class="bi-info-button"
          type="button"
          aria-label="Informazioni sul servizio"
          aria-haspopup="dialog"
          aria-controls="bi-service-info"
          title="Informazioni sul servizio">
          <span aria-hidden="true">i</span>
        </button>
      </div>
    </div>
  </div>

  <div id="content" class="container">
    {* Ricerca progetti *}
    <div id="search">
      <label for="search-project" class="bi-search-label">{@view~default.header.search.input.title@}</label>
      <div class="input-prepend">
        <button id="toggle-search" class="btn" type="button" data-toggle="tooltip"
          title="{@view~default.header.search.toggleKeywordsTitle.title@}">T</button>
        <input id="search-project" class="span2" data-toggle="tooltip" title="{@view~default.header.search.input.title@}"
          placeholder="{@view~map.search.nominatim.placeholder@}" type="text">
      </div>
      <div id="search-project-keywords">
        <span id="search-project-keywords-selected"></span><span id="search-project-result"></span>
      </div>
    </div>
    {jmessage_bootstrap}
    {if $checkServerInformation}
    <div class="alert alert-block alert-error fade in" data-alert="alert">
      <a class="close" data-dismiss="alert" href="#">×</a>
      <p>{@view~default.server.information.error.admin@} <a href="{jurl 'admin~server_information:index'}"></a></p>
    </div>
    {/if}
    {if isset($landing_page_content)}
    <div id="landingPageContent">
      {$landing_page_content}
    </div>
    {/if}
    {$MAIN}
    {if isset($landing_page_content_bottom)}
    <div id="landingPageContentBottom">
      {$landing_page_content_bottom}
    </div>
    {/if}
  </div>
</div>

<div id="bi-service-info" class="bi-info-overlay" hidden>
  <section
    class="bi-info-dialog"
    role="dialog"
    aria-modal="true"
    aria-labelledby="bi-info-title"
    aria-describedby="bi-info-description"
    tabindex="-1">

    <div class="bi-info-header">
      <h2 id="bi-info-title" tabindex="-1">Informazioni sul servizio</h2>
      <button
        type="button"
        class="bi-info-close"
        aria-label="Chiudi le informazioni">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>

    <div class="bi-info-body">
      <p id="bi-info-description">
        PROSIT
        è il sistema informativo territoriale e gestionale interno per attività di manutenzione e gestione del patrimonio
      </p>

      <h3>Sviluppo e riuso</h3>
      <p>
        Lo strumento è stato progettato e sviluppato dal servizio Supporto alla Transizione Digitale del Comune di Montelupo Fiorentino. 
      </p>
      <p>
        L'interfaccia è stata sviluppata nel rispetto dei criteri di accessibilità.
      </p>
      <p>
        Il codice è interamente open source con licenza AGPL-3.0 e pubblicato sul repository GitHub del Comune.
      </p>

      <h3>Dati</h3>
      <p>
        Tutti i dataset utilizzati sono pubblici sotto licenza CC-BY 4.0 e liberamente fruibili, scaricabili e riutilizzabili.
      </p>

      <h3>Come utilizzare il portale</h3>
      <p>
        Seleziona un progetto cartografico per consultare le mappe,
        esplorare i livelli informativi e utilizzare gli strumenti
        di ricerca disponibili.
      </p>

      <h3>Informazioni e contatti</h3>
      <p>Comune di Montelupo Fiorentino - <a href="https://www.comune.montelupo-fiorentino.fi.it/amministrazione/unita_organizzativa/supporto-alla-transizione-digitale-e-sistema-informativo-territoriale/" target="_blank" rel="noopener">Ufficio transizione digitale e sistema informativo territoriale<span class="bi-visually-hidden"> (si apre in una nuova finestra)</span></a></p>
      <p>Per malfunzionamenti e segnalazioni: <a href="mailto:e.gulli@comune.montelupo-fiorentino.fi.it">Ufficio transizione digitale e sistema informativo territoriale</a></p>
    </div>

    <div class="bi-info-footer">
      <button type="button" class="bi-info-close bi-info-close-action">
        Chiudi
      </button>
    </div>
  </section>
</div>

{* --- Footer istituzionale sticky con loghi responsive --- *}
<footer id="bi-footer" class="bi-footer">
  <div class="bi-footer-main">
    <div class="bi-container">
      <div class="bi-footer-brand">
        <div class="bi-footer-brand-left">
          <img class="bi-footer-logo-ente" src="{$j_themepath.'css/img/logo.png'}" alt=""/>
          <span class="bi-footer-title">{$title}</span>
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

{if $googleTag && $googleTag != ''}
<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id={$googleTag}"></script>
<script>
  {literal}
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  {/literal}
  gtag('config', '{$googleTag}');
</script>
{/if}

<button
  id="bi-back-to-top"
  class="bi-back-to-top"
  type="button"
  aria-label="Torna all'inizio della pagina"
  title="Torna all'inizio">
  <span aria-hidden="true">&#8593;</span>
</button>