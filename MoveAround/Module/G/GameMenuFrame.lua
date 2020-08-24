--GameMenuFrame
local MGMF = GameMenuFrame
MGMF.ClearAllPoints = function() end
MGMF:SetPoint("TOPLEFT", 20, -100)
MGMF.SetPoint = function() end
MGMF:SetMovable(true)
MGMF:SetUserPlaced(true)
MGMF:SetClampedToScreen(true)

local MoveGameMenuFrame = CreateFrame("Frame", nil, MGMF)  
MoveGameMenuFrame:SetHeight(15)
MoveGameMenuFrame:ClearAllPoints()
MoveGameMenuFrame:SetPoint("TOPLEFT", MGMF)
MoveGameMenuFrame:SetPoint("TOPRIGHT", MGMF)
MoveGameMenuFrame:EnableMouse(true)
MoveGameMenuFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveGameMenuFrame:RegisterForDrag("LeftButton")
MoveGameMenuFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		MGMF:StartMoving()
	end
end)
MoveGameMenuFrame:SetScript("OnDragStop", function(self, button)
	MGMF:StopMovingOrSizing()
end)
--GameMenuFrame