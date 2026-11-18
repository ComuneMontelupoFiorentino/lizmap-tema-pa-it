#!/usr/bin/env bash
# =====================================================================
# controlla-aggiornamento.sh
#
# Confronta i file STANDARD di un'installazione di Lizmap con le copie
# degli originali su cui abbiamo costruito il tema pa-it (cartella
# originali/<versione>/ del repository).
#
# Se un originale è cambiato, il nostro override va rivisto: lo script
# mostra le differenze e termina con codice 1.
#
# Uso:
#   scripts/controlla-aggiornamento.sh /percorso/lizmap-web-client-X.Y.Z/lizmap [versione-base]
#
# Esempio:
#   scripts/controlla-aggiornamento.sh /var/www/lizmap-web-client-3.9.1/lizmap
#
# versione-base: sottocartella di originali/ da usare (default: la più recente).
# =====================================================================
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"

if [ $# -lt 1 ]; then
  echo "Uso: $0 /percorso/lizmap-web-client-X.Y.Z/lizmap [versione-base]" >&2
  exit 2
fi

TARGET="${1%/}"
BASE="${2:-$(ls -1 "$REPO/originali" | sort -V | tail -1)}"
ORIG="$REPO/originali/$BASE"

if [ ! -d "$TARGET/modules" ] || [ ! -d "$TARGET/www" ]; then
  echo "ERRORE: $TARGET non sembra la cartella 'lizmap' di un'installazione (mancano modules/ o www/)." >&2
  exit 2
fi
if [ ! -d "$ORIG" ]; then
  echo "ERRORE: originali per la versione '$BASE' non trovati in $REPO/originali/" >&2
  exit 2
fi

VERSIONE_TARGET="sconosciuta"
if [ -f "$TARGET/project.xml" ]; then
  VERSIONE_TARGET="$(grep -o '<version[^>]*>[^<]*' "$TARGET/project.xml" | head -1 | sed 's/.*>//')" || true
fi

echo "Repository tema : $REPO"
echo "Originali base  : $BASE"
echo "Installazione   : $TARGET (versione $VERSIONE_TARGET)"
echo

CAMBIATI=0
MANCANTI=0

while IFS= read -r -d '' f; do
  rel="${f#$ORIG/}"
  dest="$TARGET/$rel"

  # I CSS del tema standard sono solo informativi: installa.sh li riprende
  # sempre dalla nuova versione, quindi le loro modifiche arrivano da sole.
  tipo="TEMPLATE"
  case "$rel" in
    www/themes/default/*) tipo="CSS (informativo)";;
  esac

  if [ ! -f "$dest" ]; then
    echo "!! MANCANTE   [$tipo] $rel"
    echo "   Il file non esiste più nella nuova versione: l'override va ripensato."
    MANCANTI=$((MANCANTI + 1))
    continue
  fi

  # -w e -B: ignoriamo differenze di soli spazi e righe vuote
  if diff -q -w -B "$f" "$dest" > /dev/null; then
    echo "OK  invariato [$tipo] $rel"
  else
    echo "!! CAMBIATO   [$tipo] $rel"
    echo "   --- righe con '<' = originale $BASE, righe con '>' = nuova versione ---"
    diff -w -B "$f" "$dest" | sed 's/^/   /' || true
    echo
    if [ "$tipo" = "TEMPLATE" ]; then
      CAMBIATI=$((CAMBIATI + 1))
    fi
  fi
done < <(find "$ORIG" -type f -print0 | sort -z)

echo
if [ $CAMBIATI -eq 0 ] && [ $MANCANTI -eq 0 ]; then
  echo "RISULTATO: nessun template di riferimento è cambiato. Puoi installare il tema."
  exit 0
fi

cat <<EOF
RISULTATO: $CAMBIATI template cambiati, $MANCANTI mancanti.

Cosa fare (vedi README, sezione "Aggiornare Lizmap"):
  1. Riporta le modifiche di 3Liz nei nostri override in lizmap/var/themes/pa-it/
  2. Salva i nuovi originali:  scripts/salva-originali.sh $TARGET $VERSIONE_TARGET
  3. Fai un commit che spieghi cosa hai adattato.
  4. Installa:  scripts/installa.sh $TARGET
EOF
exit 1
