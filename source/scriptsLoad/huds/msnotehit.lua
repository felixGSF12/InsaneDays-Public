local a1 = 0.254829592;
local a2 = -0.284496736;
local a3 = 1.421413741;
local a4 = -1.453152027;
local a5 = 1.061405429;
local p = 0.3275911;
local curTotalNotesHit = 0
local counterUpdated = 0
local actualRatingHere = 0.00
local msDiffTimeLimit = 1200 
local lastMsShowUp = 0
local msTextVisible = false
local isPixel = false

function onCreatePost()
    if getPropertyFromClass('PlayState', 'isPixelStage') then 
        setTextFont('msTxt', 'PixeloidMono.ttf')
		isPixel = true
	end

    addLuaText('funnikade')
	addLuaText('oldScore')

    setObjectOrder('oldScore', 40)
    setObjectOrder('funnikade', 40)

    setObjectCamera('oldScore','hud')
	setObjectCamera('funnikade','hud')

	if getPropertyFromClass('ClientPrefs', 'downScroll') == false then
	setProperty('oldScore.y', 680)
	elseif getPropertyFromClass('ClientPrefs', 'downScroll') == true then
	setProperty('oldScore.y', 130)
    end
    setProperty('grpNoteSplashes.visible', true)

    setProperty('msTxt.y', getProperty('comboTxt.y')+190);
    screenCenter('msTxt', 'x')
end
function onCreate()
    makeLuaText('msTxt', ' ', 0, 540, 360)
    setTextSize('msTxt', 17)
    setTextBorder('msTxt', 2, '000000')
    setTextFont('msTxt', 'vcr.ttf')
    addLuaText('msTxt')
    




    end

function onUpdatePost(elapsed)
    if getPropertyFromClass('PlayState', 'isPixelStage') then 
		isPixel = true
	end

    local curSongPosRightNow = getPropertyFromClass('Conductor', 'songPosition')
    if curSongPosRightNow - lastMsShowUp > msDiffTimeLimit and msTextVisible then
        removeLuaText('msTxt', false)
        setTextString('msTxt', '')
        addLuaText('msTxt')
        msTextVisible = false
    end
    if ratingName == ' ' then
        local beforeScoreTxt = ' '
        setTextString('oldScore', beforeScoreTxt)
    else
        local ratingNameM = getProperty('ratingFC')

        if ratingNameM == ' ' then
            ratingNameM = '  '
        end
        local ratingFull = math.max(actualRatingHere * 100, 0)
        local ratingFullAsStr = string.format("%.2f", ratingFull)

        local tempRatingNameVery = accuracyToRatingString(ratingFull)
        -- we can assert that ratingdec
        local finalScoreTxt = ' '
		setTextString('oldScore', finalScoreTxt)
    end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    if not isSustainNote then
        strumTime = getPropertyFromGroup('notes', id, 'strumTime')
        songPos = getPropertyFromClass('Conductor', 'songPosition')
        rOffset = getPropertyFromClass('ClientPrefs','ratingOffset')
        updateAccuracy(strumTime, songPos, rOffset)
    end
end



function updateAccuracy(strumTime, songPos, rOffset) -- HELPER FUNCTION
    local noteDiffSign = strumTime - songPos + rOffset
    local noteDiffAbs = math.abs(noteDiffSign)
    local totalNotesForNow = handleNoteDiff(noteDiffAbs)
    showMsDiffOnScreen(noteDiffSign)
    curTotalNotesHit = curTotalNotesHit + totalNotesForNow
    counterUpdated = counterUpdated + 1
end


function showMsDiffOnScreen(diff) 
    setProperty('msTxt.alpha', 1)
    removeLuaText('msTxt', false)
    local msDiffStr = string.format("%.3fms", -diff)
    -- debugPrint(msDiffStr)
    local textColor = ratingTextColor(diff)
    setTextColor('msTxt', textColor)
    setTextString('msTxt', msDiffStr)
    if diff > 399 then
        setTextString('msTxt', '')
    end

    addLuaText('msTxt')

    doTweenAlpha('msTxtGONE', 'msTxt', 0, 0.5, 'circInOut')

    lastMsShowUp =  getPropertyFromClass('Conductor', 'songPosition')
    msTextVisible = true
end


function ratingTextColor(diff)
    local absDiff = math.abs(diff)
    
    if absDiff < 46.0 then
        return '00FFFF'
    elseif absDiff < 91.0 then
        return '008000'
    else
        return 'FF0000'
    end
end



function cancelExistingJudgements(diff) -- HELPER FUNCTION
    if diff < 46.0 then
        return 1.0
    elseif diff < 91.0 then
        return 0.75
    elseif diff < 136.0 then
        return 0.5
    else
        return 0.0
    end
end


function handleNoteDiff(diff)
    local maxms = diff
    local ts = 1

    local max_points = 1.0;
    local miss_weight = -1.0;
    local ridic = 5 * ts;
    local max_boo_weight = 166
    local ts_pow = 0.75;
    local zero = 65 * ts^ts_pow
    local power = 2.5;
    local dev = 22.7 * ts^ts_pow

    if (maxms <= ridic) then
        return max_points
    elseif (maxms <= zero) then 
        return max_points * erf((zero - maxms) / dev)
    elseif (maxms <= max_boo_weight) then
        return (maxms - zero) * miss_weight / (max_boo_weight - zero)
    else
        return miss_weight
    end
end

function erf(x)
    local sign = 1;
    if (x < 0) then
        sign = -1;
    end
    x = math.abs(x);
    local t = 1.0 / (1.0 + p * x);
    local y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * math.exp(-x * x);

    return sign * y;
end

function noteMissPress(direction)
    updateAccuracy(400, 0, 0)
end

function noteMiss(id, direction, noteType, isSustainNote)
    updateAccuracy(400, 0, 0)
end


