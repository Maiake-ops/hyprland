#!/bin/bash
sudo pacman -S base-devel hyprland hyprpaper pipewire-pulse wireplumber fish rofi brightnessctl kitty rfkill arandr gnome-control-center gnome-calculator git
git clone https://github.com/Maiake-ops/hyprland/
cd hyprland
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
yay localsend-bin
rm -rf ~/.config/hypr/
rm -rf ~/.config/rofi/
rm -rf ~/.config/fish/ 
rm -rf ~/.config/waybar/
mkdir -p ~/.config/hypr/
mkdir -p ~/.config/rofi/
mkdir -p ~/.config/fish/
mkdir -p ~/.config/waybar/
mkdir -p ~/.config/starship/
cp -r starship.toml ~/.config/starship
cp -r style.css ~/.config/waybar
cp -r config ~/.config/waybar
cp -r config.rasi ~/.config/rofi/config.rasi
cp -r hyprland.conf ~/.config/hypr/
cp -r hyprpaper.conf ~/.config/hypr/
cp -r a.jpg ~/.config/hypr/
cp -r config.fish ~/.config/fish/
chsh -s "$(command -v fish)"

cd ~ rm -rf hyprland
echo reboot ur system
