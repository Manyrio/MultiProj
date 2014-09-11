
love.graphics.newCanvas = love.graphics.newCanvas or love.graphics.newFramebuffer



local floor = math.floor
local sin = math.sin
local cos = math.cos
local rad = math.rad
local deg = math.deg
local max = math.max
local min = math.min
local point = love.graphics.point
local fb = love.graphics.newCanvas()

love.graphics.setCanvas(fb)



--=====================================================================
--=====================================================================
--=====================================================================
--=====================================================================
--=====================================================================
--=====================================================================

function HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h, s, v = h/256*6, s/255, v/255
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return (r+m)*255,(g+m)*255,(b+m)*255
end

function HSL(h, s, l)
    if s <= 0 then return l,l,l end
    h, s, l = h/256*6, s/255, l/255
    local c = (1-math.abs((2*l)-1))*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (l-.5*c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return (r+m)*255,(g+m)*255,(b+m)*255
end

local size = 400
local function test()
	for i = 1, size do
		for j = 1, size do

		local H = (math.deg(math.atan2(j-size/2,i-size/2)) % 360)/360*255
		local C = math.sqrt((i-size/2)^2 + (j-size/2)^2)/(size/4)*255

		local L = 255

		if C > 255 then
			L = 255 - (C - 255)
		end

		
		local r,g,b = HSV(H,math.min(C,255),L)
		if r + g + b == 0 then
			print(i,j)
		end

		if C < size+100 then
			love.graphics.setColor(r,g,b,255)
			point(i+100,j+100)
		end



		end
	end
end

--test()

local r,g,b = 200,200,200

local offset = 20

for i = 1, 255 do
	r = math.max(r - 1,0)
	g = math.max(g - 1,0)
	b = math.max(b - 1,0)
	for j = 1, 30 do
		love.graphics.setColor(r,g,b,255)
		point(i,j)
	end
end


love.graphics.setCanvas()


local data = fb:getImageData()

local r,g,b = HSV(0,0,255)


local x,y = 0,0

function love.update(dt)
 x, y = love.mouse.getPosition()
	local H = (math.deg(math.atan2(y-300,x-300)) % 360)/360*255
	local C = math.sqrt((x-300)^2 + (y-300)^2)/100*255

	local L = 255

	if C > 255 then
		L = 255 - (C - 255)
	end

	r,g,b = HSV(H,math.min(C,255),L)
	r,g,b = floor(r), floor(g), floor(b)

end

function love.mousepressed()
drawmouse = true
end

function love.mousereleased()
drawmouse = false
end

function love.draw()
	if false then
		test()
	else
		for i = 1, 10 do
			love.graphics.draw(fb, 0, 0)
		end
	end

	if drawmouse then
		love.graphics.setColor(r,g,b,255)
		local r = math.sqrt((300-x)^2 + (300-y)^2)
		love.graphics.circle("fill",300,300, r,r*8)
	end

	love.graphics.setColor(255,255,255,255)
end