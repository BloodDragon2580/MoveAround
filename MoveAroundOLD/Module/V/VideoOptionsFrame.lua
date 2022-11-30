--VideoOptionsFrame
local VOFVideoOptionsFrame = VideoOptionsFrame
VOFVideoOptionsFrame.ClearAllPoints = function() end
VOFVideoOptionsFrame:SetPoint("TOPLEFT", 20, -100)
VOFVideoOptionsFrame.SetPoint = function() end
VOFVideoOptionsFrame:SetMovable(true)
VOFVideoOptionsFrame:SetUserPlaced(true)
VOFVideoOptionsFrame:SetClampedToScreen(true)

local MoveVideoOptionsFrame = CreateFrame("Frame", nil, VOFVideoOptionsFrame)  
MoveVideoOptionsFrame:SetHeight(15)
MoveVideoOptionsFrame:ClearAllPoints()
MoveVideoOptionsFrame:SetPoint("TOPLEFT", VOFVideoOptionsFrame)
MoveVideoOptionsFrame:SetPoint("TOPRIGHT", VOFVideoOptionsFrame)
MoveVideoOptionsFrame:EnableMouse(true)
MoveVideoOptionsFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveVideoOptionsFrame:RegisterForDrag("LeftButton")
MoveVideoOptionsFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		VOFVideoOptionsFrame:StartMoving()
	end
end)
MoveVideoOptionsFrame:SetScript("OnDragStop", function(self, button)
	VOFVideoOptionsFrame:StopMovingOrSizing()
end)
--VideoOptionsFrame