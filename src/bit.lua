if _VERSION < "Lua 5.2" then
	return require("bit.bit51")
end

-- Lua 5.3 has built-in bit operators, wrap them in a function.
if _VERSION >= "Lua 5.3" then
	return require("bit.bit53")
end
-- The "bit32" library shipped with lua 5.2
local has_bit32, bit32 = pcall(require, "bit32")
if has_bit32 then
	return {
		band = bit32.band;
		bor = bit32.bor;
		bxor = bit32.bxor;
		rol = bit32.lrotate,
		ror = bit32.rrotate,
		arshift = bit32.arshift,
		rshift = bit32.rshift,
		lshift = bit32.lshift,
		btest = bit32.btest,
		bnot = bit32.bnot
	}
end

