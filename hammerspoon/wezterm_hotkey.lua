local terminal = {}
local bundleID = "com.github.wez.wezterm"
local pendingShow
local cancelPendingShow, currentScreen, moveToScreen, show, focusWindow

function terminal.toggle()
    if pendingShow then
        return
    end
    local app = hs.application.get(bundleID)
    if app and app:isFrontmost() and not app:isHidden() then
        app:hide()
        return
    end
    show(currentScreen())
end

function cancelPendingShow()
    if pendingShow then
        pendingShow:stop()
        pendingShow = nil
    end
end

-- 必须在焦点切到 WezTerm 之前调用，否则拿到的会是 WezTerm 自己所在的屏幕
function currentScreen()
    local focused = hs.window.focusedWindow()
    local screen = focused and focused:screen()
    return screen or hs.mouse.getCurrentScreen() or hs.screen.mainScreen()
end

-- moveToScreen 的第四个参数在 Hammerspoon 1.1.1 中是动画时长，显式传 0 才能瞬时完成
function moveToScreen(window, screen)
    if screen and window:screen() ~= screen then
        window:moveToScreen(screen, 0)
    end
end

function show(screen)
    if not hs.application.launchOrFocusByBundleID(bundleID) then
        hs.alert.show("无法启动 WezTerm")
        return
    end
    if focusWindow(screen) then
        return
    end

    local deadline = hs.timer.secondsSinceEpoch() + 10
    pendingShow = hs.timer.doEvery(0.1, function()
        if focusWindow(screen) then
            cancelPendingShow()
        elseif hs.timer.secondsSinceEpoch() >= deadline then
            cancelPendingShow()
            hs.alert.show("未找到 WezTerm 窗口，请检查辅助功能权限或手动新建窗口")
        end
    end)
end

function focusWindow(screen)
    local app = hs.application.get(bundleID)
    local window = app and (app:focusedWindow() or app:mainWindow())
    if not window then
        return false
    end
    app:unhide()
    window:unminimize()
    moveToScreen(window, screen)
    window:maximize(0)
    window:focus()
    return true
end

return terminal