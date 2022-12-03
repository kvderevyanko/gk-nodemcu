--Восстанавливаем настройки WS после перезагрузки и инициализирует таймер ws
function openWsJson()
    _G.wsTimer = tmr.create();
    if file.open("json/ws-action.json") then
        local rd = sjson.decode(file.read())
        actionRequest(rd)
        file.close()
        return true
    else
        return false
    end
end

local function hex_to_char(x)
    return string.char(tonumber(x, 16))
end

function uri_decode(input)
    print(input)
    return input:gsub("%+", " "):gsub("%%(%x%x)", hex_to_char)
end

-- Основная функция для работы с ws 2812
function actionRequest(rd)
    print(node.heap());
    local wsEffect = dofile("ws-effect.lc");
    wsTimer:stop();
    print(node.heap());
    if rd['buffer'] == nil then return end

        local buffer = tonumber(rd['buffer'])

        local delay = 100;
        local bright = 100;
        local single_color = {0, 0, 0};
        local mode_options = 1;

        for name, value in pairs(rd) do
            if name == "delay" and tonumber(value) then
                delay = tonumber(value);
            end

            if name == "bright" and tonumber(value) then
                bright = tonumber(value);
            end

            if name == "single_color" and value then
                value = uri_decode(value);
                single_color = sjson.decode(value);
            end

            if name == "mode_options" and value then
                mode_options = tonumber(value);
            end
        end

        local mode = tostring(rd['mode']);

        if mode == "off"  then
            wsEffOff(buffer);
        elseif mode == "static" then
            wsEffStatic(buffer, single_color, bright);
        elseif mode == "static-soft-blink" then
            wsEffStaticSoftBlink(buffer, single_color, bright, delay, mode_options);
        elseif mode == "static-soft-random-blink" then
            wsEffStaticSoftRandomBlink(buffer, single_color, bright, delay, mode_options);
        elseif mode == "round-random" then
           wsEffRoundRandom(buffer, single_color, bright, delay, mode_options);
        elseif mode == "round-static" then
            wsEffRoundStatic(buffer, single_color, bright, delay, mode_options);
        elseif mode == "rainbow" then
            wsEffRainbow(buffer, single_color, bright, delay, mode_options);
        elseif mode == "rainbow-circle" then
            wsEffRainbowCircle(buffer, single_color, bright, delay, mode_options);
        elseif mode == "scanner" then
            wsScanner(buffer, single_color, bright, delay, mode_options);
        end;

        local json = sjson.encode(rd)
        file.open("json/ws-action.json", "w");
        file.write(json)
        file.flush()
        file.close()

    mode = nil;
    rd = nil;
    buffer = nil;
    json = nil;
    delay = nil;
    bright = nil;
    single_color = nil;
    mode_options = nil;
    wsEffect = nil;

    collectgarbage()
    return true;
end


return function (args)
    collectgarbage();
    local message = "";
    local tableVar = {};
    if args then
        for kv in args.gmatch(args, "%s*&?([^=]+=[^&]+)") do
            local a, b = string.match(kv, "(.*)=(.*)");
            tableVar[a] = b;
            --print(a)
            --print(b)
            --[[local pin, value = string.match(kv, "(.*)=(.*)");
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
            end;]]
            --print("Parsed: " .. key .. " => " .. value)
        end
    end
    actionRequest(tableVar);

    tableVar = nil;
    args = nil;
    collectgarbage();
    print("========");
    print(node.heap());
    return '{"status":"ok",  "message":"11111"}';
end