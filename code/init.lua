
local startTimer = tmr.create()
startTimer:register(2000, tmr.ALARM_SINGLE, function (t)
    dofile("wi-fi.lua");
    t:unregister();
end)
startTimer:start()
