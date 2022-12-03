
local scoreMap = {
    ["X"] = 1, -- For part one
    ["Y"] = 2,
    ["Z"] = 3,

    ["A"] = 1, -- For part two
    ["B"] = 2,
    ["C"] = 3,
}

local winMap = {
    ["A"] = "Y",
    ["B"] = "Z",
    ["C"] = "X",
}

local loseMap = {
    ["A"] = "Z",
    ["B"] = "X",
    ["C"] = "Y",
}

local function getScore(input)
    local totalScore = 0
    for _, v in pairs(input) do
        local openent = string.sub(v, 1, 1)
        local response = string.sub(v, 3)
        totalScore += scoreMap[response]
        totalScore += if winMap[openent] == response then 6 elseif loseMap[openent] == response then 0 else 3
    end
    return totalScore
end

local function getFairScore(input)
    local totalScore = 0
    for _, v in pairs(input) do
        local openent = string.sub(v, 1, 1)
        local winState = string.sub(v, 3)

        local response = if winState == "X" then loseMap[openent] elseif winState == "Y" then openent else winMap[openent]
        totalScore += if winState == "X" then 0 elseif winState == "Y" then 3 else 6
        totalScore += scoreMap[response]
    end
    return totalScore
end

local input = require("input")
print(getScore(input))
print(getFairScore(input))