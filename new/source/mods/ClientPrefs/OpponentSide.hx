var noteAnims:Array<String> = ["singLEFT", "singDOWN", "singUP", "singRIGHT"];

var notePositionsOpponent:Array<Float> = [];
var notePositionsPlayer:Array<Float> = [];

function onCreatePost()
{
    if (!ClientPrefs.data.middleScroll) {
        for (strum in game.opponentStrums) {
            notePositionsOpponent.push([strum.x, strum.y]);
        }
        for (strum in game.playerStrums) {
            notePositionsPlayer.push([strum.x, strum.y]);
        }
        for (strum in game.opponentStrums) {
            strum.x = notePositionsPlayer[strum.noteData][0];
            strum.y = notePositionsPlayer[strum.noteData][1];
        }
        for (strum in game.playerStrums) {
            strum.x = notePositionsOpponent[strum.noteData][0];
            strum.y = notePositionsOpponent[strum.noteData][1];
        }
    }

    for (note in game.unspawnNotes) {
        note.mustPress = !note.mustPress;
        note.noAnimation = true;
	    note.noMissAnimation = true;
    }

    var opponentHPColors:Array<Int> = game.dad.healthColorArray;
    var playerHPColor:Array<Int> = game.boyfriend.healthColorArray;
    game.healthBar.flipX = !game.healthBar.flipX;
    game.healthBar.setColors(FlxColor.fromRGB(playerHPColor[0], playerHPColor[1], playerHPColor[2]), FlxColor.fromRGB(opponentHPColors[0], opponentHPColors[1], opponentHPColors[2]));
    game.iconP1.changeIcon(game.dad.healthIcon);
    game.iconP2.changeIcon(game.boyfriend.healthIcon);
    game.iconP1.flipX = !game.iconP1.flipX;
    game.iconP2.flipX = !game.iconP2.flipX;
}

var iconOffset:Float = 26;
function onUpdatePost(elapsed:Float)
{
    var barCenter:Float = game.healthBar.rightBar.x + FlxMath.lerp(0, game.healthBar.barWidth, game.healthBar.percent / 100) + game.healthBar.barOffset.x;
    iconP1.x = barCenter - (150 * game.iconP1.scale.x) / 2 - iconOffset * 2;
    iconP2.x = barCenter + (150 * game.iconP2.scale.x - 150) / 2 - iconOffset;
}

function goodNoteHit(note:Note)
{
    var char:Character = game.dad;
    var animToPlay:String = noteAnims[note.noteData] + note.animSuffix;
    if(char != null) {
        var canPlay:Bool = true;
        if(note.isSustainNote) {
            var holdAnim:String = animToPlay + '-hold';
            if(char.animation.exists(holdAnim)) {
                animToPlay = holdAnim;
            }
            if(char.getAnimationName() == holdAnim || char.getAnimationName() == holdAnim + '-loop') {
                canPlay = false;
			}
		}
        if(canPlay) {
            char.playAnim(animToPlay, true);
        }
        char.holdTimer = 0;
    }
}

function opponentNoteHit(note:Note)
{
    var char:Character = game.boyfriend;
    var animToPlay:String = noteAnims[note.noteData] + note.animSuffix;
    if(char != null) {
        var canPlay:Bool = true;
        if(note.isSustainNote) {
            var holdAnim:String = animToPlay + '-hold';
            if(char.animation.exists(holdAnim)) {
                animToPlay = holdAnim;
            }
            if(char.getAnimationName() == holdAnim || char.getAnimationName() == holdAnim + '-loop') {
                canPlay = false;
			}
		}
        if(canPlay) {
            char.playAnim(animToPlay, true);
        }
        char.holdTimer = 0;
    }
}
