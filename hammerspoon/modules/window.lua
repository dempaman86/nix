local M = {}
local previousFrames = {}

local function frameMatches(left, right)
  return math.abs(left.x - right.x) < 1
    and math.abs(left.y - right.y) < 1
    and math.abs(left.w - right.w) < 1
    and math.abs(left.h - right.h) < 1
end

local function withFocusedWindow(fn)
  return function()
    local window = hs.window.focusedWindow()

    if not window then
      hs.alert.show("Inget aktivt fonster")
      return
    end

    fn(window)
  end
end

local function resizeTo(window, frameFn)
  local screenFrame = window:screen():frame()
  local targetFrame = frameFn(screenFrame)

  window:setFrame(targetFrame, 0)
end

function M.leftHalf(window)
  resizeTo(window, function(screenFrame)
    return {
      x = screenFrame.x,
      y = screenFrame.y,
      w = screenFrame.w / 2,
      h = screenFrame.h,
    }
  end)
end

function M.rightHalf(window)
  resizeTo(window, function(screenFrame)
    return {
      x = screenFrame.x + (screenFrame.w / 2),
      y = screenFrame.y,
      w = screenFrame.w / 2,
      h = screenFrame.h,
    }
  end)
end

function M.topHalf(window)
  resizeTo(window, function(screenFrame)
    return {
      x = screenFrame.x,
      y = screenFrame.y,
      w = screenFrame.w,
      h = screenFrame.h / 2,
    }
  end)
end

function M.bottomHalf(window)
  resizeTo(window, function(screenFrame)
    return {
      x = screenFrame.x,
      y = screenFrame.y + (screenFrame.h / 2),
      w = screenFrame.w,
      h = screenFrame.h / 2,
    }
  end)
end

function M.maximize(window)
  local windowID = window:id()
  local currentFrame = window:frame()
  local maximizedFrame = window:screen():frame()
  local previousFrame = previousFrames[windowID]

  if previousFrame and frameMatches(currentFrame, maximizedFrame) then
    window:setFrame(previousFrame, 0)
    previousFrames[windowID] = nil
    return
  end

  previousFrames[windowID] = {
    x = currentFrame.x,
    y = currentFrame.y,
    w = currentFrame.w,
    h = currentFrame.h,
  }
  window:setFrame(maximizedFrame, 0)
end

function M.center(window)
  local screenFrame = window:screen():frame()
  local frame = window:frame()

  frame.w = math.min(frame.w, screenFrame.w)
  frame.h = math.min(frame.h, screenFrame.h)
  frame.x = screenFrame.x + ((screenFrame.w - frame.w) / 2)
  frame.y = screenFrame.y + ((screenFrame.h - frame.h) / 2)

  window:setFrame(frame, 0)
end

function M.moveToNextScreen(window)
  local nextScreen = window:screen():next()

  window:moveToScreen(nextScreen, false, true, 0)
end

function M.close(window)
  window:close()
end

function M.bind(settings)
  local bindings = settings.windowHotkeys or {}

  if bindings.close then
    hs.hotkey.bind(bindings.close.mods, bindings.close.key, withFocusedWindow(M.close))
  end

  if bindings.maximize then
    hs.hotkey.bind(bindings.maximize.mods, bindings.maximize.key, withFocusedWindow(M.maximize))
  end
end

return M
