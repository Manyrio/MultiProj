

--[[
load projects, etc


--]]


local projectlist

if love.filesystem.exists("projectlist.txt") then
	--open it
else
	projectlist = ""
end

local import = love.filesystem.enumerate("import")
local new = {}


for i = 1, #import do
	if not projectlist:find("$"..import[i].."\n") then
		new[#new+1] = import[i]
	end
end
		

local fs = CreateFrame("Frame", nil, Canvas)
fs.b = fs:CreateTexture()
fs.b:SetTexture(100,100,100,255)
fs.b:SetPoint("TOPLEFT", fs, "TOPLEFT", 10, 10)
fs.b:SetPoint("BOTTOMRIGHT", fs, "BOTTOMRIGHT", -10, -10)
fs:SetBackdrop({
		edgeFile = "images/project-border.png",
		edgeSize = 16,
		insets = {left = 4,right = 4, top = 4, bottom = 4}

	})
fs:SetSize(300,300)
fs:SetPoint("TOPLEFT", Canvas, "TOPLEFT", 30, 30)
fs:SetFrameStrata("HIGH")
		
		
if #new > 0 then


end