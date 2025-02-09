local playCryAnim = false;
function onCreatePost()
    if getPropertyFromClass("ClientPrefs", "visibleIcon") == true then
    makeAnimatedLuaSprite("icongf",'icons/gf/'..getProperty("gf.healthIcon"));
    addAnimationByPrefix("icongf", "idle", "idle",24,true);
    addAnimationByPrefix("icongf", "win", "win",24,true);
    addAnimationByPrefix("icongf", "sad", "sad",24,true);
    addAnimationByPrefix("icongf", "miss", "miss",24,true);
    setObjectCamera("icongf",'hud')
    addLuaSprite("icongf",true)
    setProperty("icongf.antialiasing", false);
    setObjectOrder("icongf", getObjectOrder("iconP2")-1)
    setProperty("icongf.x", getProperty("healthBar.x")+230)
    setProperty("icongf.y", getProperty("healthBar.y")-90)
end
end
function onUpdate()
    setProperty("icongf.scale.x", getProperty("iconP1.scale.x"))
    setProperty("icongf.scale.y", getProperty("iconP1.scale.y"))
    setProperty("icongf.angle", getProperty("iconP1.angle"))
  --  setProperty("icongf.alpha", getProperty("iconP1.alpha"))
    setProperty("icongf.visible", getProperty("gf.visible"))
    setProperty("icongf.color", getProperty("iconP1.color"))
  
    local get = getProperty("iconP1.animation.curAnim.curFrame")
    local health = getProperty("health");
    local completedHealth = math.floor(health * 50)
    if completedHealth >= 60 then
        setProperty("icongf.flipX", true)
    else
        setProperty("icongf.flipX", false)
    end
    if playCryAnim == false then
    if get == 0 then
        objectPlayAnimation("icongf", "idle");
    elseif get == 1 then
        objectPlayAnimation("icongf", "sad");
    else
        objectPlayAnimation("icongf", "win");
    end
end

end
function noteMiss()
    playCryAnim = true
    objectPlayAnimation("icongf", "miss");
    runTimer("noCry",0.5);
end
function onTimerCompleted(tag)
    playCryAnim = false;
    objectPlayAnimation("icongf", "idle")
end
