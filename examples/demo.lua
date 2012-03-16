------------------------------------------------------------------------------
-- Demo program for perceptio
-- @release Perceptio (C) 2011-2012 University of York
-- Please see LICENSE for details of the BSD license.
------------------------------------------------------------------------------

-- need to specify where to find the library
package.path = package.path..";../src/?.lua;src/?.lua"

-- details about the experiment
experiment_name = "Speech Perception 1.0"
experiment_description = "Perception Experiment 1, CONTROL."

------------------------------------------------------------------------------
-- this is just to launch the module for creation
local p = require("perceptio")

-- initialise and set the name of the experiment + a description
initialised = p.init(experiment_name, experiment_description, 12, function()
    if stim then
        stim:write()
    end
end)

-- don't run anything if it hasn't been initialised
-- (important don't remove this)
if not initialised then
    return
end

-- initialise screen list
screens = {}
------------------------------------------------------------------------------

-- screen 1
screens[1] = perceptio.screen("Questionnaire",
    {
        -- row 1
        {
            proportion = 0,
            -- column 1
            {
                layout = "vertical",
                proportion = 1,
                controls = 
                {
                    {
                        type = "label",
                        label = " "
                    },
                    {
                        type = "label",
                        label = "Please fill out this form before you start the experiment."
                    }
                }
            }
        },
        -- row 2
        {
            proportion = 1,
            align = "c",
            -- column 1
            {
                layout = "flexgrid",
                columns = 2,
                proportion = 0,
                align = "c",
                controls = 
                {
                    {
                        type = "label",
                        label = "Date/Time",
                        align = "lv"
                    },
                    {
                        name = "Date",
                        type = "textbox",
                        value = os.date(),
                        expand = "eg",
                        proportion = 1
                    },
                    {
                        type = "label",
                        label = "First Name",
                        align = "lv"
                    },
                    {
                        name = "FirstName",
                        type = "textbox",
                        expand = "eg",
                        proportion = 1
                    },
                    {
                        type = "label",
                        label = "Family Name",
                        align = "lv"
                    },
                    {
                        name = "FamilyName",
                        type = "textbox",
                        expand = "eg",
                        proportion = 1
                    },
                    {
                        type = "label",
                        label = "Initials",
                        align = "lv"
                    },
                    {
                        name = "Initials",
                        type = "textbox",
                        expand = "eg",
                        proportion = 1
                    },
                    {
                        type = "label",
                        label = "Age",
                        align = "lv"
                    },
                    {
                        name = "Age",
                        type = "textbox",
                        expand = "eg",
                        proportion = 1
                    },
                    {
                        type = "label",
                        label = "Gender",
                        align = "lv"
                    },
                    {
                        name = "Gender",
                        type = "combobox",
                        --dummy = "none specified",
                        labels = {"(please select)", "female ", "male"},
                        expand = "eg",
                        proportion = 1
                    },
                    {
                        type = "label",
                        label = "Vision Aid",
                        align = "lv"
                    },
                    {
                        name = "VisionAid",
                        type = "combobox",
                        --dummy = "none specified",
                        labels = {"(please select)", "no", "spectacles", "contact lenses (soft)", "contact lenses (hard)"},
                        expand = "eg",
                        proportion = 1
                    },
                    {
                        type = "label",
                        label = "Hearing Aid",
                        align = "lv"
                    },
                    {
                        name = "HearingAid",
                        type = "combobox",
                        --dummy = "none specified",
                        labels = {"(please select)", "no ", "yes"},
                        expand = "eg",
                        proportion = 1
                    },
                    {
                        type = "label",
                        label = "Native Language/s",
                        align = "lv"
                    },
                    {
                        name = "NativeLanguage",
                        type = "textbox",
                        expand = "eg",
                        proportion = 1
                    },
                    {
                        type = "label",
                        label = "Profession/Field of Study  ",
                        align = "lv"
                    },
                    {
                        name = "Profession",
                        type = "textbox",
                        expand = "eg",
                        proportion = 1
                    },
                    {
                        type = "label",
                        label = "Prior Knowledge",
                        align = "lv"
                    },
                    {
                        name = "PriorKnowledge",
                        type = "multicheckbox",
                        labels = {"linguistics  ", "psycholinguistics  ", "phonetics  ", "speechreading  ", "sign language  "},
                        expand = "eg",
                        proportion = 1
                    },
                    {
                        type = "label",
                        label = "Email Address",
                        align = "lv"
                    },
                    {
                        name = "EmailAddress",
                        type = "textbox",
                        expand = "eg",
                        proportion = 1
                    },
                }
            }
        },
        -- row 3
        {
            proportion = 0,
            -- column 1
            {
                layout = "horizontal",
                proportion = 1,
                controls = 
                {
                    {
                        type = "label",
                        label = "All data will be held by the Department of Language and "..
                                "Linguistic Science, University of York, UK, in accordance "..
                                "with the 1998 Data Protection Act. Data will be kept and "..
                                "transferred anonymously and treated confidentially.",
                        wrap = true,
                        width = 690,
                        align = "r",
                        proportion = 1
                    },
                    {
                        name = "nextButton",
                        type = "button",
                        label = "Start experiment",
                        align = "r",
                        proportion = 0,
                        event = function(button)
                            local screen = perceptio.allScreens[1]
                            -- record the data in the textboxes
                            -- initialise stimulus
                            stim = perceptio.stimulus(screen["Initials"]:getValue().."."..os.date("%Y%m%d.%H%M%S")..".txt",
                                {"Date/Time", "First Name", "Family Name", "Initials", "Gender", "Age", "Vision Aid", "Hearing Aid", "Native Language/s", "Profession/Field of Study", "Prior Knowledge", "Email Address"})
                            perceptio.goto(2)
                            stim:info("Date/Time", screen["Date"]:getValue())
                            stim:info("First Name", screen["FirstName"]:getValue())
                            stim:info("Family Name", screen["FamilyName"]:getValue())
                            stim:info("Initials", screen["Initials"]:getValue())
                            stim:info("Gender", screen["Gender"]:getValue())
                            stim:info("Age", screen["Age"]:getValue())
                            stim:info("Vision Aid", screen["VisionAid"]:getValue())
                            stim:info("Hearing Aid", screen["HearingAid"]:getValue())
                            stim:info("Native Language/s", screen["NativeLanguage"]:getValue())
                            stim:info("Profession/Field of Study", screen["Profession"]:getValue())
                            stim:info("Prior Knowledge", p.utils.toCSV(screen["PriorKnowledge"]:getValue()))
                            stim:info("Email Address", screen["EmailAddress"]:getValue())
                      
                            -- initialise the stimulus table for video questions
                            videoResponses = stim:table("Videos", {"Video", "Plays", "Response"})
                            -- initialise the stimulus table for end questions
                            endResponses = stim:table("End", {"Question", "Response"})
                            -- start playing video immediately
                            perceptio.allScreens[2].video:play()
                        end
                    }
                }
            }
        }
    })

-- screen 2
playCount = 1
playLimit = 1
limitReached = false

-- load the video list
videos = {}
watched = {}
fv = io.open(p.utils.cwd().."/videos.txt", "r")
if fv then
    for video in fv:lines() do
        if video ~= "" then
            if video:find(":") ~= nil then
                table.insert(videos, video)
            elseif video:sub(1,1) == "/" then
                table.insert(videos, video)
            else
                table.insert(videos, p.utils.cwd().."/"..video)
            end
        end
    end
    fv:close()
end
--- Returns the next video (randomly chosen)
math.randomseed(os.time())
math.random()
math.random()
math.random()
k = #videos
rnum = {}
for i = 1, #videos do
    rnum[i] = math.random(1, k)
    k = k - 1
end
currnum = 1

function nextVideo()
    if #videos > 0 then
        --v = math.random(1, #videos)
        v = rnum[currnum]
        currnum = currnum + 1
        vid = videos[v]
        table.insert(watched, vid)
        table.remove(videos, v)
        return vid
    else
        return ""
    end
end
-- Get the first video
loadedVideo = nextVideo()

screens[2] = perceptio.screen("Video",
    {
       -- row 1
       {
           proportion = 1,
           expand = "e",
           align = "c",
           -- column 1
           {
               proportion = 1,
               expand = "e",
               align = "c",
               controls =
               {
                   {
                       proportion = 1,
                       name = "video",
                       type = "media",
                       filename = loadedVideo,
                       expand = "e",
                       align = "c",
                       event = function(video)
                            local screen = perceptio.allScreens[2]
                            if video:getState() == "playing" then
                                screen.playButton:disable()
                                screen.nextButton:disable()
                            else
                                if not limitReached then
                                    screen.playButton:enable()
                                end
                                screen.nextButton:enable()
                            end
                       end
                   }
               }
           }
       },
       --row 2
       {
           proportion = 0,
           -- column 1
           {
                proportion = 0,
                align = "l",
                controls =
                {
                    {
                        name = "playButton",
                        type = "button", 
                        label = "Replay",
                        align = "c",
                        event = function(button)
                            local screen = perceptio.allScreens[2]
                            playCount = playCount + 1
                            if screen.playButton:getLabel() == "Replay" then
                                screen.video:stop()
                                screen.video:play()
                            else
                                screen.playButton:setLabel("Replay")
                                screen.video:play()
                            end
                            if playCount >= playLimit then
                                limitReached = true
                            end
                        end
                    }
                }
            },
            -- column 2
            {
            },
            -- column 3
            {
                proportion = 0,
                align = "r",
                controls =
                {
                    {
                        name = "nextButton",
                        type = "button",
                        label = "Next",
                        align = "c",
                        enable = false,
                        event = function(button)
                            local screen = perceptio.allScreens[2]
                            -- Keep track the data for this round
                            lastVideo = loadedVideo
                            lastPlayCount = playCount
                            -- Reset for next video round
                            screen.playButton:setLabel("Replay")
                            playCount = 0
                            limitReached = false
                            screen.nextButton:disable()
                            screen.playButton:enable()
                            -- Load the next video
                            loadedVideo = nextVideo()
                            if loadedVideo ~= "" then
                                screen.video:load(loadedVideo)
                            end
                            -- Goto questions screen
                            perceptio.goto(3)
                        end
                    }
                }
            }
       }
    })

qngridcol = 2
qngridk = {"p", "b", "t", "d",
           "k", "g", "f", "v",
           "s", "z", "sh", "zh",
           "th", "dh", "m", "n",
           "h", "ng"}
qngrid = {"P   (pit)", "B   (bit)", "T   (tie)", "D   (die)",
          "K   (kite)", "G   (guy)", "F   (few)", "V   (view)",
          "S   (sun)", "Z   (zoo)", "SH   (she)", "ZH   (beiGE)",
          "TH   (thin)", "DH   (then)", "M   (map)", "N   (nap)",
          "H   (ham)", "NG   (baNG)"}
    
qnscreentable = {
    -- row 1
    {
        proportion = 0,
        -- column 1
        {
            layout = "vertical",
            proportion = 1,
            controls = 
            {
                {
                    name = "instructions",
                    type = "label",
                    label = "Which consonant did you hear in initial syllable position?"
                }
            }
        }
    },
    -- row 2
    {
        proportion = 1,
        align = "c",
        -- column 1
        {
            layout = "flexgrid",
            columns = qngridcol,
            proportion = 0,
            align = "c",
            controls = {}
        }
    },
    -- row 3
    {
        proportion = 0,
        -- column 1
        {
            layout = "horizontal",
            proportion = 1,
            controls = 
            {
                {
                    type = "label",
                    label = "Press your choice to continue...",
                    wrap = true,
                    width = 800,
                    align = "r",
                    proportion = 1
                },
            }
        }
   }
}

for i, o in ipairs(qngrid) do
    qnscreentable[2][1].controls[i] = {
                                            type = "button",
                                            name = "qn_"..qngridk[i],
                                            label = o,
                                            expand = "eg",
                                            proportion = 1,
                                            event = function(button)
                                                local screen3 = perceptio.allScreens[3]
                                                videoResponses:entry({lastVideo, lastPlayCount, qngridk[i]})
                                                if loadedVideo ~= "" then
                                                    perceptio.goto(2)
                                                    -- play the video 
                                                    -- immediately on the screen
                                                    perceptio.allScreens[2].video:play()
                                                else
                                                    perceptio.goto(4)
                                                end
                                            end
                                        }
end
screens[3] = perceptio.screen("Questionnaire 1", qnscreentable)

endscreentable =
    {
        -- row 1
        {
            proportion = 0,
            -- column 1
            {
                layout = "vertical",
                proportion = 1,
                controls = 
                {
                    {
                        type = "label",
                        label = " "
                    },
                    {
                        type = "label",
                        label = "Thank you for participating in this experiment!"
                    },
                    {
                        type = "label",
                        label = " "
                    },
                    {
                        type = "label",
                        label = "Before you quit, please answer the following questions:"
                    }
                }
            }
        },
        -- row 2
        {
            proportion = 1,
            align = "c",
            -- column 1
            {
                layout = "flexgrid",
                columns = 1,
                proportion = 0,
                align = "c",
                controls = 
                {
                    {
                        type = "label",
                        fontsize = 12,
                        label = "Do you regularly interact with people wearing any kind of face covering "..
                        "for occupational, recreational or religious reasons? If yes, please specify.",
                        wrap = true,
                        width = 800,
                        align = "l"
                    },
                    {
                        name = "ExperienceMask",
                        type = "textbox",
                        fontsize = 10,
                        expand = "eg",
                        multiline = true,
                        height = 40,
                        proportion = 1
                    },
                    {
                        type = "label",
                        fontsize = 12,
                        label = "Do you regularly interact with people having a hearing or vision impairment (deaf/blind)? If yes, please specify.",
                        wrap = true,
                        width = 800,
                        align = "l"
                    },
                    {
                        name = "ExperienceModality",
                        type = "textbox",
                        fontsize = 10,
                        expand = "eg",
                        multiline = true,
                        height = 40,
                        proportion = 1
                    },
                    {
                        type = "label",
                        fontsize = 12,
                        label = "Did you know any of the speakers before participating in this the experiment?",
                        wrap = true,
                        width = 800,
                        align = "l"
                    },
                    {
                        name = "SpeakerRecognition",
                        type = "textbox",
                        fontsize = 10,
                        expand = "eg",
                        multiline = true,
                        height = 40,
                        proportion = 1
                    },
                    {
                        type = "label",
                        fontsize = 12,
                        label = "How easily or difficult to understand were the sounds when spoken through the face coverings?",
                        width = 800,
                        align = "l"
                    },
                    {
                        type = "label",
                        fontsize = 10,
                        label = "Niqab (Muslim face veil)",
                        width = 700,
                        align = "l"
                    },
                    {
                        name = "NIQ",
                        type = "multiradio",
                        fontsize = 10,
                        dummy = " none specified  ",
                        labels = {" none specified  ", " always intelligible  ", " mostly intelligible  ", " mostly unintelligible  ", " unintelligible  "},
                        align = "c",
                        proportion = 1
                    },
                    {
                        type = "label",
                        fontsize = 10,
                        label = "Surgical mask",
                        width = 700,
                    },
                    {
                        name = "SUR",
                        type = "multiradio",
                        fontsize = 10,
                        dummy = " none specified  ",
                        labels = {" none specified  ", " always intelligible  ", " mostly intelligible  ", " mostly unintelligible  ", " unintelligible  "},
                        align = "c",
                        proportion = 1
                    },
                    {
                        type = "label",
                        fontsize = 10,
                        label = "Hoodie and bandana",
                        width = 700,
                        align = "l"
                    },
                    {
                        name = "HOO",
                        type = "multiradio",
                        fontsize = 10,
                        dummy = " none specified  ",
                        labels = {" none specified  ", " always intelligible  ", " mostly intelligible  ", " mostly unintelligible  ", " unintelligible  "},
                        align = "c",
                        proportion = 1
                    },
                    {
                        type = "label",
                        fontsize = 10,
                        label = "Balaclava (without mouth hole)",
                        width = 700,
                        align = "l"
                    },
                    {
                        name = "BA1",
                        type = "multiradio",
                        fontsize = 10,
                        dummy = " none specified  ",
                        labels = {" none specified  ", " always intelligible  ", " mostly intelligible  ", " mostly unintelligible  ", " unintelligible  "},
                        align = "c",
                        proportion = 1
                    },
                    {
                        type = "label",
                        fontsize = 10,
                        label = "Balaclava (with mouth hole)",
                        width = 700,
                        align = "l"
                    },
                    {
                        name = "BA3",
                        type = "multiradio",
                        fontsize = 10,
                        dummy = " none specified  ",
                        labels = {" none specified  ", " always intelligible  ", " mostly intelligible  ", " mostly unintelligible  ", " unintelligible  "},
                        align = "c",
                        proportion = 1
                    },
                    {
                        type = "label",
                        fontsize = 10,
                        label = "'Old man' rubber mask",
                        width = 700,
                        align = "l"
                    },
                    {
                        name = "RUB",
                        type = "multiradio",
                        fontsize = 10,
                        dummy = " none specified  ",
                        labels = {" none specified  ", " always intelligible  ", " mostly intelligible  ", " mostly unintelligible  ", " unintelligible  "},
                        align = "c",
                        proportion = 1
                    },
                    {
                        type = "label",
                        fontsize = 10,
                        label = "Tape",
                        width = 700,
                        align = "l"
                    },
                    {
                        name = "TAP",
                        type = "multiradio",
                        fontsize = 10,
                        dummy = " none specified  ",
                        labels = {" none specified  ", " always intelligible  ", " mostly intelligible  ", " mostly unintelligible  ", " unintelligible  "},
                        align = "c",
                        proportion = 1
                    },
                    {
                        type = "label",
                        fontsize = 10,
                        label = "Motorcycle crash helmet",
                        width = 700,
                        align = "l"
                    },
                    {
                        name = "HEL",
                        type = "multiradio",
                        fontsize = 10,
                        dummy = " none specified  ",
                        labels = {" none specified  ", " always intelligible  ", " mostly intelligible  ", " mostly unintelligible  ", " unintelligible  "},
                        align = "c",
                        proportion = 1
                    },
                }
            }
        },
        -- row 3
        {
            proportion = 0,
            -- column 1
            {
            },
            -- column 2
            {
                proportion = 0,
                align = "r",
                controls =
                {
                    {
                        name = "quitButton",
                        type = "button",
                        label = "Quit",
                        align = "r",
                        proportion = 0,
                        event = function(button)
                            perceptio.quit()
                        end
                    }
                }
            }
        }
    }

for i, o in ipairs(endscreentable[2][1].controls) do
    if endscreentable[2][1].controls[i] ~= "label" then
        endscreentable[2][1].controls[i].event = function(control)
                                                endResponses:entry({control.name, control:getValue()})
                                            end
    end
end
screens[4] = perceptio.screen("The End", endscreentable)

-- Run the screens
p.run(screens)


-- vim: expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
