--RaidParentFrame
local RPFRaidParentFrame = RaidParentFrame
RPFRaidParentFrame.ClearAllPoints = function() end
RPFRaidParentFrame:SetPoint("TOPLEFT", 20, -100)
RPFRaidParentFrame.SetPoint = function() end
RPFRaidParentFrame:SetMovable(true)
RPFRaidParentFrame:SetUserPlaced(true)
RPFRaidParentFrame:SetClampedToScreen(true)

local MoveRaidParentFrame = CreateFrame("Frame", nil, RPFRaidParentFrame)  
MoveRaidParentFrame:SetHeight(15)
MoveRaidParentFrame:ClearAllPoints()
MoveRaidParentFrame:SetPoint("TOPLEFT", RPFRaidParentFrame)
MoveRaidParentFrame:SetPoint("TOPRIGHT", RPFRaidParentFrame)
MoveRaidParentFrame:EnableMouse(true)
MoveRaidParentFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveRaidParentFrame:RegisterForDrag("LeftButton")
MoveRaidParentFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		RPFRaidParentFrame:StartMoving()
	end
end)
MoveRaidParentFrame:SetScript("OnDragStop", function(self, button)
	RPFRaidParentFrame:StopMovingOrSizing()
end)
--RaidParentFrame