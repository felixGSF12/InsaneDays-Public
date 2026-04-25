---@diagnostic disable: lowercase-global, undefined-global, duplicate-set-field
---@funkinScript

_G.Object = {
    sprites = {},
    texts = {}
}

local defaultCam = "camOptions"

function Object.graphic(tag, x, y, width, height, color, camera, onTop)
    camera = camera == nil and defaultCam or camera
    onTop = onTop == nil and true or onTop

    makeLuaSprite(tag, nil, x, y)
    makeGraphic(tag, width, height, color)
    setObjectCamera(tag, camera)
    addLuaSprite(tag, onTop)
    table.insert(Object.sprites, tag)
end

function Object.sprite(tag, image, x, y, xmlPrefixes, camera, onTop)
    camera = camera == nil and defaultCam or camera
    onTop = onTop == nil and true or onTop
    if xmlPrefixes ~= nil then
        makeAnimatedLuaSprite(tag, image, x, y)
        for i in pairs(xmlPrefixes) do
            addAnimationByPrefix(tag, xmlPrefixes[i], xmlPrefixes[i], 24, false)
        end
    else
        makeLuaSprite(tag, image, x, y)
    end
    setObjectCamera(tag, camera)
    addLuaSprite(tag, onTop)
    table.insert(Object.sprites, tag)
end

function Object.text(tag, x, y, width, text, camera, onTop)
    camera = camera == nil and defaultCam or camera
    onTop = onTop == nil and true or onTop
    makeLuaText(tag, text, width, x, y)
    setTextFont(tag, "alwaysVCR.ttf") -- incase you play a mod where the creator renamed their custom font to "vcr.ttf" >:(
	setTextSize(tag, 26)
	setTextColor(tag, "FFFFFF")
	setTextBorder(tag, 2, "000000")
	setTextAlignment(tag, "CENTER")
	setObjectCamera(tag, camera)
	addLuaText(tag, onTop)
    table.insert(Object.texts, tag)
end

function Object.alphabet(tag, x, y, text, bold, scale, camera)
    bold = bold == nil and true or bold
    scale = scale == nil and 1 or scale
    camera = camera == nil and defaultCam or camera
    runHaxeCode([[
        var alphabet:Alphabet = new Alphabet(]] .. x .. [[, ]] .. y .. [[, "]] .. text .. [[", ]] .. tostring(bold) .. [[);
        alphabet.cameras = [getVar("]] .. camera .. [[")];
        alphabet.scaleX = alphabet.scaleY = ]] .. scale .. [[;
        game.variables.set("]] .. tag .. [[", alphabet);
        game.add(alphabet);
    ]])
    table.insert(Object.sprites, tag)
end

function Object.gradient(tag, x, y, width, height, colors, camera)
    camera = camera == nil and defaultCam or camera
    runHaxeCode([[
        import flixel.util.FlxGradient;
        import backend.CoolUtil;

        var colors:String = "]] .. colors .. [[";
        var realColors:Array<FlxColor> = [];

        for (item in colors.split(",")) {
            realColors.push(CoolUtil.colorFromString(item));
        }

        var gradient:FlxSprite = FlxGradient.createGradientFlxSprite(]] .. width .. [[, ]] .. height .. [[, realColors);
        gradient.setPosition(]] .. x .. [[, ]] .. y .. [[);
        gradient.cameras = [getVar("]] .. camera .. [[")];
        setVar("]] .. tag .. [[", gradient);
        add(gradient);
    ]])
    table.insert(Object.sprites, tag)
end

function Object.destroy()
    for i in pairs(Object.sprites) do
        removeLuaSprite(Object.sprites[i])
    end
    for i in pairs(Object.texts) do
        removeLuaText(Object.texts[i])
    end
end

return Object
