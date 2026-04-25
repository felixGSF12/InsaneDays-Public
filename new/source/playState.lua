--[[
Recordatorio para Felix del futuro:
Este PlayState contiene funciones complejas o imposibles de replicar en Haxe.
Si hay errores raros, probablemente vienen de aquí.
También hay eventos de canciones que son más sencillos en Lua.
]]
local sustainSplash = require("mods/scripts/sustainSplash")

local singAnims = {'singLEFT','singDOWN','singUP','singRIGHT'}
local addZoom = false
local allowCountdown = false 
local text =[[
Si alguien encuentra esto... escúchame.

NO te enfrentes a Cartoon Cat.

No canta, no sigue ritmo. Solo finge hacerlo para acercarse. 
Cada vez que intentas responder, se distorsiona más.

No lo mires a los ojos. No respondas si repite tu voz.

Si la pista cambia sola, sal del escenario.
Si el entorno se pone en silencio, ya estás dentro de su juego.

No hay victoria contra él. Solo tiempo.

Guarda tus fuerzas. Huye si puedes.

Este mensaje puede ser lo único que quede de mí.

—Boyfriend
]]
-- 🎬 CREACIÓN DE ELEMENTOS
function onCreate()
   
    if curStage == 'day4' then
        precacheImage('characters/felix/felix-chained')
         precacheImage('characters/luzhy/DemonAssets')
    end
    if curStage == 'day11' then
          precacheImage('characters/rayo/rayoRework')
    end
    if songName == 'Bad Blood' then
        setProperty('baseDamage',0.10)
    else
    setProperty('baseDamage',0.043)
    end
    
end
function playOpponent()
    addLuaScript('scripts/data/Play as opponent')
    
end
function onCreatePost()
    local prefs = getPropertyFromClass('backend.ClientPrefs','data.myLove')
    local backendPrefs = getPropertyFromClass('backend.ClientPrefs','data.myLove')

    if prefs == true and songName == 'purgatory' or songName == 'Dead life' then
        
        createFelixNoSpeakers()
    elseif backendPrefs and songName == 'Esquizofrenia' then
        createFelixChained()
    end
    if songName == 'betrayal distance' or songName == 'ex-gf' then
        bomboxsh()
    end

    if songName == 'furryphobia' then
        precacheImage('characters/nazaret-enemie')
    end
    stageProperties()
    

    if songName == 'no more drogs' then
        setProperty('gf.y', getProperty('gf.y') + 30)
        setProperty('dad.y', getProperty('dad.y') + 50)
    end
    if (gfName == 'rayoSpeaker') then
        makeAnimatedLuaSprite('bombox','speakers/Speakers-new',0,0)
        addAnimationByPrefix('bombox','bom','Símbolo',24,true)
        playAnim('bombox','bom')
        setProperty('bombox.x', getProperty('gf.x') - 210)
        setProperty('bombox.y', getProperty('gf.y') - 30)
        addLuaSprite('bombox');
    elseif (week == 'day10' or week == 'day10-sister') then
        pixelStagesBom()
    end
    if dadName == 'mily_demon' then
        addHScript('mods/scripts/data/Brillo_de_ojos.hx')
    end
     
end

-- 🧍 CREACIÓN DE SPRITES
function createFelixNoSpeakers()
    makeAnimatedLuaSprite('fx','characters/felix/felix-no-speakers',0,0)
    addAnimationByPrefix('fx','idle','GF Dancing Beat0',24,true)
    setProperty('fx.x', getProperty('gf.x'))
    setProperty('fx.y', getProperty('gf.y'))
    addLuaSprite('fx')
    SpeakersFromRayo()
end
function createFelixChained()
    makeAnimatedLuaSprite('felix','characters/felix/felix-chained',0,0)
    addAnimationByIndices('felix','idle','bf breath chained',"3",24,true)
    addAnimationByPrefix('felix','aliv','bf convo chained0',24,false)
    addAnimationByPrefix('felix','idle2','bf idle chained alt',24,true)
    addAnimationByPrefix('felix','breath','bf breath chained0',24,false)
    setProperty('felix.x',getProperty("boyfriend.x"));
    setProperty('felix.y',getProperty("boyfriend.y"))
    setProperty('felix.alpha', 1)
    --setObjectOrder('felix', getObjectOrder('boyfriendGroup') + 1)
    playAnim('felix','idle')
    addLuaSprite('felix', false)
end

function createLuzhy(enable)
    if enable then
        makeAnimatedLuaSprite("luzhy","characters/luzhy/DemonAssets",-650,0)
        for _, anim in ipairs(singAnims) do
            addAnimationByPrefix("luzhy", anim, "sky demon " .. anim:sub(5):lower(), 24, false)
        end
        addAnimationByPrefix("luzhy","idle","sky demon idle",24,true)
        setObjectOrder("luzhy", getObjectOrder("dadGroup"))
        addLuaSprite("luzhy")
    end
end

-- ⚙️ PROPIEDADES Y EVENTOS
function stageProperties()
    if curStage == 'day4' then
        setProperty('luzhy.visible', false)
        setProperty('luzhy.alpha', 0)
    end
end

function eventosS()
    if curStage ~= 'day4' then return end

    if curStep == 396 then
        setProperty('luzhy.visible', true)
        doTweenAlpha('luzhyAlpha','luzhy',0.76,1.5,'linear')
    elseif curStep == 401 then
     
        triggerEvent('Change Character','bf','felix_chained')
        makeLuaSprite('bg','BackGrounds/W3/youhavebeendestroyed',-1050,-280)
        setProperty('bg.alpha',0.76)
        setProperty('dad.alpha',0.65)
           if (getPropertyFromClass('backend.ClientPrefs','data.myLove') == false) then
        setProperty('gf.alpha',0.65)
           else
             setProperty('gf.alpha',0)
           end
        setProperty('dad.color',0x000000)
        setProperty('gf.color',0x000000)
        addLuaSprite('bg')
        createLuzhy(true)
    elseif curStep == 720 then
         if (getPropertyFromClass('backend.ClientPrefs','data.myLove') == false) then
        triggerEvent('Change Character','bf','felixWeek3')
         else
            triggerEvent('Change Character','bf','')
         end
        removeLuaSprite('bg',true)
        setProperty('luzhy.alpha',0.30)
        setProperty('dad.alpha',1)
        setProperty('gf.alpha',1)
        setProperty('dad.color',0xffffff)
        setProperty('gf.color',0xffffff)
    end
end

-- 🔁 ACTUALIZACIONES
function onUpdate()

if songName == 'Esquizofrenia' and getPropertyFromClass('backend.ClientPrefs','data.myLove') == true then
    setProperty('felix.color', getProperty('boyfriend.color'))
    if getProperty('felix.alpha') <= 0 then
        setProperty('health', -2)
    end
end
if (luaSpriteExists('fx') and songName == 'Dead life' and curStep == 319 ) then
    removeLuaSprite('fx', true)
    removeLuaSprite('bom', true)
end

    local bfAnim = getProperty('boyfriend.animation.curAnim.name')
    local felixAnim = getProperty('felix.animation.curAnim.name')

    if felixAnim ~= 'aliv' and bfAnim == 'aliv' then
        playAnim('felix','aliv',true)
    elseif felixAnim ~= 'breath' and bfAnim == 'breath' then
        playAnim('felix','breath',true)
    elseif felixAnim == 'breath' and getProperty('felix.animation.curAnim.finished') then
        playAnim('felix','idle2',true)
    end

end
function onUpdatePost(elapsed)
    if songName == 'furryphobia' then
        if curStep == 1040 and not luaSpriteExists('rayo') then
            createRayoCreepy(true)
        elseif curStep == 1296 then
            createRayoCreepy(false)
        end
    end
    if songName == 'racoonlovania' then
        eventosS()
    end

    if getProperty('luzhy.animation.curAnim.name') ~= 'idle' and getProperty('luzhy.animation.curAnim.finished') then
        playAnim('luzhy','idle')
    end
       if (getPropertyFromClass('backend.ClientPrefs','data.myLove') == true and songName == 'purgatory') then
        setProperty('gf.visible', false)
    end
    if getPropertyFromClass('backend.ClientPrefs','data.myLove') == true and songName == 'Dead life' and curStep < 319  then
        setProperty('gf.visible', false)

    elseif (getPropertyFromClass('backend.ClientPrefs','data.myLove') == true and songName == 'Dead life' and curStep >= 319 ) then
       setProperty('gf.visible', true) 
       
    end
    sustainSplash:endAnimation()
end


-- 🎵 INTERACCIONES DE NOTAS
function noteMiss()
      if (songName == 'Esquizofrenia' and getPropertyFromClass('backend.ClientPrefs','data.myLove') == true) then
        felixMecanic()
    end
    if (misses >= getAchievementScore('muller')) then
          addAchievementScore('muller',1)
    end
end

function goodNoteHit(index, noteData, noteType, isSustain)
    if (songName == 'Esquizofrenia' and getPropertyFromClass('backend.ClientPrefs','data.myLove') == true) then
    if getProperty('felix.alpha') < 1 then
        setProperty('felix.alpha', getProperty('felix.alpha') + 0.005)
    end
end
    end
    --- @param index int
    --- @param noteData integer
    --- @param noteType string
    --- @param isSustain bool
    ---
    function goodNoteHitPre(index, noteData, noteType, isSustain)

    sustainSplash:active(noteData, isSustain)
    end
function opponentNoteHit(index, noteData, noteType, isSustain)
    if noteType == 'No Animation' then
        playAnim('luzhy', singAnims[noteData + 1], true)
end
end
function healthReturn()
    local default = 0.015
    if dadName == 'tester' then
        return 0.023
    elseif songName == 'isaBM' then
        return 0.017
    else
         return default
    end
end


function startResults(allow)
	setProperty('allowResultsScreen',allow)
	if getProperty('allowResultsScreen') == true then
		addLuaScript('scripts/fromEvents/(PANTALLA DE RESULTADOS).lua')
		addLuaScript('scripts/fromEvents/(RESULTADOS).lua')
		--debugPrint('se inicio la pantalla de resultados ')
	else	
		removeLuaScript('scripts/fromEvents/(PANTALLA DE RESULTADOS).lua')
		removeLuaScript('scripts/fromEvents/(RESULTADOS).lua')
		--debugPrint('no se iniciara la pantalla de resultados ')
	end
end
function healthDrain(drain, min)
    if getProperty('health') > min then
        setProperty('health', getProperty('health') - drain)
     end
end
function felixMecanic()
    setProperty('felix.alpha', getProperty('felix.alpha') - 0.2)
end

-- 📸 EFECTOS Y TRANSICIONES
function createRayoCreepy(enable)
     if (getPropertyFromClass('backend.ClientPrefs','data.myLove') == false) then
    if enable then
        makeAnimatedLuaSprite('rayo','BackGrounds/W4/images/rayoDarker',0,0)
        setProperty('rayo.x', getProperty('boyfriend.x') - 100)
        setProperty('rayo.y', getProperty('boyfriend.y'))
        addAnimationByPrefix('rayo','idle','posesion0',24,true)
        doTweenX('xd','boyfriend', getProperty('boyfriend.x') + 150, 1.4, 'linear')
        setProperty('boyfriend.alpha', 0.63)
        setObjectOrder('rayo', getObjectOrder('boyfriendGroup') + 1)
        addLuaSprite('rayo')
    else
        doTweenX('xd2','boyfriend', getProperty('boyfriend.x') - 150, 1.4, 'linear')
        setProperty('boyfriend.alpha', 1)
        removeLuaSprite('rayo')
    end
end
end

function onStartCountdown()
    if not addZoom then
    if songName == 'authoritarian' or songName == 'dear sister' then
        setProperty('defaultCamZoom', 0.86)
        addZoom = true
    elseif songName == 'isaBM' then
        setProperty('defaultCamZoom', 0.6)
        addZoom = true
    end 
end
    if (songName == 'purgatory') then
         if not allowCountdown then -- Block the first countdown
         startVideo('wi_collab_game_over_mp4_part'); -- your Video's name | video (must be 1280x720) paste into "videos" folder 
         allowCountdown = true;
         return Function_Stop;
     end
     return Function_Continue;
    elseif (songName == 'Mad Defense') then
         if not allowCountdown then -- Block the first countdown
         startVideo('leonardDie'); -- your Video's name | video (must be 1280x720) paste into "videos" folder 
         allowCountdown = true;
         return Function_Stop;
     end
     return Function_Continue;
    end
 end
local speakerCreated = false

function SpeakersFromRayo()
    if speakerCreated then return end
    speakerCreated = true
    makeAnimatedLuaSprite('bom','speakers/Speakers-new',100,100)
    addAnimationByPrefix('bom','bom','Símbolo',24,true)
    playAnim('bom','bom')
    setObjectOrder('bom',getObjectOrder('fx')-1);
    addLuaSprite('bom')
end
function onEndSong()
    if getPropertyFromClass('backend.ClientPrefs','data.myLove') == true and songName == 'Esquizofrenia' and not achievementsExist('felix_visible') and achievementsExist('luzhy') and getProperty("felix.alpha") >= 0.8 then
        callOnScripts('spawnAchievements',{'felix_visible','Termina esquizofrenia con felix siendo visible','amor visible'})
    end
  
end
function onEvent(name, value1, value2)
if name == 'videoPlay' then -- Change the name to your choice
makeVideoSprite('videoStart', value1, 0, 0, 'cam'..value2, false) -- value1 is the name of your video in mods/videos, value2 can be 'Game', 'HUD', or 'Other'
setObjectOrder('videoStart_video', 0) -- Do NOT remove the '_video', as it is necessary using the second script
setProperty('videoStart_video.alpha', 1) -- Once again, do NOT remove the '_video'
end
if name == 'Change Character' and value1 == 'gf' and value2 == 'rayoSpeaker' then
         makeAnimatedLuaSprite('bombox','speakers/Speakers-new',0,0)
        addAnimationByPrefix('bombox','bom','Símbolo',24,true)
        playAnim('bombox','bom')
        setProperty('bombox.x', getProperty('gf.x') - 210)
        setProperty('bombox.y', getProperty('gf.y') - 30)
        addLuaSprite('bombox');
    end
end
function bomboxsh()
    makeAnimatedLuaSprite('bombox','speakers/Speakers-new',0,0)
    addAnimationByPrefix('bombox','bom','Símbolo',24,true)
    playAnim('bombox','bom')
    setProperty('bombox.x', getProperty('gf.x') - 260)
    setProperty('bombox.y', getProperty('gf.y') + 60)
      setProperty('gf.y', getProperty('gf.y') + 30)
    addLuaSprite('bombox');
end
function pixelStagesBom()
    if (songName ~= 'mad defense') then
    makeAnimatedLuaSprite('bom','speakers/gfPixel',0,0)
    addAnimationByPrefix('bom','bom','GF IDLE',24,true)
    scaleLuaSprite('bom', getProperty('gf.scale.x'), getProperty('gf.scale.y'))
    setProperty('bom.antialiasing', false);
    setProperty('bom.x', getProperty('gf.x') - 120)
    setProperty('bom.y', getProperty('gf.y') - 50)
    addLuaSprite('bom');
    setObjectOrder('pixel', getObjectOrder('gf') - 1)

end
end