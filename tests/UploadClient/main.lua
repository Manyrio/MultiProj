


--[[
Options:
Select path to load file from
auto fill based on settings/conf if they exist

Title:
Author
Version
Alpha/Beta/Release
Tags
Requirements: (FB's/shaders/LOVE version)



]]

local ftp = require "socket.ftp"
--require "lua51"
--require "zip"

local boxes = {}
local buttons = {}


local function OnClick(self,x,y)
	if x > self.x and x < (self.x + self.width) and y >= self.y	and y < (self.y+ self.height) then
			for j = 1, #boxes do
				if boxes[j] == self then
					boxes[j].selected = true
				else
					boxes[j].selected = false
				end
			end
		return true
	end
end

local function CheckPath(self)
	if self.text:find("^%a:") then
		local f = io.open(self.text)
		if f then
			--found it
			self.found = true
			print("found")
		else
			self.found = false
			--didnt find it!
			print("not found")
		end
	else

	end
end

local function OnKeyDown(self, key, uni)
	if self.selected then
		if key == "tab" then
			self.selected = nil
			print(self.ID)
			if boxes[self.ID+1] then
				boxes[self.ID+1].selected = true
			else
				boxes[1].selected = true
			end
		elseif key == 'backspace' then
			self.text = string.sub(self.text, 1, -2)
			CheckPath(self)
		elseif key == 'return' then
			if self.path then
				CheckPath(self)
				print("checking path")
			else
				self.text = self.text.."\n"
			end
		elseif key == 'kpenter' then
			
		else
			if uni > 31 and uni < 127 then
				self.text = self.text..string.char(uni)
				CheckPath(self)
			end
		end
		return true
	end
end	

local function bclick(self, x, y, button)
	if x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height then
		if self.run then
			self.run()
		end
		return true
	end
end

local function newbox()
	local new = {}

	new.text = ""
	new.width = 300
	new.height = 20
	new.label = ""
	new.x = 200
	new.y = 50
	new.tx = -130
	new.ty = 2
	new.onclick = OnClick
	new.onkeydown = OnKeyDown
	new.ID = #boxes+1
	boxes[#boxes+1] = new
	return new
end

local function newbutton()
	local new = {}
	new.width = 70 
	new.height = 30
	new.onclick = bclick

	buttons[#buttons+1] = new
	return new
end

local export = newbutton()
export.x = 400
export.y = 400


local pathbox = newbox()
pathbox.y = 50
pathbox.path = true
pathbox.label = "Path:"
pathbox.tx = -130

local authorbox = newbox()
authorbox.y = 90
authorbox.label = "Author:"
authorbox.tx  = -80

local versionbox = newbox()
versionbox.y = 150
versionbox.label = "Version:"
versionbox.tx  = -80

local tagbutton = newbox()
tagbutton.y = 200
tagbutton.label = "Tags: "
tagbutton.tx  = -80

local descbox = newbox()
descbox.y = 250
descbox.label = "Description:"
descbox.height = 100
descbox.tx  = -110

export.run = function()
local msg = ""

	for i = 1, #boxes do
		if not (boxes[i].text == "") then
			msg = msg.."##-"..boxes[i].label.." "..boxes[i].text.."\r\n"
		end
	end

 local err = ftp.put("ftp://Chris:test@127.0.0.1/test1.txt", msg)
 print(err)
 	if pathbox.found then
 		local fn = pathbox.text:match("/(.-)$")
 		local file = io.open(pathbox.text,"rb")
 		file = file:read("*all")
 		local err = ftp.put("ftp://Chris:test@127.0.0.1/"..fn, file)
 		print(err)
 	end
end



function love.mousepressed(x,y,button)
	for i = 1, #boxes do 
		if boxes[i]:onclick(x,y) then
			print(i.." selected")
			return
		end
	end

	for i = 1, #buttons do
		if buttons[i]:onclick(x,y) then
			return
		end
	end
end

function love.keypressed(key,uni)
	for i = 1, #boxes do
		if boxes[i]:onkeydown(key, uni) then
			return
		end
	end
end

local box
local button

function love.draw()
	
	for i = 1, #boxes do
		box = boxes[i]
		love.graphics.setColor(255,255,255,255)
		love.graphics.print(box.label, box.x + box.tx, box.y + box.ty)

		if box.found then
			love.graphics.setColor(20,220,30,255)
		elseif box.selected then
			love.graphics.setColor(200,200,200,255)
		else
			love.graphics.setColor(30,40,100,255)
		end
		love.graphics.rectangle("fill", box.x-4, box.y-4, box.width+8, box.height+8)
		love.graphics.setColor(50,80,180,255)
		love.graphics.rectangle("fill", box.x, box.y, box.width, box.height)
		love.graphics.setColor(0,0,0)
		love.graphics.print(box.text, box.x, box.y)
	end

	for i = 1, #buttons do
		local button = buttons[i]
		love.graphics.setColor(255,255,255,255)
		love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)

	end
end