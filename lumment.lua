local complete = {}
local base_path = ""
--TODO Fix
function scan_directory(path)
	local directories = io.popen(string.format("dir %s /b /ad", path))
	for directoriename in directories:lines() do
		scan_directory(path .. "/" .. directoriename)
	end
	directories:close()
	local files = io.popen(string.format("dir %s *.java* *.h* /b /a-d", path))
	for filename in files:lines() do
		print(filename)
		table.insert(complete, dofile("main.lua")(path .. "/" .. filename))
	end
	files:close()
end

scan_directory(base_path)

for k,v in ipairs(complete) do
 print(v)
 end