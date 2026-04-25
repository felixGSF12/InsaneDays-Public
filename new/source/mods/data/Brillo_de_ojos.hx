var eyes:FlxSprite;
function onCreatePost(){
    eyes = new FlxSprite(dad.x + 496,dad.y+210);
    eyes.frames = Paths.getSparrowAtlas('backgrounds/weekend2/eyes-blow');
    eyes.animation.addByPrefix('idle','sky idle',24,true);
    eyes.animation.addByPrefix('up','sky up',24,false);
    eyes.animation.addByPrefix('down','sky down',24,false);
    eyes.animation.addByPrefix('left','sky left',24,false);
    eyes.animation.addByPrefix('right','sky right',24,false);
    eyes.animation.play('idle');
    add(eyes);
}
function onUpdate(){
     switch(dad.animation.curAnim.name){
        case 'singLEFT':
        eyes.animation.play('left');
        eyes.x = 70;
        eyes.y = 375;
        case 'singRIGHT':
        eyes.animation.play('right');
        eyes.x = 383;
        eyes.y = 450;
        case 'singDOWN':
        eyes.animation.play('down');
        eyes.x = 263;
        eyes.y = 475;
        case 'singUP':
        eyes.animation.play('up');
        eyes.x = 112;
        eyes.y = 272;
        default:
        eyes.x = 296;
        eyes.y = 480;
         eyes.animation.play('idle');
    }
}
function opponentNoteHit()
{
    triggerEvent('Screen Shake', '0.1,0.008', '0.1,0.008');
}
