------------------------------------------------------------------------------
-- Perceptio stimuli module for recording of all the stimuli.
-- @release Perceptio (C) 2011-2012 University of York
-- Please see LICENSE for details of the BSD license.
------------------------------------------------------------------------------

local setmetatable = setmetatable
local pairs = pairs
local ipairs = ipairs
local table_ = table
local io = io
local wx = require("wx")
module("perceptio.stimulus")

local set = function (list)
	local ret = {}
	for _, l in ipairs(list) do ret[l] = true end
	return ret 
end

function new(filename, inf)
    info = info or {}
    return {filename = filename, iinfo = inf, _info = {}, itables = {},
            tables = {}, info = info, table = table, validate = validate,
            write = write, data = {}}
end

function info(stimulus, key, value)
    local found = false
    for _, k in ipairs(stimulus.iinfo) do
        if k == key then
            found = true
            break
        end
    end
    if not found then
        table_.insert(stimulus.iinfo, key)
    end
    stimulus._info[key] = value
end

function table(stimulus, name, keys)
    table_.insert(stimulus.itables, name)
    local t = {keys = keys, data = {},
        entry = function (table, e)
            local overwrite = false
            for i,k in ipairs(table.data) do
                if k[1] == e[1] then
                    table.data[i] = e
                    overwrite = true
                end
            end
            if not overwrite then
                table_.insert(table.data, e or {})
            end
        end}
    stimulus.tables[name] = t
    return t
end

function validate(stimulus)
    -- format {experiment,keys,1={k=v,..}}
    -- for each stimulus 
    for i, v in ipairs(stimulus.data) do
        -- check each key k in stimulus entry
        for k, _ in pairs(v) do
            if not stimulus.keys[k] then
                return false, "Invalid stimulus key "..k.." in "..filename
            end
        end
        -- check each key k that should be there
        for k, _ in pairs(stimulus.keys) do
            if not v[k] then
                return false, "Can't find stimulus key "..k.." in "..filename
            end
        end
        for _, k in ipairs(stimulus.iinfo) do
            if stimulus._info[key] == nil then
                return false, "Can't find info key "..k.." in "..filename
            end
        end
    end
    
    for k, _ in pairs(stimulus._info) do
        local found = false
        for _, l in ipairs(stimulus.iinfo) do
            if k == l then
                found = true
                break
            end
        end
        if not found then
            return false, "Invalid info key "..k.." in "..filename
        end
    end

    return true, "Success"
end

function write(stimulus)
    local f = io.open(stimulus.filename, "a+")
    for i, k in ipairs(stimulus.iinfo) do
        f:write(k, "\t", stimulus._info[k], "\n")
    end
    f:write("\n")
    for l, t in ipairs(stimulus.itables) do
        f:write(t, "\n")
        for i, k in ipairs(stimulus.tables[t].keys) do
            if i == 1 then
                f:write(k)
            else
                f:write("\t", k)
            end
        end
        f:write("\n\n")
        for i, e in ipairs(stimulus.tables[t].data) do
            for j, k in ipairs(e) do
                if j == 1 then
                    f:write(k)
                else
                    f:write("\t", k)
                end
            end
            f:write("\n")
        end
    end
    f:close()
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })
-- vim: expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
