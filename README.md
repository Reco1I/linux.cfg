# linux.cfg

Configuración de [Niri](https://github.com/YaLTeR/niri) y Dux (DMS).

## Qué hay

| Repo | En la máquina |
|---|---|
| `niri/config.kdl` | `~/.config/niri/config.kdl` |
| `niri/binds-monitores.kdl` | `~/.config/niri/binds-monitores.kdl` |
| `niri/dms/*.kdl` | `~/.config/niri/dms/` (generados por Dux) |
| `dms/settings.json` | `~/.config/dms/settings.json` |

**Queda afuera lo que depende de cada máquina:**
- `niri/dms/outputs.kdl`: resolución, escala y posición de los monitores.
- En `settings.json`, los `screenPreferences`: en qué monitor se muestra cada barra o dock.
- El estado de Dux (`~/.local/state/dms`): historial, ubicación del clima, etc.

## Uso

```sh
./instalar.sh   # repo -> máquina (hace backup antes de pisar)
./guardar.sh    # máquina -> repo
```

`instalar.sh` conserva los monitores de la máquina. Si una barra no tiene monitor asignado en esa máquina, aparece en todos. Para cambiarlo, andá a la configuración de Dux.

## Atajos para dos monitores (`binds-monitores.kdl`)

| Atajo | Acción |
|---|---|
| `Super+º` | Enfocar el otro monitor |
| `Super+Shift+º` | Mandar la ventana al otro monitor |
| `Super` + clic en la rueda | Mandar la ventana al otro monitor |
| `Super` + botón lateral adelante / atrás | Mandar la ventana al monitor siguiente / anterior |
