
----------------------------------------------------------------------------

--HUD created with bit little of borrowed code

----------------------------------------------------------------------------





----------------------------CUSTOM----------------------------


--True = ACTIVATED
--False = DESACTIVATED




R4 = true--BARS BLACK HUD
Al = 0.85--BARS BLACK HUD VISIBLE
--Recomended no more 0.7 to 1


R5 = false--SPRITE NOISE HUD

Cn = false--COUNTER COMBO VISIBLE --Recomended "False" for PE 0.7.1

FPS = true--FPS COUNTER VISIBLE


RZ1 = false--ICON BOOPY 1
RZ2 = true--ICON BOOPY 2


Rating = 2--RATING TXT ( 1: Sick / 2: Cool / 3: Baddie)
ZTimeRating = 1952--TIME OF RATING GAME



TagColor = 'FFFFFF' --------------COLOR----------------------------

tb = false--TimeBar VISIBLE --Recomended "False" for PE 0.7.1


Rainbow = false--Rainbow Tween Color
-----WARNING SCORE AND SMOOTH BUG----
-----PLEASE DON'T USE CAMFOLLOW IF YOU WILL USE THIS OPTION----


HealthBarX = 2--HealthBar Style (1: Default / 2: On the sides / 3: HellReborn(Coming Soon))



----more options in version 2

----------------------------CUSTOM----------------------------












function getRatingVar()
	return string.sub(tostring(rating*100), 1, 5)
end

function onUpdatePost()
setProperty('Huddown.alpha', Al)
setProperty('Hudup.alpha', Al)
doTweenColor('BOX', 'BOX', TagColor, 0.01, 'linear')
	
if HealthBarX == 2 then
    setProperty('iconP2.x', 240, 0)
    setProperty('iconP1.x', 1020, 0)
	setProperty('winIcoP1.x',getProperty('iconP1.x')-70)
	if dadName == 'tijeritas' then
		setProperty("IconDuo.x",getProperty('iconP2.x')- 100)
	else
		setProperty("IconDuo.x",getProperty('iconP1.x') )
	end
	--setProperty('winIcoP1.visible',true)
end
	
    if ratingFC == '' then -- if the FC is nothing
        setProperty('scoreTxt.text', 'Score: ' .. score .. ' | Misses: ' .. misses .. ' | Ranking: 0%')

    setTextColor('scoreTxt', '000000')
    else
        setProperty('scoreTxt.text', 'Score: ' .. score .. ' | Misses: ' .. misses .. ' | Ranking: ' ..round(rating * 100, 2).. '% [' ..ratingFC..']')
    setTextColor('scoreTxt', '000000')
    end

end

local turnvalue = 20

function onBeatHit()
if RZ1 == true then
turnvalue = 20
if curBeat % 2 == 0 then
turnvalue = -20
end

setProperty('iconP2.angle',-turnvalue)
setProperty('iconP1.angle',turnvalue)

doTweenAngle('iconTween1','iconP1',0,crochet/1000,'circOut')
doTweenAngle('iconTween2','iconP2',0,crochet/1000,'circOut')
end
if RZ2 == true then
turnvalue = 20
if curBeat % 4 == 0 then
turnvalue = -20
end

setProperty('iconP2.angle',turnvalue)
setProperty('iconP1.angle',-turnvalue)

doTweenAngle('iconTween1','iconP1',0,crochet/1000,'circOut')
doTweenAngle('iconTween2','iconP2',0,crochet/1000,'circOut')
end
end
local gfSpeed = 1;


function round(x, n)
  n = math.pow(10, n or 0)
  x = x * n
  if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
  return x / n
end
--HUD CREATED BY ALPHA x


--------------------------HUD SPRITE----------------------------
function onCreatePost()

    makeLuaText("time", Part2, -1, 1170, 660)
    setTextSize("time", 18)
    setObjectCamera("time", 'hud'); 
    setTextColor('time', '000000')
    addLuaText("time")
    setTextBorder('time', 1, TagColor);
    
doTweenColor('bar', 'timeBar', TagColor, 1, 'cubeOut')
    setTextBorder('time', 1, TagColor);
    setTextBorder('PLAYING', 1, TagColor);
    setTextBorder('NAME', 1, TagColor);
setObjectOrder('iconP1',getObjectOrder('iconP2'))
	if botPlay then
		if downscroll then
			comboTextY = getProperty('scoreTxt.y') + 460
		else
			comboTextY = getProperty('botplayTxt.y') + 60
		end
	else
		if downscroll then
			comboTextY = getProperty('scoreTxt.y') + 50
		else
			comboTextY = getProperty('botplayTxt.y')
		end
	end
        setProperty('timeBarBG.visible', tb)
        setProperty('timeBar.visible', tb)

	setProperty('comboSpr.visible', false)
	
	makeLuaText('comboTxt', '', 400, getProperty('scoreTxt.x'), comboTextY)
	setTextSize('comboTxt', 55)
	setTextBorder('comboTxt', 3, '000000')
	setTextFont('comboTxt', 'vcr.ttf')
	setTextAlignment('comboTxt', 'center')
	addLuaText('comboTxt')
	screenCenter('comboTxt', 'x')

        setProperty('timeBar.x', 845)
        setProperty('timeBar.scale.x', 3.275)
        setObjectCamera('timeBar', 'hud')


        setTextBorder('scoreTxt', 1, TagColor);
        setTextColor('scoreTxt', '000000')
  
        setTextBorder('sick', 1, TagColor);
        setTextColor('sick', '000000')
  
        setTextBorder('good', 1, TagColor);
        setTextColor('good', '000000')
  
        setTextBorder('bad', 1, TagColor);
        setTextColor('bad', '000000')
  
        setTextBorder('timeTxt', 1, TagColor);
        setTextColor('timeTxt', '000000')
  
        setTextBorder('comboTxt', 1, TagColor);
        setTextColor('comboTxt', '000000')
  
  
        makeLuaText('difficultyName', '', 0, 10)
        setTextSize('difficultyName', 35)
        setProperty('difficultyName.x', 1100)
        setTextBorder('difficultyName', 1, '000000')
        setObjectCamera('difficultyName', 'hud')
        addLuaText('difficultyName')
        setTextBorder('difficultyName', 1, TagColor);
        setTextColor('difficultyName', '000000')
        setTextString('difficultyName',string.upper(difficultyName))
          setProperty('timeTxt.y', 185)
        setProperty('scoreTxt.y', 100)
        setProperty('difficultyName.y', 10)
		if not downscroll then
        setProperty('scoreTxt.y', 614)
cmy = -270
        setProperty('timeBar.y', -7)
        setProperty('timeTxt.y', 40)
        setProperty('difficultyName.y', 675)
        setProperty('time.y', 50)
        setProperty('songName.y', 675)
end
	
    makeLuaText("tnh", 'Total Notes Hit: 0', 250, tnhx, 259);
    makeLuaText("cm", 'Combos: 0', 200, -getProperty('tnh.x') + cmoffset, getProperty('tnh.y') + cmy);
    makeLuaText("sick", 'Sicks!: 0', 200, getProperty('cm.x'), getProperty('cm.y') + 20);
    makeLuaText("good", 'Goods: 0', 200, getProperty('cm.x'), getProperty('sick.y') + 20);
    makeLuaText("bad", 'Bads: 0', 200, getProperty('cm.x'), getProperty('good.y') + 20);
    makeLuaText("shit", 'Shits: 0', 200, getProperty('cm.x'), getProperty('bad.y') + 20);
    makeLuaText("miss", 'Misses: 0', 200, getProperty('cm.x'), getProperty('shit.y') + 20);
    setObjectCamera("sick", 'hud');
    setTextSize('sick', 20);
    addLuaText("sick");
    setTextFont('sick', font)
    setTextAlignment('sick', 'left')
    setObjectCamera("good", 'hud');
    setTextSize('good', 20);
    addLuaText("good");
    setTextFont('good', font)
    setTextAlignment('good', 'left')
    setObjectCamera("bad", 'hud');
    setTextSize('bad', 20);
    addLuaText("bad");
    setTextFont('bad', font)
    setTextAlignment('bad', 'left')
        setTextColor('sick', '000000')
  
        setTextColor('good', '000000')
  
        setTextColor('bad', '000000')
  
        setTextBorder('sick', 1, TagColor);
        setTextBorder('good', 1, TagColor);
        setTextBorder('bad', 1, TagColor);

	setProperty('bad.visible', Cn)
	setProperty('sick.visible', Cn)
	setProperty('good.visible', Cn)
	
    timeTab = os.date('*t')
    --debugPrint(timeTab)

    yepp = ""
    if timeTab.hour < 12 then yepp = 'A.M.' else yepp = 'P.M.' end
    part1 = months[timeTab.month] .. '. ' .. timeTab.day .. ' ' .. timeTab.year
    part2 = timeTab.hour .. ':'.. timeTab.min .. ' '.. yepp 


  -- set the fps font to VCR
  addHaxeLibrary('Main');
  runHaxeCode([[
    Main.fpsVar.visible = false;
  ]]);
end
--Memory/Fps/Time
function round(x, n)
  n = math.pow(10, n or 0)
  x = x * n
  if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
  return x / n
end


local months = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'}
local timeTab = {}

function round(x, n) --https://stackoverflow.com/questions/18313171/lua-rounding-numbers-and-then-truncate
  n = math.pow(10, n or 0)
  x = x * n
  if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
  return x / n
end

function minCheck()
    if string.len(timeTab.min) < 2 then
        if tonumber(timeTab.min) < 10 then 
            return '0'..timeTab.min
        else
            return timeTab.min
        end
    else
        return timeTab.min
    end
end

function mathlerp(from,to,i)
  return from+(to-from)*i
end
function onSongStart()
    pause = true
    setProperty('boyfriend.stunned', false)
    doTweenY('seTweenY', 'Huddown', -0, 1, 'linear');
    doTweenY('seTwee2nY', 'Hudup', 0, 1, 'linear');
end
local allowCountdown = false
local pause = false
local esc = false
--HUD CREATED BY ALPHA X

function onStepHit()
	if stepHitFuncs[curStep] then
		stepHitFuncs[curStep]()
	end
end

stepHitFuncs = {
[ZTimeRating] = function()
if Rating == 1 then--No Tocar (Te estoy viendo)
		if rating > 0.85  then
			addLuaSprite('rate',true)
			objectPlayAnimation('rate', 'sick',false)
			runTimer('daRating', 1.6, 1);
			playSound('rate', 1);
		end
end
if Rating == 2 then--No Tocar (Te estoy viendo)
		if rating > 0.85  then
			addLuaSprite('rate',true)
			objectPlayAnimation('rate', 'cool',false)
			runTimer('daRating', 1.6, 1);
			playSound('rate', 1);
		end
end
if Rating == 3 then--No Tocar (Te estoy viendo)
		if rating > 0.85  then
			addLuaSprite('rate',true)
			objectPlayAnimation('rate', 'baddie',false)
			runTimer('daRating', 1.6, 1);
			playSound('rate', 1);
		end
end
end
}

function onCreate()
if Rating == 1 then
	makeAnimatedLuaSprite('rate', 'ratings', 300,200)
	addAnimationByPrefix('rate', 'sick', 'sickRating',24,false)
	setScrollFactor('rate', 0, 0);
	setObjectCamera('rate', 'hud')
end
if Rating == 2 then
	makeAnimatedLuaSprite('rate', 'ratings', 300,200)
	addAnimationByPrefix('rate', 'cool', 'coolRating',24,false)
	setScrollFactor('rate', 0, 0);
	setObjectCamera('rate', 'hud')
end
if Rating == 3 then
	makeAnimatedLuaSprite('rate', 'ratings', 300,200)
	addAnimationByPrefix('rate', 'baddie', 'baddieRating',24,false)
	setScrollFactor('rate', 0, 0);
	setObjectCamera('rate', 'hud')
end



	setProperty('showComboNum', false)
	makeLuaSprite('Huddown', 'HUD/HUDDOWM', 0, 100);
	scaleObject('Huddown', 2, 2);
	setObjectCamera('Huddown', 'hud');
	addLuaSprite('Huddown', true);

	makeLuaSprite('Hudup', 'HUD/HUDUP', 0, -100);
	scaleObject('Hudup', 2, 2);
	setObjectCamera('Hudup', 'hud');
	addLuaSprite('Hudup', true);
		if not downscroll then
	makeLuaSprite('Huddown', 'HUD/HUDDOWM2', 0, 100);
	scaleObject('Huddown', 2, 2);
	setObjectCamera('Huddown', 'hud');

	makeLuaSprite('Hudup', 'HUD/HUDUP2', 0, -100);
	scaleObject('Hudup', 2, 2);
	setObjectCamera('Hudup', 'hud');
	addLuaSprite('Huddown', false);
	addLuaSprite('Hudup', false);
	end
    setProperty('camGame.alpha', 1)
	setProperty('Huddown.visible', R4)
	setProperty('Hudup.visible', R4)--VISIBLE




    
    






	setObjectOrder('fps', getObjectOrder('iconP2') + 1)
	setObjectOrder('MemoryCounter', getObjectOrder('iconP2') + 1)
	setObjectOrder('time', getObjectOrder('iconP2') + 1)



    doTweenColor('bar', 'timeBar', TagColor, 1, 'cubeOut')
	doTweenColor('rr1','black2',TagColor,0.01,'expoout')
	doTweenColor('rr1r','black1',TagColor,0.01,'expoout')
	doTweenColor('rr','Hudup',TagColor,0.01,'expoout')
	doTweenColor('rrr','Huddown',TagColor,0.01,'expoout')
	doTweenColor('saqqed','black',TagColor,0.01,'expoout')
	doTweenColor('werwer','12',TagColor,0.01,'expoout')
	doTweenColor('gukonv','Load',TagColor,0.01,'expoout')

	setProperty('time.visible', FPS)
	setProperty('fps.visible', FPS)
	setProperty('MemoryCounter.visible', FPS)

end
notehitlol = 0
sadfasd = 0 -- unused
font = "vcr.ttf" -- the font that the text will use.
cmoffset = -4
cmy = 360
tnhx = -10

loadnumber = math.random(1, 4)

function onUpdate(elapsed)
	setProperty('Health.visible', getProperty('scoreTxt.visible'))
	setProperty('Health.alpha', getProperty('scoreTxt.alpha'))
	setProperty('Health.x', getProperty('healthBar.x') - 20)
	setProperty('Health.y', getProperty('healthBar.y') - 0)
    notehitloltosting = tostring(notehitlol)
    setTextString('cm', 'Combos: ' .. getProperty('combo'))
    setTextString('sick', 'Sick!: ' .. getProperty('sicks'))
    setTextString('good', 'Goods: ' .. getProperty('goods'))
    setTextString('bad', 'Bads: ' .. getProperty('bads'))
    setTextString('shit', 'Shits: ' .. getProperty('shits'))
    setTextString('miss', 'Misses: ' .. getProperty('songMisses'))
	-- start of "update", some variables weren't updated yet
    -- setTextString('tnh', 'Total Notes Hit: ' + 1)

    if getPropertyFromClass('flixel.FlxG', 'keys.justReleased.ESCAPE') and not esc and pause then
        esc = true
        pause = false
        endSong()
    end

    if getPropertyFromClass('flixel.FlxG', 'keys.justReleased.ESCAPE') and esc then
        pause = false
        endSong()
    end
    local curFps = ""..getPropertyFromClass("Main", "fpsVar.currentFPS")
    local memory = round(getPropertyFromClass("openfl.system.System", "totalMemory") / 1000000, 1);
    local memPeak = memory
    local peakLv = 0
  

    timeTab = os.date('*t')
    yepp = ""
    if timeTab.hour < 12 then yepp = 'A.M.' else yepp = 'P.M.' end
    part1 = months[timeTab.month] .. '. ' .. timeTab.day .. ' ' .. timeTab.year
    part2 = timeTab.hour .. ':'.. minCheck() .. ' '.. yepp 

    setTextString('time', part2)

   
 
    setTextString("MemoryCounter", "Memory: " .. memory .. " MB")
    setTextString("fps", curFps .. " FPS")
end



    if t == 'u' then
        doTweenAlpha('12', '12', 0.4, 0.3, 'linear')
    runTimer('u2', 0.3)
    end

    if t == 'u2' then
        doTweenAlpha('12', '12', 1, 0.3, 'linear')
    runTimer('u', 0.9)
    end
--HUD CREATED BY ALPHA 

-- COMBO COUNTER PLUS V1.1.0
-- by SilverSpringing

-- Please, PLEASE credit me if you intend on using this for a mod.
-- You wouldn't like it if I didn't credit you for something you made, right? It's only fair.

-- PhantomMuff font by Cracsthor on Gamebanana: https://gamebanana.com/tools/7763
-- Psych Engine by Shadow Mario: https://github.com/ShadowMario/FNF-PsychEngine

--- CUSTOMIZATION ----------------------------------------------------------------------------

-- Colored Text
colored_text = ""
-- Changes the color of the rating text.
-- Setting this value to "Kade Engine" changes the color of each rating to look like the Kade Engine score popups.
-- Setting this value to "Week Themes" changes the color of each rating depending on the week you're on.
-- Setting this value to anything else will set the color of the text to white.

-- Unqiue Rating Animations
unique_rating_animations = true
-- If set to true, each rating will have its own unique animation that plays when it pops up.

--- ACTUAL CODE ------------------------------------------------------------------------------ 

ratingColor = "000000"

rainbowTime = 0.75

weekThemes = {
	{"FFC6EF", "F44254", "AFCAD3", "696F96"}, -- Week 1
	{"86BCFF", "91C53C", "C7463F", "E62145"}, -- Week 2
	{"FD6922", "55E858", "D78F5B", "B91C37"}, -- Week 3
	{"FFC6EF", "F3E05A", "EE1536", "2B263C"}, -- Week 4
	{"9FC5FD", "F6F097", "4566FC", "5C417E"}, -- Week 5
	{"FF45A1", "FAA66D", "96BEB5", "161C47"}, -- Week 6
	{"FFFFFF", "F7B804", "E1A244", "6E3D2A"} -- Week 7
}

local colors = {'FF00FF', '00FFFF', '00FF00', 'FF0000'}

--HUD CREATED BY ALPHA x
function goodNoteHit(id, direction, noteType, isSustainNote)

	-- Function called when you hit a note (after note hit calculations)
	-- id: The note member id, you can get whatever variable you want from this note, example: "getPropertyFromGroup('notes', id, 'strumTime')"
	-- noteData: 0 = Left, 1 = Down, 2 = Up, 3 = Right
	-- noteType: The note type string/tag
	-- isSustainNote: If it's a hold note, can be either true or false
      if not isSustainNote then    
         notehitlol = notehitlol + 1;
         setTextString('tnh', 'Total Notes Hit: ' .. tostring(notehitlol))
     end -- NOTE I DID NOT MAKE THIS FRANTASTIC24 MADE THIS!

	local rawNoteRating = getPropertyFromGroup('notes', id, 'rating')
	local noteRating = rawNoteRating
	
	if not isSustainNote then
		--SICK
		if rawNoteRating == 'sick' then
			noteRating = "Sick!!"
			
			if colored_text == "Kade Engine" then
				ratingColor = "ABFFFF"
			elseif colored_text == "Week Themes" then
				ratingColor = weekThemes[weekRaw][1]
			end
		--GOOD
		elseif rawNoteRating == 'good' then
			noteRating = "Good!"
			
			if colored_text == "Kade Engine" then
				ratingColor = "A4FFAB"
			elseif colored_text == "Week Themes" then
				ratingColor = weekThemes[weekRaw][2]
			end
				
		--BAD
		elseif rawNoteRating == 'bad' then
			noteRating = "Bad"

			if colored_text == "Kade Engine" then
				ratingColor = "CC7484"
			elseif colored_text == "Week Themes" then
				ratingColor = weekThemes[weekRaw][3]
			end
			
		--SHIT
		elseif rawNoteRating == 'shit' then
			noteRating = "Shit"

			if colored_text == "Kade Engine" then
				ratingColor = "A9263F"
			elseif colored_text == "Week Themes" then
				ratingColor = weekThemes[weekRaw][4]
			end
		end
	end
	
	if not isSustainNote then
		--cancel tweens
		cancelTween('comboTxtAlphaTween')
		cancelTween('ratingScaleTweenAngle')
		cancelTween('ratingScaleTweenX')
		cancelTween('ratingPosTweenY')
		cancelTween('ratingScaleTweenY')
		-- reset all properties
		setProperty('comboTxt.y', comboTextY)
		setProperty('comboTxt.alpha', 1)
		setProperty('comboTxt.angle', 0)
		setProperty('comboTxt.scale.x', 1)
		setProperty('comboTxt.scale.y', 1)	
		-- set string
		setTextString('comboTxt', noteRating)
		setTextColor('comboTxt', ratingColor)

		
		
		if unique_rating_animations then
			--SICK ANIMATION
			if noteRating == "Sick!!" then
				setProperty('comboTxt.angle', -5)
				setProperty('comboTxt.scale.x', 1.8)
				setProperty('comboTxt.scale.y', 1.8)	
				doTweenX('ratingScaleTweenX', 'comboTxt.scale', 1, 0.7, 'expoOut');
				doTweenY('ratingScaleTweenY', 'comboTxt.scale', 1, 0.7, 'expoOut');
				doTweenAngle('ratingScaleTweenAngle', 'comboTxt', 5, 0.7, 'linear')
			--GOOD ANIMATION
			elseif noteRating == "Good!" then
				setProperty('comboTxt.scale.x', 1.6)
				setProperty('comboTxt.scale.y', 1.6)	
				doTweenX('ratingScaleTweenX', 'comboTxt.scale', 1, 0.7, 'expoOut');
				doTweenY('ratingScaleTweenY', 'comboTxt.scale', 1, 0.7, 'expoOut');
			--BAD ANIMATION
			elseif noteRating == "Bad" then
				setProperty('comboTxt.scale.x', 1.3)
				setProperty('comboTxt.scale.y', 1.3)	
				doTweenX('ratingScaleTweenX', 'comboTxt.scale', 1, 0.7, 'expoOut');
				doTweenY('ratingScaleTweenY', 'comboTxt.scale', 1, 0.7, 'expoOut');
				doTweenAngle('ratingScaleTweenAngle', 'comboTxt', -10, 0.7, 'linear')
			--SHIT ANIMATION
			elseif noteRating == "Shit" then
				setProperty('comboTxt.scale.x', 1.0)
				setProperty('comboTxt.scale.y', 1.0)	
				doTweenX('ratingScaleTweenX', 'comboTxt.scale', 1, 0.7, 'expoOut');
				doTweenY('ratingScaleTweenY', 'comboTxt.scale', 1, 0.7, 'expoOut');
				doTweenY('ratingPosTweenY', 'comboTxt', comboTextY + 25, 0.7, 'linear');
				doTweenAngle('ratingScaleTweenAngle', 'comboTxt', -20, 0.7, 'linear')
			end
		else
			setProperty('comboTxt.scale.x', 1.6)
			setProperty('comboTxt.scale.y', 1.6)	
			doTweenX('scaleTweenX', 'comboTxt.scale', 1, 0.7, 'expoOut');
			doTweenY('scaleTweenY', 'comboTxt.scale', 1, 0.7, 'expoOut');
		end	
		doTweenAlpha('comboTxtAlphaTween', 'comboTxt', 0, 0.5, 'linear')
	end
if Rainbow == true then
    doTweenColor('Crazy1', 'timeBar', colors[direction + 1], 0.6, 'cubeOut')
	doTweenColor('Crazy2','Hudup',colors[direction + 1],0.6,'expoout')
	doTweenColor('Crazy3','Huddown',colors[direction + 1],0.6,'expoout')

    setTextBorder('fps', 1, colors[direction + 1]);
    setTextBorder('time', 1, colors[direction + 1]);
    setTextBorder('MemoryCounter', 1, colors[direction + 1]);

    setTextBorder('timeTxt', 1, colors[direction + 1]);

    setTextBorder('songName', 1, colors[direction + 1]);
    setTextBorder('sick', 1, colors[direction + 1]);
    setTextBorder('bad', 1, colors[direction + 1]);
    setTextBorder('good', 1, colors[direction + 1]);
    setTextBorder('difficultyName', 1, colors[direction + 1]);
    setTextBorder('comboTxt', 1, colors[direction + 1]);
end
end

function onTweenCompleted(tag)
	if tag == 'comboTxtAlphaTween' then
		comboTxt.alpha = 0
	end
end

--HUD CREATED BY ALPHA x


