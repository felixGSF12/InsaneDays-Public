-- Make by Noah_ノア君
--↓ settings ↓--
local customhealthbar = true       -- custom health bar. on = true  off = false    --default true
local iconMove = false            -- Icon Position Fixation. on = false  off = true    --default false
local customscoretext = true       -- custom score text. on = true  off = false    --default true
local iconbop = true
local customX = false;
--↑ settings ↑--
----------------------------
----Confirmed Operation-----
--OS Engine 1.5.1
--Psych Engine 0.6.3
--JS Engine
----------------------------

----------------------------
--------DO NOT TOUCH--------
----------------------------
function onCreatePost()
	luaDebugMode = false
if customhealthbar == true then
makeLuaSprite('Castam-healthbar-background','healthbar/background',73,607)
setObjectCamera('Castam-healthbar-background', 'camHUD')
addLuaSprite('Castam-healthbar-background')
setProperty('Castam-healthbar-background.scale.x', 0.65)
setProperty('Castam-healthbar-background.scale.y', 0.65)
makeLuaSprite('Castam-healthbarlayoutalt','healthbar/backgroundlayoutalt',73,607)
setObjectCamera('Castam-healthbarlayoutalt', 'camHUD')
addLuaSprite('Castam-healthbarlayoutalt')
setProperty('Castam-healthbarlayoutalt.scale.x', 0.65)
setProperty('Castam-healthbarlayoutalt.scale.y', 0.65)
setProperty('Castam-healthbarlayoutalt.alpha', 0.6)
makeLuaSprite('Castam-healthbarlayout','healthbar/backgroundlayout',73,607)
setObjectCamera('Castam-healthbarlayout', 'camHUD')
addLuaSprite('Castam-healthbarlayout')
setProperty('Castam-healthbarlayout.scale.x', 0.65)
setProperty('Castam-healthbarlayout.scale.y', 0.65)
makeLuaSprite('Castam-healthbar','healthbar/main',73,607)
setObjectCamera('Castam-healthbar', 'camHUD')
addLuaSprite('Castam-healthbar')
setProperty('Castam-healthbar.scale.x', 0.65)
setProperty('Castam-healthbar.scale.y', 0.65)
setObjectOrder('Castam-healthbar-background', 1, 'uiGroup')
setObjectOrder('healthBar', 2, 'uiGroup')
setObjectOrder('Castam-healthbarlayoutalt', 3, 'uiGroup')
setObjectOrder('Castam-healthbarlayout', 4, 'uiGroup')
setObjectOrder('Castam-healthbar', 5, 'uiGroup')
setProperty('healthBar.visible', true)
setProperty('healthBarBG.visible', false)
setProperty('healthBarOverlay.visible', false)
else
setProperty('healthBar.visible', true)
setProperty('healthBarBG.visible', true)
setProperty('healthBarOverlay.visible', true)
end
makeLuaText('debug', '', width, 0, 200)
addLuaText('debug')
setTextSize('debug', 40)
makeLuaText('NewscoreTxt', '', width, 0,0)
setTextSize('NewscoreTxt', 25)
addLuaText('NewscoreTxt')
setTextAlignment('NewscoreTxt', 'center')
if downscroll == false then
setProperty('NewscoreTxt.x', 400)
setProperty('NewscoreTxt.y', 660)
elseif downscroll == true then
setProperty('NewscoreTxt.x', 420)
setProperty('NewscoreTxt.y', 30)
setProperty('Castam-healthbar-background.x', 73)
setProperty('Castam-healthbar-background.y', -36)
setProperty('Castam-healthbar-background.angle', 180)
setProperty('Castam-healthbarlayoutalt.x', 73)
setProperty('Castam-healthbarlayoutalt.y', -36)
setProperty('Castam-healthbarlayoutalt.angle', 180)
setProperty('Castam-healthbarlayout.x', 73)
setProperty('Castam-healthbarlayout.y', -36)
setProperty('Castam-healthbarlayout.angle', 180)
setProperty('Castam-healthbar.x', 73)
setProperty('Castam-healthbar.y', -36)
setProperty('Castam-healthbar.angle', 180)
end
if downscroll == false and customhealthbar == true then
	setProperty('healthBar.y', 700)
	setProperty('healthBar.scale.y', 1.6)
	setProperty('healthBar.scale.x', 0.95)
	elseif downscroll == true and customhealthbar == true then
	setProperty('healthBar.y', 10)
	setProperty('healthBar.scale.y', 1.6)
	setProperty('healthBar.scale.x', 0.95)
	end
	createText('timeShit', '', 500, 385, 20, 23, 'center')
	setProperty('timeShit.alpha',0);
end
local iconP1angle = 0
local iconP2angle = 0
function onBeatHit()
health = getProperty('health')
if iconbop == true then
--player
if health > 0.35 and health < 1.65 then
iconP1angle = 20
elseif health < 0.35 then
iconP1angle = 3
elseif health > 1.65 then
iconP1angle = 25
end
--opponent
if health < 1.65 and health > 0.35 then
iconP2angle = 20
elseif health < 0.35 then
iconP2angle = 25
elseif health > 1.65 then
iconP2angle = 3
end
end

end
function onUpdate()
--setting
local stop = false
if getObjectOrder('iconP1') < getObjectOrder('Castam-healthbar') then
setObjectOrder('iconP1',getObjectOrder('Castam-healthbar')+1)
setObjectOrder('iconP2',getObjectOrder('Castam-healthbar')+1)
--setProperty('camZooming', false)
end
end


function onUpdatePost(elapsed)
	if (dadName ~= 'cdtaf') then
setProperty('iconP1.x',getProperty('Castam-healthbar.x')+820)
setProperty('iconP2.x',getProperty('Castam-healthbar.x')+160)
setProperty('iconP1.y',getProperty('Castam-healthbar.y')-5);
	else
setProperty('iconP2.x',getProperty('Castam-healthbar.x')+820)
setProperty('iconP1.x',getProperty('Castam-healthbar.x')+160)
end
if (dadName == 'momRTX' or dadName == 'sarixDownwork' or dadName == 'ichiCALLATEPORFA') then
setProperty('iconP2.y',getProperty('Castam-healthbar.y')-24)
else
setProperty('iconP2.y',getProperty('Castam-healthbar.y')-7)
end
setProperty('Castam-healthbar.x',getProperty('healthBar.x')-273)
setProperty('Castam-healthbar.y',getProperty('healthBar.y')-90)
setProperty('Castam-healthbar-background.x',getProperty('healthBar.x')-273)
setProperty('Castam-healthbar-background.y',getProperty('healthBar.y')-90)
setProperty('Castam-healthbarlayout.x',getProperty('healthBar.x')-273)
setProperty('Castam-healthbarlayout.y',getProperty('healthBar.y')-90)
setProperty('Castam-healthbarlayoutalt.x',getProperty('healthBar.x')-273)
setProperty('Castam-healthbarlayoutalt.y',getProperty('healthBar.y')-90)
setProperty('scoreTxt.visible',false)
if customscoretext == true then
setProperty('scoreTxt.visible', false)

if ratingFC == "" then
	setTextString('NewscoreTxt', 'Score : '..score..' / Rank : 0 %'..' / Misses : '..misses..'/'..' FULL COMBO')
else
	setTextString('NewscoreTxt', 'Score : '..score..' / Rank : '..round(rating * 100, 2)..' %'..' / Misses : '..misses.."/ "..ratingFC);
end
setTextSize('NewscoreTxt',20)
elseif customscoretext == true then
setProperty('scoreTxt.visible', false)
end
setTextString('debug', '')
local timeElapsed = math.floor(getProperty('songTime') / 1000)
local timeTotal = math.floor(getProperty('songLength') / 1000)

setProperty('scoreTxt.visible', false)
setProperty('timeTxt.visible', false)

if getPropertyFromClass('ClientPrefs', 'timeBarType') == 'Time Left' then
    setTextString('timeShit', string.format("%.2d:%.2d", timeElapsed / 60 % 60, timeElapsed % 60) .. '/' .. string.format("%.2d:%.2d", timeTotal / 60 % 60, timeTotal % 60))
elseif getPropertyFromClass('ClientPrefs', 'timeBarType') == 'Song Name' then
    setTextString('timeShit', songName)
elseif getPropertyFromClass('ClientPrefs', 'timeBarType') == 'Time Elapsed' then
    setTextString('timeShit', string.format("%.2d:%.2d", timeElapsed / 60 % 60, timeElapsed % 60))
end
end
	function createText(tag, text, width, x, y, size, align)
		makeLuaText(tag, text, width, x, y)
		setTextSize(tag, size)
		setTextFont(tag, 'vcr.ttf')
		setTextAlignment(tag, align)
		addLuaText(tag)
	end
	function onSongStart()
		doTweenAlpha('timeAlpha', 'timeShit', 1, 0.25, 'circIn')
	end
	function round(x, n) --https://stackoverflow.com/questions/18313171/lua-rounding-numbers-and-then-truncate
		n = math.pow(10, n or 0)
		x = x * n
		if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
		return x / n
	  end

	  function onEvent(name,value1,value2)
		if (name == "Change Stage" and value1 == "dog") then
			customX = true;
		else
			customX = false;
		end
		
	  end
function getIconsPost()
    local post = {
        getProperty('iconP2.x'),
        getProperty('iconP1.x')
    }
    return post
end
