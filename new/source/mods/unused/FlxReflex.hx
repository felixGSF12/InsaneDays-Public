import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;
import objects.Character;
import flixel.util.FlxTimer;
import tjson.TJSON as Json;

var group:FlxTypedGroup<FlxSprite>;
var characters:FlxTypedGroup<Character>;
var id:Array<String> = ['boyfriend', 'gf','dad'];

// Guardamos los datos de los JSONs para no recargarlos cada frame
var reflexDataList:Array<Dynamic> = [];

// Variables necesarias (replican las del Character original)
var danced:Bool = false;
var gfDance:Bool = false;
var danceIdle:Bool = true;
var debugMode:Bool = false;
var skipDance:Bool = false;
var specialAnim:Bool = false;
var idleSuffix:String = "";

function onCreatePost()
{
    characters = new FlxTypedGroup();
    group = new FlxTypedGroup();
    characters.add(boyfriend);
    characters.add(gf);
     characters.add(dad);

    for (i in 0...3)
    {
        var json = File.getContent(Paths.getPath("characters/shaders/" + characters.members[i].curCharacter + ".json"));
        var raw:Dynamic = Json.parse(json);
        reflexDataList.push(raw); // Guardamos el JSON en el array global

        var sprite:FlxSprite = new FlxSprite();
        sprite.frames = Paths.getSparrowAtlas(raw.image);
        sprite.scale.set(raw.scale, raw.scale);
        sprite.flipY = true;
        sprite.alpha = 0.38;
        for (anim in raw.animations)
        {
        sprite.animation.addByPrefix(anim.anim, anim.name, anim.fps, anim.loop);
       
            
        }

        sprite.ID = id[i];
    
        group.add(sprite);

        sprite.x = raw.position[0];
        sprite.y = raw.position[1];
    }
    orde();
      group.members[2].flipX = true;
   
}

function onUpdatePost(elapsed:Float)
{
    for (i in 0...3)
    {
        var reflexData = reflexDataList[i]; // usamos el JSON guardado
        var curAnim:String = "";
        if (characters.members[i].animation.curAnim != null)
            curAnim = characters.members[i].animation.curAnim.name;
        if (curAnim != "" && group.members[i].animation.getByName(curAnim) != null)
        {
            group.members[i].animation.play(curAnim);

            for (anim in reflexData.animations)
            {
                if (anim.anim == curAnim)
                {
                    group.members[i].offset.set(anim.offsets[0], anim.offsets[1]);
                    break;
                }
            }
        }
    }
    if (!gfDance){
        group.members[1].animation.play(characters.members[1].animation.curAnim.name);
    }
    
}

function gfDanceReflect()
{
    gfDance = true;
    if (!debugMode && !skipDance && !specialAnim)
    {
        if (danceIdle)
        {
            danced = !danced;
            var gfIndex = 1;
            var gfReflex = group.members[gfIndex];
            var reflexData = reflexDataList[gfIndex]; // usamos el JSON de GF

            if (gfReflex != null)
            {
                var animName = danced ? 'danceRight' + idleSuffix : 'danceLeft' + idleSuffix;
                gfReflex.animation.play(animName);

                for (anim in reflexData.animations)
                {
                    if (anim.anim == animName)
                    {
                        gfReflex.offset.set(anim.offsets[0], anim.offsets[1]);
                        break;
                    }
                }
            }
        }
    }
}

function onBeatHit()
{
    
    if (curBeat % 2 == 0)

        gfDanceReflect();
}

function orde(){
    game.insert(10,group.members[0]);
    game.insert(9,group.members[1]);
     game.insert(12,group.members[2]);
}
