import backend.ClientPrefs;
import backend.ClientPrefs;
import flixel.util.FlxTimer;
import backend.WeekData;
import flixel.tweens.FlxEase;
import backend.Song;
import flixel.tweens.FlxTween;
import backend.Paths;
import flixel.addons.display.FlxTiledSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxTiledSprite;
import states.StoryMenuState;
import sys.io.File;
import backend.Conductor;
import flixel.text.FlxTextBorderStyle;
import backend.Language;
import states.PlayState;
import flixel.text.FlxText;
import Reflect;
import backend.Conductor;
import tjson.TJSON;
import flixel.FlxG;
import openfl.Lib;
import shaders.ColorSwap;
import substates.GameOverSubstate;
import backend.MusicBeatState;
import backend.Paths;
import flixel.group.FlxTypedGroup;
var SONG:Song = null;
var disabledEvent = false;
var enableEnd:Bool = false;
var pressed:Bool = false;
var achievementGroup:FlxTypedGroup;
var black:FlxSprite;
var imageShit:Dynamic;
var beatActive:Bool = false;
var street:FlxBackdrop;
var updateStop:Bool = false;
var blackOut:FlxSprite;
var crown:FlxSprite;
var gfIcon:FlxSprite;
//this is for thats-all-folks jumpscare
var jumpscare:FlxSprite;
var blackBG:FlxSprite;
var epicPortrait:FlxSprite;
var overlay:FlxSprite;
//end 
var allowCountdown:Bool = false;
var startedFirstDialogue:Bool = false;
var startedEndDialogue:Bool = false;
var isEnd:Bool = false;
var curGfIcon:String = 'mari';
 var step = 110;
 var enableAngle = false;
var felix:FlxSprite;
var eventing:Bool = false;
var initTween:Bool = false;
var startCompleted = false; //esto es para evitar que se mantenga el zoom siempre, y que permita cambios en medio de la cancion!
 var skipeableIntros:Array<String> = ['demonophobia'];
 var bombox:FlxSprite;
 var isEnding:Bool = false;
 var felixOffsets:Array<Int> = [120,170];
var text:FlxText;
 var isMomStage2:Bool = false;
var exeptions:Array<String> = ['felixAndMari-pixel'];
var felixVariants:Array<String> = ["felix", "felixN", "felixWeek3", "felix_chained", "felixSuit", "felixShade", "felixSa"];
var mariVariants:Array<String> = ["mariP1", "mariP1N", "mariW3_Playable", "mariP1Suit", "mariSuit-shadeP1", "mariSa"];
var bg:FlxSprite;
//defaulObjects for stages
var bg:FlxSprite;
var floor:FlxSprite;
var ccIcon:FlxSprite;
var epic:FlxSprite;

//end
var stageObjects:FlxTypedGroup<FlxSprite>;
var stageObjectsFront:FlxTypedGroup<FlxSprite>;
/**function initRolesSwarp(){
    if (ClientPrefs.data.myLove == true){
        boyfriend.color = dad.color;
        if (gf != null){
 gf.color = dad.color;
        }
       
        switch(boyfriend.curCharacter){
            case "felix":
            triggerEvent('Change Character','bf',mariVariants[0]);
            triggerEvent('Change Character','gf','felixSpeakers');
            case "felixN":
            triggerEvent('Change Character','bf',mariVariants[1]);
            triggerEvent('Change Character','gf','felixSpeakersN'); 

            case "felixWeek3":
             triggerEvent('Change Character','bf',mariVariants[2]);
             createFelixW3SPrite();
             gf.visible = false;
             
            case "felix_chained":
             triggerEvent('Change Character','bf',mariVariants[2]);
             createFelixW3SPrite();
             gf.visible = false;

            case "felixSuit":
             triggerEvent('Change Character','bf',mariVariants[1]);
            triggerEvent('Change Character','gf','felixSpeakersSuit'); 

            case "felixShade":
            triggerEvent('Change Character','bf',mariVariants[1]);
            triggerEvent('Change Character','gf','felixSpeakersSuit-shade'); 
            
            case "felixSa":
            triggerEvent('Change Character','bf',mariVariants[5]);
            triggerEvent('Change Character','gf','felixWeek7gf');

            case "felixPixel":
            triggerEvent("Change Character", 'bf', 'mariPixelP1');
            triggerEvent("Change Character", 'gf', 'felixPixelSpeaker');

            case "rayo-player":
                triggerEvent('Change Character', 'bf', 'sisterPlayable');
                if (StoryMenuState.isWeekCompleted('day11')){
  triggerEvent('Change Character', 'gf', 'rayoSpeaker');
    gf.visible = true;
                }
                else{
                      triggerEvent('Change Character', 'gf', 'rayoSpeaker');
                      gf.visible = false;
                }
              
            
        }
    }
}*/
function onCreatePost(){
    onIsFemale();
    if (gf != null){
        gfIconDraw(gf.healthIcon);
    } 
   if (songName == 'no-more-drogs'){
    black = new FlxSprite();
    black.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
    black.cameras = [camHUD];
    addFlxSprite(black,true);
}
     if (!startCompleted && FlxG.camera.zoom != moreStageZooms(WeekData.getWeekFileName())){
        FlxG.camera.zoom = moreStageZooms(WeekData.getWeekFileName());
        startCompleted = true;
    }
    if (songName == 'no-more-drogs')
    {
        dad.y +=40;
    }
if (songName != 'multilove' && songName != 'thats-all-folks' ){
//initRolesSwarp();
}
  marianStuff(true,0); 
    //stageProperties();
    for (name in exeptions){
    if (ClientPrefs.data.myLove == true && boyfriend.curCharacter != name && songName != 'thats-all-folks'){
        var position:Array<Float> = getPositionByJson(PlayState.curStage);
        if (gf != null){
        if (boyfriend.curCharacter != 'rayo-player' && gf.curCharacter != 'felixSpeaker'){
boyfriend.x = position[0];
boyfriend.y = position[1];
}
}
if (gf != null){
gf.x = position[2];
gf.y = position[3];
}
  if (gf != null){
 if (boyfriend.curCharacter != 'rayo-player' && gf.curCharacter != 'felixSpeaker'){
boyfriendCameraOffset[0] = position[4];
boyfriendCameraOffset[1] = position[5];
   }
   }
 if (songName == 'betrayal-distance' || songName == 'ex-gf'){
        boyfriend.x -= 200;
        boyfriend.y += 130;
    }
    else if (songName == 'no-more-drogs' && boyfriend.curCharacter == 'felixAndMari'){
        boyfriend.y += 110;
        dad.y -= 50;
    }
else if (ClientPrefs.data.myLove == true && WeekData.getWeekFileName() == 'day10-sister' && songName == 'dear-sister' || songName == 'authoritarian'){
boyfriend.y -= 150;
boyfriend.x -= 180;
gf.y -= 100;
}
if (ClientPrefs.data.myLove == true && songName == 'isabm'){
    boyfriend.x += 170;
    gf.y += 49;
}
 else if (ClientPrefs.data.myLove  && songName == 'isabm'){
    boyfriend.x += 770;
    gf.y += 449;
}
if (ClientPrefs.data.myLove == true && WeekData.getWeekFileName() == 'day6' || WeekData.getWeekFileName() == 'day17' ){
    bombox.x = gf.x - 180;
    bombox.y = gf.y;
}
stagesPositionsMulti();
    }
    else if (boyfriend.curCharacter == name){
      // debugPrint("No se puede cambiar la posicion de "+name+" porque es un personaje especial");
       switch (name){
        case 'felixAndMari-pixel':
            boyfriend.x -= 1200;
            boyfriend.y -= 400;
       }
}
}
    if (WeekData.getWeekFileName() == "night2" && songName != 'ex-addict') {
        boyfriend.color = 0x7085ff; 
        gf.color = boyfriend.color;
          }
          bgShits();
          if (songName == "furryphobia"){
            bombox.visible = false;
          }
          if (songName == 'dark-hot'){
        var shader = createRuntimeShader("heatwave");
    for (i in 0...stageObjectsFront.length){
stageObjectsFront.members[i].shader = shader;
  }
        }

}
function stagesPositions(stage:String){
    //bendito sea la persona que invento los "switch-case"
    switch (stage){
    case "day1":
        boyfriend.y += 100;
        boyfriend.x += 80;
        gf.x +=60;
        gf.y +=50;
        boyfriendCameraOffset[0] -= 100;
        boyfriendCameraOffset[1] += 50;
    case "day3":
        if (songName == "esquizofrenia"){
              boyfriend.y += 0;
              boyfriend.x += 200;
              boyfriend.color = dad.color;
        }
        else{
            boyfriend.x += 100;
            boyfriend.y += 200;
        }
    case "night":
        boyfriend.y += 50;
        gf.y += 30;
    case 'day4':
        if (boyfriend.curCharacter == "sisterPlayable"){
    boyfriend.color = dad.color;
    boyfriend.y += 150;
    gf.x -= 200;
    gf.y +=70;
    gf.color = boyfriend.color;
        }
        else if (boyfriend.curCharacter == "mariW3_Playable"){
            boyfriend.y += 180;
        }
        case 'day5':
        if (WeekData.getWeekFileName() != 'day5'){
            gf.scrollFactor.set(1,1);
            gf.scale.set(0.6,0.6);
            gf.x += 850;
            gf.y -= 250;
            if (songName != 'infinite-love' && songName != 'mom-battle'){
            boyfriend.color = 0x828282;
            gf.color = 0x828282;
            }
            else{
            boyfriend.color = 0xff6dd5;
            gf.color = 0xff6dd5;
            }
        }
        case 'day6':
            boyfriend.color = dad.color;
            boyfriend.y += 20;
            boyfriend.x += 100; 
            gf.y += 50;
            gf.color = dad.color;
    boyfriendCameraOffset[0] -= 150;
    boyfriendCameraOffset[1] += 50;
    
       case 'day7':
         boyfriendCameraOffset[0] -= 100;
        boyfriend.y -= 90;
    case 'day8':
        boyfriend.y += 70;
    case 'factory':
    gf.y+= 110;
    case 'ritual':
    gf.y += 80;
    boyfriend.y += 70;
    case 'day10':
        if (WeekData.getWeekFileName() == 'day10') {
            gf.scrollFactor.set(1,1);
boyfriend.y += 200;
gf.y += 140;
        }
        else
        {
            boyfriend.x -= 100;
            boyfriend.y += 50;
            boyfriendCameraOffset[0] -= 100;
        }
    case 'day11':
        boyfriend.y += 60;
    }
}
function onSongStart(){
Lib.application.window.title = "FNF Insane (Now Playing: "+songName + ")"; 
skipIntroText();
}
function onDestroy(){
Lib.application.window.title = "FNF Insane";   
}
function createFelixW3SPrite(){
    felix = new FlxSprite(0,0);
    if (songName != 'esquizofrenia'){
  felix.frames = Paths.getSparrowAtlas('characters/felix/felixAssets');
    felix.animation.addByPrefix('idle','bf idle0',24,true);
    felix.x = boyfriend.x-felixOffsets[0];
    felix.y = boyfriend.y+felixOffsets[1];
    felix.animation.play('idle');
    }
  
    game.insert(6,felix);
    add(felix);
}


function spawnBombox(){

    if (gf != null){

  
    var char:String = gf.curCharacter;

    bombox = new FlxSprite(0, 0);
    bombox.alpha = gf.alpha;

    switch (char){
        case 'mariPixel':

        default:
            bombox.frames = Paths.getSparrowAtlas('speakers/Speakers-new');
            bombox.animation.addByPrefix('bom', 'Símbolo 2', 24, true);
    }
    game.insert(1, bombox);
    bombox.animation.play('bom');
    bombox.x = gf.x;
    bombox.y = gf.y;
    switch (char){
        case 'sister':
            bombox.x -= 350;
            bombox.y -= 30;
            if (songName == 'egocentric-rayo'){
                bombox.y -= 70;
            }
            else if (songName == 'anorexic-rayo'){
                bombox.y -= 90;
            }
       
    }
}
  }

function bgShits() {
    switch (PlayState.curStage){
        case 'hallucination':
            gf.alpha = 0;
    }
    
}
function createBlooms(){
    if (ClientPrefs.data.shaders == true){
    switch(PlayState.curStage){
        case 'day1':
            var bloom:FlxSprite = new FlxSprite(-700,200).loadGraphic(Paths.image('BackGrounds/W1/bloom'));
           bloom.alpha = 0.45;
           addFlxSprite(bloom,true);
   
        case 'night':
            var bloomYellow:FlxSprite = new FlxSprite(-100,-100).loadGraphic(Paths.image('BackGrounds/W2/bloom'));
           bloomYellow.alpha = 0.65;
           bloomYellow.scrollFactor.x = 0.65;
           addFlxSprite(bloomYellow,true);
    
        case 'day8':
            var bloomYellow:FlxSprite = new FlxSprite(-500,0).loadGraphic(Paths.image('BackGrounds/W8/overlayMexicano'));
           bloomYellow.alpha = 0.35;
           bloomYellow.scrollFactor.x = 0.65;
            bloomYellow.scrollFactor.y = 0.65;
           addFlxSprite(bloomYellow,true);
             }
              }
}
function onCreate(){
    stageObjects = new FlxTypedGroup(); // Definido correctamente
    stageObjectsFront = new FlxTypedGroup(); // Definido correctamente
    achievementGroup = new FlxTypedGroup();
    if (gf != null && gf.curCharacter == 'sister'){
         spawnBombox();  
    }
   
    createStages();
    for (i in 0... stageObjects.length){
        game.insert(i,stageObjects.members[i]);
      }
add(stageObjectsFront);  

}

var tweenOptions:FlxTweenOptions = {
type: null,
ease: FlxEase.linear,
onComplete: function(flx:FlxTween):Void {
if (text != null)
    {
        text.destroy();
        text = null;
    }   
        }
    };

function onUpdate(){

    if (WeekData.getWeekFileName() == 'day17'){
        reloadColor();
    }


    if (ClientPrefs.data.myLove == false && songName == 'isabm'){
        boyfriend.x = 600;
        gf.y = 650;
        gf.x = -100;
    }
    if (gf != null && gfIcon != null){
 gf.scrollFactor.set(1,1);
 gfIcon.visible = gf.visible;
gfIcon.alpha = gf.alpha;
    }
    
    if (songName == 'thats-all-folks' && curStep == 2688){
        triggerEvent('Jumpscare','bf', '');
    }
    if (jumpscare != null && jumpscare.animation.curAnim.finished){
        jumpscare.destroy();
        jumpscare = null;
        blackOut.destroy();
         }
     if (gfIcon != null){
 gfIconOffsets(gfIcon.flipX);
     }  
     if (black != null && songName == 'no-more-drogs' && curStep >= 176){
        black.destroy();
     }
    if (!startCompleted && FlxG.camera.zoom != moreStageZooms(WeekData.getWeekFileName())){
        FlxG.camera.zoom = moreStageZooms(WeekData.getWeekFileName());
        startCompleted = true;
    }
   // debugPrint("defaultCamera: "+defaultCamZoom);
    if (songName == "esquizofrenia" && PlayState.curStage == "day3"){
        if (boyfriend.color != 0xec7e52){
            boyfriend.color = 0xec7e52;
            dad.color = boyfriend.color;
        }
    }
    songEvents();
    if (bombox != null){
 bombox.alpha = gf.alpha;
    }
for (song in skipeableIntros){
    if (song == songName){
  if (text != null){
 skipIntro();
    }
    }
}   
if (pressed) {
if (text != null){
      FlxTween.tween(text, {alpha: 0}, 2, tweenOptions);
}
}
if (PlayState.curStage == 'day6' && songName == 'otaku' && curStep == 960){
    createFire();
    colors(0xf49158,0xf49158,0xf49158,{
        id: stageObjects.length,
        color: 0xf49158});
    bombox.color = 0xf49158;
}
if (disabledEvent == false && curStep < step){
marianStuff(false,0,'notes');
}
else if (initTween == false && curStep == step ){
marianStuff(false,0,'tween');
}
if (gfIcon!= null){
gfIcon.x = healthBar.x + 240;
gfIcon.y = healthBar.y - 150;
gfIconUpdate();
}
if (gf != null){
if (curGfIcon != gf.healthIcon) {
    
        gfIconDraw(changeGFIcon());
    }
    }
    if (PlayState.curStage == 'day12' && songName == 'reruns'){
        ccStage('ccNormal',true);
    }
    if (songName == 'thats-all-folks' && curStep == 288){
        for (i in 0...stageObjects.members.length){
            stageObjects.members[i].kill();
           }
        }
        if (ccIcon != null){
        iconCC(true);
    }
    if (songName == 'classism' || songName == 'redex'){
        boyfriend.color = 0xff9c6b;
        dad.color = boyfriend.color;
        gf.color = boyfriend.color;
    }
    if (eventing == true){
     for (i in 0...stageObjectsFront.length){
        stageObjectsFront.members[i].color = boyfriend.color;
     }
      }
      if (WeekData.getWeekFileName() == 'day17'){
nazaretBG(true);
      }
      comboMealShit();
}
  
function songEvents(){
    var isPlaying:Bool = false;
    if (songName == "esquizofrenia" && PlayState.curStage == "day3"){
        if (ClientPrefs.data.myLove == false && curStep == 1601){
FlxTween.tween(gf,{alpha:0.78},2.4);
        }
        if (curStep == 1633){
              triggerEvent('Play Animation', 'aliv', 'gf');
        }
    }
    if (songName == 'furryphobia' && curStep == 767){
        triggerEvent('Change Character','dad','nazaretKiller');
         triggerEvent('Red Flash Camera', 1,'');
        //  createCreepyRayo();
        dad.alpha = 0.65;
    }
    else if (songName == 'furryphobia' && curStep == 1295){
       triggerEvent('Change Character','dad','mapacheR');
       triggerEvent('Red Flash Camera', 1,'');
        dad.alpha = 1;  
        dad.color = boyfriend.color;
    }
  if (blackBG == null && songName == 'no-more-drogs' && curStep == 943) {
 blackBG = new FlxSprite(0, 0);
    blackBG.makeGraphic(FlxG.width, FlxG.height, 0xFF000000); // Negro opaco
    blackBG.cameras = [camHUD];
    add(blackBG);
}
  if (blackBG != null && songName == 'no-more-drogs' && curStep == 974) {
 blackBG.destroy();
}
if (songName == 'no-more-drogs' && curStep == 975){
    gf.visible = false;
    triggerEvent('Change Character','bf','rayo-player');
    gfIcon.visible = false;
    stageObjectsFront.members[0].visible = true;
    
}
if (crown == null && songName == 'ratero' && curStep == 320){
    createCrown(true);
}
if (songName == 'combo-meal' && curStep == 704){
    ronaldStuff(true);
    dad.visible = false;
}
else if (songName == 'combo-meal' && curStep == 1216){
    ronaldStuff(false);
}
}
function skipIntroText(){
   var noSkip:FlxTimer = new FlxTimer().start(6.0, ()->{ pressed = true; });
    for (song in skipeableIntros){
        if (song == songName){
            text = new FlxText(400,510,FlxG.width,'',25);
            //text.text = Language.getPhrase('intro_skip', 'Presiona ( Espacio ) para saltar\nla intro');
            text.cameras = [camOther];
            text.setFormat(Paths.font('vcr.ttf'),27, FlxColor.WHITE, null, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            add(text);

        }
    }
 
}
function skipIntro(){
    if (!pressed && FlxG.keys.justPressed.SPACE){
pressed = true;
Conductor.songPosition = skipIntroTime();
FlxG.sound.music.time = Conductor.songPosition;
vocals.time = Conductor.songPosition;
    }
}
function skipIntroTime():Int{
    switch(songName){
        case 'multilove':
            return 9000;
        case 'anorexic':
            return 5800;
        case 'insane':
            return 5100;
        case 'shot-head':
            return 22000;
        case 'ex-addict':
             return 9100;
        case 'ex-gf':
        return  9000;
        case 'betrayal-distance':
            return 9000;
        case 'esquizofrenia':
            return 3000;
        case 'racoonlovania':
            return 30000;
        case 'willpower':
           return  7000;
        case 'furryphobia':
            return 9000;
        case 'demonophobia':
            for (i in 0...playerStrums.length){
                playerStrums.members[i].alpha = 1;
            }
            disabledEvent = true;
            return 18000;
        case 'no-more-drogs':
            return 23000;
        case 'withered':
            return 20000;
        case 'drawning-dreams':
             return 9020;
        case 'thats-all-folks':
        return 8000;
        case 'reruns':
             return 7000;
        case 'fright-fest':
             return 16000;
        case 'isabm':
             return 17000;
        case 'rapper-battle':
            return 10300;
        case 'redex':
            return 10000;
        case 'classism':
            return 7000;
        case 'madness':
            return 12000;
        case 'aim':
            return 15000;
    }
}
/*AAAAAAAAAAAAAAAAH joPUTASSSS ¿por que no me dijeron 
se que podian crear escenarion con ".json" yo como
ahuevada programando esos gran putos escenario😭😭😭

te odio felix


se cancela mi sufrimiento, json tiene errores con el scrollfactor de gf, mejor
sigo usando haxe :3
*/
function createStages(){
    switch (PlayState.curStage){
        case 'day1':
            if (songName == "anorexic" || songName == "anorexic-rayo"){ //rayo stage
            bg = new FlxSprite(-600, 100).loadGraphic(Paths.image('BackGrounds/W1/sky'));
            bg.scrollFactor.set(0.8,0.8);
            bg.scale.set(1.2,1.2);
            addFlxSprite(bg);
           var city:FlxSprite = new FlxSprite(-600,100).loadGraphic(Paths.image('BackGrounds/W1/city'));
           city.scrollFactor.set(0.8,0.8);
           addFlxSprite(city);
           var floor:FlxSprite = new FlxSprite(-720,160).loadGraphic(Paths.image('BackGrounds/W1/street'));
           addFlxSprite(floor);
            }
        else{
            bg = new FlxSprite(-600, 100).loadGraphic(Paths.image('BackGrounds/W1/skyShade'));
            bg.scrollFactor.set(0.8,0.8);
             bg.scale.set(1.2,1.2);
            addFlxSprite(bg);
           var city:FlxSprite = new FlxSprite(-600,100).loadGraphic(Paths.image('BackGrounds/W1/cityShade'));
           city.scrollFactor.set(0.8,0.8);
           addFlxSprite(city);
           var floor:FlxSprite = new FlxSprite(-750,160).loadGraphic(Paths.image('BackGrounds/W1/streetShade'));
           addFlxSprite(floor);
           createBlooms(); 
        }
        case 'night': //exmix stage
            if (songName == 'egocentric' || songName == 'vaper' || songName == 'exmari'){
            bg = new FlxSprite(-400, -200).loadGraphic(Paths.image('BackGrounds/W2/SkyN'));
            bg.scrollFactor.set(0.8,0.8);
            addFlxSprite(bg);
           var floor:FlxSprite = new FlxSprite(-100,0).loadGraphic(Paths.image('BackGrounds/W2/floorN'));
           addFlxSprite(floor);
           var vaperGang:FlxSprite = new FlxSprite(580,870);
           vaperGang.frames = Paths.getSparrowAtlas('BackGrounds/W2/gangN');
           vaperGang.animation.addByPrefix('idle','VaperGangDay',24,true);
           vaperGang.animation.play('idle');
           addFlxSprite(vaperGang);
           createBlooms();
            }
            else{
            bg = new FlxSprite(-400, -200).loadGraphic(Paths.image('BackGrounds/W2/city_shit'));
            bg.scrollFactor.set(0.8,0.8);
            addFlxSprite(bg);
           var floor:FlxSprite = new FlxSprite(-100,0).loadGraphic(Paths.image('BackGrounds/W2/floor'));
           addFlxSprite(floor);
           var vaperGang:FlxSprite = new FlxSprite(580,870);
           vaperGang.frames = Paths.getSparrowAtlas('BackGrounds/W2/VapeGang');
           vaperGang.animation.addByPrefix('idle','VaperGangDay',24,true);
           vaperGang.animation.play('idle');
           addFlxSprite(vaperGang);
            }

             case 'day3': // luzhy stage
                if (songName != 'esquizofrenia'){   
            var restaurant:FlxSprite = new FlxSprite(-800,0).loadGraphic(Paths.image('BackGrounds/W3/normal_stage'));
            addFlxSprite(restaurant);
            var tables:FlxSprite = new FlxSprite(-550,-300).loadGraphic(Paths.image('BackGrounds/W3/sumtable'));
            tables.scrollFactor.set(0.5,0.5);
            addFlxSprite(tables,true);            
                }
                else{
                    var destroyRe:FlxSprite = new FlxSprite(-700,-280).loadGraphic(Paths.image('BackGrounds/W3/youhavebeendestroyed'));
                    dad.x -= 100; 
                    boyfriend.y -= 60;
                    addFlxSprite(destroyRe);
                var tables:FlxSprite = new FlxSprite(-550,-420).loadGraphic(Paths.image('BackGrounds/W3/overlayingsticks'));
                 tables.scrollFactor.set(0.5,0.5);
                 addFlxSprite(tables,true);
                 gf.alpha = 0;
                 var fireScales:Float = 1.9;
                 var alphas:Float = 0.87;
                 var fire1:FlxSprite = new FlxSprite(-400,210);
                 fire1.frames = Paths.getSparrowAtlas('BackGrounds/W3/newfireglow');
                 fire1.scale.set(fireScales,fireScales);
                 fire1.animation.addByPrefix('glo','FireStage',24,true);
                 fire1.animation.play('glo');
                 fire1.alpha = alphas;
                 addFlxSprite(fire1);
                var fire2:FlxSprite = new FlxSprite(670,210);
                 fire2.frames = Paths.getSparrowAtlas('BackGrounds/W3/newfireglow');
                 fire2.alpha = alphas;
                 fire2.scale.set(fireScales,fireScales);
                 fire2.animation.addByPrefix('glo','FireStage',24,true);
                 fire2.animation.play('glo');
                 addFlxSprite(fire2);
                var furniture:FlxSprite = new FlxSprite(-780,-130).loadGraphic(Paths.image('BackGrounds/W3/glowyfurniture'));
                 addFlxSprite(furniture);
                 //pos fix
                 boyfriend.x += 100;
                 boyfriend.y += 20;
                }
                case 'day4': //leo stage
                    if (songName != 'furryphobia'){
                     var speakers:FlxSprite = new FlxSprite(-700,-50);
                      speakers.frames = Paths.getSparrowAtlas('BackGrounds/W4/images/speakers');
                    speakers.animation.addByPrefix('idle','speakerBeat',24,true);
                    speakers.animation.play('idle');
                    felixOffsets[0] += 120;
                     addFlxSprite(speakers);
                    var room:FlxSprite = new FlxSprite(-1200,-200).loadGraphic(Paths.image('BackGrounds/W4/images/BGDay'));
                  //  bombox.visible = false;
                    addFlxSprite(room);
                    }
                    else{
                var speakers:FlxSprite = new FlxSprite(-700,-50);
                    speakers.frames = Paths.getSparrowAtlas('BackGrounds/W4/images/speakers');
                    speakers.animation.addByPrefix('idle','speakerBeat',24,true);
                    speakers.animation.play('idle');
                 addFlxSprite(speakers);
                var room:FlxSprite = new FlxSprite(-1200,-200).loadGraphic(Paths.image('BackGrounds/W4/images/BGDarkNew'));
                    bombox.visible = false;
                    addFlxSprite(room); 
                    boyfriend.x -= 100;
                    boyfriend.y += 50;
                    boyfriend.color = 0x726bd8;
                    dad.color = boyfriend.color;
                    gf.color = boyfriend.color;
                    gf.y -= 20;
                    gf.x -=80;
                    }
                    case 'day5':
                    if (dad.curCharacter == 'fxdad'){
            var bg:FlxSprite = new FlxSprite(-1400,-600).loadGraphic(Paths.image('BackGrounds/W5/images/mallP'));
                    addFlxSprite(bg);
                    var crown:FlxSprite = new FlxSprite(-600,560);
                    crown.frames = Paths.getSparrowAtlas('BackGrounds/W5/images/cameos');
                    crown.scrollFactor.set(0.73,0.73);
                    crown.scale.set(1.2,1.2);
                    gf.scrollFactor.set(1,1);
                    crown.animation.addByPrefix('idle','Idle',24,true);

                    crown.animation.play('idle');
                    addFlxSprite(crown,true);
                    }
                  else if (dad.curCharacter == 'momfx') {
    createMomStage('limoSunset', 'limoDrive', {
        scaleX: 1.8,
        scaleY: 1.7,
        posX: -400,
        posY: -400,
        bfColor: 0x828282,
        gfColor: 0x828282
    });           
    }
    else if (dad.curCharacter == 'momRTX'){
        gf.scrollFactor.set(1,1);
           createMomStage('limoMoon', 'LimoDriveS', {
        scaleX: 1.8,
        scaleY: 1.7,
        posX: -500,
        posY: -100,
        bfColor: 0xff6dd5,
        gfColor: 0xff6dd5
    });
    }
    case 'day6':
        var bg:FlxSprite = new FlxSprite(-2100,-200);
        bg.loadGraphic(Paths.image('BackGrounds/W6/images/bg'));
        addFlxSprite(bg);
        var floor:FlxSprite = new FlxSprite(-2100,-200);
        floor.loadGraphic(Paths.image('BackGrounds/W6/images/floor'));
        addFlxSprite(floor);
         var walls:FlxSprite = new FlxSprite(-2100,-200);
        walls.loadGraphic(Paths.image('BackGrounds/W6/images/walls'));
        addFlxSprite(walls);
        var boxes:FlxSprite = new FlxSprite(-1900,-350);
    boxes.loadGraphic(Paths.image('BackGrounds/W6/images/boxes'));
    boxes.scrollFactor.set(0.8,0.8);
    addFlxSprite(boxes,true);
        if (songName == 'dark-hot'){
    createFire();
    colors(0xf49158,0xf49158,0xf49158,{
        id: stageObjects.length,
        color: 0xf49158});
        if (bombox != null){
bombox.color = 0xf49158;
        }
        }
        case 'day7':
            gf.scrollFactor.set(1,1);
            var bg:FlxSprite = new FlxSprite(-350,0).loadGraphic(Paths.image('BackGrounds/W7/images/BG'));
            bg.scale.set(2,2);
            var city:FlxSprite = new FlxSprite(-250,100).loadGraphic(Paths.image('BackGrounds/W7/images/City'));
            city.scale.set(2,2);

            var part:FlxSprite = new FlxSprite(-750,-100).loadGraphic(Paths.image('BackGrounds/W7/images/street'));
            part.scale.set(1,1);

            var crown:FlxSprite = new FlxSprite(-200,370);
            crown.frames = Paths.getSparrowAtlas('BackGrounds/W7/images/boppers');
            crown.animation.addByPrefix('idle','FullBopper',24,true);
            crown.scale.set(2,2);
            crown.animation.play('idle');
            addFlxSprite(bg);
            addFlxSprite(city);
            addFlxSprite(crown);
            addFlxSprite(part);

        case 'day8':
        var groups:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
            var bg:FlxSprite = new FlxSprite(-900,0);
            bg.loadGraphic(Paths.image('BackGrounds/W8/BG'));
            var tables:FlxSprite = new FlxSprite(-900,0);
            tables.loadGraphic(Paths.image('BackGrounds/W8/Eatingtable'));
            var unpibemuerto:FlxSprite = new FlxSprite(900,120);
            unpibemuerto.loadGraphic(Paths.image('BackGrounds/W8/arealfamilyguy'));
            unpibemuerto.y = boyfriend.y + 50;

            var fgTables:FlxSprite = new FlxSprite(-1000,0);
            fgTables.loadGraphic(Paths.image('BackGrounds/W8/tables'));
            fgTables.scrollFactor.set(0.8,0.8);
            addFlxSprite(bg);
            addFlxSprite(unpibemuerto);
            addFlxSprite(tables);
            addFlxSprite(fgTables,true);
            if (songName == 'solfefunk'){
                for (i in 1...3){
  var tank0:FlxSprite = new FlxSprite((i*700)-1300,680);
                tank0.frames = Paths.getSparrowAtlas('BackGrounds/W8/PlaneAud'+i);
                tank0.animation.addByPrefix('idle','PlaneAud'+i+' instance 1');
                tank0.scrollFactor.set(0.8,0.8);
                tank0.animation.play('idle');
                groups.add(tank0);
                }
            }
        else if(songName == 'assault'){
              for (i in 1...6){
  var tank0:FlxSprite = new FlxSprite((i*700)-1300,680);
                tank0.frames = Paths.getSparrowAtlas('BackGrounds/W8/PlaneAud'+i);
                tank0.animation.addByPrefix('idle','PlaneAud'+i+' instance 1');
                tank0.scrollFactor.set(0.8,0.8);
                if (i == 3){
                     tank0.animation.addByPrefix('idle','PlanemanAud3 instance 1');
                }
                tank0.animation.play('idle');
                groups.add(tank0);
            
        }
            groups.members[1].y += 100;
    }
      createBlooms();
            add(groups);
            case 'day10':
    if (WeekData.getWeekFileName() == 'day10' && songName != 'mad-defense'){
 var bg:FlxSprite = new FlxSprite(0,-200);
 bg.loadGraphic(Paths.image('BackGrounds/W10/weebSky'));
 bg.scrollFactor.set(0.87,0.87);
 bg.scale.set(7,7);
 addFlxSprite(bg);
 var montains:FlxSprite = new FlxSprite(0,-60);
 montains.loadGraphic(Paths.image('BackGrounds/W10/weebSchool'));
 montains.scrollFactor.set(0.7,0.7);
 montains.scale.set(7,7);
 addFlxSprite(montains);

 
 var dojo:FlxSprite = new FlxSprite();
 dojo.loadGraphic(Paths.image('BackGrounds/W10/weebTreesBack'));
 dojo.scrollFactor.set(0.8,0.8);
 dojo.scale.set(7,7);
 addFlxSprite(dojo);
 
  var crown:FlxSprite = new FlxSprite(0,290);
 crown.frames = Paths.getSparrowAtlas('BackGrounds/W10/bgFreaks');
 crown.animation.addByPrefix('idle','BG Girls Group0',24,true);
 crown.animation.play('idle');
 crown.scale.set(5,5);
 addFlxSprite(crown);

 var floor:FlxSprite = new FlxSprite();
 floor.loadGraphic(Paths.image('BackGrounds/W10/weebStreet'));
 floor.scale.set(7,7);
 addFlxSprite(floor);

  var arboles:FlxSprite = new FlxSprite(0,100);
 arboles.frames = Paths.getSparrowAtlas('BackGrounds/W10/weebTrees');
 arboles.animation.addByPrefix('idle','trees',24,true);
 arboles.animation.play('idle');
 arboles.scale.set(7,7);
 addFlxSprite(arboles,true);
                }
    else if   (WeekData.getWeekFileName() == 'day10' && songName == 'mad-defense'){
var bg:FlxSprite = new FlxSprite(0,-200);
 bg.frames = Paths.getSparrowAtlas('BackGrounds/W10/animatedEvilSchool');
 bg.animation.addByPrefix('glic','background 2');
 bg.animation.play('glic');
 bg.scale.set(7,7);
 addFlxSprite(bg);  
 dad.x += 200;

 var bombox:FlxSprite = new FlxSprite(0,0);
 bombox.frames = Paths.getSparrowAtlas('speakers/gfPixel');
bombox.animation.addByPrefix('bom', 'GF IDLE', 24, true);
bombox.scale.set(gf.scale.x,gf.scale.y);
bombox.x = gf.x - 0;
bombox.y = gf.y + 110;
if (gf.curCharacter == 'felixPixelSpeaker'){
    bombox.y = gf.y + 210;
    bombox.x = gf.x + 140;
}
bombox.animation.play('bom');
addFlxSprite(bombox);
    }   
    else if (WeekData.getWeekFileName() == 'day10-sister' && songName != 'demonophobia')
        {
            dad.x += 1900;
            boyfriend.x -= 360; 
            boyfriend.y -= 140;
            gf.y = 150;
           // bombox.y = gf.y + 100;
            dad.y += 600;
         
            var bg:FlxSprite = new FlxSprite(0,200);
            bg.loadGraphic(Paths.image('BackGrounds/W10/sister/weebSky'));
            bg.scale.set(7,7);
            bg.scrollFactor.x = 0.6;
            bg.scrollFactor.y = 0.6;
            addFlxSprite(bg);
            var school:FlxSprite = new FlxSprite(240,210);
            school.loadGraphic(Paths.image('BackGrounds/W10/sister/weebSchool'));
            school.scrollFactor.set(0.8,0.8);
            school.scale.set(8,8);
            addFlxSprite(school);
            var floor:FlxSprite = new FlxSprite(0,200);
            floor.loadGraphic(Paths.image('BackGrounds/W10/sister/weebStreet'));
            floor.scale.set(7,7);
            addFlxSprite(floor);
            var students:FlxSprite = new FlxSprite(200,210);
            students.frames = Paths.getSparrowAtlas('BackGrounds/W10/sister/bgFreaks');
            students.animation.addByPrefix('idle1','BG girls group0',24,true);
             students.animation.addByPrefix('idle2','BG fangirls dissuaded0',24,true);
             if (songName == 'dear-sister'){
students.animation.play('idle1');
             }
             else{
students.animation.play('idle2');
             }
            students.scale.set(6,6);
            addFlxSprite(students);
var trees:FlxSprite = new FlxSprite(0, 0);
trees.frames = Paths.getPackerAtlas("BackGrounds/W10/sister/weebTrees");
trees.animation.add("idle", [0, 1, 2], 12, true);
trees.scale.set(7,7);
trees.animation.play("idle");
addFlxSprite(trees);
dad.x -= 600;
dad.y -=200;
if (ClientPrefs.data.myLove == false){
boyfriend.x += 130;
boyfriend.y += 50;
}
    }
    else if (songName == 'demonophobia'){
        dad.x -= 300;
        dad.y += 100;
        var bg:FlxSprite = new FlxSprite(0,0);
        bg.makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
        bg.setGraphicSize(FlxG.width + 2100,FlxG.height+1300);
        addFlxSprite(bg);
     var bgAnimated:FlxSprite = new FlxSprite(-1900,-310);
            bgAnimated.frames = Paths.getSparrowAtlas('BackGrounds/W10/sister/weebStage');
            bgAnimated.animation.addByPrefix('idle1','glitchBG 10',24,true);
            bgAnimated.scale.set(6,6);
            bgAnimated.animation.play('idle1');
            addFlxSprite(bgAnimated);
            boyfriend.x += 400;
            boyfriend.y += 200;
}
case 'day11':
    var bg:FlxSprite = new FlxSprite(-500,-300);
    bg.loadGraphic(Paths.image('BackGrounds/W11/abyss'));
    bg.scrollFactor.set(0.8,0.8);
    bg.scale.set(3,3);
    addFlxSprite(bg);

    var montains:FlxSprite = new FlxSprite(-170,100);
    montains.loadGraphic(Paths.image('BackGrounds/W11/hellhole in question'));
    montains.scrollFactor.set(0.7,0.7);
    montains.scale.set(2,2);
    addFlxSprite(montains);
    var jaws:FlxSprite = new FlxSprite(-200, 400);
    jaws.loadGraphic(Paths.image('BackGrounds/W11/jaws'));
    jaws.animation.addByPrefix('idle', 'jawsIdle', 24, true);
    jaws.scale.set(2, 2);
    addFlxSprite(jaws);
    var floo:FlxSprite = new FlxSprite(-500, -300);
    floo.loadGraphic(Paths.image('BackGrounds/W11/infernogroundp1'));
    floo.scale.set(1.6, 1.6);
    addFlxSprite(floo);
    var fxandm:FlxSprite = new FlxSprite(0,0);
    fxandm.frames = Paths.getSparrowAtlas('BackGrounds/W11/felix_good');
    fxandm.animation.addByPrefix('idle','BF HEY!!',24,true);
    fxandm.x = boyfriend.x + 390;
    fxandm.y = boyfriend.y -90;
    fxandm.animation.play('idle');
    fxandm.visible = false;
    addFlxSprite(fxandm,true);
    if (gf.curCharacter == 'rayoSpeaker'){
        gf.x -= 150;
        gf.y -= 100;
    }
case 'day12':
    if (songName == 'fright-fest' || songName == 'reruns' || songName == 'thats-all-folks'){
    ccStage('ccNormal',false);
}
case 'day14':
    if (songName != 'isabm'){
    var bg:FlxSprite = new FlxSprite(-800,-200);
    bg.frames = Paths.getSparrowAtlas('BackGrounds/W14/isaHouse');
    bg.animation.addByPrefix('idle','FireplaceBG0',24,true);
    bg.animation.play('idle');
    addFlxSprite(bg);  
}
else{
    var bg:FlxSprite = new FlxSprite(-900,-200);
    bg.loadGraphic(Paths.image('BackGrounds/W14/motherBG'));
    bg.animation.play('idle');
    addFlxSprite(bg);
    var floor:FlxSprite = new FlxSprite(-900,-400);
    floor.loadGraphic(Paths.image('BackGrounds/W14/motherFG'));
    floor.scale.set(1.3,1.3);
    addFlxSprite(floor);
    var frontFlowers:FlxSprite = new FlxSprite(-900,-400);
    frontFlowers.loadGraphic(Paths.image('BackGrounds/W14/plants'));
    frontFlowers.scrollFactor.set(0.7,0.7);
    frontFlowers.scale.set(1.3,1.3);
    addFlxSprite(frontFlowers,true);
    dad.x -= 100;
      overlay = new FlxSprite(0,0);
    overlay.loadGraphic(Paths.image('BackGrounds/W14/scream_overlay'));
    overlay.cameras = [camOther];
    overlay.alpha = 0;
    add(overlay);
}
case 'schoolBG':
    gf.scale.set(0.96,0.96);
    var bg:FlxSprite = new FlxSprite(300,0);
    bg.loadGraphic(Paths.image('BackGrounds/W15/BG'));
    bg.scale.set(2.8,2.8);
    addFlxSprite(bg);
    if (songName == 'ratero' || songName == 'double-trouble'){
        dad.y += 70; 
    }
    if (songName == 'popayano' || songName == 'double-trouble'){
 createCrown(false);
    }
    if (songName == 'double-trouble'){
        var extra:FlxSprite = new FlxSprite(gf.x-600,gf.y-100);
        extra.frames = Paths.getSparrowAtlas('BackGrounds/W15/Crowd1');
        extra.animation.addByPrefix('idle','Crowd1',24,true);
        extra.animation.play('idle');
        addFlxSprite(extra);
        game.insert(2,extra);
        }
if (songName == 'popayano'){
        var quin:FlxSprite = new FlxSprite(gf.x+400,gf.y+100);
        quin.frames = Paths.getSparrowAtlas('BackGrounds/W15/skip');
        quin.scale.set(0.7,0.7);
        quin.animation.addByPrefix('idle','idleskip',24,true);
        quin.animation.play('idle');
        addFlxSprite(quin);
        game.insert(2,quin);
    }

case 'Train':
    nazaretBG(false);  
    case 'ronald':
        var phase1:Bool = false;
        var phase2:Bool = false;
        switch (dad.curCharacter){
            case 'ronald':
                phase1 = true;
            case 'ronald-lv9':
                phase2 = true;
        }

        var inuko:FlxSprite = new FlxSprite(-100, 480);
        inuko.frames = Paths.getSparrowAtlas('ronald/inuko-boper');
        inuko.animation.addByPrefix('bop', 'xo window', 24, true);
        inuko.scale.set(1.47, 1.47);
        inuko.animation.play('bop');
        addFlxSprite(inuko);
           // --- Sprites principales ---
        var theWall:FlxSprite = new FlxSprite(-80, 0);
        theWall.frames = Paths.getSparrowAtlas('ronald/wall');
        theWall.animation.addByPrefix('bop', 'BG', 24, true);
        theWall.scale.set(1.47, 1.47);
        theWall.animation.play('bop');
        addFlxSprite(theWall);

        // --- Fase 1 ---
            if (phase1 == true)
        {
            var theBackBops:FlxSprite = new FlxSprite(710, 810);
            theBackBops.frames = Paths.getSparrowAtlas('ronald/phase1/back-bopers');
            theBackBops.animation.addByPrefix('bop', 'mcworkers', 24, true);
            theBackBops.scale.set(1.8, 1.8);
            theBackBops.animation.play('bop');
            addFlxSprite(theBackBops);

            var theMidBops:FlxSprite = new FlxSprite(620, 810);
            theMidBops.frames = Paths.getSparrowAtlas('ronald/phase1/mid-bopers');
            theMidBops.animation.addByPrefix('bop', 'peopleback', 24, true);
            theMidBops.scale.set(2.3, 2.3);
            theMidBops.scrollFactor.set(0.98, 0.98);
            theMidBops.animation.play('bop');
            addFlxSprite(theMidBops);

            var theFrontBops:FlxSprite = new FlxSprite(-910, 1010);
            theFrontBops.frames = Paths.getSparrowAtlas('ronald/phase1/front-bopers');
            theFrontBops.animation.addByPrefix('bop', 'peoplefront', 24, true);
            theFrontBops.scale.set(2.6, 2.6);
            theFrontBops.scrollFactor.set(0.84, 0.84);
            theFrontBops.animation.play('bop');
            addFlxSprite(theFrontBops,true);

            var theFrontBops2:FlxSprite = new FlxSprite(-2850, 910); // segunda copia para cubrir el gap
            theFrontBops2.frames = Paths.getSparrowAtlas('ronald/phase1/front-bopers');
            theFrontBops2.animation.addByPrefix('bop', 'peoplefront', 24, true);
            theFrontBops2.scale.set(2.6, 2.6);
            theFrontBops2.flipX = true;
            theFrontBops2.scrollFactor.set(0.84, 0.84);
            theFrontBops2.animation.play('bop');
            addFlxSprite(theFrontBops2,true);
        }

        if (phase2 == true)
        {
             var theBackBops2:FlxSprite = new FlxSprite(710, 810);
            theBackBops2.frames = Paths.getSparrowAtlas('ronald/2phase/back-bopers');
            theBackBops2.animation.addByPrefix('bop', 'mcworkers', 24, true);
            theBackBops2.scale.set(1.8, 1.8);
            theBackBops2.animation.play('bop');
            addFlxSprite(theBackBops2);

            var theMidBops2:FlxSprite = new FlxSprite(590, 840);
            theMidBops2.frames = Paths.getSparrowAtlas('ronald/2phase/mid-bopers');
            theMidBops2.animation.addByPrefix('bop', 'peopleback', 24, true);
            theMidBops2.scale.set(2, 2);
            theMidBops2.scrollFactor.set(0.98, 0.98);
            theMidBops2.animation.play('bop');
            addFlxSprite(theMidBops2);

            var theFrontBops3:FlxSprite = new FlxSprite(1850, 1000);
            theFrontBops3.frames = Paths.getSparrowAtlas('ronald/2phase/front-bopers');
            theFrontBops3.animation.addByPrefix('bop', 'peoplefront', 24, true);
            theFrontBops3.scale.set(2.6, 2.6);
            theFrontBops3.scrollFactor.set(0.84, 0.84);
            theFrontBops3.animation.play('bop');
            addFlxSprite(theFrontBops3,true);

            var shag:FlxSprite = new FlxSprite(-230, 970);
            shag.frames = Paths.getSparrowAtlas('ronald/2phase/shaggy-boper');
            shag.animation.addByPrefix('bop', 'shaggy', 24, true);
            shag.scale.set(2.6, 2.6);
            shag.scrollFactor.set(0.84, 0.84);
            shag.animation.play('bop');
            add(shag);
            epicAnimation();
            epicAnimation2();
        }
        case 'testStage':
            onLoad();
}
}

function createMomStage(bg:String,cars:String,bgProperties:{scaleX:Float,scaleY:Float,posX:Int,posY:Int}){
   if (songName == 'mom-vs-son'){
    var bg:FlxSprite = new FlxSprite(bgProperties.posX,bgProperties.posY).loadGraphic(Paths.image('BackGrounds/W5/images/'+bg));
            bg.scale.set(bgProperties.scaleX,bgProperties.scaleY);
            bg.scrollFactor.set(0.7,0.7);
            addFlxSprite(bg);
             }
             else{
                var bg:FlxBackdrop = new FlxBackdrop(Paths.image('BackGrounds/W5/images/tileableBG'),FlxBackdrop.X,0,1200);
                bg.x = -4800;
                bg.y += 140; 
                bg.scale.set(3.4,3.4);
                bg.velocity.x = 800;
                addFlxSprite(bg);
             }
            var car2:FlxSprite = new FlxSprite(500,130);
            car2.frames = Paths.getSparrowAtlas('BackGrounds/W5/images/'+cars);
            car2.animation.addByPrefix('blow','Limo stage0',24,true);
            gf.scale.set(0.7,0.7);
            gf.x = 1260;
            gf.y = -100;
            car2.scale.set(0.6,0.6);
            car2.animation.play('blow');
            addFlxSprite(car2);
            var car1:FlxSprite = new FlxSprite(-500,830);
            car1.frames = Paths.getSparrowAtlas('BackGrounds/W5/images/'+cars);
            car1.animation.addByPrefix('blow','Limo stage0',24,true);
            car1.scale.set(1.8,1.5);
            car1.animation.play('blow');
            addFlxSprite(car1);
            boyfriend.y -= 30;
            var blow:FlxSprite = new FlxSprite(600,0);
            blow.frames = Paths.getSparrowAtlas('BackGrounds/W5/images/speed');
            blow.animation.addByPrefix('blow','speed idle0',24,true);
            blow.scale.set(6,6);
            blow.animation.play('blow');
            addFlxSprite(blow,true);

}
function colors(bfColor:Int,gfColor:Int,dadColor:Int,bgProperties:{id:Int,color:Int}){
    boyfriend.color = bfColor;
    gf.color = gfColor;
    dad.color = gfColor;
    for (i in 0...bgProperties.id){
        stageObjects.members[i].color = bgProperties.color;
    }
}
function createFire() {
         var fires:Array<String> = ['fire1','fire2'];
        for (i in 0...fires.length){
            var fire:FlxSprite = new FlxSprite(-1300,400);
            fire.frames = Paths.getSparrowAtlas('BackGrounds/W6/images/fireAnim');
            fire.animation.addByPrefix('fire','FIREEE0',24,true);
            fire.animation.play('fire');
            addFlxSprite(fire,true);
        }
}
function addFlxSprite(object:FlxSprite, ?isFront:Bool) {
    if (isFront == null) {
        isFront = false; // valor por defecto
    }

    if (isFront == false) {
        stageObjects.add(object);
    } else {
        stageObjectsFront.add(object);
    }
}
var move = 320;
var move2 = 750;
var move3 = -350;
var vel = 1.0;
var moveShit = 410;
var moveShit2 = 650;
var easing = FlxEase.backOut;
function marianStuff(startSong:Bool,movenote:Int,?enableAlpha:String) //contiene las mecanicas usadas en 'demonophobia'
{
        if (startSong == true){
    if (songName == 'demonophobia'){
    camGame.alpha = 0;
	camHUD.alpha = 0;
		var camGoned:FlxTimer = new FlxTimer();
        camGoned.start(5.8,function(s:FlxTimer):Void{
        FlxTween.tween(camHUD,{alpha:1},5,{ease:FlxEase.linear});
        //FlxTween.tween(camGame,{alpha:1},10,{ease:FlxEase.linear});
        });
    }
    }
    if (blackBG != null){
    if (curStep == 176){
        FlxTween.tween(blackBG,{alpha:0},7);
    }
}
if (songName == 'demonophobia'){
 for (i in 0...4) {

    FlxTween.tween(
        opponentStrums.members[i], // objeto
        {angle:45},                        // ángulo final
        9.5,                       // duración
        {ease: FlxEase.backOut}   // easing
    );
}
}
//port function noteMove1
if (movenote == 1){
FlxTween.tween(opponentStrums.members[0], {x: move3}, vel + 1.01, {ease: easing});
FlxTween.tween(opponentStrums.members[1], {x: move3 + 10}, vel + 1.41, {ease: easing});
FlxTween.tween(opponentStrums.members[2], {x: move3 + 20}, vel + 2.01, {ease: easing});
FlxTween.tween(opponentStrums.members[3], {x: move3 + 30}, vel + 3.01, {ease: easing});

FlxTween.tween(playerStrums.members[0], {x: move}, vel + 1.01, {ease: easing});
FlxTween.tween(playerStrums.members[1], {x: move + 110}, vel + 1.41, {ease: easing});
FlxTween.tween(playerStrums.members[2], {x: move2 + 20}, vel + 2.01, {ease: easing});
FlxTween.tween(playerStrums.members[3], {x: move2 + 130}, vel + 3.01, {ease: easing});

}
else if (movenote == 2){
FlxTween.tween(opponentStrums.members[0], {x: move3}, vel + 1.01, {ease: easing});
FlxTween.tween(opponentStrums.members[1], {x: move3 + 10}, vel + 1.41, {ease: easing});
FlxTween.tween(opponentStrums.members[2], {x: move3 + 20}, vel + 2.01, {ease: easing});
FlxTween.tween(opponentStrums.members[3], {x: move3 + 30}, vel + 3.01, {ease: easing});

FlxTween.tween(playerStrums.members[0], {x: moveShit}, vel + 1.01, {ease: easing});
FlxTween.tween(playerStrums.members[1], {x: moveShit + 110}, vel + 1.41, {ease: easing});
FlxTween.tween(playerStrums.members[2], {x: moveShit2 + 20}, vel + 2.01, {ease: easing});
FlxTween.tween(playerStrums.members[3], {x: moveShit2 + 130}, vel + 3.01, {ease: easing});
}
if (enableAlpha == 'notes'){
        if (songName == 'demonophobia'){
            for (i in 0... playerStrums.length){
                playerStrums.members[i].alpha = 0;
                opponentStrums.members[i].alpha = 0;
            }
        }
}
else if (initTween == false && enableAlpha == 'tween')
    {
for (i in 0... playerStrums.length){
    FlxTween.tween(playerStrums.members[i],{alpha:1},3.4,{ease: FlxEase.linear});
    FlxTween.tween(opponentStrums.members[i],{alpha:1},3.4,{ease: FlxEase.linear});
}
initTween = true;
}
}
function onBeatHit() {
    if (songName == 'demonophobia'){
    if (curBeat % 63 == 0 && curStep > 141) {
        scoreTxt.y = 10;
        botplayTxt.y = 370;
       marianStuff(false,2,null);
    }

    if (curBeat % 39 == 0 && curStep > 11) {
        scoreTxt.y = 689;
        botplayTxt.y = 90;
        marianStuff(false,1,null);
        //debugPrint('aaa');
    }
    stuffs('marian');
    }
   if (dad.curCharacter == 'cdtaf'){
    angleEnable(false);
    iconP1.angle = 1;
    iconP2.angle = 1;
   }
   else{
    angleEnable(true);
   }
} 
function opponentNoteHit(note){
if (songName == 'demonophobia'){
if (healthBar.percent > 40){
FlxTween.tween(camGame,{zoom:0.8},1,{ease:FlxEase.sineInOut});
FlxTween.tween(healthBar,{x:219 * 3},10.2,{ease:FlxEase.backOut});
}
}
 if (songName == "distrust"){
        if (curStep >= 320 && curStep < 448){
            beatActive = true;
            if (beatActive){
                triggerEvent("Screen Shake","0.2,0.03","");
            }
        }
    }
  
   
    //debugPrint(note.hitHealth);
}
function stuffs(name:String){
    if (name == 'marian'){
         if (healthBar.percent > 85){
             FlxTween.tween(healthBar,{x:119},8.12,{ease:FlxEase.backOut});
         }
         
         if (healthBar.percent <= 25) {
            FlxTween.tween(healthBar,{x:319},31.23,{ease:FlxEase.backOut});
         }
    if (curBeat % 14 == 0 && curStep > 1) defaultCamZoom = 1.03;
    if (curBeat % 9 == 0 && curStep > 1){
 if (healthBar.percent < 25){
  healthBar.percent += 0.253;
 }
    }
    }
    else if (name == 'marian2'){
         if (curStep == 248){
            FlxTween.tween(camGame,{alpha:1},2,{ease:FlxEase.linear});
         }

    if (curStep == 1795){
  FlxTween.tween(camGame,{zoom:0.7},1,{ease:FlxEase.sineInOut});
FlxTween.tween(dad,{alpha:0},2,{ease:FlxEase.linear});
FlxTween.tween(iconP2,{alpha:0},2,{ease:FlxEase.linear});
    }
    if (curStep == 1856)camHUD.alpha = 0;
    }
}
function onStepHit(){
    if (songName == 'demonophobia'){
        stuffs('marian2');
    }
}
function moreStageZooms(stage:String){
    switch (stage){
        case 'day10-sister':
             return 0.86;
        default:
            return defaultCamZoom;
 }
}
function gfIconDraw(?icon:String = "mari") {
    if (Paths.fileExists('images/icons/gficon/' + icon + '.png') &&
        Paths.fileExists('images/icons/gficon/' + icon + '.xml') &&
        Paths.fileExists('images/icons/gficon/' + icon + '.json')) {

        var rawJson:String = Paths.getTextFromFile('images/icons/gficon/' + icon + '.json');
        var json:Dynamic = TJSON.parse(rawJson);
        var anims:Array<Dynamic> = json.anims;
        gfIcon = icon;
        gfIcon = new FlxSprite(0, 0);
        gfIcon.frames = Paths.getSparrowAtlas('icons/gfIcon/' + icon);

        for (anim in anims) {
            gfIcon.animation.addByPrefix(anim.name, anim.prefix, 24, anim.loop);
            for (anim in anims) {
    gfIcon.animation.addByPrefix(anim.name, anim.prefix, 24, anim.loop);
}
        }
        gfIcon.animation.play("idle", true); 
        gfIcon.cameras = [camHUD];
        addFlxSprite(gfIcon, true);

        gfIcon.x = healthBar.x + 240;
        gfIcon.y = healthBar.y - 150;
    }
    else{
        gfIconErrors(icon);
    }
}

function gfIconUpdate(){
    if (iconP1.animation.curAnim.curFrame == 1){
        gfIcon.animation.play('sad');
    }
    else if (iconP1.animation.curAnim.curFrame == 2){
        gfIcon.animation.play('happy');
    }
    else{
        gfIcon.animation.play('idle');
        
    }
    if (healthBar.percent > 50){
        gfIcon.flipX = true;
    }
    else
    {
        gfIcon.flipX = false;
    }
    gfIcon.scale.x = iconP1.scale.x;
    gfIcon.angle = iconP1.angle * 1.2;
    gfIcon.scale.y = iconP1.scale.y;
}
function gfIconErrors(icon:String = "mari") {
    var missing:Array<String> = [];

    if (!Paths.fileExists('images/icons/gficon/' + icon + '.png')) {
        missing.push(icon + ".png");
    }
    if (!Paths.fileExists('images/icons/gficon/' + icon + '.xml')) {
        missing.push(icon + ".xml");
    }
    if (Paths.getTextFromFile('images/icons/gficon/' + icon + '.json') == null) {
        missing.push(icon + ".json");
    }

    if (missing.length > 0) {
        debugPrint("Faltan los siguientes archivos para el ícono '" + icon + "':");
        for (file in missing) {
            debugPrint("- " + file,0xa21414);
        }
    } else {
        debugPrint("Error desconocido al cargar el ícono de GF: " + icon);
    }

    return null;
}
function changeGFIcon():String {

    curGfIcon = gf.healthIcon;
    if (gfIcon != null) {
        gfIcon.kill();
    }
    return curGfIcon;
}
var stop:Bool = false;
function gfIconOffsets(flipX:Bool){
        var rawJson:String = Paths.getTextFromFile('images/icons/gficon/' + gf.healthIcon + '.json');
        if (rawJson == null) {
       debugPrint("Error al cargar el archivo JSON del ícono de GF: " + gf.healthIcon, 0xa21414);
            return;
        }
        else{
        var json:Dynamic = TJSON.parse(rawJson);
        var anims:Array<Dynamic> = json.anims;
        if (gfIcon != null){
    for (anim in anims){
        if (gfIcon.animation.curAnim.name == anim.name){
            if (flipX == false){
            gfIcon.offset.set(anim.offsets[0], anim.offsets[1]);
            
}
else{
            gfIcon.offset.set(anim.offsetsFlipX[0], anim.offsetsFlipX[1]);  
}
    }
}
}
   }
}
function getPositionByJson(stageName:String):Array<Float> {
    var rawJson:String = Paths.getTextFromFile('stages/' + stageName + '.json');
    if (rawJson != null) {
    var stageData:Dynamic = TJSON.parse(rawJson);
        if (stageData.femalePostion != null && stageData.femalePostion.length >= 2) {
            return [stageData.femalePostion[0], stageData.femalePostion[1],stageData.inGfPos[0],stageData.inGfPos[1],stageData.camera[0],stageData.camera[1]];
        }
    }
    return [0, 0];
}
function stagesPositionsMulti() 
{
if (PlayState.curStage == 'day5' && dad.curCharacter == 'fxdad'){
boyfriend.x =   1000;
boyfriend.y = 250;
gf.x = 400;
gf.y = 300;
}
else if (PlayState.curStage == 'day5' && dad.curCharacter == 'momfx' ||dad.curCharacter == 'momRTX'){
boyfriend.x =   1000;
boyfriend.y = 250;
gf.x = 1600;
gf.y = -90; 
gf.scale.set(0.8,0.8);
boyfriendCameraOffset[0] -= 100;
if (dad.curCharacter == 'momfx'){
boyfriend.color = 0x919191; 
gf.color = boyfriend.color;
} 
else if (dad.curCharacter == 'momRTX'){
 boyfriend.color = 0xFC72C1; 
 gf.color = boyfriend.color;
}
}

}
var guards:FlxSprite;
function ccStage(stage:String,?update:Bool = false){
    if (stage == 'ccNormal'&& update == false){
        var bg:FlxSprite = new FlxSprite(-1400,-500).loadGraphic(Paths.image('BackGrounds/W12/up'));
        bg.scale.set(1.2,1.2);
        addFlxSprite(bg);
        var upback:FlxSprite = new FlxSprite(-1400,-300).loadGraphic(Paths.image('BackGrounds/W12/upback'));
        upback.scale.set(1.2,1.2);
        addFlxSprite(upback);
        var mall:FlxSprite = new FlxSprite(-1200,-400).loadGraphic(Paths.image('BackGrounds/W12/bg'));
        mall.scale.set(1.2,1.2);
        mall.scrollFactor.set(0.6,0.6);
        addFlxSprite(mall);

guards = new FlxSprite(-1050,0);
guards.frames = Paths.getSparrowAtlas('BackGrounds/W12/guards_bg');
guards.animation.addByPrefix('idle','guardias reruns0',24,true);
guards.animation.play('idle');
guards.alpha = 0;
guards.scale.set(1.2,1.2);
guards.scrollFactor.set(0.6,0.6);
addFlxSprite(guards,false);
var floor:FlxSprite = new FlxSprite(-1400,-300).loadGraphic(Paths.image('BackGrounds/W12/floor'));
floor.scale.set(1.6,1.6);
        addFlxSprite(floor);
    }
if (stage == 'ccNormal'&& update == true && curStep == 391){
    FlxTween.tween(guards,{alpha:1},3);
}


}
function angleEnable(enable:Bool){
     var gfSpeed:Int = 1;
     if (enable == true){
    if (curBeat % gfSpeed == 0) {
        if (curBeat % (gfSpeed * 2) == 0) {
            iconP1.scale.set(0.8, 0.8);
            iconP2.scale.set(1.2, 1.3);

            iconP1.angle = -15;
            iconP2.angle = 15;
        } else {
            iconP1.scale.set(1.2, 1.3);
            iconP2.scale.set(0.8, 0.8);

            iconP1.angle = 15;
            iconP2.angle = -15;
        }
    }
       }
}
function iconCC(update:Bool) {
    if (update == false){
    ccIcon = new FlxSprite(0,0);
    ccIcon.frames = Paths.getSparrowAtlas('icons/icon-taf_cc_icons');
    ccIcon.animation.addByPrefix('normal','neutral icon',24,true);
    ccIcon.animation.addByPrefix('win','winning icon0',24,true);
    ccIcon.animation.addByPrefix('lose','losing icon animation0',24,true);
    ccIcon.cameras = [camHUD];
    ccIcon.animation.play('normal');
    ccIcon.x = iconP2.x;
    ccIcon.y = iconP2.y;
    add(ccIcon);
    }
    else{
        switch (iconP1.animation.curAnim.curFrame){
        case 1:
        ccIcon.animation.play('win');
        case 2:
          ccIcon.animation.play('lose');
        default:
        ccIcon.animation.play('normal');
        }
    ccIcon.x = iconP2.x;
    ccIcon.y = iconP2.y;
    ccIcon.scale.set(iconP2.scale.x,iconP2.scale.y);
    ccIcon.angle = iconP2.angle;

    }
}
function onEvent(name:String,value1:Dynamic,value2:Dynamic) {
if (name == 'Change Character' && value1 == 'dad' && value2 == 'cc-phase-3'){
    iconCC(false);
    iconP2.visible = false;
    
}
else if (name == "Change Stage" && value1 == "dog"){
    ccIcon.kill();
    iconP2.visible = true;
}
if (blackOut == null && name == 'Jumpscare' && value1 == 'bf'){
    blackOut= new FlxSprite(0,0);
    blackOut.makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
    blackOut.setGraphicSize(FlxG.width + 2100,FlxG.height+1300);
    blackOut.cameras = [camOther];
    add(blackOut);
    var timer:FlxTimer = new FlxTimer();
    timer.start(6.8,function(t:FlxTimer){
        if (jumpscare == null){
jumpscare = new FlxSprite(-300,-300);
        jumpscare.frames = Paths.getSparrowAtlas('jumpscare/cbf_jumpscar_e');
        jumpscare.animation.addByPrefix('idle','so scary0',24,false);
        jumpscare.animation.play('idle');
        jumpscare.scale.set(0.7,0.7);
        jumpscare.cameras = [camOther];
        add(jumpscare);
        }
        
    });
}
if (name == 'scream'){
overlay.alpha = 0.8;
var timer:FlxTimer = new FlxTimer();
    timer.start(0.1,function(t:FlxTimer){
        overlay.alpha = 0;
    });    

}
if (name == 'badapplelol'){
    eventing = true;
}
}
function createCrown(tween:Bool){
    crown= new FlxSprite(-680,1000);
    crown.scrollFactor.set(0.8,0.8);
    crown.frames = Paths.getSparrowAtlas('BackGrounds/W15/FrontCrowd');
    crown.animation.addByPrefix('idle','FrontCrowd_Cheer0',24,true);
    crown.animation.play('idle');
    addFlxSprite(crown,true);
    if (tween == true){
    FlxTween.tween(crown,{y:200},1.5,{ease:FlxEase.linear});
    }
    else{
        crown.y = 200;
    }

}
function nazaretBG(update:Bool){
    if (update == false && songName != 'aim'){
var bg:FlxSprite = new FlxSprite(-200,-200);
bg.loadGraphic(Paths.image('Backgrounds/W17/background'));
bg.scrollFactor.set(0.6,0.6);
addFlxSprite(bg);
// animated left boppers
var boppersLeft:FlxSprite = new FlxSprite(100, 430);
boppersLeft.frames = Paths.getSparrowAtlas('BackGrounds/W17/boppers_left');
boppersLeft.animation.addByPrefix('beat', 'bop', 24, true);
boppersLeft.animation.play('beat');
boppersLeft.scrollFactor.set(0.6, 0.6);
addFlxSprite(boppersLeft, false);

// animated right boppers
var boppersRight:FlxSprite = new FlxSprite(1200, 400);
boppersRight.frames = Paths.getSparrowAtlas('BackGrounds/W17/boppers_right');
boppersRight.animation.addByPrefix('beat', 'bop', 24, true);
boppersRight.animation.play('beat');
boppersRight.scrollFactor.set(0.6, 0.6);
addFlxSprite(boppersRight, false);

// floor / foreground
var fontSprite:FlxSprite = new FlxSprite(0, 0);
fontSprite.loadGraphic(Paths.image('Backgrounds/W17/floorground'));
addFlxSprite(fontSprite, false);



switch (songName){
    case 'distrust':
        boyfriend.color = 0x7A7A7A;
        gf.color = boyfriend.color;
        dad.color = boyfriend.color;
    case 'monetary-killer':
        boyfriend.color = 0x202135;
        gf.color = boyfriend.color;
        dad.color = boyfriend.color;
}
for (sprite in stageObjects.members){
    sprite.color = boyfriend.color;
}
    }
    else if (update == true && songName != 'aim'){
    var sectionsData:Array<SwagSection> = PlayState.SONG.notes;
        if (beatActive == true && curStep == 448){
            beatActive = false;
        }
    else {
        if (updateStop == false){
            defaultCamZoom = 0.74;
            updateStop = true;
        }
    }
    }
    else if (update == false && songName == 'aim'){
  var bg:FlxSprite = new FlxSprite(620, 410);
bg.loadGraphic(Paths.image('Backgrounds/W17/classics'));
bg.scale.set(2.0, 2.0);
addFlxSprite(bg); 
gf.visible = false;
bombox.visible = false;
}
     }
function reloadColor(){
    if (boyfriend.color != dad.color){
    switch (songName){
    case 'distrust':
        boyfriend.color = 0x7A7A7A;
        gf.color = boyfriend.color;
        dad.color = boyfriend.color;
    case 'monetary-killer':
        boyfriend.color = 0x202135;
        gf.color = boyfriend.color;
        dad.color = boyfriend.color;
}
        
    }
}
function ronaldStuff(enable:Bool){
var colorSwap = new ColorSwap();
var colorSwapDarker = new ColorSwap();
var desaturation = colorSwap;
var desaturationDarker = colorSwapDarker;
var fps:Int = 24;
if (enable == true){
//boyfriend.shader = colorSwapDarker.shader;
colorSwap.saturation = -0.45;
colorSwap.brightness = -0.4;
gf.shader = colorSwapDarker.shader;
colorSwapDarker.saturation = -0.45;
colorSwapDarker.brightness = -0.47;
fps = 0;
}
else{
colorSwapDarker.saturation = 0;
colorSwapDarker.brightness = 0;
gf.shader = colorSwapDarker.shader;
fps = 24;

}
for (sprite in stageObjects.members){
sprite.shader = colorSwapDarker.shader;
sprite.animation.curAnim.frameRate = fps;
}
for (sprite in stageObjectsFront.members){
  sprite.shader = colorSwapDarker.shader;
sprite.animation.curAnim.frameRate = fps;  
}
}

function epicAnimation(){
    if (epic == null) //evitamos multiplicacion de sprites xd
        {
epic = new FlxSprite();
epic.frames = Paths.getSparrowAtlas('ronald/2phase/wry');
epic.animation.addByPrefix('anim','RonLv9 WRY',24,false);
epic.x = dad.x - 350;
epic.y = dad.y - 200;
epic.visible = false;
game.insert(2,epic); /*esto es para que no se vea por debajo de gf
ni por encima de los sprites de foreground*/
    }
 }

function epicAnimation2() {
    if (epicPortrait == null){
  epicPortrait = new FlxSprite(-500,200);
  epicPortrait.loadGraphic(Paths.image('ronald/2phase/face'));
  epicPortrait.visible = false;
  game.insert(1,epicPortrait);
    }    
}
function comboMealShit(){
      if (songName == 'combo-meal' && curStep == 669){
        dad.visible = false;
        epic.visible = true;
        epic.animation.play('anim');
      }
      else if (songName == 'combo-meal' && curStep == 704){
        dad.visible = true;
        epic.visible = false;
      }
      if (songName == 'combo-meal' && curStep == 681){
        epicPortrait.visible = true;
       FlxTween.tween(epicPortrait,{x:300},0.8,{ease:FlxEase.linear});
      }
         if (songName == 'combo-meal' && curStep == 704){
       epicPortrait.destroy();
      }
}
function makeStageSprite(x, y, name, dir) {
	var sprite = new FlxSprite(x, y);
	sprite.frames = Paths.getSparrowAtlas('backgrounds/weekend1/' + dir);
	sprite.animation.addByPrefix(name, name, 24, false);
	sprite.animation.play(name);

	return sprite;
}
var building_back:FlxBackdrop;
var building_middle:FlxBackdrop;
var building_front:FlxBackdrop;
var buildings_y:Int = - 340;
function onLoad() {
	var sky = makeStageSprite(-620, -420, 'sky', 'weekend1');
	sky.scale.set(1.4, 1.4);
	sky.scrollFactor.set(0, 0);
	addFlxSprite(sky);

	building_back = new FlxBackdrop(null, FlxBackdrop.X, 0);
    building_back.loadGraphic(Paths.image('backgrounds/weekend1/buildin_last0000'));
	building_back.animation.addByPrefix('buildin_last', 'buildin_last', 24, true);
	building_back.animation.play('buildin_last');
	building_back.y += buildings_y - 180;
	building_back.scrollFactor.set(0.3, 0.3);
	building_back.scale.set(1.4, 1.4);
	addFlxSprite(building_back);

	building_middle = new FlxBackdrop(null, FlxBackdrop.X, 0);
    building_middle.frames = Paths.getSparrowAtlas('backgrounds/weekend1/weekend1');
	building_middle.animation.addByPrefix('buildin_second', 'buildin_second', 24, true);
	building_middle.animation.play('buildin_second');
	building_middle.y += buildings_y - 120;
	building_middle.scrollFactor.set(0.4, 0.4);
	building_middle.scale.set(1.4, 1.4);
	addFlxSprite(building_middle);

	building_front = new FlxBackdrop(null, FlxBackdrop.X, 0);
    building_front.frames = Paths.getSparrowAtlas('backgrounds/weekend1/weekend1');
	building_front.animation.addByPrefix('buildinn_first', 'buildinn_first', 24, true);
	building_front.animation.play('buildinn_first');
	building_front.y += buildings_y - 50;
	building_front.scrollFactor.set(0.6, 0.6);
	building_front.scale.set(1.4, 1.4);
	addFlxSprite(building_front);

	sign = makeStageSprite(700, -170, 'sign1', 'signs');
	sign.scale.set(1.4, 1.4);
	sign.scrollFactor.set(0.7, 0.7);
	addFlxSprite(sign);



	light_back = new FlxBackdrop(null, FlxBackdrop.X, 4000);
    light_back.frames = Paths.getSparrowAtlas('backgrounds/weekend1/weekend1');
	light_back.animation.addByPrefix('light_back', 'light_back', 24, true);
	light_back.animation.play('light_back');
	light_back.x = 10;
	light_back.scrollFactor.set(0.93, 0.93);
	light_back.scale.set(1.4, 1.4);
	addFlxSprite(light_back);
	
	street = new FlxBackdrop(null, FlxBackdrop.X,0,1000);
    street.frames = Paths.getSparrowAtlas('backgrounds/weekend1/weekend1');
    street.animation.addByPrefix('street', 'street', 24, true);
	street.animation.play('street');
	street.y = 500;
	street.scrollFactor.set(1.4, 1.4);
	street.scale.set(1.4, 1.4);
	addFlxSprite(street);

	light_front = new FlxBackdrop(null, FlxBackdrop.X, 2000);
    light_front.frames = Paths.getSparrowAtlas('backgrounds/weekend1/weekend1');
	light_front.animation.addByPrefix('light_front', 'light_front', 24, true);
	light_front.animation.play('light_front');
	light_front.y = 170;
	light_front.scrollFactor.set(1.2, 1.2);
	light_front.scale.set(1.4, 1.4);
	light_front.velocity.x =  -1900;
	addFlxSprite(light_front,true);

building_back.velocity.x = -700;
light_back.velocity.x = -1900;
building_middle.velocity.x = -760;
building_front.velocity.x = -840;
street.velocity.x = -1450;

	if(!ClientPrefs.lowQuality){
		tunnelbg = new FlxBackdrop(Paths.image('backgrounds/weekend1/tunnelbg'), 0, 0);
		tunnelbg.scrollFactor.set(0.95, 0.95);
		tunnelbg.y -= 130;
		tunnelbg.visible = false;
		addFlxSprite(tunnelbg);
	}

	truck = makeStageSprite(-600, 270, 'truck', 'weekend1');
	truck.scale.set(1.4, 1.4);
	addFlxSprite(truck);
}
function onIsFemale(){
    if (PlayState.curStage == 'day1' && (songName == 'shot-head-(m-mix)')) {
        boyfriend.y += 50;
        
}
    }