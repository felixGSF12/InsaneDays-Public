---@diagnostic disable
local felixVariantes = {"felix", "felixN", "felixWeek3", "felix_chained", "felixSuit", "felixShade", "felixSa"}
local mariVariantes = {"mariP1", "mariP1N", "mariW3_Playable", "mariP1Suit", "mariSuit-shadeP1", "mariSa"}
local bools = {
    isFelix = false,
    isMari = false,
    isRayo = false,
    isLuisa = false;
}
local cry = false
---@class DeathManager

function onCreatePost()
    RayoEvent()
    onChangeGender()
    for _, felixName in ipairs(felixVariantes) do --usamos un for para no usar muchos "if"
        if boyfriendName == felixName then
            setPropertyFromClass('GameOverSubstate', 'characterName', 'felixDead')
            setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx')
            setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver')
            setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd')
        end
    end

    for _, mariName in ipairs(mariVariantes) do
        if boyfriendName == mariName then
            setPropertyFromClass('GameOverSubstate', 'characterName', 'mariDead')
            setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'mariDeath')
            setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'mariGameOver')
            setPropertyFromClass('GameOverSubstate', 'endSoundName', 'mariConfirm')
        end
    end
    if boyfriendName == "rayo-player" then
        setPropertyFromClass('GameOverSubstate', 'characterName', 'rayoDiesxd'); 
        setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'rayoloss');
        setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'rayogameOver');
        setPropertyFromClass('GameOverSubstate', 'endSoundName', 'rayogameOverEnd')

    elseif boyfriendName == "sisterPlayable" then
        setPropertyFromClass('GameOverSubstate', 'characterName', 'luisaDead'); 
        setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'sisterLoss');
        setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'sisterGameOver');
        setPropertyFromClass('GameOverSubstate', 'endSoundName', 'sisterConfirm')
    
elseif  boyfriendName == "felixAndMari" then
    setPropertyFromClass('GameOverSubstate', 'characterName', 'fxANDmari-dead'); 
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx');
    setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver');
    setPropertyFromClass('GameOverSubstate', 'endSoundName', 'mariConfirm')
elseif getPropertyFromClass("PlayState", "isPixelStage") == true and boyfriendName == "felixPixel" then
    setPropertyFromClass('GameOverSubstate', 'characterName', 'pixelDead'); 
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx-pixel');
    setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver-pixel');
    setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd')
elseif getPropertyFromClass("PlayState", "isPixelStage") == true and boyfriendName == "mariPixelP1"  then
    setPropertyFromClass('GameOverSubstate', 'characterName', 'mariPixelDead');
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'mariDeath')
    setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'mariGameOver')
    setPropertyFromClass('GameOverSubstate', 'endSoundName', 'mariConfirm')
elseif getPropertyFromClass("PlayState", "isPixelStage") == true and boyfriendName == "felixAndMari-pixel" then
    setPropertyFromClass('GameOverSubstate', 'characterName', 'felixAndMariDeadPixel');
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'fnf_loss_sfxw')
    setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'mariGameOver')
    setPropertyFromClass('GameOverSubstate', 'endSoundName', 'mariConfirm')
end
end





--[[
Controla los eventos de la week de rayo
como por ejemplo si juegan con mari, tu oponente en vez de ser "rayo" sera su hermana
y asi
]]
function RayoEvent()
    local gender = getPropertyFromClass("ClientPrefs", "myLove");
    if gender == true and dadName == "rayo" then
        triggerEvent("Change Character", 'dad', 'sisterRival')
    elseif gender == true and dadName == "rayoN" then
        triggerEvent("Change Character", 'dad', 'sisterN')
    end
end








---@class GenderSwarp
function onChangeGender()
    local roles = getPropertyFromClass("ClientPrefs", "myLove");
    if roles == true  then
        if boyfriendName == felixVariantes[1] then
            if curStage == "date" or songName == "Thats all Folks" then
                print("ajsajdja noooo")
            else
            triggerEvent("Change Character", 'bf', mariVariantes[1]);
            triggerEvent("Change Character", 'gf', 'felixSpeakers')
            end
        elseif boyfriendName == felixVariantes[2] then
            triggerEvent("Change Character", 'bf', mariVariantes[2]);
            triggerEvent("Change Character", 'gf', 'felixSpeakersN')
        elseif boyfriendName == felixVariantes[3] or boyfriendName == felixVariantes[4] then
            triggerEvent("Change Character", 'bf', mariVariantes[3]);
        elseif  boyfriendName == felixVariantes[5] then
            triggerEvent("Change Character", 'bf', mariVariantes[4])
            triggerEvent("Change Character", 'gf', 'felixSpeakersSuit')
        elseif boyfriendName == felixVariantes[6] then
            triggerEvent("Change Character", 'bf', mariVariantes[5])
            triggerEvent("Change Character", 'gf', 'felixSpeakersSuit-Shade')
        elseif boyfriendName == felixVariantes[7] then
            triggerEvent("Change Character", 'bf', mariVariantes[6])
            triggerEvent("Change Character", 'gf', 'felixWeek7gf')
        elseif boyfriendName == 'felixPixel' then
            triggerEvent("Change Character", 'bf', 'mariPixelP1')
            triggerEvent("Change Character", 'gf', 'felixPixelSpeaker')
        end
        
        if boyfriendName == "rayo-player" then
            triggerEvent("Change Character", 'bf', 'sisterPlayable'); 
            triggerEvent("Change Character", 'gf', 'rayoSpeaker'); 
        end
    end
end