
require("config")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")


local GameScene  = class("GameScene", function()
    return display.newScene("GameScene")
end)


function GameScene:ctor()
	self.fsm ={}
	cc.GameObject.extend(self.fsm)
	:addComponent("components.behavior.StateMachine")
	:exportMethods()
	self.args = {
        events = {
            {name = "01", from = "none",   to = "1" },
            {name = "02",  from = "1",  to = "2"},
            {name = "03", from = "2",  to = "3"   },
            {name = "04", from = "3", to = "4"   },
            {name = "05",  from = "4",    to = "5"},
            {name = "06", from = "5",    to = "6" },
            {name = "07", from = "6", to = "7" },
            {name = "08", from = "7", to = "1" },
        },

        callbacks = {
            on01 = function(event) CCLuaLog('fsm do on01! ') end,
   			on02 = function(event) CCLuaLog('fsm do on02! ') end,
   			on03 = function(event) CCLuaLog('fsm do on03! ') end,
   			on04 = function(event) CCLuaLog('fsm do on04! ') end,
   			on05 = function(event) CCLuaLog('fsm do on05! ') end,
   			on06 = function(event) CCLuaLog('fsm do on06! ') end,
   			on07 = function(event) CCLuaLog('fsm do on07! ') end,
   			on08 = function(event) CCLuaLog('fsm do on08! ') end,
   			onleave7 = function(event)
                for k,v in pairs(event) do
                	CCLuaLog(k)
                end
   				CCLuaLog('fsm do onleave7! ')
   				self:performWithDelay(
   						function()
   							CCLuaLog('onleave7 is done!!!!')
   							event.transition()
   					end,1)
   				return 'async'
   			end,
   			onenter5 = function(event)
   				CCLuaLog('fsm do onenter5! ')
   			end,
        },
    }
	self.fsm:setupState(self.args)


	local sc = display.newSprite('Hello_cocos.png', 240, 320)

	local btargs = {
		image = "CloseNormal.png",
		imageSelected = "CloseSelected.png",
		listener = function (tag)
			local tmp
			local state = self.fsm:getState()
			CCLuaLog(state)
			--[[if state == '7' then state = '1'
			else
				tmp = string.byte(state) + 1
				state = string.char(tmp)
			end]]
			tmp = string.byte(state) + 1
			state = string.char(tmp)
			tmp = string.byte(state)
			tmp = string.byte(state) - string.byte('0') 
			CCLuaLog(tmp)
			CCLuaLog(self.args.events[tmp].name)
			self.fsm:doEvent(self.args.events[tmp].name)

		end,
		x = display.width-32,
		y = display.cy,
		tag = 1
	}


	local bt = ui.newImageMenuItem(btargs)
	bt:setTag(21)

	local menu = ui.newMenu({bt})		--self:addChild(bt)，直接增加bt可以显示，但点击无反应
	menu:setTag(20)
	self:addChild(sc)
	self:addChild(menu)
end

function onClicked(tag)
	print('bt is onClick')

end



function GameScene:onEnter()
	CCLuaLog('GameScene:onEnter')																				--启用定时器监听
	self.fsm:doEvent("01")
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