local Notes = 0
local NoteHit = false;
-- NPS Didnt work properly for some reason. Dont enable it, Please :)

function milliToHuman(milliseconds) -- https://forums.mudlet.org/viewtopic.php?t=3258
	local totalseconds = math.floor(milliseconds / 1000)
	local seconds = totalseconds % 60
	local minutes = math.floor(totalseconds / 60)
	minutes = minutes % 60
	return string.format("%02d:%02d", minutes, seconds)  
end

-- Le settings --
local pref = {
	HideTB = false, --Hides TimeBar
	HideTimeTxt = false, --Hides TimeTxt
	Font = 'vcr.ttf', --Font that the HUD will use (default is vcr.ttf)
	ScoreX = 0, --X For ScoreTxt
	ScoreY = 470, --Y For ScoreTxt
	AccX = 0, --X For AccTxt
	AccY = 400, --Y For AccTxt
	MissX = 0, --X For MissTxt
	MissY = 500, --Y For MissTxt
	ShowWatermark = true, --Shows a watermark that you can customize :)
	WatermarkTxt = 'LuisaHud 1.2', --Custom Watermark?!!
	WatermarkX = 5, --X For watermark
	WatermarkY = 5, --Y For watermark
	ScoreTextAlignment = 'left', --Aligment for Score text 
	AccTextAlignment = 'center', --Aligment for Accuracy text 
	MissTextAlignment = 'right', --Aligment for Miss text
	WatermarkTextAlignment = 'left', --Aligment for text (Applies for all textesses)
	BotplayTxt = 'AUTOPLAY', --Change Botplay Text?!!
	BotplayX = 410, --X For Botplay
	BotplayY = 100 ,--Y For Botplay
	timeBarY = 300,
	LockToHB = false --Locks the scorings to HealthBar (Showing the vanilla ones)
	
}

function onCreatePost()
	--addLuaScript("scripts/hud/goofyscript")
	--removeLuaSprite("Health")
	removeLuaScript("iconsStuff")
	setProperty('timeTxt.y', getProperty('timeTxt.y') + 650)
    setProperty('timeBar.y', getProperty('timeBar.y') + 650 )
	setProperty('timeTxt.x', getProperty('timeTxt.x') + -500)
    setProperty('timeBar.x', getProperty('timeBar.x') + 0 )
    setProperty('scoreTxt.visible', false)

	if (pref.HideTB) then
	setProperty('timeBarBG.visible', false)
    setProperty('timeBar.visible', false)
	end
	
	if (pref.HideTimeTxt) then
	setProperty('timeTxt.visible', false)
	end
	
	setTextFont('timeTxt',pref.Font)
	setProperty('timeBar.scale.x',getProperty('timeBar.scale.x')+2)
	setProperty('timeBarBG.scale.x',getProperty('timeBarBG.scale.x')+2)
	setTextSize('timeTxt', 24)
	setTextFont('botplayTxt',pref.Font)
	setTextSize('botplayTxt', 22)
	setTextString('botplayTxt',pref.BotplayTxt)
	setProperty('botplayTxt.x',pref.BotplayX)
	setProperty('botplayTxt.y',pref.BotplayY)

	makeLuaText('micdupscore','Score: 0',0,40,0)
	setProperty('micdupscore.x',pref.ScoreX)
	setProperty('micdupscore.y',pref.ScoreY)
	setTextSize('micdupscore', 21)
	addLuaText('micdupscore')
	setTextFont('micdupscore',pref.Font)
	setTextAlignment('micdupscore', pref.ScoreTextAlignment)
	
	makeLuaText('micdupmiss','Misses: 0',0,40,0)
	setProperty('micdupmiss.x',pref.MissX)
	setProperty('micdupmiss.y',pref.MissY)
	setTextSize('micdupmiss', 21)
	addLuaText('micdupmiss')
	setTextFont('micdupmiss',pref.Font)
	setTextAlignment('micdupmiss', pref.MissTextAlignmentTextAlignment)

	makeLuaText('micdupacc','Accuracy: 0%',0,40,0)
	setProperty('micdupacc.x',pref.AccX)
	setProperty('micdupacc.y',pref.AccY)
	setTextSize('micdupacc', 21)
	addLuaText('micdupacc')
	setTextFont('micdupacc',pref.Font)
	setTextAlignment('micdupacc', pref.AccTextAlignment)

	makeLuaText('nps','Notes: 0',0,0,0)
	setProperty('nps.y',getProperty('healthBarBG.y')-200)
	setTextSize('nps', 21)
	addLuaText('nps')
	setTextFont('nps',pref.Font)

	makeLuaText('Watermark', pref.WatermarkTxt,0,0,15)
	setProperty('Watermark.x',pref.WatermarkX)
	setProperty('Watermark.y',pref.WatermarkY)
	setTextFont('Watermark',pref.Font)
	setTextAlignment('Watermark', pref.WatermarkTextAlignment)
	
	if (pref.LockToHB) then
	setProperty('scoreTxt.visible', true)
	setProperty('micdupscore.visible', false)
	setProperty('micdupacc.visible', false)
	setProperty('micdupmiss.visible', false)
	end

    if (pref.ShowWatermark) then
	addLuaText('Watermark')
	end
	
	if botPlay == true then
	setProperty('micdupscore.visible', false)
	setProperty('micdupacc.visible', false)
	setProperty('micdupmiss.visible', false)
	end
end

	function onRecalculateRating()
	setTextString('micdupacc','Accuracy: '..round(rating * 100, 2)..'%')
	setTextString('micdupmiss','Misses: '..misses)
	setTextString('micdupscore','Score: '..score)
	setTextString('nps','NPS: '..Notes)
	scaleObject('micdupscore', 1.1, 1.1, false)
	doTweenX('guhX', 'micdupscore.scale', 1, 0.4, 'quintOut')
	doTweenY('guhY', 'micdupscore.scale', 1, 0.4, 'quintOut')
	scaleObject('micdupacc', 1.1, 1.1, false)
	doTweenX('guh2X', 'micdupacc.scale', 1, 0.4, 'quintOut')
	doTweenY('guh2Y', 'micdupacc.scale', 1, 0.4, 'quintOut')
	scaleObject('micdupmiss', 1.1, 1.1, false)
	doTweenX('guh3X', 'micdupmiss.scale', 1, 0.4, 'quintOut')
	doTweenY('guh3Y', 'micdupmiss.scale', 1, 0.4, 'quintOut')
end

	if downscroll then
	setProperty('black.y', 690)
	setProperty('gray.y', 695)
	setProperty('green.y', 695)
	setProperty('songname.y', 690)
end

function round(x, n) --https://stackoverflow.com/questions/18313171/lua-rounding-numbers-and-then-truncate
    n = math.pow(10, n or 0)
    x = x * n
    if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
    return x / n
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    if not isSustainNote then
        Notes = Notes + 1
        NoteHit = false;
    end

    ezTimer('drain', 1, function()
        NoteHit = true;
    end)  
end

timers = {}
function ezTimer(tag, timer, callback) -- Better
    table.insert(timers,{tag, callback})
    runTimer(tag, timer)
end

function onTimerCompleted(tag)
    for k,v in pairs(timers) do
        if v[1] == tag then
            v[2]()
        end
    end
end
function math.lerp(a,b,t)
 return(b-a) * t + a;
end
function math.remapToRange(value,start1,stop1,start2,stop2)
 return start2 + (stop2 - start2) * ((value - start1)/(stop1 - start1))
end