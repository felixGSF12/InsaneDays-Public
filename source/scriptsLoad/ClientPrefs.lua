function onCreatePost()
    local huds = getPropertyFromClass("ClientPrefs", "vanillaHud",true);
    local ratingMode = getPropertyFromClass("ClientPrefs", "newRat",true);
    local palabras = getPropertyFromClass("ClientPrefs", "textGameOver");
  
    if huds == true then
        addLuaScript("scripts/huds/VanillaHUD");
    else
        addLuaScript("scripts/huds/mariHud");
    end
    if huds == false then
        if ratingMode == 'newStyle' then
            addLuaScript("scripts/stuff/UnholyStyle");
        elseif ratingMode == 'Text' then
            addLuaScript("scripts/stuff/combo_counter_v110");
            addLuaScript("scripts/stuff/msnotehit");
        else
            addLuaScript("scripts/stuff/UnholyStyle");
        end
    end
    if palabras then
        if palabras == 'breath' then
            addLuaScript("scripts/stuff/frasesMotivadoras");
        elseif palabras == 'death' then
            addLuaScript("scripts/stuff/gameOverStuff");
        else
            addLuaScript("scripts/stuff/null");
        end
    end
    setProperty("iconP1.x", getProperty("boyfriend.x"))
end

--para evitar errores grandes. algunas opciones estan en otros scripts, por ejemplo; "gfIcons"
--esto se encuentran en scripts/genderSwarp.lua: function createIcon()