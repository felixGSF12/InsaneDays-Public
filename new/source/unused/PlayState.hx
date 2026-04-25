import flixel.FlxSprite;
import flixel.group.FlxTypedSpriteGroup;
import backend.Paths;
import objects.Note;

var sustainSprite:FlxSprite;
var offsets:Int = 230;
var separation:Int = 225;
var shits:Array<String> = ["Red", "Green", "Blue", "Purple"];
var susPrite:FlxTypedSpriteGroup<FlxSprite>;
var isPressed:Bool = false;


function onCreatePost() {
    susPrite = new FlxTypedSpriteGroup();

    for (i in 0...playerStrums.length) {
        sustainSprite = new FlxSprite();
        sustainSprite.frames = Paths.getSparrowAtlas("HoldNoteEffect/holdCover" + shits[i]);
        sustainSprite.animation.addByPrefix('hold', "holdCover" + shits[i], 24, false);
        sustainSprite.animation.addByPrefix('holdEnd', "holdCoverEnd" + shits[i], 24, false);

        sustainSprite.x = playerStrums.members[i].x - (i * separation) + offsets;
        sustainSprite.y = playerStrums.members[i].y - 100;
        sustainSprite.visible = false;
        sustainSprite.cameras = [camHUD];
        sustainSprite.ID = i; // Asignar ID correctamente

       susPrite.add(sustainSprite);
    }

    
  susPrite.members.sort(function(a, b) return Reflect.compare(a.ID, b.ID));
add(susPrite);
}

function onUpdate() {
    for (i in 0...playerStrums.length) {
        var sprite = susPrite.members[i];
        if (sprite != null && sprite.animation != null) {
            var anim = sprite.animation;

            if (!isPressed && anim.curAnim.name == "hold" && anim.curAnim.finished) {
                sprite.animation.play('holdEnd');
            }

            if (anim.curAnim.name == "hold") {
                isPressed = true;
            }

            if (isPressed && anim.curAnim.name == "hold" && anim.curAnim.finished) {
                isPressed = false;
            }

            if (anim.curAnim.name == "holdEnd" && anim.curAnim.finished) {
                // Aquí puedes desactivar la visibilidad si es necesario
                // sprite.visible = false;
            }
        }
    }
}


function goodNoteHit(note) {
    var leData:Int = note.noteData;

    if (note.isSustainNote) {
        if (leData >= 0 && leData < susPrite.members.length) {
            var sprite = susPrite.members[leData]; // Sin cast
            if (sprite != null) {
                sprite.visible = true;
                sprite.animation.play('hold');
            }
        } else {
            trace("Índice fuera de rango: " + leData);
        }
    }
}
