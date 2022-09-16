
local mytimer = tmr.create()
mytimer:register(2000, tmr.ALARM_SINGLE, function (t) 
    dofile("gpio.lua");
    t:unregister();
end)
mytimer:start()
