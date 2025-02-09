local SplashDamage = 0
function onCreate()
    for splashs = 1,4 do
        precacheImage('bendy/Damage0'..splashs)
    end
end

function addInk()
    SplashDamage = SplashDamage + 1
    if SplashDamage >= 5 then
        setHealth(-1)
        return
    end
    playSound('bendy/inked')
    cancelTween('inkSplashDisappears')
    cancelTimer('InkScreenDestroy')
    makeLuaSprite('inkScreen','bendy/Damage0'..SplashDamage,0,0)
    scaleObject('inkScreen',0.7,0.7)
    setObjectCamera('inkScreen','hud')
    addLuaSprite('inkScreen',true)
    runTimer('InkScreenDestroy',3)
end

function onTweenCompleted(tag)
	if tag == 'inkSplashDisappears' then
		removeLuaSprite('inkScreen',true)
		SplashDamage = 0
	end
end


function onTimerCompleted(tag)
	if tag == 'InkScreenDestroy' then
		doTweenAlpha('inkSplashDisappears','inkScreen',0,2,'sineIn')
	end
end