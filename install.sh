#!/bin/bash
sudo pacman -S hyprland hyprpaper pipewire-pulse wireplumber fish rofi brightnessctl kitty rfkill arandr gnome-control-center gnome-calculator git
git clone https://github.com/Maiake-ops/hyprland/
cd hyprland
git clone https://aur.archlinux/yay.git
cd yay
makepkg -si
cd ..
yay localsend-bin
rm -rf ~/.config/hypr/hyprland.conf
rm -rf ~/.config/rofi/config.rasi
rm -rf ~/.config/fish/config.fish 
rm -rf ~/.config/waybar
mkdir ~/.config/waybar
mkdir ~/.config/starship
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
