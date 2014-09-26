
require("config")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")


local GameScene  = class("GameScene", function()
    return display.newScene("GameScene")
end)


function GameScene:ctor()
	
	local sc = display.newSprite('Hello_cocos.png', 240, 320)

	local btargs = {
		image = "CloseNormal.png",
		imageSelected = "CloseSelected.png",
		listener = onClicked,
		x = display.width-32,
		y = display.cy,
		--tag = 1
	}


	local bt = ui.newImageMenuItem(btargs)
	bt:setTag(21)

  local ttfArgs = {
    text = 'play',
    size = 24,
    color = ccc3(128,255,255),
    tag = 11,
    listener = onClicked,
    sound = '1.mp3',
    align = ui.TEXT_ALIGN_LEFT,
  }

  local ttfArgs2 = clone(ttfArgs)
  ttfArgs2.text = 'stop'
  ttfArgs2.tag = 12
  ttfArgs2.sound = '2.wav'

  local ttfArgs3 = clone(ttfArgs)
  ttfArgs3.text = 'up'
  ttfArgs3.tag = 13
  ttfArgs3.sound = '3.wav'

  local ttfArgs4 = clone(ttfArgs)
  ttfArgs4.text = 'down'
  ttfArgs4.tag = 14
  ttfArgs4.sound = 'hp.ogg'         -- oog文件有问题
  ttfArgs4.sound = '4.wav'         

  local t1 = ui.newTTFLabelMenuItem(ttfArgs)
  local t2 = ui.newTTFLabelMenuItem(ttfArgs2)
  local t3 = ui.newTTFLabelMenuItem(ttfArgs3)
  local t4 = ui.newTTFLabelMenuItem(ttfArgs4)

	local menu = ui.newMenu({bt,t1,t2,t3,t4})		--self:addChild(bt)，直接增加bt可以显示，但点击无反应
	menu:setTag(20)
  menu:pos(display.width-32,display.cy)
  menu:alignItemsVertically()
  --menu:getChildByTag(11):setTag(12)
  --menu:getChildByTag(11):setString('down')
	self:addChild(sc)
	self:addChild(menu)
  audio.preloadMusic('Trouble Maker.mp3')
  audio.preloadSound('1.mp3')
  audio.preloadSound('2.wav')
  audio.preloadSound('3.wav')
  audio.preloadSound('4.wav')

  local drawNode = display.newDrawNode():addTo(self)
  --cc.DrawNode:drawCircle(10)
  --drawNode:drawCircle(10)
  --[[
  drawNode:drawCircle(ccp(50,50),50, {
     fillColor = cc.c4f(1, 0, 0, 1), 
     borderColor = cc.c4f(0, 1, 0, 1), 
     borderWidth = 0.5, 
     segments = 50,
     })
    -- ]]
  drawNode:drawDot(ccp(300, 50), 2, cc.c4f(0, 1, 1, 1))

  local cParams = {
    fill = true,
    color = ccc4f(0,1,0,1),
    x = 100,
    y = 60,
  }
  local circle = display.newCircle(20, cParams):addTo(self)

end

function onClicked(tag)
	print('bt is onClick',tag)
  if tag == 11 then
    if not audio.isMusicPlaying() then
      audio.playMusic('Trouble Maker.mp3', true)
    else
      audio.resumeMusic()
    end
  elseif tag == 12 then
    if audio.isMusicPlaying() then
      audio.pauseMusic()              --pause后，isMusicPlaying是 true，需要resumeMusic继续播放
      --audio.stopMusic()
    end
  elseif tag == 13 then
    local v = audio.getMusicVolume()
    CCLuaLog(string.format('the Volume = %f ,to up',v))
    audio.setMusicVolume(v+0.2)
  elseif tag == 14 then
    local v = audio.getMusicVolume()
    CCLuaLog(string.format('the Volume = %f ,to down',v))
    audio.setMusicVolume(0.0)
    audio.setSoundsVolume(0.0)
  end
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