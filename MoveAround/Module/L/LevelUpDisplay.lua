--LevelUpDisplay
local LUDLevelUpDisplay = LevelUpDisplay
LUDLevelUpDisplay.ClearAllPoints = function() end
LUDLevelUpDisplay:SetPoint("TOPLEFT", 20, -100)
LUDLevelUpDisplay.SetPoint = function() end
LUDLevelUpDisplay:SetMovable(true)
LUDLevelUpDisplay:SetUserPlaced(true)
LUDLevelUpDisplay:SetClampedToScreen(true)

local MoveLevelUpDisplay = CreateFrame("Frame", nil, LUDLevelUpDisplay)  
MoveLevelUpDisplay:SetHeight(15)
MoveLevelUpDisplay:ClearAllPoints()
MoveLevelUpDisplay:SetPoint("TOPLEFT", LUDLevelUpDisplay)
MoveLevelUpDisplay:SetPoint("TOPRIGHT", LUDLevelUpDisplay)
MoveLevelUpDisplay:EnableMouse(true)
MoveLevelUpDisplay:SetHitRectInsets(-5, -5, -5, -5)
MoveLevelUpDisplay:RegisterForDrag("LeftButton")
MoveLevelUpDisplay:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		LUDLevelUpDisplay:StartMoving()
	end
end)
MoveLevelUpDisplay:SetScript("OnDragStop", function(self, button)
	LUDLevelUpDisplay:StopMovingOrSizing()
end)
--LevelUpDisplay