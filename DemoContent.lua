
local DemoContent = {}


function DemoContent:create(group, debugText)
	self.objectList = {}

	-- screen metric aliases
	local ACW, ACH = display.actualContentWidth, display.actualContentHeight
	local SOX, SOY = display.screenOriginX, display.screenOriginY
	local CCX, CCY = SOX + ACW/2, SOY + ACH/2
	local SRX, SBY = SOX + ACW, SOY + ACH

	-- and let's transform the content group (just to make it more challenging)
	group:translate(CCX,CCY)
	group:rotate(30)
	group.xScale, group.yScale = 0.5, 0.5

	-- draw some reference to show the transform
	local origin = display.newCircle(group,0,0,10,10)
	origin:setFillColor(1,0,1,0.5)
	self.objectList[#self.objectList+1] = origin
	local xAxis = display.newRect(group,0,0,ACW,2)
	xAxis:setFillColor(1,0,1,0.5)
	self.objectList[#self.objectList+1] = xAxis
	local yAxis = display.newRect(group,0,0,2,ACH)
	yAxis:setFillColor(1,0,1,0.5)
	self.objectList[#self.objectList+1] = yAxis

	-- make some touchable rects
	local function onRectTouch(self, event)
		if (event.phase=="began") then
			debugText.text = "TOUCHED ID: " .. tostring(self.id)
			debugText.alpha = 1
			transition.to(debugText, { time=1000, alpha=0.2 })
		end
		return true
	end
	local function onRectTap(self, event)
		debugText.text = "TAPPED ID: " .. tostring(self.id)
		debugText.alpha = 1
		transition.to(debugText, { time=1000, alpha=0.2 })
		return true
	end

	math.randomseed(0)
	local objectList = {}
	for i = 1, 20 do
		local x = math.random(-ACW/2,ACW/2)
		local y = math.random(-ACH/2,ACH/2)
		local w = math.random(50,100)
		local h = math.random(50,100)
		local r = math.random(360)
		--
		local rect = display.newRect(group, x, y, w, h)
		rect.id = i
		rect.alpha = 0.5
		rect.rotation = r
		-- arbitrary anchors are also supported (not present in original demo)
		rect.anchorX = math.random()
		rect.anchorY = math.random()
		if (i%2==0) then
			rect.touch = onRectTouch
			rect:addEventListener("touch")
		else
			rect.tap = onRectTap
			rect:addEventListener("tap")
		end
		objectList[#objectList+1] = rect
		--
		local text = display.newText({ parent=group, x=x, y=y, text="#"..tostring(i), fontSize=16, font=native.systemFontBold })
		-- keep text centered in rect despite arbitrary anchors: (not present in original demo)
		local cx, cy = rect:localToContent(0,0)
		text.x, text.y = group:contentToLocal(cx,cy)
		--
		text:setFillColor(0)
		text.rotation = r
		objectList[#objectList+1] = text
	end

end

function DemoContent:destroy()
	for i = 1, #self.objectList do
		display.remove(self.objectList[i].text)
		display.remove(self.objectList[i])
	end
	self.objectList = nil
end

function DemoContent:recaption(caption)
end


return DemoContent
