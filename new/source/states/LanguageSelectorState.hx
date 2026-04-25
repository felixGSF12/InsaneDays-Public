package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import backend.ClientPrefs;
import backend.Language;
import states.FlashingState;

class LanguageSelectorState extends MusicBeatState
{
    var languages:Array<String> = ["en-US"];
    var display:Array<String> = ["English"];
    public static var leftState:Bool = false;

    var options:FlxTypedGroup<FlxText>;
    var cur:Int = 0;

    override function create()
    {
        super.create();
        options = new FlxTypedGroup<FlxText>();
        add(options);

        for (i in 0...languages.length)
        {
            var t = new FlxText(0, 120 + i * 60, 0, display[i], 32);
            t.screenCenter(X);
            t.alignment = CENTER;
            options.add(t);
        }

        updateHighlight();
        trace( ClientPrefs.data.language);
        
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.UP) change(-1);
        if (FlxG.keys.justPressed.DOWN) change(1);

        if (FlxG.keys.justPressed.ENTER)
        {
            ClientPrefs.data.language = languages[cur];
            ClientPrefs.saveSettings();
            Language.reloadPhrases();

            MusicBeatState.switchState(new GenderSelectorState());
        }
        
    }

    function change(v:Int)
    {
        cur = (cur + v + languages.length) % languages.length;
        FlxG.sound.play(Paths.sound("scrollMenu"), 0.7);
        updateHighlight();
    }

    function updateHighlight()
    {
        var i = 0;
        for (txt in options)
        {
            txt.color = (i == cur ? FlxColor.WHITE : FlxColor.GRAY);
            i++;
        }
    }
}
class GenderSelectorState extends MusicBeatState
{
    var male:FlxSprite;
    var female:FlxSprite;
    var texte:FlxText;
    var items:Array<String> = ["female","male"];
    var curItem:Int = 0;
    var stickerGroup:FlxTypedGroup<FlxSprite>;
    override function create()
    {
          super.create();
stickerGroup = new FlxTypedGroup<FlxSprite>();
texte = new FlxText(0, 100, FlxG.width, Language.getPhrase('genderShit','What is your gender?'), 36);
texte.setFormat(Paths.font("vcr.ttf"), 36, FlxColor.WHITE, CENTER);
add(texte);

var warning:FlxText = new FlxText(0, FlxG.height - 100, FlxG.width,
Language.getPhrase('genderShit2','Yes, only 2 genders... \nThis can be changed in the options menu, under Role Swap.'), 24);
warning.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER);
add(warning);

for (i in 0...items.length)
{
    var spr = new FlxSprite((i*200)+340, 200);
    spr.loadGraphic(Paths.image(items[i]));
    spr.updateHitbox();
    spr.scale.set(0.5, 0.5);
    stickerGroup.add(spr);

}
add(stickerGroup);
changeItem(0);
}
    function changeItem(dir:Int)
    {
        if (stickerGroup == null || stickerGroup.length == 0) return;
        curItem = (curItem + dir + stickerGroup.length) % stickerGroup.length;
        FlxG.sound.play(Paths.sound("scrollMenu"), 0.7);

        for (i in 0...stickerGroup.length)
        {
            var spr:FlxSprite = cast stickerGroup.members[i];
            if (i == curItem)
            {
                spr.alpha = 1;
                FlxTween.tween(spr.scale, {x:0.8, y:0.8}, 0.5, {ease:FlxEase.elasticOut});
            }
            else
            {
                spr.alpha = 0.5;
                spr.scale.set(0.5, 0.5);
            }
        }
    }
    override function update(elapsed:Float) {
        super.update(elapsed);  
        if (FlxG.keys.justPressed.LEFT) changeItem(-1);
        if (FlxG.keys.justPressed.RIGHT) changeItem(1);
        if (FlxG.keys.justPressed.ENTER)
        {
            FlxG.sound.play(Paths.sound("confirmMenu"), 0.7);
            switch (curItem)
            {
                case 0:
                    ClientPrefs.data.myLove = true;
                    ClientPrefs.saveSettings();
                    MusicBeatState.switchState(new FlashingState());
                case 1:
                    ClientPrefs.data.myLove = false;
                    ClientPrefs.saveSettings();
                    MusicBeatState.switchState(new FlashingState());
    }
}
}
}