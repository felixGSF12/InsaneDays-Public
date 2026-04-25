---@diagnostic disable: lowercase-global, undefined-global

local curItem = 1
local allowInteraction = true
local allowEnd = false

local barRatings = {"Sick", "Good", "Bad", "Shit", "Miss", "Sustain Miss"}
local ratingTotal = {
    sick = 0,
    good = 0,
    bad = 0,
    shit = 0,
    miss = 0,
    sustain_miss = 0
}
local totalNotes = 0
local maxBarLength = 0
local realSongLength = 0

-- i have GOT to figure out what these mean (save me kade engine, save me) -Ramen
-- mr kade engine if you ever see this please make variable names self explanatory or add comments pretty please 🥺 -Ramen
local hitGraph = {x = 215, y = 404, width = 1010, height = 262}
local minValue = 0
local maxValue = 0
local ts = 0
local range = 0

function onCreate()
    require("mods/scripts/utility/SongData")
    require("mods/scripts/utility/ClientData")
    require("mods/scripts/utility/Object")
    require("mods/scripts/utility/Misc")
    require("mods/scripts/utility/Math")

    luaDebugMode = getVar("debugMode")

    minValue = -(math.floor(getPropertyFromClass("backend.Conductor", "safeZoneOffset")) + 95)
    maxValue = math.floor(getPropertyFromClass("backend.Conductor", "safeZoneOffset")) + 95
    ts = math.floor(getPropertyFromClass("backend.Conductor", "safeZoneOffset")) / 166 --whats stopping me from just manually entering 1 here?
    range = math.max(maxValue - minValue, maxValue * 0.1)

    Misc.camera("camOptions", 0, 0, screenWidth, screenHeight)
    Object.graphic("resultsFade", 0, 0, screenWidth, screenHeight, "000000")
    setProperty("resultsFade.alpha", 0)
end

function onSongStart()
    realSongLength = songLength -- hits graph bugs out if i dont do this on song start
end

function onUpdate(elapsed)
    if allowInteraction then
        if keyJustPressed("accept") then
             doTweenAlpha("resultsFadeInEnd", "resultsFade", 1, 1, "linear")
            soundFadeOut(nil, 1)
            playSound(ClientData.acceptSound, ClientData.interactVolume)
            allowInteraction = false
            allowEnd = true
        elseif keyJustPressed("ui_left") then
            changeItem(-1)
        elseif keyJustPressed("ui_right") then
            changeItem(1)
        end
    end
end

function onEndSong()
    setProperty("paused", true)
    runHaxeCode([[
        game.inst.stop();
        game.vocals.stop();
        game.opponentVocals.stop();
    ]])

    doTweenAlpha("resultsFadeIn", "resultsFade", 1, 0.5, "linear")

    if not allowEnd then
        return Function_Stop
    end
    if allowEnd then
        return Function_Continue
    end
end

function onTweenCompleted(tag)
    if tag == "resultsFadeIn" then
        removeLuaSprite("resultsFade", false)
        playMusic(ClientData.menuMusic, 0, true)
        soundFadeIn(_, 5, 0, 0.7)

        ClientData.load()
        SongData.load(songName, difficultyName, getVar("totalNotes"), ClientData.data.opponentSide)
        -- debugPrint(#SongData.data)

        Object.sprite("mainBG", "menuDesat", 0, 0)
        screenCenter("mainBG")
        local playerColor = Math.rgbToHex(getProperty("boyfriend.healthColorArray"), true)
        local opponentColor = Math.rgbToHex(getProperty("dad.healthColorArray"), true)
        Object.gradient("mainBGOverlay", 0, 0, screenWidth, screenHeight, playerColor .. ", " .. opponentColor)
        setBlendMode("mainBGOverlay", "multiply")

        Object.sprite("resultsBG", "bg/results", 0, 0)
        setProperty("resultsBG.antialiasing", false)

        createResults()

        addLuaSprite("resultsFade", true)
        doTweenAlpha("resultsFadeOut", "resultsFade", 0, 0.5, "linear")
    elseif tag == "resultsFadeOut" then
        allowInteraction = true
    elseif tag == "resultsFadeInEnd" then
        setProperty("camGame.visible", false)
        setProperty("camHUD.visible", false)
        setProperty("camOther.visible", false)
        endSong()
    end
end

function createResults()
    for note in pairs(SongData.data[curItem].notes) do
        for i = 1, #barRatings do
            if SongData.data[curItem].notes[note].rating == barRatings[i]:lower():gsub(" ", "-") then
                ratingTotal[barRatings[i]:lower():gsub(" ", "_")] = ratingTotal[barRatings[i]:lower():gsub(" ", "_")] + 1
            end
        end
    end

    totalNotes = ratingTotal.sick + ratingTotal.good + ratingTotal.bad + ratingTotal.shit + ratingTotal.miss + ratingTotal.sustain_miss

    --Title Box
    Object.text("songTitle", 609, 39, 0, songName .. " | " .. difficultyName)
    if getProperty("songTitle.width") > 632 then
        scaleObject("songTitle", 632 / getProperty("songTitle.width"), 1)
    end
    setProperty("songTitle.x", getProperty("songTitle.x") + Misc.centerWithin(getProperty("songTitle.width"), 632))
    setProperty("songTitle.y", getProperty("songTitle.y") + Misc.centerWithin(getProperty("songTitle.height"), 42))

    --Bar Graph Box
    for i = 1, #barRatings do
        local curColor = Math.rgbToHex(ClientData.data.colors[barRatings[i]:lower():gsub("sustain ", "")], true)
        Object.graphic("ratingBar-" .. barRatings[i], 55, 55 + ((i - 1) * 50), 500, 30, curColor)
        maxBarLength = getProperty("ratingBar-" .. barRatings[i] .. ".width")

        Object.text("ratingBarName-" .. barRatings[i], 0, 0, maxBarLength, barRatings[i] .. (stringEndsWith(barRatings[i]:lower(), "miss") and "es" or "s"))
        setTextSize("ratingBarName-" .. barRatings[i], 20)
        setTextAlignment("ratingBarName-" .. barRatings[i], "left")
        setProperty("ratingBarName-" .. barRatings[i] .. ".x", getProperty("ratingBar-" .. barRatings[i] .. ".x"))
        setProperty("ratingBarName-" .. barRatings[i] .. ".y", getProperty("ratingBar-" .. barRatings[i] .. ".y") + Misc.centerWithin(getProperty("ratingBarName-" .. barRatings[i] .. ".height"), getProperty("ratingBar-" .. barRatings[i] .. ".height")))

        Object.text("ratingBarValue-" .. barRatings[i], 0, 0, maxBarLength, "0000 | (99.99%)")
        setTextSize("ratingBarValue-" .. barRatings[i], 20)
        setTextAlignment("ratingBarValue-" .. barRatings[i], "right")
        setProperty("ratingBarValue-" .. barRatings[i] .. ".x", getProperty("ratingBarName-" .. barRatings[i] .. ".x"))
        setProperty("ratingBarValue-" .. barRatings[i] .. ".y", getProperty("ratingBarName-" .. barRatings[i] .. ".y"))
    end

    --Hits Box
    Object.text("LateMarker", 215, 405, 0, "Too Late! (+" .. math.floor(getPropertyFromClass("backend.Conductor", "safeZoneOffset")) .. "ms)")
    setTextSize("LateMarker", 20)
    setProperty("LateMarker.alpha", 0.5)
    Object.text("EarlyMarker", 215, 405 + 262, 0, "Too Early! (" .. -math.floor(getPropertyFromClass("backend.Conductor", "safeZoneOffset")) .. "ms)")
    setTextSize("EarlyMarker", 20)
    setProperty("EarlyMarker.y", getProperty("EarlyMarker.y") - getProperty("EarlyMarker.height"))
    setProperty("EarlyMarker.alpha", 0.5)

    Object.graphic("hitWindowSick", 71, 436, 18, 18, Math.rgbToHex(ClientData.data.colors["sick"], true))
    Object.text("hitWindowSickText", getProperty("hitWindowSick.x") + getProperty("hitWindowSick.width") + 5, getProperty("hitWindowSick.y"), 0, "<= 45ms")
    setTextSize("hitWindowSickText", 20)

    Object.graphic("hitWindowGood", getProperty("hitWindowSick.x"), getProperty("hitWindowSick.y") + 90, 18, 18, Math.rgbToHex(ClientData.data.colors["good"], true))
    Object.text("hitWindowGoodText", getProperty("hitWindowGood.x") + getProperty("hitWindowGood.width") + 5, getProperty("hitWindowGood.y"), 0, "<= 90ms")
    setTextSize("hitWindowGoodText", 20)

    Object.graphic("hitWindowBad", getProperty("hitWindowSick.x"), getProperty("hitWindowGood.y") + 90, 18, 18, Math.rgbToHex(ClientData.data.colors["bad"], true))
    Object.text("hitWindowBadText", getProperty("hitWindowBad.x") + getProperty("hitWindowBad.width") + 5, getProperty("hitWindowBad.y"), 0, "<= 135ms")
    setTextSize("hitWindowBadText", 20)

    createJudgementLine(math.floor(getPropertyFromClass("backend.Conductor", "safeZoneOffset")))
    createJudgementLine(135)
    createJudgementLine(90)
    createJudgementLine(45)
    createJudgementLine(0)
    createJudgementLine(-45)
    createJudgementLine(-90)
    createJudgementLine(-135)
    createJudgementLine(-math.floor(getPropertyFromClass("backend.Conductor", "safeZoneOffset")))

    for i = 1, #SongData.data[curItem].notes do
        if SongData.data[curItem].notes.rating ~= "sustain-miss" and SongData.data[curItem].notes[i].hitTime ~= nil then
            local value = (SongData.data[curItem].notes[i].hitTime - minValue) / range
            local pointX = hitGraph.x + (hitGraph.width * (SongData.data[curItem].notes[i].strumTime / songLength))
            Object.graphic("hitMarker-" .. i, pointX, 0, 3, 3 , "FFFFFF")
            setProperty("hitMarker-" .. i .. ".offset.y", getProperty("hitMarker-" .. i .. ".height") / 2)
        end
    end

    --Song Stats Box
    local songStatsBox = {x = 624 + 5, y = 184 + 5, width = 602 - 5, height = 152 - 5}
    local statsSpacing = songStatsBox.height / 4

    Object.text("SongsStatsTextDisplay", 624, 134, 602, "Sample Text")
    setTextSize("SongsStatsTextDisplay", 20)
    setProperty("SongsStatsTextDisplay.y", getProperty("SongsStatsTextDisplay.y") + Misc.centerWithin(getProperty("SongsStatsTextDisplay.height"), 32))

    Object.text("ClearDate", songStatsBox.x, songStatsBox.y + (0 * statsSpacing), 602, "Date Cleared: " .. SongData.data[curItem].song.date)
    setTextSize("ClearDate", 20)
    -- setTextAlignment("ClearDate", "left")
    setProperty("ClearDate.y", getProperty("ClearDate.y") + Misc.centerWithin(getProperty("ClearDate.height"), statsSpacing))

    Object.text("MissType", songStatsBox.x, songStatsBox.y + (1 * statsSpacing), 602, "Sustain Miss Type: " .. SongData.data[curItem].song.missType)
    setTextSize("MissType", 20)
    -- setTextAlignment("MissType", "left")
    setProperty("MissType.y", getProperty("MissType.y") + Misc.centerWithin(getProperty("MissType.height"), statsSpacing))

    Object.text("SongStats", songStatsBox.x, songStatsBox.y + (2 * statsSpacing), 602, "Sample Text")
    setTextSize("SongStats", 20)
    -- setTextAlignment("SongStats", "left")
    setProperty("SongStats.y", getProperty("SongStats.y") + Misc.centerWithin(getProperty("SongStats.height"), statsSpacing))

    Object.text("SongStatsMax", songStatsBox.x, songStatsBox.y + (3 * statsSpacing), 602, "Sample Text")
    setTextSize("SongStatsMax", 20)
    -- setTextAlignment("SongStatsMax", "left")
    setProperty("SongStatsMax.y", getProperty("SongStatsMax.y") + Misc.centerWithin(getProperty("SongStatsMax.height"), statsSpacing))

    changeItem(0)
end

function updateResults()
    ratingTotal.sick = 0
    ratingTotal.good = 0
    ratingTotal.bad = 0
    ratingTotal.shit = 0
    ratingTotal.miss = 0
    ratingTotal.sustain_miss = 0
    totalNotes = 0

    for note in pairs(SongData.data[curItem].notes) do
        for i = 1, #barRatings do
            if SongData.data[curItem].notes[note].rating == barRatings[i]:lower():gsub(" ", "-") then
                ratingTotal[barRatings[i]:lower():gsub(" ", "_")] = ratingTotal[barRatings[i]:lower():gsub(" ", "_")] + 1
            end
        end
    end

    totalNotes = ratingTotal.sick + ratingTotal.good + ratingTotal.bad + ratingTotal.shit + ratingTotal.miss + ratingTotal.sustain_miss


    --Bar Graph Box
    for i = 1, #barRatings do
        scaleObject("ratingBar-" .. barRatings[i], ratingTotal[barRatings[i]:lower():gsub(" ", "_")] / totalNotes, 1)
        setTextString("ratingBarValue-" .. barRatings[i],  ratingTotal[barRatings[i]:lower():gsub(" ", "_")] .. " | (" .. Math.round((ratingTotal[barRatings[i]:lower():gsub(" ", "_")] / totalNotes) * 100, 2) .. "%)")
    end

    --Hits Box
    for i = 1, #SongData.data[curItem].notes do
        if SongData.data[curItem].notes.rating ~= "sustain-miss" and SongData.data[curItem].notes[i].hitTime ~= nil then
            local value = (SongData.data[curItem].notes[i].hitTime - minValue) / range
            local pointY = hitGraph.y + ((-value * hitGraph.height - 1) + hitGraph.height)
            setProperty("hitMarker-" .. i .. ".y", pointY)
            if math.abs(SongData.data[curItem].notes[i].hitTime) <= 45 then
                setProperty("hitMarker-" .. i .. ".color", Math.rgbToHex(ClientData.data.colors["sick"]))
            elseif math.abs(SongData.data[curItem].notes[i].hitTime) <= 90 then
                setProperty("hitMarker-" .. i .. ".color", Math.rgbToHex(ClientData.data.colors["good"]))
            elseif math.abs(SongData.data[curItem].notes[i].hitTime) <= 135 then
                setProperty("hitMarker-" .. i .. ".color", Math.rgbToHex(ClientData.data.colors["bad"]))
            elseif math.abs(SongData.data[curItem].notes[i].hitTime) <= getPropertyFromClass("backend.Conductor", "safeZoneOffset") then
                setProperty("hitMarker-" .. i .. ".color", Math.rgbToHex(ClientData.data.colors["shit"]))
            else
                setProperty("hitMarker-" .. i .. ".color", Math.rgbToHex(ClientData.data.colors["miss"]))
            end
        end
    end

    --Song Stats Box
    setTextString("ClearDate", "Date Cleared: " .. SongData.data[curItem].song.date)

    setTextString("SongsStatsTextDisplay", "< Showing Stats " .. curItem .. " out of " .. #SongData.data .. " >")
    local songStatsString = "Rank: " .. SongData.data[curItem].song.rank
    songStatsString = songStatsString .. " | Score: " .. SongData.data[curItem].song.score
    songStatsString = songStatsString .. " | Accuracy: " .. SongData.data[curItem].song.accuracy
    setTextString("SongStats", songStatsString)

    local songStatsMaxString = "Max Combo: " .. SongData.data[curItem].song.maxCombo
    songStatsMaxString = songStatsMaxString .. " | Max NPS: " .. SongData.data[curItem].song.maxNPS
    setTextString("SongStatsMax", songStatsMaxString)
end

function createJudgementLine(ms) --save me kade engine
    local value = ((ms * ts) - minValue) / range
    local pointX = hitGraph.x
    local pointY = hitGraph.y + ((-value * hitGraph.height - 1) + hitGraph.height)

    Object.graphic("judgementLine-" .. ms, pointX, pointY, hitGraph.width, 1, "FFFFFF")
    setProperty("judgementLine-" .. ms .. ".alpha", 0.5)
    if math.abs(ms) == 0 then
        setProperty("judgementLine-" .. ms .. ".color", Math.rgbToHex(ClientData.data.colors["sick"]))
    elseif math.abs(ms) == 45 then
        setProperty("judgementLine-" .. ms .. ".color", Math.rgbToHex(ClientData.data.colors["good"]))
    elseif math.abs(ms) == 90 then
        setProperty("judgementLine-" .. ms .. ".color", Math.rgbToHex(ClientData.data.colors["bad"]))
    elseif math.abs(ms) == 135 then
        setProperty("judgementLine-" .. ms .. ".color", Math.rgbToHex(ClientData.data.colors["shit"]))
    else
        setProperty("judgementLine-" .. ms .. ".color", Math.rgbToHex(ClientData.data.colors["miss"]))
    end
end

function changeItem(change)
    if change ~= 0 then
        playSound(ClientData.scrollSound, ClientData.interactVolume)
    end

    curItem = curItem + change
    if curItem > #SongData.data then
        curItem = 1
    elseif curItem < 1 then
        curItem = #SongData.data
    end

    updateResults()
end
