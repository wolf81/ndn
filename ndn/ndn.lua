-- should be able to parse strings like 4d6, 1d8+2, 2d4-2, -1d6

return function(die_str)
-- ^(%-?%d*)d(%d*)([+|-]%d*)?$
	-- parse using regular expressions
	local die_count, die_value, mod_sign, die_mod = 
		string.match(die_str, "^(%-?%d+)d(%d+)([%+%-]?)(%d*)$")

	-- cast to number, since due to included sign it will default to a string
	die_count = tonumber(die_count)

	print(die_str, die_count, die_value, mod_sign, die_mod)

	if die_count == nil or die_value == nil then
		error("invalid dice string: " .. die_str)
	end

	-- simplify for min/max calculations
	die_mod = mod_sign == "" and 0 or mod_sign == "-" and -die_mod or die_mod

	-- calculate the minimum base value of all the dice
	local die_base = die_mod

	-- calculate min and max values
	local min = die_count + die_mod
	local max = die_count * die_value + die_mod
	if max < min then max, min = min, max end

	-- calculate min and max values of a single die roll
	local factor = die_count < 0 and -1 or 1
	local die_min = factor
	local die_max = factor * die_value 
	if die_max < die_min then die_min, die_max = die_max, die_min end

	-- private state
	local self = {
		die_count = die_count,
		die_min = die_min,
		die_max = die_max,
		die_mod = die_mod,
		range = { min, max },
	}	

	-- roll the dice
	local roll = function() 
		local v = self.die_mod

		for i = 1, math.abs(self.die_count) do
			v = v + math.random(self.die_min, self.die_max)
		end

		return v
	end

	-- return minimum and maximum values of a roll
	local range = function()
		return unpack(self.range)
	end

	-- the public interface
	local ndn = {
		roll = roll,
		range = range,		
	}
	
	-- add __tostring function for debug purposes
	-- if no function provided, call roll() from the public interface
	setmetatable(ndn, {
		__call = roll,
		__tostring = function() return die_str end,
	})

	return ndn
end
