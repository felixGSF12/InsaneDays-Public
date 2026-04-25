---@diagnostic disable: lowercase-global, undefined-global, missing-parameter, inject-field
---@funkinScript

_G.Misc = {}

function Misc.centerWithin(objectSize, workspaceSize)
    return (workspaceSize / 2) - (objectSize / 2)
end

function Misc.camera(tag, x, y, width, height)
    runHaxeCode([[
        var customCamera:FlxCamera = new FlxCamera(]] .. x .. [[, ]] .. y .. [[, ]] .. width .. [[, ]] .. height .. [[);
        customCamera.bgColor = 0x00;
        FlxG.cameras.add(customCamera, false);
        //FlxG.cameras.add(camOther, false); //i only need this for debugging
        setVar("]] .. tag .. [[", customCamera);
    ]])
end

function Misc.removeCamera(tag)
    runHaxeCode([[
        FlxG.cameras.remove(getVar("]] .. tag .. [["));
        game.variables.remove(]] .. tag ..[[); //doing this just in case
    ]])
end

function Misc.indexOf(array, value) --https://stackoverflow.com/questions/38282234/returning-the-index-of-a-value-in-a-lua-table
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

function Misc.listFromTxt(fileName)
    runHaxeCode("import backend.CoolUtil;")
    return runHaxeCode("CoolUtil.coolTextFile('mods/" .. modFolder .. "/scripts/options/" .. fileName .. ".txt');")
end

function Misc.mouseOverlaps(object)
    local overlapsX = false
    local overlapsY = false

    if getProperty(object) ~= nil then
        if getMouseX("camOptions") > getProperty(object .. ".x") then
            if getMouseX("camOptions") <=  getProperty(object .. ".x") + getProperty(object .. ".width") then
                overlapsX = true
            end
        end
        if getMouseY("camOptions") > getProperty(object .. ".y") then
            if getMouseY("camOptions") <= getProperty(object .. ".y") + getProperty(object .. ".height") then
                overlapsY = true
            end
        end
    end
    return overlapsX and overlapsY
end

function Misc.mouseWheel()
    return runHaxeCode("FlxG.mouse.wheel;")
end

function Misc.keyboardJustPressed()
    return runHaxeCode("FlxG.keys.firstJustPressed();") ~= -1
end

function Misc.setClipboard(text)
    runHaxeCode("import lime.system.Clipboard;")
    return runHaxeCode("Clipboard.text = '" .. text .. "';")
end

function Misc.getClipboard()
    runHaxeCode("import lime.system.Clipboard;")
    return runHaxeCode("Clipboard.text;")
end

return Misc