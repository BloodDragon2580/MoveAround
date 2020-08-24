--TaxiFrame
local MTF = TaxiFrame
MTF.ClearAllPoints = function() end
MTF:SetPoint("TOPLEFT", 20, -100)
MTF.SetPoint = function() end
MTF:SetMovable(true)
MTF:SetUserPlaced(true)
MTF:SetClampedToScreen(true)

local MoveTaxiFrame = CreateFrame("Frame", nil, MTF)  
MoveTaxiFrame:SetHeight(15)
MoveTaxiFrame:ClearAllPoints()
MoveTaxiFrame:SetPoint("TOPLEFT", MTF)
MoveTaxiFrame:SetPoint("TOPRIGHT", MTF)
MoveTaxiFrame:EnableMouse(true)
MoveTaxiFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveTaxiFrame:RegisterForDrag("LeftButton")
MoveTaxiFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		MTF:StartMoving()
	end
end)
MoveTaxiFrame:SetScript("OnDragStop", function(self, button)
	MTF:StopMovingOrSizing()
end)
--TaxiFrame