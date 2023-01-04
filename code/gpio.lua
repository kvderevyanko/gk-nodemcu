--Восстанавливаем настройки PWM после перезагрузки
function openGpioJson()
    if file.open("json/gpio-action.json") then
        local str = file.read();
        if str then
            local rd = sjson.decode(str)
            actionRequest(rd)
        end
        file.close()
        return true
    else
        return false
    end
end

--Функция для работы с PWM
function actionRequest(rd)
    for pin, value in pairs(rd) do
        pin = tonumber(pin);
        value = tonumber(value);
        if  pin ~= nil and pin >= 0 and pin < 10  then --Проверяем, что бы ключи были числа в нужных пределах
            gpio.mode(pin, gpio.OUTPUT)
            if value == 1 then
                gpio.write(pin, gpio.HIGH)
            else
                gpio.write(pin, gpio.LOW)
            end
        end;
    end

    local json = sjson.encode(rd)
    file.open("json/gpio-action.json-tmp", "w");
    file.write(json);
    file.flush();
    file.close();

    file.remove("json/gpio-action.json");
    file.flush();
    file.close();
    file.rename("json/gpio-action.json-tmp", "json/gpio-action.json");
    file.flush();
    file.close();
    file.remove("json/gpio-action.json-tmp");
    file.flush();
    file.close();

    json = nil;
    rd = nil
    collectgarbage()
    return '{"status":"ok", "message":"gpio ok"}'
end


return function(args)
    local tableVar = {};
    if args then
        for kv in args.gmatch(args, "%s*&?([^=]+=[^&]+)") do
            local name, value = string.match(kv, "(.*)=(.*)");
            tableVar[name] = value;
        end
    end
    actionRequest(tableVar);

    tableVar = nil;
    args = nil;
    collectgarbage();
    return '{"status":"ok",  "message":"11111"}';
end