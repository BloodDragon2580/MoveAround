--MerchantFrame
local MMF = MerchantFrame
MMF.ClearAllPoints = function() end
MMF:SetPoint("TOPLEFT", 20, -100)
MMF.SetPoint = function() end
MMF:SetMovable(true)
MMF:SetUserPlaced(true)
MMF:SetClampedToScreen(true)

local MoveMerchantFrame = CreateFrame("Frame", nil, MMF)  
MoveMerchantFrame:SetHeight(15)
MoveMerchantFrame:ClearAllPoints()
MoveMerchantFrame:SetPoint("TOPLEFT", MMF)
MoveMerchantFrame:SetPoint("TOPRIGHT", MMF)
MoveMerchantFrame:EnableMouse(true)
MoveMerchantFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveMerchantFrame:RegisterForDrag("LeftButton")
MoveMerchantFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		MMF:StartMoving()
	end
end)
MoveMerchantFrame:SetScript("OnDragStop", function(self, button)
	MMF:StopMovingOrSizing()
end)
--MerchantFrame