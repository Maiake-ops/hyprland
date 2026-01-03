if status is-interactive
    # --- UI & Greeting ---
    set -g fish_greeting ""
    echo -e (set_color 06398e)"󰇄  Welcome back. Arch Linux environment initialized."

    # --- Direct Aliases (No checks, just speed) ---
    alias ls='eza -1 --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first'
    alias la='eza -la --icons --group-directories-first'
    alias tree='eza --tree'
    alias cat='bat --style=plain' # Keep it clean
    alias grep='grep --color=auto'
    alias reload='source ~/.config/fish/config.fish'

    # --- Liquid Syntax Highlighting ---
    set -U fish_color_normal d6bbf8
    set -U fish_color_command d6bbf8 --bold
    set -U fish_color_quote 6f78ff
    set -U fish_color_redirection d6bbf8
    set -U fish_color_end 172188
    set -U fish_color_error ff5555
    set -U fish_color_param d6bbf8
    set -U fish_color_comment 595959
    set -U fish_color_autosuggestion 595959
    set -U fish_color_operator 06398e
    set -U fish_color_escape 6f78ff
    set -U fish_color_cwd 06398e

    # --- Prompt ---
    starship init fish | source
end