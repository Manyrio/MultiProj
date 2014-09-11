love.graphics.setBackgroundColor(80,90,160,255 )

math.randomseed(math.floor(love.timer.getMicroTime()))

local icon = {}
icon.img = love.graphics.newImage("images/love-logo-512x256.png")
icon.width = 512
icon.height = 256
icon.x = 300
icon.y = 300
icon.vx = math.random(-50, 50)
icon.vy = math.random(-50,50)

local scwidth = love.graphics.getWidth()
local scheight = love.graphics.getHeight()

function icon:update(dt)
	icon.x = icon.x + icon.vx*dt
	icon.y = icon.y + icon.vy*dt
	
	if (icon.x < 0 and icon.vx < 0) or (icon.x+icon.width > scwidth and icon.vx > 0) then --reverse the direction if it collides with walls
		icon.vx = -icon.vx
	end

	if (icon.y < 0 and icon.vy < 0) or (icon.y+icon.height > scheight and icon.vy > 0) then
		icon.vy = -icon.vy
		icon.vy = icon.vy + math.random(-10, 10)
	end
end


function icon:draw()	
	love.graphics.draw(icon.img, icon.x, icon.y)
end

return icon