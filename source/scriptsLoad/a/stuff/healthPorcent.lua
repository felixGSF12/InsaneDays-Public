function onCreate()
    makeLuaText('healthText', 'Health: ' .. math.floor(getProperty("health") * 50), 300, screenWidth / 2 - 300 / 2, screenHeight / 2 - -508 / 1.5)
    addLuaText('healthText')
    setTextSize('healthText', 20);
end
function onUpdate(elapsed)
	-- start of "update", some variables weren't updated yet
    setTextString('healthText', 'Health: ' .. math.floor(getProperty("health") * 50))
end
functio