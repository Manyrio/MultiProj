--[[
globals:
Projects - store all of the projects
Players -- store all of the game players
Settings -- store settings, sync them if needed.
Users = {}
CURRENT_USER --- default user before they log in

--]]

--[[
New Project basics
-public/private
-name of project
New Project Advanced
project x/y
add users to project
from template
--]]



Projects = {} --stores each table containing sub projects
Settings = {} -- all settings 
Settings.AutoPause = true
Users = {}

COLORS = {
    edgec = {200,200,200,200},
    bgc = {100,100,100,150},
}



UIParent = require "GUI" --this needs to be loaded first so all of the other modules can use it
CURRENT_USER = {name = "kraftman"}
UIParent.scale = 1

local Background = require("modules/background")
LuaEdit = require "modules/luaedit"
ProjectLoader = require "modules/projloader"
Client = require "modules/client"
require "modules/menu"

--==============================================================================

function love.update(dt)
	Background:update(dt)
  UIParent:update(dt)
end

function love.mousepressed(x,y,button)
  UIParent:mousepressed(x,y,button)
end

function love.mousereleased(x,y,button)
  UIParent:mousereleased(x,y,button)
end

function love.keypressed(key, uni)
	if Client then
		if CURRENT_USER.selectededitbox then
		local eb = CURRENT_USER.selectededitbox
			Client:send("W||"..eb:GetName().."||L||"..CURRENT_USER.selectedline.."||P||"..CURRENT_USER.linepos.."||K||"..key.."||U||"..uni)
			-- W window L line P position K key U uni UN username
		end
	end
  UIParent:keypressed(key, uni)
end

function love.keyreleased(key, uni)
  UIParent:keyreleased(key,uni)
end

function love.draw() 
	Background:draw()
  UIParent:draw()
end

--==============================================================================


