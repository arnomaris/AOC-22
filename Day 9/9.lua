
local function updateTail(xH: number, yH: number, xT: number, yT: number)
    if (xH ~= xT and yH ~= yT) and (math.abs(xH - xT) > 1 or math.abs(yH - yT) > 1) then -- diagonal
        xT += if xH - xT > 0 then 1 else -1
        yT += if yH - yT > 0 then 1 else -1
    elseif math.abs(xH - xT) > 1 then
        xT += if xH - xT > 0 then 1 else -1
    elseif math.abs(yH - yT) > 1 then
        yT += if yH - yT > 0 then 1 else -1
    end
    return xT, yT
end

local function tailVisited(input: string, amountOfTails: number): table
    local visited = {}
    local xH, yH = 0, 0
    local tails = {}
    for _ = 1, amountOfTails do
        table.insert(tails, {xT = 0, yT = 0})
    end
    for line in string.gmatch(input, "([^\n]*)\n?") do
        local direction, steps = string.match(line, "^([%w%a]+) (.*)")
        if direction then
            for _ = 1, steps do
                if direction == "L" or direction == "R" then
                    xH += if direction == "R" then 1 else -1
                elseif direction == "U" or direction == "D" then
                    yH += if direction == "U" then 1 else -1
                end
                for i, v in ipairs(tails) do
                    if i == 1 then
                        v.xT, v.yT = updateTail(xH, yH, v.xT, v.yT)
                    else
                        v.xT, v.yT = updateTail(tails[i - 1].xT, tails[i - 1].yT, v.xT, v.yT)
                    end
                end
                visited[tails[amountOfTails].xT .. "/" .. tails[amountOfTails].yT] = true
            end
        end
    end
    return visited
end

local function count(t: table): number
    local i = 0
    for _ in t do
        i += 1
    end
    return i
end

local input = require('input')[1]
print(count(tailVisited(input, 1)))
print(count(tailVisited(input, 9)))