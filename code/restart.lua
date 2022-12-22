
dofile("ws.lc");
openWsJson();

dofile("gpio-pwm.lc");
openPwmJson();

dofile("gpio.lc");
openGpioJson();

collectgarbage();