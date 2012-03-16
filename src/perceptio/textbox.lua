------------------------------------------------------------------------------
-- Perceptio textbox module for providing access to textbox control.
-- @release Perceptio (C) 2011-2012 University of York
-- Please see LICENSE for details of the BSD license.
------------------------------------------------------------------------------

local setmetatable = setmetatable
local wx = require("wx")
local control = require("perceptio.control")
module("perceptio.textbox")

function new(args, panel)
    local ret = control(args,{changeValue = changeValue, getValue = getValue})
    args.width = args.width or wx.wxDefaultSize:GetWidth()
    args.height = args.height or wx.wxDefaultSize:GetHeight()
    args.label = args.label or "No Label"
    args.value = args.value or ""
    args.id = args.id or wx.wxID_ANY
    args.fontsize = args.fontsize or 12
    args.multiline = args.multiline or false
    
    local is_multiline = 0
    if args.multiline then
        is_multiline = wx.wxTE_MULTILINE
    end
    
    ret.wx = wx.wxTextCtrl(panel, args.id, args.value,
                             wx.wxDefaultPosition,
                             wx.wxSize(args.width, args.height),
                             wx.wxTE_LEFT + wx.wxTE_BESTWRAP + is_multiline)
    ret.wx:SetFont(wx.wxFont(args.fontsize, wx.wxDEFAULT, wx.wxNORMAL, wx.wxNORMAL))
    panel:Connect(args.id, wx.wxEVT_COMMAND_TEXT_UPDATED,
        function(event)
            if args.event ~= nil then
                args.event(ret)
            end
            event:Skip()
        end)
    panel:Connect(args.id, wx.wxEVT_COMMAND_TEXT_ENTER,
        function(event)
            if args.enterEvent ~= nil then
                args.enterEvent(ret)
            end
            event:Skip()
        end)
    return ret
end

function changeValue(self, text)
    self.wx:ChangeValue(text)
end
function getValue(self)
    return self.wx:GetValue()
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })
-- vim: expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
