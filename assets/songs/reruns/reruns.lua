function onCreatePost()
	if songName == 'ReRuns' then
	makeLuaSprite("whiteshit", "", -1050, -500)
	makeGraphic('whiteshit', 3400, 2000, '0xFFFFFFFF')
	setProperty('whiteshit.alpha', 0.00001)
	addLuaSprite('whiteshit', false)

	makeLuaSprite("blackshit", "", -1050, -500)
	makeGraphic('blackshit', 3400, 2000, '0xFF000000')
	addLuaSprite('blackshit', true)

	makeLuaSprite("vignette", "cc/cc_go", 0, 0)
	setObjectCamera('vignette', 'hud')
	addLuaSprite('vignette', false)

	setProperty('camGame.zoom', 2.4)
end
end

function onSongStart()
	if songName == 'ReRuns' then
	doTweenAlpha('blackshitOut', 'blackshit', 0.5, 7.5)
	doTweenZoom('camOut', 'camGame', 1.2, 7.5)
end
end

function onBeatHit()
if songName == 'ReRuns' then
	if curBeat == 33 then
		doTweenAlpha('blackshitIn', 'blackshit', 1, 0.4)
	end
	if curBeat == 34 then
		setProperty('vignette.alpha', 0.00001)
		setProperty('blackshit.alpha', 0.00001)
	end
	if curBeat == 96 then
		doTweenAlpha('vignetteIn', 'vignette', 0.8, 1.5)
	end
	if curBeat == 98 then
		setProperty('guards.alpha', 1)
	end
	if curBeat == 112 then
		setProperty('ST.alpha', 0.8)
		setProperty('ST1.alpha', 0.8)
		doTweenAlpha('blackshitIn', 'blackshit', 1, 0.4)
		doTweenAlpha('camHUDFade', 'camHUD', 0.1, 0.8)
		doTweenZoom('camIn', 'camGame', 1.8, 0.8)
	end
	if curBeat == 114 then
		setProperty('camGame.zoom', 0.8)
		setProperty('ST.alpha', 0.00001)
		setProperty('ST1.alpha', 0.00001)
		setProperty('camHUD.alpha', 1)
		setProperty('blackshit.alpha', 0.00001)
		doTweenAlpha('blackshitIn', 'blackshit', 0.8, 7.8)
		doTweenZoom('camIn', 'camGame', 1.2, 7.8)
	end
	if curBeat == 131 then 
		setProperty('blackshit.alpha', 0.00001)
		setProperty('vignette.alpha', 0.00001)
	end
	if curBeat == 160 then
		doTweenAlpha('blackshitIn', 'blackshit', 1, 0.8)
		doTweenAlpha('camHUDFade', 'camHUD', 0.1, 0.8)
		doTweenAlpha('vignetteIn', 'vignette', 0.8, 1.5)
		doTweenAlpha('cd_glitchIn', 'cd_glitch', 1, 0.8)
		playAnim('cd_glitch', 'cb', true)
	end
	if curBeat == 162 then
		setProperty('blackshit.alpha', 0.00001)
		setProperty('camHUD.alpha', 1)
		setProperty('vignette.alpha', 0.00001)
		for i=0,3 do
			noteTweenAlpha('noteFade'..i, i, 0.4, 4, 'linear')
			noteTweenX('centerSlide'..i, i, (-228 + (getPropertyFromClass('Note', 'swagWidth') * i) + (screenWidth / 2)), 4, 'linear')
			noteTweenX('centerSlide'..i + 4, i + 4, (-228 + (getPropertyFromClass('Note', 'swagWidth') * i) + (screenWidth / 2)), 4, 'linear')
		end
		setProperty('vignette.alpha', 0.00001)
		setProperty('cd_glitch.alpha', 0.00001)
	end
	if curBeat == 176 then
		doTweenAlpha('blackshitIn', 'blackshit', 1, 0.8)
	end
	if curBeat == 179 then
		setProperty('blackshit.alpha', 0.00001)
		setProperty('vignette.alpha', 0.00001)
		for i=0,3 do
			noteTweenAlpha('noteUnFade'..i, i, 1, 0.4, 'linear')
			noteTweenX('noteReturn'..i, i, _G['defaultOpponentStrumX'..i], 0.4, 'bounceOut')
			noteTweenX('noteReturn'..i + 4, i + 4, _G['defaultPlayerStrumX'..i], 0.4, 'bounceOut')
        end
	end
	if curBeat == 209 then
		setProperty('camGame.alpha', 0.00001)
		setProperty('camHUD.alpha', 0.00001)
		setProperty('whiteshit.alpha', 1)
		setProperty('vignette.alpha', 1)
	end
	if curBeat == 210 then
		setProperty('camGame.alpha', 1)
		setProperty('camHUD.alpha', 1)
		setProperty('dad.color', '0xFF000000')
		setProperty('boyfriend.color', '0xFF000000')
		setProperty('gf.color', '0xFF000000')
		cameraFlash('game', '0xFFFF0000', 0.5, true)
		doTweenZoom('camOut', 'camGame', 0.4, 3)
	end
	if curBeat == 224 then
		doTweenAlpha('blackshitIn', 'blackshit', 1, 0.8)
	end
	if curBeat == 226 then
		setProperty('blackshit.alpha', 0.00001)
	end
	if curBeat == 240 then
		doTweenZoom('camIn', 'camGame', 1.8, 0.4)
		doTweenAlpha('blackshitIn', 'blackshit', 1, 0.8)
		doTweenAlpha('STin', 'ST', 1, 0.4)
		doTweenAlpha('ST1in', 'ST1', 1, 0.4)
	end
	if curBeat == 241 or curBeat == 273 then
		doTweenAlpha('STout', 'ST', 0.00001, 0.4)
		doTweenAlpha('ST1out', 'ST1', 0.00001, 0.4)
	end
	if curBeat == 242 then
		setProperty('blackshit.alpha', 0.00001)
		setProperty('whiteshit.alpha', 0.00001)
		--why does it need to be tweened why cant i just set it? i dunno because its fucking stupid i guess....,,
		doTweenColor('dadColorReturn', 'dad', '0xFFFFFFFF', 0.00001)
		doTweenColor('boyfriendColorReturn', 'boyfriend', '0xFFFFFFFF', 0.00001)
		doTweenColor('gfColorReturn', 'gf', '0xFFFFFFFF', 0.00001)
	end
	if curBeat == 258 then
		doTweenAlpha('blackshitIn', 'blackshit', 0.8, 2.8)
	end
	if curBeat == 264 then
		doTweenAlpha('blackshitOut', 'blackshit', 0.00001, 0.8)
	end
	if curBeat == 266 then
		doTweenZoom('camIn', 'camGame', 2.4, 8)
		doTweenAlpha('camGameFade', 'camGame', 0.00001, 8)
		doTweenAlpha('camHUDFade', 'camHUD', 0.00001, 8)
	end
	if curBeat == 268 then
		doTweenAlpha('STin', 'ST', 0.5, 0.8)
	end
	if curBeat == 272 or curBeat == 277 then
		setProperty('ST.alpha', 1)
		setProperty('ST1.alpha', 1)
	end
	if curBeat == 270 or curBeat == 278 then
		setProperty('ST.alpha', 0.00001)
		setProperty('ST1.alpha', 0.00001)
	end
	if curBeat == 211 or curBeat == 212 or curBeat == 213 or curBeat == 214 or curBeat == 215 or curBeat == 216 or curBeat == 218
	or curBeat == 220 or curBeat == 222 or curBeat == 223 or curBeat == 224 or curBeat == 225 or curBeat == 226 or curBeat == 227 
	or curBeat == 228 or curBeat == 230 or curBeat == 231 or curBeat == 232 or curBeat == 234 or curBeat == 236 or curBeat == 237
	or curBeat == 238 or curBeat == 239 then
		cameraFlash('game', '0xFFFF0000', 0.5, true)
	end
end
end

function onStepHit()
	if songName == 'ReRuns' then
--	if curStep == 644 or curStep == 646 then
--		setProperty('funni_cd_glitch.alpha', 1)
--	end
--	if curStep == 645 or curStep == 647 then
--		setProperty('funni_cd_glitch.alpha', 0.00001)
--	end
	if curStep == 980 then
		setProperty('ST.alpha', 1)
	end
	if curStep == 981 then
		setProperty('ST.alpha', 0.00001)
		setProperty('cd.x', 708)
		setProperty('cd.y', -1081)
		setProperty('cd.alpha', 1)
		objectPlayAnimation('cd', 'fall', true)
	end
	if curStep == 984 then
		setProperty('ST.alpha', 1)
	end
	if curStep == 986 then
		setProperty('ST.alpha', 0.00001)
		setProperty('cd.x', 730)
		setProperty('cd.y', 300)
		objectPlayAnimation('cd', 'idle', true)	
	end
	if curStep == 994 then
		doTweenAlpha('ST1in', 'ST1', 1, 0.4)
	end
	if curStep == 1000 or curStep == 1016 then
		setProperty('ST1.alpha', 0.00001)
	end
	if curStep == 1014 then
		setProperty('ST1.alpha', 0.00001)
	end
end
end