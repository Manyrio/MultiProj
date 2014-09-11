




local NewProj = CreateFrame("Frame")

NewProj:SetSize(300, 100)
NewProj:SetPoint("TOPLEFT", UIParent, "TOPLEft", 200, 200)
NewProj.t = NewProj:CreateTexture()
NewProj.t:SetTexture(0,0,0,200)
NewProj.t:SetAllPoints(NewProj)

NewProj.title = NewProj:CreateFontString(10)
NewProj.title:SetPoint("TOPLEFT", NewProj, "TOPLEFT", 5, 5)
NewProj.title:SetSize(120, 20)
NewProj.title:SetText("Create Project")

NewProj:SetScript("OnMouseDown", function(self, x, y, button) --drag or size
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
	
NewProj:SetScript("OnMouseUp", function(self)
	self:StopMovingOrSizing()
end)

NewProj.namelabel = NewProj:CreateFontString(10)
NewProj.namelabel:SetPoint("TOPLEFT", NewProj, "TOPLEFT", 5, 40)
NewProj.namelabel:SetSize(120, 20)
NewProj.namelabel:SetText("Name")

NewProj.nameEB = CreateFrame("EditBox", nil, NewProj)
NewProj.nameEB:SetPoint("TOPLEFT", NewProj, "TOPLEFT", 45, 40)
NewProj.nameEB.t = NewProj.nameEB:CreateTexture()
NewProj.nameEB.t:SetTexture(20,20,20,240)
NewProj.nameEB.t:SetAllPoints(NewProj.nameEB)
NewProj.nameEB:SetSize(200, 20)
NewProj.nameEB:SetScript("OnEnterPressed", function(self) 
	ProjectLoader:Create(self:GetText(), CURRENT_USER)
	NewProj:Hide()
	
	if Client then
		Client:send("NP||"..self:GetText().."||name||"..CURRENT_USER.name)
	end
	
	self:SetText("")
end)





