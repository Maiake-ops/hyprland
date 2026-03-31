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
    sudo pacman -S --needed base-devel hyprland hyprpaper pipewire-pulse wireplumber fish rofi brightnessctl kitty rfkill arandr gnome-control-center gnome-calculator git

elif [ "$DISTRO" = "void" ]; then
    sudo xbps-install -Sy base-devel git hyprland hyprpaper pipewire wireplumber fish rofi brightnessctl kitty rfkill arandr gnome-control-center gnome-calculator

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
        dev-vcs/git
fi

# ---------------- CLONE DOTFILES ---------------- #

cd ~
git clone https://github.com/Maiake-ops/hyprland.git
cd hyprland

# ---------------- AUR (ARCH ONLY) ---------------- #

if [ "$DISTRO" = "arch" ]; then
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    yay -S localsend-bin --noconfirm
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

# ---------------- SHELL CHANGE ---------------- #

echo "[*] Setting fish as default shell..."
chsh -s "$(command -v fish)"

# ---------------- CLEANUP ---------------- #

cd ~
rm -rf hyprland

echo "[✔] Done. Reboot your system."
