
require("config")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")

local GameScene  = class("GameScene", function()
    return display.newScene("GameScene")
end)


function GameScene:ctor()
  local backColor = display.newColorLayer(ccc4(20,5,40,128)):addTo(self)
  local iconLayer = display.newLayer():addTo(self)
  local itemLayer = display.newClippingRegionNode(CCRect(40, 100, 400, 400)):addTo(self)
  backColor:setTag(1)
  iconLayer:setTag(2)
  itemLayer:setTag(3)

  itemLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, onTouch)
  itemLayer:setTouchEnabled(true)
  itemLayer:setTouchSwallowEnabled(false)

  local function createCircle(number,r,parent)              --用于创建表示页面底部圆圈，number几个圈，r圆圈半径，parent父节点
    for i=1,number do
      local params = {
        fill = true,
        color = ccc4f(1,1,0.6,1),
        x = r + 3*r*(i-1),
        y = r,
      } 
      local cirlce = display.newCircle(10, params)          --创建圆点
      parent:addChild(cirlce)
    end

    local d = 2*r*number + r*(number-1)
    local x = (display.width-d)/2
    parent:pos(x,r+50)

    local params2 = {
        fill = true,
        color = ccc4f(1,0.5,0.5,1),
        x = r,
        y = r,
      }
    local iconScrell = display.newCircle(8, params2):addTo(parent) --表示当前页面的圆点
    iconScrell:setTag(10)
    iconScrell.currentX = iconScrell:getPositionX()                 --增加当前x坐标属性，用于移动动画时用
    iconScrell.indexPositionX = r*3                                 --增加移动偏移量属性，用于移动动画时用
    parent:reorderChild(iconScrell, 2)
  end

  local function createItem(rows,cols,page,file,parent)             --创建关卡Sprite,rows、cols第一页的行列数，page一共多少页，file纹理图，parent父节点
    --local nodeCliping = display.newBatchNode(file):addTo(parent)    --用batchNode装载Sprite
    local nodeCliping = display.newNode():addTo(parent) 
    nodeCliping:setTag(20)
    nodeCliping.currentX = 0
    local lSprite = display.newSprite(file)
    local size = lSprite:getContentSize()                           --获取纹理尺寸
    lSprite = nil
    CCLuaLog(string.format('w=%g,h=%g',size.width,size.height))
    local sizeParent = parent:getContentSize()                      --获取父节点尺寸
    CCLuaLog(string.format('sizeParent w=%g,sizeParent h=%g',sizeParent.width,sizeParent.height))
    --CCLuaLog(string.format('parent x=%g,parent y=%g',parent:getPositionX(),parent:getPositionX()))

    local dx = sizeParent.width/cols                                --根据父节点尺寸，行列数计算第一格的长宽
    local dy = sizeParent.height/rows
    local parentX = parent:getPositionX()
    local parentY = parent:getPositionY()

    local n = 1
    local menu = CCMenu:create():addTo(nodeCliping)
    menu:pos(40,100)
    for p=1,page do
      local dpx = display.width * (p-1)                             --第一页坐标相差一个display.width
      for row=1,rows do
        for col=1,cols do
          x = 40 + dx/2 + dx*(col-1) + dpx                          --要创建的当前Sprite，x,y坐标
          y = 100 + (rows-row)*dy + dy/2                            --40,100为创建newClippingRegionNode时的x,y坐标
          --local sprite = display.newSprite(file, x, y):addTo(nodeCliping)
          local sprite = display.newSprite(file)
          local sprite2 = display.newSprite('CloseSelected.png')
          local itemSprite = CCMenuItemSprite:create(sprite,sprite2,nil)
          itemSprite:pos(x-40,y-100)
          itemSprite:addNodeEventListener(cc.MENU_ITEM_CLICKED_EVENT, function(n)
                --if sound then audio.playSound(sound) end
                onClicked(n)
            end)
          menu:addChild(itemSprite,2,n)

          local params = {
            size = 24,
            text = n,
            x = x,
            y = y - size.height,
            align = ui.TEXT_ALIGN_CENTER,
          }
          local mlabe = ui.newTTFLabel(params):addTo(nodeCliping)
          n = n +1
        end
      end
    end
  end

  createItem(4,4,5,"CloseNormal.png",itemLayer)                     --创建4*4，5页的关卡Sprite
  createCircle(5,10,iconLayer)                                      --创建5个圆点表示页，半径10


end

function onClicked(tag)
	--if(tag == 1) then print('bt is onClick',tag) end
  print('bt is onClick',tag)

end

local startX
local layer
local icon
local index = 1                 --表示当前所处的页面
function onTouch(event)
  if not layer then
    layer = display.getRunningScene():getChildByTag(3):getChildByTag(20)
  end
  if not icon then
    icon = display.getRunningScene():getChildByTag(2):getChildByTag(10)
  end
  if event.name == 'began' then
    CCLuaLog('onTouch began')
    startX = event.x
    return true
  elseif event.name == 'moved' then
    local dx = event.x - event.prevX
    local dy = event.y - event.prevY
    local x = layer:getPositionX()
    --local y = layer:getPositionY()
    --layer:pos(x+dx, y+dy)
    layer:setPositionX(x+dx)
  elseif event.name =='ended' then
    dx = event.x - startX
    if dx > display.width/2 and index-1>0 then                      --触点偏移量大于display.width/2触发移动下一页动画
      index=index-1
      layer.currentX = layer.currentX + display.width
      icon.currentX = icon.currentX - icon.indexPositionX
    elseif dx < -display.width/2 and index+1<6 then
      index = index+1
      layer.currentX = layer.currentX - display.width
      icon.currentX = icon.currentX + icon.indexPositionX
    end
      transition.moveTo(layer,{x=layer.currentX,time=0.2})          --
      transition.moveTo(icon,{x=icon.currentX,time=0.2})
      --layer:setPositionX(layer.currentX)
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