---@diagnostic disable: lowercase-global, undefined-global

local firstStrumTime = 0
local skippedIntro = false
local allowSkip = false
local startedTween = false

function onCreatePost()
    require("mods/scripts/utility/Object")

    firstStrumTime = getPropertyFromGroup("unspawnNotes", 0, "strumTime")

    Object.text("skipIntro", 0, 0, 0, "Press [SPACE] to skip the intro!", "camHUD", true)
    screenCenter("skipIntro", "x")
    setProperty("skipIntro.y", downscroll and 200 - getProperty("skipIntro.height") or screenHeight - 200)
    setProperty("skipIntro.alpha", 0)
end

function onSongStart()
    allowSkip = true
    doTweenAlpha("skipIntroTweenIN", "skipIntro", 1, 0.25, "linear")
end

function onUpdate(elapsed)
    if keyboardJustPressed("SPACE") and not skippedIntro and allowSkip and getSongPosition() < firstStrumTime - 1000 then
        skippedIntro = true
        cancelTween("skipIntroTweenIN")
        doTweenAlpha("skipIntroTweenOUT", "skipIntro", 0, 0.5, "linear")
        runHaxeCode([[
            game.setSongTime(]] .. firstStrumTime .. [[ - 1000);
        ]])
     
    elseif getSongPosition() > firstStrumTime - 1000 and not startedTween then
        startedTween = true
        cancelTween("skipIntroTweenIN")
        doTweenAlpha("skipIntroTweenOUT", "skipIntro", 0, 0.5, "linear")
    end
    
end

function onTweenCompleted(tag)
    if tag == "skipIntroTweenOUT" then
        removeLuaText("skipIntro")
        close()
    end
end