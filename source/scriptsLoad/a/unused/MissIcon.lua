function onCreatePost()	
	doTweenY('scoreY', 'scoreTxt', 689 , 0.63, 'backOut')
end
function onBeatHit()

		makeLuaSprite('winIcoP1', 'icons/lossIcons/loss-'..getProperty('iconP1.animation.curAnim.name'), getProperty('iconP1.x'), getProperty('iconP1.y'))
		setObjectCamera('winIcoP1', 'hud')
		addLuaSprite('winIcoP1', true)
		setObjectOrder('winIcoP1', getObjectOrder('iconP1') + 1)
		setProperty('winIcoP1.flipX', true)
		setProperty('winIcoP1.visible', false)
				
		setProperty('winIcoP1.alpha', getProperty('iconP1.alpha'))		
		setProperty('winIcoP1.angle',getProperty('iconP1.angle',turnvalue))	

			setProperty('iconP1.visible', true)
			setProperty('winIcoP1.visible', false)
		end

function onGameOver()
modchart = false
return Function_Continue;
end

function noteMiss(id, direction, noteType, isSustainNote)
if direction == 0 then
	dir = "LEFT"
elseif direction == 1 then
	dir = "DOWN"
elseif direction == 2 then
	dir = "UP"
elseif direction == 3 then
	dir = "RIGHT"
end
	  setProperty('iconP1.visible', false)
	setProperty('winIcoP1.visible', true)

end

function onUpdatePost()

setProperty("winIcoP1.scale.x", (getProperty("iconP1.scale.x") - 1) / 1 + 1)
setProperty("winIcoP1.scale.y", (getProperty("iconP1.scale.y") - 1) / 1 + 1)

setProperty("winIcoP2.scale.x", (getProperty("iconP2.scale.x") - 1) / 1 + 1)
setProperty("winIcoP2.scale.y", (getProperty("iconP2.scale.y") - 1) / 1 + 1)

		setProperty('winIcoP1.x', getProperty('iconP1.x')+-50)
		setProperty('winIcoP1.y', getProperty('iconP1.y')-50)
		setProperty('winIcoP2.x', getProperty('iconP2.x'))
		setProperty('winIcoP2.y', getProperty('iconP2.y'))
end
--Improved by LinkstormZ


