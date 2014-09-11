




local eb = CreateFrame("Frame")

eb:SetSize(300,300)
eb:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 50, 100)
eb.bg = eb:CreateTexture()
eb.bg:SetTexture(30,30,30,200)
eb.bg:SetAllPoints(eb)
eb.bg:SetFrameStrata("LOW")

eb.mlb = CreateFrame("MultiLineEditBox", nil, eb)
eb.mlb:SetPoint("TOPLEFT",eb,"TOPLEFT", 5, 10)
eb.mlb:SetPoint("BOTTOMRIGHT",eb,"BOTTOMRIGHT", -5, -5)

eb.play = CreateFrame("Button", nil, eb)
eb.play:SetPushedTexture("Images/playdown.png")
eb.play:SetNormalTexture("Images/play.png")
eb.play:SetSize(16,16)
eb.play:SetPoint("BOTTOMLEFT", eb, "TOPLEFT", 0, 0)
eb.play:SetScript("OnMouseDown", function(self) eb.mlb:Export()  end)

function eb.mlb:Export()
	local s = ""
	
	for i = 1, #self.__VARS.lines do
		s = s..self.__VARS.lines[i].text.."\n"
	end
	
	self.proj = NewProject:Create("testing", s, true)
	self.proj:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 40, 100)

end


eb:SetScript("OnMouseDown", function(self, x, y, button) --drag or size
	if y-self:GetTop() < 30 then
		self:StartMoving()
	elseif y - self:GetBottom() > - 10 then
		self:StartSizing("BOTTOM")
	elseif x - self:GetLeft() < 10 then
		self:StartSizing("LEFT")
	elseif x - self:GetRight() > -10  then
		self:StartSizing("RIGHT")
	end
end)

eb:SetScript("OnMouseUp", function(self)
	self:StopMovingOrSizing()
end)

local luaedit = {}

return luaedit