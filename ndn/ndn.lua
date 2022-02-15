-- should be able to parse strings like 4d6, 1d8+2, 2d4-2, -1d6

return function(die_str)
	-- parse using regular expressions
	local die_sign, die_count, die_value, mod_sign, mod_value = 
		string.match(die_str, "^(%-?)(%d+)d(%d+)([%+%-]?)(%d*)$")

	if die_count == nil or die_value == nil then
		error("invalid dice string: " .. die_str)
	end

	-- simplify for min/max calculations
	die_sign = die_sign == "-" and -1 or 1
	mod_value = mod_sign == "" and 0 or mod_sign == "-" and -mod_value or mod_value

	-- calculate the minimum base value of all the dice
	local die_base = mod_value
	if die_sign == -1 then
		die_base = die_base - die_count * die_value - 1
	end

	-- calculate min and max values
	local min = mod_value + die_sign * die_count
	local max = mod_value + die_sign * die_count * die_value
	if max < min then max, min = min, max end

	-- calculate min and max values of a single die roll
	local die_min = 1 * die_sign
	local die_max = die_value * die_sign
	if die_max < die_min then die_min, die_max = die_max, die_min end
	
	-- private state
	local self = {
		die_count = die_count,
		die_min = die_min,
		die_max = die_max,
		die_mod = mod_value,
		range = { min, max },
	}	

	-- roll the dice
	local roll = function() 
		local v = self.die_mod

		for i = 1, self.die_count do
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
