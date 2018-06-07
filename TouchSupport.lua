
--[[
MIT License

Copyright (c) 2018 David Bollinger

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

local TouchSupport = {
	_NAME = "TouchSupport",
	_DESCRIPTION = "Support for manually dispatching touch events to children of a specified Display Group",
	_VERSION = "0.0.1",
	_COPYRIGHT = "Copyright (c) 2018 David Bollinger",
	_LICENSE = "MIT License"
}
TouchSupport.__index = TouchSupport

--- create an instance of TouchSupport to intercept touches and manually dispatche them to the specified group
-- @param params Table a table of parameters used to initialize the instance
--    touchGroup DisplayGroup the group into which to insert the touch rectangle, should be at top of display hierarchy
--    contentGroup DisplayGroup the group containing the objects that need manual event dispatching
--       (may be the entire effected contentGroup, or a sub-group of contentGroup containing only "touchable" elements)
-- @usage little error handling, so give it valid input
--
function TouchSupport:new(params)
	local instance = setmetatable({}, self)
	instance:init(params)
	return instance
end

--- used internally, see new() above
function TouchSupport:init(params)
	self.touchGroup = params.touchGroup -- where our touch rect lives and is actually touchable
	self.contentGroup = params.contentGroup -- where effected content lives and needs faked touchability
	-- screen dimension aliases
	local ACW, ACH = display.actualContentWidth, display.actualContentHeight
	local SOX, SOY = display.screenOriginX, display.screenOriginY
	local CCX, CCY = SOX + ACW/2, SOY + ACH/2
	local SRX, SBY = SOX + ACW, SOY + ACH
	-- create a full-screen rect to receive touch events
	local rect = display.newRect(self.touchGroup, CCX, CCY, ACW, ACH)
	-- two-way references
	rect.touchSupport = self
	self.touchRect = rect
	-- set up the touch listener
	rect.isVisible = false
	rect.isHitTestable = true
	rect.touch = function(self, event)
		if (event.phase=="began") then
			display.getCurrentStage():setFocus(self)
			--or MT: display.getCurrentStage():setFocus(self, event.id)
			--or don't set focus if you don't care to receive ended phase
			self.hasFocus = true
			self.touchSupport:redispatchEvent(event)
		elseif (self.hasFocus) then
			if (event.phase=="moved") then
				self.touchSupport:redispatchEvent(event)
			elseif (event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus(nil)
				--or MT: display.getCurrentStage():setFocus(self, nil)
				--or don't unset focus if you didn't set it to begin with
				self.hasFocus = false
				self.touchSupport:redispatchEvent(event)
			end
		end
		return true
	end
	rect:addEventListener("touch")
end


function TouchSupport:destroy()
	if (self.touchRect) then self.touchRect:removeEventListener("touch") end
	self.touchRect.touch = nil
	display.remove(self.touchRect)
	self.touchRect = nil
	self.touchGroup = nil
	self.contentGroup = nil
end


--======================
--== TOUCH REDISPATCHING
--======================

local function _objectBoundsContainPoint(object, x, y)
	--=====================================
	-- select one of the following methods:
	--=====================================
	-- 1) this method is more performant, but is not accurate if either object or its parent group is transformed
	--
	--local cb = object.contentBounds
	--return ((x>=cb.xMin) and (y>=cb.yMin) and (x<=cb.xMax) and (y<=cb.yMax))

	-- 2) this method is less performant (it implies a matrix multiplication), but remains accurate if either object or its parent group is transformed
	--
	local lx,ly = object:contentToLocal(x,y)
	local ohw, ohh = object.width/2, object.height/2
	return ((lx>=-ohw) and (ly>=-ohh) and (lx<=ohw) and (ly<=ohh))

end -- objectBoundsContainPoint()


local function _processObject(event, object)
	if (not object) then return end
	if ((object.isVisible or object.isHitTestable) and object.touch) then
		if (_objectBoundsContainPoint(object, event.x, event.y)) then
			event.target = object
			local handled = object:dispatchEvent(event)
			if (handled==true) then
				event.handled = true
			end
		end -- if within bounds
	end -- if a potential touch candidate
end -- _processObject()


local function _recurseGroup(event, group)
	for i = group.numChildren, 1, -1 do
		local child = group[i]
		if (child) then
			if (child.numChildren) then
				_recurseGroup(event, child)
			else
				_processObject(event, child)
			end -- if child is group
		end -- if child
		if (event.handled) then return end
	end -- for i children
end -- _recurseGroup()


function TouchSupport:redispatchEvent(event)
	event.handled = false
	if (not self.contentGroup) then return end
	_recurseGroup(event, self.contentGroup)
end


local API = setmetatable({}, { __call = function(self,params) return TouchSupport:new(params) end })
return API
