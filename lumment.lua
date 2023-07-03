local complete = {}

local _, last_slash = arg[0]:find("^.*\\")
local relative_path = arg[0]:sub(1, last_slash or 0)

local base_path = arg[1] or os.getenv("PWD") or io.popen("cd"):read()

local find_comment = assert(loadfile(relative_path .. "main.lua"))

function scan_directory(path, i)
	local directories = io.popen(string.format("dir %s /b /ad-h 2>nul", path))
	for directoriename in directories:lines() do
		--print("directory",i, directoriename)
		scan_directory(path .. "\\" .. directoriename, i+1)
	end
	directories:close()
	local files = io.popen(string.format('dir %s /b /a-d-h 2>nul | findstr /l ".java .c .h"', path))
	for filename in files:lines() do
		--print("file",i, path, filename, path .. "\\" .. filename)
		table.insert(complete, find_comment(path .. "\\" .. filename))
	end
	files:close()
end
local i = 0
scan_directory(base_path, i)

for k,v in ipairs(complete) do
	if type(v) == 'table' then
		for k,v in ipairs(v) do
			print((v:gsub("%c","\\n")))
		end
	end
end
