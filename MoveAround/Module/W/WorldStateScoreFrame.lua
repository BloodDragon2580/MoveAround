--WorldStateScoreFrame
local WSSFWorldStateScoreFrame = WorldStateScoreFrame
WSSFWorldStateScoreFrame.ClearAllPoints = function() end
WSSFWorldStateScoreFrame:SetPoint("TOPLEFT", 20, -100)
WSSFWorldStateScoreFrame.SetPoint = function() end
WSSFWorldStateScoreFrame:SetMovable(true)
WSSFWorldStateScoreFrame:SetUserPlaced(true)
WSSFWorldStateScoreFrame:SetClampedToScreen(true)

local MoveWorldStateScoreFrame = CreateFrame("Frame", nil, WSSFWorldStateScoreFrame)  
MoveWorldStateScoreFrame:SetHeight(15)
MoveWorldStateScoreFrame:ClearAllPoints()
MoveWorldStateScoreFrame:SetPoint("TOPLEFT", WSSFWorldStateScoreFrame)
MoveWorldStateScoreFrame:SetPoint("TOPRIGHT", WSSFWorldStateScoreFrame)
MoveWorldStateScoreFrame:EnableMouse(true)
MoveWorldStateScoreFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveWorldStateScoreFrame:RegisterForDrag("LeftButton")
MoveWorldStateScoreFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		WSSFWorldStateScoreFrame:StartMoving()
	end
end)
MoveWorldStateScoreFrame:SetScript("OnDragStop", function(self, button)
	WSSFWorldStateScoreFrame:StopMovingOrSizing()
end)
--WorldStateScoreFrame