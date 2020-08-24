--CraftFrame
local CFCraftFrame = CraftFrame
CFCraftFrame.ClearAllPoints = function() end
CFCraftFrame:SetPoint("TOPLEFT", 20, -100)
CFCraftFrame.SetPoint = function() end
CFCraftFrame:SetMovable(true)
CFCraftFrame:SetUserPlaced(true)
CFCraftFrame:SetClampedToScreen(true)

local MoveCraftFrame = CreateFrame("Frame", nil, CFCraftFrame)  
MoveCraftFrame:SetHeight(15)
MoveCraftFrame:ClearAllPoints()
MoveCraftFrame:SetPoint("TOPLEFT", CFCraftFrame)
MoveCraftFrame:SetPoint("TOPRIGHT", CFCraftFrame)
MoveCraftFrame:EnableMouse(true)
MoveCraftFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveCraftFrame:RegisterForDrag("LeftButton")
MoveCraftFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		CFCraftFrame:StartMoving()
	end
end)
MoveCraftFrame:SetScript("OnDragStop", function(self, button)
	CFCraftFrame:StopMovingOrSizing()
end)
--CraftFrame