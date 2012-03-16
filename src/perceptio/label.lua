------------------------------------------------------------------------------
-- Perceptio label module for providing access to label control.
-- @release Perceptio (C) 2011-2012 University of York
-- Please see LICENSE for details of the BSD license.
------------------------------------------------------------------------------

local setmetatable = setmetatable
local wx = require("wx")
local control = require("perceptio.control")
module("perceptio.label")

function new(args, panel)
    local ret = control(args,{setLabel = setLabel, getLabel = getLabel})
    args.width = args.width or wx.wxDefaultSize:GetWidth()
    args.height = args.height or wx.wxDefaultSize:GetHeight()
    args.label = args.label or "No Label"
    args.id = args.id or wx.wxID_ANY
    args.wrap = args.wrap or true
    args.fontsize = args.fontsize or 12
    ret.wx = wx.wxStaticText(panel, args.id, args.label,
                             wx.wxDefaultPosition,
                             wx.wxSize(args.width, args.height))
    ret.wx:SetFont(wx.wxFont(args.fontsize, wx.wxDEFAULT, wx.wxNORMAL, wx.wxNORMAL))
    if args.wrap then
        ret.wx:Wrap(args.width)
    end
    return ret
end

function setLabel(self, label)
    self.wx:SetLabel(label)
    --self.wx:SetText(label)
end
function getLabel(self)
    return self.wx:GetLabel()
    --return self.wx:GetText(label)
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })
-- vim: expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
