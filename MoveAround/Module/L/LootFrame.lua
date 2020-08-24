--LootFrame
local LFLootFrame = LootFrame
LFLootFrame.ClearAllPoints = function() end
LFLootFrame:SetPoint("TOPLEFT", 20, -100)
LFLootFrame.SetPoint = function() end
LFLootFrame:SetMovable(true)
LFLootFrame:SetUserPlaced(true)
LFLootFrame:SetClampedToScreen(true)

local MoveLootFrame = CreateFrame("Frame", nil, LFLootFrame)  
MoveLootFrame:SetHeight(15)
MoveLootFrame:ClearAllPoints()
MoveLootFrame:SetPoint("TOPLEFT", LFLootFrame)
MoveLootFrame:SetPoint("TOPRIGHT", LFLootFrame)
MoveLootFrame:EnableMouse(true)
MoveLootFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveLootFrame:RegisterForDrag("LeftButton")
MoveLootFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		LFLootFrame:StartMoving()
	end
end)
MoveLootFrame:SetScript("OnDragStop", function(self, button)
	LFLootFrame:StopMovingOrSizing()
end)
--LootFrame