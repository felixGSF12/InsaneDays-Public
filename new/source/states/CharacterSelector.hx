package states; 
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
#if desktop
import sys.io.File;
import sys.io.FileOutput;
#end
import flixel.ui.FlxButton;
import flixel.group.FlxGroup.FlxTypedGroup;
import backend.MusicBeatState;
import backend.WeekData;
import StringTools;
using StringTools;
class CharacterSelector extends MusicBeatState
{
    var cols:Int = 3; 
    var rows:Int = 3; 
    var spacing:Int = 100;
    public static var curChar:Int = 0;
    var stateSwitch:FlxTimer;
    var isPressed:Bool = false;
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
        charIcon = ClientPrefs.data.characterList;
        refreshIcons();
        super.create();
    } 
        public function refreshIcons():Void {
            for (icon in chars) {
                remove(icon);
            }
            chars = [];
            for (i in 0...(cols * rows)) {
                var icon:FlxSprite;
                if (i < charIcon.length) {
                    icon = new FlxSprite((i % cols) * 110 + 440, Math.floor(i / cols) * 120 + 150);
                    icon.loadGraphic(Paths.image('selector/' + charIcon[i]));
                } else {
                    icon = new FlxSprite((i % cols) * 110 + 440, Math.floor(i / cols) * 120 + 150).loadGraphic(Paths.image('selector/' + lockIcon));
                }
                add(icon);
                chars.push(icon);
            }
        }
        override function update(elapsed:Float) {
            if (FlxG.keys.justPressed.ESCAPE) {
                stateSwitch.cancel(); 
                FlxG.sound.play(Paths.sound('CS_locked'));
                isPressed = false;
                
            }
            if (FlxG.keys.justPressed.ENTER) {
                chars[curChar].animation.play('select');
            }
        
            for (i in 0...chars.length) {
                if (curChar == i) {
                    chars[i].scale.set(1, 1);
                } else {
                    chars[i].scale.set(0.8, 0.8);
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
                        selectedCharacter = curling; 
                        stateSwitch.start(2, function(a:FlxTimer):Void {
    MusicBeatState.switchState(new FreeplayState());   
     FlxG.sound.playMusic(Paths.music('freeplayRandom'));                         
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
if (FlxG.keys.justPressed.SPACE){
if (curling != 'felix' && !returnNull()) {
    selectedCharacter = curling; 
    trace('Personaje seleccionado para eliminación: ' + selectedCharacter);
    openSubState(new DeleteCharacterSubState(selectedCharacter));
}
else{
      FlxG.sound.play(Paths.sound('CS_locked'));
}
}
      super.update(elapsed);
        }
        public function returnNull() {
    var curling = charIcon[curChar];
    return curling == 'lock' || curling == null || curling == "";
    
}

        public static function unlockCharacter(name:String) {
            if (!ClientPrefs.data.characterList.contains(name)) {
                ClientPrefs.data.characterList.push(name);
                ClientPrefs.saveSettings();
            }
        }
      }

class DeleteCharacterSubState extends MusicBeatSubstate
{
    var confirmText:FlxText;
    var yesBtn:FlxText;
    var noBtn:FlxText;
    var character:String;
    var curSelected:Int = 0;
    var buttons:Array<String> = ["Si", "No"];
    var btsFamily:FlxTypedGroup<FlxText>;
    public function new(character:String) {
        super();
        this.character = character;

    }

    override public function create():Void
    {
        super.create();
        // Fondo negro semitransparente
        btsFamily = new FlxTypedGroup<FlxText>();
        var blackBg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        blackBg.alpha = 0.75;
        add(blackBg);

         var charIcon:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("selector/" + character));
        charIcon.screenCenter();
        add(charIcon);
        // Texto de confirmación
        var text:FlxText = new FlxText(0, charIcon.y + charIcon.height + 20, FlxG.width, "");
        text.text = "¿Estas Seguro de eliminar a este personaje?";
        text.setFormat(null, 24, 0xFFFFFF, "center");
        add(text);

    for (i in 0...buttons.length) {
    var btn:FlxText = new FlxText((i * FlxG.width / buttons.length), text.y + text.height + 10, FlxG.width / buttons.length, buttons[i]);
    btn.setFormat(null, 24, 0xFFFFFF, "center");
    btsFamily.add(btn);
}
        add(btsFamily);
changeButton(0);

    }
    override function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.keys.justPressed.LEFT) {
            changeButton(-1);
        } 
        if (FlxG.keys.justPressed.RIGHT) {
            changeButton(1);
        } 
        var button = buttons[curSelected];
        if (FlxG.keys.justPressed.ENTER) {
            if (button == "Si") {
                CharacterSelector.charIcon.remove(character);
                ClientPrefs.data.characterList = CharacterSelector.charIcon;
                ClientPrefs.saveSettings();
                cast(FlxG.state, CharacterSelector).refreshIcons();
                close();
            }
            else {
                close();
            }
           

        }

    }
    function changeButton(index:Int) {
        curSelected += index;
        if (curSelected >= buttons.length) {
            curSelected = 0;
        } else if (curSelected < 0) {
            curSelected = buttons.length - 1;
        }
        for (i in 0...btsFamily.length) {
            var btn:FlxText = btsFamily.members[i];
            if (i == curSelected) {
                btn.setFormat(null, 24, 0xFFFF00, "center");
            } else {
                btn.setFormat(null, 24, 0xFFFFFF, "center");
            }
        }
    }
}
