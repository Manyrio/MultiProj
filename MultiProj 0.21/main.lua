

Projects = {} --stores each table containing sub projects

Settings = {} -- all settings 
Settings.AutoPause = true

COLORS = {
    edgec = {200,200,200,200},
    bgc = {100,100,100,150},
}



UIParent = require "GUI"
LuaEdit = require "modules/luaedit"

NewProject = require "projloader"


UIParent.scale = 1

love.graphics.setBackgroundColor(80,90,160,255 )


local	BackGroundLogo =love.graphics.newImage("images/love-logo-512x256.png")


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
	love.graphics.draw(BackGroundLogo, UIParent:GetHeight()/2, UIParent:GetWidth()/2, 0,1,1, 128, 256)
  UIParent:draw()
end


