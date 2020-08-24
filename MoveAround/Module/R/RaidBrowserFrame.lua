--RaidBrowserFrame
local RBFRaidBrowserFrame = RaidBrowserFrame
RBFRaidBrowserFrame.ClearAllPoints = function() end
RBFRaidBrowserFrame:SetPoint("TOPLEFT", 20, -100)
RBFRaidBrowserFrame.SetPoint = function() end
RBFRaidBrowserFrame:SetMovable(true)
RBFRaidBrowserFrame:SetUserPlaced(true)
RBFRaidBrowserFrame:SetClampedToScreen(true)

local MoveRaidBrowserFrame = CreateFrame("Frame", nil, RBFRaidBrowserFrame)  
MoveRaidBrowserFrame:SetHeight(15)
MoveRaidBrowserFrame:ClearAllPoints()
MoveRaidBrowserFrame:SetPoint("TOPLEFT", RBFRaidBrowserFrame)
MoveRaidBrowserFrame:SetPoint("TOPRIGHT", RBFRaidBrowserFrame)
MoveRaidBrowserFrame:EnableMouse(true)
MoveRaidBrowserFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveRaidBrowserFrame:RegisterForDrag("LeftButton")
MoveRaidBrowserFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		RBFRaidBrowserFrame:StartMoving()
	end
end)
MoveRaidBrowserFrame:SetScript("OnDragStop", function(self, button)
	RBFRaidBrowserFrame:StopMovingOrSizing()
end)
--RaidBrowserFrame