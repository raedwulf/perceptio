------------------------------------------------------------------------------
-- Perceptio module for loading into perceptio experiments.
-- @release Perceptio (C) 2011-2012 University of York
-- Please see LICENSE for details of the BSD license.
------------------------------------------------------------------------------

-- load the wxlua module
package.cpath = package.cpath..";./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"
local wx = require("wx")
local screen = require("perceptio.screen")
local stimulus = require("perceptio.stimulus")
local utils = require("perceptio.utils")
module("perceptio")

-- Globals
allScreens = {}

-- Locals
local frame = nil
local currentScreen = 1

-- IDs
ID_FRAME = 1000

--- Initialise the experiment
-- It takes two parameters, a title and a description to create a new maximised
-- window for the experiment.
-- @param title The title/name of the experiment.
-- @param description The description of the experiment.
-- @param fontsize The font size
function init(title, description, fontsize, closeevent)
    fontsize = fontsize or 12
    frame = wx.wxFrame(wx.NULL, ID_FRAME, title, wx.wxPoint(0,0), wx.wxDefaultSize, wx.wxCAPTION + wx.wxRESIZE_BORDER + wx.wxCLIP_CHILDREN + wx.wxMAXIMIZE + wx.wxSTAY_ON_TOP)
    frame:SetFont(wx.wxFont(fontsize, wx.wxDEFAULT, wx.wxNORMAL, wx.wxNORMAL))
    frame:Connect(ID_FRAME, wx.wxEVT_SIZE,
        function(event)
            local w, h = frame:GetClientSizeWH()
            --print(w)
            event:Skip()
        end)
    frame:Connect(ID_FRAME, wx.wxEVT_CLOSE_WINDOW,
        function(event)
            event:Skip()
            if closeevent then
                closeevent()
            end
        end)
    mainSizer = wx.wxBoxSizer(wx.wxVERTICAL)
    screen.init(frame, mainSizer)
    return true
end

--- Run a set of screens
-- @param screens The screens to run.
function run(screens)
    -- we need this in global vars
    allScreens = screens
    -- load the first screen
    currentScreen = 1
    local panel = screens[1].panel
    mainSizer:Add(panel, 1, wx.wxEXPAND + wx.wxALL + wx.wxALIGN_CENTRE)
    panel:Show(true)
    -- sizer it up
    frame:SetAutoLayout(true)
    frame:SetSizer(mainSizer)
    --mainSizer:SetSizeHints(frame)
    --mainSizer:Fit(frame)
    -- Makesure the mainSizer has the right layout
    mainSizer:Layout()
    -- start the application
    wx.wxGetApp():SetTopWindow(frame)
    frame:Show(true)
    -- start the wxWidgets event loop
    wx.wxGetApp():MainLoop()
end

--- Go to a particular screen
-- @param num The screen number to switch to from current screen.
function goto(num)
    if allScreens[num] ~= nil then
        local panel = allScreens[currentScreen].panel
        mainSizer:Detach(panel)
        panel:Show(false)
        panel = allScreens[num].panel
        panel:Show(true)
        mainSizer:Add(panel, 1, wx.wxEXPAND + wx.wxALL + wx.wxALIGN_CENTRE)
        mainSizer:Layout()
        currentScreen = num
    else
        -- TODO: Error gracefully
    end
end

--- Close the window and exit the program
function quit()
    -- TODO: All the recording state needs to be finalised
    frame:Close()
end

-- vim: expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
