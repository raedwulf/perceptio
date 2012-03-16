------------------------------------------------------------------------------
-- Perceptio control module for providing common routines for each control
-- @release Perceptio (C) 2011-2012 University of York
-- Please see LICENSE for details of the BSD license.
------------------------------------------------------------------------------

local setmetatable = setmetatable
local wx = require("wx")
module("perceptio.control")

function new(args, control)
    control.name = args.name
    control.type = args.type
    if control.enable == nil then
        control.enable = function(self) self.wx:Enable(true) end
    end
    if control.disable == nil then
        control.disable = function(self) self.wx:Disable() end
    end
    if control.show == nil then
        control.show = function(self) self.wx:Show(true) end
    end
    if control.hide == nil then
        control.hide = function(self) self.wx:Hide() end
    end
    if control.getLabel == nil then
        control.getLabel = function(self) return self.wx:GetLabel() end
    end
    if control.setLabel == nil then
        control.setLabel = function(self, text) self.wx.SetLabel(text) end
    end

    return control
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })
-- vim: expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
