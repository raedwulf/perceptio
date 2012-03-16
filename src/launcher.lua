------------------------------------------------------------------------------
-- Perceptio launcher
-- @release Perceptio (C) 2011-2012 University of York
-- Please see LICENSE for details of the BSD license.
------------------------------------------------------------------------------

-- load the wxlua module
package.cpath = package.cpath..";./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"
require("wx")

-- create the frame window
local frame = wx.wxFrame(wx.NULL, wx.wxID_ANY, "Perceptio", wx.wxDefaultPosition, wx.wxSize(450, 450), wx.wxDEFAULT_FRAME_STYLE)
-- create the panel
local panel = wx.wxPanel(frame, wx.wxID_ANY)

-- create a file menu
local fileMenu = wx.wxMenu()
fileMenu:Append(wx.wxID_EXIT, "E&xit", "Quit the program")

-- create a help menu
local helpMenu = wx.wxMenu()
helpMenu:Append(wx.wxID_ABOUT, "&About", "About Perceptio")

-- create a menu bar and append the file and help menus
local menuBar = wx.wxMenuBar()
menuBar:Append(fileMenu, "&File")
menuBar:Append(fileMenu, "&Help")

-- set the menu bar
frame:SetMenuBar(menuBar)

-- connect the exit menu event
frame:Connect(wx.wxID_EXIT, wx.wxEVT_COMMAND_MENU_SELECTED,
	function (event)
		frame:Close(true)
	end)

-- show the frame window
frame:Show(true)

-- start the wxWidgets event loop
wx.wxGetApp():MainLoop()
