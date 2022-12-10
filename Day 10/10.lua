
local function calculateRegisters(input: string)
    local cycle = 1
    local register = 1
    local getLine = string.gmatch(input, "([^\n]*)\n?")
    local currentLine = getLine()
    local total = 0
    local image = "\n#"

    local function calclateSignal()
        if (cycle - 20) % 40 == 0 then
            print(cycle, register)
            total += register * cycle
        end
        image = if math.abs(((cycle -1) % 40) - register) <= 1 then image .. "#" else image .. "."
        if cycle % 40 == 0 then
            image = image .. "\n"
        end
    end

    while currentLine ~= "" do
        if currentLine == "noop" then
            cycle += 1
            calclateSignal()
            currentLine = getLine()
            continue
        else
            local intsructionValue = string.match(currentLine, "-?%d+")
            if not intsructionValue then continue end
            for i = 1, 2 do
                cycle += 1
                if i == 2 then
                    register += intsructionValue
                end
                calclateSignal()
            end
            currentLine = getLine()
        end
    end
    return total, image
end

print(calculateRegisters(require("input")[1]))