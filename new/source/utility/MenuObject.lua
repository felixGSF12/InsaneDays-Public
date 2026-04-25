---@diagnostic disable: lowercase-global, undefined-global, duplicate-set-field
---@funkinScript

_G.MenuObject = {
    sprites = {},
    texts = {}
}

function MenuObject.graphic(tag, x, y, width, height, color)
    require("mods/scripts/utility/Object")
    require("mods/scripts/utility/Misc")
    Object.graphic(tag, x, y, width, height, color)
    table.remove(Object.sprites, Misc.indexOf(Object.sprites, tag))
    table.insert(MenuObject.sprites, tag)
end

function MenuObject.sprite(tag, image, x, y, xmlPrefixes)
    require("mods/scripts/utility/Object")
    require("mods/scripts/utility/Misc")
    Object.sprite(tag, image, x, y, xmlPrefixes)
    table.remove(Object.sprites, Misc.indexOf(Object.sprites, tag))
    table.insert(MenuObject.sprites, tag)
end

function MenuObject.text(tag, x, y, width, text)
    require("mods/scripts/utility/Object")
    require("mods/scripts/utility/Misc")
    Object.text(tag, x, y, width, text)
    table.remove(Object.texts, Misc.indexOf(Object.texts, tag))
    table.insert(MenuObject.texts, tag)
end

function MenuObject.alphabet(tag, x, y, text, bold, scale)
    require("mods/scripts/utility/Object")
    require("mods/scripts/utility/Misc")
    Object.alphabet(tag, x, y, text, bold, scale)
    table.remove(Object.sprites, Misc.indexOf(Object.sprites, tag))
    table.insert(MenuObject.sprites, tag)
end

function MenuObject.gradient(tag, x, y, width, height, colors)
    require("mods/scripts/utility/Object")
    require("mods/scripts/utility/Misc")
    Object.gradient(tag, x, y, width, height, colors)
    table.remove(Object.sprites, Misc.indexOf(Object.sprites, tag))
    table.insert(MenuObject.sprites, tag)
end

function MenuObject.destroy()
    for i in pairs(MenuObject.sprites) do
        removeLuaSprite(MenuObject.sprites[i])
    end
    for i in pairs(MenuObject.texts) do
        removeLuaText(MenuObject.texts[i])
    end
end

return MenuObject