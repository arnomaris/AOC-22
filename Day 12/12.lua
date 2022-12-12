local function makeGrid(input: string)
    local grid = {}
    local sx, sy = nil, nil
    local i = 1
    for line in string.gmatch(input, "([^\n]*)\n?") do
        if line == "" then continue end
        grid[i] = {}
        local j = 1
        for v in string.gmatch(line, ".") do
            if v == "S" then
                sy = i
                sx = j
            end
            if v == "S" or v == "E" then
                grid[i][j] = v
            else
                grid[i][j] = string.byte(v) - 96
            end
            j += 1
        end
        i += 1
    end
    return grid, sx, sy
end

local function findPath(grid: table, startX: number, startY: number)
    local queue = {q = {}}
    local closedSet = {}

    function queue:push(x: number, y: number, path: string, height: number|string, previousX: number, previousY: number)
        table.insert(self.q, {x = x, y = y, path = path, height = height, previousX = previousX, previousY = previousY})
        if not closedSet[y] then closedSet[y] = {} end
        closedSet[y][x] = true
    end

    function queue:pop()
        if #self.q < 1 then return nil end
        local shortest = self.q[1]
        local index = 1
        for i, v in pairs(self.q) do
            if type(v) == table then
                if #v.path < #shortest.path then
                    shortest = v
                    index = i
                end
            end
        end
        table.remove(self.q, index)
        return shortest
    end

    queue:push(startX, startY, "", 1, nil, nil)

    local function expand(selected: table, x: number, y: number)
        if grid[y][x] == "S" then return end
        if closedSet[y] and closedSet[y][x] then return end
        local height = if grid[y][x] == "E" then 26 elseif grid[y][x] == "S" then 1 else grid[y][x]
        local selectedHeight = if selected.height == "E" then 26 elseif selected.height == "S" then 1 else selected.height
        if height - selectedHeight > 1 then return end
        queue:push(x, y, selected.path .. "X", grid[y][x], selected.x, selected.y)
    end

    local solution = nil

    while #queue.q > 0 do
        local selected = queue:pop()
        if selected.height == "E" then
            solution = #selected.path
            break
        end
        for i = -1, 1 do
            if i == 0 then continue end
            if grid[selected.y][selected.x + i] then
                expand(selected, selected.x + i, selected.y)
            end
        end
        for j = -1, 1 do
            if j == 0 then continue end
            if grid[selected.y + j] then
                expand(selected, selected.x, selected.y + j)
            end
        end
    end
    return solution
end

local grid, startX, startY = makeGrid(require('input')[1])
local foundPath = findPath(grid, startX, startY)
print(foundPath)

do
    local shortest = foundPath
    for j, v in pairs(grid) do
        for i, k in pairs(v) do
            local path = findPath(grid, i, j)
            if path and path < shortest then
                shortest = path
            end
        end
    end
    print(shortest)
end