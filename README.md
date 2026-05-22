# lavarch

A minimal and opinionated Hyprland setup for Arch Linux, featuring a complete Wayland desktop configuration with curated themes, scripts, and utility integrations.

Designed for users who want a fast and clean Hyprland environment without manually configuring every component from scratch.

---

# Included Components

This repository contains configurations and scripts for:

- Hyprland
- Waybar
- Rofi
- Dunst
- Kitty
- Hyprpaper
- Hyprlock
- Zsh
- Wallpapers
- Utility scripts

---

# Requirements

This setup assumes:

- A fresh Arch Linux installation
- Networking configured and working
- A user account with `sudo` access
- Booting initially into a TTY (no desktop environment required)

---

# 1. Initial System Setup

Update the system and install basic tools:

```bash
sudo pacman -Syu
sudo pacman -S git base-devel curl zsh
```

If networking is not configured yet, install and enable NetworkManager:

```bash
sudo pacman -S networkmanager
sudo systemctl enable --now NetworkManager
```

---

# 2. Required Packages

Install the following packages before copying the configuration files.

## Core Wayland / Hyprland

```bash
sudo pacman -S \
hyprland \
xdg-desktop-portal-hyprland \
xorg-xwayland \
dbus \
polkit \
seatd
```

---

## Bar, Launcher, Terminal, File Manager

```bash
sudo pacman -S \
waybar \
rofi-wayland \
kitty \
dolphin \
firefox
```

---

## Wallpaper, Lock Screen, Screenshots

```bash
sudo pacman -S \
hyprpaper \
hyprlock \
hyprshot \
grim \
slurp \
imagemagick
```

---

## Audio, Media, Brightness

```bash
sudo pacman -S \
pipewire \
wireplumber \
pipewire-pulse \
playerctl \
brightnessctl
```

---

## Clipboard and Notifications

```bash
sudo pacman -S \
wl-clipboard \
cliphist \
dunst
```

---

## Utilities Used by Scripts

```bash
sudo pacman -S \
inotify-tools
```

---

## Fonts

Recommended font:

- `0xProto Nerd Font`

Install from the AUR if not available in the repositories.

---

## Optional Shell Utilities

Used in `.zshrc` and helper scripts:

```bash
sudo pacman -S \
eza \
bat \
fzf \
fd \
fastfetch
```

---

## Optional Applications

These are referenced in application rules, icons, or scripts:

- Spotify
- Spicetify
- Vesktop
- Telegram
- Helvum

---

# 3. Clone the Repository

```bash
git clone https://github.com/srijii/lavarch.git
cd lavarch
```

Create required directories:

```bash
mkdir -p ~/.config ~/.wallpapers ~/scripts
```

Copy the configuration files:

```bash
cp -r configs/.config/* ~/.config/
cp -r configs/.wallpapers/* ~/.wallpapers/
cp -r scripts/* ~/scripts/
cp configs/.zshrc ~/.zshrc
```

Make scripts executable:

```bash
chmod +x ~/scripts/*.sh
```

---

# 4. Hardware-Specific Configuration

Some files contain hardcoded paths and monitor/device names that must be updated manually.

## Files That Require Editing

### Hyprpaper

```bash
~/.config/hypr/hyprpaper.conf
```

Update:

- `/home/monok8i`
- Monitor name (`eDP-1`)

---

### Hyprlock

```bash
~/.config/hypr/hyprlock.conf
```

Update wallpaper paths if needed.

---

### Wallpaper Script

```bash
~/scripts/random-wallpaper.sh
```

Update the monitor name if it differs from `eDP-1`.

---

### Hyprland Configuration

```bash
~/.config/hypr/hyprland.conf
```

Update:

- `monitor=` entries
- Input device names
- Resolution or refresh rate settings if required

---

### Zsh Configuration

```bash
~/.zshrc
```

Update any hardcoded paths, especially Spicetify-related paths.

---

## Automatically Replace Hardcoded Home Paths

```bash
USER_NAME="$(whoami)"

grep -rl "/home/monok8i" ~/.config ~/.zshrc ~/scripts | \
xargs sed -i "s|/home/monok8i|/home/$USER_NAME|g"
```

---

## Find Monitor Names

```bash
hyprctl monitors
```

---

# 5. Starting Hyprland

## Option A — Launch Directly From TTY

```bash
Hyprland
```

---

## Option B — Use a Display Manager

Example using SDDM:

```bash
sudo pacman -S sddm
sudo systemctl enable --now sddm
```

---

# 6. Post-Launch Checklist

After launching Hyprland, verify the following:

- Waybar starts correctly
- Notifications work through Dunst
- Hyprpaper loads wallpapers
- Clipboard history works with `cliphist`
- Screenshots work using `hyprshot`
- Rofi launches properly
- Audio controls function through PipeWire

---

# 7. Known Manual Steps

## Missing `dunst-status.sh`

Waybar references:

```bash
~/scripts/dunst-status.sh
```

This script is not included in the repository.

Create it manually:

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

Alternatively, remove the `custom/notification` module from Waybar.

---

## ASUS-Specific Keyboard Backlight Script

The script:

```bash
kb-brightness-notify.sh
```

uses:

```bash
/sys/class/leds/asus::kbd_backlight
```

This path is ASUS-specific.

Find the correct keyboard backlight device using:

```bash
ls /sys/class/leds
```

or:

```bash
find /sys/class/leds -name '*kbd*'
```

---

# Keybindings

Main modifier key: `SUPER`

| Keybind | Action |
|---|---|
| `SUPER + Q` | Open Kitty |
| `SUPER + E` | Open Dolphin |
| `SUPER + R` | Launch Rofi |
| `SUPER + B` | Open Firefox |
| `SUPER + V` | Clipboard History |
| `SUPER + SHIFT + W` | Wallpaper Picker |

---

# Notes

This setup is intentionally opinionated and may require adjustments depending on:

- Monitor layout
- GPU configuration
- Input devices
- Preferred applications
- Laptop-specific hardware features

Review the configuration files before daily use instead of blindly copying everything into an existing setup.

```
