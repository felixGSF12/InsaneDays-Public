package newer.utility;

import flixel.FlxG;
import flixel.FlxCamera;
import lime.system.Clipboard;
import openfl.geom.Point;

class Misc {

    /**
     * Retorna el centro dentro de un espacio.
     * Equivalente a Lua: Misc.centerWithin()
     */
    public static function centerWithin(objectSize:Float, workspaceSize:Float):Float {
        return (workspaceSize * 0.5) - (objectSize * 0.5);
    }

    /**
     * Retorna true si el mouse está dentro del área de un sprite.
     * Debes pasar el sprite directamente.
     */
    public static function mouseOverlapsSprite(sprite:flixel.FlxSprite, ?camera:FlxCamera):Bool {
        if (sprite == null) return false;

        var cam = camera == null ? FlxG.camera : camera;

        var mx = FlxG.mouse.getScreenPosition(cam).x;
        var my = FlxG.mouse.getScreenPosition(cam).y;

        return (mx >= sprite.x && mx <= sprite.x + sprite.width &&
                my >= sprite.y && my <= sprite.y + sprite.height);
    }

    /**
     * Retorna el valor del scroll del mouse (FlxG.mouse.wheel)
     */
    public static function mouseWheel():Int {
        return FlxG.mouse.wheel;
    }

    /**
     * Devuelve verdadero si CUALQUIER tecla fue recién presionada.
     * Equivalente al antiguo Misc.keyboardJustPressed()
     */
    public static function keyboardJustPressed():Bool {
        return FlxG.keys.firstJustPressed() != -1;
    }

    /**
     * Copiar texto al portapapeles
     */
    public static function setClipboard(text:String):Void {
        Clipboard.text = text;
    }

    /**
     * Obtener texto del portapapeles
     */
    public static function getClipboard():String {
        return Clipboard.text;
    }

    /**
     * Cargar un archivo TXT y devolver sus líneas como array.
     * Similar a Misc.listFromTxt Lua.
     */
    public static function listFromTxt(path:String):Array<String> {
        return backend.CoolUtil.coolTextFile(path);
    }
}

