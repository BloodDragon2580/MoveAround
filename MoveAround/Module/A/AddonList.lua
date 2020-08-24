--AddonList
local ALAddonList = AddonList
ALAddonList.ClearAllPoints = function() end
ALAddonList:SetPoint("TOPLEFT", 20, -100)
ALAddonList.SetPoint = function() end
ALAddonList:SetMovable(true)
ALAddonList:SetUserPlaced(true)
ALAddonList:SetClampedToScreen(true)

local ALAddonList = CreateFrame("Frame", nil, ALAddonList)  
ALAddonList:SetHeight(15)
ALAddonList:ClearAllPoints()
ALAddonList:SetPoint("TOPLEFT", ALAddonList)
ALAddonList:SetPoint("TOPRIGHT", ALAddonList)
ALAddonList:EnableMouse(true)
ALAddonList:SetHitRectInsets(-5, -5, -5, -5)
ALAddonList:RegisterForDrag("LeftButton")
ALAddonList:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		ALAddonList:StartMoving()
	end
end)
ALAddonList:SetScript("OnDragStop", function(self, button)
	ALAddonList:StopMovingOrSizing()
end)
--AddonList