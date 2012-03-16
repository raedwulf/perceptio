------------------------------------------------------------------------------
-- Perceptio slider module for providing access to slider control.
-- @release Perceptio (C) 2011-2012 University of York
-- Please see LICENSE for details of the BSD license.
------------------------------------------------------------------------------

local setmetatable = setmetatable
local wx = require("wx")
local control = require("perceptio.control")
module("perceptio.slider")

function new(args, panel)
    local ret = control(args,{changeValue = changeValue, getValue = getValue})
    args.width = args.width or wx.wxDefaultSize:GetWidth()
    args.height = args.height or wx.wxDefaultSize:GetHeight()
    args.label = args.label or "No Label"
    args.value = args.value or ""
    args.min = args.min or 0
    args.max = args.max or 100
    args.id = args.id or wx.wxID_ANY
    args.style = args.style or ""
    args.fontsize = args.fontsize or 12

    local style = wx.wxSL_HORIZONTAL
    
    args.style:gsub(".", function(c)
        if c == "h" then val = val + wx.wxSL_HORIZONTAL end
        if c == "v" then val = val + wx.wxSL_AUTOTICKS end
        if c == "a" then val = val + wx.wxSL_LABELS end
        if c == "l" then val = val + wx.wxSL_LEFT end
        if c == "r" then val = val + wx.wxSL_RIGHT end
        if c == "t" then val = val + wx.wxSL_TOP end
        if c == "b" then val = val + wx.wxSL_BOTTOM end
        if c == "i" then val = val + wx.wxSL_INVERSE end
    end)
    
    ret.wx = wx.wxSlider(panel, args.id, args.value, args.min, args.max,
                         wx.wxDefaultPosition,
                         wx.wxSize(args.width, args.height), style)
    ret.wx:SetFont(wx.wxFont(args.fontsize, wx.wxDEFAULT, wx.wxNORMAL, wx.wxNORMAL))
                         
    panel:Connect(args.id, wx.wxEVT_SCROLL,
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
