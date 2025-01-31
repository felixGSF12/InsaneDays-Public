package;
import flixel.text.FlxText;
import flixel.FlxG;
import Paths;
class UnlockCharacterState extends MusicBeatState{
    var character:String = "";
    public function new(character:String) {
        this.character = character;
    }
override function create(){
    var songName = PlayState.SONG.song;
    var text:FlxText = new FlxText(0,0,FlxG.width,"");
    text.setFormat(Paths.font("vcr.ttf"),18);
    add(text);
    FlxG.sound.play(Paths.sound('confirmMenu'));
    switch (character){
        case 'rayo':
            text.text = "Rayo Ahora es Jugable!\n Presiona TAB en el FreePlay\npara acceder a el.";
        case 'mari':
            text.text = "Mari Ahora es Jugable!\n Presiona TAB en el FreePlay\npara acceder a ella.";

    }
    super.create();
}
override function update(elapsed:Float) {
super.update(elapsed);
if (FlxG.keys.justReleased.ESCAPE){
if (PlayState.isStoryMode == true){
    MusicBeatState.switchState(new StoryMenuState());
}  
else{
    MusicBeatState.switchState(new FreeplayState());
}
} 
}
}