--[[
each project needs:
creator
creation date
public/private
who it is shared with
.last updated time



--]]

local socket = require "socket"

local username = "kraftman"

local users = {}

local tinsert = table.insert


local client = socket.connect("127.0.0.1", 5050)
client:settimeout(0)
if client then
	client:send("UN||kraftman"..math.floor(love.timer.getMicroTime()).."\n")
	client:send("UNREQALL\n") 
end

local pinger = {}
pinger.timeout = 20
pinger.timer = 0

local server = {}
server.lastping = 0

function pinger:update(dt)
	self.timer = self.timer + dt
	if pinger.timer > pinger.timeout then
		pinger.timer = pinger.timer - pinger.timeout
		client:send("PING\n")
	end
end


function love.update(dt)
	local line, err = client:receive("*l")
	if line then
		print(line)
		if line:find("UNREQALLSEND") then
			for u in line:gmatch("||(%w+%d+)") do
				print(u)
				tinsert(users, u)
			end
		elseif line:find("^PONG") then
			server.lastping = 0
		end
	end
	pinger:update(dt)
end


function love.keypressed(key)
	client:send(key.."\n")
end

function love.draw()
	for i = 1, #users do
		love.graphics.print(users[i], 10, 20*i)
	end
end





