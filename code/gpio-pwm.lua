return function (args)
    local message = "";
    if args then
        for kv in args.gmatch(args, "%s*&?([^=]+=[^&]+)") do
            local pin, value = string.match(kv, "(.*)=(.*)");
            pin = tonumber(pin);
            value = tonumber(value);
            if pin >= 1 or pin < 12 then --Проверяем, что бы пины были числа в нужных пределах
                -- Так же проверяем значения 0 < value < 1023
                if value < 0 then value = 0; end;
                if value > 1023 then value = 1023; end;
                message = message..pin.."=>"..value.." ";
                pwm.setup(pin, 500, value)
                pwm.start(pin)
            end;
            --print("Parsed: " .. key .. " => " .. value)
        end
    end
    return '{"status":"ok",  "message":"'..message..'"}';
end