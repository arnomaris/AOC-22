
local function getRanges(input: table): table
    local ranges = {}
    for _, s in input do
        local range = {}
        for v in string.gmatch(s, "%d*-%d*") do
            local num1 = string.match(v, "%d*")
            local num2 = string.sub(v, 2 + #num1, #v)
            table.insert(range, {tonumber(num1), tonumber(num2)})
        end
        table.insert(ranges, range)
    end
    return ranges
end

local function countContained(ranges: table): number
    local count = 0
    for _, range in ranges do
        if (range[1][1] >= range[2][1] and range[1][2] <= range[2][2])
            or (range[2][1] >= range[1][1] and range[2][2] <= range[1][2]) then
            count += 1
        end
    end
    return count
end

local function countOverlap(ranges: table): number
    local count = 0
    for _, range in ranges do
        if math.max(range[1][1], range[2][1]) <= math.min(range[1][2], range[2][2]) then
            count += 1
        end
    end
    return count
end

local input = require("input")
local ranges = getRanges(input)
print(countContained(ranges))
print(countOverlap(ranges))