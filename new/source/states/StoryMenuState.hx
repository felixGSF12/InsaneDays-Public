package states;

import backend.WeekData;
import backend.Highscore;
import backend.Song;
import substates.UnlockCharacter;
import flixel.group.FlxGroup;
import flixel.graphics.FlxGraphic;

import objects.MenuItem;
import objects.MenuCharacter;

import options.GameplayChangersSubstate;
import substates.ResetScoreSubState;
import backend.Achievements;
import backend.StageData;

class StoryMenuState extends MusicBeatState
{
	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();
	var openScreen:FlxTimer;
	var scoreText:FlxText;

	private static var lastDifficultyName:String = '';
	var curDifficulty:Int = 1;
	var bgSprite:FlxSprite;
	var mobsaic:FlxSprite;
	var scrollDelay:Float = 1.5; // segundos de pausa al reiniciar
	var scrollTimer:Float = 0;
	private static var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;
	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var loadedWeeks:Array<WeekData> = [];

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();


		persistentUpdate = persistentDraw = true;
		PlayState.isStoryMode = true;
		WeekData.reloadWeekFiles(true);

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		openScreen = new FlxTimer();
		if(WeekData.weeksList.length < 1)
		{
			FlxTransitionableState.skipNextTransIn = true;
			persistentUpdate = false;
			MusicBeatState.switchState(new states.ErrorState("NO WEEKS ADDED FOR STORY MODE\n\nPress ACCEPT to go to the Week Editor Menu.\nPress BACK to return to Main Menu.",
				function() MusicBeatState.switchState(new states.editors.WeekEditorState()),
				function() MusicBeatState.switchState(new states.MainMenuState())));
			return;
		}

		if(curWeek >= WeekData.weeksList.length) curWeek = 0;

		scoreText = new FlxText(10, 670, 0, Language.getPhrase('week_score', 'WEEK SCORE: {1}', [lerpScore]), 36);
		scoreText.setFormat(Paths.font("vcr.ttf"), 45);
		scoreText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);


		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
	var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('StoryMe/y mi corazon tucun tucun tucun'));
		bg.scale.set(1.5,1.5);
		mobsaic = new FlxSprite(0,0);
		mobsaic.loadGraphic(Paths.image('pausebg'));
		mobsaic.scale.set(1.5,1.5);
		var barra:FlxSprite = new FlxSprite(330,-50);
		barra.loadGraphic(Paths.image('barras'));
		barra.scale.set(2,1);

		var layerAnimated:FlxSprite = new FlxSprite(-180, -400);
		layerAnimated.frames = Paths.getSparrowAtlas('layerfoda');
		layerAnimated.animation.addByPrefix('idle', 'layerfoda', 24, true);
		layerAnimated.animation.play('idle');

		bgSprite = new FlxSprite(-20, 0);
		bgSprite.antialiasing = ClientPrefs.data.antialiasing;

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		var num:Int = 0;
		var itemTargetY:Float = 0;
		for (i in 0...WeekData.weeksList.length)
		{
			var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var isLocked:Bool = weekIsLocked(WeekData.weeksList[i]);
			if(!isLocked || !weekFile.hiddenUntilUnlocked)
			{
				loadedWeeks.push(weekFile);
				WeekData.setDirectoryFromWeek(weekFile);
				var weekThing:MenuItem = new MenuItem(400, bgSprite.y + 406, WeekData.weeksList[i]);
				weekThing.y += ((weekThing.height + 20) * num);
				weekThing.ID = num;
				weekThing.targetY = itemTargetY;
				itemTargetY += Math.max(weekThing.height, 110) + 10;
				grpWeekText.add(weekThing);

				weekThing.screenCenter(X);
				// weekThing.updateHitbox();

				// Needs an offset thingie
				if (isLocked)
				{
					var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
					lock.antialiasing = ClientPrefs.data.antialiasing;
					lock.frames = ui_tex;
					lock.animation.addByPrefix('lock', 'lock');
					lock.animation.play('lock');
					lock.ID = i;
					grpLocks.add(lock);
				}
				num++;
			}
		}

		WeekData.setDirectoryFromWeek(loadedWeeks[0]);
		var charArray:Array<String> = loadedWeeks[0].weekCharacters;
		for (char in 0...3)
		{
			var weekCharacterThing:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + char) - 150, charArray[char]);
			weekCharacterThing.y += 70;
			grpWeekCharacters.add(weekCharacterThing);
		}

		difficultySelectors = new FlxGroup();


		leftArrow = new FlxSprite(grpWeekText.members[0].x - 110 +  grpWeekText.members[0].width + 200, grpWeekText.members[0].y - 380);
		leftArrow.antialiasing = ClientPrefs.data.antialiasing;
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		Difficulty.resetList();
		if(lastDifficultyName == '')
		{
			lastDifficultyName = Difficulty.getDefault();
		}
		curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(lastDifficultyName)));
		
		sprDifficulty = new FlxSprite(-300, leftArrow.y);
		sprDifficulty.antialiasing = ClientPrefs.data.antialiasing;
		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(leftArrow.x + 316, leftArrow.y);
		rightArrow.antialiasing = ClientPrefs.data.antialiasing;
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		var tracksSprite:FlxSprite = new FlxSprite(FlxG.width * 0.07 + 370, bgSprite.y + 415).loadGraphic(Paths.image('StoryMe/tracks'));
		tracksSprite.antialiasing = ClientPrefs.data.antialiasing;
		tracksSprite.scale.set(1.2,1.2);
		tracksSprite.x = 560;
		

		txtTracklist = new FlxText(FlxG.width * 0.05 + 360, tracksSprite.y + 60, 0, "", 32);
		trace(txtTracklist.x);
		txtTracklist.alignment = CENTER;
		txtTracklist.setBorderStyle(FlxTextBorderStyle.OUTLINE,0xff000000,2);
		txtTracklist.font = Paths.font("vcr.ttf");
		txtTracklist.color = 0xffffffff;
		startScrolling();
		add(bg);
		add(mobsaic);
		add(tracksSprite);
		add(barra);
		add(txtTracklist);
		add(layerAnimated);
		add(bgSprite);
		add(difficultySelectors);
		add(scoreText);

		

		changeWeek();
		changeDifficulty();
checkWeekCompletion();
		super.create();
	}

	override function closeSubState() {
		persistentUpdate = true;
		changeWeek();
		super.closeSubState();
	}
 public static function isWeekCompleted(name:String):Bool {
			return weekCompleted.exists(name) && weekCompleted.get(name);
	 }
	override function update(elapsed:Float)
	{
		if(WeekData.weeksList.length < 1)
		{
			if (controls.BACK && !movedBack && !selectedWeek)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				movedBack = true;
				MusicBeatState.switchState(new MainMenuState());
			}
			super.update(elapsed);
			return;
		}

		// scoreText.setFormat(Paths.font("vcr.ttf"), 32);
		if(intendedScore != lerpScore)
		{
			lerpScore = Math.floor(FlxMath.lerp(intendedScore, lerpScore, Math.exp(-elapsed * 30)));
			if(Math.abs(intendedScore - lerpScore) < 10) lerpScore = intendedScore;
	
			scoreText.text = Language.getPhrase('week_score', 'WEEK SCORE: {1}', [lerpScore]);
		}

		// FlxG.watch.addQuick('font', scoreText.font);

		if (!movedBack && !selectedWeek)
		{
			var changeDiff = false;
			if (controls.UI_UP_P)
			{
				changeWeek(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeDiff = true;
			}

			if (controls.UI_DOWN_P)
			{
				changeWeek(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeDiff = true;
			}

			if(FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				changeWeek(-FlxG.mouse.wheel);
				changeDifficulty();
			}

			if (controls.UI_RIGHT)
				rightArrow.animation.play('press')
			else
				rightArrow.animation.play('idle');

			if (controls.UI_LEFT)
				leftArrow.animation.play('press');
			else
				leftArrow.animation.play('idle');

			if (controls.UI_RIGHT_P)
				changeDifficulty(1);
			else if (controls.UI_LEFT_P)
				changeDifficulty(-1);
			else if (changeDiff)
				changeDifficulty();

			if(FlxG.keys.justPressed.CONTROL)
			{
				persistentUpdate = false;
				openSubState(new GameplayChangersSubstate());
			}
			else if(controls.RESET)
			{
				persistentUpdate = false;
				openSubState(new ResetScoreSubState('', curDifficulty, '', curWeek));
				//FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			else if (controls.ACCEPT)
				selectWeek();
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			MusicBeatState.switchState(new MainMenuState());
		}

		super.update(elapsed);
		
		var offY:Float = grpWeekText.members[curWeek].targetY;
		for (num => item in grpWeekText.members)
			item.y = FlxMath.lerp(item.targetY - offY + 480, item.y, Math.exp(-elapsed * 10.2));

		for (num => lock in grpLocks.members)
			lock.y = grpWeekText.members[lock.ID].y + grpWeekText.members[lock.ID].height/2 - lock.height/2;


		
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (!weekIsLocked(loadedWeeks[curWeek].fileName))
		{
			// We can't use Dynamic Array .copy() because that crashes HTML5, here's a workaround.
			var songArray:Array<String> = [];
			var leWeek:Array<Dynamic> = loadedWeeks[curWeek].songs;
			for (i in 0...leWeek.length) {
				songArray.push(leWeek[i][0]);
			}

			// Nevermind that's stupid lmao
			try
			{
				PlayState.storyPlaylist = songArray;
				PlayState.isStoryMode = true;
				selectedWeek = true;
	
				var diffic = Difficulty.getFilePath(curDifficulty);
				if(diffic == null) diffic = '';
	
				PlayState.storyDifficulty = curDifficulty;
	
				Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
				PlayState.campaignScore = 0;
				PlayState.campaignMisses = 0;
			}
			catch(e:Dynamic)
			{
				trace('ERROR! $e');
				return;
			}
			
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].isFlashing = true;
				for (char in grpWeekCharacters.members)
				{
					if (char.character != '' && char.hasConfirmAnimation)
					{
						char.animation.play('confirm');
					}
				}
				stopspamming = true;
			}

			var directory = StageData.forceNextDirectory;
			LoadingState.loadNextDirectory();
			StageData.forceNextDirectory = directory;

			@:privateAccess
			if(PlayState._lastLoadedModDirectory != Mods.currentModDirectory)
			{
				trace('CHANGED MOD DIRECTORY, RELOADING STUFF');
				Paths.freeGraphicsFromMemory();
			}
			LoadingState.prepareToSong();
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				#if !SHOW_LOADING_SCREEN FlxG.sound.music.stop(); #end
				LoadingState.loadAndSwitchState(new PlayState(), true);
				FreeplayState.destroyFreeplayVocals();
			});
			
			#if (MODS_ALLOWED && DISCORD_ALLOWED)
			DiscordClient.loadModRPC();
			#end
		}
		else FlxG.sound.play(Paths.sound('cancelMenu'));
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = Difficulty.list.length-1;
		if (curDifficulty >= Difficulty.list.length)
			curDifficulty = 0;

		WeekData.setDirectoryFromWeek(loadedWeeks[curWeek]);

		var diff:String = Difficulty.getString(curDifficulty, false);
		var newImage:FlxGraphic = Paths.image('menudifficulties/' + Paths.formatToSongPath(diff));
		//trace(Mods.currentModDirectory + ', menudifficulties/' + Paths.formatToSongPath(diff));

		if(sprDifficulty.graphic != newImage)
		{
			sprDifficulty.loadGraphic(newImage);
			sprDifficulty.x = 810;
		
			sprDifficulty.alpha = 0;
			sprDifficulty.y = 0;

			FlxTween.cancelTweensOf(sprDifficulty);
			FlxTween.tween(sprDifficulty, {y: sprDifficulty.y + 30, alpha: 1}, 0.07);
		}
		lastDifficultyName = diff;

		switch (lastDifficultyName)
		{
			case 'normal':
				rightArrow.x = 1167;
			
			case 'insane':
				rightArrow.x = 1167;
			
			case 'expert':
				rightArrow.x = 1167;

			default:
				rightArrow.x = leftArrow.x + 316;
		}

		#if !switch
		intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);
		#end
	}

	var lerpScore:Int = 49324858;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
{
    if (loadedWeeks == null || loadedWeeks.length == 0) return;

    curWeek += change;

    // 🔥 WRAP SEGURO
    curWeek = (curWeek + loadedWeeks.length) % loadedWeeks.length;

    var leWeek:WeekData = loadedWeeks[curWeek];
    if (leWeek == null) return; // 🔥 protección clave

    WeekData.setDirectoryFromWeek(leWeek);

    var leName:String = Language.getPhrase('storyname_${leWeek.fileName}', leWeek.storyName);

    var unlocked:Bool = !weekIsLocked(leWeek.fileName);

    for (num => item in grpWeekText.members)
    {
        item.alpha = 0.6;
        if (num == curWeek && unlocked)
            item.alpha = 1;
    }

    bgSprite.visible = true;

    var assetName:String = leWeek.weekBackground;
    if (assetName == null || assetName.length < 1)
    {
        bgSprite.visible = false;
    }
    else
    {
        bgSprite.loadGraphic(Paths.image('StoryMe/' + assetName));
    }

    PlayState.storyWeek = curWeek;

    Difficulty.loadFromWeek();
    difficultySelectors.visible = unlocked;

    if (Difficulty.list.contains(Difficulty.getDefault()))
        curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(Difficulty.getDefault())));
    else
        curDifficulty = 0;

    var newPos:Int = Difficulty.list.indexOf(lastDifficultyName);
    if (newPos > -1)
    {
        curDifficulty = newPos;
    }

    updateText();
}
	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!weekCompleted.exists(leWeek.weekBefore) || !weekCompleted.get(leWeek.weekBefore)));
	}

	function updateText()
{
    if (loadedWeeks == null || loadedWeeks.length == 0) return;
    if (curWeek < 0 || curWeek >= loadedWeeks.length) return;

    var leWeek:WeekData = loadedWeeks[curWeek];

    if (leWeek == null)
    {
        trace("NULL WEEK at index: " + curWeek);
        return;
    }

    if (leWeek.songs == null)
    {
        trace("NULL SONGS in week: " + leWeek.fileName);
        return;
    }

    var stringThing:Array<String> = [];

    for (i in 0...leWeek.songs.length)
    {
        stringThing.push(leWeek.songs[i][0]);
    }

    txtTracklist.text = '';

    for (i in 0...stringThing.length)
    {
        txtTracklist.text += stringThing[i] + ',   ';
    }

    txtTracklist.text = txtTracklist.text.toUpperCase();

    txtTracklist.screenCenter(X);
    txtTracklist.x -= FlxG.width * 0.35 - 730;

    #if !switch
    intendedScore = Highscore.getWeekScore(leWeek.fileName, curDifficulty);
    #end
}

var scrollSpeed:Float = 8;

function startScrolling()
{
    txtTracklist.x = FlxG.width;

    FlxTween.tween(txtTracklist, {x: -txtTracklist.width}, scrollSpeed, {
        ease: FlxEase.linear,
        onComplete: function(tween:FlxTween)
        {
            startScrolling();
        }
    });
}
 public  function checkWeekCompletion():Void {
    var maxDiff:Int = Difficulty.list.length - 1;
    var maxDiffName:String = Difficulty.getString(maxDiff, false);

	if (isWeekCompleted("prologue")) {
        Achievements.unlock("Mari");
    }

    if (isWeekCompleted("day1")) {
        Achievements.unlock("Rayo");
    }

    if (isWeekCompleted("night2")) {
        Achievements.unlock("Exmix");
    }
	if (isWeekCompleted("day3")) {
        Achievements.unlock("Luzhy");
    }
	if (isWeekCompleted("day4")) {
        Achievements.unlock("Leo");
		openScreen.start(1, function(tmr:FlxTimer) {
			openUnlockCharacter("rayo");
	    });
	}
	if (isWeekCompleted('day5')){
		Achievements.unlock('Daddy');
	}
	if (isWeekCompleted('day5-mom')){
		Achievements.unlock('Mommy');
	}
	if (isWeekCompleted('day6')){
		Achievements.unlock('Darka');
	}
	if (isWeekCompleted('day7')){
		Achievements.unlock('Sarix');
	}
	if (isWeekCompleted('day8')){
		Achievements.unlock('ichi');
	}
	if (isWeekCompleted('day9')){
		Achievements.unlock('bendy');
	}
	if (isWeekCompleted('day10')){
		Achievements.unlock('Brother');
	}
	if (isWeekCompleted("day10-sister")){
		Achievements.unlock('Sister');
		openScreen.start(1, function(tmr:FlxTimer) {
			openUnlockCharacter("mari");
	    });
	}
	if (isWeekCompleted('day11')){
		Achievements.unlock('Karate');
	}
	if (isWeekCompleted('day12')){
		Achievements.unlock('cc');
	}
	if (isWeekCompleted('day13')){
		Achievements.unlock('bf');
	}
	if (isWeekCompleted('day14')){
		Achievements.unlock('isaBM');
	}
	if (isWeekCompleted('day15')){
		Achievements.unlock('Vagos');
	}
	if (isWeekCompleted('day16')){
		Achievements.unlock('jester');
	}
	if (isWeekCompleted('weekR')){
		Achievements.unlock('ronald');
	}
	if (isWeekCompleted('day17')){
		Achievements.unlock('naza');
	}
	
  }
function openUnlockCharacter(char:String):Void {
	persistentUpdate = false;
	if (!ClientPrefs.data.characterList.contains(char)) {
			openSubState(new UnlockCharacter(char));
    }
 }
 function completeByName(name:String, character:String):Void {
    var maxDiff:Int = Difficulty.list.length - 1;
    if (Highscore.getScore(name, maxDiff) > 0) {
        openUnlockCharacter(character);
    }
}
}
