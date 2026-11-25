# niri-dms-config

Config de [Kanata](https://github.com/jtroo/kanata) para manejar el mouse con el teclado, y atajos de
[niri](https://github.com/YaLTeR/niri) para Dux Shell, todo con la misma cruceta IJKL (CachyOS + niri + Dux).

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

## Atajos de niri (`niri/binds-ijkl.kdl`)

Los atajos de Dux que usaban HJKL pasan a IJKL (I arriba, J izquierda, K abajo, L derecha):

| Acción | Atajo |
|---|---|
| Foco entre ventanas/columnas | `Mod+J/K/I/L` |
| Mover ventanas/columnas | `Mod+Shift+J/K/I/L` |
| Foco a otro monitor | `Mod+Ctrl+J/K/I/L` |
| Mover columna a otro monitor | `Mod+Shift+Ctrl+J/K/I/L` |
| Workspace de abajo / arriba | `Mod+U` / `Mod+O` |
| Mover columna al workspace de abajo / arriba | `Mod+Ctrl+U` / `Mod+Ctrl+O` |
| Mover el workspace abajo / arriba | `Mod+Shift+U` / `Mod+Shift+O` |
| Overview | `Mod+H` (en Dux es `Mod+O`) |

No se toca `dms/binds.kdl`, que lo maneja Dux. El archivo se carga con un `include` al final de
`~/.config/niri/config.kdl`, después de los `include` de dms: niri usa el último bind definido,
así que estos atajos pisan los de Dux aunque Dux reescriba su archivo. niri recarga solo al guardar.

## Instalación

```sh
git clone https://github.com/Reco1I/niri-dms-config.git ~/kanata-config
~/kanata-config/install.sh
```

El script:
- **Config y servicio:** enlaza `config.kbd` en `~/.config/kanata/` y el servicio de usuario en `~/.config/systemd/user/`. Así, editar el archivo del repo cambia la config directamente.
- **Atajos de niri:** enlaza `niri/binds-ijkl.kdl` en `~/.config/niri/` y agrega el `include` al final de `config.kdl` si falta.
- **Permisos de uinput (con sudo):** instala la regla udev y la carga del módulo `uinput`.
- **Grupos:** agrega tu usuario a los grupos `input` y `uinput`.
- **Servicio:** lo activa para que Kanata arranque al iniciar sesión.

Después de editar `config.kbd`: `systemctl --user restart kanata`.

## Archivos

- `config.kbd`: mapeo activo de Kanata
- `niri/binds-ijkl.kdl`: atajos de niri con IJKL
- `systemd/kanata.service`: servicio de usuario
- `sistema/99-uinput.rules`: regla udev (`/etc/udev/rules.d/`)
- `sistema/uinput.conf`: carga del módulo uinput (`/etc/modules-load.d/`)
