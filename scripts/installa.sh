#!/usr/bin/env bash
# =====================================================================
# installa.sh
#
# Installa il tema pa-it in un'installazione di Lizmap, SENZA toccare
# nessun file standard:
#
#   1. controlla che i template originali non siano cambiati
#      (controlla-aggiornamento.sh); se sono cambiati si ferma
#   2. salva una copia del tema pa-it già installato (se esiste)
#   3. www/themes/pa-it   = copia di www/themes/default della versione
#                           installata + i nostri file (font, bi-layout.css)
#                           + main.css costruito così:
#                             parti/main-prepend.css
#                             www/themes/default/css/main.css  (standard)
#                             parti/main-append.css
#   4. var/themes/pa-it   = i nostri template sovrascritti
#   5. var/config/localconfig.ini.php: imposta theme=pa-it
#
# Uso:
#   scripts/installa.sh /percorso/lizmap-web-client-X.Y.Z/lizmap [opzioni]
#
# Opzioni:
#   --forza          installa anche se i template originali sono cambiati
#   --non-attivare   non modifica localconfig.ini.php (per provare con ?theme=pa-it)
# =====================================================================
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
TEMA="pa-it"

FORZA=0
ATTIVA=1
TARGET=""
for a in "$@"; do
  case "$a" in
    --forza) FORZA=1;;
    --non-attivare) ATTIVA=0;;
    -*) echo "Opzione sconosciuta: $a" >&2; exit 2;;
    *) TARGET="${a%/}";;
  esac
done

if [ -z "$TARGET" ]; then
  echo "Uso: $0 /percorso/lizmap-web-client-X.Y.Z/lizmap [--forza] [--non-attivare]" >&2
  exit 2
fi

DEFAULT_THEME="$TARGET/www/themes/default"
if [ ! -f "$DEFAULT_THEME/css/main.css" ] || [ ! -d "$TARGET/modules" ]; then
  echo "ERRORE: $TARGET non sembra la cartella 'lizmap' di un'installazione" >&2
  echo "        (manca www/themes/default/css/main.css o modules/)." >&2
  exit 2
fi

echo "== 1. Controllo dei template originali"
if ! "$REPO/scripts/controlla-aggiornamento.sh" "$TARGET"; then
  if [ $FORZA -eq 0 ]; then
    echo
    echo "Installazione FERMATA: adatta prima gli override (o usa --forza se sai cosa fai)."
    exit 1
  fi
  echo "--forza: proseguo comunque."
fi
echo

STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$TARGET/var/backup-tema-$TEMA/$STAMP"

echo "== 2. Backup del tema già installato"
if [ -d "$TARGET/www/themes/$TEMA" ] || [ -d "$TARGET/var/themes/$TEMA" ]; then
  mkdir -p "$BACKUP"
  [ -d "$TARGET/www/themes/$TEMA" ] && cp -a "$TARGET/www/themes/$TEMA" "$BACKUP/www-themes-$TEMA"
  [ -d "$TARGET/var/themes/$TEMA" ] && cp -a "$TARGET/var/themes/$TEMA" "$BACKUP/var-themes-$TEMA"
  echo "Backup in $BACKUP"
else
  echo "Nessun tema $TEMA installato: niente da salvare."
fi
echo

echo "== 3. CSS e immagini: www/themes/$TEMA"
STAGING="$(mktemp -d)"
trap 'rm -rf "$STAGING"' EXIT

# base: il tema standard della versione installata
cp -a "$DEFAULT_THEME/." "$STAGING/"
# i nostri file (font, titillium.css, bi-layout.css, eventuali immagini)
cp -a "$REPO/lizmap/www/themes/$TEMA/." "$STAGING/"
# main.css = prepend + main.css standard + append
{
  cat "$REPO/parti/main-prepend.css"
  cat "$DEFAULT_THEME/css/main.css"
  cat "$REPO/parti/main-append.css"
} > "$STAGING/css/main.css"

rm -rf "$TARGET/www/themes/$TEMA"
cp -a "$STAGING" "$TARGET/www/themes/$TEMA"
chmod -R a+rX "$TARGET/www/themes/$TEMA"
echo "Installato $TARGET/www/themes/$TEMA"
echo

echo "== 4. Template: var/themes/$TEMA"
rm -rf "$TARGET/var/themes/$TEMA"
mkdir -p "$TARGET/var/themes"
cp -a "$REPO/lizmap/var/themes/$TEMA" "$TARGET/var/themes/$TEMA"
chmod -R a+rX "$TARGET/var/themes/$TEMA"
find "$TARGET/var/themes/$TEMA" -type f | sed "s|^$TARGET/|Installato |"
echo

echo "== 5. Configurazione: theme=$TEMA"
CONF="$TARGET/var/config/localconfig.ini.php"
if [ $ATTIVA -eq 0 ]; then
  echo "--non-attivare: localconfig.ini.php non modificato. Prova con ?theme=$TEMA"
elif [ ! -f "$CONF" ]; then
  echo "ATTENZIONE: $CONF non trovato. Aggiungi a mano: theme=$TEMA (vedi config/localconfig.snippet.ini)"
else
  # valore attuale, solo nella parte prima della prima [sezione]
  ATTUALE="$(awk '/^\[/{exit} /^theme[ \t]*=/{sub(/^theme[ \t]*=[ \t]*/,""); print}' "$CONF")"
  if [ "$ATTUALE" = "$TEMA" ]; then
    echo "Già impostato: theme=$TEMA"
  else
    cp "$CONF" "$CONF.bak-$STAMP"
    if [ -n "$ATTUALE" ]; then
      awk -v t="$TEMA" 'BEGIN{s=0} /^\[/{s=1} !s && /^theme[ \t]*=/{print "theme=" t; next} {print}' "$CONF.bak-$STAMP" > "$CONF"
      echo "Cambiato theme=$ATTUALE -> theme=$TEMA"
    else
      awk -v t="$TEMA" 'BEGIN{d=0} !d && /^\[/{print "theme=" t; print ""; d=1} {print} END{if(!d) print "theme=" t}' "$CONF.bak-$STAMP" > "$CONF"
      echo "Aggiunto theme=$TEMA prima della prima sezione"
    fi
    echo "Backup della configurazione: $CONF.bak-$STAMP"
  fi
fi
echo

cat <<EOF
FATTO.
Ricarica Lizmap con Ctrl+F5. Se non vedi le modifiche, svuota la cache di Lizmap
(lizmap/install/clean_vartmp.sh, oppure chiedi a chi ha i permessi di root).
Per tornare indietro: vedi README, sezione "Tornare indietro".
EOF
