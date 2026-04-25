package newer.utility;

import haxe.ds.StringMap;
import newer.utility.OptionEntry.OptionType;
class OptionsList {
    public static var list:StringMap<OptionEntry> = new StringMap<OptionEntry>();

    public static function init():Void {
        list.set("showHitTimings", new OptionEntry(
            "showHitTimings",
            "Hit Timings",
            "Display the time a note is hit relative to it's intended strum time.",
            OptionType.BoolType,
            true
        ));

        list.set("showNPS", new OptionEntry(
            "showNPS",
            "Notes Per Second Counter",
            "The amount of notes a player has hit within one second.",
            OptionType.BoolType,
            true
        ));

        list.set("showCombo", new OptionEntry(
            "showCombo",
            "Combo Counter",
            "The consecutive number of notes a player hits without missing.",
            OptionType.BoolType,
            true
        ));

        list.set("showUnderlay", new OptionEntry(
            "showUnderlay",
            "Lane Underlay",
            "A graphic displayed beneath the strumline to help note visibility.",
            OptionType.BoolType,
            true
        ));

        list.set("showJudgements", new OptionEntry(
            "showJudgements",
            "Judgement Tracker",
            "Text that displays the total of each note rating obtained.",
            OptionType.BoolType,
            true
        ));

        list.set("showResults", new OptionEntry(
            "showResults",
            "Results Screen",
            "A screen that reviews the player's performance once a song is cleared.",
            OptionType.BoolType,
            true
        ));

        // Gameplay
        list.set("underlayType", new OptionEntry(
            "underlayType",
            "Underlays Shown",
            "The lane underlays to be displayed.",
            OptionType.ListType(["PLAYER","OPPONENT","ALL"]),
            "PLAYER"
        ));

        list.set("underlayOpacity", new OptionEntry(
            "underlayOpacity",
            "Underlay Opacity",
            "The opacity of the underlays displayed.",
            OptionType.NumberType(1, 100),
            70
        ));

        list.set("judgementType", new OptionEntry(
            "judgementType",
            "Judgement Tracker Side",
            "The side of the screen the judgement tracker is on.",
            OptionType.ListType(["LEFT","RIGHT"]),
            "LEFT"
        ));

        list.set("resultsPresence", new OptionEntry(
            "resultsPresence",
            "Results Screen Presence",
            "When the results screen will be displayed.",
            OptionType.ListType(["ALL","STORY MODE","FREEPLAY"]),
            "ALL"
        ));

        list.set("quantNotes", new OptionEntry(
            "quantNotes",
            "Quantize Note Colors",
            "Will color notes depending on the snap they were placed on.",
            OptionType.BoolType,
            false
        ));

        list.set("skipIntroToggle", new OptionEntry(
            "skipIntroToggle",
            "Skip Song Intro Toggle",
            "The ability to press [SPACE] to skip the song's intro.",
            OptionType.BoolType,
            false
        ));

        list.set("opponentSide", new OptionEntry(
            "opponentSide",
            "Play Opponent Side",
            "Play the opponent's chart instead of your own.\n(WILL break some animations!!!)",
            OptionType.BoolType,
            false
        ));
    }
}
