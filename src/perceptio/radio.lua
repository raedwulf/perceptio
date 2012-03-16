------------------------------------------------------------------------------
-- Perceptio radio module for providing access to radiobutton control.
-- @release Perceptio (C) 2011-2012 University of York
-- Please see LICENSE for details of the BSD license.
------------------------------------------------------------------------------

local setmetatable = setmetatable
local wx = require("wx")
local control = require("perceptio.control")
module("perceptio.radio")

function new(args, panel)
    local ret = control(args,{setValue = setValue, getValue = getValue})
    args.width = args.width or wx.wxDefaultSize:GetWidth()
    args.height = args.height or wx.wxDefaultSize:GetHeight()
    args.label = args.label or "No Label"
    args.id = args.id or wx.wxID_ANY
    args.style = args.style or 0
    args.fontsize = args.fontsize or 12
    
    ret.wx = wx.wxRadioButton(panel, args.id, args.label,
                             wx.wxDefaultPosition,
                             wx.wxSize(args.width, args.height))
    ret.wx:SetFont(wx.wxFont(args.fontsize, wx.wxDEFAULT, wx.wxNORMAL, wx.wxNORMAL))
    panel:Connect(args.id, wx.wxEVT_COMMAND_RADIOBUTTON_SELECTED,
        function(event)
            if args.event ~= nil then
                args.event(ret)
            end
            event:Skip()
        end)
    return ret
end

function setValue(self, value)
    self.wx:SetValue(value)
end
function getValue(self)
    return self.wx:GetValue()
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })
-- vim: expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
