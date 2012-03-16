------------------------------------------------------------------------------
-- Test program for perceptio
-- @release Perceptio (C) 2011-2012 University of York
-- Please see LICENSE for details of the BSD license.
------------------------------------------------------------------------------

-- need to specify where to find the library
package.path = package.path..";../src/?.lua;src/?.lua"

-- details about the experiment
experiment_name = "Demo Test 1"
experiment_description = "This is a demo test to show what Perceptio can do."

------------------------------------------------------------------------------
-- this is just to launch the module for creation
local perceptio = require("perceptio")

-- initialise and set the name of the experiment + a description
initialised = perceptio.init(experiment_name, experiment_description)

-- don't run anything if it hasn't been initialised
-- (important don't remove this)
if not initialised then
    return
end

-- initialise screen list
screens = {}

screens[1] = perceptio.screen("Questionnaire",
    {
        -- row 1
        {
            proportion = 1,
            border = "lrtb",
            borderWidth = 10,
            expand = "e",
            -- column 1
            {
                layout = "vertical",
                border = "lrtb",
                expand = "e",
                proportion = 1,
                controls =
                {
                    {
                        name = "instructions",
                        type = "label", 
                        label = "Press \"Play\" to watch this video,"..
                                "you may click \"Replay\" if you need "..
                                "to watch this video again."
                    },
                    {
                        name = "panic",
                        type = "button", 
                        label = "Don't PANIC.",
                        align = "c",
                        event = function(screen)
                            if screen.panic.wx:GetLabel() == "PANIC PANIC!" then
                                screen.movie.wx:Stop()
                                screen.movie.wx:Play()
                            else
                                screen.panic.wx:SetLabel("PANIC PANIC!")
                                screen.movie.wx:Play()
                            end
                        end
                    }

                }
            }
        },
        -- row 2
        {
            proportion = 3,
            border = "lrtb",
            borderWidth = 10,
            expand = "e",
            -- column 1
            {
                layout = "vertical",
                align = "c",
                controls =
                {
                    {
                        name = "form1",
                        type = "form",
                        label = "hello",
                        value = "world",
                        expand = "e"
                    },
                    {
                        name = "form2",
                        type = "form",
                        label = "cheesecake",
                        value = "applepie",
                        expand = "e"
                    },
                    --{
                    --    name = "movie",
                    --    type = "media",
                    --    filename = "/home/raedwulf/downloads/monsterXvid.avi",
                    --    align = "c",
                    --    width = 300,
                    --}
                },
                proportion = 1
            }
        },
        -- row 3
        {
            proportion = 1,
            border = "lrtb",
            borderWidth = 10,
            expand = "e",
            -- column 1
            {
                layout = "horizontal",
                proportion = 1,
                controls =
                {
                    {
                        name = "bla",
                        type = "label", 
                        label = "BLARGH",
                        align = "r",
                        expand = "e",
                        proportion = 1
                    },
                    {
                        name = "nextButton",
                        type = "button", 
                        label = "Next",
                        align = "r",
                        proportion = 0,
                        expand = "e",
                        event = function(screen)
                            perceptio.goto(2)
                        end
                    }
                }
            }
        },

    })

screens[2] = perceptio.screen("Cheeseburger",
    {
        -- row 1
        {
            proportion = 1,
            border = "lrtb",
            borderWidth = 10,
            expand = "e",
            -- column 1
            {
                layout = "horizontal",
                border = "lrtb",
                expand = "e",
                controls =
                {
                    {
                        name = "foobar",
                        type = "label", 
                        label = "Nextish screenish"
                    },
                    {
                        name = "getback",
                        type = "button", 
                        label = "Get Back to where you once belonged",
                        align = "c",
                        event = function(screen)
                            perceptio.goto(1)
                        end
                    }
                },
                proportion = 1
            }
        },
        -- row 2
        {
            proportion = 1,
            border = "lrtb",
            borderWidth = 10,
            expand = "e",
            -- column 1
            {
                layout = "flexgrid",
                columns = 2,
                gap = {x=5,y=5},
                border = "lrtb",
                expand = "e",
                controls =
                {
                    {
                        name = "sand",
                        type = "label", 
                        label = "Sandwich",
                        align = "c"
                    },
                    {
                        name = "jam",
                        type = "textbox", 
                        value = "Jam sandwich",
                        expand = "eg",
                        proportion = 1
                    },
                    {
                        name = "bun",
                        type = "label", 
                        label = "Bun",
                        align = "c"
                    },
                    {
                        name = "cream",
                        type = "textbox", 
                        value = "Cream bun",
                        expand = "eg",
                        proportion = 1
                    }
                },
                proportion = 1
            }
        }
    })

perceptio.run(screens)

-- vim: expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
