display.setStatusBar( display.HiddenStatusBar )

-- standard tvshader stuff
local TVShader = require("TVShader")
local contentGroup = display.newGroup()
local effectGroup = display.newGroup()
local tvshader = TVShader({ contentGroup=contentGroup, effectGroup=effectGroup })


-- debug content
-- keep this stuff out of, and above, contentGroup/effectGroup
local debugGroup = display.newGroup()
local debugText = display.newText({ parent=debugGroup, text="YOU TOUCHED:", x=10, y=10, font=native.systemFontBold, fontSize=10 })
debugText.anchorX = 0
debugText:setFillColor(1,1,0)

-- demo content
local DemoContent = require("DemoContent")
DemoContent:create(contentGroup, debugText)
-- you should check it out, lots of transforms to both the group and the objects, pretty tricky




-- TEST #1
-- COMMON OUT TEST #2 BELOW
-- VERIFY THAT EVERYTHING IS UNTOUCHABLE (see console output)
-- (or skip this step if you already "know" that it'll be untouchable)




-- TEST #2
-- UNCOMMENT NEXT SECTION
-- VERIFY THAT EVERYTHING IS PROPERLY TOUCHABLE (see console output)
-- (if the opacity is hard to determine who's on top, just remember: bigger numbers are on top)
-- (you may want to zero-out the pincushion effect while testing this to get better precision)
--

local touchGroup = display.newGroup() -- on top of everything
local TouchSupport = require("TouchSupport")
local touchSupport = TouchSupport({ touchGroup=touchGroup, contentGroup=contentGroup })


