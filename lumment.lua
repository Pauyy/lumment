
content = io.popen("dir /b /a-d")
for line in content:lines() do
	print(line)
end
content:close()

comments = loadfile("main.lua")("test.java")

for k,v in ipairs(comments) do
 print(v)
 end