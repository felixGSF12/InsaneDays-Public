local renderedGrdsH = {0, 0}
local backdropVelocity = 0.6

local isAbleToExit = false
local accuracy = 0

local highestCombo = 0

local curRank = 1
local curRating = 1
local rankings = {'f', 'e', 'd', 'c', 'b', 'a', 's'}
local starsToGenerate = {0, 2, 5, 9, 15, 23, 30}
local ratingImgs = {'shit', 'bad', 'good', 'sick'}
local bgColors = {'5b3c6e', '5b3c6e', '5b3c6e', '3e4599', '3e4599', 'c16ac8', '72ccaf'};
local angles = {20, 15, 0, 0} --spice up the rating
local tweens = {'bounceOut', 'bounceOut', 'linear', 'linear'}
debug = false;

local avgScore = 0
local avgMisses = 0
local avgCombo = 0
local avgAccuracy = 0

local countedNumValue = 0

function onCreate()
    setPropertyFromClass('PlayState', 'chartingMode', debug);
   -- getSound()
    
end

function onCustomSubstateCreatePost(name)
    if name == 'results' then
        setProperty('strumLineNotes.visible', false)
        setProperty('micdupacc.visible', false)
        setProperty('micdupmiss.visible', false)
        setProperty('micdupscore.visible', false)
        setProperty('notes.visible', false)
        setProperty('nps.visible', false)
        setProperty('vocals.volume', 0)
        setPropertyFromClass('flixel.FlxG', 'sound.music.volume', 0)

        makeLuaSprite('camgamehide', nil, -1000, -1000)
        makeGraphic('camgamehide', 3000, 3000, '000000')
        addLuaSprite('camgamehide', true)
        setScrollFactor('camgamehide', 0,0)

        makeLuaSprite('backgr', nil, 0, 0)
        makeGraphic('backgr', 1280, 720, '000000')
        addLuaSprite('backgr')
        setObjectCamera('backgr', 'hud')

        createBackdrops()

        backdropsIntro()
        for i=1,2 do
            local yValue = 0
            local height = 350
            if i == 2 then yValue = screenHeight - height - 150 end
            createGrd(i, 140, 0, yValue, screenWidth, height, i == 2)
    
            if i == 2 then
                 makeLuaSprite('stupid', nil, 0, yValue + height)
                 makeGraphic('stupid', screenWidth, 2000, '000000')
                 addLuaSprite('stupid')
                 setObjectCamera('stupid', 'other')
            end
        end
        createHorizontalGradient()

        accuracy = math.floor(rating * 100)

        updateLetter()
        runTimer('startSequence', 1)
    end
end

local notFirstTime = false
function updateLetter()
    if isStoryMode then
getSound()
        end
        makeLuaSprite('bigLetter', 'ranking/'..rankings[curRank], 750, 100)
    addLuaSprite('bigLetter')
    scaleObject('bigLetter', 2, 2)
    setObjectCamera('bigLetter', 'other')

    if notFirstTime or isStoryMode then
        removeLuaSprite('bigLetterW')
        makeLuaSprite('bigLetterW', 'ranking/'..rankings[curRank]..'-f', 750, 100)
        addLuaSprite('bigLetterW')
        scaleObject('bigLetterW', 2, 2)
        setObjectCamera('bigLetterW', 'other')

        scaleObject('bigLetter', 2.1, 2.1)
        doTweenX('bigLetter', 'bigLetter.scale', 2, 0.5, 'linear')
        doTweenY('bigLetter2', 'bigLetter.scale', 2, 0.5, 'linear')

        scaleObject('bigLetterW', 2.1, 2.1)
        doTweenX('bigLetterW', 'bigLetterW.scale', 2, 0.5, 'linear')
        doTweenY('bigLetterW2', 'bigLetterW.scale', 2, 0.5, 'linear')
        doTweenAlpha('bigLetterW3', 'bigLetterW', 0, 0.5, 'linear')
    else
        setProperty('bigLetter.alpha', 0)

        doTweenAlpha('bigLetterA1', 'bigLetter', 1, 0.5, 'linear')
    end
    notFirstTime = true
end
local numbersFade = false
local doLerpNumbers = false
local pressEnter = false
local enterPressed = false
function onTimerCompleted(name)
    if name == 'startSequence' then
        if not isStoryMode then
            runTimer('accStartNums', 0.07, accuracy + 1)
        else
            onFinished()
        end
    end

    if name == 'accStartNums' then
        doNums()
        if countedNumValue ~= accuracy then
            playSound('scrollMenu')
            countedNumValue = countedNumValue + 1
        elseif countedNumValue == accuracy then
            numbersFade = true
            playSound('cancelMenu')
            onFinished()
        end

        local updateLetterValues = {16, 32, 46, 63, 78, 93}
        local ratingUpdateValues = {35, 60, 90}

        for i = 1, #updateLetterValues do
            if countedNumValue == updateLetterValues[i] then
                local lastColor = bgColors[curRank]
                curRank = curRank + 1
                playSound('assets_preload_sounds_ranking-'..rankings[curRank], 1.5)
                updateLetter()
                stars()
                if not (lastColor == bgColors[curRank]) then
                    cameraFlash('hud', 'FFFFFF', 0.5, true)
                end
            end
        end

        for i = 1, #ratingUpdateValues do
            if countedNumValue == ratingUpdateValues[i] then
                curRating = curRating + 1
            end
        end
    end

    if name == 'bigRating' then
        local theOffsets = {{0, 0}, {0, 100}, {0, 100}, {-150, 20}}

        makeLuaSprite('bigRating', ratingImgs[curRating], -350, -200)
        scaleObject('bigRating', 5, 5) --god dammit yo so big

        setProperty('bigRating.x', -350 + theOffsets[curRating][1])
        setProperty('bigRating.y', -200 + theOffsets[curRating][2])
        --setProperty('camOther.zoom', 0.1)
        doTweenX('bigRating', 'bigRating.scale', 1.1, 0.1, 'linear')
        doTweenY('bigRating2', 'bigRating.scale', 1.1, 0.1, 'linear')
        --doTweenX('bigRating3', 'bigRating', 200, 0.5, 'linear')
        --doTweenY('bigRating4', 'bigRating', 100, 0.5, 'linear')
        addLuaSprite('bigRating')
        setObjectCamera('bigRating', 'other')
    end

    if name == 'bigRatingFX' then
        if ratingImgs[curRating] == 'bad' or ratingImgs[curRating] == 'shit' then
            setProperty('bigRating.y', getProperty('bigRating.y') - 10) -- a snap fix
            setProperty('bigRating.x', getProperty('bigRating.x') - 10)
            setProperty('bigRating.origin.x', 0)
            setProperty('bigRating.origin.y', 0)
        end
        doTweenAngle('bigRatingAng', 'bigRating', angles[curRating], 1, tweens[curRating])
        if ratingImgs[curRating] == 'shit' then
            doTweenAngle('bigLetterAng', 'bigLetter', -angles[curRating], 1, tweens[curRating])

            runTimer('bigRatingFall', 1.6)
        end
    end

    if name == 'bigRatingFall' then
        doTweenY('bigRatingFallsLol', 'bigRating', screenHeight, 1, 'circIn')
        doTweenY('bigLetterFallsLol', 'bigLetter', screenHeight, 0.6, 'circIn') --physycs
    end

    if name == 'scoreStuff' then
        playSound('cancelMenu')

        makeLuaSprite('score', 'ranking/score', -150, 400)
        addLuaSprite('score')
        setObjectCamera('score', 'other')
        
        doTweenX('scoreTwn', 'score', 400, 0.8, 'circOut')

        makeLuaSprite('misses', 'ranking/misses', -150, 500)
        addLuaSprite('misses')
        setObjectCamera('misses', 'other')
        
        doTweenX('missesTwn', 'misses', 180, 0.8, 'circOut')

        if not isStoryMode then
            makeLuaSprite('tcombo', 'ranking/topcombo', -150, 500)
            addLuaSprite('tcombo')
            setObjectCamera('tcombo', 'other')
            
            doTweenX('tcomboTwn', 'tcombo', 560, 0.8, 'circOut')
        else
            makeLuaText('wkScoreTxt', '(Week score)', 0, 400, 384)
            setTextSize('wkScoreTxt', 16)
            addLuaText('wkScoreTxt')
            setObjectCamera('wkScoreTxt', 'other')
            setProperty('wkScoreTxt.alpha', 0)

            makeLuaText('wkMissTxt', '(Week misses)', 0, 180, 484)
            setTextSize('wkMissTxt', 16)
            addLuaText('wkMissTxt')
            setObjectCamera('wkMissTxt', 'other')
            setProperty('wkMissTxt.alpha', 0)

            doTweenAlpha('wkMissTxtAlpha', 'wkMissTxt', 1, 1.8, 'linear')
            doTweenAlpha('wkScoreTxtAlpha', 'wkScoreTxt', 1, 1.8, 'linear')
        end

        runTimer('startLerpNums', 1)
        
        makeAnimatedLuaSprite('a', 'androidcontrols/controls', 538, 588);
		addAnimationByPrefix('a', 'a', 'a', 24, false);
		addAnimationByPrefix('a', 'aPress', 'aPressed', 24, false);
		addLuaSprite('a', true);
		setObjectCamera('a', 'other')
		
        makeLuaSprite('pressenter', 'ranking/press_enter', 50, screenHeight - 110)
        addLuaSprite('pressenter')
        setObjectCamera('pressenter', 'other')
    end

    if name == 'startLerpNums' then
        pressEnter = true
        doLerpNumbers = true
    end

    if name == 'exit' then
        stopSound('music1')
        endSong()
    end
end

function onTweenCompleted(name)
    if name == 'bigRating' then
        cameraFlash('other', 'FFFFFF', 0.5, true)
        cameraShake('other', 0.01, 0.5)
        cameraShake('hud', 0.01, 0.5)
        playSound('confirmMenu')
        isAbleToExit = true

        runTimer('bigRatingFX', 3)
    end
end

function onFinished()
    for i=1, 3 do
        doTweenAlpha('numAL'..i, 'numAL'..i, 0, 1, 'linear')
    end

    if not isStoryMode then
        doEndNums()
        runTimer('bigRating', 0.8)
    else
        isAbleToExit = true
    end
    local tmrDur = 2
    if isStoryMode then tmrDur = 0.5 end
    runTimer('scoreStuff', tmrDur)
end

local starPos = {}
function stars()
    for i=1, starsToGenerate[curRank] do
        local x = getRandomInt(800, 1100)
        local y = getRandomInt(150, 560)

        makeLuaSprite('star'..i, 'ranking/mediocre_star', x, y)
        setObjectCamera('star'..i, 'other')
        --scaleObject('star'..i, 0.8, 0.8)

        local propShit = 'star'..i..''
        setProperty(propShit..'.angle', getRandomInt(-45, 45))

        addLuaSprite('star'..i)

        doTweenX('star'..i, propShit..'.scale', 0, 0.5, 'linear')
        doTweenY('star'..i..'2', propShit..'.scale', 0, 0.5, 'linear')

        doTweenX('star'..i..'3', propShit, x + getRandomInt(-300, 300), 2, 'circOut')
        doTweenY('star'..i..'5', propShit, y + screenHeight, 3.5, 'circOut')
        --getRandomInt(800, 1000)
        --getRandomInt(150, 560)
    end
end

local lerpedScore = 0
function doScoreNums(elapsed)
    lerpedScore = lerpedScore + elapsed * 200000
    if (avgScore - lerpedScore) <= 10 then
        lerpedScore = avgScore end

        local arrayNums = stringSplit(''..math.floor(lerpedScore), '')

        for i=1, #arrayNums do
            local last = #arrayNums - i + 1
            removeLuaSprite('numScore'..i)
            makeLuaSprite('numScore'..i, 'num'..arrayNums[last], 395 - ((39 * 1.2) * i), 410)
            addLuaSprite('numScore'..i)
            setGraphicSize('numScore'..i, 39 * 1.2, 46 * 1.2)
            setObjectCamera('numScore'..i, 'other')
        end
end

local lerpedMiss = 0
function doScoreNumsMiss(elapsed)
    lerpedMiss = lerpedMiss + elapsed * 200
    if (avgMisses - lerpedMiss) <= 10 then
        lerpedMiss = avgMisses end
        
        local arrayNums = stringSplit(''..math.floor(lerpedMiss), '')

        for i=1, #arrayNums do
            local last = #arrayNums - i + 1
            removeLuaSprite('numMiss'..i)
            makeLuaSprite('numMiss'..i, 'num'..arrayNums[last], 175 - ((39 * 1.2) * i), 510)
            addLuaSprite('numMiss'..i)
            setGraphicSize('numMiss'..i, 39 * 1.2, 46 * 1.2)
            setObjectCamera('numMiss'..i, 'other')
        end
end

local lerpedCombo = 0
function doScoreNumsCombo(elapsed)
    lerpedCombo = lerpedCombo + elapsed * 500
    if (avgCombo - lerpedCombo) <= 10 then
        lerpedCombo = avgCombo end
        
        local arrayNums = stringSplit(''..math.floor(lerpedCombo), '')

        for i=1, #arrayNums do
            local last = #arrayNums - i + 1
            removeLuaSprite('numCombo'..i)
            makeLuaSprite('numCombo'..i, 'num'..arrayNums[last], 555 - ((39 * 1.2) * i), 510)
            addLuaSprite('numCombo'..i)
            setGraphicSize('numCombo'..i, 39 * 1.2, 46 * 1.2)
            setObjectCamera('numCombo'..i, 'other')
        end
end

function doNums()
    local arrayNums = stringSplit(''..countedNumValue, '')
    --[[{0, 0, 0}
    arrayNums[1] = countedNumValue % 100
    arrayNums[2] = countedNumValue % 10
    local unit = countedNumValue
    if unit > 9 then
        unit = 0
    end
    arrayNums[3] = unit]]
    for i=1, #arrayNums do
        removeLuaSprite('numAL'..i)
        makeLuaSprite('numAL'..i, 'num'..arrayNums[i], 870 + (38 * i), 50)
        addLuaSprite('numAL'..i)
        setGraphicSize('numAL'..i, 39, 46)
        setProperty('numAL'..i..'.color', getColorFromHex('a09c9c'))
        setObjectCamera('numAL'..i, 'other')
    end
end

function doEndNums()
    local arrayNums = stringSplit(''..accuracy, '')
    for i=1, #arrayNums do
        local last = #arrayNums - i + 1
        makeLuaSprite('numEL'..i, 'num'..arrayNums[last], -200 - (54 * i), (screenHeight / 2) - 30)
        addLuaSprite('numEL'..i)
        setGraphicSize('numEL'..i, 53, 61)
        setObjectCamera('numEL'..i, 'other')
        doTweenX('numEL'..i, 'numEL'..i, 650 - (54 * i), 1, 'quadOut')
    end

    makeLuaSprite('percent', 'ranking/percent', -202, (screenHeight / 2) - 30)
    addLuaSprite('percent')
    setGraphicSize('percent', 53, 61)
    setObjectCamera('percent', 'other')
    doTweenX('percent', 'percent', 652, 1, 'quadOut')
end

function createGrd(id, startFadeAt, x, y, width, height, inverted)
    local proHeight = height - startFadeAt
    local alpha = 1
    if inverted then alpha = 0 end
    for i=1, height do
        if i > startFadeAt then
            if inverted then 
               alpha = alpha + (1 / proHeight)
            else
                alpha = alpha - (1 / proHeight)
            end
        end

        local tagName = 'grd_g'..id..i

        local yValue = (y -1) + i

        makeLuaSprite(tagName, nil, x, yValue)
        makeGraphic(tagName, width, 1, '000000')
        addLuaSprite(tagName)
        setObjectCamera(tagName, 'other')
        setProperty(tagName..'.alpha', maxMin(alpha, 0, 1))
        setProperty(tagName..'.antialiasing', false) -- prevents lag, i think?
    end
    renderedGrdsH[id] = height
end

function createHorizontalGradient()
    local alpha = 1
    local width = screenWidth / 2 + 200
    for i=1, width do
        alpha = alpha - (1 / width)

        local tagName = 'grd_h'..i

        local xValue = 790

        makeLuaSprite(tagName, nil, xValue, (screenHeight / 2) - 35)
        makeGraphic(tagName, 1, 70, 'FFFFFF')
        addLuaSprite(tagName)
        setObjectCamera(tagName, 'other')
        setProperty(tagName..'.alpha', maxMin(alpha, 0, 1))
        setProperty(tagName..'.visible', false)
    end
end

function createBackdrops()
    for i=1,2 do
        local xValue = 0
        if i == 2 then
            xValue = screenWidth
        end
        makeLuaSprite('backdrop'..i, 'menuDesat', xValue, 0)
        addLuaSprite('backdrop'..i)
        setProperty('backdrop'..i..'.alpha', 0)
        setObjectCamera('backdrop'..i, 'hud')
        setGraphicSize('backdrop'..i, screenWidth, screenHeight)
    end
end

function backdropsIntro()
    for i=1,2 do
        doTweenAlpha('backdrop'..i..'A', 'backdrop'..i, 1, 0.5, 'linear')
    end
end

function updateBackdrops(elapsed)
    for i=1,2 do
        local tag = 'backdrop'..i
        setProperty(tag..'.x', getProperty(tag..'.x') - (1 * backdropVelocity * (elapsed * 120)))

        local backdropCurX = getProperty(tag..'.x')
        if backdropCurX < -screenWidth then
            setProperty(tag..'.x', screenWidth - 2)
        end
        setProperty(tag..'.color', getColorFromHex(bgColors[curRank]))
    end
end

local coveredRange = 1
local enterSpriteV = 0
local enterSpriteT = 0
function onCustomSubstateUpdatePost(name, elapsed)
    if name == 'results' then
        updateBackdrops(elapsed)

        if doLerpNumbers then
            doScoreNums(elapsed)
            doScoreNumsMiss(elapsed)
            if not isStoryMode then
                doScoreNumsCombo(elapsed)
            end
        end
        
    end

    local sWidth = screenWidth / 2 + 200
    if not isStoryMode then
        for i=1, math.floor(elapsed * 5000) do
            if coveredRange < sWidth and numbersFade then
                setProperty('grd_h'..coveredRange..'.x', sWidth - coveredRange)
                setProperty('grd_h'..coveredRange..'.visible', true)
                coveredRange = coveredRange + 1
            end
        end
    end

    if (getMouseX('camHUD') > 508 and getMouseX('camHUD') < 640) and (getMouseY('camHUD') > 588 and getMouseY('camHUD') < 720 and mouseClicked('left')) or keyJustPressed('accept') and isAbleToExit and pressEnter and not enterPressed then
        enterPressed = true
       objectPlayAnimation('a', 'aPress', false);
        playSound('confirmMenu')
        runTimer('exit', 1.5)
    end

    if keyboardJustPressed('T') and debug then
        endSong()
    end

    if keyboardJustPressed('P') and debug then
        score = 1000000
        misses = 100
        highestCombo = 9999
        lerpedCombo = 0
        lerpedMiss = 0
        lerpedScore = 0
    end

    if keyboardJustPressed('O') and debug then
        onFinished()
    end

    if pressEnter then
        if not enterPressed then
            enterSpriteV = enterSpriteV + elapsed
            setProperty('pressenter.alpha', maxMin(0.2 + (0.8 * math.abs(math.sin(enterSpriteV))), 0.2, 1))
        else
            setProperty('pressenter.alpha', 1)
            enterSpriteT = enterSpriteT + elapsed
            if enterSpriteT > 0.06 then
                enterSpriteT = 0
                setProperty('pressenter.visible', not getProperty('pressenter.visible'))
            end
        end
    end
end

function removeGrd(id)
    alpha = 1
    for i=1, renderedGrdsH[id] do
        removeLuaSprite('grd_g'..id..i)
    end
end

function maxMin(v, min, max)
    if v < min then return min
    elseif v > max then return max end
    return v
end

function fakeFloorDec(v, d)
    if d < 1 then
        return math.floor(v)
    end

    local tempMult = 1
    for i = 0,v do
        tempMult = tempMult * 10;
    end
    local newValue = math.floor(v * tempMult);
    return newValue / tempMult;
end

function onUpdatePost()
    if getProperty('combo') > highestCombo then
        highestCombo = getProperty('combo')
    end

    if isStoryMode then
        avgScore = gPFC('campaignScore')
        avgMisses = gPFC('campaignMisses')
    else
        avgScore = score
        avgMisses = misses
        avgCombo = highestCombo
    end
    if debug == true then
        if keyJustPressed('space') then
            addMisses(1)
       end
        if keyboardJustPressed("F") then
        endSong()
        end
    end
end

function lerp(a, b, r)
    return a + r * (b - a);
end

function gPFC(p)
    return getPropertyFromClass('PlayState', p)
end
function getSound()
        if boyfriendName == 'rayo-player' or  boyfriendName == 'sisterPlayable'then
            if avgMisses <= 10 then
                curRank = #rankings
                play("rayoPerfect")
            elseif avgMisses <= 20 then
                curRank = #rankings - 1  -- A
                play("rayoExcellent")
            elseif avgMisses <= 30 then
                curRank = #rankings - 2
                play("rayoGood")
            elseif avgMisses <= 35 then
                curRank = #rankings - 3
                play("rayoGood")
            elseif avgMisses <= 40 then
                curRank = #rankings - 4
                play("rayoLoss")
            elseif avgMisses <= 50 then
                curRank = #rankings - 5
                play("rayoLoss")
            else
                curRank = 1
                play("rayoLoss")
            end
        else
            felixPlays()
        end 
    end
function felixPlays()
    if avgMisses <= 10 then
        curRank = #rankings
        play("felixPerfect")
    elseif avgMisses <= 20 then
        curRank = #rankings - 1  -- A
        play("felixExcellent")
    elseif avgMisses <= 30 then
        curRank = #rankings - 2
        play("felixGood")
    elseif avgMisses <= 35 then
        curRank = #rankings - 3
        play("felixGood")
    elseif avgMisses <= 40 then
        curRank = #rankings - 4
        play("felixShit")
    elseif avgMisses <= 50 then
        curRank = #rankings - 5
        play("felixShit")
    else
        curRank = 1
        play("felixShit")
    end
end

function play(path)
    playSound("results/"..path,0.7,'musicBG');
end
function resultFreePlay()
    if boyfriendName == 'rayo-player' or  boyfriendName == 'sisterPlayable'then
        if accuracy <= 100 then
            curRank = #rankings
            play("rayoPerfect")
        elseif accuracy <= 80 then
            curRank = #rankings - 1  -- A
            play("rayoExcellent")
        elseif accuracy <= 70 then
            curRank = #rankings - 2
            play("rayoGood")
        elseif accuracy <= 60 then
            curRank = #rankings - 3
            play("rayoGood")
        elseif accuracy <= 40 then
            curRank = #rankings - 4
            play("rayoLoss")
        elseif accuracy <= 50 then
            curRank = #rankings - 5
            play("rayoLoss")
        else
            curRank = 1
            play("rayoLoss")
        end
    else
        felix()
    end
end
function felix()
    if accuracy <= 10 then
        curRank = #rankings
        play("felixPerfect")
    elseif accuracy <= 20 then
        curRank = #rankings - 1  -- A
        play("felixExcellent")
    elseif accuracy <= 30 then
        curRank = #rankings - 2
        play("felixGood")
    elseif accuracy <= 35 then
        curRank = #rankings - 3
        play("felixGood")
    elseif accuracy <= 40 then
        curRank = #rankings - 4
        play("felixShit")
    elseif accuracy <= 50 then
        curRank = #rankings - 5
        play("felixShit")
    else
        curRank = 1
        play("felixShit")
    end
end