--DressUpFrame
local MDUF = DressUpFrame
MDUF.ClearAllPoints = function() end
MDUF:SetPoint("TOPLEFT", 20, -100)
MDUF.SetPoint = function() end
MDUF:SetMovable(true)
MDUF:SetUserPlaced(true)
MDUF:SetClampedToScreen(true)

local MoveDressUpFrame = CreateFrame("Frame", nil, MDUF)  
MoveDressUpFrame:SetHeight(15)
MoveDressUpFrame:ClearAllPoints()
MoveDressUpFrame:SetPoint("TOPLEFT", MDUF)
MoveDressUpFrame:SetPoint("TOPRIGHT", MDUF)
MoveDressUpFrame:EnableMouse(true)
MoveDressUpFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveDressUpFrame:RegisterForDrag("LeftButton")
MoveDressUpFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		MDUF:StartMoving()
	end
end)
MoveDressUpFrame:SetScript("OnDragStop", function(self, button)
	MDUF:StopMovingOrSizing()
end)
--DressUpFrame