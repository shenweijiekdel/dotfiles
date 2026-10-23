local wezterm = require("wezterm")
local act = wezterm.action
local ui = require("ui")

local config = wezterm.config_builder()
for key, value in pairs(ui) do
	config[key] = value
end

config.window_close_confirmation = "NeverPrompt"
-- Windows 默认快捷键，可通过 wezterm show-keys --lua 查询
-- Alt-Enter 全屏
-- CTRL-SHIFT-m 最小化窗口
-- CTRL-SHIFT-鼠标 拖动窗口
-- CTRL-SHIFT-t 新建tab
-- CTRL-Tab | CTRL-数字 切换tab
-- CTRL-SHIFT-p 打开命令面板
-- CTRL-SHIFT-Alt-" 垂直分割pane（窗格）
-- CTRL-SHIFT-Alt-% 水平分割pane（窗格）
-- CTRL-SHIFT-方向键 激活不同Pane
-- CTRL-SHIFT-Alt-方向键 调整Pane大小
-- CTRL-SHIFT-z 切换pane缩放模式
-- CTRL-SHIFT-f 搜索
-- CTRL-SHIFT-空格键 进入快速选择模式（会将一些特定文本用字母标注，然后输入字母就会复制对应文本到剪贴板，如果输入字母的大写模式就会复制并粘贴对应文本）
-- CTRL-SHIFT-u 输入特殊字符（Unicode）
config.keys = {
	{
		-- CTRL-SHIFT-w 关闭Pane，直至关闭tab
		key = "w",
		mods = "SHIFT|CTRL",
		action = wezterm.action.CloseCurrentPane({
			confirm = true,
		}),
	},
	{
		-- CTRL-SHIFT-e 重命名tab
		key = "E",
		mods = "CTRL|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		-- SHIFT-Enter 最大化window
		key = "Enter",
		mods = "SHIFT",
		action = wezterm.action_callback(function(window, pane)
			window:maximize()
		end),
	},
}

return config
