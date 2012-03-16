------------------------------------------------------------------------------
-- Perceptio screen module for layouting the screen with controls.
-- @release Perceptio (C) 2011-2012 University of York
-- Please see LICENSE for details of the BSD license.
------------------------------------------------------------------------------

local setmetatable = setmetatable
local wx = require("wx")
local setmetatable = setmetatable
local print = print
local pairs = pairs
local ipairs = ipairs
local type = type
local string = string
local collectgarbage = collectgarbage
local label = require("perceptio.label")
local textbox = require("perceptio.textbox")
local checkbox = require("perceptio.checkbox")
local button = require("perceptio.button")
local radio = require("perceptio.radio")
local slider = require("perceptio.slider")
local media = require("perceptio.media")
local multiradio = require("perceptio.multiradio")
local multicheckbox = require("perceptio.multicheckbox")
local combobox = require("perceptio.combobox")

module("perceptio.screen")

-- Locals
local frame = nil
local mainSizer = nil
local controlID = 1002

--- Get the sizer for string
-- Takes the name of a string and returns a sizer for it
-- @param l The type of the sizer
-- @param c The number of columns, if it is flexgrid or grid
-- @param x The x gap
-- @param y The y gap
local psizer = function(l,c,x,y)
    if c == nil then c = 2 end
    if x == nil then x = 5 end
    if y == nil then y = 5 end
    if l == "vertical" then
        return wx.wxBoxSizer(wx.wxVERTICAL)
    elseif l == "horizontal" then
        return wx.wxBoxSizer(wx.wxHORIZONTAL)
    elseif l == "grid" then
        return wx.wxGridSizer(c, x, y)
    elseif l == "flexgrid" then
        return wx.wxFlexGridSizer(0, c, x, y)
    else
        -- TODO: error check
        return nil
    end
end

--- Get the border enum value for a string
-- Takes a string about border and returns the equivalent enum value for it
-- @param s The border type string
local pbordernum = function(s)
    local val = 0
    string.gsub(s, ".", function(c)
        if c == "t" then val = val + wx.wxTOP end
        if c == "b" then val = val + wx.wxBOTTOM end
        if c == "l" then val = val + wx.wxLEFT end
        if c == "r" then val = val + wx.wxRIGHT end
        if c == "a" then val = wx.wxALL end
    end)
    return val
end

--- Get the align enum value for a string
-- Takes a string about alignment and returns the equivalent enum value for it
-- @param s The align type string
local palignnum = function(s)
    local val = 0
    s:gsub(".", function(c)
        if c == "t" then val = val + wx.wxALIGN_TOP end
        if c == "b" then val = val + wx.wxALIGN_BOTTOM end
        if c == "l" then val = val + wx.wxALIGN_LEFT end
        if c == "r" then val = val + wx.wxALIGN_RIGHT end
        if c == "c" then val = val + wx.wxALIGN_CENTRE end
        if c == "v" then val = val + wx.wxALIGN_CENTRE_VERTICAL end
        if c == "h" then val = val + wx.wxALIGN_CENTRE_HORIZONTAL end
    end)
    return val
end

--- Get the expand enum value for a string
-- Takes a string about expand and returns the equivalent enum value for it
-- @param s The expand type string
local pexpandnum = function(s)
    local val = 0
    s:gsub(".", function(c)
        if c == "e" then val = val + wx.wxEXPAND end
        if c == "s" then val = val + wx.wxSHAPED end
        if c == "f" then val = val + wx.wxFIXED_MINSIZE end
    end)
    return val
end

local paddsizer = function(sizer, ctrl, data)
    local sflags = pbordernum(data.border) + palignnum(data.align) +
                   pexpandnum(data.expand)
    sizer:Add(ctrl, data.proportion, sflags, data.borderWidth)
end

--- Initialise the screen module
-- It needs this to communicate the frame/sizer control at the start.
-- @param frame The main frame of the application.
-- @param mainSizer The main sizer of the application
function init(f, ms)
    frame = f
    mainSizer = ms
end

--- Create a new screen for the experiment
-- It takes the title and layout of the screen as parameters.  The title
-- does not typically get shown to the user, it is an identifier used in the logs.
-- The layout takes a string for the format of the layout.
-- @param screen The title of the screen.
-- @param layout The layout of the screen.
-- @return A new screen object.
function new(title, layout)
    local screen = {}
    screen["title"] = title
    screen["layout"] = layout
    
    local panel = wx.wxPanel(frame, wx.wxID_ANY)
    local vbs = wx.wxBoxSizer(wx.wxVERTICAL)
    
    for rowname, row in pairs(layout) do
        
        if row.proportion == nil then row.proportion = 1 end
        if row.borderWidth == nil then row.borderWidth = 10 end
        if row.border == nil then row.border = "lrtb" end
        if row.align == nil then row.align = "" end
        if row.expand == nil then 
            if row.align == "c" then
                row.expand = "n" 
            else
                row.expand = "e"
            end
        end
        
        local hbs = wx.wxBoxSizer(wx.wxHORIZONTAL)
        for k, v in pairs(row) do
            if type(v) == "table" then
                if v.layout == nil then v.layout = "horizontal" end
                if v.gap == nil then v.gap = {x=5,y=5} end
                if v.proportion == nil then v.proportion = 0 end
                if v.borderWidth == nil then v.borderWidth = 10 end
                if v.border == nil then v.border = "lrtb" end
                if v.align == nil then v.align = "" end
                if v.expand == nil then 
                    if v.align == "c" then
                        v.expand = "n" 
                    else
                        v.expand = "e"
                    end
                end
                if v.columns == nil then v.columns = 2 end

                local l = v.layout
                local firstradio = true
                v.sizer = psizer(l, v.columns, v.gap.x, v.gap.y)
                
                if v.controls == nil then
                   hbs:AddStretchSpacer(1)
                else
                    for k, v2 in pairs(v.controls) do
                        -- if there are any controls, we need a panel
                        -- deal with all the various sizer params
                        if v2.default == nil then v2.default = "" end
                        if v2.filename == nil then v2.filename = "" end
                        if v2.proportion == nil then v2.proportion = 0 end
                        if v2.border == nil then v2.border = "" end
                        if v2.borderWidth == nil then v2.borderWidth = 0 end
                        if v2.align == nil then v2.align = "" end
                        if v2.expand == nil then 
                            if v2.align == "c" then
                                v2.expand = "n" 
                            else
                                v2.expand = "e"
                            end
                        end
                        if v2.labels == nil then v2.labels = {v2.label} end
                        
                        -- set the control id so we can set the signals
                        v2.id = controlID
                        controlID = controlID + 1
                        control = nil
                        
                        local spacer = false
                        local stretchspacer = false
                        
                        -- defaults for media are different
                        if v2.type ~= "media" then
                            if v2.width == nil then v2.width = wx.wxDefaultSize:GetWidth() end
                            if v2.height == nil then v2.height = wx.wxDefaultSize:GetHeight() end
                        end
                        
                        if v2.type == "button" then
                            control = button(v2, panel)
                        elseif v2.type == "label" then
                            control = label(v2, panel)
                        elseif v2.type == "slider" then
                            control = slider(v2, panel)    
                        elseif v2.type == "radio" then
                            local style = 0
                            if firstradio then
                                firstradio = false
                                style = wx.wxRB_GROUP
                            end
                            control = radio(v2, panel, style)
                        elseif v2.type == "multiradio" then
                            control = multiradio(v2, panel)
                            controlID = v2.id
                        elseif v2.type == "multicheckbox" then
                            control = multicheckbox(v2, panel)
                            controlID = v2.id
                        elseif v2.type == "checkbox" then
                            control = checkbox(v2, panel)
                        elseif v2.type == "textbox" then
                            control = textbox(v2, panel)
                        elseif v2.type == "combobox" then
                            control = combobox(v2, panel)
                        elseif v2.type == "form" then
                            v2.control = wx.wxBoxSizer(wx.wxHORIZONTAL)
                            v2.control_label = wx.wxStaticText(panel, v2.id, v2.label)
                            controlID = controlID + 1
                            v2.control_textbox = wx.wxTextCtrl(panel, v2.id + 1,
                                                               v2.default,
                                                               wx.wxDefaultPosition,
                                                               wx.wxSize(v2.width, v2.height))
                            v2.control:Add(v2.control_label, 1, wx.wxALIGN_LEFT +
                                           wx.wxALIGN_CENTRE_VERTICAL + wx.wxEXPAND)
                            v2.control:Add(v2.control_textbox, 2, wx.wxALIGN_LEFT + wx.wxEXPAND)
                        elseif v2.type == "spacer" then
                            spacer = true
                        elseif v2.type == "stretchspacer" then
                            stretchspacer = true
                        elseif v2.type == "media" then
                            control = media(v2, panel)
                        end
                        
                        -- save it so that the user can access the control by name
                        if control == nil then
                            control = {}
                            control.wx = v2.control -- TODO: wrap wx functionality
                        end
                        if v2.name then screen[v2.name] = control end
                        -- add it to the sizer
                        if spacer then
                            -- add a spacer
                            v.sizer:AddSpacer(v2.width)
                        elseif stretchspacer then
                            -- add a stretch spacer
                            v.sizer:AddStretchSpacer(v2.width)
                        else
                            paddsizer(v.sizer, control.wx, v2)
                        end

                        if v2.enable == false then control:disable() end
                        if v2.visible == false then control:hide() end
                    end
                    -- add it to the horizontal sizer
                    paddsizer(hbs, v.sizer, v)
                end
            end
        end
        -- add it to the vertical sizer
        paddsizer(vbs, hbs, row)
    end
    
    panel:SetAutoLayout(true)
    panel:SetSizer(vbs)
    vbs:SetSizeHints(panel)
    vbs:Fit(panel)

    -- add self to main sizer
    --mainSizer:Add(panel, 0, wx.wxEXPAND)
    panel:Show(false)
    screen.panel = panel
    screen.vbs = vbs
    
    return screen
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })
-- vim: expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
