
colored_text = ""

-- Unqiue Rating Animations
unique_rating_animations = false
-- If set to true, each rating will have its own unique animation that plays when it pops up.

--- ACTUAL CODE ------------------------------------------------------------------------------ 

ratingColor = "FFFFFF"

rainbowTime = 0.75

weekThemes = {
	{"FFC6EF", "F44254", "AFCAD3", "696F96"}, -- Week 1
	{"86BCFF", "91C53C", "C7463F", "E62145"}, -- Week 2
	{"FD6922", "55E858", "D78F5B", "B91C37"}, -- Week 3
	{"FFC6EF", "F3E05A", "EE1536", "2B263C"}, -- Week 4
	{"9FC5FD", "F6F097", "4566FC", "5C417E"}, -- Week 5
	{"FF45A1", "FAA66D", "96BEB5", "161C47"}, -- Week 6
	{"FFFFFF", "F7B804", "E1A244", "6E3D2A"} -- Week 7
}
function onCreate()
	setPropertyFromClass('ClientPrefs', 'comboOffset[0]', 9999)
	
	setProperty('showComboNum', false)
	end
	


function onCreatePost()
	
	if botPlay then
		if downscroll then
			comboTextY = getProperty('scoreTxt.y') + 460
		else
			comboTextY = getProperty('botplayTxt.y') + 60
		end
	else
		if downscroll then
			comboTextY = getProperty('scoreTxt.y') + 50
		else
			comboTextY = getProperty('botplayTxt.y')
		end
	end
	setProperty('comboSpr.visible', false)
	
	makeLuaText('comboTxt', '', 400, getProperty('scoreTxt.x'), comboTextY)
	setTextSize('comboTxt', 42)
	setTextBorder('comboTxt', 4, '000000')
	setTextFont('comboTxt', 'vcr.ttf')
	setTextAlignment('comboTxt', 'center')
	addLuaText('comboTxt')
	screenCenter('comboTxt', 'x')
	if  getPropertyFromClass('PlayState', 'isPixelStage')   then
		setTextFont('comboTxt', 'PixeloidMono.ttf')
		isPixel = true
	end	
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	
	local rawNoteRating = getPropertyFromGroup('notes', id, 'rating')
	local noteRating = rawNoteRating
	
	if not isSustainNote then
		--SICK
		if rawNoteRating == 'sick' then
			noteRating = "Insano!!"
			ratingColor = "FFCD00"
			if colored_text == "Kade Engine" then
				ratingColor = "ABFFFF"
			elseif colored_text == "Week Themes" then
				ratingColor = weekThemes[weekRaw][1]
			end
		--GOOD
		elseif rawNoteRating == 'good' then
			noteRating = "Bien!!"
			ratingColor = "FFFFFF"
			if colored_text == "Kade Engine" then
				ratingColor = "A4FFAB"
			elseif colored_text == "Week Themes" then
				ratingColor = weekThemes[weekRaw][2]
			end
				
		--BAD
		elseif rawNoteRating == 'bad' then
			noteRating = "Meh!"
			ratingColor = "FFFFFF"
			if colored_text == "Kade Engine" then
				ratingColor = "CC7484"
			elseif colored_text == "Week Themes" then
				ratingColor = weekThemes[weekRaw][3]
			end
			
		--SHIT
		elseif rawNoteRating == 'shit' then
			noteRating = "MIERDA!"
			ratingColor = "550000"
			if colored_text == "Kade Engine" then
				ratingColor = "A9263F"
			elseif colored_text == "Week Themes" then
				ratingColor = weekThemes[weekRaw][4]
			end
		end
	end
	
	if not isSustainNote then
		--cancel tweens
		cancelTween('comboTxtAlphaTween')
		cancelTween('ratingScaleTweenAngle')
		cancelTween('ratingScaleTweenX')
		cancelTween('ratingPosTweenY')
		cancelTween('ratingScaleTweenY')
		-- reset all properties
		setProperty('comboTxt.y', 150)
		setProperty('comboTxt.alpha', 1)
		setProperty('comboTxt.angle', 0)
		setProperty('comboTxt.scale.x', 1)
		setProperty('comboTxt.scale.y', 1)	
		-- set string
		setTextString('comboTxt', noteRating .. "\n" .. getProperty('combo'))
		setTextColor('comboTxt', ratingColor)

		
		
		if unique_rating_animations then
			--SICK ANIMATION
			if noteRating == "Sick!!" then
				setProperty('comboTxt.angle', -5)
				setProperty('comboTxt.scale.x', 1.8)
				setProperty('comboTxt.scale.y', 1.8)	
				doTweenX('ratingScaleTweenX', 'comboTxt.scale', 1, 0.7, 'expoOut');
				doTweenY('ratingScaleTweenY', 'comboTxt.scale', 1, 0.7, 'expoOut');
				doTweenAngle('ratingScaleTweenAngle', 'comboTxt', 5, 0.7, 'linear')
			--GOOD ANIMATION
			elseif noteRating == "Good!" then
				setProperty('comboTxt.scale.x', 1.6)
				setProperty('comboTxt.scale.y', 1.6)	
				doTweenX('ratingScaleTweenX', 'comboTxt.scale', 1, 0.7, 'expoOut');
				doTweenY('ratingScaleTweenY', 'comboTxt.scale', 1, 0.7, 'expoOut');
			--BAD ANIMATION
			elseif noteRating == "Bad" then
				setProperty('comboTxt.scale.x', 1.3)
				setProperty('comboTxt.scale.y', 1.3)	
				doTweenX('ratingScaleTweenX', 'comboTxt.scale', 1, 0.7, 'expoOut');
				doTweenY('ratingScaleTweenY', 'comboTxt.scale', 1, 0.7, 'expoOut');
				doTweenAngle('ratingScaleTweenAngle', 'comboTxt', -10, 0.7, 'linear')
			--SHIT ANIMATION
			elseif noteRating == "Shit" then
				setProperty('comboTxt.scale.x', 1.0)
				setProperty('comboTxt.scale.y', 1.0)	
				doTweenX('ratingScaleTweenX', 'comboTxt.scale', 1, 0.7, 'expoOut');
				doTweenY('ratingScaleTweenY', 'comboTxt.scale', 1, 0.7, 'expoOut');
				doTweenY('ratingPosTweenY', 'comboTxt', comboTextY + 25, 0.7, 'linear');
				doTweenAngle('ratingScaleTweenAngle', 'comboTxt', -20, 0.7, 'linear')
			end
		else
			setProperty('comboTxt.scale.x', 1.6)
			setProperty('comboTxt.scale.y', 1.6)	
			doTweenX('scaleTweenX', 'comboTxt.scale', 1, 0.7, 'expoOut');
			doTweenY('scaleTweenY', 'comboTxt.scale', 1, 0.7, 'expoOut');
		end	
		doTweenAlpha('comboTxtAlphaTween', 'comboTxt', 0, 0.5, 'linear')
	end
end

function onTweenCompleted(tag)
	if tag == 'comboTxtAlphaTween' then
		comboTxt.alpha = 0
	end
end
