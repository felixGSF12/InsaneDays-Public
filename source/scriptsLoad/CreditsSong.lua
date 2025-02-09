CoderA = '' -- PUT CODER'S USER HERE
ComposerB = '' -- PUT COMPOSER'S USER HERE
ArtistC = '' -- PUT ARTIST'S USER HERE
CharterD = '' -- PUT CHARTER'S USER HERE
enabled = true -- for SongScript

changeCreditColor = false -- change color for songz
mainColor =  '' -- Big Box Color
secondaryColor = '' -- Lines Color
SecondaryColor2 = '' -- Text Color 
---------------------------------------------------------------------------------------------------

function onCreatePost()
   
 setTextString('CODER', CoderA) -- name
 setTextString('COMPOSER', ComposerB)
 setTextString('ARTIST', ArtistC)
 setTextString('CHARTER', CharterD)
if songName == 'multiLove' then
   setTextString('CODER', 'felixGS') -- name
 setTextString('COMPOSER', 'MariUwu')
 setTextString('ARTIST', 'LuisaOG')
 setTextString('CHARTER', 'LuisaOG')
elseif week == 'day1' then
   setTextString('CODER', 'felixGS') -- name
   setTextString('COMPOSER', 'MariUwu')
   setTextString('ARTIST', 'LuisaOG')
   setTextString('CHARTER', 'IMSofi2')
elseif week == 'night2' then
   setTextString('CODER', 'felixGS') -- name
   setTextString('COMPOSER', 'MariUwu')
   setTextString('ARTIST', 'felixGS')
   setTextString('CHARTER', 'IMSofi2')
elseif week == 'day3' then
   setTextString('CODER', 'felixGS') -- name
   setTextString('COMPOSER', 'MariUwu & felixGS')
   setTextString('ARTIST', 'felixGS')
   setTextString('CHARTER', 'IMSofi2')
   setTextString('COMPOSER', 'felixGS')
elseif week == 'day4' then
   setTextString('CODER', 'felixGS') -- name
   setTextString('COMPOSER', 'MariUwu,felixGS \tLuisaOG')
   setTextString('ARTIST', 'felixGS')
   setTextString('CHARTER', 'IMSofi2')
elseif week == 'day5' then
setTextString('CODER', 'felixGS') -- name
   setTextString('COMPOSER', 'MariUwu & felixGS')
   setTextString('ARTIST', 'felixGS & LuisaOG')
   setTextString('CHARTER', 'IMSofi2')
elseif week == 'day5-mom' then
   setTextString('CODER', 'felixGS') -- name
   setTextString('COMPOSER', 'MariUwu & felixGS')
   setTextString('ARTIST', 'felixGS & LuisaOG')
   setTextString('CHARTER', 'IMSofi2')
elseif week == 'day6' then
   setTextString('CODER', 'felixGS') -- name
   setTextString('COMPOSER', 'MariUwu & LuisaOG')
   setTextString('ARTIST', 'LuisaOG')
   setTextString('CHARTER', 'felixGS')
elseif week == 'day7' then
   setTextString('CODER', 'felixGS & LuisaOG') -- name
   setTextString('COMPOSER', 'MariUwu FelixGS & LuisaOG')
   setTextString('ARTIST', 'IMSofi2')
   setTextString('CHARTER', 'IMSofi2')
elseif week == 'day8' then
   setTextString('CODER', CoderA) -- name
 setTextString('COMPOSER', ComposerB)
 setTextString('ARTIST', ArtistC)
 setTextString('CHARTER', CharterD)
elseif week == 'day9' then
   setTextString('Recreacion', 'felixGS') -- name
   setTextString('CODER', 'indieCrossTeam') -- name
 setTextString('COMPOSER','indieCrossTeam' )
 setTextString('ARTIST', 'JzBoy')
 setTextString('CHARTER', 'indieCrossTeam')
   
elseif week == 'day10' then
   setTextString('CODER', 'felixGS') -- name
   setTextString('COMPOSER', 'MariUwu')
   setTextString('ARTIST', 'MariUwu')
   setTextString('CHARTER', 'MariUwu')
elseif week == 'day10-sister' then
   setTextString('CODER', 'felixGS') -- name
   setTextString('COMPOSER', 'MariUwu')
   setTextString('ARTIST', 'MariUwu')
   setTextString('CHARTER', 'MariUwu')
elseif week == 'day11' then
   setTextString('CODER', 'felixGS') -- name
   setTextString('COMPOSER', 'MariUwu LuisaOG & felixGS')
   setTextString('ARTIST', 'FelixGS')
   setTextString('CHARTER', 'IMSofi2')
elseif week == 'day12' then
   setTextString('CODER', 'felixGS & LuisaOG') -- name
   setTextString('COMPOSER', '')
   setTextString('ARTIST', '')
   setTextString('CHARTER', '')
elseif week == 'day13' then
   setTextString('CODER', 'LuisaOG') -- name
   setTextString('COMPOSER', 'LuisaOG')
   setTextString('ARTIST', 'FelixGS')
   setTextString('CHARTER', 'IMSofi2')
elseif week == 'day14' then
   setTextString('CODER', 'FelixGS') -- name
   setTextString('COMPOSER', 'LuisaOG & MariUwu')
   setTextString('ARTIST', 'IMSofi2')
   setTextString('CHARTER', 'FelixGS')
elseif week == 'day14' then
   setTextString('CODER', 'FelixGS') -- name
   setTextString('COMPOSER', 'LuisaOG')
   setTextString('ARTIST', 'IMSofi2')
   setTextString('CHARTER', 'FelixGS')
end
end
   

 if onOrOff == false then
    setProperty('bigBox.visible', false)
    setProperty('lineLeft.visible', false)
    setProperty('lineRight.visible', false)
    setProperty('CREDITSthing.visible', false)
    setProperty('CODERthing.visible', false)
    setProperty('CODER.alpha', 0)
    setProperty('COMPOSERthing.visible', false)
    setProperty('COMPOSER.alpha', 0)
    setProperty('ARTISTthing.visible', false)  
    setProperty('ARTIST.alpha', 0)
    setProperty('CHARTERthing.visible', false)
    setProperty('CHARTER.alpha', 0)    
 end

  if changeCreditColor == true then
   doTweenColor('bigboxs', 'bigBox', mainColor, 0.01, 'linear')
   doTweenColor('lineL', 'lineLeft', SecondaryColor, 0.01, 'linear')
   doTweenColor('lineR', 'lineRight', SecondaryColor, 0.01, 'linear')
   setTextColor('CREDITSthing', SecondaryColor2)
   setTextColor('CODERthing', SecondaryColor2)
   setTextColor('COMPOSERthing', SecondaryColor2)
   setTextColor('ARTISTthing', SecondaryColor2)
   setTextColor('CHARTERthing', SecondaryColor2)
   setTextColor('CODER', SecondaryColor2)
   setTextColor('COMPOSER', SecondaryColor2)
   setTextColor('ARTIST', SecondaryColor2)
   setTextColor('CHARTER', SecondaryColor2)
  end