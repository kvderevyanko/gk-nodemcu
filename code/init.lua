
local mytimer = tmr.create()
mytimer:register(2000, tmr.ALARM_SINGLE, function (t)
    dofile("wi-fi.lua");
    t:unregister();
end)
mytimer:start()
