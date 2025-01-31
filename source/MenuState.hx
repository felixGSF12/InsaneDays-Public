package;
import haxe.Http;
import haxe.Json;
#if desktop
import sys.FileSystem;
#end
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import openfl.display.Loader;
import openfl.events.Event;
import openfl.net.URLRequest;
import flixel.util.FlxColor;

class ModMenuState extends MusicBeatState {
        var modpacks:Array<Dynamic>;
        var currentModpackIndex:Int = 0;
        var logoGroup:FlxTypedGroup<FlxSprite>;
        var buttonGroup:FlxTypedGroup<FlxButton>;
        var textGroup:FlxTypedGroup<FlxText>;
    
        override public function create():Void {
            FlxG.mouse.visible = true;
            var bg = new FlxSprite().loadGraphic(Paths.image("menumod/GalleryMenu"));
            add(bg);
            var fg = new FlxSprite().loadGraphic(Paths.image("menumod/Base"));
            fg.flipX = true;
            add(fg);
    
            logoGroup = new FlxTypedGroup<FlxSprite>();
            buttonGroup = new FlxTypedGroup<FlxButton>();
            textGroup = new FlxTypedGroup<FlxText>();
    
            var url:String = "https://raw.githubusercontent.com/FelixGsf/insaneVersion/refs/heads/main/modpackDownloadList.json";
            var http = new Http(url);
    
            http.onData = function(data:String) {
                modpacks = Json.parse(data);
                displayModpack(currentModpackIndex);
            };
    
            http.onError = function(errorMsg:String) {
                trace("Error: " + errorMsg);
            };
    
            http.request();
    
            super.create();
        }
    
        override public function update(elapsed:Float):Void {
            super.update(elapsed);
    
            if (FlxG.keys.justPressed.UP) {
                FlxG.sound.play(Paths.sound('scrollMenu'));
                currentModpackIndex = (currentModpackIndex - 1 + modpacks.length) % modpacks.length;
                displayModpack(currentModpackIndex);
            }
    
            if (FlxG.keys.justPressed.DOWN) {
                FlxG.sound.play(Paths.sound('scrollMenu'));
                currentModpackIndex = (currentModpackIndex + 1) % modpacks.length;
                displayModpack(currentModpackIndex);
            }
        }
    
        function displayModpack(index:Int):Void {
            // Clear previous elements
            logoGroup.clear();
            buttonGroup.clear();
            textGroup.clear();
    
            var modpack = modpacks[index];
    
            // Check if properties exist
            var logo:String = Reflect.hasField(modpack, "logo") ? modpack.logo : "default_logo.png";
            var description:String = Reflect.hasField(modpack, "descripcion") ? modpack.descripcion : "No description available.";
            var updated:String = Reflect.hasField(modpack, "updated") ? modpack.updated : "";
    
            // Modpack Logo
            var loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event) {
                var bitmapData = event.target.content.bitmapData;
                var sprite = new FlxSprite(250, FlxG.height / 2 - 100, bitmapData); // Centrado
                sprite.scale.set(2, 2); // Aumenta el tamaño del logo
                logoGroup.add(sprite);
    
                // Download button
                var button = new FlxButton(910, 620, "Download", function() {
                    openLink(modpack.link);
                });
                button.scale.set(2.5,2.5);
                button.label.setFormat("rubik.ttf", 16, FlxColor.BLACK, "center"); // Aumenta el tamaño del texto del botón
                buttonGroup.add(button);
    
                // Text Object showing if it's a new or updated modpack
                var updatedTxt = new FlxText(sprite.x-250, 30, FlxG.width, updated);
                updatedTxt.setFormat(Paths.font("vcr.ttf"), 28, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK); // Aumenta el tamaño del texto
                textGroup.add(updatedTxt);
    var descTxt = new FlxText(100, updatedTxt.y + updatedTxt.height + 10, FlxG.width - 200, description); // Cambiar la posición de la descripción
    descTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    textGroup.add(descTxt);
});
loader.load(new URLRequest(logo));
            loader.load(new URLRequest(logo));
    
            add(logoGroup);
            add(buttonGroup);
            add(textGroup);
        }
    
        function openLink(url:String):Void {
            CoolUtil.browserLoad(url); // Abre el enlace en el navegador usando la función existente
        }
    }
    