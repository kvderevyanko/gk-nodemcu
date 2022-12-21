return function (args)
    local message = "";
    if args then
        for kv in args.gmatch(args, "%s*&?([^=]+=[^&]+)") do
            local name, value = string.match(kv, "(.*)=(.*)");

            if name == "type" then print("value")
                if value == "ws2812" then
                    if file.open("json/ws-action.json") then
                        message = file.readline();
                        message = message:gsub('"', '\\"');
                      file.close();
                    else

                    end
                end;

            end;

            --print("Parsed: " .. key .. " => " .. value)
        end
    end
   -- print(message)
    return '{"status":"ok",  "message":"'..message..'"}';
end