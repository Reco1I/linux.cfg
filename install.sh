#!/usr/bin/env bash
# Instala esta config de Kanata y los atajos IJKL de niri en la máquina actual.
# Requisitos: kanata instalado (en Arch/CachyOS: paquete AUR kanata-bin).
set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")"
REPO="$PWD"

command -v kanata >/dev/null || { echo "Falta kanata (AUR: kanata-bin)"; exit 1; }
kanata --cfg "$REPO/config.kbd" --check

echo "==> Enlazando config y servicio de usuario"
mkdir -p ~/.config/kanata ~/.config/systemd/user
ln -sfn "$REPO/config.kbd" ~/.config/kanata/config.kbd
ln -sfn "$REPO/systemd/kanata.service" ~/.config/systemd/user/kanata.service

echo "==> Atajos IJKL de niri"
NIRI_CFG=~/.config/niri/config.kdl
if [ -f "$NIRI_CFG" ]; then
    ln -sfn "$REPO/niri/binds-ijkl.kdl" ~/.config/niri/binds-ijkl.kdl
    # El include tiene que ir al final, después de los de dms, para pisar sus binds
    grep -qxF 'include "binds-ijkl.kdl"' "$NIRI_CFG" ||
        printf '\n// Atajos IJKL propios (repo niri-dms-config). Tiene que ir después de los include de dms.\ninclude "binds-ijkl.kdl"\n' >> "$NIRI_CFG"
    command -v niri >/dev/null && niri validate
else
    echo "No hay $NIRI_CFG: salteo los atajos de niri"
fi

echo "==> Permisos de uinput (pide sudo)"
sudo install -Dm644 sistema/99-uinput.rules /etc/udev/rules.d/99-uinput.rules
sudo install -Dm644 sistema/uinput.conf /etc/modules-load.d/uinput.conf
getent group uinput >/dev/null || sudo groupadd --system uinput
sudo usermod -aG input,uinput "$USER"
sudo modprobe uinput
sudo udevadm control --reload-rules && sudo udevadm trigger --name-match=uinput

echo "==> Activando servicio"
systemctl --user daemon-reload
systemctl --user enable kanata.service

echo "Listo. Cerrá sesión y volvé a entrar (o reiniciá) para que tomen efecto los grupos."
