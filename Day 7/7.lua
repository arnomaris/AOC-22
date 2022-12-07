
local function addSize(dir:table, size: number)
    dir.Size += size
    if dir.Parent then
        addSize(dir.Parent, size)
    end
end

local function getDirSizes(input: string)
    local directory = {Parent = nil, Size = 0, Children = {}}
    local currentDirectory = directory

    for line in string.gmatch(input, "([^\n]*)\n?") do
        local newDirectory = string.match(line, "%$ cd (.+)")
        local size = string.match(line, "^([%w%d]+) (.*)")
        if newDirectory then
            if newDirectory == ".." then
                currentDirectory = currentDirectory.Parent
            else
                if not currentDirectory.Children[newDirectory] then
                    currentDirectory.Children[newDirectory] = {Parent = currentDirectory, Size = 0, Children = {}}
                end
                currentDirectory = currentDirectory.Children[newDirectory]
            end
        elseif size and size ~= "dir" then
            addSize(currentDirectory, tonumber(size))
        end
    end
    return directory
end

local function getDirectoriesWithMaxSize(directory: table, size: number)
    local total = 0
    for _, v in pairs(directory.Children) do
        if v.Size <= size then
            total += v.Size
        end
        total += getDirectoriesWithMaxSize(v, size)
    end
    return total
end

local function insert(t: table, l: table)
    for _, v in pairs(l) do
        table.insert(t, v)
    end
end

local function getSmallestSize(directory: table, required: number)
    local smallest = math.huge
    local children = {}
    insert(children, directory.Children)
    while #children > 0 do
        local v = table.remove(children, 1)
        if v.Size < smallest and v.Size >= required then
            smallest = v.Size
        end
        insert(children, v.Children)
    end
    return smallest
end

local fileStructure = getDirSizes(require("input")[1])
print(getDirectoriesWithMaxSize(fileStructure, 100000))
print(getSmallestSize(fileStructure, 30000000 - (70000000 - fileStructure.Size)))