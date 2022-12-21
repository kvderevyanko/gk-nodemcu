local conf = dofile("config.lc");

srv = net.createServer(net.TCP)
srv:listen(conf.general.port, function(conn)
    conn:on("receive", function(client, request)
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if (method == nil) then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        if vars then
            print(vars);
        end

      if path then
            print(path);
        end

        local req;
        if vars then
            req = dofile("request.lc")(path .. '?' .. vars);
        else
            req = dofile("request.lc")(path);
        end

        local answer = "";

        local f = req['file'];

        if f == "" or f == "/" then f = "index.html"; end;

        if f and file.exists(f) then

            if string.sub(f, -3) == ".lc" then
                --answer = '{"status":"ok",  "message":"File "}';
                local r;
                if vars then
                    answer = dofile(f)(vars);
                else
                    answer = dofile(f)(nil);
                end
                print("answer");
                print(answer);
                if answer == "" then answer = '{"status":"ok",  "message":"Not answer"}'; end;

                client:send("HTTP/1.0 200 OK\r\nContent-Type: application/json\r\n\r\n" .. answer);
            elseif string.sub(f, -5) == ".json" then
                client:send("HTTP/1.0 200 OK\r\nContent-Type: application/json\r\n\r\n");
                if file.open(f) then
                    client:send(file.read());
                    file.close()
                end
            else
              --  client:send("HTTP/1.0 200 OK\r\nContent-Type: text/html \r\n\r\n")
                --Получаем длину файла, считаем количество отрезков по 1000 байт и отдаём честями
                local stat = file.stat(f);
                --Считаем количество отрезков по 800 байт
                local statSize = (stat.size / 1000 + 1);

                local bigFile = "";

                --Задаём ограничения
                if stat.size < 1000 then statSize = 1; end;
                if statSize > 5 then statSize = 5; bigFile = "----Big File----"; end;

                if statSize == 1 then
                    --Если размер файла меньше 1000 байт, возвращаем как есть
                    if file.open(f) then
                        client:send(file.read());
                        file.close()
                    end
                else
                    --выплёвываем по 1000 байт
                    for i = 1, statSize, 1 do
                        if file.open(f) then
                            file.seek("set", ((i - 1) * 1000))
                            local textFile = file.read(1000);
                            file.close();
                            client:send(textFile);
                            textFile = nil;
                            collectgarbage();
                        end
                    end
                end

                if bigFile ~= "" then client:send(bigFile); end;

                bigFile = nil;
                statSize = nil;
                collectgarbage();
            end
        else
            answer = '{"status":"error",  "message":"not found file"}';
            client:send("HTTP/1.0 200 OK\r\nContent-Type: application/json\r\n\r\n" .. answer)
        end
        answer = nil
        req = nil
        f = nil
        method = nil
        path = nil
        vars = nil
        collectgarbage();
    end)
    conn:on("sent", function(sck)
        sck:close()
    end)
    collectgarbage();
end)

