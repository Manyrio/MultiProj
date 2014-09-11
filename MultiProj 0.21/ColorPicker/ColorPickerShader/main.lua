

local UIParent = require "GUI"

local m = require "colorpicker"



local f = CreateFrame("Frame")
f.b = f:CreateTexture()
f.b:SetTexture(0,150,70,255)
f.b:SetAllPoints(f)
f:SetAllPoints(UIParent)
f:SetScript("OnMouseDown", function()
     m:Show()
     local x,y = love.mouse.getPosition() 
    m:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x-m:GetWidth()/2,y-m:GetWidth()/2)
     end)

f:SetScript("OnClick", function(self) self.b:SetTexture(m:GetColor()) end)


function love.update(dt)
    UIParent:update(dt)
end

function love.draw()
    UIParent:draw()
end

function love.mousepressed(x,y,button)
    UIParent:mousepressed(x,y,button)
end

function love.mousereleased(x,y,button)
    UIParent:mousereleased(x,y,button)
end
