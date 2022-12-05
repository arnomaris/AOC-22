local function parseCrane(craneInput: string): table
    local lines = {}
    craneInput = string.gsub(craneInput, "%s%s%s%s", " [ ]")
    for line in string.gmatch(craneInput, "([^\n]*)\n?") do
        local i = 1
        for char in string.gmatch(line, "%[.%]") do
            if not lines[i] then lines[i] = {} end
            if char ~= "[ ]" then
                table.insert(lines[i], string.match(char, "%a"))
            end
            i = i + 1
        end
    end
    return lines
end

local function popPush(t:table, amount: number, pop: number, push: number, multiple: boolean)
    for i = 1, amount do
        table.insert(t[push], if multiple then i else 1, table.remove(t[pop], 1))
    end
end

local function moveCrane(crane: table, instructions: table, multiple: boolean)
    for _, v in (instructions) do
        local getNum = string.gmatch(v, "%d+")
        local amount, from, to = tonumber(getNum()), tonumber(getNum()), tonumber(getNum())
        popPush(crane, amount, from, to, multiple)
    end
    local str = ""
    for _, t in (crane) do
        str = str..t[1]
    end
    return str
end

local function deepCopy(orig: table): table
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepCopy(orig_key)] = deepCopy(orig_value)
		end
		setmetatable(copy, deepCopy(getmetatable(orig)))
	else
		copy = orig
	end
	return copy
end

local crane = parseCrane(require("crane")[1])
local input = require("input")
print(moveCrane(deepCopy(crane), input, false))
print(moveCrane(deepCopy(crane), input, true))
