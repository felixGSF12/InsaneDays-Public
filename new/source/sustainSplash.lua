local sustain = {}
local ends = {'Purple', 'Blue', 'Green', 'Red'}
local pressed = false
function sustain:create() -- esta se llama en onCreatePost
    for i = 1, 4 do
        local separation = getPropertyFromGroup('playerStrums', i-1, 'x') 
        makeAnimatedLuaSprite("sustainSplash"..i, "HoldNoteEffect/holdCover"..ends[i], (i*10) + separation - 130, -50)
        addAnimationByPrefix("sustainSplash"..i, "hold","holdCover"..ends[i],21,false);
        addAnimationByPrefix("sustainSplash"..i, "end","holdCoverEnd"..ends[i],24,false);
        setObjectCamera("sustainSplash"..i, 'hud')
        setProperty("sustainSplash"..i..".visible", false)
        addLuaSprite("sustainSplash"..i, true)
        setProperty('sustainSplash'..i..'.shader',getPropertyFromGroup('grpNoteSplashes'),i-1,'shader');
    end
end


--- @param noteData integer
---
function sustain:active(noteData, isSustain) -- esta se llama en goodNoteHitPre
if isSustain  then
       setProperty("sustainSplash"..(noteData+1)..".visible", true)
      playAnim("sustainSplash"..noteData+1, "hold", false)
end
end
function sustain:endAnimation() -- esta se llama en onUpdatePost
    for i = 1, 4 do
        local default = getProperty('sustainSplash'..i..'.animation.curAnim.name')
        if (default == 'hold' and getProperty('sustainSplash'..i..'.animation.curAnim.finished')) then
        playAnim('sustainSplash'..i, 'end')
        end
        if getProperty('sustainSplash'..i..'.animation.curAnim.name') == 'end' and getProperty('sustainSplash'..i..'.animation.curAnim.finished') then
            setProperty("sustainSplash"..i..".visible", false)
        end
    end
end
function onUpdate()
     for i = 1, 4 do
        local separation = getPropertyFromGroup('playerStrums', i-1, 'x') 
        setProperty('sustainSplash'..i..'.x',(i*10)+separation- 130)
     end
end
return sustain  