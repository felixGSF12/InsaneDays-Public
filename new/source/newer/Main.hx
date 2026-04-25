package newer;

import options.Option;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import backend.Paths;
import newer.utility.ClientData;
import objects.Alphabet;
import backend.MusicBeatState;
class Main extends MusicBeatState {

    public var items:Array<String> = ["Visibility", "Gameplay", "Colors", "Save & Exit"];
    public var curItem:Int = 0;
    public var allowInteraction:Bool = true;
var camOptions:FlxCamera;
    // Objetos del menú
    public var mainBG:FlxSprite;
    public var mainBGOverlay:FlxSprite;
    public var descriptionBox:FlxSprite;
    public var descriptionText:FlxText;
    public var rrsVersion:FlxText;

    // Letras del menú como Alphabet
    public var letters:Array<Alphabet> = [];

    override public function create():Void {
        super.create();

        // Cargar preferencias y música
        ClientData.load();
        FlxG.sound.playMusic(Paths.music(ClientData.menuMusic), 1, true);

        // Crear cámara principal
camOptions = new FlxCamera(0, 0, FlxG.width, FlxG.height);
camOptions.bgColor = 0x00000000; // transparente si quieres
FlxG.cameras.add(camOptions, false); // el 'false' indica que no reemplaza la cámara principal


        // Fondo principal
        mainBG = new FlxSprite(0, 0).loadGraphic(Paths.image("menuDesat"));
        mainBG.cameras = [camOptions];
        FlxG.state.add(mainBG);

        // Gradiente overlay
       // var playerColor = Math.rgbToHex(FlxG.getProperty("boyfriend.healthColorArray"), true);
       // var opponentColor = Math.rgbToHex(FlxG.getProperty("dad.healthColorArray"), true);

       // mainBGOverlay = Misc.createGradient(0, 0, FlxG.width, FlxG.height, playerColor + "," + opponentColor, "camOptions");
       // mainBGOverlay.blend = flixel.util.FlxBlendMode.MULTIPLY;

        // Crear letras del menú con Alphabet
        var workspaceSize:Float = FlxG.height - 100;
        var spacing:Float = workspaceSize / items.length;

        for (i in 0...items.length) {
            var letter = new Alphabet(0, (spacing * i) + (spacing / items.length), items[i], true);
            letter.cameras = [camOptions];
            letter.screenCenter(X);
            add(letter);
            letters.push(letter);
        }

        // Caja de descripción
        descriptionBox = new FlxSprite(0, FlxG.height - 100).loadGraphic(Paths.image("bg/description"));
        descriptionBox.cameras = [camOptions];
        FlxG.state.add(descriptionBox);

        descriptionText = new FlxText(0, 0, descriptionBox.width - 20, "You can access this screen again in the pause menu!\n(These menus can also be interacted via mouse!)");
        descriptionText.cameras = [camOptions];
        descriptionText.setFormat(Paths.font("alwaysVCR.ttf"), 20, FlxColor.WHITE, "center", FlxColor.BLACK);
        descriptionText.x = descriptionBox.x;
        descriptionText.y = descriptionBox.y;
        FlxG.state.add(descriptionText);

        // Versión
        rrsVersion = new FlxText(0, 0, FlxG.width, ClientData.title + " - v" + ClientData.version);
        rrsVersion.setFormat(Paths.font("alwaysVCR.ttf"), 18, FlxColor.WHITE, "left", FlxColor.BLACK);
        rrsVersion.cameras = [camOptions];
        rrsVersion.y = FlxG.height - rrsVersion.height;
        FlxG.state.add(rrsVersion);

        // Selección inicial
        updateSelection();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // Chequear si alguna subventana está abierta
        allowInteraction = true;

        if (!allowInteraction) return;

        if (FlxG.keys.justPressed.W || FlxG.keys.justPressed.UP) changeSelection(-1);
        else if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.DOWN) changeSelection(1);

     if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE) {
    var selection = items[curItem];

    if (selection == "Save & Exit") {
        ClientData.save();
        MusicBeatState.switchState(new states.MainMenuState());
        return;
    }

    if (selection == "Colors") {
        //openSubState(new ColorsSubState());
        FlxG.sound.play(ClientData.acceptSound, 0.4);
        return;
    }

    // Cargar menú usando TXT
    openSubState(new options.NwOptionsState(selection));
    FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
}
}

    public function changeSelection(delta:Int):Void {
        curItem += delta;
        if (curItem < 0) curItem = items.length - 1;
        if (curItem >= items.length) curItem = 0;
        FlxG.sound.play(Paths.sound(ClientData.scrollSound), ClientData.interactVolume);
        updateSelection();
    }

    public function updateSelection():Void {
        for (i in 0...letters.length) {
            letters[i].alpha = if (i == curItem) 1 else 0.6;
        }
    }
}
