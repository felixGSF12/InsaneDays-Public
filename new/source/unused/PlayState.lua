
local camMovement = 60
local velocity = 3
local campointx = 600
local campointy = 680
local camlockx = 0
local camlocky = 0
local camlock = false
local bfturn = false

function opponentNoteHit(index, noteData, noteType, isSustain)
    
    if getProperty('health') > 0.1 then
        setProperty('health', getProperty('health') - 0.02 * getProperty("healthLoss"));
    end
    if not bfturn then
		if noteData == 0 then
			camlockx = campointx - camMovement
			camlocky = campointy
		elseif noteData == 1 then
			camlocky = campointy + camMovement
			camlockx = campointx
		elseif noteData == 2 then
			camlocky = campointy - camMovement
			camlockx = campointx
		elseif noteData == 3 then
			camlockx = campointx + camMovement
			camlocky = campointy
		end
	--nice--
	runTimer('camreset', 1)
	setProperty('cameraSpeed', velocity)
	camlock = true
	end	
end

function onUpdate() 
        dadColR = getProperty('dad.healthColorArray[0]')
        dadColG = getProperty('dad.healthColorArray[1]')
        dadColB = getProperty('dad.healthColorArray[2]')
        dadColFinal = string.format('%02x%02x%02x', dadColR, dadColG, dadColB)
        setTimeBarColors(dadColFinal, "000000")
        
        if camlock then
	setProperty('camFollow.x', camlockx)
	setProperty('camFollow.y', camlocky)
	end
end
function onMoveCamera(focus)
	if focus == 'boyfriend' then
	campointx = getProperty('camFollow.x')
	campointy = getProperty('camFollow.y')
	bfturn = true
	camlock = false
	setProperty('cameraSpeed', 1)
	
	elseif focus == 'dad' then
	campointx = getProperty('camFollow.x')
	campointy = getProperty('camFollow.y')
	bfturn = false
	camlock = false
	setProperty('cameraSpeed', 1)
	
	end
end
function goodNoteHit(id, noteData, noteType, isSustainNote)
	if bfturn then
		if noteData == 0 then
			camlockx = campointx - camMovement
			camlocky = campointy
		elseif noteData == 1 then
			camlocky = campointy + camMovement
			camlockx = campointx
		elseif noteData == 2 then
			camlocky = campointy - camMovement
			camlockx = campointx
		elseif noteData == 3 then
			camlockx = campointx + camMovement
			camlocky = campointy
		end
	runTimer('camreset', 1)
	setProperty('cameraSpeed', velocity)
	camlock = true
	end	
end


function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'camreset' then
	camlock = false
	setProperty('cameraSpeed', 1)
	setProperty('camFollow.x', campointx)
	setProperty('camFollow.y', campointy)
	end
end
