package substates;

import backend.WeekData;
import flixel.FlxG;
import objects.Character;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import backend.Paths;
import flixel.sound.FlxSound;
import states.StoryMenuState;
import states.FreeplayState;
import sys.io.File;
import haxe.Json;

typedef DeadScreen = {
    var position:Array<Float>;
    var image:String;
	var front:Bool;
    var scales:Array<Float>;
	var animated:Bool;
	var animName:String;
	var prefix:String;
	var framerate:Int;
	var loop:Bool;
	var startIn:String;
}

typedef DataDead = {
    var zoom:Float;
    var cameraPosition:Array<Float>; // 👈 nuevo campo
	var messages:Array<String>;
    var boyfriend:Array<Int>;
	var messagesPositions:Array<Int>;
    var parts:Array<DeadScreen>;
}

typedef DeadFile = {
    var stage:DataDead;
}


class GameOverSubstate extends MusicBeatSubstate
{
	public var boyfriend:Character;
	var camFollow:FlxObject;
	public static var stage:FlxSprite; //si lo usas asegurate de usar 'if (stage != null)'
	var stagePostfix:String = "";
	public static var stageInGV:String = "";
	public static var characterName:String = 'bf-dead';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';
	var isEnding:Bool = false;
	var frontAssets:FlxTypedGroup<FlxSprite>;
	var cry:FlxSound;
	public static var deathDelay:Float = 0;
	public static var instance:GameOverSubstate;
	var messageText:FlxText;
var currentMessage:String = "";
var displayedText:String = "";
var typeTimer:Float = 0;
var typeSpeed:Float = 0.04;
var messageDone:Bool = false;


	
	public function new(?playStateBoyfriend:Character = null)
	{
		if(playStateBoyfriend != null && playStateBoyfriend.curCharacter == characterName) //Avoids spawning a second boyfriend cuz animate atlas is laggy
		{
			this.boyfriend = playStateBoyfriend;
		}
		super();
	}

	public static function resetVariables() {
		characterName = 'bf-dead';
		deathSoundName = 'fnf_loss_sfx';
		loopSoundName = 'gameOver';
		endSoundName = 'gameOverEnd';
		deathDelay = 0;

		var _song = PlayState.SONG;
		if(_song != null)
		{
			if(_song.gameOverChar != null && _song.gameOverChar.trim().length > 0) characterName = _song.gameOverChar;
			if(_song.gameOverSound != null && _song.gameOverSound.trim().length > 0) deathSoundName = _song.gameOverSound;
			if(_song.gameOverLoop != null && _song.gameOverLoop.trim().length > 0) loopSoundName = _song.gameOverLoop;
			if(_song.gameOverEnd != null && _song.gameOverEnd.trim().length > 0) endSoundName = _song.gameOverEnd;
		}
	}

	var charX:Float = 0;
	var charY:Float = 0;

	var overlay:FlxSprite;
	var overlayConfirmOffsets:FlxPoint = FlxPoint.get();
	override function create()
	{
		instance = this;
FlxG.camera.flash(FlxColor.RED, 2.1);
frontAssets = new FlxTypedGroup();
		Conductor.songPosition = 0;
var raw:String = File.getContent(Paths.getPath('deadStages/'+stageInGV+'.json'));
var data:DeadFile = cast Json.parse(raw);
		if(boyfriend == null)
		{
			boyfriend = new Character(data.stage.boyfriend[0],data.stage.boyfriend[1], characterName, true);
		}
		boyfriend.skipDance = true;
		
FlxG.camera.zoom = data.stage.zoom;
        // Crear los sprites definidos en el JSON
        for (part in data.stage.parts)
        {
            var sprite = new FlxSprite(part.position[0], part.position[1]);
			if (part.animated == false){
				sprite.loadGraphic(Paths.image(part.image));
			}
			else{
				sprite.frames = Paths.getSparrowAtlas(part.image);
				sprite.animation.addByPrefix(part.animName,part.prefix,part.framerate,part.loop);
				sprite.animation.play(part.startIn);
			}
			sprite.scale.set(part.scales[0],part.scales[1]);
            sprite.updateHitbox();
			if (part.front == false){
   			add(sprite);
			}
			else{
			frontAssets.add(sprite);
			}
         
			
        }
		add(boyfriend);
		add(frontAssets);
		if (data.stage.messages != null && data.stage.messages.length > 0)
{
    currentMessage = data.stage.messages[FlxG.random.int(0, data.stage.messages.length - 1)];
    displayedText = "";
    messageDone = false;

    messageText = new FlxText(data.stage.messagesPositions[0], data.stage.messagesPositions[1], FlxG.width, "");
    messageText.setFormat(Paths.font("vcr.ttf"), 47, FlxColor.WHITE, "center");
    messageText.scrollFactor.set();
    messageText.alpha = 0;
    add(messageText);

    // Pequeño efecto de entrada
    FlxTween.tween(messageText, {alpha: 1}, 1, {ease: FlxEase.quadOut});
}


		FlxG.sound.play(Paths.sound(deathSoundName));


		boyfriend.playAnim('firstDeath');

		PlayState.instance.setOnScripts('inGameOver', true);
		PlayState.instance.callOnScripts('onGameOverStart', []);
		FlxG.sound.music.loadEmbedded(Paths.music(loopSoundName), true);

		if(characterName == 'pico-dead')
		{
			overlay = new FlxSprite(boyfriend.x + 205, boyfriend.y - 80);
			overlay.frames = Paths.getSparrowAtlas('Pico_Death_Retry');
			overlay.animation.addByPrefix('deathLoop', 'Retry Text Loop', 24, true);
			overlay.animation.addByPrefix('deathConfirm', 'Retry Text Confirm', 24, false);
			overlay.antialiasing = ClientPrefs.data.antialiasing;
			overlayConfirmOffsets.set(250, 200);
			overlay.visible = false;
			add(overlay);

			boyfriend.animation.callback = function(name:String, frameNumber:Int, frameIndex:Int)
			{
				switch(name)
				{
					case 'firstDeath':
						if(frameNumber >= 36 - 1)
						{
							overlay.visible = true;
							overlay.animation.play('deathLoop');
							boyfriend.animation.callback = null;
						}
					default:
						boyfriend.animation.callback = null;
				}
			}

			if(PlayState.instance.gf != null && PlayState.instance.gf.curCharacter == 'nene')
			{
				var neneKnife:FlxSprite = new FlxSprite(boyfriend.x - 450, boyfriend.y - 250);
				neneKnife.frames = Paths.getSparrowAtlas('NeneKnifeToss');
				neneKnife.animation.addByPrefix('anim', 'knife toss', 24, false);
				neneKnife.antialiasing = ClientPrefs.data.antialiasing;
				neneKnife.animation.finishCallback = function(_)
				{
					remove(neneKnife);
					neneKnife.destroy();
				}
				insert(0, neneKnife);
				neneKnife.animation.play('anim', true);
			}
		}

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		crySound();
	var raw:String = File.getContent(Paths.getPath('deadStages/'+stageInGV+'.json'));
   var data:DeadFile = cast Json.parse(raw);
FlxG.camera.zoom = data.stage.zoom;
if (data.stage.cameraPosition != null && data.stage.cameraPosition.length >= 2)
{
      FlxG.camera.scroll.set(data.stage.cameraPosition[0], data.stage.cameraPosition[1]);
}
if (messageText.x != data.stage.messagesPositions[0]){
	messageText.x = data.stage.messagesPositions[0];
}
if (messageText.y != data.stage.messagesPositions[1]){
	messageText.y = data.stage.messagesPositions[1];
}

		PlayState.instance.callOnScripts('onUpdate', [elapsed]);

		var justPlayedLoop:Bool = false;
		if (!boyfriend.isAnimationNull() && boyfriend.getAnimationName() == 'firstDeath' && boyfriend.isAnimationFinished())
		{
			boyfriend.playAnim('deathLoop');
			if(overlay != null && overlay.animation.exists('deathLoop'))
			{
				overlay.visible = true;
				overlay.animation.play('deathLoop');
			}
			justPlayedLoop = true;
		}

		if(!isEnding)
		{
			if (controls.ACCEPT)
			{
				endBullshit();
			}
			else if (controls.BACK)
			{
				#if DISCORD_ALLOWED DiscordClient.resetClientID(); #end
				FlxG.camera.visible = false;
				FlxG.sound.music.stop();
				PlayState.deathCounter = 0;
				PlayState.seenCutscene = false;
				PlayState.chartingMode = false;
	
				Mods.loadTopMod();
				if (PlayState.isStoryMode)
					MusicBeatState.switchState(new StoryMenuState());
				else
					MusicBeatState.switchState(new FreeplayState());
	
				FlxG.sound.playMusic(Paths.music('freeplayRandom')); 
				PlayState.instance.callOnScripts('onGameOverConfirm', [false]);
			}
			else if (justPlayedLoop)
			{
				switch(PlayState.SONG.stage)
				{
					case 'tank':
						coolStartDeath(0.2);
						
						var exclude:Array<Int> = [];
						//if(!ClientPrefs.cursing) exclude = [1, 3, 8, 13, 17, 21];
	
						FlxG.sound.play(Paths.sound('jeffGameover/jeffGameover-' + FlxG.random.int(1, 25, exclude)), 1, false, null, true, function() {
							if(!isEnding)
							{
								FlxG.sound.music.fadeIn(0.2, 1, 5);
							}
						});

					default:
						coolStartDeath();
				}
			}
			
			if (FlxG.sound.music.playing)
			{
				Conductor.songPosition = FlxG.sound.music.time;
			}
		}
		PlayState.instance.callOnScripts('onUpdatePost', [elapsed]);

		if (!messageDone && currentMessage != "")
{
    typeTimer += elapsed;

    if (typeTimer >= typeSpeed)
    {
        typeTimer = 0;

        var nextIndex = displayedText.length;
        if (nextIndex < currentMessage.length)
        {
            displayedText += currentMessage.charAt(nextIndex);
            messageText.text = displayedText;


    }
}
	}
	}


	function coolStartDeath(?volume:Float = 1):Void
	{
		FlxG.sound.music.play(true);
		FlxG.sound.music.volume = volume;
	}

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			if(boyfriend.hasAnimation('deathConfirm'))
				boyfriend.playAnim('deathConfirm', true);
			else if(boyfriend.hasAnimation('deathLoop'))
				boyfriend.playAnim('deathLoop', true);

			if(overlay != null && overlay.animation.exists('deathConfirm'))
			{
				overlay.visible = true;
				overlay.animation.play('deathConfirm');
				overlay.offset.set(overlayConfirmOffsets.x, overlayConfirmOffsets.y);
			}
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music(endSoundName));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					MusicBeatState.resetState();
				});
			});
			PlayState.instance.callOnScripts('onGameOverConfirm', [true]);
		}
	}
	override function destroy()
	{
		instance = null;
		super.destroy();
	}
function createBG() {
 stage = new FlxSprite(0, 0);
    
    if (stageInGV != null && stageInGV != '') {
        stage.loadGraphic(Paths.image(stageInGV));
    } else {
        stage.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    }
    
    add(stage);
}
function crySound()
    if (boyfriend != null && boyfriend.curCharacter == 'mariDead')
    {
        if (boyfriend.animation.curAnim.name == 'deathLoop' && cry == null)
        {
            cry = new FlxSound();
            cry.loadEmbedded(Paths.sound('crying_sfx'), true);

            cry.volume = 0.34 + FlxG.random.float(0, 0.1);
            cry.pitch = 0.95 + FlxG.random.float(0, 0.1);
            add(cry);
            cry.fadeIn(1, 0, cry.volume);
            cry.play(true);
        }
    }
override public function onFocusLost():Void
{
    if (cry != null && cry.playing)
        cry.pause();
}

override public function onFocus():Void
{
    if (cry != null && !cry.playing)
        cry.resume();
}
}