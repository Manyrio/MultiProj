--[[
notes:
if the width changes, the canvas's will need to be renewed
need to 


--]]




local tinsert = table.insert
local floor = math.floor

local UIParent = require "GUI"



local f = CreateFrame("Frame")
f:SetSize(300, 300)
f:SetPoint("TOPLEFT", UIParent, "TOPLEFT",0,0)
f:EnableMouse(true)
f:EnableKeyboard(true)


f.lines = {}

f.fontheight = 12

f.t = f:CreateTexture()
f.t:SetTexture(100,120,255,255)
f.t:SetAllPoints(f)

f.lineheight = 12


f:SetScript("OnKeyDown", function(self, key,uni) self.selectedline:KeyPressed(key, uni) end)


f:SetScript("OnMouseDown", function() end)
f:SetScript("OnMouseUp", function(self, x, y, button)
	local line = floor((y - self:GetTop())/self.lineheight)
	if f.lines[line+1] then -- +1 as index starts at 1 not 0
		f:SelectLine(line+1)
		local charwidth = (love.graphics.getFont():getWidth(f.selectedline.text)/f.selectedline.text:len())
		local cpos = floor(((x-self:GetLeft())/charwidth))
		f.selectedline.cpos = math.min(cpos, f.selectedline.text:len())
	end
 end)

function f:SelectLine(index)
	for i = 1, #self.lines do
		local l = self.lines[i]
		if i == index then
			l.selected = true
		elseif l.selected then
			love.graphics.setCanvas(l.buffer)
			love.graphics.print(l.text, 0,0)
			love.graphics.setCanvas()
		else
			l.selected = nil
		end
	end

	self.selectedline.selected = true
end
		

function f.newline(position, text)
	if type(position) == "string" then
		text = position
		position = #f.lines+1
	elseif not position then
		position = #f.lines+1
		text = ""
	end

	local l = CreateFrame("Frame", nil, f)
	l.text = text or ""
	l.cpos = 0 --cursor position
	l.index = position
	
	
	function l:GetText()
		return self.text
	end
	

	

	f:SetScript("OnDraw", function (self)
		for i = 1, #self.lines do
			local l = self.lines[i]
			love.graphics.print(l.text, l:GetLeft(), l:GetTop())
				if l.selected then
					local f = love.graphics.getFont()
					local x = l:GetLeft()+f:getWidth(l.text:sub(1, l.cpos))
					love.graphics.line(l:GetLeft()+x, l:GetTop(), l:GetLeft()+x, l:GetBottom())
				else
					love.graphics.draw(l.buffer, l:GetLeft(), l:GetTop())
				end
		end
	end)
	
	function l:KeyPressed(key,uni)
		if key == "left" then
			if self.cpos == 0 then
				if self.index > 1 then
					f:SelectLine(self.index-1)
					f.selectedline.cpos = f.selectedline.text:len()
				end
			else
				self.cpos = self.cpos - 1
			end
		elseif key == "right" then
			if self.cpos == self.text:len() then
				if self.index < #f.lines then
					f:SelectLine(self.index+1)
					f.selectedline.cpos = 0
				end
			else
				self.cpos = self.cpos + 1
			end
		elseif key == 'backspace' then
			if self.cpos == 0 then
				if self.index > 1 then
					f:SelectLine(self.index-1)
					f.selectedline.cpos = f.selectedline.text:len()
					f.selectedline.text = f.selectedline.text..self.text
					
					table.remove(f.lines, self.index)
					for i = 2, #f.lines do
						f.lines[i]:SetPoint("TOPLEFT", f.lines[i-1], "BOTTOMLEFT")
						f.lines[i].index = i
					end
				end
			else
				self.text = self.text:sub(1, self.cpos-1)..self.text:sub(self.cpos+1)
				self.cpos = self.cpos - 1
			end
		elseif key == "up" then
			if self.index > 1 then
				f:SelectLine(self.index-1)
				f.selectedline.cpos = math.min(f.selectedline.text:len(), self.cpos)
			end
		elseif key == "down" then
			if self.index < #f.lines then
				f:SelectLine(self.index+1)
				f.selectedline.cpos = math.min(f.selectedline.text:len(), self.cpos)
			end
		elseif key == "return" then
			
			f.newline(self.index+1, self.text:sub(self.cpos+1))
			self.text = self.text:sub(1, self.cpos)
		elseif uni > 31 and uni < 127 then
			self.cpos = self.cpos+1
			self.text = self.text:sub(1, self.cpos-1)..string.char(uni)..self.text:sub(self.cpos)
		end
	end
	
	if #f.lines <1 then
		l:SetPoint("TOPLEFT", f, "TOPLEFT")
		l:SetHeight(12)
		l:SetPoint("RIGHT", f, "RIGHT")
		
		f.selectedline = l
	else
		l:SetPoint("TOPLEFT", f.lines[position-1], "BOTTOMLEFT")
		l:SetHeight(12)
		l:SetPoint("RIGHT", f, "RIGHT")
	end
	
	if position < #f.lines then
		table.insert(f.lines, position,l)
		f.lines[1]:SetPoint("TOPLEFT", f, "TOPLEFT")
		for i = 2, #f.lines do
			f.lines[i]:SetPoint("TOPLEFT", f.lines[i-1], "BOTTOMLEFT")
			f.lines[i].index = i
		end
	else
		table.insert(f.lines,position,l)
	end
	print(position)
	f:SelectLine(position)
end

f.newline("test string")





function love.update(dt)
  UIParent:update(dt)
end

function love.mousepressed(x,y,button)
  UIParent:mousepressed(x,y,button)
end

function love.mousereleased(x,y,button)
  UIParent:mousereleased(x,y,button)
end

function love.keypressed(key, uni)
  UIParent:keypressed(key, uni)
end

function love.keyreleased(key, uni)
  UIParent:keyreleased(key,uni)
end

function love.draw() 
  UIParent:draw()
end


