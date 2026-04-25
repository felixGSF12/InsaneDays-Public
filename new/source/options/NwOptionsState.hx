package options;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.FlxSprite;
import newer.utility.OptionList;
import newer.utility.ClientData;
import backend.MusicBeatSubstate;
import newer.utility.Misc;
#if desktop
import sys.io.File;
import sys.io.FileOutput;
#end
import backend.CoolUtil;

/**
 * Menú de opciones basado en un archivo TXT y OptionsList.
 * Version completamente limpia de dependencias Lua.
 */
class NwOptionsState extends MusicBeatSubstate
{
    public var options:Array<String>;          // nombres de opciones
    public var curItem:Int = 0;                // índice seleccionado
    public var allowInteraction:Bool = false;  // se habilita al presionar "ACEPTAR"
    public var usingMouse:Bool = false;        
    public var prevMousePos = [0.0, 0.0];

    // UI
    public var optionElements:Array<FlxText> = [];
    public var descriptionText:FlxText;
    public var optionBG:FlxSprite;
    public var resetButton:FlxSprite;

    public function new(targetMenu:String)
    {
        super();

        ClientData.load();
        OptionsList.init();

        // Lee archivo .txt que contiene nombres de opciones
      var raw:String = File.getContent(Paths.getPath("data/options/" + targetMenu + ".txt"));
options = raw.split("\n"); // ahora sí es Array<String>
for (i in 0...options.length) {
    options[i] = options[i].trim();
}
options = options.filter(function(s) return s != "");

        createMenu();
        for (tag in options) {
    if (!OptionsList.list.exists(tag)) {
        trace("[WARN] Option not found in OptionsList: " + tag);
    }
}

    }

    function createMenu():Void
    {
        // Fondo
        var menuBG = new FlxSprite().loadGraphic(Paths.image("menuDesat"));
        menuBG.screenCenter();
        add(menuBG);

        // Fondo semitransparente
        var overlay = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xAA000000);
        add(overlay);

        // Panel de opciones
        optionBG = new FlxSprite(0, 60).loadGraphic(Paths.image("bg/generic"));
        optionBG.antialiasing = false;
        optionBG.screenCenter(X);
        add(optionBG);

        // Crea elementos visuales por cada opción
        for (i in 0...options.length)
        {
            var tag = options[i];
            var entry = OptionsList.list.get(tag);

            var txt = new FlxText(0, 0, 0, entry.name, 22);
            txt.x = Misc.centerWithin(txt.width, FlxG.width);
            txt.y = optionBG.y + 20 + i * 40;

            optionElements.push(txt);
            add(txt);
        }

        // Caja de descripción
        var descBox = new FlxSprite(0, FlxG.height - 110).makeGraphic(FlxG.width, 100, FlxColor.GRAY);
        add(descBox);

        descriptionText = new FlxText(0, FlxG.height - 100, FlxG.width - 20, "");
        add(descriptionText);

        // Botón reset
        resetButton = new FlxSprite(0, 0).loadGraphic(Paths.image("misc/reset"));
        resetButton.x = optionBG.x + optionBG.width - resetButton.width - 4;
        resetButton.y = optionBG.y - resetButton.height - 4;
        add(resetButton);

        updateSelected(0);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        // Detectar si el mouse se movió
        if (mouseJustMoved())
            usingMouse = true;
        else if (Misc.keyboardJustPressed())
            usingMouse = false;

        // HABILITAR menú presionando SPACE/ENTER
        if (!allowInteraction)
        {
            if (FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER)
                allowInteraction = true;
            return;
        }

        // Salir
        if (FlxG.keys.justPressed.ESCAPE)
        {
            ClientData.save();
            close();
            return;
        }

        if (!usingMouse)
            keyboardControl(elapsed);
        else
            mouseControl(elapsed);

        prevMousePos = [FlxG.mouse.screenX, FlxG.mouse.screenY];
    }

    // CONTROL POR TECLADO
    function keyboardControl(elapsed:Float):Void
    {
        if (FlxG.keys.justPressed.UP)
            updateSelected(-1);

        if (FlxG.keys.justPressed.DOWN)
            updateSelected(1);

        var tag = options[curItem];
        var entry = OptionsList.list.get(tag);

        switch(entry.type)
        {
            case BoolType:
                if (FlxG.keys.justPressed.SPACE) entry.value = !entry.value;
            case NumberType(min, max):
                if (FlxG.keys.justPressed.LEFT) entry.value = Math.max(min, entry.value - 1);
                if (FlxG.keys.justPressed.RIGHT) entry.value = Math.min(max, entry.value + 1);
            case ListType(items):
                var idx = items.indexOf(entry.value);
                if (FlxG.keys.justPressed.LEFT) idx = (idx - 1 + items.length) % items.length;
                if (FlxG.keys.justPressed.RIGHT) idx = (idx + 1) % items.length;
                entry.value = items[idx];
        }

        if (FlxG.keys.justPressed.R)
            resetAll();
    }

    // CONTROL POR MOUSE
    function mouseControl(elapsed:Float):Void
    {
        FlxG.mouse.visible = true;

        // Hover de opciones
        for (i in 0...optionElements.length)
        {
            var txt = optionElements[i];
            if (Misc.mouseOverlapsSprite(txt))
            {
                updateSelected(i - curItem);
                break;
            }
        }

        // Click: Cambiar valor
        if (FlxG.mouse.justPressed)
        {
            var tag = options[curItem];
            var entry = OptionsList.list.get(tag);

            switch(entry.type)
            {
                case BoolType:
                    entry.value = !entry.value;
                case NumberType(min, max):
                    entry.value++;
                    if (entry.value > max) entry.value = min;
                case ListType(items):
                    var idx = items.indexOf(entry.value);
                    idx = (idx + 1) % items.length;
                    entry.value = items[idx];
            }

            // Reset
            if (Misc.mouseOverlapsSprite(resetButton))
                resetAll();
        }
    }

    // Cambiar opción seleccionada
    function updateSelected(change:Int):Void
    {
        curItem += change;
        if (curItem < 0) curItem = options.length - 1;
        if (curItem >= options.length) curItem = 0;

        // Actualizar colores
        for (i in 0...optionElements.length)
            optionElements[i].color = (i == curItem) ? FlxColor.YELLOW : FlxColor.WHITE;

        // Actualizar descripción
       var rawTag = options[curItem];


var tag = rawTag.trim();
var entry = OptionsList.list.get(tag);

if (entry == null) {
    descriptionText.text = "Invalid option: \"" + tag + "\"\n(Not defined in OptionsList)";
    trace("[ERROR] Option \"" + tag + "\" not found in OptionsList!");
} else {
    descriptionText.text = entry.description;
}
    }
    function resetAll():Void
    {
        for (tag in options)
            ClientData.reset(tag);
        ClientData.save();
    }

    function mouseJustMoved():Bool
    {
        return prevMousePos[0] != FlxG.mouse.screenX || prevMousePos[1] != FlxG.mouse.screenY;
    }
}
