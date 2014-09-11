



local UIParent = require "GUI"


local f = CreateFrame("Frame")

f.eb = CreateFrame("MultiLineEditBox")
f.eb:SetPoint("TOPLEFT", f, "TOPLEFT", 5, 5)
f.eb:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, -5)


f:SetSize(200,400)
f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 50, 50)


f.t = f:CreateTexture()
f.t:SetTexture(40, 40, 40,255)
f.t:SetAllPoints(f)

local f = CreateFrame("Frame")

f.eb = CreateFrame("MultiLineEditBox", nil, f)
f.eb:SetPoint("TOPLEFT", f, "TOPLEFT", 5, 5)
f.eb:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, -5)


f:SetSize(200,400)
f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 300, 50)


f.t = f:CreateTexture()
f.t:SetTexture(40, 40, 40,255)
f.t:SetAllPoints(f)





function love.update(dt)
  UIParent:update(dt)
end

function love.mousepressed(x,y,button)
  UIParent:mousepressed(x,y,button)
end

function love.mousereleased(x,y,button)
  UIParent:mousereleased(x,y,button)
end

function love.keypressed(key, uni)
  UIParent:keypressed(key, uni)
end

function love.keyreleased(key, uni)
  UIParent:keyreleased(key,uni)
end

function love.draw() 
  UIParent:draw()
	love.graphics.print(love.timer.getFPS(), 10, 10)
end













































