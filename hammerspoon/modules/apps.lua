local M = {}

local function appIdentifier(appConfig)
  return appConfig.bundleID or appConfig.path or appConfig.name
end

local function runningApp(appConfig)
  if appConfig.bundleID then
    local apps = hs.application.applicationsForBundleID(appConfig.bundleID)

    if apps and #apps > 0 then
      return apps[1]
    end
  end

  return hs.appfinder.appFromName(appConfig.name)
end

local function launchApp(appConfig)
  return hs.application.open(appIdentifier(appConfig), 3, true)
end

local function requestReopen(appConfig, app)
  if app then
    app:unhide()
    app:activate()
  end

  local target = appConfig.bundleID and ('id "%s"'):format(appConfig.bundleID) or ('"%s"'):format(appConfig.name)

  return hs.osascript.applescript(([[
    tell application %s
      reopen
      activate
    end tell
  ]]):format(target))
end

local function focusWindow(window)
  if window:isMinimized() then
    window:unminimize()
  end

  local app = window:application()

  if app then
    app:activate()
  end

  window:focus()
end

local function sortedWindows(app)
  local windows = {}

  for _, window in ipairs(app:allWindows()) do
    if window:isStandard() then
      table.insert(windows, window)
    end
  end

  table.sort(windows, function(left, right)
    return left:id() < right:id()
  end)

  return windows
end

local function waitForWindows(appConfig, retries, delayMicros)
  for _ = 1, retries do
    local app = runningApp(appConfig)

    if app then
      local windows = sortedWindows(app)

      if #windows > 0 then
        return app, windows
      end
    end

    hs.timer.usleep(delayMicros)
  end

  local app = runningApp(appConfig)

  if not app then
    return nil, {}
  end

  return app, sortedWindows(app)
end

local function triggerNewWindow(appConfig, app)
  local shortcut = appConfig.newWindowShortcut

  if not shortcut or not app then
    return false
  end

  app:activate()
  hs.timer.usleep(200000)
  hs.eventtap.keyStroke(shortcut.mods, shortcut.key, 200000, app)
  return true
end

local function cycleAppWindows(app, appConfig)
  local windows = sortedWindows(app)

  if #windows == 0 then
    requestReopen(appConfig, app)
    app, windows = waitForWindows(appConfig, 10, 100000)

    if #windows == 0 then
      triggerNewWindow(appConfig, app)
      app, windows = waitForWindows(appConfig, 10, 100000)
    end

    if #windows == 0 then
      hs.alert.show(("Kunde inte oppna fonster for %s"):format(appConfig.name))
      return false
    end
  end

  local focusedWindow = hs.window.focusedWindow()
  local targetWindow = windows[1]

  if focusedWindow then
    local focusedApp = focusedWindow:application()

    if focusedApp and focusedApp:pid() == app:pid() then
      for index, window in ipairs(windows) do
        if window:id() == focusedWindow:id() then
          targetWindow = windows[(index % #windows) + 1]
          break
        end
      end
    else
      local appFocusedWindow = app:focusedWindow() or app:mainWindow()

      if appFocusedWindow then
        targetWindow = appFocusedWindow
      end
    end
  else
    local appFocusedWindow = app:focusedWindow() or app:mainWindow()

    if appFocusedWindow then
      targetWindow = appFocusedWindow
    end
  end

  focusWindow(targetWindow)
  return true
end

local function launchOrCycle(appConfig)
  local app = runningApp(appConfig)

  if app then
    return cycleAppWindows(app, appConfig)
  end

  local launched = launchApp(appConfig)

  if not launched then
    hs.alert.show(("Kunde inte oppna %s"):format(appConfig.name))
    return false
  end

  return cycleAppWindows(launched, appConfig)
end

function M.bind(settings)
  for key, appConfig in pairs(settings.appHotkeys or {}) do
    hs.hotkey.bind({ "cmd" }, key, nil, function()
      launchOrCycle(appConfig)
    end)
  end
end

return M
