local conf = dofile("config.lua");

wifi.setmode(conf.wifi.mode)
print('Client MAC: ',wifi.sta.getmac())
wifi.sta.config(conf.wifi.station)

wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(args)
    print("Connected to WiFi Access Point. Got IP: " .. args["IP"])
    --start server
    dofile("server.lua");
    wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(args)
        print("Lost connectivity! Restarting...")
        node.restart()
    end)
end)

