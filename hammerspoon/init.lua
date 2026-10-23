local terminal = require("wezterm_hotkey")

hs.autoLaunch(true)
hs.hotkey.bind({ "alt" }, "u", terminal.toggle)

if not hs.accessibilityState() then
    hs.alert.show("请在系统设置 → 隐私与安全性 → 辅助功能中允许 Hammerspoon")
end
