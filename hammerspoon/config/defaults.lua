return {
  notifications = true,
  windowHotkeys = {
    close = {
      mods = { "cmd" },
      key = "q",
    },
    maximize = {
      mods = { "cmd" },
      key = "f",
    },
  },
  appHotkeys = {
    ["1"] = {
      name = "Firefox",
      bundleID = "org.mozilla.firefox",
      newWindowShortcut = {
        mods = { "cmd" },
        key = "n",
      },
    },
    ["2"] = {
      name = "Ghostty",
      bundleID = "com.mitchellh.ghostty",
      newWindowShortcut = {
        mods = { "cmd" },
        key = "n",
      },
    },
    ["3"] = {
      name = "Signal",
      bundleID = "org.whispersystems.signal-desktop",
    },
    ["4"] = {
      name = "Codex",
      bundleID = "com.openai.codex",
    },
  },
}
