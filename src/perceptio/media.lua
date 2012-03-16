------------------------------------------------------------------------------
-- Perceptio media module for providing access to media control.
-- @release Perceptio (C) 2011-2012 University of York
-- Please see LICENSE for details of the BSD license.
------------------------------------------------------------------------------

local setmetatable = setmetatable
local io = require("io")
local string = require("string")
local wx = require("wx")
local utils = require("perceptio.utils")
local control = require("perceptio.control")

module("perceptio.media")

function new(args, panel)
    local ret = control(args,{play = play, stop = stop, pause = pause, seek = seek, 
                 setVolume = setVolume, getState = getState, load = load, resize = resize})
    args.width = args.width or wx.wxDefaultSize:GetWidth()
    args.height = args.height or wx.wxDefaultSize:GetHeight()
    args.label = args.label or "No Label"
    args.value = args.value or ""
    args.id = args.id or wx.wxID_ANY
    args.fontsize = args.fontsize or 12

    ret.width = args.width
    ret.height = args.height
    --if not utils.exists(args.filename) then
    --    args.filename = wx.wxGetCwd() .. "/" .. args.filename
    --    if not utils.exists(args.filename) then
    --        io.stderr:write("Cannot find " .. args.filename .. "\n")
    --        return {}
    --    end
    --end
    local f = io.open(args.filename, "r")
    if not f then
        args.filename = wx.wxGetCwd() .. "/" .. args.filename
    else
        f:close()
    end
    f = io.open(args.filename, "r")
    if f then
        f:close()
    else
        ret.filename = args.filename
    end
    ret.wx = wx.wxMediaCtrl(panel, args.id, args.filename)
    ret.wx:SetFont(wx.wxFont(args.fontsize, wx.wxDEFAULT, wx.wxNORMAL, wx.wxNORMAL))
    if args.filename then
        ret:resize()
    end
    -- make it invisible
    panel:Connect(args.id, wx.wxEVT_MEDIA_LOADED,
        function(event)
            if args.loadedEvent ~= nil then
                args.loadedEvent(ret)
            end
            event:Skip()
        end)
    
    panel:Connect(args.id, wx.wxEVT_MEDIA_STOP,
        function(event)
            if args.stopEvent ~= nil then
                args.stopEvent(ret)
            end
            event:Skip()
        end)
        
    panel:Connect(args.id, wx.wxEVT_MEDIA_STATECHANGED,
            function (event)
                if args.event ~= nil then
                    args.event(ret)
                end
                event:Skip()
            end)
    return ret
end

function resize(self)
    local size
    local bestsize = self.wx:GetBestSize()
    if self.width == nil then
        if self.height == nil then
            size = wx.wxDefaultSize
        else
            local ratio = self.height / bestsize:GetHeight()
            size = wx.wxSize(bestsize:GetWidth() * ratio, self.height)
        end
    else
        if self.height == nil then
            local ratio = self.width / bestsize:GetWidth()
            size = wx.wxSize(self.width, bestsize:GetHeight() * ratio)
        else
            size = wx.wxSize(self.width, self.height)
        end
    end
    --self.wx:SetSize(size)
end

function load(self, filename)
    local f = io.open(filename, "r")
    if not f then
        filename = wx.wxGetCwd() .. "/" .. filename
    else
        f:close()
    end
    f  = io.open(filename, "r")
    if not f then
        filename = nil
    else
        f:close()
    end
    if filename then
        self:resize()
    end
    return self.wx:Load(filename)
end

function play(self)
    return self.wx:Play()
end

function stop(self)
    return self.wx:Stop()
end

function pause(self)
    return self.wx:Pause()
end

function seek(self, offset, mode)
    return self.wx:Seek(offset, mode)
end

function setVolume(self, volume)
    return self.wx:SetVolume(volume)
end

function getState(self)
    local state = self.wx:GetState()
    if state == wx.wxMEDIASTATE_STOPPED then
        return "stopped"
    elseif state == wx.wxMEDIASTATE_PAUSED then
        return "paused"
    elseif state == wx.wxMEDIASTATE_PLAYING then
        return "playing"
    else
        return "unknown"
    end
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })
-- vim: expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
