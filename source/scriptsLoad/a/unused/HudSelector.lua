local Hudtype = 'mariHud' --la version del hud que desees
 --Hudtypes list:
--InsaneEngine  (vanilla)
--Insane    (old hud)
--LuisaHud
--mariHud (con minuscula)
--FelixHud

function onCreatePost()
    if Hudtype == 'InsaneEngine' then
        addLuaScript('Scripts/hud/InsaneEngine')
    end
    if Hudtype == 'insane' then
        addLuaScript('scripts/hud/MicUpinsane');
    end
    if Hudtype == 'mariHud' then
        addLuaScript('Scripts/hud/MariHud')
       -- setProperty('msTxt.visible',false)
    end
    if Hudtype == 'FelixHud' then
        addLuaScript('Scripts/hud/FelixHud');
end
if Hudtype == 'LuisaHud' then
    addLuaScript('Scripts/hud/LuisaHud');
end
end