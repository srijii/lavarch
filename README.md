# lavarch
⚡ lavarch - my personal Hyprland config for Arch Linux.

This README covers what to do **after a fresh Arch install** and on the **first login into a TTY** (no WM yet).

## What’s included
- Hyprland config (colors, keybinds, autostart)
- Waybar, Rofi, Dunst, Kitty configs
- Hyprpaper + Hyprlock configs
- Wallpapers and scripts
- Zsh config

## 0) After Arch install (first boot in TTY)
Make sure you can log in, have networking, and sudo set up.

Recommended basics:
- `sudo pacman -Syu`
- Install `git`, `base-devel`, `curl`, `zsh`
- Enable networking if you don’t have it yet (`NetworkManager` is the usual choice)

## 1) Install required packages
Install via `pacman` / `yay` as appropriate.  
Packages are grouped by what the configs/scripts reference.

**Core Wayland/Hyprland**
- `hyprland`, `xdg-desktop-portal-hyprland`, `xorg-xwayland`
- `dbus`, `polkit`, `seatd` (if needed on your setup)

**Bar / launcher / terminal / file manager**
- `waybar`
- `rofi` or `rofi-wayland`
- `kitty`
- `dolphin`
- `firefox`

**Wallpaper / lockscreen / screenshots**
- `hyprpaper`
- `hyprlock`
- `hyprshot` (uses `grim` + `slurp`)
- `imagemagick` (for `convert` in `wall-changer.sh`)

**Audio / media / power**
- `pipewire`, `wireplumber`, `pipewire-pulse` (for `wpctl`)
- `playerctl`
- `brightnessctl`

**Clipboard / notifications**
- `wl-clipboard` (for `wl-copy` / `wl-paste`)
- `cliphist`
- `dunst` (and `dunstify`)

**Utilities used by scripts**
- `inotify-tools` (for `inotifywait` in `kb-brightness-notify.sh`)

**Fonts**
- `0xProto Nerd Font` (used in kitty, rofi, dunst, hyprlock)

**Shell tooling referenced in `.zshrc` (optional but expected)**
- `oh-my-zsh` + `catppuccin` theme
- `eza`, `bat`, `fzf`, `fd`, `fastfetch`

**Optional apps referenced in UI**
- `helvum` (Waybar audio click)
- `spotify`, `spicetify`, `vesktop`, `telegram` (icons & app rules)

## 2) Clone and install configs
```bash
git clone https://github.com/srijii/lavarch.git
cd lavarch

mkdir -p ~/.config ~/.wallpapers ~/scripts

cp -r configs/.config/* ~/.config/
cp -r configs/.wallpapers/* ~/.wallpapers/
cp -r scripts/* ~/scripts/
cp -r configs/.zshrc ~/.zshrc

chmod +x ~/scripts/*.sh
```

## 3) Fix paths and hardware-specific settings
These configs are personal and include hardcoded paths and device names.

Update these after copying:
- `~/.config/hypr/hyprpaper.conf`  
  Replace `/home/monok8i` and update monitor name (`eDP-1`).
- `~/.config/hypr/hyprlock.conf`  
  Update wallpaper path to your `~/.wallpapers/…` files.
- `~/scripts/random-wallpaper.sh`  
  Update the monitor name (`eDP-1`) if yours differs.
- `~/.config/hypr/hyprland.conf`  
  Update `monitor=` and input device names if needed.
- `~/.zshrc`  
  Update the `PATH` line that includes `/home/monok8i/.spicetify`.

Optional helper to replace the hardcoded home path:
```bash
USER_NAME="$(whoami)"
grep -rl "/home/monok8i" ~/.config ~/.zshrc ~/scripts | xargs sed -i "s|/home/monok8i|/home/$USER_NAME|g"
```

Find your monitor names with:
```bash
hyprctl monitors
```

## 4) First launch (no WM installed)
You can start Hyprland either from a display manager or directly from TTY:

**Option A: start from TTY**
```bash
Hyprland
```

**Option B: install a display manager (example: SDDM)**
```bash
sudo pacman -S sddm
sudo systemctl enable --now sddm
```

## 5) Post-launch checklist
- Start `dunst` (or set up a user service) so notifications work.
- Confirm Waybar loads (depends on `waybar`, `wireplumber`, `wl-clipboard`, etc.)
- Run `~/.config/rofi` themes and scripts (requires `rofi`).
- Ensure `hyprpaper` is running (autostarted in Hyprland config).
- Verify screenshots (`hyprshot`) and clipboard history (`cliphist`).

## 6) Notes / known manual steps
- Waybar references `~/scripts/dunst-status.sh` but it is **not** in this repo.  
  Either create it (template below) or remove the `custom/notification` module from Waybar.
  ```bash
  cat <<'EOF' > ~/scripts/dunst-status.sh
  #!/usr/bin/env bash
  if dunstctl is-paused | grep -q true; then
    echo '{"text":"","class":"muted"}'
  else
    echo '{"text":""}'
  fi
  EOF
  chmod +x ~/scripts/dunst-status.sh
  ```
- `kb-brightness-notify.sh` is ASUS‑specific (`/sys/class/leds/asus::kbd_backlight`).  
  Find your keyboard backlight path with:
  ```bash
  ls /sys/class/leds
  # or
  find /sys/class/leds -name '*kbd*'
  ```

## Keybinds (high level)
Main modifier: **SUPER**
- **SUPER + Q** → kitty
- **SUPER + E** → dolphin
- **SUPER + R** → rofi (drun)
- **SUPER + B** → firefox
- **SUPER + V** → clipboard history
- **SUPER + SHIFT + W** → wallpaper picker
