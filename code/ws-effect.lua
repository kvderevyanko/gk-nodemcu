function wsEffOff(bufferWs)
    ws2812.init()
    local buffer = pixbuf.newBuffer(bufferWs, 3);
    buffer:fill(0, 0, 0);
    ws2812.write(buffer);
    buffer = nil;
    collectgarbage();
end

function blueDiode(blink, blueBright, blueMinBright, blueMaxBright, blueSpeed, blueStep)
    blueBright = blueBright * 4;
    blueBright = 1023 - blueBright;
    if blueBright < 0 then blueBright = 0; end;
    if blueBright > 1023 then blueBright = 1023; end;

    ws2812.init()
    local buffer = pixbuf.newBuffer(2000, 3);
    buffer:fill(0, 0, 0);
    ws2812.write(buffer);

    pwm.setup(4, 500, blueBright);
    pwm.start(4);

    if blink == 1 then
        if blueMinBright <  blueMaxBright then
            blueMinBright = 225 - blueMinBright;
            blueMaxBright = 225 - blueMaxBright;

            if blueMinBright < 0 then blueMinBright = 0 end;
            if blueMinBright > 225 then blueMinBright = 225 end;

            if blueMaxBright < 0 then blueMaxBright = 0 end;
            if blueMaxBright > 225 then blueMaxBright = 225 end;

            if blueSpeed < 5 then blueSpeed = 5 end;
            if blueSpeed > 1000 then blueSpeed = 1000 end;

            if blueStep < 1 then blueStep = 1 end;
            if blueStep > 20 then blueStep = 20 end;

            local nowDuty = blueMaxBright;
            local direction = 1;

            wsTimer:register(blueSpeed, tmr.ALARM_AUTO, function()
                if direction == 1 then
                    nowDuty = nowDuty - blueStep;
                    if nowDuty < 0 then nowDuty = 0; end;
                    pwm.setduty(4, (nowDuty * 4));

                    if nowDuty < blueMaxBright or nowDuty == blueMaxBright then
                        direction = 0;
                    end
                else
                    nowDuty = nowDuty + blueStep;
                    if nowDuty > 226 then nowDuty = 225; end;
                    pwm.setduty(4, (nowDuty * 4));

                    if nowDuty > blueMinBright or nowDuty == blueMinBright then
                        direction = 1;
                    end
                end;
            end);
            wsTimer:start();

        else
            pwm.setduty(4, blueMaxBright);
        end
    end

    buffer = nil;
    collectgarbage();
end

function wsEffStatic(bufferWs, color, bright)
    ws2812.init()
    local buffer = pixbuf.newBuffer(bufferWs, 3);
    buffer:fill(color[2], color[1], color[3]);
    buffer:mix(bright, buffer);
    ws2812.write(buffer);
    buffer = nil;
    collectgarbage();
end

function wsEffStaticSoftBlink(bufferWs, color, bright, delay, mode_options)
    ws2812.init();
    local g = color[2];
    local r = color[1];
    local b = color[3];

    local g_make = g;
    local r_make = r;
    local b_make = b;
    local incr = 0;
    if mode_options < 1 then
        mode_options = 1;
    end ;
    local buffer = pixbuf.newBuffer(bufferWs, 3);

    wsTimer:register(delay, tmr.ALARM_AUTO, function()
        if incr == 0 then
            g_make = g_make - mode_options;
            r_make = r_make - mode_options;
            b_make = b_make - mode_options;

            if g_make < 1 then
                g_make = 0;
            end ;
            if r_make < 1 then
                r_make = 0;
            end ;
            if b_make < 1 then
                b_make = 0;
            end ;

            if g_make == 0 and r_make == 0 and b_make == 0 then
                incr = 1;
            end ;
        end ;

        if incr == 1 then
            g_make = g_make + mode_options;
            r_make = r_make + mode_options;
            b_make = b_make + mode_options;

            if g_make > g then
                g_make = g;
            end ;
            if r_make > r then
                r_make = r;
            end ;
            if b_make > b then
                b_make = b;
            end ;

            if g_make == g and r_make == r and b_make == b then
                incr = 0;
            end ;
        end ;

        buffer:fill(g_make, r_make, b_make);
        buffer:mix(bright, buffer);
        ws2812.write(buffer);
    end);

    wsTimer:start();
    collectgarbage();
end

function wsEffStaticSoftRandomBlink(bufferWs, color, bright, delay, mode_options)
    ws2812.init();
    local g = color[2];
    local r = color[1];
    local b = color[3];

    local g_make = g;
    local r_make = r;
    local b_make = b;
    local incr = 0;
    local hide = 1;

    if mode_options < 1 then
        mode_options = 1;
    end ;
    local buffer = pixbuf.newBuffer(bufferWs, 3);
    wsTimer:register(delay, tmr.ALARM_AUTO, function()
        if incr == 0 then
            g_make = g_make - mode_options;
            r_make = r_make - mode_options;
            b_make = b_make - mode_options;

            if g_make < 1 then
                g_make = 0;
            end ;
            if r_make < 1 then
                r_make = 0;
            end ;
            if b_make < 1 then
                b_make = 0;
            end ;

            if g_make == 0 and r_make == 0 and b_make == 0 then
                incr = 1;

                g = math.random(0, 255);
                r = math.random(0, 255);
                b = math.random(0, 255);

                hide = math.random(1, 3);

                if hide == 1 then
                    g = 0;
                end ;
                if hide == 2 then
                    r = 0;
                end ;
                if hide == 3 then
                    b = 0;
                end ;
            end ;
        end ;

        if incr == 1 then
            g_make = g_make + mode_options;
            r_make = r_make + mode_options;
            b_make = b_make + mode_options;

            if g_make > g then
                g_make = g;
            end ;
            if r_make > r then
                r_make = r;
            end ;
            if b_make > b then
                b_make = b;
            end ;

            if g_make == g and r_make == r and b_make == b then
                incr = 0;
            end ;
        end ;

        buffer:fill(g_make, r_make, b_make);
        buffer:mix(bright, buffer);
        ws2812.write(buffer);
        collectgarbage();
    end);

    wsTimer:start();
    collectgarbage();
end

function wsEffRoundRandom(bufferWs, color, bright, delay, mode_options)
    ws2812.init();
    local buffer = pixbuf.newBuffer(bufferWs, 3);
    buffer:fill(0, 0, 0);
    ws2812.write(buffer);

    if mode_options < 1 then
        mode_options = 1;
    end ;
    if mode_options > 3 then
        mode_options = 3;
    end ;

    local i = 1;
    local hide = 1;
    local g = color[2];
    local r = color[1];
    local b = color[3];

    if delay < 10 then
        delay = 10;
    end ;

    wsTimer:register(delay, tmr.ALARM_AUTO, function()

        hide = math.random(1, 3);

        g = math.random(0, 200);
        r = math.random(0, 200);
        b = math.random(0, 200);

        if hide == 1 then
            g = 0;
        end ;
        if hide == 2 then
            r = 0;
        end ;
        if hide == 3 then
            b = 0;
        end ;

        buffer:set(i, g, r, b);
        buffer:fade(mode_options);
        buffer:mix(bright, buffer)
        ws2812.write(buffer);
        i = i + 1;
        if i > bufferWs then
            i = 1
        end ;
        collectgarbage();
    end);
    wsTimer:start();
    collectgarbage();
end

function wsEffRoundStatic(bufferWs, color, bright, delay, mode_options)
    ws2812.init();
    local buffer = pixbuf.newBuffer(bufferWs, 3);
    buffer:fill(0, 0, 0);
    ws2812.write(buffer);

    if mode_options < 1 then
        mode_options = 1;
    end ;
    if mode_options > 3 then
        mode_options = 3;
    end ;

    local i = 1;
    local g = color[2];
    local r = color[1];
    local b = color[3];
    wsTimer:register(delay, tmr.ALARM_AUTO, function()
        buffer:set(i, g, r, b);
        buffer:fade(mode_options);
        buffer:mix(bright, buffer)
        ws2812.write(buffer);
        i = i + 1;
        if i > bufferWs then
            i = 1
        end ;
        collectgarbage();
    end);
    wsTimer:start();
    collectgarbage();
end

function wsEffRainbow(bufferWs, color, bright, delay, mode_options)
    ws2812.init();
    local buffer = pixbuf.newBuffer(bufferWs, 3);

    local g = color[2];
    local r = color[1];
    local b = color[3];
    if delay < 10 then
        delay = 10;
    end ;

    wsTimer:register(delay, tmr.ALARM_AUTO, function()

        if b == 0 then
            r = r - mode_options;
            g = g + mode_options;
        elseif r == 0 then
            g = g - mode_options;
            b = b + mode_options;
        elseif g == 0 then
            b = b - mode_options;
            r = r + mode_options;
        end ;

        if g < 1 then
            g = 0;
        end ;
        if g > 255 then
            g = 255;
            b = 1;
            r = 0;
        end ;

        if b < 1 then
            b = 0;
        end ;
        if b > 255 then
            b = 255;
            r = 1;
            g = 0;
        end ;

        if r < 1 then
            r = 0;
        end ;
        if r > 255 then
            r = 255;
            b = 0;
            g = 1;
        end ;

        buffer:fill(g, r, b);
        buffer:mix(bright, buffer);

        ws2812.write(buffer);
        collectgarbage();
    end);

    wsTimer:start();
    collectgarbage();
end

function wsEffRainbowCircle(bufferWs, color, bright, delay, mode_options)
    ws2812.init();
    local buffer = pixbuf.newBuffer(bufferWs, 3);

    local g = color[2];
    local r = color[1];
    local b = color[3];

    local second_g = 0;
    local second_r = 0;
    local second_b = 0;
    if delay < 20 then
        delay = 20;
    end ;

    delay = delay * 3;
    --[[
    Для яркости находим коэфициент (яркость от 255) и на этот коэфициент делим реальную яркость
    ]]

    local catBright = 255/bright;

    --[[
    Меняем цвет по частям
    Считаем количество частей и меняем у каждой части по очереди
    ]]
    local wsRC = 0;
    local pointers = 5;
   -- delay = 500
    wsTimer:register(delay, tmr.ALARM_AUTO, function()
        local startP = 1;
        local endP = pointers;
        local path = 0;

        if bufferWs > pointers then
            path = bufferWs / pointers;
            if path > 1 then
                wsRC = wsRC + 1;

                startP = (wsRC - 1) * pointers + 1;
                endP = startP + pointers;

                if startP > bufferWs then
                    startP = bufferWs
                end ;
                if endP > bufferWs then
                    endP = bufferWs
                end ;

                if wsRC > path then
                    wsRC = 0;
                end

            else
                endP = bufferWs;
            end
        else
            endP = bufferWs;
        end
        --Заполняем буфер
        --for i = 1, bufferWs do
        for i = startP, endP do

            if b == 0 then
                r = r - mode_options;
                g = g + mode_options;
            elseif r == 0 then
                g = g - mode_options;
                b = b + mode_options;
            elseif g == 0 then
                b = b - mode_options;
                r = r + mode_options;
            end ;

            if g < 0 then
                g = 0;
            end ;
            if g > 255 then
                g = 255;
                b = 1;
                r = 0;
            end ;

            if b < 0 then
                b = 0;
            end ;
            if b > 255 then
                b = 255;
                r = 1;
                g = 0;
            end ;

            if r < 0 then
                r = 0;
            end ;
            if r > 255 then
                r = 255;
                g = 1;
                b = 0;
            end ;

            second_g = g;
            second_r = r;
            second_b = b;

            buffer:set(i, (g/catBright), (r/catBright), (b/catBright));
        end

      --  buffer:mix(bright, buffer);
        ws2812.write(buffer);
        g = second_g;
        r = second_r;
        b = second_b;

        path = nil;
        startP = nil;
        endP = nil;
        collectgarbage();
    end);

    wsTimer:start();
    collectgarbage();
end
