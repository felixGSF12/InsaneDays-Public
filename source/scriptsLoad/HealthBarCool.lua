-- Script by AquaStrikr (https://twitter.com/AquaStrikr_)
---comment
---@param animationName string
---@param bool boolean
function onStopAnimation(animationName,bool,char)
setProperty('boyfriend.specialAnim',false)
characterPlayAnim(char,animationName, bool)
end




function onCreatePost()
	makeLuaSprite('Health', 'healthbarSacorg')
	setObjectCamera('Health', 'hud')
	addLuaSprite('Health', true)
	setObjectOrder('Health', getObjectOrder('healthBar') + 1)
	
	setProperty('healthBar.visible', true)
end

--function onCreatePost() -- HBoverlay
  --  makeLuaSprite('healthBarOver', 'saraHUD/healthBarOver', getProperty('healthBar.x') - 4, getProperty('healthBar.y') - 4.9)
    --setObjectCamera('healthBarOver', 'hud');
   -- setProperty('healthBarOver.angle', getProperty('healthBar.angle')) s--etObjectOrder('healthBarOver', getObjectOrder('health') - 1)
--end
--end
function onUpdatePost(elapsed)
	setProperty('Health.x', getProperty('healthBar.x') - 55)
	setProperty('Health.y', getProperty('healthBar.y') - 20)
end
function onUpdate()
	if keyJustPressed('space') then
		characterPlayAnim('boyfriend', 'hey', true);
		triggerEvent("Hey!", 'gf', '')
		setProperty('boyfriend.specialAnim', true);
	elseif boyfriendName == 'fxRTx' then
		onStopAnimation()
	end
end