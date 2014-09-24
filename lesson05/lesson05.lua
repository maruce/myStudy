--myScripts =  'print(\'... This is myScritps ...\')'
myScripts =  'i = 5 j=6 print(\'555\')'
l = loadstring(myScripts) 		--loadstring返回的是function
print(type(l)) 					
l()								--需要执行一下,否则print(i)打印nil
print(i,j)

dofile('extern.lua') 			--同一个文件每dofile一次就执行一次
dofile('extern.lua')
require('extern')				--同一个文件require最多只会执行一次,require不需要带扩展名
require('extern')

f = loadfile('extern.lua') 		--loadfile同loadstring，只是从文件载入，返回的是function
print(type(f)) 
f()
f()

r = io.read()
print(r)
fr = loadstring(r)
while(type(fr) == 'function') do
	fr()
	r = io.read()
	fr = loadstring(r)
end