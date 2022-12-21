dofile("compile.lua");
local startTimer = tmr.create()
startTimer:register(1000, tmr.ALARM_SINGLE, function (t)
    _G.cjson = sjson;
    dofile("restart.lc");
    dofile("wi-fi.lc");
    t:unregister();
end)
startTimer:start()
