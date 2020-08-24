--BattlefieldFrame
local BFBattlefieldFrame = BattlefieldFrame
BFBattlefieldFrame.ClearAllPoints = function() end
BFBattlefieldFrame:SetPoint("TOPLEFT", 20, -100)
BFBattlefieldFrame.SetPoint = function() end
BFBattlefieldFrame:SetMovable(true)
BFBattlefieldFrame:SetUserPlaced(true)
BFBattlefieldFrame:SetClampedToScreen(true)

local MoveBattlefieldFrame = CreateFrame("Frame", nil, BFBattlefieldFrame)  
MoveBattlefieldFrame:SetHeight(15)
MoveBattlefieldFrame:ClearAllPoints()
MoveBattlefieldFrame:SetPoint("TOPLEFT", BFBattlefieldFrame)
MoveBattlefieldFrame:SetPoint("TOPRIGHT", BFBattlefieldFrame)
MoveBattlefieldFrame:EnableMouse(true)
MoveBattlefieldFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveBattlefieldFrame:RegisterForDrag("LeftButton")
MoveBattlefieldFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		BFBattlefieldFrame:StartMoving()
	end
end)
MoveBattlefieldFrame:SetScript("OnDragStop", function(self, button)
	BFBattlefieldFrame:StopMovingOrSizing()
end)
--BattlefieldFrame