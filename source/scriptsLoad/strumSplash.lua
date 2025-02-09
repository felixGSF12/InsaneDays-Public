---@diagnostic disable

function onCreatePost()
    splash = getPropertyFromClass("ClientPrefs", "noteSplashes", false)
    posY =  getPropertyFromGroup('playerStrums', 3, 'y')
    if splash == true then
        for i = 0,3 do 
                posXP = getPropertyFromGroup('playerStrums', 0, 'x')
    posXB = getPropertyFromGroup('playerStrums', 1, 'x')
    posXG = getPropertyFromGroup('playerStrums', 2, 'x')
    posXR = getPropertyFromGroup('playerStrums', 3, 'x')
    
        makeAnimatedLuaSprite("red", "holdCoverRed", posXR-107, posY-80)
        addAnimationByPrefix("red", "push", "holdCoverRed", 24, false)
        makeAnimatedLuaSprite("purple", "holdCoverPurple", posXP-107, posY-80)
        addAnimationByPrefix("purple", "idle", "holdCoverPurple0", 24, false)
        makeAnimatedLuaSprite("blue", "blueShit", posXB-107, posY-80)
        addAnimationByPrefix("blue", "push", "holdCoverBlue", 24, false)
        makeAnimatedLuaSprite("green", "holdCoverGreen", posXG-107, posY-80)
        addAnimationByPrefix("green", "push", "holdCoverGreen", 24, false)

        setProperty("red.visible", false)
        setProperty("purple.visible", false)
        setProperty("blue.visible", false)
        setProperty("green.visible", false)

        addLuaSprite("red", true)
        addLuaSprite("purple", true)
        addLuaSprite("blue", true)
        addLuaSprite("green", true)
    end
end
end
function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if splash == true then
        if noteData == 0 and isSustainNote == true then
            setProperty("purple.visible", true)
            objectPlayAnimation("purple", "idle", true)
            runTimer("byePurple", 0.56)
        elseif noteData == 2 and isSustainNote == true then
            setProperty("green.visible", true)
            objectPlayAnimation("green", "push", true)
            runTimer("byeGreen", 0.56)
        elseif noteData == 1 and isSustainNote == true then
            setProperty("blue.visible", true)
            objectPlayAnimation("blue", "push", true)
            runTimer("byeBlue", 0.56)
        elseif noteData == 3 and isSustainNote == true then
            setProperty("red.visible", true)
            objectPlayAnimation("red", "push", true)
            runTimer("byeRed", 0.56)
        end
    end
end

function onTimerCompleted(tag)
    if tag == "byePurple" then
        setProperty("purple.visible", false)
    end
    if tag == "byeBlue" then
        setProperty("blue.visible", false)
    end
    if tag == "byeGreen" then
        setProperty("green.visible", false)
    end
    if tag == "byeRed" then
        setProperty("red.visible", false)
    end
end

function onUpdate(elapsed)
    local isPixel = getPropertyFromClass("PlayState","isPixelStage")
    setObjectCamera("purple", 'hud')
    setObjectCamera("green", 'hud')
    setObjectCamera("blue", 'hud')
    setObjectCamera("red", 'hud')
    if isPixel == true then
        removeLuaSprite("red",true);
        removeLuaSprite("blue",true);
        removeLuaSprite("green",true);
        removeLuaSprite("purple",true);
    end
    for i = 0,3 do 
       local newPos0 = getPropertyFromGroup('playerStrums', 0, 'x', defaultPlayerStrumX0);
       local newPos1 =getPropertyFromGroup('playerStrums', 1, 'x', defaultPlayerStrumX1);
       local newPos2 = getPropertyFromGroup('playerStrums', 2, 'x', defaultPlayerStrumX2);
       local newPos3 = getPropertyFromGroup('playerStrums', 3, 'x', defaultPlayerStrumX3);

       setProperty("red.x",newPos3 - 107)
       setProperty("blue.x",newPos1 - 107)
       setProperty("purple.x",newPos0 - 107)
       setProperty("green.x",newPos2 - 107)
end
for i = 0,3 do
    local newPos0y = getPropertyFromGroup('playerStrums', 0, 'y', defaultPlayerStrumY0);
    local newPos1y =getPropertyFromGroup('playerStrums', 1, 'y', defaultPlayerStrumY1);
    local newPos2y = getPropertyFromGroup('playerStrums', 2, 'y', defaultPlayerStrumY2);
    local newPos3y = getPropertyFromGroup('playerStrums', 3, 'y', defaultPlayerStrumY3);
    setProperty("red.y",newPos3y - 80)
    setProperty("blue.y",newPos1y - 80)
    setProperty("purple.y",newPos0y - 80)
    setProperty("green.y",newPos2y - 80)
end
end