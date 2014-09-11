local UIParent = require "GUI"
local colorwheel = require "colorpicker"

local f = CreateFrame("Frame")

local floor = math.floor
local tinsert = table.insert

love.graphics.newCanvas = love.graphics.newCanvas or love.graphics.newFramebuffer

f:SetSize(400,400)
f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 30, 30)
f.bg = f:CreateTexture(nil, "BACKGROUND")
f.bg:SetTexture(30,70,170,180)
f.bg:SetAllPoints(f)

f.window = CreateFrame("Frame", nil, f)
f.window:SetPoint("TOPLEFT", f, "TOPLEFT", 10,10)
f.window:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -10,-10)

f.window.layers = {}


f.oldx = 0
f.oldy = 0
f.psize = 5
f.selectedcolor = {255,0,0,100}

f.lb = {}

f.new = CreateFrame("Frame", nil, f)
f.new:SetSize(20, 20)
f.new:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, -5)
f.new.b = f.new:CreateTexture()
f.new.b:SetTexture(30,240,40,255)
f.new.b:SetAllPoints(f.new)
tinsert(f.lb, f.new)

f.new:SetScript("OnMouseDown", function(self) 
local b = CreateFrame("Frame", nil, f)
	b.fb = love.graphics.newCanvas()
	b.pix = {}

		for i = 1, f.window:GetWidth() do
			b.pix[i] = {}
		end

	b.b = b:CreateTexture()
	b.b:SetTexture(100,30,200,255)
	b.b:SetAllPoints(b)

	tinsert(f.window.layers, b)
	tinsert(f.lb, b)
	b:SetSize(20,20)
	b:SetPoint("TOPLEFT", f.lb[#f.lb-1], "TOPRIGHT", 5,0)
	f.selected = b
	b.shown = true

	b:SetScript("OnMouseDown", function(self)
		
		if f.selected == self then
			if self.shown then
				self.shown = nil
				self.b:SetTexture(60,0,150,255)
			else
				self.shown = true
				self.b:SetTexture(100,30,200,255)
			end
		end

		f.selected = self
	end)
end)

f.new.__SCRIPTS.OnMouseDown(f.new)


local function StencilFunc()
	love.graphics.rectangle("fill", f.window:GetLeft(),f.window:GetTop(),f.window:GetWidth(), f.window:GetHeight())
end

local function RenderFunc()
	love.graphics.setStencil(StencilFunc)
		love.graphics.setColor(f.selectedcolor)
		love.graphics.rectangle("fill",f.x*f.psize+f.window:GetLeft(), f.y*f.psize+f.window:GetTop(), f.psize, f.psize )
		love.graphics.setColor(255,255,255,255)
	love.graphics.setStencil() 
end

f.window:SetScript("OnDraw", function(self)
	if f.selected then
		
		love.graphics.rectangle("fill", f.window:GetLeft(), f.window:GetTop(), f.window:GetWidth(), f.window:GetHeight())
		self.oldbm = love.graphics.getBlendMode()
		love.graphics.setBlendMode("alpha")

		love.graphics.setStencil(StencilFunc)
		for i = 1, #f.window.layers do
			if f.window.layers[i].shown then
				love.graphics.draw(f.window.layers[i].fb)
			end
		end
		love.graphics.setStencil()

		love.graphics.setBlendMode(self.oldbm)
	end
end)

f.drawmode = "additive"

f:SetScript("OnUpdate", function(self)
	if f.selected and IsMouseButtonDown("l") then
	self.x, self.y = love.mouse.getPosition()
	self.x = floor((self.x-f.window:GetLeft())/f.psize)
	self.y = floor((self.y-f.window:GetTop())/f.psize)

	if self.oldx == self.x and self.oldy == self.y then
		return
	end
		if f.selected.shown then
			self.oldbm = love.graphics.getBlendMode()
			love.graphics.setBlendMode(self.drawmode)
			f.selected.fb:renderTo(RenderFunc)
			love.graphics.setBlendMode(self.oldbm)
		end
	self.oldx = self.x
	self.oldy = self.y
end
end)

f:SetScript("OnMouseDown", function(self)
	if IsMouseButtonDown("m") then
		colorwheel:Show()
	end
end)
colorwheel:SetScript("OnHide", function(self)
	f.selectedcolor = {self:GetColor()}
	if f.selectedcolor[4] < 255 then
		f.drawmode = "additive"
	else
		f.drawmode = "alpha"
	end
	end)

function love.keypressed(key)
	if key == "r" then
		f.selectedcolor = {255,0,0,100}
		f.drawmode = "additive"
	elseif key == "g" then
		f.selectedcolor = {0,255,0,100}
		f.drawmode = "additive"
	elseif key == "b" then
		f.selectedcolor = {0,0,255,100}
		f.drawmode = "additive"
	elseif key == "e" then
		f.drawmode = "subtractive"
		f.selectedcolor = {0,0,0,255}
	end
end

function love.mousepressed(x,y,button)
	UIParent:mousepressed(x,y,button)
end

function love.mousereleased(x,y,button)
	UIParent:mousereleased(x,y,button)
end

function love.update(dt)
	UIParent:update(dt)
end

function love.draw()
	UIParent:draw()
end