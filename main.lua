display.setStatusBar( display.HiddenStatusBar )


-- standard tvshader setup stuff
local TVShader = require("TVShader")
local contentGroup = display.newGroup()
local effectGroup = display.newGroup()
local tvshader = TVShader({ contentGroup=contentGroup, effectGroup=effectGroup })


-- debug stuff
-- keep this stuff out of, and above, contentGroup/effectGroup
local debugGroup = display.newGroup()
local debugText = display.newText({ parent=debugGroup, text="TOUCH/TAP WILL BE REPORTED HERE", x=10, y=10, font=native.systemFontBold, fontSize=10 })
debugText.anchorX = 0
debugText:setFillColor(1,1,0)
debugText.alpha = 0.3


-- demo content
local DemoContent = require("DemoContent")
DemoContent:create(contentGroup, debugText)
-- you should check it out, lots of transforms to both the group and the objects, pretty tricky




-- TEST #1
-- COMMENT OUT TEST #2 BELOW
-- VERIFY THAT EVERYTHING IS UNTOUCHABLE
-- (or skip this step if you already "know" that it'll be untouchable)




-- TEST #2
-- UNCOMMENT NEXT SECTION
-- VERIFY THAT EVERYTHING IS PROPERLY TOUCHABLE
-- (if the opacity is hard to determine who's on top, just remember: bigger numbers are on top)
-- (you may want to zero-out the pincushion effect while testing this to get better precision)
--
-- even rect #'s have touch listeners, odd rect #'s have tap listeners
-- overlapping touches will be properly handled by topmost (fe, try #18 where it overlaps #14)
-- overlapping taps will be properly handled by topmost (fe, try #13 where it overlaps #9)
-- note that handling a touch does NOT handle its tap (fe, try #14 where it overlaps #3, or #16 where it overlaps #15), this is intentional
--

local touchGroup = display.newGroup() -- on top of everything
local TouchSupport = require("TouchSupport") -- the class
local touchSupport = TouchSupport({ touchGroup=touchGroup, contentGroup=contentGroup }) -- an instance

