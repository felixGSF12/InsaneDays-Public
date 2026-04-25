package substates;

import flixel.addons.transition.FlxTransitionableState;
import states.StoryMenuState;
import states.FreeplayState;
import states.PlayState;
import backend.Highscore;
import backend.WeekData;
import backend.Song;
import backend.Rating;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.effects.FlxFlicker;
import objects.Bar;
import flixel.ui.FlxBar;
import flixel.math.FlxMath;

class ResultsSubstate extends MusicBeatSubstate
{
    public var camHUD:FlxCamera;

    var resultsW:FlxSprite;
    var resultsG:FlxSprite;

    var scoreTxt:FlxText;
    var missTxt:FlxText;
    var accTxt:FlxText;
    var sickTxt:FlxText;
    var goodTxt:FlxText;
    var badTxt:FlxText;
    var shitTxt:FlxText;
    var songTxt:FlxText;
    var highTxt:FlxText;

    public var progressBar:FlxBar;
    public var barTween:FlxTween = null;
    var can_leave = false;

    var lerpScore:Int = 0;
    var intendedScore:Int = 0;
    var lerpMisses:Int = 0;
    var intendedMisses:Int = 0;
    var lerpRating:Float = 0;
    var intendedRating:Float = 0;
    var lerpSick:Int = 0;
    var intendedSick:Int = 0;
    var lerpGood:Int = 0;
    var intendedGood:Int = 0;
    var lerpBad:Int = 0;
    var intendedBad:Int = 0;
    var lerpShit:Int = 0;
    var intendedShit:Int = 0;

    var showScore = false;
    var showMisses = false;
    var showAccuracy = false;
    var showSick = false;
    var showGood = false;
    var showBad = false;
    var showShit = false;
    var showRank = false;
    var rankSprite:FlxSprite;
var ratingSprite:FlxSprite;

var rankings:Array<String> = ['f','e','d','c','b','a','s'];
var ratingImgs:Array<String> = ['shit','bad','good','sick'];

var curRank:Int = 0;
var curRating:Int = 0;

   override function create()
{
    camHUD = new FlxCamera();
    FlxG.cameras.add(camHUD, false);
    camHUD.bgColor.alpha = 0;

    var bg:FlxSprite = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);
    bg.scale.set(FlxG.width, FlxG.height);
    bg.alpha = 0.4;
    add(bg);

    var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
    grid.velocity.set(40, 40);
    grid.alpha = 0;
    FlxTween.tween(grid, {alpha: 1}, 0.5);
    add(grid);

    var resultsW:FlxSprite = new FlxSprite().loadGraphic(Paths.image('results/results-white'));
    add(resultsW);

    var resultsG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('results/results-gold'));
    resultsG.visible = false;
    add(resultsG);

    // TEXTOS
    songTxt = new FlxText(420, 10, FlxG.width, PlayState.SONG.song + ' (' + Difficulty.getString().toUpperCase() + ')', 40);
    add(songTxt);

    scoreTxt = new FlxText(20, 615, FlxG.width, 'Score: 0', 70);
    add(scoreTxt);

    missTxt = new FlxText(20, 515, FlxG.width, 'Misses: 0', 50);
    add(missTxt);

    accTxt = new FlxText(300, 375, FlxG.width, 'Accuracy: 0%', 50);
    add(accTxt);

    // DATOS
    if (PlayState.isStoryMode)
    {
        intendedScore = PlayState.campaignScore;
        intendedMisses = PlayState.campaignMisses;
        intendedRating = PlayState.campaignPercent / PlayState.songsPlayed;
    }
    else
    {
        intendedScore = PlayState.instance.songScore;
        intendedMisses = PlayState.instance.songMisses;
        intendedRating = PlayState.instance.ratingPercent * 100;
    }

    // 🔥 CALCULAR RANKING
    calculateRanking();

    // 🔠 LETRA
    rankSprite = new FlxSprite(750, 100).loadGraphic(Paths.image('ranking/' + rankings[curRank]));
    rankSprite.scale.set(2, 2);
    rankSprite.alpha = 0;
    add(rankSprite);

    // ⭐ RATING (SICK, GOOD...)
    ratingSprite = new FlxSprite(200, 120).loadGraphic(Paths.image(ratingImgs[curRating]));
    ratingSprite.scale.set(3, 3);
    ratingSprite.alpha = 0;
    add(ratingSprite);

    // 🎬 ANIMACIONES
    new FlxTimer().start(0.8, function(tmr)
    {
        FlxTween.tween(rankSprite, {alpha: 1}, 0.5);
        FlxTween.tween(rankSprite.scale, {x: 2.2, y: 2.2}, 0.3);
    });

    new FlxTimer().start(1.2, function(tmr)
    {
        FlxTween.tween(ratingSprite, {alpha: 1}, 0.5);
        FlxTween.tween(ratingSprite.scale, {x: 1.5, y: 1.5}, 0.3);
    });

    // LERP START
    new FlxTimer().start(1.5, function(tmr)
    {
        can_leave = true;
        showScore = true;
        showAccuracy = true;
        showMisses = true;
    });

    super.create();
}

    override function update(elapsed:Float)
    {
        if(showScore)
        {
        lerpScore = Math.floor(FlxMath.lerp(intendedScore, lerpScore, Math.exp(-elapsed * 14)));

        if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
        }

        if(showMisses)
        {
        lerpMisses = Math.floor(FlxMath.lerp(intendedMisses, lerpMisses, Math.exp(-elapsed * 16)));

        if (Math.abs(lerpMisses - intendedMisses) <= 10)
			lerpMisses = intendedMisses;
        }

        var ratingSplit:Array<String> = Std.string(CoolUtil.floorDecimal(lerpRating, 2)).split('.');

        if(showAccuracy)
        {
        lerpRating = FlxMath.lerp(intendedRating, lerpRating, Math.exp(-elapsed * 12));

        if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}

        while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}
        }

        if(showSick)
        {
        lerpSick = Math.floor(FlxMath.lerp(intendedSick, lerpSick, Math.exp(-elapsed * 16)));

        if (Math.abs(lerpSick - intendedSick) <= 10)
			lerpSick = intendedSick;
        }
        if(showGood)
        {
        lerpGood = Math.floor(FlxMath.lerp(intendedGood, lerpGood, Math.exp(-elapsed * 16)));

        if (Math.abs(lerpGood - intendedGood) <= 10)
			lerpGood = intendedGood;
        }
        if(showBad)
        {
        lerpBad = Math.floor(FlxMath.lerp(intendedBad, lerpBad, Math.exp(-elapsed * 16)));

        if (Math.abs(lerpBad - intendedBad) <= 10)
			lerpBad = intendedBad;
        }
        if(showShit)
        {
        lerpShit = Math.floor(FlxMath.lerp(intendedShit, lerpShit, Math.exp(-elapsed * 16)));

        if (Math.abs(lerpShit - intendedShit) <= 10)
			lerpShit = intendedShit;
        }

        scoreTxt.text = 'Score: ' + lerpScore;
        missTxt.text = 'Misses: ' + lerpMisses;
        accTxt.text = 'Accuracy: ' + ' ' + ratingSplit.join('.') + '%';
        sickTxt.text = 'Sicks: ' + lerpSick;
        goodTxt.text = 'Goods: ' + lerpGood;
        badTxt.text = 'Bads: ' + lerpBad;
        shitTxt.text = 'Shits: ' + lerpShit;

        super.update(elapsed);

        if (controls.ACCEPT && can_leave == true)
        {
            endthis();
        }
    }

    function endthis(){
        var percent:Float = PlayState.instance.ratingPercent;
         trace(PlayState.instance.songName);
		if(Math.isNaN(percent)) percent = 0;
        
        if(PlayState.isStoryMode)
        {
        Highscore.saveWeekScore(WeekData.getWeekFileName(), PlayState.campaignScore, PlayState.storyDifficulty);
        }
        else
        {
		Highscore.saveScore(PlayState.SONG.song, PlayState.instance.songScore, PlayState.storyDifficulty, percent);
        }

        PlayState.campaignPercent = PlayState.songsPlayed = 0;
        PlayState.campaignSicks = 0;
        PlayState.campaignGoods = 0;
        PlayState.campaignBads = 0;
        PlayState.campaignShits = 0;

        
        if (PlayState.isStoryMode) 
        {
        MusicBeatState.switchState(new StoryMenuState());
        }
        else
        {
       
        if (PlayState.instance.songName == 'demonophobia')
        {
         MusicBeatState.switchState(new FreeplayState('mari'));
         trace('se termino esta cosa');
        }
        else{
        MusicBeatState.switchState(new FreeplayState());
        }
        FlxG.sound.playMusic(Paths.music('freakyMenu'));
    }
    }
    function openUnlockCharacter(char:String):Void {
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
function calculateRanking():Void
{
    var acc:Float = intendedRating;

    if (acc >= 95) curRank = 6;
    else if (acc >= 90) curRank = 5;
    else if (acc >= 80) curRank = 4;
    else if (acc >= 70) curRank = 3;
    else if (acc >= 60) curRank = 2;
    else if (acc >= 50) curRank = 1;
    else curRank = 0;

    if (acc >= 90) curRating = 3;
    else if (acc >= 75) curRating = 2;
    else if (acc >= 60) curRating = 1;
    else curRating = 0;
}
}
