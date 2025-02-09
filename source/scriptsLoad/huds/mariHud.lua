

ratingFCActivate = false
scaleNum = 1
removeScore = false;
songList = {'Exmilix'}
function createText(tag, text, width, x, y, size, align)
    makeLuaText(tag, text, width, x, y)
    setTextSize(tag, size)
    setTextAlignment(tag, align)
    addLuaText(tag)
end

function onCreatePost()
local down = getPropertyFromClass("ClientPrefs", "downScroll",true)
    msX = 800
    msY = 400
    if down == false then
    setProperty("iconP1.y",630)
    setProperty("iconP1.x",670)
    setObjectOrder("iconP1", getObjectOrder("Health")+2)
    setProperty("iconP2.y",610)
    setProperty("iconP2.x",590)
    setObjectOrder("iconP2", getObjectOrder("Health")+2)
    else
        setProperty("iconP1.y",50)
        setObjectOrder("iconP1", getObjectOrder("Health")+2)
        setObjectOrder("iconP2", getObjectOrder("Health")+2)
        setProperty("iconP2.y",50)
    end
    setProperty('scoreTxt.visible', false)
    setProperty('timeTxt.visible', false)
 --   setProperty('timeTxt.y', 600)

    --customizing the timeba
    setProperty('timeBar.y', getProperty('timeBar.y') + 50 )
    setProperty('timeBarBG.y', getProperty('timeBarBG.y') + 50)
    setProperty('timeBar.scale.x', 0.44)
    setProperty('timeBarBG.scale.x', 0.45)

    --creating properties
    createText('scoreTxt', '', 1000, getProperty('healthBar.x') - 205, getProperty('healthBar.y') + 50, 18, 'center')
    createText('timeTxt', '', 500, 385, 100, 28, 'center')
    createText('ratings', '', 600, 330, 20, 18, 'center')
    if songName == songList[1] then
    createText('watermark', songName .. ' - ' .. 'normal' .. ' - ' .. 'PE ' .. version, 1000, 275, 0, 15, 'right')
    else
        createText('watermark', songName .. ' - ' .. difficultyName .. ' - ' .. 'PE ' .. version, 1000, 275, 0, 15, 'right')
    end
    createText('msTiming', 'bruh', 500, msX, msY, 24, 'center')

 screenCenter('scoreTxt', 'X')
    screenCenter('ratings', 'X')

    --editing things that aren't a part of createText
    setProperty('watermark.alpha', 0.65)
    --for da song start tween
    setProperty('timeTxt.alpha', 0)
    setProperty('ratings.alpha', 0)

    --msTiming alpha
    setProperty('msTiming.alpha', 0)

    --for rating square compatability
    if checkFileExists('scripts/rating_squares.lua') then
        removeLuaText('ratings')
    end

    if hideTime then
        removeLuaText('timeTxt', true)
    end

    --DOWNSCROLL IS COOL BUT MAKING ELSEIF STATEMENTS ARE NOT
    if downscroll then
        setProperty('timeTxt.y', 600)
        setProperty('ratings.y', 685)
        setProperty('timeBar.y', getProperty('timeBar.y') - 100 )
        setProperty('timeBarBG.y', getProperty('timeBarBG.y') - 100)
    end

   
end
function onSongStart()
    doTweenAlpha('timeFadeIn', 'timeTxt', 1, 0.25, circIn)
    doTweenAlpha('ratingFadeIn', 'ratings', 1, 0.25, circIn)
   -- setProperty("IconDuo.visible", true)
end

function onUpdatePost()
    
    --timer variables
    --getting song length in seconds
    local  timeElapsed = math.floor(getProperty('songTime')/1000)
    local  timeTotal = math.floor(getProperty('songLength')/1000)
   -- setObjectOrder('scoreTxt',getObjectOrder('iconP1')-2)
    --setObjectOrder('scoreTxt',getObjectOrder('iconP2')-2)
   -- setProperty('IconDuo.x', getProperty('iconP1.x') + 0) 
   -- setProperty('IconDuo.y',550)
    --timeTxt updates (string.format puts it into mm:ss format)
    if songName == "Thats all Folks" then
        setTextString('timeTxt', string.format("%.2d:%.2d", timeElapsed/60%60, timeElapsed%60) .. '/' ..'???')
    else

    setTextString('timeTxt', string.format("%.2d:%.2d", timeElapsed/60%60, timeElapsed%60) .. '/' .. string.format("%.2d:%.2d", timeTotal/60%60, timeTotal%60))
    end
    --scoreTxt updates
    if ratingFCActivate == false then
        setTextString('scoreTxt', 'Score: ' .. score .. ' | ' .. 'Combo Breaks: ' .. getProperty('songMisses') .. ' | ' .. 'Accuracy: ' .. string.format("%.2f%%", rating * 100) .. ' ' .. '(?)')
    else
        setTextString('scoreTxt', 'Score: ' .. score .. ' | ' .. 'Misses: ' .. getProperty('songMisses') .. ' | ' .. 'Accuracy: ' .. string.format("%.2f%%", rating * 100) .. ' ' .. '(' .. getProperty('ratingFC') .. ')')
    end

    --rating updates
    setTextString('ratings', 'Sicks: ' .. getProperty('sicks') .. ' | ' .. 'Goods: ' .. getProperty('goods') .. ' | ' .. 'Bads: ' .. getProperty('bads') .. ' | ' .. 'Shits: ' .. getProperty('shits'))

    if (botPlay and downscroll or removeScore == true) then
        setProperty('scoreTxt.visible', false)
        setProperty('ratings.visible', false)
        setProperty('botplayTxt.y', getProperty('timeTxt.y') + 60)
    elseif (botPlay or removeScore == true) then
        setProperty('scoreTxt.visible', false)
        setProperty('ratings.visible', false)
        setProperty('botplayTxt.y', getProperty('timeTxt.y') - 60)
    end

    --text bump
    while scaleNum >= 1 and scoreZoom do
        setProperty('scoreTxt.scale.y', scaleNum)
        setProperty('scoreTxt.scale.x', scaleNum)
        setProperty('msTiming.scale.y', scaleNum)
        setProperty('msTiming.scale.x', scaleNum)
        scaleNum = scaleNum - 0.005
        wait(0.1)
    end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    ratingFCActivate = true
end
function noteMiss(id, direction, noteType, isSustainNote)
    ratingFCActivate = true
end