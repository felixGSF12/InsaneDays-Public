import objects.Note;
import flixel.util.FlxTimer;
import backend.ClientPrefs;
var camMovement:Int = 60;
var velocity:Int = 3;
var campointx:Int = 600;
var campointy:Int = 680;
var camlockx:Int = 0;
var camlocky:Int = 0;
var camlock:Bool = false;
var bfturn:Bool = false;
var camreset:FlxTimer;

function opponentNoteHit(note:Note):Void {
    if (ClientPrefs.data.cameraFollow == true) {
    if (!bfturn) {
        switch (note.noteData) {
            case 0:
                camlockx = campointx - camMovement;
                camlocky = campointy;
            case 1:
                camlockx = campointx;
                camlocky = campointy + camMovement;
            case 2:
                camlockx = campointx;
                camlocky = campointy - camMovement;
            case 3:
                camlockx = campointx + camMovement;
                camlocky = campointy;
        }
       camreset = new FlxTimer();
        camreset.start(1, function(t:FlxTimer):Void {
            cameraSpeed = 1;
            camFollow.x = campointx;
            camFollow.y = campointy;
        });
        cameraSpeed = velocity;
        camlock = true;
    }
     }
}
function onMoveCamera(focus:String){
      if (ClientPrefs.data.cameraFollow == true) {
    if (focus == 'boyfriend'){
    campointx = camFollow.x;
	campointy = camFollow.y;
	bfturn = true;
	camlock = false;
	cameraSpeed = 1;
    }	
	else if (focus == 'dad'){
    campointx = camFollow.x;
	campointy = camFollow.y;
	bfturn = false;
	camlock = false;
	cameraSpeed = 1;
    }
       }
}
function onUpdate() {
     if (ClientPrefs.data.cameraFollow == true) {
      if (camlock){
    camFollow.x = camlockx;
	camFollow.y = camlocky;
      }
	  }
}
function goodNoteHit(note:Note):Void {
    if (ClientPrefs.data.cameraFollow == true) {
    if (bfturn) {
        switch (note.noteData) {
            case 0:
                camlockx = campointx - camMovement;
                camlocky = campointy;
            case 1:
                camlockx = campointx;
                camlocky = campointy + camMovement;
            case 2:
                camlockx = campointx;
                camlocky = campointy - camMovement;
            case 3:
                camlockx = campointx + camMovement;
                camlocky = campointy;
        }
        camreset = new FlxTimer();
        camreset.start(1, function(t:FlxTimer):Void {
        cameraSpeed = 1;
        camFollow.x = campointx;
        camFollow.y = campointy;
        });
        cameraSpeed = velocity;
        camlock = true;
    }
}
}
