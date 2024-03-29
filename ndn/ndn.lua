local mrandom, mabs, mfloor = love.math.random or math.random, math.abs, math.floor

--[[

We want to parse strings like: d20, 4d6, -2d6, 12d4+12, -2d12-5

We use the following regex pattern: 
	^(%-?%d*)d(%d+)([%+%-]?%d*)$

^:				anchor at start of line
(%-?%d*):		match optional '-' followed by 0+ digits in first capture group
d:				match d character
(%d+):			match 1 or more digits in second capture group
([%+%-]?%d*):	match optional '-' or '+' followed by 0+ digits in third capure group
$:				anchor at end of line

The above pattern isn't perfect but it's good enough to filter out most invalid 
strings. Additional edge cases are handled by validating each capture group.
--]] 

return function(die_str)
	-- parse using regular expressions
	local die_count, die_value, die_mod = 
		string.match(die_str, "^(%-?%d*)d(%d+)([%+%-]?%d*)$")

	-- filter out any invalid capture groups
	if die_count == nil or die_value == nil or die_mod == "-" or die_mod == "+" then
		error("invalid die string: " .. die_str)
	end

	-- if die_str is like -d4, then assume -1d4
	if die_count == '-' then die_count = -1 end

	-- cast to number, since the sign makes these values default to string
	die_count = die_count and tonumber(die_count) or 1
	die_mod = die_mod and tonumber(die_mod) or 0

	-- calculate min and max values so we can return the range of the numbers
	local min = die_count + die_mod
	local max = die_count * die_value + die_mod
	if max < min then max, min = min, max end

	-- calculate min and max values for a single die roll
	local factor = die_count < 0 and -1 or 1
	local die_min = factor
	local die_max = factor * die_value 
	if die_max < die_min then die_min, die_max = die_max, die_min end

	local average = mfloor((min + max) / 2)

	-- private state
	local self = {
		die_count = die_count,
		die_min = die_min,
		die_max = die_max,
		die_mod = die_mod,
		average = average,
		range = { min, max },
	}	

	-- roll the dice
	local roll = function() 
		local v = self.die_mod

		for i = 1, mabs(self.die_count) do
			v = v + mrandom(self.die_min, self.die_max)
		end

		return v
	end

	-- the public interface
	local dice = {
		-- perform a roll
		roll = roll,
		-- return minimum and maximum values of a roll
		range = function() return unpack(self.range) end,	
		-- return the average value of any roll
		average = function() return self.average end,
		-- return the minimum possible value of any roll
		min = function() return self.range[1] end,
		-- return the maximum possible value of any roll
		max = function() return self.range[2] end,
		-- return the number of hit dice
		count = function() return self.die_count end,
	}
	
	-- add __tostring function for debug purposes
	-- if no function provided, call roll() from the public interface
	setmetatable(dice, {
		__call = roll,
		__tostring = function() return die_str end,
	})

	return dice
end
