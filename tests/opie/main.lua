--[[
needed:
multiple rings
drag items to rings



]]


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
ring.center = love.graphics.newImage("center ring.png")
ring.arrow = love.graphics.newImage("ring arrow.png")
ring.crot = 0
ring.arot = 0
ring.timer = 0
ring.alpha = 0


local mouse = {}


function ring.update(dt)

	ring.timer = ring.timer + dt
	ring.crot = ring.timer*2
	 mouse.x, mouse.y = love.mouse.getPosition()
	 
	local angle = math.deg(math.atan2((mouse.x-ring.x),(ring.y-mouse.y)))
	
	
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
				return
		end
		ring.alpha = ring.alpha - 800*dt 
		ring.sx = math.max(0, ring.sx-dt*10)
		ring.sy = ring.sx
	end
	
	ring.selected = ring.list[floor(ring.tempangle/(360/#ring.list))+1]
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
		
end

function love.mousereleased(x,y,button)

		ring.shrinking = true
		ring.growing = nil
		return self.selected
end

return ring




