--TabardFrame
local TFTabardFrame = TabardFrame
TFTabardFrame.ClearAllPoints = function() end
TFTabardFrame:SetPoint("TOPLEFT", 20, -100)
TFTabardFrame.SetPoint = function() end
TFTabardFrame:SetMovable(true)
TFTabardFrame:SetUserPlaced(true)
TFTabardFrame:SetClampedToScreen(true)

local MoveTabardFrame = CreateFrame("Frame", nil, TFTabardFrame)  
MoveTabardFrame:SetHeight(15)
MoveTabardFrame:ClearAllPoints()
MoveTabardFrame:SetPoint("TOPLEFT", TFTabardFrame)
MoveTabardFrame:SetPoint("TOPRIGHT", TFTabardFrame)
MoveTabardFrame:EnableMouse(true)
MoveTabardFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveTabardFrame:RegisterForDrag("LeftButton")
MoveTabardFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		TFTabardFrame:StartMoving()
	end
end)
MoveTabardFrame:SetScript("OnDragStop", function(self, button)
	TFTabardFrame:StopMovingOrSizing()
end)
--TabardFrame