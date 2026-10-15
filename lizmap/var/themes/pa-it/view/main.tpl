{* =====================================================================
   OVERRIDE TEMA pa-it (stile Bootstrap Italia) - home di Lizmap
   Basato su: modules/view/templates/main.tpl di Lizmap 3.9.0
   Originale di riferimento: originali/<versione>/modules/view/templates/main.tpl
   nel repository lizmap-tema-pa-it
   Modifiche: header a due fasce, skip link, footer istituzionale.
   Testi da personalizzare: cerca "DA PERSONALIZZARE".
   ===================================================================== *}
{meta_html csstheme 'css/main.css'}
{meta_html csstheme 'css/media.css'}
{meta_html csstheme 'css/bi-layout.css'}

<a class="bi-skiplink" href="#content">Vai ai contenuti</a>
<a class="bi-skiplink" href="#bi-footer">Vai al footer</a>

<div id="header" class="bi-header">
  {* --- Fascia slim: ente di appartenenza (DA PERSONALIZZARE) --- *}
  <div class="bi-header-slim">
    <div class="bi-container bi-header-slim-inner">
      <a class="bi-ente" href="https://www.esempio.it" target="_blank" rel="noopener">Nome Ente di appartenenza</a>
    </div>
  </div>

  {* --- Fascia centrale: logo, titolo, menu utente --- *}
  <div class="bi-header-center">
    <div class="bi-container bi-header-center-inner">
      <a class="bi-brand" href="{jurl 'view~default:index'}">
        <div id="logo"></div>
        <div id="title">
          <h1>{$title}</h1>
          <h2>{$subTitle}</h2>
        </div>
      </a>

      <div id="headermenu" class="navbar">
        <div id="auth" class="navbar-inner">
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
</div>

<div id="content" class="container">
  <div id="search">
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

{* --- Footer istituzionale (DA PERSONALIZZARE: testi e link) --- *}
<footer id="bi-footer" class="bi-footer">
  <div class="bi-footer-main">
    <div class="bi-container">
      <div class="bi-footer-brand">
        <img src="{$j_themepath.'css/img/logo_footer.png'}" alt=""/>
        <span>{$title}</span>
      </div>
      <div class="bi-footer-cols">
        <div>
          <h4>Contatti</h4>
          <p>
            Nome Ente<br/>
            Via Esempio 1, 50100 Firenze<br/>
            PEC: <a href="mailto:ente@pec.esempio.it">ente@pec.esempio.it</a>
          </p>
        </div>
        <div>
          <h4>Link utili</h4>
          <ul>
            <li><a href="https://www.esempio.it">Sito istituzionale</a></li>
            <li><a href="https://www.esempio.it/open-data">Open data</a></li>
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
        <li><a href="https://www.esempio.it/privacy">Privacy</a></li>
        <li><a href="https://www.esempio.it/note-legali">Note legali</a></li>
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
