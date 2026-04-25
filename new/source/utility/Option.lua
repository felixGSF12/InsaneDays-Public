---@diagnostic disable: lowercase-global, undefined-global, duplicate-set-field
---@funkinScript

--i knew it was gonna be hard but i didnt know it was gonna be like this -Ramen

_G.Option = {}

local secondaryTextSize = 18
local tweenSpeed = 0.1
local tweenEase = "linear"

function Option.create(x, y, tag, displayName, optionType)
    require("mods/" .. modFolder .. "/scripts/utility/MenuObject")
    require("mods/" .. modFolder .. "/scripts/utility/Misc")
    require("mods/" .. modFolder .. "/scripts/utility/OptionsList")

    ClientData.load()

    Option[tag] = {}

    MenuObject.sprite("OptionBG-" .. tag, "bg/option", x, y)
    setProperty("OptionBG-" .. tag .. ".antialiasing", false)
    Option[tag].tag = tag
    Option[tag].width = getProperty("OptionBG-" .. tag .. ".width")
    Option[tag].height = getProperty("OptionBG-" .. tag .. ".height")

    MenuObject.text("OptionName-" .. tag, 0, 0, 0, displayName)
    setProperty("OptionName-" .. tag .. ".x", (x + 5) + Misc.centerWithin(getProperty("OptionName-" .. tag .. ".width"), 422))
    setProperty("OptionName-" .. tag .. ".y", (y + 5) + Misc.centerWithin(getProperty("OptionName-" .. tag .. ".height"), 45))

    if optionType == "bool" then
        MenuObject.sprite("toggleBG-" .. tag, "bg/optionToggle", 0, 0)
        setProperty("toggleBG-" .. tag .. ".antialiasing", false)

        MenuObject.graphic("toggleBar-" .. tag, 0, 0, 202, 27, "FFFFFF")

        MenuObject.text("toggleOFF-" .. tag, 0, 0, 0, "OFF")
        setTextSize("toggleOFF-" .. tag, secondaryTextSize)
        setTextBorder("toggleOFF-" .. tag, 0)
        setProperty("toggleOFF-" .. tag .. ".color", getColorFromHex(ClientData.data[tag] and "FFFFFF" or "000000"))

        MenuObject.text("toggleON-" .. tag, 0, 0, 0, "ON")
        setTextSize("toggleON-" .. tag, secondaryTextSize)
        setTextBorder("toggleON-" .. tag, 0)
        setProperty("toggleON-" .. tag .. ".color", getColorFromHex(ClientData.data[tag] and "000000" or "FFFFFF"))
    elseif optionType == "number" then
        Option[tag].timeHeld = 0
        Option[tag].isEditing = false
        Option[tag].draggingSlider = false

        MenuObject.text("numberValue-" .. tag, 0, 0, 422, ClientData.data[tag] .."%")
        setTextSize("numberValue-" .. tag, secondaryTextSize)
        setTextBorder("numberValue-" .. tag, 0)

        MenuObject.sprite("sliderBG-" .. tag, "bg/optionSlider", 0, 0)
        setProperty("sliderBG-" .. tag .. ".antialiasing", false)

        MenuObject.graphic("sliderBar-" .. tag, 0, 0, 1, 7, "FFFFFF")
        scaleObject("sliderBar-" .. tag, (ClientData.data[tag] / 100) * 324, 1)

        MenuObject.sprite("sliderCursor-" .. tag, "cursors/slider", 0, 0)
        setProperty("sliderCursor-" .. tag .. ".antialiasing", false)
        setProperty("sliderCursor-" .. tag .. ".offset.x", getProperty("sliderCursor-" .. tag .. ".width") / 2)

        MenuObject.sprite("leftArrow-" .. tag, "misc/arrow", 0, 0)
        setProperty("leftArrow-" .. tag .. ".antialiasing", false)

        MenuObject.sprite("rightArrow-" .. tag, "misc/arrow", 0, 0)
        setProperty("rightArrow-" .. tag .. ".antialiasing", false)
        setProperty("rightArrow-" .. tag .. ".flipX", true)
    elseif optionType == "list" then -- why the fuck was this the hardest one to do what the hell
        Option[tag].isEditing = false

        MenuObject.text("listValue-" .. tag, 0, 0, 422, ClientData.data[tag])
        setTextSize("listValue-" .. tag, secondaryTextSize)
        setTextBorder("listValue-" .. tag, 0)

        for i = 1, #OptionsList[tag].list do
            MenuObject.graphic("listMarker-" .. tag .. i, 0, 0, 12, 1, "FFFFFF")
            scaleObject("listMarker-" .. tag .. i, 1, Misc.indexOf(OptionsList[tag].list, ClientData.data[tag]) == i and 9 or 3, false)
            setProperty("listMarker-" .. tag .. i .. ".color", getColorFromHex(Misc.indexOf(OptionsList[tag].list, ClientData.data[tag]) == i and "FFFFFF" or "808080"))
        end

        MenuObject.sprite("leftArrow-" .. tag, "misc/arrow", 0, 0)
        setProperty("leftArrow-" .. tag .. ".antialiasing", false)

        MenuObject.sprite("rightArrow-" .. tag, "misc/arrow", 0, 0)
        setProperty("rightArrow-" .. tag .. ".antialiasing", false)
        setProperty("rightArrow-" .. tag .. ".flipX", true)
    end
end

function Option.move(tag, x, y)
    setProperty("OptionBG-" .. tag .. ".x", x)
    setProperty("OptionBG-" .. tag .. ".y", y)
    setProperty("OptionName-" .. tag .. ".x", (x + 5) + Misc.centerWithin(getProperty("OptionName-" .. tag .. ".width"), 422))
    setProperty("OptionName-" .. tag .. ".y", (y + 5) + Misc.centerWithin(getProperty("OptionName-" .. tag .. ".height"), 45))

    if OptionsList[tag].type == "bool" then
        setProperty("toggleBG-" .. tag .. ".x", (x + 432) + Misc.centerWithin(getProperty("toggleBG-" .. tag .. ".width"), 422))
        setProperty("toggleBG-" .. tag .. ".y", (y + 5) + Misc.centerWithin(getProperty("toggleBG-" .. tag .. ".height"), 45))

        setProperty("toggleBar-" .. tag .. ".x", ClientData.data[tag] and getProperty("toggleBG-" .. tag .. ".x") + 4 + getProperty("toggleBar-" .. tag .. ".width") or getProperty("toggleBG-" .. tag .. ".x") + 4)
        setProperty("toggleBar-" .. tag .. ".y", getProperty("toggleBG-" .. tag .. ".y") + 4)

        setProperty("toggleOFF-" .. tag .. ".x", getProperty("toggleBG-" .. tag .. ".x") + Misc.centerWithin(getProperty("toggleOFF-" .. tag .. ".width"), 202))
        setProperty("toggleOFF-" .. tag .. ".y", (getProperty("toggleBG-" .. tag .. ".y") + 4) + Misc.centerWithin(getProperty("toggleOFF-" .. tag .. ".height"), 27))

        setProperty("toggleON-" .. tag .. ".x", (getProperty("toggleBG-" .. tag .. ".x") + 202) + Misc.centerWithin(getProperty("toggleON-" .. tag .. ".width"), 202))
        setProperty("toggleON-" .. tag .. ".y", (getProperty("toggleBG-" .. tag .. ".y") + 4) + Misc.centerWithin(getProperty("toggleON-" .. tag .. ".height"), 27))
    elseif OptionsList[tag].type == "number" then
        setProperty("numberValue-" .. tag .. ".x", (x + 432) + Misc.centerWithin(getProperty("numberValue-" .. tag .. ".width"), 422))
        setProperty("numberValue-" .. tag .. ".y", y + 8)

        setProperty("sliderBG-" .. tag .. ".x", (x + 432) + Misc.centerWithin(getProperty("sliderBG-" .. tag .. ".width"), 422))
        setProperty("sliderBG-" .. tag .. ".y", ((y + getProperty("OptionBG-" .. tag .. ".height")) - getProperty("sliderBG-" .. tag .. ".height")) - 10)

        setProperty("sliderBar-" .. tag .. ".x", getProperty("sliderBG-" .. tag .. ".x") + 4)
        setProperty("sliderBar-" .. tag .. ".y", getProperty("sliderBG-" .. tag .. ".y") + 4)

        setProperty("sliderCursor-" .. tag .. ".x", getProperty("sliderBar-" .. tag .. ".x") + getProperty("sliderBar-" .. tag .. ".scale.x"))
        setProperty("sliderCursor-" .. tag .. ".y", getProperty("sliderBar-" .. tag .. ".y") + Misc.centerWithin(getProperty("sliderCursor-" .. tag .. ".height"), getProperty("sliderBar-" .. tag .. ".height")))

        setProperty("leftArrow-" .. tag .. ".x", x + 438)
        setProperty("leftArrow-" .. tag .. ".y", y + Misc.centerWithin(getProperty("leftArrow-" .. tag .. ".height"), getProperty("OptionBG-" .. tag .. ".height")))

        setProperty("rightArrow-" .. tag .. ".x", x + 815)
        setProperty("rightArrow-" .. tag .. ".y", y + Misc.centerWithin(getProperty("rightArrow-" .. tag .. ".height"), getProperty("OptionBG-" .. tag .. ".height")))
    elseif OptionsList[tag].type == "list" then
        setProperty("listValue-" .. tag .. ".x", (x + 432) + Misc.centerWithin(getProperty("listValue-" .. tag .. ".width"), 422))
        setProperty("listValue-" .. tag .. ".y", y + 8)

        for i = 1, #OptionsList[tag].list do
            local objectSize = getProperty("listMarker-" .. tag .. i .. ".width")
            local spacing = objectSize + 3
            local spacingTotal = (spacing - objectSize) * (#OptionsList[tag].list - 1)
            local sizeTotal = (objectSize * #OptionsList[tag].list) + spacingTotal

            setProperty("listMarker-" .. tag .. i .. ".x", ((x + 432) + Misc.centerWithin(sizeTotal, 422)) + ((i - 1) * spacing))
            setProperty("listMarker-" .. tag .. i .. ".y", getProperty("listValue-" .. tag .. ".y") + getProperty("listValue-" .. tag .. ".height") + 10)
        end

        setProperty("leftArrow-" .. tag .. ".x", x + 438)
        setProperty("leftArrow-" .. tag .. ".y", y + Misc.centerWithin(getProperty("leftArrow-" .. tag .. ".height"), getProperty("OptionBG-" .. tag .. ".height")))

        setProperty("rightArrow-" .. tag .. ".x", x + 815)
        setProperty("rightArrow-" .. tag .. ".y", y + Misc.centerWithin(getProperty("rightArrow-" .. tag .. ".height"), getProperty("OptionBG-" .. tag .. ".height")))
    end
end

function Option.setAlpha(tag, value)
    setProperty("OptionBG-" .. tag .. ".alpha", value)
    setProperty("OptionName-" .. tag .. ".alpha", value)
    if OptionsList[tag].type == "bool" then
        setProperty("toggleBG-" .. tag .. ".alpha", value)
        setProperty("toggleBar-" .. tag .. ".alpha", value)
        setProperty("toggleOFF-" .. tag .. ".alpha", value)
        setProperty("toggleON-" .. tag .. ".alpha", value)
    elseif OptionsList[tag].type == "number" then
        setProperty("numberValue-" .. tag .. ".alpha", value)
        setProperty("sliderBG-" .. tag .. ".alpha", value)
        setProperty("sliderBar-" .. tag .. ".alpha", value)
        setProperty("sliderCursor-" .. tag .. ".alpha", value)
        setProperty("leftArrow-" .. tag .. ".alpha", value)
        setProperty("rightArrow-" .. tag .. ".alpha", value)
    elseif OptionsList[tag].type == "list" then
        setProperty("listValue-" .. tag .. ".alpha", value)

        for i = 1, #OptionsList[tag].list do
            setProperty("listMarker-" .. tag .. i .. ".alpha", value)
        end

        setProperty("leftArrow-" .. tag .. ".alpha", value)
        setProperty("rightArrow-" .. tag .. ".alpha", value)
    end
end

function Option.boolControllerKeyboard(tag)
    if keyJustPressed("accept") then
        ClientData.data[tag] = not ClientData.data[tag]
        updateBool(tag)
    elseif keyJustPressed("ui_left") then
        ClientData.data[tag] = false
        updateBool(tag)
    elseif keyJustPressed("ui_right") then
        ClientData.data[tag] = true
        updateBool(tag)
    end
end

function Option.boolControllerMouse(tag)
    if Misc.mouseOverlaps("toggleBG-" .. tag) then
        if mouseClicked() then
            ClientData.data[tag] = not ClientData.data[tag]
            updateBool(tag)
        end
    end
end

function Option.numberControllerKeyboard(tag, elapsed)
    if keyPressed("ui_left") then
        if luaSpriteExists("leftArrow-" .. tag) then
            scaleObject("leftArrow-" .. tag, 0.9, 0.9, false)
        end
    elseif keyPressed("ui_right") then
        if luaSpriteExists("rightArrow-" .. tag) then
            scaleObject("rightArrow-" .. tag, 0.9, 0.9, false)
        end
    end
    if keyReleased("ui_left") then
        cancelTween("leftArrowTween-" .. tag)
        startTween("leftArrowTween-" .. tag, "leftArrow-" .. tag .. ".scale", {x = 1, y = 1}, tweenSpeed, {ease = tweenEase})
    end
    if keyReleased("ui_right") then
        cancelTween("rightArrowTween-" .. tag)
        startTween("rightArrowTween-" .. tag, "rightArrow-" .. tag .. ".scale", {x = 1, y = 1}, tweenSpeed, {ease = tweenEase})
    end

    if keyPressed("ui_left") or keyPressed("ui_right") then
        Option[tag].timeHeld = Option[tag].timeHeld + elapsed
    elseif keyReleased("ui_left") or keyReleased("ui_right") then
        Option[tag].timeHeld = 0
    end

    if Option[tag].timeHeld > 0.2 then
        if keyPressed("ui_left") then
            ClientData.data[tag] = ClientData.data[tag] - 1
        elseif keyPressed("ui_right") then
            ClientData.data[tag] = ClientData.data[tag] + 1
        end
    else
        if keyJustPressed("ui_left") then
            playSound(ClientData.scrollSound, ClientData.interactVolume)
            ClientData.data[tag] = ClientData.data[tag] - 1
        elseif keyJustPressed("ui_right") then
            playSound(ClientData.scrollSound, ClientData.interactVolume)
            ClientData.data[tag] = ClientData.data[tag] + 1
        end
    end

    if ClientData.data[tag] < OptionsList[tag].minValue then
        ClientData.data[tag] = OptionsList[tag].minValue
    elseif ClientData.data[tag] >= OptionsList[tag].maxValue then
        ClientData.data[tag] = OptionsList[tag].maxValue
    end

    if luaTextExists("numberValue-" .. tag) then -- doing this cause i get debug error text that bothers me
        updateNumber(tag)
    end
end

function Option.numberControllerMouse(tag, elapsed)
    if Misc.mouseOverlaps("leftArrow-" .. tag) or Misc.mouseOverlaps("rightArrow-" .. tag) or Misc.mouseOverlaps("sliderBG-" .. tag) or Misc.mouseOverlaps("OptionBG-" .. tag) then
        if not Option[tag].isEditing and mouseClicked() then
            Option[tag].isEditing = true
        end
    elseif not Misc.mouseOverlaps("leftArrow-" .. tag) or not Misc.mouseOverlaps("rightArrow-" .. tag) or not Misc.mouseOverlaps("sliderBG-" .. tag) or not Misc.mouseOverlaps("OptionBG-" .. tag) then
        if Option[tag].isEditing then
            Option[tag].isEditing = false
            Option[tag].draggingSlider = false
        end
    end

    if Misc.mouseOverlaps("sliderBG-" .. tag) and Misc.mouseWheel() ~= 0 then --gayyy
        ClientData.data[tag] = ClientData.data[tag] + Misc.mouseWheel()
        if ClientData.data[tag] < OptionsList[tag].minValue then
            ClientData.data[tag] = OptionsList[tag].minValue
        elseif ClientData.data[tag] >= OptionsList[tag].maxValue then
            ClientData.data[tag] = OptionsList[tag].maxValue
        end
        if luaTextExists("numberValue-" .. tag) then -- doing this cause i get debug error text that bothers me
            updateNumber(tag)
        end
    end

    if Option[tag].isEditing then
        if mouseClicked() then
            if Misc.mouseOverlaps("leftArrow-" .. tag) then
                playSound(ClientData.scrollSound, ClientData.interactVolume)
                ClientData.data[tag] = ClientData.data[tag] - 1
            elseif Misc.mouseOverlaps("rightArrow-" .. tag) then
                playSound(ClientData.scrollSound, ClientData.interactVolume)
                ClientData.data[tag] = ClientData.data[tag] + 1
            end
        elseif mousePressed() then
            Option[tag].timeHeld = Option[tag].timeHeld + elapsed
            if Misc.mouseOverlaps("leftArrow-" .. tag) and not Option[tag].draggingSlider then
                scaleObject("leftArrow-" .. tag, 0.9, 0.9, false)
                if Option[tag].timeHeld > 0.2 then
                    ClientData.data[tag] = ClientData.data[tag] - 1
                end
            elseif Misc.mouseOverlaps("rightArrow-" .. tag) and not Option[tag].draggingSlider then
                scaleObject("rightArrow-" .. tag, 0.9, 0.9, false)
                if Option[tag].timeHeld > 0.2 then
                    ClientData.data[tag] = ClientData.data[tag] + 1
                end
            elseif Misc.mouseOverlaps("sliderBG-" .. tag) and not Option[tag].draggingSlider then
                Option[tag].draggingSlider = true
            end
        elseif mouseReleased() then
            Option[tag].timeHeld = 0
            Option[tag].draggingSlider = false

            cancelTween("leftArrowTween-" .. tag)
            startTween("leftArrowTween-" .. tag, "leftArrow-" .. tag .. ".scale", {x = 1, y = 1}, tweenSpeed, {ease = tweenEase})
            cancelTween("rightArrowTween-" .. tag)
            startTween("rightArrowTween-" .. tag, "rightArrow-" .. tag .. ".scale", {x = 1, y = 1}, tweenSpeed, {ease = tweenEase})
        end

        if Option[tag].draggingSlider then
            local sliderLength = 324
                setProperty("sliderCursor-" .. tag ..".x", getMouseX("camOptions"))
                if getProperty("sliderCursor-" .. tag ..".x") <= getProperty("sliderBG-" .. tag ..".x") + 4 then
                    setProperty("sliderCursor-" .. tag ..".x", getProperty("sliderBG-" .. tag ..".x") + 4)
                elseif getProperty("sliderCursor-" .. tag ..".x") > getProperty("sliderBG-" .. tag ..".x") + 4 + sliderLength then
                    setProperty("sliderCursor-" .. tag ..".x", getProperty("sliderBG-" .. tag ..".x") + 4 + sliderLength)
                end
                local cursorValue = getProperty("sliderCursor-" .. tag ..".x") - (getProperty("sliderBG-" .. tag ..".x") + 4)
                ClientData.data[tag] = math.floor(100 * (cursorValue / sliderLength))
        end

        if ClientData.data[tag] < OptionsList[tag].minValue then
            ClientData.data[tag] = OptionsList[tag].minValue
        elseif ClientData.data[tag] >= OptionsList[tag].maxValue then
            ClientData.data[tag] = OptionsList[tag].maxValue
        end

        if luaTextExists("numberValue-" .. tag) then -- doing this cause i get debug error text that bothers me
            updateNumber(tag)
        end
    else
        Option[tag].timeHeld = 0

        cancelTween("leftArrowTween-" .. tag)
        startTween("leftArrowTween-" .. tag, "leftArrow-" .. tag .. ".scale", {x = 1, y = 1}, tweenSpeed, {ease = tweenEase})
        cancelTween("rightArrowTween-" .. tag)
        startTween("rightArrowTween-" .. tag, "rightArrow-" .. tag .. ".scale", {x = 1, y = 1}, tweenSpeed, {ease = tweenEase})
    end
end

function Option.listControllerKeyboard(tag)
    if keyPressed("ui_left") then
        if luaSpriteExists("leftArrow-" .. tag) then
            scaleObject("leftArrow-" .. tag, 0.9, 0.9, false)
        end
    elseif keyPressed("ui_right") then
        if luaSpriteExists("rightArrow-" .. tag) then
            scaleObject("rightArrow-" .. tag, 0.9, 0.9, false)
        end
    end

    if Misc.keyboardJustPressed() then
        local curListItem = Misc.indexOf(OptionsList[tag].list, ClientData.data[tag])
        if keyJustPressed("ui_left") then
            playSound(ClientData.scrollSound, ClientData.interactVolume)
            curListItem = curListItem - 1
        elseif keyJustPressed("ui_right") then
            playSound(ClientData.scrollSound, ClientData.interactVolume)
            curListItem = curListItem + 1
        end

        if curListItem > #OptionsList[tag].list then
            curListItem = 1
        elseif curListItem < 1 then
            curListItem = #OptionsList[tag].list
        end

        ClientData.data[tag] = OptionsList[tag].list[curListItem]
        updateList(tag)
    end

    if keyReleased("ui_left") or keyReleased("ui_right") then
        cancelTween("leftArrowTween-" .. tag)
        startTween("leftArrowTween-" .. tag, "leftArrow-" .. tag .. ".scale", {x = 1, y = 1}, tweenSpeed, {ease = tweenEase})
        cancelTween("rightArrowTween-" .. tag)
        startTween("rightArrowTween-" .. tag, "rightArrow-" .. tag .. ".scale", {x = 1, y = 1}, tweenSpeed, {ease = tweenEase})
    end
end

function Option.listControllerMouse(tag)
    if Misc.mouseOverlaps("leftArrow-" .. tag) or Misc.mouseOverlaps("rightArrow-" .. tag) or Misc.mouseOverlaps("OptionBG-" .. tag) then
        if not Option[tag].isEditing and mouseClicked() then
            Option[tag].isEditing = true
        end
    elseif not Misc.mouseOverlaps("leftArrow-" .. tag) or not Misc.mouseOverlaps("rightArrow-" .. tag) or not Misc.mouseOverlaps("OptionBG-" .. tag) then
        if Option[tag].isEditing then
            Option[tag].isEditing = false
        end
    end

    if Option[tag].isEditing then
        if mousePressed() then
            if Misc.mouseOverlaps("leftArrow-" .. tag) then
                scaleObject("leftArrow-" .. tag, 0.9, 0.9, false)
            elseif Misc.mouseOverlaps("rightArrow-" .. tag) then
                scaleObject("rightArrow-" .. tag, 0.9, 0.9, false)
            end
        end
        if mouseClicked() then
            local curListItem = Misc.indexOf(OptionsList[tag].list, ClientData.data[tag])
            if Misc.mouseOverlaps("leftArrow-" .. tag) then
                playSound(ClientData.scrollSound, ClientData.interactVolume)
                curListItem = curListItem - 1
            elseif Misc.mouseOverlaps("rightArrow-" .. tag) then
                playSound(ClientData.scrollSound, ClientData.interactVolume)
                curListItem = curListItem + 1
            end

            if curListItem > #OptionsList[tag].list then
                curListItem = 1
            elseif curListItem < 1 then
                curListItem = #OptionsList[tag].list
            end

            ClientData.data[tag] = OptionsList[tag].list[curListItem]
            updateList(tag)
        elseif mouseReleased() then
            cancelTween("leftArrowTween-" .. tag)
            startTween("leftArrowTween-" .. tag, "leftArrow-" .. tag .. ".scale", {x = 1, y = 1}, tweenSpeed, {ease = tweenEase})
            cancelTween("rightArrowTween-" .. tag)
            startTween("rightArrowTween-" .. tag, "rightArrow-" .. tag .. ".scale", {x = 1, y = 1}, tweenSpeed, {ease = tweenEase})
        end
    else
        cancelTween("leftArrowTween-" .. tag)
        startTween("leftArrowTween-" .. tag, "leftArrow-" .. tag .. ".scale", {x = 1, y = 1}, tweenSpeed, {ease = tweenEase})
        cancelTween("rightArrowTween-" .. tag)
        startTween("rightArrowTween-" .. tag, "rightArrow-" .. tag .. ".scale", {x = 1, y = 1}, tweenSpeed, {ease = tweenEase})
    end
end

function updateBool(tag, fastUpdate)
    fastUpdate = fastUpdate == nil and false or fastUpdate
    if luaSpriteExists("toggleBG-" .. tag) then -- need to prevent error text if player presses [back] and [accept] at the same time
        local targetX = ClientData.data[tag] and getProperty("toggleBG-" .. tag .. ".x") + 4 + getProperty("toggleBar-" .. tag .. ".width") or getProperty("toggleBG-" .. tag .. ".x") + 4
        if not fastUpdate then
            stopSound("toggleSound")
            playSound(ClientData.toggleSound, ClientData.interactVolume, "toggleSound")
            setSoundPitch("toggleSound", ClientData.data[tag] and 1.2 or 0.9)
            cancelTween("toggleBarTween-" .. tag)
            doTweenX("toggleBarTween-" .. tag, "toggleBar-" .. tag, targetX, tweenSpeed, tweenEase)
            cancelTween("toggleOFFTween-" .. tag)
            doTweenColor("toggleOFFTween-" .. tag, "toggleOFF-" .. tag, ClientData.data[tag] and "FFFFFF" or "000000", tweenSpeed, tweenEase)
            cancelTween("toggleONTween-" .. tag)
            doTweenColor("toggleONTween-" .. tag, "toggleON-" .. tag, ClientData.data[tag] and "000000" or "FFFFFF", tweenSpeed, tweenEase)
        else
            cancelTween("toggleBarTween-" .. tag)
            cancelTween("toggleOFFTween-" .. tag)
            cancelTween("toggleONTween-" .. tag)
            setProperty("toggleBar-" .. tag .. ".x", targetX)
            setProperty("toggleOFF-" .. tag .. ".color", ClientData.data[tag] and getColorFromHex("FFFFFF") or getColorFromHex("000000"))
            setProperty("toggleON-" .. tag .. ".color", ClientData.data[tag] and getColorFromHex("000000") or getColorFromHex("FFFFFF"))
        end
    end
end

function updateNumber(tag)
    setTextString("numberValue-" .. tag, ClientData.data[tag] .."%")
    scaleObject("sliderBar-" .. tag, (ClientData.data[tag] / 100) * 324, 1)
    setProperty("sliderCursor-" .. tag .. ".x", getProperty("sliderBar-" .. tag .. ".x") + getProperty("sliderBar-" .. tag .. ".scale.x"))
end

function updateList(tag, fastUpdate)
    fastUpdate = fastUpdate == nil and false or fastUpdate
    if luaTextExists("listValue-" .. tag) then -- doing this cause i get debug error text that bothers me
        setTextString("listValue-" .. tag, ClientData.data[tag])
        for i = 1, #OptionsList[tag].list do
            if not fastUpdate then
                cancelTween("listMarkerTween-" .. tag .. i)
                cancelTween("listMarkerTweenColor-" .. tag .. i)
                doTweenY("listMarkerTween-" .. tag .. i, "listMarker-" .. tag .. i .. ".scale", Misc.indexOf(OptionsList[tag].list, ClientData.data[tag]) == i and 9 or 3, tweenSpeed, tweenEase)
                doTweenColor("listMarkerTweenColor-" .. tag .. i, "listMarker-" .. tag .. i, Misc.indexOf(OptionsList[tag].list, ClientData.data[tag]) == i and "FFFFFF" or "808080", tweenSpeed, tweenEase)
            else
                cancelTween("listMarkerTween-" .. tag .. i)
                cancelTween("listMarkerTweenColor-" .. tag .. i)
                setProperty("listMarker-" .. tag .. i .. ".scale.y", Misc.indexOf(OptionsList[tag].list, ClientData.data[tag]) == i and 9 or 3)
                setProperty("listMarker-" .. tag .. i .. ".color", Misc.indexOf(OptionsList[tag].list, ClientData.data[tag]) == i and getColorFromHex("FFFFFF") or getColorFromHex("808080"))
            end
        end
    end
end

function Option.reload()
    for items in pairs(Option) do
        if type(Option[items]) == "table" then
            if OptionsList[Option[items].tag].type == "bool" then
                updateBool(Option[items].tag, true)
            elseif OptionsList[Option[items].tag].type == "number" then
                updateNumber(Option[items].tag)
            elseif OptionsList[Option[items].tag].type == "list" then
                updateList(Option[items].tag, true)
            end
        end
    end
end