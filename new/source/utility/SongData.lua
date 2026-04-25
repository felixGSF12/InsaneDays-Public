---@diagnostic disable: lowercase-global, undefined-global

_G.SongData = {
    data = {}
}

function SongData.load(songTitle, songDifficulty, totalNotes, opponentSide)
    require("mods/scripts/utility/ClientData")
    local savePath = ClientData.title:gsub(" ", "_"):gsub("'", "") .. "/SongData/" .. songTitle .. "/" .. songDifficulty
    savePath = savePath .. (opponentSide and "-Opponent_Chart" or "")
    local saveFile = totalNotes

    -- debugPrint(savePath .. "/" .. saveFile)
    initSaveData(saveFile, savePath)
    SongData.data = getDataFromSave(saveFile, "clears", {})
end

function SongData.save(totalNotes, songData)
    local saveFile = totalNotes
    setDataFromSave(saveFile, "clears", songData)
    flushSaveData(totalNotes)
end

return SongData