package states;
//import CharacterSelector;
import states.ModsMenuState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.FlxG;
import backend.WeekData;
import flixel.FlxState;
import flixel.effects.FlxFlicker;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import states.DownloadModsState;
import flixel.util.FlxColor;
import options.OptionsState;
import flixel.group.FlxSpriteGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.text.FlxText.FlxTextBorderStyle;
class MainMenuState_OLD extends MusicBeatState {
    var menuAssets:FlxSpriteGroup;
    var optionText:FlxText;
    public static var insaneVersion:String = '0.5.0 (retake)';
    var bg:FlxSprite;
   // var bg:FlxSprite;
    var objects:Array<String> = ['addons', 'options','storymode', 'gallery', 'freeplay','modLib','credits'];
    var gotoState:FlxTimer;
    var speed:Int = 0;
    var value:Int = 0;
    var xy:Bool = false;
    var achi:Achievement;

    var selected:Bool = false;
    var achievements:FlxSprite;
    var barras:FlxSprite;
    var marco:FlxSprite;
    var marcoBG:FlxSprite;
    override function create() {
   #if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
	
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
        gotoState = new FlxTimer();
        FlxG.mouse.visible = true;
        menuAssets = new FlxSpriteGroup();
        bg = new FlxSprite(0, 0).loadGraphic(Paths.image('grad'));
        add(bg);
        marcoBG = new FlxSprite(0,0).loadGraphic(Paths.image('menumod/mainmenu/marcoBG'));
        add(marcoBG);
        for (i in 0...objects.length) {
            var drawImages:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('menumod/mainmenu/menu_' + objects[i]));
            drawImages.ID = i;
            add(drawImages);
            menuAssets.add(drawImages);
        }
        // Crear y añadir el texto para mostrar la opción seleccionada 
      marco = new FlxSprite(0,0).loadGraphic(Paths.image('menumod/mainmenu/marco'));
      

      add(marco);
    achievements = new FlxSprite(0,0);
    achievements.loadGraphic(Paths.image('menumod/mainmenu/achievements'));
    add(achievements);

        optionText = new FlxText(0, FlxG.height - 700, FlxG.width, "", 40); 
        optionText.setFormat(Paths.font('vcr.ttf'), 40, 0xFFFFFFFF, "center"); 
        optionText.setBorderStyle(FlxTextBorderStyle.OUTLINE,FlxColor.BLACK,5);
        add(optionText);
        // sprite position:

        //addons:
        menuAssets.members[0].x = 334;
        menuAssets.members[0].y = 507;
       
        //storymode_position:
        menuAssets.members[2].y += 50;
        menuAssets.members[2].x = 660;
        menuAssets.members[2].scale.set(1.026,1.03);
        //gallery:
        menuAssets.members[3].y = 284;
        menuAssets.members[3].x = 332;
        //options:
        menuAssets.members[1].y = 283;
        menuAssets.members[1].x = 104;
        //downloadList:
        menuAssets.members[5].x = 653;
        menuAssets.members[5].y = 508;
        //downloadList:
         menuAssets.members[6].x = 104;
         menuAssets.members[6].y = 508;
        //free
        menuAssets.members[4].y = 48;
        menuAssets.members[4].x = 104;

var version:String = "INSANE DAYS: " + MainMenuState.insaneVersion;
var engineVersion:String = "PSYCH ENGINE: 1.0.4";
var totalText:FlxText = new FlxText(560,0,FlxG.width, version+"\n"+engineVersion,10);
totalText.setFormat(null, 10, 0xFFFFFFFF, "center");
add(totalText); 


        super.create();
    }
    function hideMenuAssetsExcept(selectedID: Int): Void {
        for (i in 0...menuAssets.members.length) {
            if (menuAssets.members[i].ID != selectedID) {
                FlxTween.tween(menuAssets.members[i], {alpha: 0}, 0.2);
            }
        }
    }
  
        override function update(elapsed:Float) {
            super.update(elapsed);

            if (FlxG.keys.justReleased.SEVEN){
                MusicBeatState.switchState(new states.editors.MasterEditorMenu());
            }
            if (FlxG.keys.justPressed.ESCAPE){
                MusicBeatState.switchState(new TitleState());
            }
            if (achievements.overlapsPoint(FlxG.mouse.getWorldPosition())){
                optionText.text = "Achievements";
                if (FlxG.mouse.justPressed){
                 
                }
               
            }
                
            for (sprite in menuAssets.members) {
                if (sprite.overlapsPoint(FlxG.mouse.getWorldPosition())) {
                    var selectedOption: String = objects[sprite.ID];
                    if (!selected) {
                        optionText.text = Language.getPhrase("menuMain_" + selectedOption, selectedOption);
                    }
                    if (!selected && FlxG.mouse.justPressed) {
                        selected = true;
                        FlxG.mouse.visible = false;
                        FlxTween.tween(optionText, {color: FlxColor.fromString("#3ff0ff")}, 0.2);
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
                        hideMenuAssetsExcept(sprite.ID);
                       // increaseScale(sprite);
                       
                        switch (sprite.ID) {
                            case 0:
                          zoomToSpriteAndSwitchState(sprite, new ModsMenuState());
                           case 1:
                                zoomToSpriteAndSwitchState(sprite, new OptionsState());
                           case 2:
                                zoomToSpriteAndSwitchState(sprite, new StoryMenuState());
                           case 3:
                                zoomToSpriteAndSwitchState(sprite, new GalleryState());
                           case 4:
                                zoomToSpriteAndSwitchState(sprite, new FreeplayState());
                           case 5:
                                zoomToSpriteAndSwitchState(sprite, new DownloadModsState());
                           case 6:
                                zoomToSpriteAndSwitchState(sprite, new CreditsState());
                                
                        }
                    }
                }
            }
        }
        function zoomToSpriteAndSwitchState(
    target:FlxSprite,
    nextState:FlxState,
    zoomLevel:Float = 2,
    duration:Float = 1.1
){
    var cam = FlxG.camera;

    var targetX = target.x + target.width / 2;
    var targetY = target.y + target.height / 2;

    targetX -= cam.width / 2;
    targetY -= cam.height / 2;

    FlxTween.tween(cam.scroll, { x: targetX, y: targetY }, duration, {
        ease: FlxEase.quadOut
    });

    var startZoom = cam.zoom;
    var endZoom = zoomLevel;

    FlxTween.num(startZoom, endZoom, duration, {
        onUpdate: function(t:FlxTween) {
            cam.zoom = startZoom + (endZoom - startZoom) * t.scale;
        },

        onComplete: function(_) {
            // Cambiar de estado cuando termina el zoom
            MusicBeatState.switchState(nextState);
        }
    });
}
}

class MainMenuState extends MusicBeatState
{
    var bg:FlxSprite;
    var itemsGroup:FlxSpriteGroup;
    public static var insaneVersion:String = '25.04.26';
    public var stringItems:Array<String> = [
    'story_mode',
    'freeplay',
    'credits',
    'options',
    'achievements',
    'downloader',
    'mods'
];
var curselected:Int = 0;
var barraUp:FlxSprite;
var barraDown:FlxSprite;
var seletedTween:FlxTween;
var noAllowedNav:Bool = false;
var targetScrollY:Float = 0; 
var leftPart:FlxSprite;
var portrait:FlxSprite;
var currentScrollY:Float = 0;
var random:Float = 1;


//portrait shit
var postX:Float = 0;
var postY:Float = 0;
    override function create() {
        super.create();
        random = FlxG.random.int(1, 5);
        bg = new FlxSprite(0, 0).loadGraphic(Paths.image('title/titlebg_' + random));
         #if MODS_ALLOWED
        Mods.pushGlobalMods();
        Mods.loadTopMod();
        #end
        itemsGroup = new FlxSpriteGroup();
        add(bg);
        var chess:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('title/titlebg0'));
        add(chess);
#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
        portrait = new FlxSprite(postX, postY);
        portrait.loadGraphic(Paths.image('menumod/mainmenu/art_story_mode')); //default portrait
        add(portrait);
        for (i in 0...stringItems.length) {
            var menuItem:FlxSprite = new FlxSprite(520, (i*280));
            menuItem.frames = Paths.getSparrowAtlas('menumod/mainmenu/menu_' + stringItems[i]);
            menuItem.ID = i;
            menuItem.animation.addByPrefix('selected', stringItems[i] + ' basic',24,true);
            menuItem.animation.addByPrefix('idle', stringItems[i] + ' white',24,true);
            menuItem.animation.play('idle');
            itemsGroup.add(menuItem);
}
leftPart = new FlxSprite(0,0).loadGraphic(Paths.image('mmov'));
add(leftPart);
	barraUp = new FlxSprite(0, -260);
		barraUp.loadGraphic(Paths.image('title/barra'));
		barraUp.antialiasing = ClientPrefs.data.antialiasing;
		barraUp.scale.set(3, 1.2);
		barraUp.flipY = true;
		barraDown= new FlxSprite(0, 260);
		barraDown.loadGraphic(Paths.image('title/barra'));
		barraDown.antialiasing = ClientPrefs.data.antialiasing;
		barraDown.scale.set(3, 1.2);
add(itemsGroup);
add(barraUp);
add(barraDown);
changeItem(0);
if (ClientPrefs.data.lowQuality == true){
    Achievements.unlock("toastie");
}
var version:String = "INSANE DAYS: " + MainMenuState.insaneVersion;
var engineVersion:String = "PSYCH ENGINE: 1.0.4";
var totalText:FlxText = new FlxText(560,0,FlxG.width, version+"\n"+engineVersion,10);
totalText.setFormat(null, 10, 0xFFFFFFFF, "center");
add(totalText);
}
function changeItem(index:Int){
    FlxG.sound.play(Paths.sound('scrollMenu'), 0.9);
    curselected += index;
    if (curselected < 0){
        curselected = stringItems.length - 1;
}
    if (curselected >= stringItems.length){
        curselected = 0;
    }
    for (i in 0...itemsGroup.members.length){
           var item = itemsGroup.members[i];
        if (i == curselected){
           item.animation.play('idle',true);
            FlxTween.tween(item, {x:480}, 0.3, {ease: FlxEase.quadOut});
        } 
        else {
         item.animation.play('selected',true); 
         FlxTween.cancelTweensOf(item);
         item.x = 520;
}
}
  targetScrollY = - (curselected * 280);
changePortrait(curselected);
}

override function update(elapsed:Float) {
    super.update(elapsed);
    currentScrollY = FlxMath.lerp(currentScrollY, targetScrollY, 0.12);
    itemsGroup.y = currentScrollY;
if (!noAllowedNav){
    if (FlxG.keys.justPressed.UP) changeItem(-1);
    if (FlxG.keys.justPressed.DOWN) changeItem(1);
    var item = stringItems[curselected];
    var itemSprite = itemsGroup.members[curselected];
    if (FlxG.keys.justPressed.ENTER){
        noAllowedNav = true;
        FlxG.sound.play(Paths.sound('confirmMenu'), 0.9);
     	FlxFlicker.flicker(itemSprite, 1, 0.06, false, false, function(flick:FlxFlicker)
				{
					switch (item)
					{
						case 'story_mode':
							MusicBeatState.switchState(new StoryMenuState());
						case 'freeplay':
							MusicBeatState.switchState(new FreeplayState());
						#if MODS_ALLOWED
						case 'mods':
							MusicBeatState.switchState(new ModsMenuState());
						#end
						
						case 'downloader':
							MusicBeatState.switchState(new states.DownloadModsState());
			
                        #if ACHIEVEMENTS_ALLOWED
						case 'achievements':
							MusicBeatState.switchState(new states.AchievementsMenuState());
						#end
						case 'credits':
							MusicBeatState.switchState(new CreditsState());
						case 'options':
							MusicBeatState.switchState(new OptionsState());
							OptionsState.onPlayState = false;
							if (PlayState.SONG != null)
							{
								PlayState.SONG.arrowSkin = null;
								PlayState.SONG.splashSkin = null;
								PlayState.stageUI = 'normal';
							}
					}
				});
}
}
if (!noAllowedNav && FlxG.keys.justPressed.ESCAPE){
    MusicBeatState.switchState(new TitleState());
    noAllowedNav = true;
}
if (FlxG.keys.justPressed.SEVEN){
      MusicBeatState.switchState(new states.editors.MasterEditorMenu());
}
}
public function changePortrait(index:Int):Void{
    portrait.loadGraphic(Paths.image('menumod/mainmenu/art_' + stringItems[index])); 
    var item:String = stringItems[index];
    trace('cambiando a ' + item);
    switch (item){
        case 'achievements':
            portrait.y -= 70;
            trace('hola esto es una prueba');
        default:
            portrait.y = 0;
}
}
}