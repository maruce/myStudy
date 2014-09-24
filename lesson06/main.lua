--[[
edtVar,用local引用了var.lua里的myVar，
并增加了version元素，
实则是全局myVar也增加了version
]]

require 'var'
require 'edtVar' 		--require是全局引入，edtVar不用在里面再显示require 'var'

print(myVar.name)
print(myVar.version)