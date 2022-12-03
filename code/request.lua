local function uriToFilename(uri)
   --return  string.sub(uri, 3, -1)..'.lc'
   return  string.sub(uri, 2, -1);
end

local function hex_to_char(x)
  return string.char(tonumber(x, 16))
end

local function uri_decode(input)
  return input:gsub("%+", " "):gsub("%%(%x%x)", hex_to_char)
end

local function parseArgs(args)
   local r = {}
   local i = 1
   if args == nil or args == "" then return r end
   for arg in string.gmatch(args, "([^&]+)") do
      local name, value = string.match(arg, "(.*)=(.*)")
      if name ~= nil then r[name] = uri_decode(value) end
      i = i + 1
   end
   i = nil
   collectgarbage()
   return r
end

local function parseUri(uri)
   local r = {}
   if uri == nil then return r end
   if uri == "/" then uri = "/index.html" end
   local questionMarkPos, b, c, d, e, f = uri:find("?")
   if questionMarkPos == nil then
      r.file = uri:sub(1, questionMarkPos)
      r.args = {}
   else
      r.file = uri:sub(1, questionMarkPos - 1)
      r.args = parseArgs(uri:sub(questionMarkPos+1, #uri))
   end
   r.file = uriToFilename(r.file)
   return r
end


-- Parses the client's request. Returns a dictionary containing pretty much everything
-- the server needs to know about the uri.
return function (uri)
   local r = parseUri(uri)
   return r
end
