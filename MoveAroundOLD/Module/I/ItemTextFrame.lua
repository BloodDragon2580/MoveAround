--ItemTextFrame
local ITFItemTextFrame = ItemTextFrame
ITFItemTextFrame.ClearAllPoints = function() end
ITFItemTextFrame:SetPoint("TOPLEFT", 20, -100)
ITFItemTextFrame.SetPoint = function() end
ITFItemTextFrame:SetMovable(true)
ITFItemTextFrame:SetUserPlaced(true)
ITFItemTextFrame:SetClampedToScreen(true)

local MoveItemTextFrame = CreateFrame("Frame", nil, ITFItemTextFrame)  
MoveItemTextFrame:SetHeight(15)
MoveItemTextFrame:ClearAllPoints()
MoveItemTextFrame:SetPoint("TOPLEFT", ITFItemTextFrame)
MoveItemTextFrame:SetPoint("TOPRIGHT", ITFItemTextFrame)
MoveItemTextFrame:EnableMouse(true)
MoveItemTextFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveItemTextFrame:RegisterForDrag("LeftButton")
MoveItemTextFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		ITFItemTextFrame:StartMoving()
	end
end)
MoveItemTextFrame:SetScript("OnDragStop", function(self, button)
	ITFItemTextFrame:StopMovingOrSizing()
end)
--ItemTextFrame