#!/bin/bash

set -e

echo "[*] Detecting distro..."

if [ -f /etc/arch-release ]; then
    DISTRO="arch"
elif [ -f /etc/gentoo-release ]; then
    DISTRO="gentoo"
elif [ -f /etc/os-release ] && grep -qi "void" /etc/os-release; then
    DISTRO="void"
else
    echo "Unsupported distro."
    exit 1
fi

echo "[*] Detected: $DISTRO"

# ---------------- INSTALL PACKAGES ---------------- #

if [ "$DISTRO" = "arch" ]; then
    sudo pacman -S --needed base-devel hyprland hyprpaper pipewire-pulse wireplumber fish rofi brightnessctl kitty rfkill arandr gnome-control-center gnome-calculator git starship eza ttf-jetbrains-mono-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji

elif [ "$DISTRO" = "void" ]; then
    sudo xbps-install -Sy base-devel git hyprland hyprpaper pipewire wireplumber fish rofi brightnessctl kitty rfkill arandr gnome-control-center gnome-calculator starship eza font-jetbrains-mono noto-fonts-ttf noto-fonts-emoji

elif [ "$DISTRO" = "gentoo" ]; then
    sudo emerge --ask=n \
        gui-wm/hyprland \
        gui-apps/hyprpaper \
        media-video/pipewire \
        media-video/wireplumber \
        app-shells/fish \
        x11-misc/rofi \
        sys-apps/brightnessctl \
        x11-terms/kitty \
        net-wireless/rfkill \
        x11-apps/arandr \
        gnome-base/gnome-control-center \
        gnome-extra/gnome-calculator \
        dev-vcs/git \
        app-shells/starship \
        app-misc/eza \
        media-fonts/jetbrains-mono \
        media-fonts/noto \
        media-fonts/noto-cjk \
        media-fonts/noto-emoji
fi

# ---------------- CONFIG SETUP ---------------- #

echo "[*] Setting up configs..."

rm -rf ~/.config/hypr ~/.config/rofi ~/.config/fish ~/.config/waybar

mkdir -p ~/.config/{hypr,rofi,fish,waybar,starship}

cp -r starship.toml ~/.config/starship/
cp -r style.css ~/.config/waybar/
cp -r config ~/.config/waybar/
cp -r config.rasi ~/.config/rofi/config.rasi
cp -r hyprland.conf ~/.config/hypr/
cp -r hyprpaper.conf ~/.config/hypr/
cp -r a.jpg ~/.config/hypr/
cp -r config.fish ~/.config/fish/

# ---------------- STARSHIP INIT ---------------- #

echo "[*] Enabling Starship for fish..."

if ! grep -q "starship init fish" ~/.config/fish/config.fish 2>/dev/null; then
    echo 'starship init fish | source' >> ~/.config/fish/config.fish
fi

# ---------------- EZA ALIAS ---------------- #

echo "[*] Setting up eza aliases..."

if ! grep -q "alias ls=" ~/.config/fish/config.fish 2>/dev/null; then
    echo 'alias ls="eza --icons --group-directories-first"' >> ~/.config/fish/config.fish
    echo 'alias ll="eza -la --icons --group-directories-first"' >> ~/.config/fish/config.fish
    echo 'alias tree="eza --tree --icons"' >> ~/.config/fish/config.fish
fi

# ---------------- FONT CACHE ---------------- #

echo "[*] Refreshing font cache..."
fc-cache -fv

# ---------------- SHELL CHANGE ---------------- #

echo "[*] Setting fish as default shell..."
chsh -s "$(command -v fish)"

echo "[✔] Done. Reboot your system."