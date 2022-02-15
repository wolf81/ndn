io.stdout:setvbuf('no') -- show debug output live in SublimeText console

local ndn = require "ndn"

-- create 3 dice types
local dice_types = {
    ndn("4d6+1"), 
    ndn("-2d4+5"), 
    ndn("1d6"),
    ndn("2d6"),
    ndn("3d6"),
}

-- lets roll each dice pair multiple times
local rolls = 10000

print("\n\n")

-- roll each die n times; print values, print average
for _, dice in ipairs(dice_types) do
    local min, max = dice.range()
    print(tostring(dice) .. " (" .. min .. " ... " .. max .. ")")
    local avg = 0
    local values = {}
    for i = 1, rolls do
        local v = dice() -- lets roll
        avg = avg + v
        if values[v] == nil then values[v] = 0 end
        values[v] = values[v] + 1
    end
    print("\navg: " .. avg / rolls)

    for i, v in pairs(values) do
        print(i, v)
    end
    print()
end

function love.load( ... )
	print("love")
end