---@diagnostic disable: lowercase-global, undefined-global

_G.ClientData = {
    initiated = false,
    title = "Ramen's Results Screen",
    version = "4.1.3",
    data = {},
    defaultPrefs = {
        openOptions = true,

        --visibility
        showHitTimings = true,
        showNPS = true,
        showCombo = true,
        showUnderlay = true,
        showJudgements = true,
        showResults = true,

        --gameplay
        underlayType = "PLAYER",
        underlayOpacity = 70,
        judgementType = "LEFT",
        resultsPresence = "ALL",
        opponentSide = false,
        quantNotes = false,
        skipIntroToggle = false,

        --colors (duh)
        colors = {
            sick =  {254, 214, 54}, -- FED636
            good =  {31, 254, 178}, -- 1FFEB2
            bad =   {255, 43, 178}, -- FF2BB2
            shit =  {254, 54, 54},  -- FE3636
            miss =  {159, 33, 33}   -- 9F2121
        }
    },
    menuMusic = "fartEditor",
    scrollSound = "scroll",
    toggleSound = "toggle",
    acceptSound = "accept",
    backSound = "back",
    interactVolume = 0.4
}

function ClientData.load()
    if not ClientData.initiated then
        initSaveData("Player_Preferences", ClientData.title:gsub(" ", "_"):gsub("'", ""))
        ClientData.initiated = true
    end
    for key, value in pairs(ClientData.defaultPrefs) do
        ClientData.data[key] = getDataFromSave("Player_Preferences", key, value)
    end
end

function ClientData.save()
    for key, value in pairs(ClientData.data) do
        setDataFromSave("Player_Preferences", key, value)
    end
    flushSaveData("Player_Preferences")
end

function ClientData.reset(tag)
    ClientData.data[tag] = ClientData.defaultPrefs[tag]
    ClientData.save()
end

return ClientData
