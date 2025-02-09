function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if not isSustainNote then
        triggerEvent("Add Camera Zoom", "0.020", "0.04")
    end
end
--Mario's Madness V2 Show Song Script
--THIS SCRIPT NOW WORKS ON PSYCH 0.7.X!

local felixSongs = { --canciones compuestas por Felix
	'MultiLove',
	'Anorexic',
	'insane',
	'Vape',
	'mom-vs-son',
	'mothers-love',
	'daddy',
	'daddy song',
	'dad rap',
	'purgatory',
	'Dead life',
	'Remember Me',
	'Classism',
	'RedEx',
	'Bandit',
	'Otaku',
}
local mariSongs = {
	'ex-gf',
	'betrayal distance',
	'Esquizofrenia',
	'willPower',
	'Infinite Love',
	'Mom Battle',
	'OnlySolfe',
	'SolfeFunk',
	'OverProtective',
	'gigaImpact',
	'Mad defense',
	'dear sister',
	'ReRuns',
	'Rapper Battle',
	'isaBM',
	'improbable outset',
	'Combo Meal',
	'Cuties Friends',
	'ExMari',
	'Egocentrics',
	'No Vaper',
	'exBoss Rap',
	'Spousal Homicide',

}
local luisaSongs = { --canciones compuesta por Luisa
	'Shot Head', --Este es el Remix
	'racoonlovania',
	'Dark Hot',
	'furryphobia',
	'Vaper',
	'Friendship roses',
	'Withered',
	'Assault',
	'authoritarian'
}
local michellSongs = { --canciones compuestas por Michell!
	'Darkangel',
	'2hot-bf',
	'Fright Fest',
	'Cursed Mirror',
	'Ratero',
	'Popayano',
	'Double Trouble',
	'Madness',
	'The Idea',
	'shot head (M mix)',
	'Monetary Killer'

};
local otherMods_recreations = {
	mari = {
		'Ritual',
		'Terrible-Sin',
		'Last Reel'
	}
}
function onSongStart()
	if getPropertyFromClass("ClientPrefs","intro") == true then
	makeLuaText('titleText', songName, 1000, 132, 301)
	setTextSize('titleText', 50)
	setTextColor('titleText', 'FFFFFF')
	setTextBorder('titleText', 2, "000000")
	setObjectCamera('titleText', 'other')
	setTextFont('titleText', 'Neutra.ttf')
	addLuaText('titleText')
	setProperty('titleText.alpha', 0)
doTweenAlpha('showTitleText', 'titleText', 1, 0.1, linear)

	makeLuaSprite('TheLine', 'LINE', 344, 368)
	makeGraphic('TheLine', 575, 3, 'FFFFFF')
	setObjectCamera('TheLine', 'other')
	setProperty('TheLine.alpha', 0)
	addLuaSprite('TheLine', true)
	doTweenAlpha('showBorder', 'TheLine', 1, 0.1, linear)


    for _,songFelix in ipairs(felixSongs) do
        if songName ==  songFelix then
        makeLuaText('authorText', "FelixGSF", 1000, 132, 374)
    	setTextSize('authorText', 35)
		setProperty('authorText.alpha', 0)
	setTextColor('authorText', 'FFFFFF')
	setTextBorder('authorText', 2, '000000')
	setTextFont('authorText', 'Neutra.ttf')
	setObjectCamera('authorText', 'other')
    	addLuaText('authorText')
	doTweenAlpha('showAuthorText', 'authorText', 1, 0.1, linear)
    end
end
for _,songMari in ipairs(mariSongs) do
    if songName ==  songMari then
        makeLuaText('authorText', "Mari_OG", 1000, 132, 374)
    	setTextSize('authorText', 35)
		setProperty('authorText.alpha', 0)
	setTextColor('authorText', 'FFFFFF')
	setTextBorder('authorText', 2, '000000')
	setTextFont('authorText', 'Neutra.ttf')
	setObjectCamera('authorText', 'other')
    	addLuaText('authorText')
	doTweenAlpha('showAuthorText', 'authorText', 1, 0.1, linear)
    end
end
for _,songLuisa in ipairs(luisaSongs) do
    if songName ==  songLuisa then
        makeLuaText('authorText', "Lu1z4_OG", 1000, 132, 374)
    	setTextSize('authorText', 35)
		setProperty('authorText.alpha', 0)
	setTextColor('authorText', 'FFFFFF')
	setTextBorder('authorText', 2, '000000')
	setTextFont('authorText', 'Neutra.ttf')
	setObjectCamera('authorText', 'other')
    	addLuaText('authorText')
	doTweenAlpha('showAuthorText', 'authorText', 1, 0.1, linear)
    end
end
for _,songMichell in ipairs(michellSongs) do
    if songName ==  songMichell then
        makeLuaText('authorText', "Michell_art1", 1000, 132, 374)
    	setTextSize('authorText', 35)
		setProperty('authorText.alpha', 0)
	setTextColor('authorText', 'FFFFFF')
	setTextBorder('authorText', 2, '000000')
	setTextFont('authorText', 'Neutra.ttf')
	setObjectCamera('authorText', 'other')
    	addLuaText('authorText')
	doTweenAlpha('showAuthorText', 'authorText', 1, 0.1, linear)
    end
end
end
end
function onUpdate()
	setProperty('titleText.color', getIconColor('dad'))
    if curStep >= 23 then
        doTweenAlpha("showBorder2", "titleText", 0, 0.6, "elasticOut")
     setProperty("authorText.alpha", getProperty("titleText.alpha"))
     setProperty("TheLine.alpha", getProperty("titleText.alpha"))
    end 
end
function getIconColor(chr)
    local chr = chr or "dad"
    return getColorFromHex(rgbToHex(getProperty(chr .. ".healthColorArray")))
end

function rgbToHex(array)
    return string.format('%.2x%.2x%.2x', array[1], array[2], array[3])
end
function onTweenCompleted(tag)
	if tag == "showBorder2" then
		removeLuaText("titleText");
		removeLuaText("authorText");
		removeLuaSprite("TheLine");
	end
end