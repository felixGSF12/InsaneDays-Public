 

local sounds = {"missnote1","missnote2","missnote3"}
local icons = {'felix','mari'};
local min = 0;
local zoom = '0.034'
local cound = 0;
local healthDrain = 0.02
isMari = false;
local health_min_value = 0.20
--- @param membersIndex int
--- @param noteData int
--- @param noteType string
--- @param isSustainNote boolean
function noteMiss(membersIndex, noteData, noteType, isSustainNote)
	debugPrint("avgMisses is: "..getPropertyFromClass("Results", "avgMisses"))
	debugPrint("lerpedCombo is: ".. getPropertyFromClass("Results", "lerpedCombo"))
	debugPrint("highestCombo is: "..getPropertyFromClass("Results", "highestCombo"))
	debugPrint("highestComboRecord is: "..getPropertyFromClass("Results", " highestComboRecord"))
	precacheSound("missnote1")
	precacheSound("missnote2")
	precacheSound("missnote3")
	local vol = getPropertyFromClass("ClientPrefs", "missVol")
	local shake = getPropertyFromClass("ClientPrefs", "shakeScreen")
	if not isSustainNote then
		if shake == true then
		triggerEvent("Screen Shake", "0.4,0.02", nil)
		end
		indice_aleatorio = math.random(#sounds)
		opcion_aleatoria = sounds[indice_aleatorio]
	playSound(opcion_aleatoria,vol,"miss111")
		print(opcion_aleatoria)
		end
		if vol == 0 then
			stopSound("miss111")
		end
	end
function checkLogro()
	if botPlay == false or practice == false then
		addLuaScript("data/"..songName.."/".."logro/achievements")
		--addLuaScript("data/"..songName.."/".."achievements")
end
end
local function pixelRatingfix()
	local ratingMode = getPropertyFromClass("ClientPrefs", "newRat",true);
	if ratingMode == 'vanilla' and curStage == "PixelJOYO" or curStage == "EvilDojo" then
		setPropertyFromClass('ClientPrefs', 'comboOffset[0]', -200,180)
				setPropertyFromClass('ClientPrefs', 'comboOffset[2]', -315)
				setPropertyFromClass('ClientPrefs', 'comboOffset[3]', -50)
	end
end
function onCreatePost()
	checkLogro()
	pixelRatingfix()
	gf_stagePositions()
	local multi = getPropertyFromClass("ClientPrefs", "multiPlayer",true);
	noteSplashes = getPropertyFromClass("ClientPrefs","noteSplashes",true)
	local roles = getPropertyFromClass("ClientPrefs", "myLove",false)
    --border health
	if getPropertyFromClass("ClientPrefs", "vanillaHud") == false then
	makeLuaSprite('Health', 'healthbarSacorg')
	setObjectCamera('Health', 'hud')
	addLuaSprite('Health', true)
	setObjectOrder('Health', getObjectOrder('healthBar') + 3)
	setProperty('healthBar.visible', true)

	makeLuaSprite('HealthBG', 'saraHUD/healthBarOver')
	setProperty('HealthBG.x', getProperty("healthBar.x"))
	setProperty('HealthBG.y', getProperty("healthBar.y"))
	setObjectCamera('HealthBG', 'hud')
	addLuaSprite('HealthBG', true)
	setObjectOrder('HealthBG', getObjectOrder('healthBar') + 3)
	setProperty('healthBar.visible', true)
	end
	--gender change
if multi == true then
	addLuaScript("scripts/stuff/MultiPlayer");
	removeLuaScript("scripts/huds/mariHud",true)
end

end
function onUpdatePost(elapsed)
	
	setProperty('Health.x', getProperty('healthBar.x') - 55)
	setProperty('Health.y', getProperty('healthBar.y') - 20)
	setProperty('timeBar.color', getIconColor('dad'))
end
function getIconColor(chr)
    local chr = chr or "dad"
    return getColorFromHex(rgbToHex(getProperty(chr .. ".healthColorArray")))
end
function rgbToHex(array)
    return string.format('%.2x%.2x%.2x', array[1], array[2], array[3])
end

function onTimerCompleted(tag)
	if tag == "stop" then
		stopSound("lowhealth")
	end
end
function onBeatHit()
	--icons move
	local gfSpeed = 1;
	if (curBeat % gfSpeed == 0) then
		if curBeat % (gfSpeed * 2) == 0 then
			setProperty('iconP1.scale.x', 0.8 );
			setProperty('iconP1.scale.y', 0.8 );
			setProperty('iconP2.scale.x', 1.2 );
			setProperty('iconP2.scale.y', 1.3 );

			setProperty('iconP1.angle', -15);
			setProperty('iconP2.angle', 15);
		else
			setProperty('iconP1.scale.x', 1.2 );
			setProperty('iconP1.scale.y', 1.3 );
			setProperty('iconP2.scale.x', 0.8 );
			setProperty('iconP2.scale.y', 0.8 );

			setProperty('iconP2.angle', -15);
			setProperty('iconP1.angle', 15);
		end
	end
end
--- @param membersIndex int
--- @param noteData int
--- @param noteType string
--- @param isSustainNote bool
---
function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
	if  getPropertyFromClass('ClientPrefs', 'noteSplashes') == true  and not isSustainNote then
		runHaxeCode('game.spawnNoteSplash('..getPropertyFromGroup('strumLineNotes', noteData, 'x')..', '..getPropertyFromGroup('strumLineNotes', noteData, 'y')..', '..noteData..');')
end
if songName == "MultiLove" then
    setHealDrain(0.20, 0)

elseif dadName == 'brother-mad' then
    setHealDrain(0.20, 0.002)

elseif songName == "Thats all Folks" and difficultyName == "easy" then
    setHealDrain(0.20, 0.011)

elseif dadName == 'brother' then
    setHealDrain(0.20, 0)

elseif songName == 'isaBM' then
    setHealDrain(0.20, 0.002)
else
	setHealDrain(0.20, 0.02)
end
if practice == true then
    setHealDrain(0.20, 0)
end
end
function setHealDrain(min, porcent)
    local active = true
    local health = getProperty('health')
        if health > min then
            setProperty('health', health - porcent * getProperty("healthLoss"))
    end
end
function onCreate()
	if getPropertyFromClass("ClientPrefs", "shitHealth") == true then
		if downscroll == false then
		makeLuaText('healthText', 'Health: ' .. math.floor(getProperty("health") * 50), 300, screenWidth / 2 + 300 / 2, screenHeight / 2 - -508 / 1.5)
		addLuaText('healthText')
		setTextSize('healthText', 20);
		else
			if middlescroll and downscroll and getPropertyFromClass("ClientPrefs", "iconsBor") == false then
			makeLuaText('healthText', 'Health: ' .. math.floor(getProperty("health") * 50), 300, screenWidth / 2 - 910 / 2, screenHeight / 2 - 350 / 1.5)
		addLuaText('healthText')
		setTextSize('healthText', 20);
			elseif downscroll and middlescroll and getPropertyFromClass("ClientPrefs", "iconsBor") == true then
				makeLuaText('healthText', 'Health: ' .. math.floor(getProperty("health") * 50), 300, screenWidth / 2 + 600 / 2, screenHeight / 2 - 470 / 1.5)
				addLuaText('healthText')
				setTextSize('healthText', 20);
			else
				makeLuaText('healthText', 'Health: ' .. math.floor(getProperty("health") * 50), 300, screenWidth / 2 - 300 / 2, screenHeight / 2 + 370 / 1.5)
				addLuaText('healthText')
				setTextSize('healthText', 20);
			end
	end
	if downscroll then
		makeLuaText('healthText', 'Health: ' .. math.floor(getProperty("health") * 50), 300, screenWidth / 2 - 270 / 2, screenHeight / 2 - -408 / 1.5)
		addLuaText('healthText')
		setTextSize('healthText', 20);
	end
end
end
function noteMiss()
	triggerEvent("Play Animation", "sad", "gf")
end
function stagePositions()
	if curStage == "rayoBack" then
		setProperty("gf.y", getProperty("gf.y")-68)
	end
end