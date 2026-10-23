local wezterm = require("wezterm")
local themePath = wezterm.config_dir .. "/current-theme"
wezterm.add_to_config_reload_watch_list(themePath)
local file = assert(io.open(themePath, "r"))
local themeName = file:read("*l")
file:close()
assert(themeName and themeName:match("^[%w%-]+$"), "无效的主题名称")
local theme = require("themes." .. themeName)

return {
	color_scheme = theme.color_scheme,
	font = wezterm.font_with_fallback({ "Monaco Nerd Font", "PingFang SC", "Monaco" }),
	font_size = 14,
	custom_block_glyphs = false,
	line_height = 1.1,
	window_background_opacity = 0.82,
	macos_window_background_blur = 35,
	text_background_opacity = 1.0,
	window_decorations = "RESIZE",
	window_padding = {
		left = "1.5cell",
		right = "1.5cell",
		top = "1cell",
		bottom = "1cell",
	},
	default_cursor_style = "SteadyBlock",
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	use_fancy_tab_bar = false,
	show_new_tab_button_in_tab_bar = false,
	tab_max_width = 28,
	inactive_pane_hsb = {
		saturation = 0.85,
		brightness = 0.75,
	},
	colors = theme.colors,
}
