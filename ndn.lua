-- should be able to parse strings like 4d6, 1d8+2, 2d4-2, -1d6

return function(dice_str)
	-- parse using regular expressions
	local die_sign, die_count, die_value, mod_sign, mod_value = 
		string.match(dice_str, "^(%-?)(%d)d(%d)([%+%-]?)(%d?)$")

	if die_count == nil or die_value == nil then
		error("invalid dice string: " .. dice_str)
	end

	-- simplify for min/max calculations
	die_count = die_sign == "-" and -die_count or die_count
	die_value = die_value
	mod_value = mod_sign == "" and 0 or mod_sign == "-" and -mod_value or mod_value

	-- calculate min and max values
	local min = mod_value + die_count
	local max = mod_value + die_count * die_value
	if max < min then max, min = min, max end
	
	-- private state
	local self = {
		min = min,
		max = max,
	}	

	-- public interface
	local ndn = { 
		roll = function() 
			return math.random(self.min, self.max) 
		end 
	}
	
	-- add __tostring function for debug purposes
	-- if no argument provided, call roll() from the public interface
	setmetatable(ndn, {
		__call = ndn.roll,
		__tostring = function() return dice_str end,
	})

	return ndn
end
