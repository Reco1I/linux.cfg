# kanata-config

Config de [Kanata](https://github.com/jtroo/kanata) para manejar el mouse con el teclado (CachyOS + niri).

## Mapeo actual (`config.kbd`): modo hold

Si solo tocás CapsLock, funciona como CapsLock normal. Mientras lo mantenés:

| Tecla | Acción |
|---|---|
| I J K L | Mover el cursor (arriba, izquierda, abajo, derecha), con aceleración |
| F o Espacio | Clic izquierdo (mantener = arrastrar) |
| D | Clic derecho |
| S | Clic del medio |
| U / O | Scroll arriba / abajo |
| A (mantenido) | Modo preciso, al 30% de velocidad |

Aceleración: de 1 a 16 px cada 4 ms, llega al máximo en 700 ms
(en las líneas `movemouse-accel-*`: el último número es la velocidad máxima y el segundo el tiempo de aceleración en ms).

## Variantes (`variantes/`)

| Archivo | Descripción |
|---|---|
| `hold-hjkl-original.kbd` | Mantener CapsLock; HJKL/flechas mueven, U I O clics, N M scroll, Shift izq. lento |
| `toggle.kbd` | CapsLock activa/desactiva el modo mouse; Esc sale; Shift+CapsLock = mayúsculas |
| `toggle-luz.kbd` | Igual que `toggle`, y la luz de CapsLock queda encendida en modo mouse |
| `toggle-luz-bloqueo.kbd` | Igual que `toggle-luz`, y bloquea las teclas que escriben en modo mouse |

Para usar una variante: copiala sobre `config.kbd` y corré `systemctl --user restart kanata`.

## Instalación

```sh
git clone https://github.com/Reco1I/kanata-config.git ~/kanata-config
~/kanata-config/install.sh
```

El script:
- **Config y servicio:** enlaza `config.kbd` en `~/.config/kanata/` y el servicio de usuario en `~/.config/systemd/user/`. Así, editar el archivo del repo cambia la config directamente.
- **Permisos de uinput (con sudo):** instala la regla udev y la carga del módulo `uinput`.
- **Grupos:** agrega tu usuario a los grupos `input` y `uinput`.
- **Servicio:** lo activa para que Kanata arranque al iniciar sesión.

Después de editar `config.kbd`: `systemctl --user restart kanata`.

## Archivos

- `config.kbd`: mapeo activo
- `systemd/kanata.service`: servicio de usuario
- `sistema/99-uinput.rules`: regla udev (`/etc/udev/rules.d/`)
- `sistema/uinput.conf`: carga del módulo uinput (`/etc/modules-load.d/`)
