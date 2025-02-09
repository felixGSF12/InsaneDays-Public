local defaultName = "FNF Insane" -- add your mod name here
local songCreator = ""
local toolCreator = "Astro" -- keep this in for credit or make sure to credit me in your mod!

if songName == "Your_Song_Name_Here" then -- put your song name here!  
    songCreator = "Composor" -- put composors here!
end    

function onSongStart()
    setPropertyFromClass("openfl.Lib", "application.window.title", defaultName .. "- Estas Jugando: " .. songName .. " (" .. difficultyName .. ")"); -- feel free to remove parts you don't want
end

function onDestroy() -- can change to onSongEnd() if that works better for you (i don't recommend it though)
    setPropertyFromClass("openfl.Lib", "application.window.title", defaultName);
end