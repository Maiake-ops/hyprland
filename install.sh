#!/bin/bash

# --- Liquid Glass Auto-Installer ---
# Target: Arch Linux

echo "😈 Initializing Environment..."

# 1. Install Dependencies
echo "📦 Installing core components..."
sudo pacman -S --needed hyprland waybar rofi-wayland kitty fish starship eza git bat hyprpaper hyprpicker ttf-jetbrains-mono-nerd --noconfirm

# 2. Create Directories
mkdir -p ~/.config/{hypr,waybar,rofi,fish,kitty}

# 3. Configure Fish Shell
echo "🐟 Setting up Fish Shell..."
cat << 'EOF' > ~/.config/fish/config.fish
if status is-interactive
    set -g fish_greeting ""
    echo -e (set_color 06398e)"󰇄  Welcome back. Arch Linux environment initialized."

    # Aliases
    alias ls='eza -1 --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first'
    alias la='eza -la --icons --group-directories-first'
    alias cat='bat --style=plain'
    alias reload='source ~/.config/fish/config.fish'

    # Theme Colors
    set -U fish_color_normal d6bbf8
    set -U fish_color_command d6bbf8 --bold
    set -U fish_color_quote 6f78ff
    set -U fish_color_autosuggestion 595959
    set -U fish_color_param d6bbf8

    starship init fish | source
end
EOF

# 4. Configure Starship
echo "🚀 Setting up Starship Prompt..."
cat << 'EOF' > ~/.config/starship.toml
format = """
[░▒▓](#06398e)\
[  ](bg:#06398e fg:#030419)\
[](fg:#06398e bg:#172188)\
$directory\
[](fg:#172188 bg:#3b4252)\
$git_branch$git_status\
[](fg:#3b4252 bg:transparent)\
$character"""

[directory]
style = "bg:#172188 fg:#d6bbf8"
format = "[ $path ]($style)"

[character]
success_symbol = "[ 󱐋](bold #d6bbf8)"
error_symbol = "[ 󱐋](bold #ff5555)"
EOF

# 5. Configure Kitty (The Glass Engine)
echo "🐱 Setting up Kitty..."
cat << 'EOF' > ~/.config/kitty/kitty.conf
font_family      JetBrainsMono Nerd Font
font_size        12.0
background_opacity 0.82
background_blur    15
window_padding_width 15
confirm_os_window_close 0
foreground #d6bbf8
background #030419
EOF

# 6. Configure Rofi
echo "🔍 Setting up Rofi..."
cat << 'EOF' > ~/.config/rofi/config.rasi
configuration {
    modi: "drun";
    show-icons: true;
    display-drun: " ";
}
* {
    bg: rgba(3, 4, 25, 0.85);
    accent: #d6bbf8;
    background-color: transparent;
    text-color: @accent;
}
window {
    width: 600px;
    border: 2px;
    border-color: rgba(23, 33, 136, 0.5);
    border-radius: 20px;
    background-color: @bg;
}
mainbox { padding: 24px; children: [ "inputbar", "listview" ]; }
inputbar {
    padding: 12px;
    background-color: rgba(255, 255, 255, 0.05);
    border-radius: 12px;
    children: [ "prompt", "entry" ];
}
listview { lines: 8; spacing: 8px; }
element { padding: 10px; border-radius: 10px; }
element selected { background-color: rgba(214, 187, 248, 0.15); text-color: #ffffff; }
EOF

# 7. Set Fish as default shell
echo "🐚 Changing default shell to Fish..."
chsh -s $(which fish)

git clone https://github.com/Maiake-ops/hyprland/
cd hyprland
mv a.jpg ~/.config/hypr/
mv hyprpaper.conf ~/.config/hypr/
rm -rf hyprland


echo "✅ Installation Complete!"
echo "⚠️  Restart Hyprland to apply all changes."
