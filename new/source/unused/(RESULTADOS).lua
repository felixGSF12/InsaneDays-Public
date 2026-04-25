local allowEnd = false

local storyPlaylistLength
function onEndSong()
    storyPlaylistLength = gPFC('storyPlaylist.length')
    --debugPrint(storyPlaylistLength)
    if not isStoryMode or (isStoryMode and storyPlaylistLength == 1) then
        if not allowEnd then
            sPFC('campaignScore', gPFC('campaignScore') + score)
            sPFC('campaignMisses', gPFC('campaignMisses') + misses)
            doTransition()
            storyPlaylistLength = storyPlaylistLength - 1
            return Function_Stop
        else
            sPFC('campaignScore', gPFC('campaignScore') - score)
            sPFC('campaignMisses', gPFC('campaignMisses') - misses)
        end
    end
end

local closing = false
local dontKeepClosing = false
function doTransition()
    local h = 500

    makeLuaSprite('black', nil, 0, -(screenHeight + h))
    makeGraphic('black', screenWidth, screenHeight, '000000')
    addLuaSprite('black')
    setObjectCamera('black', 'other')

    createGrd(0, -h, screenWidth, h, false)

    local dur = 1
    for i = 1, h do
        doTweenY('grd'..i..'twn', 'grd'..i, (screenHeight + i) - 1, dur, 'linear') end
        
    doTweenY('blacktwn', 'black', 0, dur, 'linear')
    runTimer('blackTweenEnd', dur)
end

function onTimerCompleted(name)
    if name == 'blackTweenEnd' then
        closing = true
        soundFadeOut('', 1, 0)
        runTimer('open', 1)
    end
  
    if name == 'open' then
        for i = 1, 220 do
            setProperty('grd'..i..'.visible', false)
        end
        setProperty('black.visible', false)
        openCustomSubstate('results')
        allowEnd = true
   
end
end
function onPause()
    if closing then return Function_Stop end
end

function createGrd(x, y, width, height, inverted)
    local alpha = 1
    for it=1, height do
        alpha = alpha - (1 / height)

        local tagName = 'grd'..it
        local yV = (y + it) - 1

        makeLuaSprite(tagName, nil, x, yV)
        makeGraphic(tagName, width, 1, '000000')
        addLuaSprite(tagName)
        setObjectCamera(tagName, 'other')
        setProperty(tagName..'.alpha', alpha)
        setProperty(tagName..'.antialiasing', false) -- prevents lag, i think?
    end
end

function onUpdatePost(e)
    if closing then
        setProperty('vocals.volume', getProperty('vocals.volume') - e)
    end
end

function gPFC(p)
    return getPropertyFromClass('states.PlayState', p)
end

function sPFC(p, v)
    return setPropertyFromClass('states.PlayState', p, v)
end