hs.window.animationDuration = 0

local settings = require("modules.settings")

_G.configWatcher = require("modules.reloader").start(hs.configdir)
require("modules.window").bind(settings)
require("modules.apps").bind(settings)

if settings.notifications then
  hs.alert.show("Hammerspoon laddad")
end
