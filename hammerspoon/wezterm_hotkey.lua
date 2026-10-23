local terminal = {}
local bundleID = "com.github.wez.wezterm"
local pendingShow
local cancelPendingShow, show, focusWindow

function terminal.toggle()
    if pendingShow then
        return
    end
    local app = hs.application.get(bundleID)
    if app and app:isFrontmost() and not app:isHidden() then
        app:hide()
        return
    end
    show()
end

function cancelPendingShow()
    if pendingShow then
        pendingShow:stop()
        pendingShow = nil
    end
end

function show()
    if not hs.application.launchOrFocusByBundleID(bundleID) then
        hs.alert.show("无法启动 WezTerm")
        return
    end
    if focusWindow() then
        return
    end

    local deadline = hs.timer.secondsSinceEpoch() + 10
    pendingShow = hs.timer.doEvery(0.1, function()
        if focusWindow() then
            cancelPendingShow()
        elseif hs.timer.secondsSinceEpoch() >= deadline then
            cancelPendingShow()
            hs.alert.show("未找到 WezTerm 窗口，请检查辅助功能权限或手动新建窗口")
        end
    end)
end

function focusWindow()
    local app = hs.application.get(bundleID)
    local window = app and (app:focusedWindow() or app:mainWindow())
    if not window then
        return false
    end
    app:unhide()
    window:unminimize()
    window:maximize()
    window:focus()
    return true
end

return terminal
