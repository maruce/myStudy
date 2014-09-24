local m = myVar or nil
if not m then
	print('m is nil')
	m = {}
else
	print('m = myVar')
end
m.version = '1.0.0'