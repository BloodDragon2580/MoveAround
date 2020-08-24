--GossipFrame
local GFGossipFrame = GossipFrame
GFGossipFrame.ClearAllPoints = function() end
GFGossipFrame:SetPoint("TOPLEFT", 20, -100)
GFGossipFrame.SetPoint = function() end
GFGossipFrame:SetMovable(true)
GFGossipFrame:SetUserPlaced(true)
GFGossipFrame:SetClampedToScreen(true)

local MoveGossipFrame = CreateFrame("Frame", nil, GFGossipFrame)  
MoveGossipFrame:SetHeight(15)
MoveGossipFrame:ClearAllPoints()
MoveGossipFrame:SetPoint("TOPLEFT", GFGossipFrame)
MoveGossipFrame:SetPoint("TOPRIGHT", GFGossipFrame)
MoveGossipFrame:EnableMouse(true)
MoveGossipFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveGossipFrame:RegisterForDrag("LeftButton")
MoveGossipFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		GFGossipFrame:StartMoving()
	end
end)
MoveGossipFrame:SetScript("OnDragStop", function(self, button)
	GFGossipFrame:StopMovingOrSizing()
end)
--GossipFrame