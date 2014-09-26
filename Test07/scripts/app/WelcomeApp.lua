
require("config")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")

local GameScene  = class("GameScene", function()
    return display.newScene("GameScene")
end)


function GameScene:ctor()
  local backColor = display.newColorLayer(ccc4(20,5,40,128)):addTo(self)

--[[
  local myFire = CCParticleFire:create():addTo(self)            --SDK自带效果
  myFire:pos(display.cx,display.cy+100)

  local mySmoke = CCParticleSmoke:create():addTo(self)          --SDK自带效果
  mySmoke:pos(display.cx,50)

  --local mySnow = CCParticleSnow:create():addTo(self)          --SDK自带效果
  local mySnow = CCParticleSnow:createWithTotalParticles(500):addTo(self)     
  local g = mySnow:getGravity()                                
  CCLuaLog(string.format('gravity x=%g,y=%g',g.x,g.y))
  mySnow:setGravity(CCPoint(0,-100))                             --更改重力属性
--]]

  local item = ui.newImageMenuItem({image='CloseNormal.png', imageSelected='CloseSelected.png',listener = onClicked,tag=11})
  local menu = ui.newMenu({item}):addTo(self)
  menu:pos(display.width-40,display.height-40)
  menu:setZOrder(10)

  local myCreateParticles = CCParticleSystemQuad:create('aaa.plist'):addTo(self)      --通过粒子编辑器生产的plist文件
  myCreateParticles:setTotalParticles(600)                                            --更改属性
  myCreateParticles:setStartSpin(100)
  myCreateParticles:setStartSpinVar(50)
  myCreateParticles:setStartSize(100)
  myCreateParticles:setStartSizeVar(50)


  local touchLayer = display.newLayer():addTo(self)                                    --增加触摸层
  touchLayer:setTouchEnabled(true)
  touchLayer:setZOrder(5)
  --touchLayer:addTouchEventListener(function(event)
  touchLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    --CCLuaLog('touchLayer on Touch!')
    if event.name == 'began' then
      CCLuaLog(string.format('event x=%g,y=%g',event.x,event.y))
      myCreateParticles:pos(event.x, event.y)
      return true
    elseif event.name == 'moved' then
      local dx = event.x - event.prevX
      local dy = event.y - event.prevY
      local x = myCreateParticles:getPositionX()+dx
      local y = myCreateParticles:getPositionY()+dy
      myCreateParticles:pos(x, y)
    end
  end)


end
local effect = {
  'CCParticleFire',
  'CCParticleFireworks',
  'CCParticleSun',
  'CCParticleGalaxy',
  'CCParticleFlower',
  'CCParticleMeteor',
  'CCParticleSpiral',
  'CCParticleExplosion',
  'CCParticleSmoke',
  'CCParticleSnow',
  'CCParticleRain'
}
local index = 1
function onClicked(tag)
  local node = display.getRunningScene():getChildByTag(1)
  if node then
    display.getRunningScene():removeChildByTag(1)               --移除前一个效果对象
  end
  --print('bt is onClick',tag)
  local mySource = 'local tmp = ' .. effect[index] .. ':create()\nreturn tmp' --lua语句
  --CCLuaLog(mySource)
  local tmp,f
  f = loadstring(mySource)                                      --通过loadstring生成粒子效果
  --CCLuaLog(type(f))
  tmp = f()                                                     --执行设定的lua语句
  tmp:addTo(display.getRunningScene())
  tmp:setTag(1)
  CCLuaLog('do effect:' .. effect[index])
  index=index+1
  if index > #effect then index = 1 end
  return false                                                  --返回false，屏蔽下层触摸事件
end


function onTouch(event)
 
end

function GameScene:onEnter()
	CCLuaLog('GameScene:onEnter')																				--启用定时器监听
end


function GameScene:enterScene(sceneName, args, transitionType, time, more)
	 print('GameScene:enterScene..................')
end


game = {}

function game.startup()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    print('startup..................')
    game.enterMainScene()
end

function game.exit()
    CCDirector:sharedDirector():endToLua()
    print('exit..........')
end

function game.enterMainScene()
	print('GameScene.new',type(GameScene.new))
    display.replaceScene(GameScene.new(), "fade", 0.6, display.COLOR_WHITE)
end
return game