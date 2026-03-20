local defaults = require("config.defaults")

local function deepMerge(base, overrides)
  for key, value in pairs(overrides) do
    if type(value) == "table" and type(base[key]) == "table" then
      deepMerge(base[key], value)
    else
      base[key] = value
    end
  end

  return base
end

local function clone(value)
  if type(value) ~= "table" then
    return value
  end

  local copy = {}

  for key, nestedValue in pairs(value) do
    copy[key] = clone(nestedValue)
  end

  return copy
end

local settings = clone(defaults)
local hasLocalConfig, localConfig = pcall(require, "config.local")

if hasLocalConfig and type(localConfig) == "table" then
  deepMerge(settings, localConfig)
end

return settings
