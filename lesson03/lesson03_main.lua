print('...............................')
print(arg[-1],arg[0])
arg[-1] = 'arg -1'
arg[0] = 'lesson03_extern'
local str = require('lesson03_extern')		--采用require引入其它Lua文件时，不需要带扩展名，同时将带入参数arg[-1],arg[0]，如果引入的文件带返回值，可直接做为require的返回值
print(str)

print('...............................')
local obj = require('folder01.lesson03_extern2')		--可以带路径，用'.'语法
print(obj:getName())
print(obj:setName('czl'))
print(obj:getName())