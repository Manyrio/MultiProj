
local RightBar = CreateFrame("Frame",nil,Canvas)
RightBar:SetWidth(5)
RightBar:EnableMouse(true)
RightBar:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT")
RightBar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT")
RightBar.bg = RightBar:CreateTexture()
RightBar.bg:SetTexture(COLORS.bgc)
RightBar.bg:SetAllPoints(RightBar)
RightBar.edge = RightBar:CreateTexture()
RightBar.edge:SetTexture(COLORS.edgec)
RightBar.edge:SetPoint("TOPLEFT", RightBar, "TOPLEFT", 1, 1)
RightBar.edge:SetPoint("BOTTOMLEFT", RightBar, "BOTTOMLEFT", 1, -1)
RightBar.edge:SetWidth(2)


RightBar:SetScript("OnMouseDown", function(self,x) if x - self:GetLeft() <= 5 then self:StartSizing("LEFT") end end)
RightBar:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)

irc:SetPoint("TOPLEFT", RightBar, "TOPLEFT", 3, 0)
irc:SetPoint("BOTTOMRIGHT", RightBar, "BOTTOMRIGHT")
irc:SetParent(RightBar)


local BottomBar = CreateFrame("Frame",nil,Canvas)
BottomBar:SetHeight(5)
BottomBar:EnableMouse(true)
BottomBar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT")
BottomBar:SetPoint("BOTTOMRIGHT", RightBar, "BOTTOMLEFT")
BottomBar.bg = BottomBar:CreateTexture()
BottomBar.bg:SetTexture(COLORS.bgc)
BottomBar.bg:SetAllPoints(BottomBar)

BottomBar.edge = BottomBar:CreateTexture()
BottomBar.edge:SetTexture(COLORS.edgec)
BottomBar.edge:SetPoint("TOPLEFT", BottomBar, "TOPLEFT")
BottomBar.edge:SetPoint("TOPRIGHT", BottomBar, "TOPRIGHT")
BottomBar.edge:SetHeight(2)

BottomBar:SetScript("OnMouseDown", function(self,x,y) if y - self:GetTop() < 5 then self:StartSizing("TOP") end end)
BottomBar:SetScript("OnMouseUp", function(self,x,y) self:StopMovingOrSizing() end)

