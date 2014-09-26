
require("config")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")


--[[--
local WelcomeApp = class("WelcomeApp", cc.mvc.AppBase)

function WelcomeApp:run()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    CCNotificationCenter:sharedNotificationCenter():registerScriptObserver(nil, function() self:enterSampleScene() end, "WELCOME_LIST_SAMPLES")
    CCNotificationCenter:sharedNotificationCenter():registerScriptObserver(nil, function() self:enterMainFrame() end, "WELCOME_APP")
    self:enterScene("WelcomeScene")
end

function WelcomeApp:enterMainFrame()
    self:enterScene("WelcomeScene", nil, "slideInL", 0.3, display.COLOR_WHITE)
end

function WelcomeApp:enterSampleScene()
    self:enterScene("SampleScene", nil, "pageTurn", 0.5, false)
end

function WelcomeApp:backToMainScene()
    self:enterScene("WelcomeScene", nil, "pageTurn", 0.5, true)
end

return WelcomeApp
]]

local GameScene  = class("GameScene", function()
    return display.newScene("GameScene")
end)


function GameScene:ctor()
	--print('GameScene:ctor..................')
	--cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	--cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	--self:addEventListener("myEvent", handler(self, self.onEvent))	
	--self:dispatch()

	self.mevent ={}
	cc.GameObject.extend(self.mevent)
	:addComponent("components.behavior.EventProtocol")
	:exportMethods()
	self.mevent:addEventListener("myEvent", handler(self, self.onEvent))	

	local sc = display.newSprite('Hello_cocos.png', 240, 320)

	local btargs = {
		image = "CloseNormal.png",
		imageSelected = "CloseSelected.png",
		listener = onClicked,
		--[[listener = function(tag)
			CCLuaLog('Bt is on Click')
			self.mevent:dispatchEvent({name = 'myEvent'})
			end,]]
		x = display.width-32,
		y = display.cy,
		tag = 1
	}

	myBox = sc:getBoundingBox()
	---[[
	sc:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		CCLuaLog('sc:onTouch!')
		return true
		end
	)
	sc:setTouchEnabled(true)
	sc:setTouchSwallowEnabled(false) 				--不吞噬触摸(默认true)触摸将会传递给下一级
	--]]

	self.layer = display.newLayer()
	self.layer:setTag(2)
    self:addChild(self.layer)

	self.layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		CCLuaLog('layer:onTouch!')
		if(event.name == 'began') then
			local x,y = event.x,event.y
			local p = CCPoint(x,y)
			if myBox:containsPoint(p) then 			--判断点是否在CCRect内
				CCLuaLog('is in myBox')
			else
				CCLuaLog('is ont in myBox')
			end
			return true 							--listener在began需要返回true才能有后面的moved,ended事件，默认false
		else
			CCLuaLog('NODE_TOUCH_EVENT:' .. event.name)
		end
	end
	)
	self.layer:setTouchEnabled(true)
	

	local bt = ui.newImageMenuItem(btargs)
	bt.name = 'This is a buttom'
	bt:setTag(21)

	local menu = ui.newMenu({bt})		--self:addChild(bt)，直接增加bt可以显示，但点击无反应
	function menu:onEnterFrame(dt)
		CCLuaLog(dt .. 'menu onEnterframe')
	end
	menu:setTag(20)
	--menu:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt) menu:onEnterFrame(dt) end)	--监听每帧事件
	--menu:scheduleUpdate() 																		--启用定时器监听scheduleUpdate()同scheduleUpdate_()
	self:addChild(sc)
	self:addChild(menu)

	--self.mevent:dispatchEvent({name = 'myEvent'})

    self.str = 'This is self.str'
end

function onClicked(tag)
	print('bt is onClick')
	self = CCDirector:sharedDirector():getRunningScene()
	mBt = self:getChildByTag(20):getChildByTag(tag)
	if not mBt then CCLuaLog('not have mBt child')
	else
		CCLuaLog(string.format('mBt name = %s',mBt.name))
	end
	--game.exit()
	--cc(GameScene):addComponent("components.behavior.EventProtocol"):exportMethods()
	--GameScene:dispatch()
	self.mevent:dispatchEvent({name = 'myEvent'})
	--node:dispatchEvent({name = 'myEvent'})

end

function GameScene:dispatch()
	self.mevent:dispatchEvent({name = 'myEvent'})
end

function GameScene:onEvent()
	CCLuaLog('GameScene:onEvent()....................')
end

function GameScene:onEnter()
	CCLuaLog('GameScene:onEnter')
	--self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt) self:onEnterFrame(dt) end) 				--监听每帧事件
	--self:scheduleUpdate_() 																					--启用定时器监听

end

function GameScene:onEnterFrame(dt)
	CCLuaLog(dt .. 'GameScene onEnterframe')
end

function GameScene:enterScene(sceneName, args, transitionType, time, more)
	
	 print('GameScene:enterScene..................')
end

--[[--
function GameScene:new(...)
	print('GameScene:new..................')
	--GameScene.super.new(...)
	return GameScene
end
]]

game = {}

function game.startup()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    --display.addSpriteFramesWithFile(CONFIG_ROLE_SHEET_FILE,CONFIG_ROLE_SHEET_IMAGE)
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