return function (args)
    local message = "";
    if args then
        for kv in args.gmatch(args, "%s*&?([^=]+=[^&]+)") do
            local pin, value = string.match(kv, "(.*)=(.*)");
            pin = tonumber(pin);
            value = tonumber(value);
            if pin >= 0 or pin < 12 then --Проверяем, что бы ключи были числа в нужных пределах
                gpio.mode(pin, gpio.OUTPUT)
                if value == 1 then
                    gpio.write(pin, gpio.HIGH)
                    message = message..pin..":on ";
                else
                    gpio.write(pin, gpio.LOW)
                    message = message..pin..":off ";
                end
            end;
            --print("Parsed: " .. key .. " => " .. value)
        end
    end
    return '{"status":"ok",  "message":"'..message..'"}';
end