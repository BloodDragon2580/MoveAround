--PVEFrame
local PVEF = PVEFrame
PVEF.ClearAllPoints = function() end
PVEF:SetPoint("TOPLEFT", 20, -100)
PVEF.SetPoint = function() end
PVEF:SetMovable(true)
PVEF:SetUserPlaced(true)
PVEF:SetClampedToScreen(true)

local MovePVEFrame = CreateFrame("Frame", nil, PVEF)  
MovePVEFrame:SetHeight(15)
MovePVEFrame:ClearAllPoints()
MovePVEFrame:SetPoint("TOPLEFT", PVEF)
MovePVEFrame:SetPoint("TOPRIGHT", PVEF)
MovePVEFrame:EnableMouse(true)
MovePVEFrame:SetHitRectInsets(-5, -5, -5, -5)
MovePVEFrame:RegisterForDrag("LeftButton")
MovePVEFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		PVEF:StartMoving()
	end
end)
MovePVEFrame:SetScript("OnDragStop", function(self, button)
	PVEF:StopMovingOrSizing()
end)
--PVEFrame