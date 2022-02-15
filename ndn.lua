-- should be able to parse strings like 4d6, 1d8+2, 2d4-2, -1d6

return function(dice_str)
	-- parse using regular expressions
	local die_sign, die_count, die_value, mod_sign, mod_value = 
		string.match(dice_str, "^(%-?)(%d)d(%d)([%+%-]?)(%d?)$")

	if die_count == nil or die_value == nil then
		error("invalid dice string: " .. dice_str)
	end

	-- simplify for min/max calculations
	die_sign = die_sign == "-" and -1 or 1
	die_value = die_value
	mod_value = mod_sign == "" and 0 or mod_sign == "-" and -mod_value or mod_value

	-- calculate min and max values
	local min = mod_value + die_sign * die_count
	local max = mod_value + die_sign * die_count * die_value
	if max < min then max, min = min, max end
	
	-- private state
	local self = {
		die_sign = die_sign,
		die_count = die_count,
		die_value = die_value,
		mod_value = mod_value,

		range = { min, max },
	}	

	roll = function() 
		local v = self.mod_value

		if self.die_count == 0 then return v end

		for i = 1, self.die_count do
			v = v + math.random(self.die_value)
		end

		return v
	end

	range = function()
		return unpack(self.range)
	end

	local ndn = {
		roll = roll,
		range = range,		
	}
	
	-- add __tostring function for debug purposes
	-- if no argument provided, call roll() from the public interface
	setmetatable(ndn, {
		__call = roll,
		__tostring = function() return dice_str end,
	})

	return ndn
end
