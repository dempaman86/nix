local M = {}

function M.start(configDir)
  return hs.pathwatcher.new(configDir, function(files)
    for _, file in ipairs(files) do
      if file:sub(-4) == ".lua" then
        hs.reload()
        return
      end
    end
  end):start()
end

return M
