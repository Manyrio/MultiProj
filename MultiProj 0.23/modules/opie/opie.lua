--[[
needed:
multiple rings
drag items to rings



]]

--[[

--Opie = require "modules/opie/opie"

local list = {}
list[1] = {label = "New File", img = love.graphics.newImage("images/newfile.png")}
list[2] = {label = "New Project", img = love.graphics.newImage("images/newproj.png")}
list[3] = {label = "Close All", img = love.graphics.newImage("images/closeall.png")}
list[4] = {label = "Close all games", img = love.graphics.newImage("images/closeallgames.png")}



local Canvas = CreateFrame("Frame", nil, UIParent)
Canvas:SetSize(UIParent:GetWidth(), UIParent:GetHeight())
Canvas:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
Canvas:EnableMouse(true)

Canvas:SetScript("OnMouseDown", function(self, x, y, button) 
Opie:Show(x,y,list,Canvas.select)
end)

local result = ""

function Canvas.select(index)
	result = list[index].label
end
--]]


--======= general locals ===========
local random = math.random
local tinsert = table.insert
local floor = math.floor
local sin = math.sin
local rad = math.rad
--==================================



local ring = CreateFrame("Frame", nil, UIParent)
ring:EnableMouse(true)
ring:SetFrameStrata("HIGH")
ring:SetSize(300,300)



ring.sx = 1
ring.sy = 1
ring.center = love.graphics.newImage("modules/opie/center ring.png")
ring.arrow = love.graphics.newImage("modules/opie/ring arrow.png")
ring.crot = 0
ring.arot = 0
ring.timer = 0
ring.alpha = 0


local mouse = {}


function ring:update(dt)

	ring.timer = ring.timer + dt
	ring.crot = ring.timer*2
	 mouse.x, mouse.y = love.mouse.getPosition()
	 
	local angle = math.deg(math.atan2((mouse.x-self:GetLeft()+5),(self:GetTop()+5-mouse.y)))
	
	
	ring.arot = angle --ring.arot + (angle - ring.arot)*dt*10
	ring.tempangle = angle +180
	
	if ring.growing then
			if ring.alpha > 255 then 
				ring.growing = nil
				ring.alpha = 255
				return
			end
			ring.alpha = ring.alpha + 800*dt
			ring.sx = math.min(1, ring.sx+dt*10)
			ring.sy = ring.sx
	elseif ring.shrinking then
		if ring.alpha < 0 then 
				ring.shrinking = nil
				ring.alpha = 0
				self:SetScript("OnUpdate", nil)
				return
		end
		ring.alpha = ring.alpha - 800*dt 
		ring.sx = math.max(0, ring.sx-dt*10)
		ring.sy = ring.sx
	end
	
	ring.selected = floor(ring.tempangle/(360/#ring.list))+1
end

ring:SetScript("OnDraw", function(self)
	love.graphics.setColor(255,255,255,self.alpha)
	love.graphics.draw(self.center, self:GetLeft(),self:GetTop(), self.crot, self.sx/4, self.sy/4, 128, 128)
	love.graphics.draw(self.arrow, self:GetLeft(), self:GetTop(), rad(self.arot), self.sx/2, self.sy/2, 32, 120)
end)


function ring:Show(x,y, list, returnfunc)
		self:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x-5, y-5)
		self.growing = true
		self.shrinking = nil
		self.list = list
		self.returnfunc = returnfunc
		self:SetScript("OnUpdate", function(self, dt) self:update(dt) end)
		
end

ring:SetScript("OnMouseUp", function(self, x,y,button) 
	self.shrinking = true
	self.growing = true
	self.returnfunc(self.selected)
end)

return ring




