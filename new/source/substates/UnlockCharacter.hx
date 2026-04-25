package substates;

import states.CharacterSelector;
import backend.MusicBeatSubstate;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import backend.Paths;
import backend.ClientPrefs;

class UnlockCharacter extends MusicBeatSubstate {
    var viewIcon:String = "";

    public function new(icon:String) {
        super();
        persistentUpdate = false;
        viewIcon = icon;
        
        }


    private function overrideNames():String {
        switch (viewIcon) {
            case "duo":
                return "Migue y Dip";
            case "granpa":
                return "Abuelo de Felix";
            default:
                return viewIcon;
        }
    }

    override function create() {
        super.create();

        // Sonido de logro
        FlxG.sound.play(Paths.sound("achievement"), 1, false);

        // Fondo negro semitransparente
        var blackBg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        blackBg.alpha = 0.75;
        add(blackBg);

        // Ícono del personaje desbloqueado
        var charIcon:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("selector/" + viewIcon));
        charIcon.screenCenter();
        add(charIcon);

        // Texto principal
        var text:FlxText = new FlxText(0, charIcon.y + charIcon.height + 20, FlxG.width, "");
        text.text = "¡Ahora " + overrideNames() + " está desbloqueado!";
        text.setFormat(null, 24, 0xFFFFFF, "center");
        add(text);

        // Texto secundario con salto de línea correcto
        var text2:FlxText = new FlxText(0, text.y + text.height + 10, FlxG.width, "");
        text2.text = "¡Puedes seleccionarlo en el menú de selección de personaje\npresionando TAB en el freeplay!";
        text2.setFormat(null, 16, 0xFFFFFF, "center");
        add(text2);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.ACCEPT) {
            CharacterSelector.unlockCharacter(viewIcon);
            close();
        }
    }
}
