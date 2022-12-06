local function findSequence(str: string, length: number)
    local seq = ""
    local startIndex = 1
    for v in string.gmatch(str, ".") do
        local i = string.find(seq, v)
        if i then
            seq = string.sub(seq, i + 1)
        end
        seq = seq .. v
        if #seq >= length then
            return startIndex
        end
        startIndex += 1
    end
end

local input = require("input")[1]
print(findSequence(input, 4))
print(findSequence(input, 14))