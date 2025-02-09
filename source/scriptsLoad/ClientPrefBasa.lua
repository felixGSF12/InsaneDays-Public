function onCreatePost()
  local hud = getPropertyFromClass("ClientPrefs", "hudselector", true)
  local credit = getPropertyFromClass("ClientPrefs", "byeCredits", false)
  local combo = getPropertyFromClass("ClientPrefs", "comboNew", true)
  if hud then
      if hud == 'oldHud' then
          addLuaScript('scripts/unused/hud/MicUpInsane')
      elseif hud == 'NewHud' then
          addLuaScript('scripts/unused/hud/InsaneEngine')
        elseif hud == 'mariHud' then
          addLuaScript('scripts/unused/hud/mariHud')
        elseif hud == 'luisaHud' then
          addLuaScript('scripts/unused/hud/LuisaHud')
        elseif hud == 'felixHud' then
          addLuaScript('scripts/unused/hud/FelixHud')
      end
if credit == false then
    addLuaScript('scripts/Client/Credits')
    addLuaScript('scripts/Client/CreditsSong')
else
    addLuaScript('scripts/Client/null')
    addLuaScript('scripts/Client/null')
end
  end
  if combo == true then
addLuaScript('scripts/Client/combo_counter_v110', false)
  else
    setPropertyFromClass('ClientPrefs', 'comboOffset[0]', 92,180)
    setPropertyFromClass('ClientPrefs', 'comboOffset[2]', 315)
    setPropertyFromClass('ClientPrefs', 'comboOffset[3]', 130)
    addLuaScript('scripts/Client/null');
  end
end