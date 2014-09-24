print('... lua01 ...')
require('var')
--[[
package.path:设置lua的搜索路径，默认路径：
	D:\lua-5.2.3_Win32_bin\lua\?.lua;D:\lua-5.2.3_Win32_bin\lua\?\init.lua;D:\lua-5.2.3_Win32_bin\?.lua;D:\lua-5.2.3_Win32_bin\?\init.lua;.\?.lua
增加搜索路径(路径间用';'做分隔)：
	package.path .. ';..\\Test01\\?.lua'
]]
print('package.path=' .. package.path)
package.path = package.path .. ';..\\Test01\\?.lua'
print('new package.path=' .. package.path)
require('lua02') 										--lua01 require了var.lua，再其下面require的lua02.lua可以直接在里面引用var.lua里的变量，不用显示再require 'var.lua'

print('... lua01.lua end! ...')

table1 = {1,2,3,4,5}
table2 = {6,7,8,9,0}
tmp = {}
tmp.__add = function (op1,op2)
	for k,v in pairs(op2) do
		table.insert(op1,k,v) 				--第两个参数是要插入的位置，不要key值，结果是 6 7 8 9 0 1 2 3 4 5，key值非数字会报错，如table4
		--table.insert(op1,#op1+1,v)				--结果: 1 2 3 4 5 6 7 8 9 0
	end
	return op1
end
setmetatable(table1, tmp)
table3 = table1 + table2
for k,v in pairs(table3) do
	print(v)
end
--[[
-- error
tabe4 = {a=6,b=7,c=8,d=9,e=9,f=0}
table5 = table1 + table4
for k,v in pairs(table5) do
	print(v)
end
--]]

s = table.concat(table1,'\t',4,9)  			--将table的内容连接，第二个参数为连接的分隔符，后面两个为起止位置
print(s)

print('... .......... ...')
for k,v in pairs(package) do
	print(k,v)
end

print('... .......... ...')
for k,v in pairs(package.searchers) do
	print(k,v)
end