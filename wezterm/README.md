# WezTerm 与 tmux 主题配置

## 概览

已保存四套暗色主题，使用 `set-theme` 一条命令同时切换 WezTerm 与当前 tmux 服务的配色。字体、字号、毛玻璃、布局和快捷键独立于主题，切换不会关闭窗口或会话。

本文创建时使用 **Catppuccin Mocha**；实际当前主题以 `current-theme` 文件为准。

## 主题选择与切换

| 主题标识 | 名称 | 风格 |
| --- | --- | --- |
| `catppuccin-mocha` | Catppuccin Mocha | 深灰紫底、淡紫高亮、柔和粉彩 |
| `gruvbox-dark-hard` | Gruvbox Dark Hard | 暖灰黑底、米白文字、金色高亮，对比鲜明 |
| `rose-pine-moon` | Rosé Pine Moon | 深紫灰底、玫瑰色高亮、金色点缀 |
| `everforest` | Everforest | 深灰绿底、米色文字、森林绿高亮 |

### 推荐：命令切换

在终端执行其中一条：

```bash
~/.config/wezterm/set-theme catppuccin-mocha
~/.config/wezterm/set-theme gruvbox-dark-hard
~/.config/wezterm/set-theme rose-pine-moon
~/.config/wezterm/set-theme everforest
```

脚本会验证主题名称及文件，加载对应 tmux 配色，再更新 `current-theme`。WezTerm 监听该文件并自动重载。未运行 tmux 时只保存选择，下次 tmux 加载配置时使用所选主题。

tmux 同步针对命令连接的服务，通常是默认服务；使用多个独立 socket 的 tmux 服务时，不会自动同步全部服务。

### 手动修改配置

编辑 `~/.config/wezterm/current-theme`，写入上述主题标识之一，独占一行。例如：

```text
catppuccin-mocha
```

WezTerm 会自动重载。tmux 需要额外执行：

```bash
~/.config/wezterm/set-theme --tmux-only
```

也可以使用现有 tmux 重载快捷键：先按 `Ctrl + A`，松开后按 `r`。

如果 WezTerm 外观未更新，可按 `Ctrl + Shift + R` 手动重载。

## 文件职责

```text
~/.config/wezterm/
├── wezterm.lua                 # 生效入口：组合外观与原有快捷键
├── ui.lua                      # 通用外观：字体、透明度、光标、布局
├── current-theme               # 当前主题名称，唯一选择来源
├── set-theme                   # 主题切换与 tmux 同步脚本
├── themes/
│   ├── catppuccin-mocha.lua     # WezTerm 主题
│   ├── catppuccin-mocha.tmux    # 对应 tmux 主题
│   ├── gruvbox-dark-hard.lua
│   ├── gruvbox-dark-hard.tmux
│   ├── rose-pine-moon.lua
│   ├── rose-pine-moon.tmux
│   ├── everforest.lua
│   └── everforest.tmux
└── README.md
```

依赖关系：

```text
wezterm.lua → ui.lua → current-theme + themes/<主题>.lua
~/.tmux.conf → set-theme --tmux-only → current-theme + themes/<主题>.tmux
set-theme <主题> → 对应 tmux 配色 + 更新 current-theme
```

`~/.tmux.conf` 保留通用布局、快捷键与插件，配色从主题文件加载。目录中的旧 `init.lua`、`colors/` 不参与当前这套主题加载。

## 通用外观设置

修改 `ui.lua` 即可让所有主题统一使用新的外观参数：

| 设置 | 当前值 |
| --- | --- |
| 英文与图标字体 | Monaco Nerd Font |
| 中文字体 | PingFang SC（苹方简体） |
| 备用字体 | Monaco |
| 字号 | `14` |
| 行距 | `1.1` |
| 窗口背景不透明度 | `0.82` |
| macOS 背景模糊强度 | `35` |
| 文字单元格背景不透明度 | `1.0` |
| 光标 | `SteadyBlock`，常亮块状 |
| 窗口装饰 | `RESIZE`，无标题栏、保留缩放边框 |
| 标签栏 | 单标签隐藏，多标签显示 |

主题只定义配色，不覆盖以上设置。

### tmux Powerline 分隔符

当前四套主题使用三角分隔符 ``、``，窗口标签与活动窗格标题两端为尖角，背景使用 `bg=terminal`。曾试用半圆 ``、``，现已恢复三角；如需再次试用，可在四套 `.tmux` 文件中将 `` 替换为 ``、`` 替换为 ``，再运行 `set-theme --tmux-only`。

四套 tmux 主题均使用 Powerline 分隔符 ``、``：左侧会话末端使用右向箭头，窗口标签两端使用向外尖角，右侧时间与日期使用左向箭头。状态栏空白区域及色块外侧尖角使用默认背景，透出毛玻璃；时间与日期内部的连接箭头保留相邻色块背景，保证颜色衔接。第二行分隔带保持原有颜色。活动窗格顶部标题的高亮区域两端同样使用 ``、`` 尖角，非活动窗格保持低调的普通标题。箭头颜色随主题切换，原有双行状态栏布局保持不变。

这些符号需要支持 Powerline 的字体；当前配置使用 Monaco Nerd Font，并设置 `custom_block_glyphs = false`，让尖角由字体渲染而非 WezTerm 内置绘制。该设置也会让其他块状、制表线等受支持符号交由字体渲染。状态栏及活动窗格标题外侧尖角使用 `bg=terminal`，明确使用终端默认背景，避免固定深色背景形成矩形底块。不要用 `bg=default` 替代：在窗口列表中它可能继承窗口标签的高亮背景，使三角前景与背景同色，导致尖角看起来消失。外观格式位于 `themes/<主题>.tmux` 的 `status-left`、`status-right`、`window-status-format` 和 `window-status-current-format` 中。

### Vim 背景与毛玻璃

Vim 等程序如果显式绘制背景色，该背景在 `text_background_opacity = 1.0` 下可能不透明，即使普通终端区域已有毛玻璃。

可在 Vim 中清除编辑区背景，或调整 WezTerm 的 `text_background_opacity`；后者也会影响 tmux 状态栏、选区等程序指定的背景。不要将窗口透明度与程序背景透明度混为一谈。

本次主题配置不负责修改 Vim 高亮；本文不表示 Vim 的透明设置已写入 `~/.vimrc`。

## 呼出与工作区

Hammerspoon 配置位于 `~/.hammerspoon/`，独立于主题：

- `Option + U`：呼出或隐藏 WezTerm。
- 呼出时最大化普通窗口并置前，不是始终置顶。
- 首次启动等待窗口期间合并重复按键，避免重复启动。
- macOS Dock 中为 WezTerm 设置「选项 → 分配给 → 所有桌面」，用于跨普通桌面呼出；该分配是持久设置。
- 原生全屏空间不同于普通桌面，不保证相同行为。

## 新增主题与验证

新增主题时：

1. 在 `themes/` 下创建同名 `.lua` 和 `.tmux` 文件。
2. `.lua` 返回 `color_scheme` 与 `colors`；`.tmux` 定义状态栏、窗格边框、选区与提示配色，参考已有文件覆盖同样的配置项。
3. 在 `set-theme` 的主题白名单及用法提示中加入新标识。
4. 验证配置，再执行切换。

常用检查：

```bash
bash -n ~/.config/wezterm/set-theme
luac -p ~/.config/wezterm/ui.lua
wezterm show-keys --lua >/dev/null
tmux show-options -g status-style
tmux show-options -g pane-active-border-style
```

WezTerm 内置主题名称需与当前版本精确匹配，不能只使用展示名称猜测。

## 小结

日常切换优先使用 `~/.config/wezterm/set-theme <主题标识>`，让 WezTerm 和 tmux 保持一致；调字体或毛玻璃改 `ui.lua`，调某套配色改 `themes/` 下对应文件。现有四套主题全部保留，可随时切回。
