# ndn

*ndn* is a miniature library for using D&D-style dice rolls in a game.

The library can be used as such:

```lua
-- import library from project directory
local ndn = require "path.to.ndn"

-- create 3 dice types
local dice_types = {
	ndn("4d6+1"), 
	ndn("-2d4+5"), 
	ndn("1d6"),
}

-- lets roll each dice pair multiple times
local rolls = 10

-- roll each die n times; print values, print average
for _, dice in ipairs(dice_types) do
	print(dice)
	local avg = 0
	for i = 1, 1000 do
		local v = dice() -- lets roll
		avg = avg + v
		print("v: " .. v)
	end
	print("avg: " .. avg / rolls)
end
```
