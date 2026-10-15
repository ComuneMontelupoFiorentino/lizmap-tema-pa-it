#!/usr/bin/env bash
# =====================================================================
# salva-originali.sh
#
# Copia da un'installazione di Lizmap gli ORIGINALI dei file su cui il
# tema pa-it si basa, in originali/<versione>/.
# Da usare dopo aver adattato gli override a una nuova versione, così il
# prossimo controlla-aggiornamento.sh confronterà con questa.
#
# I file salvati sono quelli presenti nella versione-base più recente,
# più ogni template sovrascritto in lizmap/var/themes/pa-it/.
#
# Uso:
#   scripts/salva-originali.sh /percorso/lizmap-web-client-X.Y.Z/lizmap X.Y.Z
# =====================================================================
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"

if [ $# -lt 2 ]; then
  echo "Uso: $0 /percorso/lizmap-web-client-X.Y.Z/lizmap X.Y.Z" >&2
  exit 2
fi

TARGET="${1%/}"
VERSIONE="$2"
DEST="$REPO/originali/$VERSIONE"
ULTIMA="$(ls -1 "$REPO/originali" 2>/dev/null | sort -V | tail -1 || true)"

if [ -e "$DEST" ]; then
  echo "ERRORE: $DEST esiste già." >&2
  exit 2
fi

# Elenco dei file da salvare (percorsi relativi alla cartella lizmap/)
LISTA="$(mktemp)"
trap 'rm -f "$LISTA"' EXIT

if [ -n "$ULTIMA" ]; then
  (cd "$REPO/originali/$ULTIMA" && find . -type f | sed 's|^\./||') >> "$LISTA"
fi

# ogni template sovrascritto: var/themes/pa-it/<modulo>/<file>.tpl
# corrisponde all'originale modules/<modulo>/templates/<file>.tpl
if [ -d "$REPO/lizmap/var/themes/pa-it" ]; then
  (cd "$REPO/lizmap/var/themes/pa-it" && find . -type f -name '*.tpl' | sed 's|^\./||') |
  while IFS= read -r t; do
    modulo="${t%%/*}"
    file="${t#*/}"
    echo "modules/$modulo/templates/$file"
  done >> "$LISTA"
fi

sort -u "$LISTA" | while IFS= read -r rel; do
  if [ -f "$TARGET/$rel" ]; then
    mkdir -p "$DEST/$(dirname "$rel")"
    cp "$TARGET/$rel" "$DEST/$rel"
    echo "salvato  $rel"
  else
    echo "ATTENZIONE: $rel non esiste in $TARGET" >&2
  fi
done

echo
echo "Originali $VERSIONE salvati in $DEST"
echo "Ricorda di fare il commit: git add originali/$VERSIONE && git commit"
