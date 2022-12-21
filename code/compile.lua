-- httpserver-compile.lua
-- Part of nodemcu-httpserver, compiles server code after upload.
-- Author: Marcos Kirsch

local compileAndRemoveIfNeeded = function(f)
   if file.exists(f) then
      local newf = f:gsub("%w+/", "")
      file.rename(f, newf)
      print('Compiling:', newf)
      node.compile(newf)
      file.remove(newf)
      collectgarbage()
   end
end

local serverFiles = {
   'ws.lua',
   'ws-effect.lua',
   'request.lua',
   'server.lua',
   'wi-fi.lua',
   'restart.lua',
   'gpio-pwm.lua',
   'gpio.lua',
   'config.lua',
   'json.lua',
}

for i, f in ipairs(serverFiles) do compileAndRemoveIfNeeded(f) end


compileAndRemoveIfNeeded = nil
serverFiles = nil

collectgarbage()
