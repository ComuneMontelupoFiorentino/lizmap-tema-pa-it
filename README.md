# Tema pa-it per Lizmap

Tema per [Lizmap Web Client](https://github.com/3liz/lizmap-web-client) che avvicina
l'aspetto del portale cartografico allo stile di
[Bootstrap Italia](https://italia.github.io/bootstrap-italia/), il kit di design per i
siti della Pubblica Amministrazione.

Testato su **Lizmap 3.9.0**.

Il repository contiene **solo le nostre personalizzazioni**: non è un fork di Lizmap.
Nessun file standard di Lizmap viene modificato; il tema si aggiunge accanto a quello
standard e si può togliere in qualsiasi momento.

## Cosa cambia

| Dove | Cosa |
|---|---|
| Tutte le pagine (home e mappe) | Font Titillium Web servito dal nostro server, palette blu `#0066CC` |
| Home | Header a due fasce (ente di appartenenza + logo e titolo), footer istituzionale, skip link per l'accessibilità |
| Mappe | Solo font e colori: la struttura resta quella standard |

## Struttura

```
lizmap/                              copiato sull'installazione da scripts/installa.sh
├── www/themes/pa-it/css/
│   ├── titillium.css                @font-face del font locale
│   ├── fonts/                       Titillium Web (woff2/woff, licenza OFL)
│   └── bi-layout.css                layout di header e footer della home
└── var/themes/pa-it/view/
    └── main.tpl                     template della home (override)

parti/
├── main-prepend.css                 messo IN CIMA a main.css (import del font)
└── main-append.css                  messo IN FONDO a main.css (palette e font)

originali/<versione>/                copie dei file standard su cui ci basiamo,
                                     per accorgerci quando 3Liz li cambia

config/localconfig.snippet.ini       la riga che attiva il tema

scripts/
├── installa.sh                      installa il tema in un'installazione Lizmap
├── controlla-aggiornamento.sh       confronta gli originali con una nuova versione
└── salva-originali.sh               registra gli originali di una nuova versione
```

## Come funziona

Lizmap (framework Jelix) cerca file e template prima nel **tema attivo** e poi, per i
template, nell'originale:

- **CSS e immagini**: `www/themes/<tema>/css/`. Ogni pagina carica prima il CSS
  dell'applicazione (`www/assets/css`), poi quello del tema, che quindi vince.
  Per il CSS **non c'è ripiego** sul tema `default`: il tema deve contenere tutti
  i file. Per questo `installa.sh` parte sempre da una copia di `www/themes/default`
  della versione installata.
- **Template**: `var/themes/<tema>/<modulo>/<file>.tpl` sostituisce
  `modules/<modulo>/templates/<file>.tpl`. Qui il ripiego c'è: si sovrascrive solo
  ciò che serve.
- **Tema attivo**: `theme=pa-it` in `var/config/localconfig.ini.php`, fuori da ogni
  sezione. Senza quella riga, il tema si prova aggiungendo `?theme=pa-it` all'URL.

`main.css` del tema non è salvato nel repository: viene **costruito** a ogni
installazione come `parti/main-prepend.css` + `main.css` standard della versione
installata + `parti/main-append.css`. Così le correzioni di 3Liz al tema standard
arrivano da sole e le nostre regole, essendo in fondo, restano prioritarie.

## Installare

Sul server, con i permessi di scrittura sulla cartella di Lizmap (non serve root):

```bash
git clone <url-di-questo-repository> /var/www/lizmap-custom/lizmap-tema-pa-it
cd /var/www/lizmap-custom/lizmap-tema-pa-it
scripts/installa.sh /var/www/lizmap-web-client-3.9.0/lizmap
```

Lo script:

1. controlla che i template standard siano quelli su cui abbiamo lavorato
   (altrimenti si ferma);
2. salva il tema già installato in `lizmap/var/backup-tema-pa-it/<data-ora>/`;
3. installa CSS, font e template;
4. imposta `theme=pa-it` (con backup di `localconfig.ini.php`).

Per installare senza attivarlo, e provarlo con `?theme=pa-it`:

```bash
scripts/installa.sh /var/www/lizmap-web-client-3.9.0/lizmap --non-attivare
```

Se dopo l'installazione non vedi le modifiche: Ctrl+F5 nel browser, poi eventualmente
svuotare la cache di Lizmap (`lizmap/install/clean_vartmp.sh`, richiede root).

## Modificare il tema

**Regola d'oro: si modifica nel repository, poi si installa.** Mai il contrario: una
modifica fatta a mano sul server viene sovrascritta alla prossima installazione.

1. Modifica i file nel repository.
2. `scripts/installa.sh /percorso/lizmap` e verifica nel browser.
3. Commit con un messaggio che dica **cosa** e **perché**:
   ```bash
   git add -A
   git commit -m "Home: logo dell'ente nell'header" -m "Sostituito il logo standard con quello fornito dall'ufficio comunicazione."
   git push
   ```

### Dove mettere cosa

| Voglio cambiare | File |
|---|---|
| Colori, font, bottoni (ovunque) | `parti/main-append.css` |
| Header e footer della home (aspetto) | `lizmap/www/themes/pa-it/css/bi-layout.css` |
| Header e footer della home (HTML, testi, link) | `lizmap/var/themes/pa-it/view/main.tpl` |
| Logo | `lizmap/www/themes/pa-it/css/img/logo.png` (e `logo_footer.png`) |
| Un altro template | vedi sotto |

I testi da adattare all'ente sono segnati `DA PERSONALIZZARE` in `main.tpl`.

### Sovrascrivere un nuovo template

1. Trova il template sul server:
   `grep -rl 'testo-o-classe' /percorso/lizmap/modules/*/templates/`
2. Copialo nel repository: `modules/<modulo>/templates/<file>.tpl` →
   `lizmap/var/themes/pa-it/<modulo>/<file>.tpl`
3. Salva anche l'originale: `originali/<versione>/modules/<modulo>/templates/<file>.tpl`
4. Aggiungi in cima al template un commento Jelix `{* ... *}` che spieghi cosa cambi.

Regole per non rompere i template:

- Tutto ciò che è tra `{ }` è codice Jelix (`{$variabile}`, `{@modulo~chiave@}`,
  `{jurl ...}`, `{if}...{/if}`, `{include ...}`): va lasciato intatto.
- Niente CSS o JavaScript scritti nel template: le graffe verrebbero lette come
  codice. Metterli in un file nel tema e caricarlo con `{meta_html csstheme 'css/file.css'}`.
- Non togliere id e classi usati dal JavaScript di Lizmap. Controllo:
  `grep -rl 'nome-id' /percorso/lizmap/www/assets/js/`
- **Non sovrascrivere i template della mappa** (`map*.tpl`).

## Aggiornare Lizmap

Ogni versione di Lizmap si installa in una cartella nuova. Procedura:

```bash
cd /var/www/lizmap-custom/lizmap-tema-pa-it
git pull
scripts/controlla-aggiornamento.sh /var/www/lizmap-web-client-X.Y.Z/lizmap
```

**Se dice "nessun template di riferimento è cambiato"**: installa e basta.

```bash
scripts/installa.sh /var/www/lizmap-web-client-X.Y.Z/lizmap
```

**Se segnala template cambiati**: mostra le differenze (`<` = vecchio originale,
`>` = nuova versione). Allora:

1. Riporta le modifiche di 3Liz nel nostro override in `lizmap/var/themes/pa-it/`
   (di solito un nuovo `{if}` o una variabile in più).
2. Registra i nuovi originali:
   `scripts/salva-originali.sh /var/www/lizmap-web-client-X.Y.Z/lizmap X.Y.Z`
3. Installa, verifica, e fai un commit che spieghi l'adattamento:
   `git commit -am "Adattamento a Lizmap X.Y.Z: ..."`

Ricordarsi anche di:

- controllare che `theme=pa-it` sia nella configurazione della nuova installazione
  (`installa.sh` la aggiunge se manca);
- aggiornare in cima a questo README la versione testata.

### Lizmap 3.10 e Bootstrap 5

Fino alla 3.9 Lizmap usa Bootstrap 2; la 3.10 passa a Bootstrap 5. Template e CSS
cambieranno molto: conviene ripartire dal nuovo `main.tpl` standard e riapplicare a
mano i tre blocchi (skip link, header, footer). `bi-layout.css` e le variabili si
riusano quasi tutti, e su Bootstrap 5 ci si può avvicinare molto di più a
Bootstrap Italia.

## Tornare indietro

- **Disattivare il tema**: in `var/config/localconfig.ini.php` rimettere
  `theme=default` (o ripristinare il `.bak-<data>` creato da `installa.sh`).
- **Tornare all'installazione precedente del tema**: copiare indietro le cartelle
  da `lizmap/var/backup-tema-pa-it/<data-ora>/`.
- **Tornare a una versione precedente del repository**: `git log`, poi
  `git checkout <commit>` e `scripts/installa.sh`.

Il tema standard (`default`) non viene mai toccato: si può sempre vedere con
`?theme=default`.

## Licenze

- Font Titillium Web: SIL Open Font License, vedi
  `lizmap/www/themes/pa-it/css/fonts/OFL.txt`. File presi dal pacchetto
  `bootstrap-italia` 2.18.3.
- Il tema standard di Lizmap, da cui `installa.sh` parte, è distribuito con Lizmap
  (licenza MPL 2.0).
