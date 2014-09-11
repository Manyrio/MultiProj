
local a = 0

function love.update(dt)
	a = a+dt
end

function love.draw()
	love.graphics.print("Cheese: "..a, 40, 40)
end