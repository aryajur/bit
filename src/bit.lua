bit = {}

-- Lua 5.3 has built-in bit operators, wrap them in a function.
if _VERSION == "Lua 5.3" then
	function bit.bnot (a)
	  return ~a & 0xFFFFFFFF
	end


	--
	-- in all vararg functions, avoid creating 'arg' table when there are
	-- only 2 (or less) parameters, as 2 parameters is the common case
	--


	function bit.bor (x, y, z, ...)
	  if not z then
		return ((x or 0) | (y or 0)) & 0xFFFFFFFF
	  else
		local arg = {...}
		local res = x | y | z
		for i = 1, #arg do res = res | arg[i] end
		return res & 0xFFFFFFFF
	  end
	end

	function bit.bxor (x, y, z, ...)
	  if not z then
		return ((x or 0) ~ (y or 0)) & 0xFFFFFFFF
	  else
		local arg = {...}
		local res = x ~ y ~ z
		for i = 1, #arg do res = res ~ arg[i] end
		return res & 0xFFFFFFFF
	  end
	end

	function bit.btest (...)
	  return bit.band(...) ~= 0
	end

	function bit.lshift (a, b)
	  return ((a & 0xFFFFFFFF) << b) & 0xFFFFFFFF
	end

	function bit.rshift (a, b)
	  return ((a & 0xFFFFFFFF) >> b) & 0xFFFFFFFF
	end

	function bit.arshift (a, b)
	  a = a & 0xFFFFFFFF
	  if b <= 0 or (a & 0x80000000) == 0 then
		return (a >> b) & 0xFFFFFFFF
	  else
		return ((a >> b) | ~(0xFFFFFFFF >> b)) & 0xFFFFFFFF
	  end
	end

	function bit.rol (a ,b)
	  b = b & 31
	  a = a & 0xFFFFFFFF
	  a = (a << b) | (a >> (32 - b))
	  return a & 0xFFFFFFFF
	end

	function bit.ror (a, b)
	  return bit.rol(a, -b)
	end
	
	function bit.band (x, y, z, ...)
	  if not z then
		return ((x or -1) & (y or -1)) & 0xFFFFFFFF
	  else
		local arg = {...}
		local res = x & y & z
		for i = 1, #arg do res = res & arg[i] end
		return res & 0xFFFFFFFF
	  end
	end
	return bit
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

return bit