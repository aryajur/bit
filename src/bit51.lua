local bit = {}	
-- No bit operations found so create them

-- The following bit operations code extracted from LuaBit (http://luaforge.net/projects/bit/)
local function check_int(n)
	-- checking not float
	if(n - math.floor(n) > 0) then
		error("Number has no integer representation")
	end
end

local function to_bits(n)
	check_int(n)
	if(n < 0) then
		-- negative
		return to_bits(bit.bnot(math.abs(n)) + 1)
	end
	-- to bits table (convert to binary number)
	local tbl = {}
	local cnt = 1
	while (n > 0) do
		local last = math.mod(n,2)
		if(last == 1) then
			tbl[cnt] = 1
		else
			tbl[cnt] = 0
		end
		n = (n-last)/2
		cnt = cnt + 1
	end

	return tbl
end

-- Function to convert the binary representation back to the number
local function tbl_to_number(tbl)
	local n = #tbl

	local rslt = 0
	local power = 1
	for i = 1, n do
		rslt = rslt + tbl[i]*power
		power = power*2
	end

	return rslt
end

local function expand(tbl_m, tbl_n)
	local big = {}
	local small = {}
	if(#tbl_m > #tbl_n) then
		big = tbl_m
		small = tbl_n
	else
		big = tbl_n
		small = tbl_m
	end
	-- expand small
	for i = #small + 1, #big do
		small[i] = 0
	end
end

local function bit_or(m, n)
	local tbl_m = to_bits(m)
	local tbl_n = to_bits(n)
	expand(tbl_m, tbl_n)

	local tbl = {}
	local rslt = math.max(#tbl_m, #tbl_n)
	for i = 1, rslt do
		if(tbl_m[i]== 0 and tbl_n[i] == 0) then
			tbl[i] = 0
		else
			tbl[i] = 1
		end
	end

	return tbl_to_number(tbl)
end

local function bit_and(m, n)
	local tbl_m = to_bits(m)
	local tbl_n = to_bits(n)
	expand(tbl_m, tbl_n) 

	local tbl = {}
	local rslt = math.max(#tbl_m, #tbl_n)
	for i = 1, rslt do
		if(tbl_m[i]== 0 or tbl_n[i] == 0) then
			tbl[i] = 0
		else
			tbl[i] = 1
		end
	end

	return tbl_to_number(tbl)
end

local function bit_not(n)

	local tbl = to_bits(n)
	local size = math.max(#tbl, 32)
	for i = 1, size do
		if(tbl[i] == 1) then 
			tbl[i] = 0
		else
			tbl[i] = 1
		end
	end
	return tbl_to_number(tbl)
end

local function bit_xor(m, n)
	local tbl_m = to_bits(m)
	local tbl_n = to_bits(n)
	expand(tbl_m, tbl_n) 

	local tbl = {}
	local rslt = math.max(#tbl_m, #tbl_n)
	for i = 1, rslt do
		if(tbl_m[i] ~= tbl_n[i]) then
			tbl[i] = 1
		else
			tbl[i] = 0
		end
	end

	return tbl_to_number(tbl)
end

local function bit_rshift(n, bits)
	check_int(n)

	local high_bit = 0
	if(n < 0) then
		-- negative
		n = bit_not(math.abs(n)) + 1
		high_bit = 2147483648 -- 0x80000000
	end

	for i=1, bits do
		n = n/2
		n = bit_or(math.floor(n), high_bit)
	end
	return math.floor(n)
end

-- logic rightshift assures zero filling shift
local function bit_logic_rshift(n, bits)
	check_int(n)
	if(n < 0) then
		-- negative
		n = bit_not(math.abs(n)) + 1
	end
	for i=1, bits do
		n = n/2
	end
	return math.floor(n)
end

local function bit_lshift(n, bits)
	check_int(n)

	if(n < 0) then
		-- negative
		n = bit_not(math.abs(n)) + 1
	end

	for i=1, bits do
		n = n*2
	end
	return bit_and(n, 4294967295) -- 0xFFFFFFFF
end

local function bit_lrotate(n,bits)
  bits = bit_and(bits, 31)
  n = bit_and(a,0xFFFFFFFF)
  n = bit_or(bit_lshift(n ,bits), bit_logic_rshift(n, (32 - bits)))
  return bit_and(n , 0xFFFFFFFF	)
end

local function bit_rrotate(n,bits)
	 return bit_lrotate(n, -bits)
end

local function bit_bor (x, y, z, ...)
	if not z then
		return bit_and(bit_or((x or 0) , (y or 0)) , 0xFFFFFFFF)
	else
		local arg = {...}
		local res = bit_or(x,bit_or( y , z))
		for i = 1, #arg do res = bit_or(res , arg[i]) end
		return bit_and(res , 0xFFFFFFFF)
	end
end

local function bit_bxor (x, y, z, ...)
	if not z then
		return bit_and(bit_xor((x or 0) , (y or 0)) , 0xFFFFFFFF)
	else
		local arg = {...}
		local res = bit_xor(x,bit_xor( y , z))
		for i = 1, #arg do res = bit_xor(res, arg[i]) end
		return bit_and(res , 0xFFFFFFFF)
	end
end

local function bit_band (x, y, z, ...)
  if not z then
	return bit_and(bit_and((x or -1) , (y or -1)) , 0xFFFFFFFF)
  else
	local arg = {...}
	local res = bit_and(x , bit_and(y , z))
	for i = 1, #arg do res = bit_and(res , arg[i]) end
	return bit_and(res , 0xFFFFFFFF)
  end
end

local function bit_test (...)
  return bit_band(...) ~= 0
end


bit.band = bit_band
bit.bor = bit_bor
bit.bxor = bit_bxor
bit.rol = bit_lrotate
bit.ror = bit_rrotate
bit.arshift = bit_rshift
bit.rshift = bit_logic_rshift
bit.lshift = bit_lshift
bit.btest = bit_test
bit.bnot = bit_not

return bit
