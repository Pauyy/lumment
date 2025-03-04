local path_separator = package.config:sub(1,1)
assert(path_separator == "/" or path_separator == "\\", "Lua config returned a path separator that we can not handle, expected something like '/' or '\' but got " .. path_separator .. " instead")
local script_path = arg[0]
local _, last_slash = script_path:find("^.*" .. path_separator)
local lumment_dir = script_path:sub(1, last_slash or 0)

-- execution path
local scan_path = arg[1] or ""
if scan_path then
	-- Append path seperator to end when one is omitted
	if scan_path:sub(#scan_path, #scan_path) ~= "/" and scan_path:sub(#scan_path, #scan_path) ~= "\\" then
		scan_path = scan_path .. path_separator
	end
end

local absolute_path = os.getenv("PWD") or io.popen("cd"):read() .. path_separator ..  scan_path

local find_comment = assert(loadfile(lumment_dir .. "check_file.lua"))

local lummentignore_f = io.open(lumment_dir .. ".lummentignore", "r")
local lumment_ignore = {}
if lummentignore_f then
	for foldername in lummentignore_f:lines() do
		-- todo handle case when the ignore file has a trailing / or \
		table.insert(lumment_ignore, foldername)
	end
	lummentignore_f:close()
end

--[[
	command for linux
	ls -1R
]]

function load_windows_files(lumment_ignore, path)
	local hidden_folders = assert(io.popen(string.format('dir "%s" /ADH /B /S 2>nul', path)))
	local ignored_folders = {}
	for hf in hidden_folders:lines() do 
		table.insert(ignored_folders, hf)
	end
	hidden_folders:close()

	-- Windows does list sub files in hidden folders so we have to ignore them ourself
	local relevant_folders = assert(io.popen(string.format('dir "%s" /A-D-H /B /S 2>nul', path)))
	local files_to_check = {}
	local absolute_path_length = #path
	for rf in relevant_folders:lines() do
		local ignore = false
		for _, v in ipairs(ignored_folders) do
			if rf:find(v, 1, true) then ignore = true break end
		end
		for _, v in ipairs(lumment_ignore) do
			if rf:find(v, 1, true) then ignore = true break end
		end
		if not ignore then table.insert(files_to_check, string.sub(rf, absolute_path_length + 1)) end
	end
	relevant_folders:close()
	return files_to_check
end

local files = load_windows_files(lumment_ignore, absolute_path)

local comments = {}
local valid_file_suffix = {"c", "cpp", "h", "hpp", "java", "js", "ts"}
for _, v in ipairs(valid_file_suffix) do valid_file_suffix[v] = true end
for _, filename in ipairs(files) do
	-- perhaps insert as filename=comment_information
	local _, suffix_index = filename:find("^.*%.")
	if valid_file_suffix[filename:sub(suffix_index+1)] then
		table.insert(comments, find_comment(absolute_path .. path_separator, filename))
	end
end

for k,v in ipairs(comments) do
	if type(v) == 'table' then
		for k,v in ipairs(v) do
			print((v:gsub("%c","\\n")))
		end
	else
		print("Why was there a", type(v), "in my comment table")
	end
end
