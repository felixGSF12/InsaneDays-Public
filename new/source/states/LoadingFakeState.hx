package states;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import haxe.Http;
import backend.ClientPrefs;
import  flixel.text.FlxText.FlxTextBorderStyle;
import flixel.text.FlxText;
import backend.Language;

class LoadingFakeState extends MusicBeatState
{
    var bg:FlxSprite;
    var bfLoad:FlxSprite;
    var loadTimer:Float = 0;

    var loadDone:Bool = false;
    var updateChecked:Bool = false;
    var requiresUpdate:Bool = false;
    var loadingText:FlxText;
    override function create()
    {
        super.create();

        bg = new FlxSprite().loadGraphic(Paths.image("a"));
        bg.screenCenter();
        add(bg);
        bfLoad = new FlxSprite(850,250);
        bfLoad.frames = Paths.getSparrowAtlas("bf_running");
        bfLoad.animation.addByPrefix("idle", "bf running",24,true);
        bfLoad.animation.play("idle");
        bfLoad.scale.set(0.3,0.3);
        add(bfLoad);
     
        fakeLoad();
    }

    function fakeLoad()
    {
        ClientPrefs.loadPrefs();
        Language.reloadPhrases();

        // Iniciar verificación de actualización
        checkUpdate(function(needsUpdate:Bool)
        {
            requiresUpdate = needsUpdate;
            updateChecked = true;
        });

        loadDone = true;
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        if (!loadDone || !updateChecked) return;

        loadTimer += elapsed;

        if (loadTimer >= 5.6)
        {
            if (requiresUpdate)
            {
                MusicBeatState.switchState(new substates.OutdatedSubState());
                return;
            }

           if (ClientPrefs.data.language == null || ClientPrefs.data.language == "")
            {
            MusicBeatState.switchState(new LanguageSelectorState());
            return;
           }
           if (ClientPrefs.data.flashing == false){
            MusicBeatState.switchState(new FlashingState());
           }
           if (ClientPrefs.data.language != "" && ClientPrefs.data.flashing != false){
            MusicBeatState.switchState(new TitleState());
           }
        
        }
    }

    // =========================================================
    // CHECK UPDATE (funciona correctamente con HTTP asíncrono)
    // =========================================================
    public function checkUpdate(callback:Bool->Void)
    {
        var url = "https://raw.githubusercontent.com/felixGSF12/InsaneDays-Public/refs/heads/main/version.txt";
        var localVersion = states.MainMenuState.insaneVersion.trim();
        var http = new Http(url);

        http.onData = function(data:String)
        {
            var newVersion = data.split("\n")[0].trim();

            trace('Online: $newVersion  |  Local: $localVersion');

            if (newVersion != localVersion)
                callback(true);  // necesita actualizar
            else
                callback(false); // está al día
        }

        http.onError = function(err)
        {
            trace('Update error: $err');
            callback(false); // si falla, dejar pasar
        }

        http.request();
    }
    public static function returnVersion(url:String = null):String {
	if (url == null || url.length == 0)
			url = "https://raw.githubusercontent.com/felixGSF12/InsaneDays-Public/refs/heads/main/version.txt";
		var version:String = states.MainMenuState.insaneVersion.trim();
		if(ClientPrefs.data.checkForUpdates) {
			trace('checking for updates...');
			var http = new haxe.Http(url);
			http.onData = function (data:String)
			{
				var newVersion:String = data.split('\n')[0].trim();
				trace('version online: $newVersion, your version: $version');
				if(newVersion != version) {
					trace('versions arent matching! please update');
					version = newVersion;
					http.onData = null;
					http.onError = null;
					http = null;
				}
			}
			http.onError = function (error) {
				trace('error: $error');
			}
			http.request();
		}
		return version;
    }
}
