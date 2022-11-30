--DestinyFrame
local DFDestinyFrame = DestinyFrame
DFDestinyFrame.ClearAllPoints = function() end
DFDestinyFrame:SetPoint("TOPLEFT", 20, -100)
DFDestinyFrame.SetPoint = function() end
DFDestinyFrame:SetMovable(true)
DFDestinyFrame:SetUserPlaced(true)
DFDestinyFrame:SetClampedToScreen(true)

local MoveDestinyFrame = CreateFrame("Frame", nil, DFDestinyFrame)  
MoveDestinyFrame:SetHeight(15)
MoveDestinyFrame:ClearAllPoints()
MoveDestinyFrame:SetPoint("TOPLEFT", DFDestinyFrame)
MoveDestinyFrame:SetPoint("TOPRIGHT", DFDestinyFrame)
MoveDestinyFrame:EnableMouse(true)
MoveDestinyFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveDestinyFrame:RegisterForDrag("LeftButton")
MoveDestinyFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		DFDestinyFrame:StartMoving()
	end
end)
MoveDestinyFrame:SetScript("OnDragStop", function(self, button)
	DFDestinyFrame:StopMovingOrSizing()
end)
--DestinyFrame