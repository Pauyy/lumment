
local file_name = arg[1] or "test.java"
local file = assert(io.open(file_name, "r"))

local text = file:read("*all")
file:close()

local flags = {}
flags.clear = function() for k,v in pairs(flags) do if k ~= "clear" then flags[k] = false end end end
flags.comment = false
flags.comment_multi_line = false
flags.comment_single_line = false
flags.string = false
flags.star = false
flags.slash = false

local comment = {}
comment.clear = function() for k, v in ipairs(comment) do comment[k] = nil end end
local comments= {}

local last_character
local character
local i = 1

function handleCommentTypes(c, lc)
	--print("check", c, flags.star, flags.slash, flags.comment_multi_line, flags.comment_single_line)
	if flags.comment_single_line then --we are in a single line comment
		if c:find('%c') then --if the single line comment contains a \n or \r it finished
			flags.clear()
			table.insert(comments, table.concat(comment))
			--print("Singleline inserted")
			comment.clear()
			character = nil
		else
			table.insert(comment, c)
		end
	elseif flags.comment_multi_line then --we are in a multiline comment
		if c == "*" then flags.star = true 
		elseif flags.star and c == "/" then
			flags.clear()
			table.insert(comments, table.concat(comment))
			--print("Multiline inserted")
			comment.clear()
			character = nil
		else
			table.insert(comment, c)
		end
	end
	if c:find("%S") and c ~= "*" and c ~= "/"  then
		flags.star = false
		flags.slash = false
	end
end

for i= 1, #text do
	last_character = character
	character = text:sub(i,i)
	if flags.comment then
		handleCommentTypes(character, last_character)
		
	--check if comment or something starts
	elseif last_character == "/" and character == "/" then
		flags.comment_single_line = true
		flags.comment = true
	elseif character == "/" then --set that a multiline comment could start
		if not flags.string then flags.slash = true end
	elseif flags.slash and character == "*" then --multiline comment starts
		flags.comment_multi_line = true
		flags.comment = true
		flags.slash = false
	elseif character == '"' then --string starts
		flags.string = not flags.string
	elseif character:find('%S') then --current character is not a whitespace if there was a slash before it cannot start a multiline comment anymore
		flags.slash = false
		flags.star = false
	
	end
end

for k,v in ipairs(comments) do
	print(k,v)
end

