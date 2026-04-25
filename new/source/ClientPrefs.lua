function onCreatePost()

    -- ✅ UNDERLAYS
    if getPropertyFromClass('backend.ClientPrefs','data.underlays') ~= 'Disabled'
        and checkFileExists('mods/scripts/ClientPrefs/HUD.lua', true) then
        addLuaScript('mods/scripts/ClientPrefs/HUD.lua', true)
    end

    -- ✅ GAMEPLAY SETTINGS
    local gp = getPropertyFromClass('backend.ClientPrefs','data.gameplaySettings')
    if gp ~= nil then
        local dadSide = gp['dadSide'] or gp.dadSide
        if dadSide == true and checkFileExists('mods/scripts/ClientPrefs/OpponentSide.hx', true) then
            addHScript('mods/scripts/ClientPrefs/OpponentSide.hx')
        end
    end

    -- ✅ Cargar Results.lua (ya está verificado)
    addLuaScript('mods/results/scripts/game/Results.lua')
end
