pin1 = 1;
pin2 = 2;
pin5 = 5;
pin6 = 6;

clock = 200;

local function pwmLeftStop() 
    pwm.stop(pin1)
    pwm.stop(pin2)
end;

local function pwmRightStop() 
    pwm.stop(pin5)
    pwm.stop(pin6)
end;

local function rightForward(speed) 
    pwmRightStop() 
    
    gpio.mode(pin5, gpio.OUTPUT)
    gpio.write(pin5, gpio.LOW)
    pwm.setup(pin6, clock, speed)
    pwm.start(pin6)
end;


local function rightBack(speed) 
    pwmRightStop() 
    
    gpio.mode(pin6, gpio.OUTPUT)
    gpio.write(pin6, gpio.LOW)
    
    pwm.setup(pin5, clock, speed)
    pwm.start(pin5)
end;

local function rightStop() 
    pwmRightStop() 
    
    gpio.mode(pin5, gpio.OUTPUT)
    gpio.write(pin5, gpio.LOW)
    gpio.mode(pin6, gpio.OUTPUT)
    gpio.write(pin6, gpio.LOW)
end;


local function leftForward(speed) 
    pwmLeftStop() 
    
    gpio.mode(pin2, gpio.OUTPUT)
    gpio.write(pin2, gpio.LOW)
    pwm.setup(pin1, clock, speed)
    pwm.start(pin1)
end;


local function leftBack(speed) 
    pwmLeftStop() 
    gpio.mode(pin1, gpio.OUTPUT)
    gpio.write(pin1, gpio.LOW)
    
    pwm.setup(pin2, clock, speed)
    pwm.start(pin2)
end;

local function leftStop() 
    pwmLeftStop() 
    
    gpio.mode(pin2, gpio.OUTPUT)
    gpio.write(pin2, gpio.LOW)
    gpio.mode(pin1, gpio.OUTPUT)
    gpio.write(pin1, gpio.LOW)
end;

rightStop() 
leftStop()

--rightForward(800) 
--leftForward(800) 
--rightBack(700) 

--rightBack(800) 
--leftBack(800)
-- leftStop()