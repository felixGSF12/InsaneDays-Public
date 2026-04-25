package substates;

import states.LoadingFakeState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import states.LanguageSelectorState;
import states.MainMenuState;
import states.FlashingState;
import states.TitleState;

class OutdatedSubState extends MusicBeatState
{
	public static var updateVersion:String = LoadingFakeState.returnVersion();
	var leftState:Bool = false;

	var bg:FlxSprite;
	var warnText:FlxText;

	override function create()
	{
		super.create();

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		bg.alpha = 0.0;
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			'You are running an outdated version of\nInsane Days (${MainMenuState.insaneVersion})\n
			-----------------------------------------------\n
			Press ENTER to update to the latest version ${updateVersion}\n
			Press ESCAPE to proceed anyway.\n
			You can disable this warning by unchecking the
			"Check for Updates" setting in the Options Menu\n
			-----------------------------------------------\n
			Thank you for using the Mod!',
			32);
		warnText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		warnText.scrollFactor.set();
		warnText.screenCenter(Y);
		warnText.alpha = 0.0;
		add(warnText);

		FlxTween.tween(bg, { alpha: 0.8 }, 0.6, { ease: FlxEase.sineIn });
		FlxTween.tween(warnText, { alpha: 1.0 }, 0.6, { ease: FlxEase.sineIn });
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if (controls.ACCEPT) {
				leftState = true;
				CoolUtil.browserLoad("https://github.com/felixGSF12/InsaneDays-Public/releases");
			}
			else if(controls.BACK) {
				if (ClientPrefs.data.language == null || ClientPrefs.data.language == "") {
					MusicBeatState.switchState(new LanguageSelectorState());
				}
				else{
					MusicBeatState.switchState(new FlashingState());
				}
			}
			if(leftState)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(bg, { alpha: 0.0 }, 0.9, { ease: FlxEase.sineOut });
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					ease: FlxEase.sineOut,
					onComplete: function (twn:FlxTween) {
						FlxG.state.persistentUpdate = true;
						MusicBeatState.switchState(new FlashingState());
					}
				});
			}
		}
		super.update(elapsed);
	}
}
