#!/usr/bin/env bash
set -e

echo "[*] Installing Maiake Hyprland setup..."

REPO="https://github.com/Maiake-ops/hyprland.git"
DIR="$HOME/.maiake-hyprland"

# --- Check system ---
if ! command -v pacman &>/dev/null; then
  echo "[!] Only Arch/Artix supported"
  exit 1
fi

# --- Confirm ---
read -p "Install Maiake Hyprland config? (y/n): " confirm
[ "$confirm" != "y" ] && exit 0

# --- Install dependencies ---
echo "[*] Installing packages..."
sudo pacman -S --needed --noconfirm \
  git hyprland waybar wofi foot \
  grim slurp wl-clipboard \
  networkmanager \
  fish starship fzf eza bat \
  ttf-dejavu ttf-font-awesome \
  polkit-gnome

# --- Clone repo ---
echo "[*] Cloning config..."
if [ ! -d "$DIR" ]; then
  git clone "$REPO" "$DIR"
else
  git -C "$DIR" pull
fi

cd "$DIR"

# --- Backup old configs ---
echo "[*] Backing up old configs..."
mkdir -p "$HOME/.config-backup"
for dir in hypr waybar wofi; do
  [ -d "$HOME/.config/$dir" ] && mv "$HOME/.config/$dir" "$HOME/.config-backup/$dir-$(date +%s)"
done

# --- Install configs ---
echo "[*] Installing configs..."
mkdir -p "$HOME/.config"

cp -r "$DIR/.config/hypr" "$HOME/.config/" 2>/dev/null || true
cp -r "$DIR/.config/waybar" "$HOME/.config/" 2>/dev/null || true
cp -r "$DIR/.config/wofi" "$HOME/.config/" 2>/dev/null || true

# --- Patch scripts (remove zsh if exists) ---
echo "[*] Fixing scripts..."
grep -rl '#!/bin/zsh' "$HOME/.config" 2>/dev/null | while read -r file; do
  sed -i '1s|/bin/zsh|/usr/bin/env sh|' "$file"
done

# --- Setup Fish ---
echo "[*] Setting up Fish shell..."
mkdir -p "$HOME/.config/fish"

cat > "$HOME/.config/fish/config.fish" << 'EOF'
# Prompt
starship init fish | source

# Aliases
alias ls="eza"
alias cat="bat"
alias update="sudo pacman -Syu"

# PATH
set -gx PATH $HOME/.local/bin $PATH

# Auto start Hyprland
if test -z "$WAYLAND_DISPLAY"; and test (tty) = "/dev/tty1"
    exec dbus-run-session Hyprland
end
EOF

# --- Set Fish as default ---
if [ "$SHELL" != "/usr/bin/fish" ]; then
  echo "[*] Setting Fish as default shell..."
  chsh -s /usr/bin/fish
fi

# --- Enable seatd (Artix/runit) ---
if [ -d /etc/runit/sv/seatd ]; then
  echo "[*] Enabling seatd..."
  sudo ln -sf /etc/runit/sv/seatd /run/runit/service/
fi

echo "[✓] Done!"
echo "👉 Reboot or login on tty1 to start Hyprland"