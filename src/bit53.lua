-- bit operations library for Lua 5.3
local bit = {}
	
do
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