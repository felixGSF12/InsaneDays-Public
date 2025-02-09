
local inkMax = 3
local enabled = false
function onCreate()
    precacheImage('bendy/third/Ink_Shit')
    precacheImage('bendy/third/InkRain')
    for inkShit = 1,inkMax do
        makeLuaSprite('InkedShit'..inkShit,'BackGrounds/W9/images/third/Ink_Shit',1000 - (760 * (inkShit - 1)),0)
        setObjectCamera('InkedShit'..inkShit,'hud')
        setProperty('InkedShit'..inkShit..'.alpha',0.001)
    end
    makeAnimatedLuaSprite('InkedRain','BackGrounds/W9/images/third/InkRain',0,0)
    addAnimationByPrefix('InkedRain','Rain','erteyd instance 1',24,true)
    setObjectCamera('InkedRain','hud')
    setProperty('InkedRain.alpha',0.001)
    addLuaSprite('InkedRain',false)
end
function onUpdate(el)
    if enabled then
        setProperty('InkedShit1.x',getProperty('InkedShit1.x') + (el*100))
        for inkShit = 2,inkMax do
            setProperty('InkedShit'..inkShit..'.x',getProperty('InkedShit1.x') - (762 * (inkShit - 1)))
        end
        if getProperty('InkedShit3.x') >= 0 then
            setProperty('InkedShit1.x',getProperty('InkedShit2.x'))
        end
    end
end
function active(enable)
    if enable then
        for inkShit = 1,inkMax do
            addLuaSprite('InkedShit'..inkShit,false)
            doTweenAlpha('heyInk'..inkShit,'InkedShit'..inkShit,0.6,1,'linear')
        end
        addLuaSprite('Inked-Rain', true)
        doTweenAlpha('heyInkRain','InkedRain',1,1,'linear')
    else
        for inkShit = 1,inkMax do
            doTweenAlpha('byeInk'..inkShit,'InkedShit'..inkShit,0,1,'linear')
        end
        doTweenAlpha('byeInkRain','InkedRain',0,1,'linear')
    end
    enabled = enable == true
end