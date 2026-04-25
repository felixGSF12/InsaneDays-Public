---@diagnostic disable: lowercase-global, undefined-global

_G.Math = {}

function Math.hexToRGB(hexcode)
    hexcode = string.upper(hexcode)

    local hexDecimalMap = {
        ["0"] = 0,
        ["1"] = 1,
        ["2"] = 2,
        ["3"] = 3,
        ["4"] = 4,
        ["5"] = 5,
        ["6"] = 6,
        ["7"] = 7,
        ["8"] = 8,
        ["9"] = 9,
        ["A"] = 10,
        ["B"] = 11,
        ["C"] = 12,
        ["D"] = 13,
        ["E"] = 14,
        ["F"] = 15
    }

    local rgb = {0, 0, 0}
    local red = 0
    local green = 0
    local blue = 0

    if #hexcode == 6 then
        if hexDecimalMap[hexcode:sub(1, 1)] ~= nil or hexDecimalMap[hexcode:sub(2, 2)] ~= nil then
            red = (hexDecimalMap[hexcode:sub(1, 1)] * 16) + hexDecimalMap[hexcode:sub(2, 2)]
        else
            return rgb
        end
        if hexDecimalMap[hexcode:sub(3, 3)] ~= nil or hexDecimalMap[hexcode:sub(4, 4)] ~= nil then
            green = (hexDecimalMap[hexcode:sub(3, 3)] * 16) + hexDecimalMap[hexcode:sub(4, 4)]
        else
            return rgb
        end
        if hexDecimalMap[hexcode:sub(5, 5)] ~= nil or hexDecimalMap[hexcode:sub(6, 6)] ~= nil then
            blue = (hexDecimalMap[hexcode:sub(5, 5)] * 16) + hexDecimalMap[hexcode:sub(6, 6)]
        else
            return rgb
        end
    else
        return rgb
    end

    rgb = {red, green, blue}

    return rgb
end

function Math.rgbToHex(colorArray, returnString)
    returnString = returnString == nil and false or returnString
    local hexcode = ""
    for colors in pairs(colorArray) do
        value1 = math.floor(colorArray[colors] / 16)
        value2 = ((colorArray[colors] / 16) % 1) * 16
        hexcode = hexcode .. (value1 < 10 and tostring(value1) or tostring(string.char((65 + value1) - 10)))
        hexcode = hexcode .. (value2 < 10 and tostring(value2) or tostring(string.char((65 + value2) - 10)))
        end
    if not returnString then
        return getColorFromHex(hexcode)
    end
    return hexcode
end

function Math.rgbToHSB(colorArray, returnArray) -- https://www.geeksforgeeks.org/program-change-rgb-color-model-hsb-color-model/
    returnArray = returnArray == nil and false or returnArray
    local r = colorArray[1] / 255
    local g = colorArray[2] / 255
    local b = colorArray[3] / 255
    local cmax = math.max(r, math.max(g, b))
    local cmin = math.min(r, math.min(g, b))
    local diff = cmax - cmin
    local h = -1
    local s = -1

    if cmax == cmin then
        h = 0
    elseif cmax == r then
        h = math.fmod(60 * ((g - b) / diff) + 360, 360)
    elseif cmax == g then
        h = math.fmod(60 * ((b - r) / diff) + 120, 360)
    elseif cmax == b then
        h = math.fmod(60 * ((r - g) / diff) + 240, 360)
    end

    if cmax == 0 then
        s = 0
    else
        s = (diff / cmax) * 100
    end

    local v = cmax * 100

    local hsb = {math.floor(h), math.floor(s), math.floor(v)}
    local convertedColor = ""
    for colors in pairs(hsb) do
        convertedColor = convertedColor .. hsb[colors] .. ","
    end

    if returnArray then
        return hsb
    end
    return runHaxeCode("FlxColor.fromHSB(" .. convertedColor:sub(1, #convertedColor - 1) .. ")")
end

function Math.hsbToRGB(hue, saturation, brightness)
	local RGB = {}

	local c = brightness * saturation
	local x = c * (1 - math.abs((hue / 60) % 2 - 1))
	local m = brightness - c
	local r, g, b

	if hue >= 0 and hue < 60 then
	  r, g, b = c, x, 0
	elseif hue >= 60 and hue < 120 then
	  r, g, b = x, c, 0
	elseif hue >= 120 and hue < 180 then
	  r, g, b = 0, c, x
	elseif hue >= 180 and hue < 240 then
	  r, g, b = 0, x, c
	elseif hue >= 240 and hue < 300 then
	  r, g, b = x, 0, c
	else
	  r, g, b = c, 0, x
	end

	table.insert(RGB, math.floor((r + m) * 255))
	table.insert(RGB, math.floor((g + m) * 255))
	table.insert(RGB, math.floor((b + m) * 255))

	return RGB
end

function Math.round(float, decimalPlaces)
    return runHaxeCode("FlxMath.roundDecimal(" .. float .. "," .. decimalPlaces .. ")")
end

return Math