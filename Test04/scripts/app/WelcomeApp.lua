
require("config")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")

sharedScheduler = CCDirector:sharedDirector():getScheduler()

Timer = require('Timer')

local GameScene  = class("GameScene", function()
    return display.newScene("GameScene")
end)


function GameScene:ctor()
	


	local sc = display.newSprite('Hello_cocos.png', 240, 320)
  --sc:setTag(1)
  CCLuaLog(string.format('sc zOrder = %d',sc:getZOrder()))
	local btargs = {
		image = "CloseNormal.png",
		imageSelected = "CloseSelected.png",
		listener = onClicked,
		x = display.width-32,
		y = display.cy,
		tag = 1
	}

  sbt = display.newSprite("CloseNormal.png",300,50):addTo(self)
  sbt:setColor(cc.c3(0,255,10))
  sbt:setTag(2)

  sbt2 = display.newSprite("CloseNormal.png",50,160):addTo(self)
  sbt2:setColor(cc.c3(50,200,50))
  CCLuaLog(string.format('sbt2 zOrder = %d',sbt2:getZOrder()))
  --sbt2:setTag(1)
  sbt2:setZOrder(1)
  CCLuaLog(string.format('sbt2 getVertexZ = %d',sbt2:getVertexZ()))
  --sbt2:setScale(2.0)
  sbt2:setSkewX(45)
  sbt2:setSkewY(-45)
  --CCLuaLog(string.format('sbt2 tag = %d',sbt2:getTag()))
  --self:reorderChild(sbt2,1)               -- ??? 需要reorder sbt2和在sc上面
  --sbt2:playAnimationForever(seq, 0.4)
  sbt2:runAction(re)

	local bt = ui.newImageMenuItem(btargs)
	bt:setTag(21)

  
	local menu = ui.newMenu({bt})		--self:addChild(bt)，直接增加bt可以显示，但点击无反应
	menu:setTag(20)
  menu:pos(display.width-32,display.cy)
  menu:alignItemsVertically()
  --menu:getChildByTag(11):setTag(12)
  --menu:getChildByTag(11):setString('down')
	self:addChild(sc)
	self:addChild(menu)


  local mDrawDot = display.newDrawNode():addTo(self)
  mDrawDot:drawDot(ccp(0, 0), 5, cc.c4f(0, 1, 1, 1))
  mDrawDot:pos(300, 100)

  local mDrawDot2 = display.newDrawNode()
  mDrawDot2:drawDot(ccp(0, 0), 8, cc.c4f(1, 1, 0, 0.5))
  mDrawDot2:addTo(mDrawDot)
  mDrawDot2:pos(0, 50)

  local mDrawDot3 = display.newDrawNode()
  mDrawDot3:drawDot(ccp(0, 0), 8, cc.c4f(1, 0, 1, 0.5))
  mDrawDot3:addTo(mDrawDot2)
  mDrawDot3:pos(0, 50)
  
  local mD2p = mDrawDot2:getPositionInCCPoint()
  CCLuaLog(string.format('mDrawDot2 x=%g,y=%g',mDrawDot2:getPositionX(),mDrawDot2:getPositionY()))
  CCLuaLog(string.format('mDrawDot2 x=%g,y=%g',mD2p.x,mD2p.y))
  local sp = self:convertToWorldSpace(mD2p)
  CCLuaLog(string.format('self x=%g,y=%g',sp.x,sp.y))

  local mD3p = mDrawDot3:getPositionInCCPoint()
  CCLuaLog(string.format('mDrawDot3 x=%g,y=%g',mD3p.x,mD3p.y))
  local cws = mDrawDot2:convertToWorldSpace(mD3p)
  CCLuaLog(string.format('mDrawDot3 W x=%g,y=%g',cws.x,cws.y))
  local cns = mDrawDot2:convertToNodeSpace(mD3p)
  CCLuaLog(string.format('mDrawDot3 N x=%g,y=%g',cns.x,cns.y))


  local mv = CCMoveBy:create(2, ccp(100,400))
  --mDrawDot:runAction(mv)
  mDrawDot:setTag(10)
  mDrawDot2:setTag(11)
  --[[
  local cParams = {
    fill = true,
    color = ccc4f(0,1,0,1),
    x = 100,
    y = 60,
  }
  local circle = display.newCircle(20, cParams):addTo(self)
  ]]

 --tId = sharedScheduler:scheduleScriptFunc(mySchedulerHalder, 0.5, false)

  Timer:runOnce(
    function()
      CCLuaLog("runOnce")
    end
    )

 local tNode = display.newLayer():addTo(self)
 tNode:setTag(21)
 tNode:addNodeEventListener(cc.NODE_TOUCH_EVENT, onTouch)
 tNode:setTouchSwallowEnabled(false)
 tNode:setTouchEnabled(true)

end

isShow = true
seq = CCSequence:createWithTwoActions(CCMoveBy:create(2, CCPoint(0,100)), CCMoveBy:create(2, CCPoint(0,-100)))
re = CCRepeatForever:create(seq)

function onClicked(tag)
	print('bt is onClick',tag)
  if isShow then    --if sbt:isVisible() then
    isShow = false
    local hi =CCHide:create()
    sbt:runAction(hi)           --sbt:setVisible(false)
  else
    isShow = true
    local sh = CCShow:create()
    sbt:runAction(sh)           --sbt:setVisible(true)
  end

   CCDirector:sharedDirector():getActionManager():removeAction(re)

end

local tCount = 0
function mySchedulerHalder()
  CCLuaLog('... mySchedulerHalder ...')
  local node = display.getRunningScene()
  local children = node:getChildByTag(10)
  local p = children:getPositionInCCPoint()
  --local pp = node:convertToWorldSpace(p)
  --local pp = node:convertToNodeSpace(p)
  local pp = node:convertToNodeSpaceAR(p)
  CCLuaLog(string.format('children x=%g,y=%g',p.x,p.y))
  CCLuaLog(string.format('children x=%g,y=%g',pp.x,pp.y))
  tCount = tCount+1
  if(tCount > 5) then
    sharedScheduler:unscheduleScriptEntry(tId)
  end
end

function onTouch(event)
  local node = display.getRunningScene()
  if not node then
    CCLuaLog('node = nil')
    return false
  end
  --local children2 = node:getChildByTag(8)
  --local p2 = children2:getPositionInCCPoint()
  CCLuaLog(string.format('children x=%g,y=%g',event.x,event.y))
  return false
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