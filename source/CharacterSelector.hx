package; 
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
#if desktop
import sys.io.File;
import sys.io.FileOutput;
#end
import WeekData;
import StringTools;
using StringTools;
class CharacterSelector extends MusicBeatState
{
    var cols:Int = 3; 
    var rows:Int = 3; 
    var spacing:Int = 100;
    public static var curChar:Int = 0;
    public static var isMariFree:Bool = true;
    public static var isFelixFree:Bool = true;
    var stateSwitch:FlxTimer;
    public static var exitToState:Bool = false;
    var isPressed:Bool = false;
    public static var isRayoFree:Bool = false;
    var bg:FlxSprite;
    var lockIcon:String = 'lock';
    var floor:FlxSprite;
    var speakers:FlxSprite;
    public static var selectedCharacter:String = "felix";
    var crown:FlxSprite;
    public static var charIcon:Array<String> = ['felix'];
    var chars:Array<FlxSprite> = [];
    var choose:FlxSprite;

    override function create() {

    // Cargar personajes desde el archivo
        stateSwitch = new FlxTimer();
       // musicGroup = new FlxSoundGroup();
        FlxG.sound.playMusic(Paths.music('charSelect'), 1, true);
    
        bg = new FlxSprite(-150, -180).loadGraphic(Paths.image('selector/charSelectBG'));
        add(bg);
        crown = new FlxSprite(0, 240);
        crown.frames = Paths.getSparrowAtlas('selector/crown');
        crown.animation.addByPrefix('idle', 'crowd', 24, true);
        crown.animation.play('idle');
        add(crown);
    
        floor = new FlxSprite(0, 400);
        floor.frames = Paths.getSparrowAtlas('selector/charSelectStage');
        floor.animation.addByPrefix('idle', 'stage full instance 1', 24, true);
        floor.animation.play('idle');
        add(floor);
    
        choose = new FlxSprite(400, 0).loadGraphic(Paths.image('selector/chosee'));
        add(choose);
    
        var courtines:FlxSprite = new FlxSprite(-50, -70).loadGraphic(Paths.image('selector/curtains'));
        add(courtines);
    
        speakers = new FlxSprite(-50, 430);
        speakers.frames = Paths.getSparrowAtlas('selector/speakers');
        speakers.animation.addByPrefix('bom', 'Speakers ALL', 24, true);
        speakers.animation.play('bom');
        add(speakers);
        loadCharactersFromFile(Paths.getPreloadPath("images/selector/characters.txt"));
        refreshIcons();
        super.create();
    } 
        public function refreshIcons():Void {
            // Elimina los íconos actuales
            for (icon in chars) {
                remove(icon);
            }
            chars = [];
    
            // Añade los nuevos íconos
            for (i in 0...(cols * rows)) {
                var icon:FlxSprite;
                if (i < charIcon.length) {
                    icon = new FlxSprite((i % cols) * 130 + 440, Math.floor(i / cols) * 150 + 150);
                    icon.loadGraphic(Paths.image('selector/' + charIcon[i]));
                } else {
                    icon = new FlxSprite((i % cols) * 130 + 440, Math.floor(i / cols) * 150 + 150).loadGraphic(Paths.image('selector/' + lockIcon));
                }
                add(icon);
                chars.push(icon);
            }
        }
        override function update(elapsed:Float) {
            if (FlxG.keys.justPressed.ESCAPE) {
                MusicBeatState.switchState(new FreeplayState());
            }
        
            if (FlxG.keys.justPressed.ENTER) {
                chars[curChar].animation.play('select');
            }
        
            for (i in 0...chars.length) {
                if (curChar == i) {
                    chars[i].scale.set(1.5, 1.5);
                } else {
                    chars[i].scale.set(1.1, 1.1);
                }
            }
            var curling = charIcon[curChar];
            if (!isPressed) {
                if (FlxG.keys.justPressed.ENTER) {
                    if (curling == 'lock' || curling == null || curling == "") {
                        FlxG.sound.play(Paths.sound('CS_locked'));
                        isPressed = false;
                        stateSwitch.cancel();
                        trace('en teoria deberia funcionar');
                    } else {
                        // Lógica para personajes desbloqueados
                        isPressed = true;
                        FlxG.sound.play(Paths.sound('CS_confirm'));
                        chars[curChar].animation.play('select');
                        selectedCharacter = curling; // Actualiza el personaje seleccionado
                        // Esto es lo que no quiero!
                        stateSwitch.start(2, function(a:FlxTimer):Void {
    MusicBeatState.switchState(new FreeplayState());                            
                        });
                    }
                }        
        }
        if (FlxG.keys.justPressed.LEFT) { 
            curChar = (curChar % cols == 0) ? curChar + cols - 1 : curChar - 1; 
            FlxG.sound.play(Paths.sound('CS_select'));
        } 
        else if (FlxG.keys.justPressed.RIGHT) { 
            curChar = (curChar % cols == cols - 1) ? curChar - cols + 1 : curChar + 1;
            FlxG.sound.play(Paths.sound('CS_select'));
        } 
        else if (FlxG.keys.justPressed.UP) { 
            curChar = (curChar < cols) ? curChar + (rows - 1) * cols : curChar - cols; 
            FlxG.sound.play(Paths.sound('CS_select'));
        } 
        else if (FlxG.keys.justPressed.DOWN) { 
            curChar = (curChar >= (rows - 1) * cols) ? curChar % cols : curChar + cols;
            FlxG.sound.play(Paths.sound('CS_select'));
}
        super.update(elapsed);
        }
        public function loadCharactersFromFile(filePath:String):Void {
            var fileContent:String = File.getContent(filePath);
            var lines:Array<String> = fileContent.split("\n");
            charIcon = [];
            for (line in lines) {
                if (line.trim() != "") {
                    charIcon.push(line.trim());
                }
            }
        }
        public static function saveCharactersToFile(filePath:String):Void {
            var file:FileOutput = File.write(filePath, false);
            for (char in charIcon) {
                file.writeString(char + "\n");
            }
            file.close();
        }
        
        
}