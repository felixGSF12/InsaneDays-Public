restart = false
local alpha = 0
isFire = false
isBullet = false
isHurtNotes = false
forHealth = false
forSignal = false
isInkNote = false
isSinNote = false
forReset = false



























function onCreate()
 frases = {'debes seguir...','no te rindas!','manten tu \ndeterminacion','puedes hacerlo mejor!','levantate!','¿enserio no superaras\n'..songName.."?"}
    local fraseIndex = 1
frase = frases[fraseIndex]
fraseDisplay = ''
 contador = 0
 limite = 5  -- Ajusta este valor para controlar la velocidad
end
function onCreatePost()
    math.randomseed(os.time())
    fraseIndex = math.random(1,#frases)
    frase = frases[fraseIndex]
    makeLuaText('f', fraseDisplay, 370, 460, 100)
	setTextSize('f', 30)
	makeLuaText('e', 'works', 370, 460, 100)
	setTextSize('e', 50)
    makeLuaText('x', "esa es la actitud!", 370, 460, 100)
	setTextSize('x', 30)
end

function onUpdatePost()
 if inGameOver == true and restart == false then
    if #fraseDisplay < #frase and contador >= limite then
        fraseDisplay = frase:sub(1, #fraseDisplay + 1)
        removeLuaText('f')
        makeLuaText('f', fraseDisplay, 370, 460, 100)
        setTextSize('f', 30)
        contador = 0
    end
    contador = contador + 1
    addLuaText('f', 1500, 1500) 
 elseif inGameOver == false then
    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.R') and not restart then
        restart = true 
        addLuaText('e', 1500, 1500)
    end
    if restart == true then
        return
    end
 end
end