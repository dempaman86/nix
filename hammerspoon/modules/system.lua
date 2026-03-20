local M = {}

local function showStatus(message)
  hs.alert.closeAll()
  hs.alert.show(message)
end

local function toggleCaffeine()
  local enabled = hs.caffeinate.get("displayIdle")

  hs.caffeinate.set("displayIdle", not enabled, true)
  showStatus(enabled and "Caffeine av" or "Caffeine pa")
end

function M.bind(settings)
  local hotkey = settings.hotkey

  hs.hotkey.bind(hotkey, "r", hs.reload)
  hs.hotkey.bind(hotkey, "0", toggleCaffeine)
  hs.hotkey.bind(hotkey, "l", hs.caffeinate.lockScreen)
end

return M
