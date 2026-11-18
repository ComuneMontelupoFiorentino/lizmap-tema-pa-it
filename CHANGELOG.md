# Changelog

Modifiche al tema pa-it. Per ogni voce, la versione di Lizmap su cui è stata testata.

## [Non rilasciato]

### Lizmap 3.9.12 — 2026-11-18: allineamento con la versione in esercizio

- **Home, header**: menu personalizzato nella fascia slim (Rekla, Opendata), pulsante (i)
  con popup "Informazioni sul servizio", pulsante "torna su" (`js/bi-page.js`).
- **Home, footer**: sempre in fondo alla pagina anche con poco contenuto; loghi corretti su mobile.
- **Accesso**: login, password dimenticata e creazione account con header e footer della
  home (`var/themes/pa-it/master_admin/index_login.tpl`, `css/bi-login.css`).
- **CSS**: `main.css`, `view.css` e `map.css` salvati completi nel repository;
  `installa.sh` li usa così come sono (prima `main.css` veniva costruito dalle parti).
- **Icone** Bootstrap Italia in `css/svg/`, nuovo logo in `css/img/logo.png`.
- **Script**: resi eseguibili (prima `installa.sh` si fermava al controllo dei template).
- **Licenza**: MPL 2.0.

### Lizmap 3.9.0 — 2026-10-15 (2)

- **Home, header**: menu utente (Amministrazione, login/utente) spostato nella fascia
  slim, a destra del nome dell'ente; la fascia centrale contiene solo logo e titolo.
  Titolo e sottotitolo ora uno sotto l'altro.
- **Home, ricerca**: la ricerca progetti non è più sovrapposta all'header ma sta nel
  contenuto, prima delle card, con etichetta visibile (accessibilità) e campo in stile
  Bootstrap Italia; il pulsante "T" delle parole chiave è a destra del campo.
- **Mobile**: nome dell'ente troncato con i puntini, menu utente solo con le icone.

### Lizmap 3.9.0 — 2026-10-15

- **Font**: Titillium Web servito localmente (`titillium.css` + `fonts/`), niente
  richieste a Google Fonts.
- **Palette**: variabili del tema Lizmap ridefinite con i colori di Bootstrap Italia
  (`#0066CC`, `#004D99`, `#E5F0FA`, testo `#1A1A1A`).
- **Home, header**: fascia slim con l'ente di appartenenza, fascia centrale con logo,
  titolo e sottotitolo cliccabili verso la home, menu utente a destra. L'header non è
  più fisso in alto.
- **Home, footer**: footer istituzionale con contatti, link utili e fascia con
  Privacy, Note legali, Dichiarazione di accessibilità.
- **Accessibilità**: skip link "Vai ai contenuti" e "Vai al footer".
- **Attivazione**: `theme=pa-it` in `localconfig.ini.php`.
- **Script**: `installa.sh`, `controlla-aggiornamento.sh`, `salva-originali.sh`.

Da fare:
- Sostituire i testi segnaposto `DA PERSONALIZZARE` in `main.tpl`.
- Logo dell'ente in `css/img/logo.png` e `logo_footer.png`.
- Card dei progetti della home.
