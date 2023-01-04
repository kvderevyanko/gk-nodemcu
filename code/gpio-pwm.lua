--Восстанавливаем настройки PWM после перезагрузки
function openPwmJson()
    if file.open("json/pwm-action.json") then
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
    local clock =  tonumber(rd['clock']);
    if clock < 1 or clock > 1000 then clock = 500 end;
    for pin, value in pairs(rd) do
        --Если значения не те, что ниже
        if pin ~= nil and pin ~= 'clock' then
            pin = tonumber(pin)
            value = tonumber(value)
            if value < 0 then value = 0 end;

            if  pin ~= nil and pin >= 0 and pin < 10  then
                pwm.setup(pin, clock, value);
                pwm.start(pin);
           end
        end
    end

    local json = sjson.encode(rd)
    file.open("json/pwm-action.json-tmp", "w");
    file.write(json);
    file.flush();
    file.close();

    file.remove("json/pwm-action.json");
    file.flush();
    file.close();
    file.rename("json/pwm-action.json-tmp", "json/pwm-action.json");
    file.flush();
    file.close();
    file.remove("json/pwm-action.json-tmp");
    file.flush();
    file.close();

    json = nil;
    rd = nil
    clock = nil
    collectgarbage()
    return '{"status":"ok", "message":"pwm ok"}'
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