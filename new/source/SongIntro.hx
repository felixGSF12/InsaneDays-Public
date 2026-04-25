import tjson.TJSON;
import flixel.text.FlxText;
import flixel.FlxG;
import Reflect;
import flixel.FlxSprite;
import Std;
import flixel.tweens.FlxEase;
import backend.Paths;
import flixel.group.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.FlxBasic;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxTimer;


var name:FlxText;
var bar:FlxSprite;
var objects:FlxTypedGroup<FlxBasic>;
var compositors:FlxText;
var bye:FlxTimer;

function onCreate() {
    objects = new FlxTypedGroup();
}

function onSongStart() {
    bye = new FlxTimer();
    var get:Dynamic = getSongInfo(songName);
   name = new FlxText(0, 0, 0, songName, 70);
name.setFormat(Paths.font('Neutra.ttf'), 70);
name.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
name.autoSize = true;
name.screenCenter();
name.y = 260 - 10;
name.x -= 10;
name.cameras = [camHUD];
    name.alpha = 0;
    if (get != null){
    name.color = get.color;
    objects.add(name);
      
    bye.start(6,()->{
        for (object in objects.members){
          FlxTween.tween(object,{alpha:0},1.5,{ease: FlxEase.linear, onComplete: function(flx:FlxTween){
            object.destroy();
            //debugPrint('los objectos se fueron con maradona');
          }});
        }
    });

    bar = new FlxSprite(320, 300);
    bar.makeGraphic(600, 10);
    bar.cameras = [camHUD];
    bar.color = name.color;
    objects.add(bar);
    var compositorText:String = get.compositors.join("\n");

    compositors = new FlxText(510, 310, FlxG.width, compositorText, 40);
    compositors.setFormat(Paths.font('Neutra.ttf'), 40);
    compositors.cameras = [camHUD];
    compositors.alpha = 0;
    compositors.setBorderStyle(FlxTextBorderStyle.OUTLINE,FlxColor.BLACK,2);
    compositors.color = get.color;
    objects.add(compositors);

    // ----- ANIMACIONES -----
    FlxTween.tween(bar, { y:320 }, 0.2, { ease: FlxEase.bounceIn });
     FlxTween.tween(compositors, { y:350,alpha:1 }, 0.2, { ease: FlxEase.linear });
    FlxTween.tween(name, { alpha:1 }, 0.4, { ease: FlxEase.linear });

    add(objects);
}
 }

function onUpdate(elapsed:Float) {
    if (bar != null)
        bar.alpha = name.alpha;
}

function loadJson(file:String):Dynamic {
    var raw:String = Paths.getTextFromFile('data/' + file + '.json');
    var json:Dynamic = TJSON.parse(raw);
    return json;
}

function getSongInfo(songName:String):Dynamic {
    var data:Dynamic = loadJson("introData");

    if (!Reflect.hasField(data, songName)) {
        trace("Error: Canción '" + songName + "' no existe en el JSON.");
        return null;
    }

    var songData:Dynamic = Reflect.field(data, songName);

    var compositors:Array<String> = songData.compositors;
    var color:Int = Std.parseInt(songData.color);

    return {
        compositors: compositors,
        color: color
    };
}

