print('...............................')

print(arg[-1],arg[0])
table1 = {}
setmetatable(table1,{__index={a=1,b=2,c=3,d=4}})
print(table1.a)
table2 = {}
table1.__index = table1
setmetatable(table2,table1)		--table1也需要设置一下__index，否则table2.b返回nil
print(table2.b)

print(type(setmetatable({},table1)))

t = (setmetatable({},table1))	--setmetable有返回值，返回为set后的table
print(t.c)

print(string.sub('123456789',2,-5))		--裁剪字符串，获取第2个参数到第二个参数间的所有字符串，包含第一个与最后一个
print(string.sub('123456789',2,20))		--超出部分自动去除
print(string.sub('123456789',1,1))	