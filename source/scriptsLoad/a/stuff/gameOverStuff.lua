restart = false
local alpha = 0
isFire = false
isBullet = false
isHurtNotes = false
naturalCause = false
forHealth = false
isRayoNote = false
forSignal = false
isInkNote = false
isSinNote = false
forReset = false
healthDrain = 0;



function noteMiss(id, noteData, noteType, isSustainNote)
    health = getProperty('health')
    if noteType == 'FireNote' and health <= 0 then -- por fire notes
        isFire = true
    elseif health <= 0 then --por salud
        naturalCause = true
    end
    if noteType == 'RayoNote' then
        isRayoNote = true  
    end
    if noteType == 'warningNOTE' and health >= 0 then
        isBullet = true
        naturalCause = false
    elseif  noteType == 'warningNOTE' and health <= 0 then
        naturalCause = true
        isBullet = false
end
end


function onCreatePost()
    --motivo de muerte:
    if isFire == true then
        makeLuaText("motivo", "has muerto por: Fire Notes", 370, 460, 600);
    end
    if forReset == true then
        makeLuaText("motivo", "has muerto por: Presionar (R) ", 370, 460, 600);
        setTextSize("motivo", 30)
    end
    if naturalCause == true then
        makeLuaText("motivo", "has muerto por: tu salud llego a 0 ", 370, 460, 600);
        setTextSize("motivo", 30)
    end
    if isRayoNote == true then
        makeLuaText("motivo", "has muerto por: Darka te quemo... ", 370, 460, 600);
        setTextSize("motivo", 30)
    end
    if isBullet == true then
        makeLuaText("motivo", "has muerto por:\nFelicidades Rayo te disparon ", 370, 460, 600);
        setTextSize("motivo", 30)
    end
    setTextSize("motivo", 30)
end


function onUpdatePost()
    key()
    if isFire == true  then
        makeLuaText("motivo", "has muerto por: \n Fire Notes", 370, 460, 600);
        setTextSize("motivo", 30)
    end
    if forReset == true then
        makeLuaText("motivo", "has muerto por: \nPresionar (R) ", 370, 460, 600);
        setTextSize("motivo", 30)
    end
    if naturalCause == true then
        makeLuaText("motivo", "has muerto por: \ntu salud llego a 0 ", 370, 460, 600);
        setTextSize("motivo", 30)
    end
    if isRayoNote == true then
        makeLuaText("motivo", "has muerto por: \nDarkangel te quemo!... ", 370, 460, 600);
        setTextSize("motivo", 30)
    end
    if isBullet == true and naturalCause == false then
        makeLuaText("motivo", "has muerto por:\nte han disparado", 370, 460, 600);
        setTextSize("motivo", 30)
    end
 if inGameOver == true and restart == false then
        contador = 0
    end
    contador = contador + 1
    addLuaText('f', 1500, 1500) 
    addLuaText("motivo") 
end
function key()
    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.R') then
        forReset = true
    end
end