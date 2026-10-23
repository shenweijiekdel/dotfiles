#!/bin/bash
set -euo pipefail

dotfiles="$(cd "$(dirname "$0")" && pwd)"
stamp="$(date +%Y%m%d-%H%M%S)"

link() {
    local source="$1" target="$2"
    mkdir -p "$(dirname "$target")"
    if [[ -L "$target" ]]; then
        rm "$target"
    elif [[ -e "$target" ]]; then
        mv "$target" "$target.backup.$stamp"
        printf '已备份原有文件：%s -> %s.backup.%s\n' "$target" "$target" "$stamp"
    fi
    ln -s "$source" "$target"
    printf '已链接：%s -> %s\n' "$target" "$source"
}

link "$dotfiles/wezterm" "$HOME/.config/wezterm"
link "$dotfiles/tmux/tmux.conf" "$HOME/.tmux.conf"
link "$dotfiles/hammerspoon/init.lua" "$HOME/.hammerspoon/init.lua"
link "$dotfiles/hammerspoon/wezterm_hotkey.lua" "$HOME/.hammerspoon/wezterm_hotkey.lua"

printf '\n完成。后续步骤：\n'
printf '1. 授予 Hammerspoon「辅助功能」权限，并重载配置\n'
printf '2. 在 Dock 中为 WezTerm 设置「分配给 → 所有桌面」\n'
printf '3. tmux 内按 Ctrl+A 再按 r 重载配置\n'
