
love.graphics.setBackgroundColor(150,150,255,255)

local random = math.random
math.randomseed(5)

local MAP_WIDTH = love.graphics.getWidth()
local MAP_HEIGHT = love.graphics.getHeight()


local Houses = {}

local function MakeHouse(h)
	local h = h or {}
	h.height = random(30,40)
	h.width = random(60,100)
	h.storeys = random(2,7)
	h.wallcolor = random(255)
	h.fullheight = h.height*h.storeys
	h.fullwidth = h.width + 10
	h.x = random(MAP_WIDTH)
	h.y = MAP_HEIGHT
	h.data = {}
	
	--initialise grid
	for i = 1, h.fullheight  do
		h.data[i] = {}
		for j = 1, h.fullwidth do
			h.data[i][j] = {1,1,1,0}
		end
	end
	--draw backing
	for j = 6, h.fullwidth-6 do
		for i = 1, h.fullheight-h.height do
			h.data[i][j] = {60,60,60}
		end
	end
	
	--draw walls
	
	for i = 1, h.fullheight  do
		for j = 1, h.fullwidth do
			if i < h.fullheight - h.height then
				if (j > 5 and j < 8) or (j < h.fullwidth -5 and j > h.fullwidth-8 ) then
					h.data[i][j] = {110,54,27}
				end
			end
		end
	end 
	
	--draw floors
	for j = 6, h.fullwidth-6 do
		for i = h.height, h.height*(h.storeys-2), h.height do
			h.data[i][j] = {100,100,100}
		end
	end
	
	--draw roof
	for i = 1, h.fullheight  do
		for j = 1, h.fullwidth do
			if (i > h.fullheight - h.height) and (i < h.fullheight - h.height+6) then
				if j > 3 and j < h.fullwidth -3 then
					h.data[i][j] = {200,0,0}
				end
			end
		end
	end
	
	
	h.buffer = love.graphics.newFramebuffer()
	
	
	love.graphics.setRenderTarget(h.buffer)	
	
	for i = 1, h.fullheight do
		for j = 1, h.fullwidth do
			love.graphics.setColor(unpack(h.data[i][j]))
			
			love.graphics.rectangle("fill", j +h.x, MAP_HEIGHT-i, 1, 1)
		end
	end
	
	love.graphics.setRenderTarget()

	--Houses[h] = h
	return h
end

local map = {}

for i = 1, 20 do
	local a = MakeHouse()
	local cx = (a.x + a.x+a.fullwidth)/2
	local found
	for h in pairs(Houses) do
		if (a.x > h.x and a.x < h.x+h.fullwidth) or (a.x+a.fullwidth < h.x+h.fullwidth and a.x+a.fullwidth >h.x) or (cx>h.x and cx < h.x+h.fullwidth) then
			
			found = true
		else
			
		end
	end
	if not found then
		Houses[a] = a
	end	
end

--=====


--=========== LOAD ======================

function love.load()

end

--=============== KEYBOARD ==============

function love.keypressed(key,uni)

end



--================= UPDATE =====================

function love.update(dt)


end

-- ================== MOUSE =================

function love.mousepressed(x,y,button)
	--increment()
end

function love.mousereleased(x,y,button)
	
end

-- ================= DRAW =====================

function love.draw()
	love.graphics.setColor(255,255,255,255)
	for _,house in pairs(Houses) do
		love.graphics.draw(house.buffer)
	end
	love.graphics.print(love.timer.getFPS(), 400, 400)
end


