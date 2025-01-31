package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class OptionsState extends MusicBeatState
{
	public static var onPlayState:Bool = false;

	var options:Array<String> = ['Note Colors','Hud settings', 'Controls', 'Graphics', 'Visuals and UI','Gameplay'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
//private var duo:FlxSprite; // Declaración del sprite fuera de la funció
	private static var curSelected:Int = 0;
	public static var duo:FlxSprite;
	public static var menuBG:FlxSprite;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Note Colors':
				openSubState(new options.NotesSubState());
			case 'Controls':
				openSubState(new options.ControlsSubState());
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new options.VisualsUISubState());
			case 'Hud settings':
					openSubState(new options.HudSettings());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				LoadingState.loadAndSwitchState(new options.NoteOffsetState());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menumod/GalleryMenu'));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		var bg2:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menumod/Splash'));
		bg2.flipX = true;
		bg2.updateHitbox();
		bg2.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg2);
		 duo = new FlxSprite(0,100).loadGraphic(Paths.image('options/' + options[curSelected]));
		 duo.scrollFactor.set(0, 0);
		 duo.setGraphicSize(Std.int(duo.width * 1));
		 duo.antialiasing = ClientPrefs.globalAntialiasing;
			add(duo);
		var titleText:Alphabet = new Alphabet(430, 40, "OPTIONS", true);
		titleText.scaleX = 1.1;
		titleText.scaleY = 1.1;
		titleText.alpha = 0.6;
		add(titleText);
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);
			for (i in 0...options.length){
				var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
				optionText.x = 50;
				optionText.screenCenter(Y);
				optionText.y += (120 * (i - (options.length / 2))) + 150;
				grpOptions.add(optionText);
			}
		changeSelection();
		ClientPrefs.saveSettings();
		super.create();
		
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (controls.UI_DOWN_P || controls.UI_UP_P){

			FlxTween.tween(duo,{x: 600, alpha : 0},0.2,{ease:FlxEase.cubeIn,onComplete: function(twn:FlxTween)
				{
					duo.loadGraphic(Paths.image('options/' + options[curSelected]));
					FlxTween.tween(duo,{x: 0, alpha : 1},0.2,{ease:FlxEase.cubeOut});
				}
			});
		 }
		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			if(onPlayState)
				{
					StageData.loadDirectory(PlayState.SONG);
					LoadingState.loadAndSwitchState(new PlayState());
					FlxG.sound.music.volume = 0;
				}
				else
			MusicBeatState.switchState(new MainMenuState());
		}

		else if (controls.ACCEPT) {
			openSelectedSubstate(options[curSelected]);
		}
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;
	
		var bullShit:Int = 0;
	
		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
			}
			bullShit++; // Incrementar bullShit en cada iteración
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
		updatePositions(); // Llamar a la función para actualizar las posiciones
	}
	
	function updatePositions() {
		for (item in grpOptions.members) {
			item.y = item.targetY * 120 + 150; // Ajusta el cálculo según sea necesario
		}
	}
		}