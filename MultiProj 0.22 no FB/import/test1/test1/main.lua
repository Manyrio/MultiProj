
require "test"

love.graphics.setBackgroundColor(100,30,30)

local rot = 0

function love.update(dt)
	rot = rot + dt*10
end


function love.draw()
	
	love.graphics.setColor(255,255,0,255)
	love.graphics.rectangle("fill", 200+ math.sin(rot)*50, 200+ math.cos(rot)*50, 40, 20)
	love.graphics.draw(image, 20, 20)

end