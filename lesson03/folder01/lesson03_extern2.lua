print('...............................')
print(arg[-1],arg[0])
local object = {}
object.name = 'lesson03_extern2'

function object:getName()
	return self.name
end

function object:setName(name)	
	self.name = name
end
return object
