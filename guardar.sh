#!/usr/bin/env bash
# Copia la configuración de Niri y Dux (DMS) de esta máquina al repo.
# Deja afuera lo que depende de cada máquina (monitores) y los backups.
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
NIRI="$HOME/.config/niri"
DMS="$HOME/.config/dms"

# Niri
mkdir -p "$REPO/niri/dms"
cp "$NIRI/config.kdl" "$REPO/niri/"
cp "$NIRI"/binds-*.kdl "$REPO/niri/"
find "$REPO/niri/dms" -name '*.kdl' -delete
for f in "$NIRI"/dms/*.kdl; do
    [ "$(basename "$f")" = "outputs.kdl" ] && continue   # monitores: propio de cada máquina
    cp "$f" "$REPO/niri/dms/"
done

# Dux: settings.json sin la asignación de barras/docks a monitores
mkdir -p "$REPO/dms"
jq 'walk(if type == "object" then del(.screenPreferences) else . end)' \
    "$DMS/settings.json" > "$REPO/dms/settings.json"

echo "Listo. Revisá los cambios con: git -C \"$REPO\" diff"
