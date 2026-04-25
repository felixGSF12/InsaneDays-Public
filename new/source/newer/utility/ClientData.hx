package newer.utility;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.util.FlxColor;

class ClientData {

    public static var initiated:Bool = false;
    public static var title:String = "Ramen's Results Screen";
    public static var version:String = "4.1.3";
    // Datos del jugador
    public static var data:Map<String, Dynamic> = new Map<String, Dynamic>();

    // Preferencias por defecto
    public static var defaultPrefs:Map<String, Dynamic> = [
        "openOptions" => true,

        // visibility
        "showHitTimings" => true,
        "showNPS" => true,
        "showCombo" => true,
        "showUnderlay" => true,
        "showJudgements" => true,
        "showResults" => true,

        // gameplay
        "underlayType" => "PLAYER",
        "underlayOpacity" => 70,
        "judgementType" => "LEFT",
        "resultsPresence" => "ALL",
        "opponentSide" => false,
        "quantNotes" => false,
        "skipIntroToggle" => false,

        // colors
        "colors" => [
            "sick" => [254, 214, 54],
            "good" => [31, 254, 178],
            "bad" => [255, 43, 178],
            "shit" => [254, 54, 54],
            "miss" => [159, 33, 33]
        ]
    ];

    public static var menuMusic:String = "fartEditor";
    public static var scrollSound:String = "scrollMenu";
    public static var toggleSound:String = "toggle";
    public static var acceptSound:String = "accept";
    public static var backSound:String = "back";
    public static var interactVolume:Float = 0.7;

    private static var saveVar:FlxSave;

    // -----------------------------
    // Métodos
    // -----------------------------

 public static function load():Void {
    if (!initiated) {
        saveVar = new FlxSave();
        saveVar.bind(title.replace(" ", "_").replace("'", ""));
        initiated = true;
    }

    for (key in defaultPrefs.keys()) {
        var defaultValue = defaultPrefs.get(key);

        // Verificar existencia correctamente
        if (!Reflect.hasField(saveVar.data, key)) {
            Reflect.setField(saveVar.data, key, defaultValue);
        }

        // Obtener valor
        var value = Reflect.field(saveVar.data, key);
        data.set(key, value);
    }

    saveVar.flush(); // Guardar cambios
}


   public static function save():Void {
    for (key in data.keys()) {
        var value = data.get(key);
        Reflect.setField(saveVar.data, key, value);
    }
    saveVar.flush();
}


    public static function reset(tag:String):Void {
        data.set(tag, defaultPrefs.get(tag));
        save();
    }
}
