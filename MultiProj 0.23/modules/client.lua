-- re write of client to fit with gui



local socket = require "socket"

local username = "kraftman"

local tinsert = table.insert



 Client = CreateFrame("Frame")

Client.pingtime = 20
Client.pingtimer = 0
Client.users = {}
Client.lastupdate = 0
Client.retries = 5


function Client:Init(ip,port)
	if not ip then ip = "127.0.0.1" end
	if not port then port = 5050 end
	
	self.ip = ip
	self.port = port
	self.socket = socket.connect(self.ip, 5050)
	if self.socket then
		self.socket:settimeout(0)
		self:send("UN||"..username)
		self:send("UNREQALL") 
		self.retries = 0
		if self.socket:getsockname() then
			self.connected = true
		end
	end
end



function Client:Ping(dt)
	self.pingtimer = self.pingtimer + dt
	if self.pingtimer > self.pingtime then
		self.pingtimer = self.pingtimer -self.pingtime
		self:send("PING")
	end
end

function Client:ParseLine(msg)
print(msg)
	if msg:find("^UNREQALLSEND") then --receive a list of all online users
		for u in msg:gmatch("||(%w+%d+)") do
			print(u)
			tinsert(self.users, u)
			Users[u] = {name = user, status = "online"}
		end
	elseif msg:find("^PONG") then --keeps the connection status updated
		print(msg)
		self.lastupdate = 0
	elseif msg:find("^NU||") then -- add a new user
		local user = msg:match("^NU||(.+)")
		if not Users[user] then
			Users[user] = {name = user, status = "online"}
		end
	elseif msg:find("^NP") then
		local project, username = msg:match("NP||(.+)||name||(.+)")
		print("Creating project: "..project.." by "..username)
		if not Users[username] then
			Users[username] = {name = username}
		end
		ProjectLoader:Create(project, Users[username])
	elseif msg:find("^W||") then
		local window, line, position, key, uni,user = msg:match("W||(.+)||L||(.+)||P||(.+)||K||(.+)||U||(.+)||UN||(.+)")
		if _G[window] then
			local eb = _G[window]
			position = tonumber(position)
			uni = tonumber(uni)
			line = tonumber(line)
			Users[user].selectededitbox = eb
			Users[user].selectedline = line
			Users[user].linepos = position
			print(window, line, position, key, uni,user)
			eb:SelectLine(Users[user].selectedline, Users[user])
			eb:keypressed(key, uni, Users[user])
		end
	elseif msg:find("^TIMEOUT||") then
		local user = msg:match("^TIMEOUT||(.+)")
		if Users[user] and Users[user].selectededitbox then
			Users[user].selectededitbox.users[user] = nil
		end
		Users[user] = nil
	elseif msg:find("STATUS||") then
		local user, status = msg:match("^STATUS||(.+)||(.+)")
		Users[user].status = status
	end
end

function Client:send(msg)
	if self.socket then
		self.socket:send(msg.."\n")
	end
end

Client:Init("127.0.0.1",5050)

Client:SetScript("OnUpdate", function(self, dt)
	if self.socket then
		local line, err = self.socket:receive("*l")
		if line then
			self:ParseLine(line)
		end
		self:Ping(dt)
		
	end
	self.lastupdate = self.lastupdate + dt
	if self.lastupdate > 60 and self.retries < 4 then
		print("connection lost, retrying")
		self.lastupdate = 0
		self:Init(self.ip, self.port)
		self.retries = self.retries + 1
		self.connected = false
	end
end)




return Client