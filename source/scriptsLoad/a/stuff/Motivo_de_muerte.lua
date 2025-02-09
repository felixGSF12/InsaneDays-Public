isFire = false
isBullet = false
isHurtNotes = false
forHealth = false
forSignal = false
isInkNote = false
isSinNote = false
function onCreatePost()--xd
    makeLuaText("Motivo", "Has muerto por: Fire Notes", 370, 460, 100)
    setTextSize("Motivo", 30)
    addLuaText("Motivo", 1500, 1500)
end

function onUpdatePost()--xd
     --   removeLuaText("Motivo")
        makeLuaText("Motivo", "Has muerto por: Fire Notes", 370, 460, 100)
        setTextSize("Motivo", 30)
        addLuaText("Motivo", 1500, 1500)
    end
function onGameOverStart()
    onUpdatePost()
    onCreatePost()
    
end