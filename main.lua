io.stdout:setvbuf('no') -- show debug output live in SublimeText console

local ndn = require "ndn"

-- run app with LÖVE - press "g" to generate a new random set of dice and roll 

local function generate()
    local n_rolls = 10000

    local die_count_min, die_count_max = -5, 5
    local die_types = { 4, 6, 8, 12 }
    local die_mod_min, die_mod_max = -15, 15

    local d1 = math.random(die_count_min, die_count_max)
    local d2 = die_types[math.random(1, #die_types)]
    local die_string = d1 .. "d" .. d2

    if math.random(2) == 1 then
        local d3 = math.random(die_mod_min, die_mod_max)
        die_string = die_string .. (d3 >= 0 and "+" or "") .. d3
    end

    local dice = ndn(die_string)

    local min, max = dice.range()
    print("dice: " .. tostring(dice))
    print("\nrange: (" .. min .. " ... " .. max .. ")")
    local avg = 0
    local values = {}

    for i = min, max do
        values[i] = 0
    end

    for i = 1, n_rolls do
        local v = dice() -- lets roll
        avg = avg + v
        local success, err = pcall(function()
            values[v] = values[v] + 1
        end)
        if not success then
            error("failed with value: " .. v)
        end
    end

    print("\nv", "%")

    for i = min, max do
        local v = values[i] / n_rolls * 100
        print(i, v)
    end

    print("\naverage: " .. avg / n_rolls)

    print("\n------\n")
end

function love.load( ... )
    love.window.setTitle("ndn")

    generate()
end

function love.keypressed(key, code)
    if key == "g" then
        generate()
    end
end