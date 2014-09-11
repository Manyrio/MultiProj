




love.graphics.setBackgroundColor(0,30,0)


local rot = 0

function love.update(dt)
	rot = rot + dt*5
end


local x, y

function love.draw()
	love.graphics.setColor(255,0,255,255)
	love.graphics.rectangle("fill", 200+ -math.sin(rot)*50, 200+ math.cos(rot)*50, 40, 20)
	love.graphics.line(1,1,20,40,400,150)
	x,y = love.mouse.getPosition()
	love.graphics.circle("fill", x,y, 5,15)

	love.graphics.print("test", 40,40)
end

