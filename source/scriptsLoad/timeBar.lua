function onUpdatePost()
    setProperty('timeBar.color', getIconColor('dad'))
end
function getIconColor(chr)
    local chr = chr or "dad"
    return getColorFromHex(rgbToHex(getProperty(chr .. ".healthColorArray")))
end
function rgbToHex(array)
    return string.format('%.2x%.2x%.2x', array[1], array[2], array[3])
end