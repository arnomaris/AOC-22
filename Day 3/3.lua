local function getCharWeight(char: string)
    return if char == char:lower() then char:byte() - 96 else char:byte() - 38
end

local function findWrongItems(input: table)
    local total = 0
    for _, v in pairs(input) do
        local len = #v
        for i = 1, len/2 do
            local char = v:sub(i, i)
            if v:find(char, len/2 + 1) then
                total += getCharWeight(char)
                break
            end
        end
    end
    return total
end

local function findGroupItems(input: table)
    local total = 0
    for i = 1, #input - 2, 3 do
        local v = input[i]
        local str2 = input[i + 1]
        local str3 = input[i + 2]
        for s in v:gmatch(".") do
            if str2:find(s) and str3:find(s) then
                total += getCharWeight(s)
                break
            end
        end
    end
    return total
end

local input = require("input")
print(findWrongItems(input))
print(findGroupItems(input))