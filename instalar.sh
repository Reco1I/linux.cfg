#!/usr/bin/env bash
# Instala la configuración de Niri y Dux (DMS) del repo en esta máquina.
# No toca la configuración de monitores (niri/dms/outputs.kdl) y conserva
# en qué monitores se muestran las barras y docks de Dux.
# Antes de pisar, guarda una copia en ~/.config/linux.cfg-backup-<fecha>.
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
NIRI="$HOME/.config/niri"
DMS="$HOME/.config/dms"
BACKUP="$HOME/.config/linux.cfg-backup-$(date +%Y%m%d-%H%M%S)"

mkdir -p "$BACKUP"
[ -d "$NIRI" ] && cp -a "$NIRI" "$BACKUP/niri"
[ -f "$DMS/settings.json" ] && mkdir -p "$BACKUP/dms" && cp -a "$DMS/settings.json" "$BACKUP/dms/"

# Niri
mkdir -p "$NIRI/dms"
cp "$REPO/niri/config.kdl" "$REPO"/niri/binds-*.kdl "$NIRI/"
cp "$REPO"/niri/dms/*.kdl "$NIRI/dms/"

# Dux: mezcla settings.json manteniendo los screenPreferences locales (por id).
# Si una barra/dock no existe en esta máquina, se muestra en todos los monitores.
mkdir -p "$DMS"
if [ -f "$DMS/settings.json" ]; then
    LOCAL="$DMS/settings.json"
else
    LOCAL=/dev/null
fi
jq -n --slurpfile repo "$REPO/dms/settings.json" --slurpfile local <(cat "$LOCAL" 2>/dev/null || echo '{}') '
    ($local[0] // {}) as $l
    | def prefs($key; $id):
        ([($l[$key] // [])[] | select(.id == $id) | .screenPreferences] | first) // ["all"];
      $repo[0]
    | .barConfigs  |= map(. + {screenPreferences: prefs("barConfigs";  .id)})
    | .dockConfigs |= map(. + {screenPreferences: prefs("dockConfigs"; .id)})
' > "$DMS/settings.json.tmp"
mv "$DMS/settings.json.tmp" "$DMS/settings.json"

if command -v niri >/dev/null; then
    niri validate -c "$NIRI/config.kdl"
fi
echo "Listo. Backup en $BACKUP"
echo "Si Dux no toma los cambios, reinicialo (por ejemplo cerrando sesión)."
