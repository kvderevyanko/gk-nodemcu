local conf = dofile("config.lc");

wifi.setmode(conf.wifi.mode)

if (conf.wifi.mode == wifi.SOFTAP) or (conf.wifi.mode == wifi.STATIONAP) then
    print('AP MAC: ', wifi.ap.getmac())
    wifi.ap.config(conf.wifi.accessPoint.config)
    wifi.ap.setip(conf.wifi.accessPoint.net)
end

if (conf.wifi.mode == wifi.STATION) or (conf.wifi.mode == wifi.STATIONAP) then
    print('Client MAC: ', wifi.sta.getmac())
    wifi.sta.config(conf.wifi.station)
end



if (wifi.getmode() == wifi.STATION) or (wifi.getmode() == wifi.STATIONAP) then

    wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(args)
        print("Connected to WiFi Access Point. Got IP: " .. args["IP"])
        --start server
        dofile("server.lc");
        wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(args)
            print("Lost connectivity! Restarting...")
            node.restart()
        end)
    end)

    -- What if after a while (30 seconds) we didn't connect? Restart and keep trying.
    local watchdogTimer = tmr.create()
    watchdogTimer:register(30000, tmr.ALARM_SINGLE, function (watchdogTimer)
        local ip = wifi.sta.getip()
        if (not ip) then ip = wifi.ap.getip() end
        if ip == nil then
            print("No IP after a while. Restarting...")
            node.restart()
        else
            --print("Successfully got IP. Good, no need to restart.")
            watchdogTimer:unregister()
        end
    end)
    watchdogTimer:start()
else
    print("Server created")
    print("ssid: "..conf.wifi.accessPoint.config.ssid)
    print("Password: "..conf.wifi.accessPoint.config.pwd)
    print("IP: "..conf.wifi.accessPoint.net.ip)
    dofile("server.lc");
end

conf = nil
collectgarbage()