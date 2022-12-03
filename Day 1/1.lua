
local function getSums(input: table)
    local sums = {}
    local i = 1
    for _, v in pairs(input) do
        if v == "" then
            i += 1
        else
            sums[i] = if sums[i] == nil then tonumber(v) else sums[i] + tonumber(v)
        end
    end
    return sums
end

local sums = getSums(require("input"))
table.sort(sums, function(a,b) return a > b end)
print(sums[1])
print(sums[1] + sums[2] + sums[3])