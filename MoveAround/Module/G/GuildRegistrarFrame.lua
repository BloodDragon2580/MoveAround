--GuildRegistrarFrame
local GRFGuildRegistrarFrame = GuildRegistrarFrame
GRFGuildRegistrarFrame.ClearAllPoints = function() end
GRFGuildRegistrarFrame:SetPoint("TOPLEFT", 20, -100)
GRFGuildRegistrarFrame.SetPoint = function() end
GRFGuildRegistrarFrame:SetMovable(true)
GRFGuildRegistrarFrame:SetUserPlaced(true)
GRFGuildRegistrarFrame:SetClampedToScreen(true)

local MoveGuildRegistrarFrame = CreateFrame("Frame", nil, GRFGuildRegistrarFrame)  
MoveGuildRegistrarFrame:SetHeight(15)
MoveGuildRegistrarFrame:ClearAllPoints()
MoveGuildRegistrarFrame:SetPoint("TOPLEFT", GRFGuildRegistrarFrame)
MoveGuildRegistrarFrame:SetPoint("TOPRIGHT", GRFGuildRegistrarFrame)
MoveGuildRegistrarFrame:EnableMouse(true)
MoveGuildRegistrarFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveGuildRegistrarFrame:RegisterForDrag("LeftButton")
MoveGuildRegistrarFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		GRFGuildRegistrarFrame:StartMoving()
	end
end)
MoveGuildRegistrarFrame:SetScript("OnDragStop", function(self, button)
	GRFGuildRegistrarFrame:StopMovingOrSizing()
end)
--GuildRegistrarFrame