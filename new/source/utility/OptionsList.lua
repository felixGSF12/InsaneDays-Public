_G.OptionsList = {
    -- Visibility
    showHitTimings = {
        name = "Hit Timings",
        description = "Display the time a note is hit relative to it's intended strum time.",
        type = "bool"
    },
    showNPS = {
        name = "Notes Per Second Counter",
        description = "The amount of notes a player has hit within one second.",
        type = "bool"
    },
    showCombo = {
        name = "Combo Counter",
        description = "The consecutive number of notes a player hits without missing.",
        type = "bool"
    },
    showUnderlay = {
        name = "Lane Underlay",
        description = "A graphic displayed beneath the strumline to help note visibility.",
        type = "bool"
    },
    showJudgements = {
        name = "Judgement Tracker",
        description = "Text that displays the total of each note rating obtained.",
        type = "bool"
    },
    showResults = {
        name = "Results Screen",
        description = "A screen that reviews the player's performance once a song is cleared.",
        type = "bool"
    },

    -- Gameplay
    underlayType = {
        name = "Underlays Shown",
        description = "The lane underlays to be displayed.",
        type = "list",
        list = {"PLAYER", "OPPONENT", "ALL"} --only needed for lists
    },
    underlayOpacity = {
        name = "Underlay Opacity",
        description = "The opacity of the underlays displayed.",
        type = "number",
        minValue = 1, --only needed for numbers
        maxValue = 100 --only needed for numbers
    },
    judgementType = {
        name = "Judgement Tracker Side",
        description = "The side of the screen the judgement tracker is on.",
        type = "list",
        list = {"LEFT", "RIGHT"} --only needed for lists
    },
    resultsPresence = {
        name = "Results Screen Presence",
        description = "When the results screen will be displayed.",
        type = "list",
        list = {"ALL", "STORY MODE", "FREEPLAY"} --only needed for lists
    },
    quantNotes = {
        name = "Quantize Note Colors",
        description = "Will color notes depending on the snap they were placed on.",
        type = "bool"
    },
    skipIntroToggle = {
        name = "Skip Song Intro Toggle",
        description = "The ability to press [SPACE] to skip the song's intro.",
        type = "bool"
    },
    opponentSide = {
        name = "Play Opponent Side",
        description = "Play the opponent's chart instead of your own.\n(WILL break some animations!!!)",
        type = "bool"
    }
}

return OptionsList