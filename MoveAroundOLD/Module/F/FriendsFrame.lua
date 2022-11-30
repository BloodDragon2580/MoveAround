--FriendsFrame
local MFF = FriendsFrame
MFF.ClearAllPoints = function() end
MFF:SetPoint("TOPLEFT", 20, -100)
MFF.SetPoint = function() end
MFF:SetMovable(true)
MFF:SetUserPlaced(true)
MFF:SetClampedToScreen(true)

local MoveFriendsFrame = CreateFrame("Frame", nil, MFF)  
MoveFriendsFrame:SetHeight(15)
MoveFriendsFrame:ClearAllPoints()
MoveFriendsFrame:SetPoint("TOPLEFT", MFF)
MoveFriendsFrame:SetPoint("TOPRIGHT", MFF)
MoveFriendsFrame:EnableMouse(true)
MoveFriendsFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveFriendsFrame:RegisterForDrag("LeftButton")
MoveFriendsFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		MFF:StartMoving()
	end
end)
MoveFriendsFrame:SetScript("OnDragStop", function(self, button)
	MFF:StopMovingOrSizing()
end)
--FriendsFrame