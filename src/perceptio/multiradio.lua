------------------------------------------------------------------------------
-- Perceptio multiradio module for providing access to radiobutton controls.
-- @release Perceptio (C) 2011-2012 University of York
-- Please see LICENSE for details of the BSD license.
------------------------------------------------------------------------------

local setmetatable = setmetatable
local ipairs = ipairs
local wx = require("wx")
local control = require("perceptio.control")
module("perceptio.multiradio")

function new(args, panel)
    local ret = control(args,{getValue = getValue, setValue = setValue,
                              getLabels = getLabels,
                              setLabels = setLabels})
    args.width = args.width or wx.wxDefaultSize:GetWidth()
    args.height = args.height or wx.wxDefaultSize:GetHeight()
    args.labels = args.labels or {"No Label"}
    args.value = args.value or false
    args.id = args.id or wx.wxID_ANY
    args.style = args.style or 0
    args.fontsize = args.fontsize or 12

    ret.wx = wx.wxBoxSizer(wx.wxHORIZONTAL)
    style = wx.wxRB_GROUP

    ret.fontsize = args.fontsize
    ret.event = args.event
    ret.firstIndex = args.id
    ret.panel = panel
    ret.dummy = args.dummy
    ret.radioButtons = {}
    setLabels(ret, args.labels)
    args.id = args.id + 10
    return ret
end

function getValue(self)
    for i, r in ipairs(self.radioButtons) do
        if r:GetValue() then
            return r:GetLabel()
        end
    end
    return "None"
end

function setValue(self, value)
    for i, r in ipairs(self.radioButtons) do
        if r:GetLabel() == value then
            r:SetValue(true)
            break
        end
    end
end

function getLabels(self)
    ret = {}
    j = 1
    for i in 1, self.lastIndex-self.lastIndex+1 do
        ret[i] = self.radioButtons[i]:GetLabel()
    end
    return ret
end

function setLabels(self, labels)
    local id = self.firstIndex
    if self.lastIndex ~= nil then
        for i in self.lastindex-self.lastIndex+1 do
            self.wx:Remove(self.radioButtons[i])
        end
    end
    self.radioButtons = {}
    for i, l in ipairs(labels) do
        self.radioButtons[i] = wx.wxRadioButton(self.panel, id, l,
                                               wx.wxDefaultPosition,
                                               wx.wxDefaultSize,
                                               style)
        self.radioButtons[i]:SetFont(wx.wxFont(self.fontsize, wx.wxDEFAULT, wx.wxNORMAL, wx.wxNORMAL))
        if self.dummy == l then
            self.radioButtons[i]:Hide()
        else
            self.wx:Add(self.radioButtons[i], 0, wx.wxALIGN_LEFT +
                       wx.wxALIGN_CENTRE_VERTICAL + wx.wxEXPAND + 
                       wx.wxLEFT + wx.wxRIGHT)
            self.panel:Connect(id, wx.wxEVT_COMMAND_RADIOBUTTON_SELECTED,
                function(event)
                    if self.event ~= nil then
                        self.event(self)
                    end
                    event:Skip()
                end)
        end
        id = id + 1
        style = 0
    end
    self.lastIndex = self.firstIndex + #labels - 1
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })
-- vim: expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
