
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
	local btargs = {
		image = "CloseNormal.png",
		imageSelected = "CloseSelected.png",
		listener = onClicked,
		x = display.width-32,
		y = display.cy,
		tag = 1
	}


	local bt = ui.newImageMenuItem(btargs)
	--bt:setTag(21)
  items = {}
  items[1] = bt
  myArray = CCArray:create()
  myArray:addObject(items[1])
  for i=2,50 do
    items[i] = ui.newImageMenuItem(btargs)
    items[i]:setTag(i)
    myArray:addObject(items[i])
  end

  menu = CCMenu:createWithArray(myArray)
	menu:setTag(20)
  menu:pos(display.cx,display.cy)

  -- Padding为元素间的间隔
  menu:alignItemsVerticallyWithPadding(20)             --无效果，后面定义的align才生效
  menu:alignItemsHorizontallyWithPadding(20)           --无效果，后面定义的align才生效
  -- menu:setLayoutPadding(50, 50, 50, 50)
  --menu:getChildByTag(11):setTag(12)
  --menu:getChildByTag(11):setString('down')
  --menu:alignItemsInColumnsWithArray(5)

  myArray2 = CCArray:create()
  for i=1,10 do                                         --行数可以多，不能少，自动会去除多的部分
    myArray2:addObject(CCInteger:create(5))             --列数必需是总数的约数
  end
  menu:alignItemsInColumnsWithArray(myArray2)
  menu:setContentSize(CCSize(200,200))

  local Clipping = display.newClippingRegionNode(CCRect(100, 100, 300, 300)):addTo(self)
  --Clipping:addChild(menu)
  Clipping:setZOrder(11)

	self:addChild(sc)
	self:addChild(menu)
  --self:addChild(Clipping)

  local touch = display:newLayer()
  touch:addNodeEventListener(cc.NODE_TOUCH_EVENT, onTouch)
  touch:setTouchSwallowEnabled(false)
  touch:setTouchEnabled(true)
  touch:addTo(Clipping)

  cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()
  self:dumpAllEventListeners()

end

function onClicked(tag)
	--if(tag == 1) then print('bt is onClick',tag) end
  print('bt is onClick',tag)

end

function onTouch(event)
  print('bt is onTouch')
  if event.name == 'moved' then
    local x,y = event.x,event.y
    local px,py = event.prevX,event.prevY
    CCLuaLog(string.format('x,y=%g,%g px,py=%g,%g',x,y,px,py))
    local dx,dy = x-px,y-py
    --x = menu:getPositionX()
    y = menu:getPositionY()
    --menu:pos(x+dx,y+dy)
    --menu:setPositionX(x+dx)
    menu:setPositionY(y+dy)
  end
  if event.name == 'ended' then
    menu:pos(display.cx,display.cy)
  end
  return true
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