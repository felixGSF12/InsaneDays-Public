-- script by space.fla on discord

function onCreatePost()

    makeLuaText('songText', ' ' .. (songName), 1250, 0, 640)
    addLuaText('songText')

    if downscroll then

    makeLuaText('songText', ' ' .. (songName), 1250, 0, 78)
    addLuaText('songText')
end
end

function onUpdatePost()
	setProperty('iconP1.x', screenWidth - 430)
	setProperty('iconP2.x', 385)
    setProperty('winIcoP1.x', screenWidth - 500)
   -- setProperty('winIcoP1.visible',true)
end   