local path_separator = package.config:sub(1,1)
assert(path_separator == "/" or path_separator == "\\", "Lua config returned a path separator that we can not handle, expected something like '/' or '\' but got " .. path_separator .. " instead")

local _, last_slash = arg[0]:find("^.*" .. path_separator)
local lumment_dir = arg[0]:sub(1, last_slash or 0)

local base_path = arg[1] or os.getenv("PWD") or io.popen("cd"):read()

local find_comment = assert(loadfile(lumment_dir .. "check_file.lua"))

local lummentignore = io.open(lumment_dir .. ".lummentignore", "r")
local ignored_folders = {}
if lummentignore then
	for line in lummentignore:lines() do
		ignored_folders[line] = true
	end
	lummentignore:close()
end

local comments = {}
function scan_directory(path, i)
	-- Collect all Directories and Recursivly chek their content
	local directories = io.popen(string.format("dir %s /b /ad-h 2>nul", path))
	for directoriename in directories:lines() do
		if not ignored_folders[directoriename] then
			scan_directory(path .. path_separator .. directoriename, i+1)
		end
	end
	directories:close()
	-- Check all Files in the current directory for comments
	local files = io.popen(string.format('dir %s /b /a-d-h 2>nul | findstr /r ".*[.]cpp$ .*[.]hpp$ .*[.]c$ .*[.]h$ .*[.]java$ .*[.]ts$ .*[.]js$"', path))
	for filename in files:lines() do
		--print("file",i, path, filename, path .. "\\" .. filename)
		table.insert(comments, find_comment(path .. path_separator .. filename))
	end
	files:close()
end
local i = 0

scan_directory(base_path, i)

for k,v in ipairs(comments) do
	if type(v) == 'table' then
		for k,v in ipairs(v) do
			print((v:gsub("%c","\\n")))
		end
	else
		print("Why was there a", type(v), "in my comment table")
	end
end
