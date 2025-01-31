package;

import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import Achievement.AchievementSystem;
import flixel.util.FlxTimer;
class AchievementState extends MusicBeatState {
    var noAchievementsText:FlxText;
    var isTextFadingOut:Bool = true;
    var titleText:FlxText;
    var curItem:Int = 0;
    var descripBG:FlxSprite;
    var iconGroup:FlxSpriteGroup ;
var descriptionText:FlxText;
    override function create():Void {
        if (iconGroup != null) {
            iconGroup.clear();
        } else {
            iconGroup = new FlxSpriteGroup();
        }
        var bg:FlxSprite = new FlxSprite(0, 0);
        bg.loadGraphic(Paths.image('menumod/GalleryMenu'));
        bg.screenCenter(XY);
     
        add(bg);
        // Cargar los logros
        AchievementSystem.loadAchievements();

        // Verificar si hay logros
        if (AchievementSystem.achievements.length == 0) {
            noAchievementsText = new FlxText(460, 320, FlxG.width, "¡No Hay Logros Desbloqueados!");
            noAchievementsText.setFormat(Paths.font('vcr.ttf'), 25);
            add(noAchievementsText);
            fadeText();
        } else {
            trace("Logros cargados correctamente.");
            // Crear un grupo de sprites para los iconos de logros
            var yPosition:Float = 160;

            for (achievement in AchievementSystem.achievements) {
                trace("Cargando icono para: " + achievement.icon);
                var icon:FlxSprite = new FlxSprite(50, yPosition);
                icon.loadGraphic(Paths.image("achievements/" + achievement.icon));
                trace(icon.x);
                if (!iconGroup.members.contains(icon)){
                    iconGroup.add(icon);
                }
               
                yPosition += 160; 
            }
            add(iconGroup);
            var bgTitle:FlxSprite = new FlxSprite(0,-130).makeGraphic(FlxG.width,255,FlxColor.BLACK);
            bgTitle.alpha = 0;
            FlxTween.tween(bgTitle,{alpha:0.68},0.4);
            add(bgTitle);
            descripBG = new FlxSprite(0,0);
            descripBG.makeGraphic(FlxG.width,255,FlxColor.BLACK);
            descripBG.y = 549;
            descripBG.alpha = 0;
            FlxTween.tween(descripBG,{alpha:0.70},0.4);
            add(descripBG);

            if (AchievementSystem.achievements.length != 0){
                descriptionText = new FlxText(0, 631, FlxG.width, "");
                descriptionText.setFormat(Paths.font('vcr.ttf'), 29, 0xFFFFFFFF, "center");
                add(descriptionText);
                titleText = new FlxText(0,57,FlxG.width,"");
                titleText.setFormat(Paths.font('vcr.ttf'), 29, 0xFFFFFFFF, "center");
                add(titleText);
            }
            changeAchievements(0);
        }

        super.create();
    }

    function fadeText():Void {
        if (isTextFadingOut) {
            FlxTween.tween(noAchievementsText, { alpha: 0 }, 1.6, { onComplete: onFadeComplete });
        } else {
            FlxTween.tween(noAchievementsText, { alpha: 1 }, 1.6, { onComplete: onFadeComplete });
        }
    }

    function onFadeComplete(tween:FlxTween):Void {
        isTextFadingOut = !isTextFadingOut;
        fadeText();
    }
    var centerOffset:Int = 90;
    var yPosition:Int = 50;
    
    function changeAchievements(index:Int):Void {
        FlxG.sound.play(Paths.sound('scrollMenu'), 1);
        curItem += index;
    
        if (curItem < 0) {
            curItem = AchievementSystem.achievements.length - 1;
        }
        if (curItem >= AchievementSystem.achievements.length) {
            curItem = 0;
        }
    
        var newY:Int = centerOffset - (curItem * 150); 
        for (i in 0...iconGroup.length) {
            var targetY:Int = newY + (i * 150 ) + 100;
            if (i == curItem) {
               // iconGroup.members[i].scale.set(1.3, 1.3);
                FlxTween.tween(iconGroup.members[i].scale,{y:1.3,x:1.3},0.5,{ease: FlxEase.elasticOut});
                FlxTween.tween(iconGroup.members[i], { y: targetY, x: 170}, 0.5, { ease: FlxEase.elasticOut});
            } else {
                FlxTween.tween(iconGroup.members[i].scale,{y:1,x:1},0.5,{ease: FlxEase.elasticOut});
                FlxTween.tween(iconGroup.members[i], { y: targetY, x: 50}, 0.5, { ease: FlxEase.elasticOut});
        
            }
    }
}
    override function update(elapsed:Float):Void {
        super.update(elapsed);
        if (descriptionText != null){
    descriptionText.text = AchievementSystem.achievements[curItem].description;
        }
        if (titleText != null){
            titleText.text = AchievementSystem.achievements[curItem].title;
        }
        if (FlxG.keys.justPressed.UP) {
            changeAchievements(-1);
        } else if (FlxG.keys.justPressed.DOWN) {
            changeAchievements(1);
        }
        if (FlxG.keys.justPressed.ESCAPE){
            MusicBeatState.switchState(new MainMenuState());
            FlxG.sound.play(Paths.sound('cancelMenu'),1);
        }
    }
    
}
