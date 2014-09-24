MyObject = {}
MyObject.name	= 'chizhaoliu'
MyObject.arg	= 28
MyObject.height	= 160
function MyObject:getName ()
	return self.name
	end
function MyObject:setName(name)
	self.name = name
	end
function MyObject:setArg(arg)
	self.arg = arg
	end	
MyObject.__index = MyObject

MyNewObject = {}
setmetatable(MyNewObject,MyObject)
print(MyNewObject.name)
MyNewObject.setName(MyNewObject,'czl')
print(MyNewObject:getName())
MyNewObject:setArg(18)
print(MyNewObject.arg)