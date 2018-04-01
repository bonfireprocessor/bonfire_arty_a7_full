require "pack"
bit32=require "bit32" -- from luarocks

local LOAD_BASE=0x010000

local f=assert(io.open(arg[1]..".bin","rb"))
local data = f:read("*a")
f:close()
local size=#data


local nPages=math.floor(size/4096)
if (size % 4096)>0 then
  nPages=nPages+1
end

-- brk_address= ((uint32_t)LOAD_BASE + recv_bytes + 4096) & 0x0fffffffc;
local brk_address= bit32.band(LOAD_BASE+size+4096, 0xfffffffc)

print(string.format("Filling header with nPages=%d, brkAddress=%x",nPages,brk_address))

local header=string.pack("<I<I<I",0x55aaddbb,nPages,brk_address)
header=header..string.rep("\0",4096-#header)
print(#header) -- debug only

local fw=assert(io.open(arg[1]..".img","wb"))
fw:write(header,data)
fw:close()
print(string.format("%d Bytes written",#header+#data))


