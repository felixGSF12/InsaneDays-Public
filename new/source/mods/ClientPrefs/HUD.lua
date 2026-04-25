---@diagnostic disable: lowercase-global, undefined-global

local customStats = {
    curCombo = 0,
    maxCombo = 0,
    curNPS = 0,
    maxNPS = 0,
    accuracy = 0
}

function onCreate()
    require("mods/scripts/utility/ClientData")
    require("mods/scripts/utility/Object")
    require("mods/scripts/utility/Misc")
    require("mods/scripts/utility/Math")

    ClientData.load()

    luaDebugMode = getVar("debugMode")
end

function onCreatePost()
     if getPropertyFromClass('backend.ClientPrefs','data.timings') == true then
        Object.text("hitTimingText", 0, 0, getPropertyFromGroup("playerStrums", 0, "width") * 4, "", "camHUD", false)
        setTextSize("hitTimingText", 30)
        setProperty("hitTimingText.y", downscroll and 0 or getPropertyFromGroup("playerStrums", 0, "y") + 150)
    end
    if getPropertyFromClass('backend.ClientPrefs','data.underlays') ~= 'Disabled' then
        
        local strumGap = (getPropertyFromGroup("opponentStrums", 1, "x") - getPropertyFromGroup("opponentStrums", 0, "x")) - getPropertyFromGroup("opponentStrums", 0, "width")
        for i = 0, 3 do
               if getPropertyFromClass('backend.ClientPrefs','data.underlays')  == "OPPONENT" or getPropertyFromClass('backend.ClientPrefs','data.underlays')  == "All" then
                Object.graphic("opponentUnderlay-" .. i, getPropertyFromGroup("opponentStrums", i, "x"), 0, getPropertyFromGroup("opponentStrums", i, "width") + strumGap, screenHeight, "000000", "camHUD", false)
                setProperty("opponentUnderlay-" .. i .. ".x", getPropertyFromGroup("opponentStrums", i, "x") + Misc.centerWithin(getProperty("opponentUnderlay-" .. i .. ".width"), getPropertyFromGroup("opponentStrums", i, "width")))
                setProperty("opponentUnderlay-" .. i .. ".alpha",getPropertyFromClass('backend.ClientPrefs','data.underlayAlpha'))
                addToGroup("uiGroup", "opponentUnderlay-" .. i, 0)
            end
            if getPropertyFromClass('backend.ClientPrefs','data.underlays') == "Player" or getPropertyFromClass('backend.ClientPrefs','data.underlays') == "All"  then
                Object.graphic("playerUnderlay-" .. i, getPropertyFromGroup("playerStrums", i, "x"), 0, getPropertyFromGroup("playerStrums", i, "width") + strumGap, screenHeight, "000000", "camHUD", false)
                setProperty("playerUnderlay-" .. i .. ".x", getPropertyFromGroup("playerStrums", i, "x") + Misc.centerWithin(getProperty("playerUnderlay-" .. i .. ".width"), getPropertyFromGroup("playerStrums", i, "width")))
               setProperty("playerUnderlay-" .. i .. ".alpha", getPropertyFromClass('backend.ClientPrefs','data.underlayAlpha'))
                addToGroup("uiGroup", "playerUnderlay-" .. i, 0)
                
            end
        end
    end
    if getPropertyFromClass('backend.ClientPrefs','data.judgement') ~= 'Disabled' then
        local ratings = {"Sick", "Good", "Bad", "Shit", "Miss"}
        local textWidth = 170
        for i = 1, #ratings do
            Object.text("judgementTag-".. ratings[i], 0, 0, textWidth, ratings[i] .. (ratings[i] == "Miss" and "es" or "s") .. ":", "camHUD", false)
            setTextAlignment("judgementTag-".. ratings[i], "left")
            setTextColor("judgementTag-".. ratings[i], Math.rgbToHex(ClientData.data.colors[ratings[i]:lower()], true))

            local objectSize = getProperty("judgementTag-".. ratings[i] .. ".height")
            local sizeTotal = objectSize * #ratings
            setProperty("judgementTag-" .. ratings[i] .. ".x", getPropertyFromClass('backend.ClientPrefs','data.judgement') == "LEFT" and 10 or (screenWidth - textWidth) - 10)
            setProperty("judgementTag-" .. ratings[i] .. ".y", Misc.centerWithin(sizeTotal, screenHeight) + ((i - 1) * objectSize))

            Object.text("judgementValue-" .. ratings[i], getProperty("judgementTag-" .. ratings[i] .. ".x"), getProperty("judgementTag-" .. ratings[i] .. ".y"), getProperty("judgementTag-" .. ratings[i] .. ".width"), "0", "camHUD", false)
            setTextAlignment("judgementValue-".. ratings[i], "right")
        end
    end
end

function onUpdate(elapsed)
    if customStats.curNPS > 0 then
        customStats.curNPS = customStats.curNPS - (customStats.curNPS * elapsed)
        onUpdateScore()
    elseif customStats.curNPS <= 0 then
        customStats.curNPS = 0
    end
    if ClientData.data.showHitTimings then
        setProperty("hitTimingText.x", getPropertyFromGroup("playerStrums", 0, "x"))
    end
    if getPropertyFromClass('backend.ClientPrefs','data.underlays') ~= 'Disabled' then
        for i = 0, getProperty("playerStrums.length") - 1 do
            if getPropertyFromClass('backend.ClientPrefs','data.underlays') == "OPPONENT" or getPropertyFromClass('backend.ClientPrefs','data.underlays') == "ALL" then
                setProperty("opponentUnderlay-" .. i .. ".x", getPropertyFromGroup("opponentStrums", i, "x"))
            end
            if getPropertyFromClass('backend.ClientPrefs','data.underlays') == "PLAYER" or getPropertyFromClass('backend.ClientPrefs','data.underlays') == "ALL" then
                setProperty("playerUnderlay-" .. i .. ".x", getPropertyFromGroup("playerStrums", i, "x"))
            end
        end
    end
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    local strumTime = getPropertyFromGroup("notes", membersIndex, "strumTime")
    local songPosition = getPropertyFromClass("backend.Conductor", "songPosition")
    local playerOffset = getPropertyFromClass("backend.ClientPrefs","data.ratingOffset")
    local ms = strumTime - songPosition + playerOffset

    if not isSustainNote then
        customStats.curCombo = customStats.curCombo + 1
        customStats.curNPS = customStats.curNPS + 1
        if customStats.curCombo > customStats.maxCombo then
            customStats.maxCombo = customStats.maxCombo + 1
        end
        if customStats.curNPS > customStats.maxNPS then
            customStats.maxNPS = customStats.maxNPS + 1
        end

        if ClientData.data.showHitTimings then
            cancelTween("hitTimingTween")
            cancelTimer("hitTimingTimer")
            runTimer("hitTimingTimer", 0.3)
            setProperty("hitTimingText.alpha", 0.7)
            setTextColor("hitTimingText", Math.rgbToHex(ClientData.data.colors[getPropertyFromGroup("notes", membersIndex, "rating")], true))
            setTextString("hitTimingText", Math.round(ms * -1, 2) .. "ms")
        end
    end
end

function noteMiss(membersIndex, noteData, noteType, isSustainNote)
    customStats.curCombo = 0
end

function onUpdateScore(miss)
    local ratings = {"Sick", "Good", "Bad", "Shit", "Miss"}
    local realRatings = {
        getProperty("ratingsData[0].hits"), -- sicks
        getProperty("ratingsData[1].hits"), -- goods
        getProperty("ratingsData[2].hits"), -- bads
        getProperty("ratingsData[3].hits"), -- shits
        getProperty("songMisses")
    }
    if ClientData.data.showJudgements then
        for i = 1, #ratings do
            if luaTextExists("judgementValue-" .. ratings[i]) then -- lua debug error message lol
                setTextString("judgementValue-" .. ratings[i], realRatings[i])
            end
        end
    end

    local scoreTextNew = ""
    if not botPlay then
        customStats.accuracy = Math.round(rating * 100, 2)
        scoreTextNew = "Score: " .. score
        if ClientData.data.showNPS then
            scoreTextNew = scoreTextNew .. " | NPS: " .. math.floor(customStats.curNPS) .. " (" .. customStats.maxNPS .. ")"
        end
        if ClientData.data.showCombo then
            scoreTextNew = scoreTextNew .. " | Combo: " .. customStats.curCombo .. " (" .. customStats.maxCombo .. ")"
        end
        scoreTextNew = scoreTextNew .. " | Misses: " .. misses .. " | Rating: [" .. (ratingFC == "" and "N/A" or ratingFC) .. "] - (" .. customStats.accuracy .. "%)"
    else
        scoreTextNew = "[Botplay!]"
        if ClientData.data.showNPS then
            scoreTextNew = scoreTextNew .. " | NPS: " .. math.floor(customStats.curNPS) .. " (" .. customStats.maxNPS .. ")"
        end
        if ClientData.data.showCombo then
            scoreTextNew = scoreTextNew .. " | Combo: " .. customStats.curCombo .. " (" .. customStats.maxCombo .. ")"
        end
    end

    setVar("accuracy", customStats.accuracy)
    setVar("maxCombo", customStats.maxCombo)
    setVar("maxNPS", math.floor(customStats.maxNPS))

    setTextString("scoreTxt", scoreTextNew)
    setTextSize("scoreTxt", ClientData.data.showNPS and 18 or ClientData.data.showCombo and 18 or 20)
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "hitTimingTimer" then
        doTweenAlpha("hitTimingTween", "hitTimingText", 0, 0.5, "linear")
    end
end

function onEndSong()
    close()
end
