pin=4
gpio.mode(pin, gpio.OUTPUT)
gpio.write(pin, gpio.LOW)
print('Diod ON')

local mytimer = tmr.create()
mytimer:register(2000, tmr.ALARM_SINGLE, function (t) 
    print('Diod OFF')
    gpio.write(pin, gpio.HIGH)
    t:unregister();
end)
mytimer:start()


