import flixel.FlxSprite;
import backend.Paths;
import backend.ClientPrefs;
import flixel.sound.FlxSound;
import substates.GameOverSubstate as Gv;
var felixVariants:Array<String> = ["felix", "felixN", "felixWeek3", "felix_chained", "felixSuit", "felixShade", "felixSa"];
var mariVariants:Array<String> = ["mariP1", "mariP1N", "mariW3_Playable", "mariP1Suit", "mariSuit-shadeP1", "mariSa"];
var cry:FlxSound;
var curAnimation:String = "";

function onCreatePost() {
    var gx:FlxSprite = Gv.stage;
    Gv.stageInGV = 'felix';

    for (fx in felixVariants){
        if (ClientPrefs.data.myLove == false && (fx == boyfriend.curCharacter || songName == 'thats-all-folks')){
            Gv.characterName = 'felixDead';
            Gv.deathSoundName = 'fnf_loss_sfx';
            Gv.loopSoundName = 'gameOverOld';
            Gv.endSoundName = 'gameOverEnd';
            Gv.stageInGV = 'felix';
        }
    }

    for (mari in mariVariants){
        if (ClientPrefs.data.myLove == true && mari == boyfriend.curCharacter){
            Gv.characterName = 'mariDead';
            Gv.deathSoundName = 'fnf_loss_sfx_gf';
            Gv.loopSoundName = 'gameOver-gf';
            Gv.endSoundName = 'gameOverEnd-gf';
            Gv.stageInGV = 'mari';
        }
    }

    if (boyfriend.curCharacter == 'rayo-player'){
        Gv.characterName = 'rayoDiesxd';
        Gv.deathSoundName = 'rayoloss';
        Gv.loopSoundName = 'rayogameOver';
        Gv.endSoundName = 'rayogameOverEnd';
        Gv.stageInGV = 'rayo';
    }
    else if (ClientPrefs.data.myLove == true && boyfriend.curCharacter == 'sisterPlayable'){
        Gv.characterName = 'LuisaDead';
        Gv.deathSoundName = 'sisterloss';
        Gv.loopSoundName = 'sisterGameOver';
        Gv.endSoundName = 'sisterConfirm';
        Gv.stageInGV = 'luisa';
    }
    else if (ClientPrefs.data.myLove == false && boyfriend.curCharacter == 'felixPixel'){
        Gv.characterName = 'pixelDead';
        Gv.deathSoundName = 'fnf_loss_sfx-pixel';
        Gv.loopSoundName = 'gameOver-pixel';
        Gv.endSoundName = 'gameOverEnd-pixel';
        Gv.stageInGV = 'felix';
    }
    else if (ClientPrefs.data.myLove == true && boyfriend.curCharacter == 'mariPixelP1'){
        Gv.characterName = 'mariPixelDead';
        Gv.deathSoundName = 'fnf_loss_sfx-pixel';
        Gv.loopSoundName = 'gameOver-pixel';
        Gv.endSoundName = 'gameOverEnd-pixel';
        Gv.stageInGV = 'felix';
    }
    else if (boyfriend.curCharacter == 'felixAndMari'){
        Gv.characterName = 'fxANDmari-dead';
        Gv.deathSoundName = 'fnf_loss_sfx';
        Gv.loopSoundName = 'gameOver-gf';
        Gv.endSoundName = 'gameOverEnd';
        Gv.stageInGV = 'mari';
    }
    else if (boyfriend.curCharacter == 'felixAndMari-pixel'){
        Gv.characterName = 'felixAndMariDeadPixel';
        Gv.deathSoundName = 'fnf_loss_sfx-pixel';
        Gv.loopSoundName = 'mariGameOver';
        Gv.endSoundName = 'gameOverEnd-pixel';
        Gv.stageInGV = 'mari';
    }
    if (Gv.stageInGV == null || Gv.stageInGV.length < 1){
        Gv.stageInGV = 'felix';
    }
}
function onEvent(name:String,value1:String,value2:String){
    if (name == 'Change Character' && value1 == 'bf' && value2 == 'rayo-player'){
        Gv.characterName = 'rayoDiesxd';
        Gv.deathSoundName = 'rayoloss';
        Gv.loopSoundName = 'rayogameOver';
        Gv.endSoundName = 'rayogameOverEnd';
        Gv.stageInGV = 'rayo';
    }
}
