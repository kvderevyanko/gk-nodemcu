
function wsEffOff(bufferWs)
    ws2812.init()
    local buffer = ws2812.newBuffer(bufferWs, 3);
    buffer:fill(0, 0, 0);
    ws2812.write(buffer);
    buffer = nil;
    collectgarbage();
end

function wsEffStatic(bufferWs, color, bright)
    ws2812.init()
    local buffer = ws2812.newBuffer(bufferWs, 3);
    buffer:fill(color[1], color[2], color[3]);
    buffer:mix(bright, buffer);
    ws2812.write(buffer);
    buffer = nil;
    collectgarbage();
end

function wsEffStaticSoftBlink(bufferWs, color, bright, delay, mode_options)
    ws2812.init();
    local g = color[1];
    local r = color[2];
    local b = color[3];

    local g_make = g;
    local r_make = r;
    local b_make = b;
    local incr = 0;
    if mode_options < 1 then mode_options = 1; end;
    local buffer = ws2812.newBuffer(bufferWs, 3);

    wsTimer:register(delay, tmr.ALARM_AUTO, function()
        if incr == 0 then
            g_make = g_make - mode_options;
            r_make = r_make - mode_options;
            b_make = b_make - mode_options;

            if g_make < 1 then g_make = 0; end;
            if r_make < 1 then r_make = 0; end;
            if b_make < 1 then b_make = 0; end;

            if g_make == 0 and r_make == 0 and b_make == 0 then
                incr = 1;
            end;
        end;


        if incr == 1 then
            g_make = g_make + mode_options;
            r_make = r_make + mode_options;
            b_make = b_make + mode_options;

            if g_make > g then g_make = g; end;
            if r_make > r then r_make = r; end;
            if b_make > b then b_make = b; end;

            if g_make == g and r_make == r and b_make == b then
                incr = 0;
            end;
        end;

        buffer:fill(g_make,r_make,b_make);
        buffer:mix(bright, buffer);
        ws2812.write(buffer);
    end);

    wsTimer:start();
    collectgarbage();
end

function wsEffStaticSoftRandomBlink(bufferWs, color, bright, delay, mode_options)
    ws2812.init();
    local g = color[1];
    local r = color[2];
    local b = color[3];

    local g_make = g;
    local r_make = r;
    local b_make = b;
    local incr = 0;
    local hide = 1;

    if mode_options < 1 then mode_options = 1; end;
    local buffer = ws2812.newBuffer(bufferWs, 3);
    wsTimer:register(delay, tmr.ALARM_AUTO, function()
        if incr == 0 then
            g_make = g_make - mode_options;
            r_make = r_make - mode_options;
            b_make = b_make - mode_options;

            if g_make < 1 then g_make = 0; end;
            if r_make < 1 then r_make = 0; end;
            if b_make < 1 then b_make = 0; end;

            if g_make == 0 and r_make == 0 and b_make == 0 then
                incr = 1;

                g = math.random(0, 255);
                r = math.random(0, 255);
                b = math.random(0, 255);

                hide =  math.random(1, 3);

                if hide == 1 then g = 0; end;
                if hide == 2 then r = 0; end;
                if hide == 3 then b = 0; end;
            end;
        end;


        if incr == 1 then
            g_make = g_make + mode_options;
            r_make = r_make + mode_options;
            b_make = b_make + mode_options;

            if g_make > g then g_make = g; end;
            if r_make > r then r_make = r; end;
            if b_make > b then b_make = b; end;

            if g_make == g and r_make == r and b_make == b then
                incr = 0;
            end;
        end;

        buffer:fill(g_make,r_make,b_make);
        buffer:mix(bright, buffer);
        ws2812.write(buffer);
        collectgarbage();
    end);

    wsTimer:start();
    collectgarbage();
end


function wsEffRoundRandom(bufferWs, color, bright, delay, mode_options)
    ws2812.init();
    local buffer = ws2812.newBuffer(bufferWs, 3);
    buffer:fill(0,0, 0);
    ws2812.write(buffer);

    if mode_options < 1 then mode_options = 1; end;
    if mode_options > 3 then mode_options = 3; end;

    local i = 1;
    local hide = 1;
    local g = color[1];
    local r = color[2];
    local b = color[3];

    if delay < 10 then delay = 10; end;

    wsTimer:register(delay, tmr.ALARM_AUTO, function()

        hide =  math.random(1, 3);

        g = math.random(0, 200);
        r = math.random(0, 200);
        b = math.random(0, 200);

        if hide == 1 then g = 0; end;
        if hide == 2 then r = 0; end;
        if hide == 3 then b = 0; end;

        buffer:set(i, g,r, b);
        buffer:fade(mode_options);
        buffer:mix(bright, buffer)
        ws2812.write(buffer);
        i = i+1;
        if i > bufferWs then i = 1 end;
        collectgarbage();
    end);
    wsTimer:start();
    collectgarbage();
end


function wsEffRoundStatic(bufferWs, color, bright, delay, mode_options)
    ws2812.init();
    local buffer = ws2812.newBuffer(bufferWs, 3);
    buffer:fill(0,0, 0);
    ws2812.write(buffer);

    if mode_options < 1 then mode_options = 1; end;
    if mode_options > 3 then mode_options = 3; end;

    local i = 1;
    local g = color[1];
    local r = color[2];
    local b = color[3];
    wsTimer:register(delay, tmr.ALARM_AUTO, function()
        buffer:set(i, g,r, b);
        buffer:fade(mode_options);
        buffer:mix(bright, buffer)
        ws2812.write(buffer);
        i = i+1;
        if i > bufferWs then i = 1 end;
        collectgarbage();
    end);
    wsTimer:start();
    collectgarbage();
end



function wsEffRainbow(bufferWs, color, bright, delay, mode_options)
    ws2812.init();
    local buffer = ws2812.newBuffer(bufferWs, 3);

    local g = color[1];
    local r = color[2];
    local b = color[3];
    if delay < 10 then delay = 10; end;

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
        end;

        if g < 1 then g = 0; end;
        if g > 255 then g = 255; b = 1; r = 0; end;

        if b < 1 then b = 0; end;
        if b > 255 then b = 255; r = 1; g = 0; end;

        if r < 1 then r = 0; end;
        if r > 255 then r = 255; b = 0; g = 1; end;

        buffer:fill(g,r,b);
        buffer:mix(bright, buffer);

        ws2812.write(buffer);
        collectgarbage();
    end);

    wsTimer:start();
    collectgarbage();
end



function wsEffRainbowCircle(bufferWs, color, bright, delay, mode_options)
    ws2812.init();
    local buffer = ws2812.newBuffer(bufferWs, 3);

    local g = color[1];
    local r = color[2];
    local b = color[3];

    local second_g = 0;
    local second_r = 0;
    local second_b = 0;
    if delay < 10 then delay = 10; end;

    wsTimer:register(delay, tmr.ALARM_AUTO, function()
        for i = 1, bufferWs do

            if b == 0 then
                r = r - mode_options;
                g = g + mode_options;
            elseif r == 0 then
                g = g - mode_options;
                b = b + mode_options;
            elseif g == 0 then
                b = b - mode_options;
                r = r + mode_options;
            end;

            --get second pin value
            if i == 2 then
                second_g = g;
                second_r = r;
                second_b = b;
            end;

            if g < 0 then g = 0; end;
            if g > 255 then g = 255; b = 1; r = 0; end;

            if b < 0 then b = 0; end;
            if b > 255 then b = 255; r = 1; g = 0; end;

            if r < 0 then r = 0; end;
            if r > 255 then r = 255; g = 1; b = 0; end;

            buffer:set(i,g,r,b);
        end

        buffer:mix(bright, buffer);
        ws2812.write(buffer);
        g = second_g;
        r = second_r;
        b = second_b;
        collectgarbage();
    end);

    wsTimer:start();
    collectgarbage();
end
