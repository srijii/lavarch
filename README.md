# lavarch

A fully configured Hyprland setup for Arch Linux with a complete Wayland desktop environment, custom theming, utility scripts, and preconfigured applications.

This repository includes configurations for:

- Hyprland
- Waybar
- Rofi
- Dunst
- Kitty
- Hyprpaper
- Hyprlock
- Zsh
- Wallpapers and helper scripts

---

# Requirements

Before using this setup:

- Arch Linux installed
- Internet connection working
- User account with sudo access
- Booting into a TTY session

---

# Basic System Setup

Update the system:

```bash
sudo pacman -Syu
```

Install basic packages:

```bash
sudo pacman -S git base-devel curl zsh
```

---

# Networking Setup

If networking is not configured yet:

```bash
sudo pacman -S networkmanager
sudo systemctl enable --now NetworkManager
```

Verify internet access:

```bash
ping archlinux.org
```

---

# Full Package Installation

## Core Hyprland / Wayland

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

## Desktop Applications

```bash
sudo pacman -S \
waybar \
rofi-wayland \
kitty \
dolphin \
firefox
```

---

## Wallpaper / Lockscreen / Screenshots

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

## Audio / Media / Brightness

```bash
sudo pacman -S \
pipewire \
wireplumber \
pipewire-pulse \
playerctl \
brightnessctl
```

Enable audio services:

```bash
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

---

## Clipboard / Notifications

```bash
sudo pacman -S \
wl-clipboard \
cliphist \
dunst
```

---

## Script Dependencies

```bash
sudo pacman -S \
inotify-tools
```

---

## Shell Utilities

```bash
sudo pacman -S \
eza \
bat \
fzf \
fd \
fastfetch
```

---

# Fonts

Recommended font:

- `0xProto Nerd Font`

Without Nerd Fonts, many UI icons will appear broken.

---

# Optional Applications

Optional applications referenced in rules/scripts:

- Spotify
- Spicetify
- Vesktop
- Telegram
- Helvum

---

# Clone and Install

Clone the repository:

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

# Required Manual Configuration

Some configuration files contain hardcoded paths and monitor names.

Update these files after installation:

| File | Required Changes |
|---|---|
| `~/.config/hypr/hyprpaper.conf` | Wallpaper paths and monitor name |
| `~/.config/hypr/hyprlock.conf` | Wallpaper paths |
| `~/scripts/random-wallpaper.sh` | Monitor name |
| `~/.config/hypr/hyprland.conf` | Monitor and input device configuration |
| `~/.zshrc` | Hardcoded user paths |

---

## Automatically Replace Hardcoded Paths

Replace `/home/monok8i` automatically:

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

# First Launch

After completing the setup, log into your TTY session and start Hyprland manually once:

```bash
Hyprland
```

This launches the complete desktop environment including:

- Waybar
- Hyprpaper
- Dunst
- Wallpaper system
- Rofi
- Autostart applications

If everything loads correctly, continue with the auto-start setup below.

---

# Auto-Start Hyprland on Login

To automatically launch Hyprland whenever logging into `tty1`, add the following to:

```bash
~/.zprofile
```

Open the file:

```bash
nano ~/.zprofile
```

Add:

```bash
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec Hyprland
fi
```

Save and exit.

After this setup, the login flow becomes:

```text
Boot
→ Login on tty1
→ Hyprland starts automatically
```

No display manager is required.

---

# Optional: Display Manager Setup

If a graphical login screen is preferred:

```bash
sudo pacman -S sddm
sudo systemctl enable --now sddm
```

Then select Hyprland from the session menu.

---

# Post-Install Checklist

After launching Hyprland, verify:

- Waybar loads correctly
- Dunst notifications work
- Wallpapers load correctly
- Clipboard history works
- Screenshots function correctly
- PipeWire audio works
- Rofi launches properly

---

# Known Manual Steps

## Missing `dunst-status.sh`

Waybar references:

```bash
~/scripts/dunst-status.sh
```

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

Or remove the `custom/notification` module from Waybar.

---

## ASUS-Specific Keyboard Backlight Script

`kb-brightness-notify.sh` uses:

```bash
/sys/class/leds/asus::kbd_backlight
```

Find the correct device using:

```bash
ls /sys/class/leds
```

or:

```bash
find /sys/class/leds -name '*kbd*'
```

---

# Keybindings

Main modifier: `SUPER`

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

This setup is opinionated and may require adjustments depending on:

- Monitor layout
- GPU configuration
- Input devices
- Laptop-specific hardware
- Preferred applications

Review the configuration files before using them in an existing setup.
