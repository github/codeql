-- This file generates the header map files used by this test.
-- (it is provided in case the maps need to be changed)

local function hash(str)
  local n = 0
  for c in str:lower():gmatch"." do
    n = n + c:byte()*13
  end
  return n
end

local function write_map(filename, endian, mapping)
  local num_entries = 0
  local max_value_length = 0
  for k, v in pairs(mapping) do
    num_entries = num_entries + 1
    max_value_length = math.max(max_value_length, #v)
  end
  local num_buckets = 2^math.ceil(math.log(num_entries + 1)/math.log(2))
  local f = io.open(filename, "wb")
  local function write_uint32(val)
    local b0 = (val % 256); val = (val - b0) / 256
    local b1 = (val % 256); val = (val - b1) / 256
    local b2 = (val % 256); val = (val - b2) / 256
    local b3 = (val % 256);
    if endian == "little" then
      f:write(string.char(b0, b1, b2, b3))
    elseif endian == "big" then
      f:write(string.char(b3, b2, b1, b0))
    else
      error(("Expected endian of %q or %q, got %q"):format("little", "big", endian))
    end
  end
  if endian == "little" then
    f:write("pamh\1\0")
  else
    f:write("hmap\0\1")
  end
  f:write("\0\0")
  write_uint32(6*4 + num_buckets*12)
  write_uint32(num_entries)
  write_uint32(num_buckets)
  write_uint32(max_value_length)
  
  local string_pieces = {"\0"}
  local string_piece_length = 1
  local encode = setmetatable({}, {__index = function(cache, str)
    local result = string_piece_length
    cache[str] = result
    str = str .."\0"
    string_pieces[#string_pieces + 1] = str
    string_piece_length = string_piece_length + #str
    return result
  end})
  local buckets = {}
  for k, v in pairs(mapping) do
    local i = hash(k) % num_buckets
    while buckets[i] do
      i = (i + 1) % num_buckets
    end
    local v1, v2 = v:match"(.*/)([^/]*)$"
    buckets[i] = {encode[k], encode[v1], encode[v2]}
  end
  
  for i = 0, num_buckets-1 do
    for _, v in ipairs(buckets[i] or {0, 0, 0}) do
      write_uint32(v)
    end
  end
  f:write(table.unpack(string_pieces))
  
  f:close()
end

-- for langtests:
--local root = "semmlecode-cpp-tests/header-variant-tests/headermaps/"
-- for qltest:
local root = "./"
write_map("little.hmap", "little", {
  ["a.h"] = root .."1.h",
  ["B.h"] = root .."2.h",
  ["c.H"] = root .."3.h",
  ["D.H"] = root .."4.h",
})
write_map("big.hmap", "big", {
  ["e.h"] = root .."5.h",
  ["F.h"] = root .."6.h",
  ["g.H"] = root .."7.h",
  ["H.H"] = root .."8.h",
})
