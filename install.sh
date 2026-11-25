#!/usr/bin/env bash
# Instala esta config de Kanata en la máquina actual.
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
