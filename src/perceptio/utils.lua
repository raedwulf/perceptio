------------------------------------------------------------------------------
-- Perceptio utility module for providing useful functions
-- @release Perceptio (C) 2011-2012 University of York
-- Please see LICENSE for details of the BSD license.
------------------------------------------------------------------------------

local setmetatable = setmetatable
local pairs = pairs
local table = table
local string = string
local io = require("io")
local wx = require("wx")
module("perceptio.utils")

function exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function cwd()
    return wx.wxGetCwd()
end

-- Used to escape "'s by toCSV
function escapeCSV (s)
  if string.find(s, '[,"]') then
    s = '"' .. string.gsub(s, '"', '""') .. '"'
  end
  return s
end

-- Convert from table to CSV string
function toCSV (tt)
  local s = ""
  for _,p in pairs(tt) do
    s = s .. "," .. escapeCSV(p)
  end
  return string.sub(s, 2)      -- remove first comma
end

-- Convert from CSV string to table
function fromCSV (s)
  s = s .. ','        -- ending comma
  local t = {}        -- table to collect fields
  local fieldstart = 1
  repeat
    -- next field is quoted? (start with `"'?)
    if string.find(s, '^"', fieldstart) then
      local a, c
      local i  = fieldstart
      repeat
        -- find closing quote
        a, i, c = string.find(s, '"("?)', i+1)
      until c ~= '"'    -- quote not followed by quote?
      if not i then error('unmatched "') end
      local f = string.sub(s, fieldstart+1, i-1)
      table.insert(t, (string.gsub(f, '""', '"')))
      fieldstart = string.find(s, ',', i) + 1
    else                -- unquoted; find next comma
      local nexti = string.find(s, ',', fieldstart)
      table.insert(t, string.sub(s, fieldstart, nexti-1))
      fieldstart = nexti + 1
    end
  until fieldstart > string.len(s)
  return t
end

-- vim: expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
