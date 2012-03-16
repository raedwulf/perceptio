------------------------------------------------------------------------------
-- Perceptio combobox module for providing access to combobox control.
-- @release Perceptio (C) 2011-2012 University of York
-- Please see LICENSE for details of the BSD license.
------------------------------------------------------------------------------

local setmetatable = setmetatable
local ipairs = ipairs
local wx = require("wx")
local control = require("perceptio.control")
module("perceptio.combobox")

function new(args, panel)
    local ret = control(args,{getValue = getValue, setValue = setValue, getLabels = getLabels})
    args.width = args.width or wx.wxDefaultSize:GetWidth()
    args.height = args.height or wx.wxDefaultSize:GetHeight()
    args.labels = args.labels or {"None selected"}
    args.value = args.value or false
    args.id = args.id or wx.wxID_ANY
    args.style = args.style or 0
    args.fontsize = args.fontsize or 12

    ret.wx = wx.wxComboBox(panel, args.id, args.labels[1], wx.wxDefaultPosition,
                           wx.wxSize(args.width, args.height), args.labels,
                           wx.wxCB_DROPDOWN + wx.wxCB_READONLY)
    ret.wx:SetFont(wx.wxFont(args.fontsize, wx.wxDEFAULT, wx.wxNORMAL, wx.wxNORMAL))
    ret.event = args.event
    ret.panel = panel
    return ret
end

function getValue(self)
    return self.wx:GetValue()
end

function setValue(self, value)
    self.wx:SetValue(value)
end

function getLabels(self)
    return self.labels
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })
-- vim: expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
