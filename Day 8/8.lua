-- this is code is not ideal at all, but it works :P
-- normally i would clean it up but dont really have time for that at the moment
local function getTreeMap(input: string)
    local map = {}
    local i = 1
    for line in string.gmatch(input, "([^\n]*)\n?") do
        if line ~= "" then
            map[i] = {}
            for s in string.gmatch(line, ".") do
                table.insert(map[i], s)
            end
        end
        i += 1
    end
    return map
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

local function evaluateAxis(treeMap: table, visibleTrees: table, axis: number) -- this is very ugly but it works :)
    if axis == 1 or axis == -1 then -- x-axis
        for i = 1, #treeMap do
            local treeLine = treeMap[i]
            local startIndex = axis == 1 and 1 or #treeLine
            local endIndex = axis == 1 and #treeLine or 1
            local increment = axis == 1 and 1 or -1
            local highest = treeLine[startIndex]
            visibleTrees[i][startIndex] = true
            for j = startIndex, endIndex, increment do
                if treeLine[j] > highest then
                    highest = treeLine[j]
                    visibleTrees[i][j] = true
                else break
                end
            end
        end
    elseif axis == 2 or axis == -2 then -- y-axis
        for j = 1, #treeMap[1] do
            local startIndex = axis == 2 and 1 or #treeMap
            local endIndex = axis == 2 and #treeMap or 1
            local increment = axis == 2 and 1 or -1
            local highest = treeMap[startIndex][j]
            visibleTrees[startIndex][j] = true
            for i = startIndex, endIndex, increment do
                if treeMap[i][j] > highest then
                    highest = treeMap[i][j]
                    visibleTrees[i][j] = true
                else break
                end
            end
        end
    end
end

local function getVisibleTrees(treeMap: table)
    local visibleTrees = deepCopy(treeMap)
    evaluateAxis(treeMap, visibleTrees, 1)
    evaluateAxis(treeMap, visibleTrees, -1)
    evaluateAxis(treeMap, visibleTrees, 2)
    evaluateAxis(treeMap, visibleTrees, -2)
    return visibleTrees
end

local function countVisibleTrees(visibleTrees: table) -- Part 1
    local count = 0
    for i = 1, #visibleTrees do
        local treeLine = visibleTrees[i]
        for j = 1, #treeLine do
            if treeLine[j] == true then count += 1 end
        end
    end
    return count
end

local function getDistance(treeMap: table, yIndex: number, xIndex: number) -- i really couldnt be bothred to make this a nice function ://
    local distance = 1
    local height = treeMap[yIndex][xIndex]
    local axisDistance = 0
    if xIndex + 1 < #treeMap[yIndex] then
        for j = xIndex + 1, #treeMap[yIndex] do
            if treeMap[yIndex][j] < height then
                axisDistance += 1
            else
                axisDistance += 1
                break
            end
        end
    end
    distance *= axisDistance > 0 and axisDistance or 1
    axisDistance = 0
    if xIndex - 1 > 0 then
        for j = xIndex - 1, 1, -1 do
            if treeMap[yIndex][j] < height then
                axisDistance += 1
            else
                axisDistance += 1
                break
            end
        end
    end
    distance *= axisDistance > 0 and axisDistance or 1
    axisDistance = 0
    if yIndex + 1 < #treeMap then
        for i = yIndex + 1, #treeMap do
            if treeMap[i][xIndex] < height then
                axisDistance += 1
            else
                axisDistance += 1
                break
            end
        end
    end
    distance *= axisDistance > 0 and axisDistance or 1
    axisDistance = 0
    if yIndex - 1 > 0 then
        for i = yIndex - 1, 1, -1 do
            if treeMap[i][xIndex] < height then
                axisDistance += 1
            else
                axisDistance += 1
                break
            end
        end
    end
    distance *= axisDistance > 0 and axisDistance or 1
    return distance
end

local function getScenicScores(treeMap: table) -- Part 2
    local highestScore = 0
    for i, treeLine in pairs(treeMap) do
        for j, _ in pairs(treeLine) do
            local distance = getDistance(treeMap, i, j)
            if distance > highestScore then highestScore = distance end
        end
    end
    return highestScore
end

local treeMap = getTreeMap(require("input")[1])
local visibleTrees = getVisibleTrees(treeMap)
print(countVisibleTrees(visibleTrees))
print(getScenicScores(treeMap))