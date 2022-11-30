--CinematicFrame
local CFCinematicFrame = CinematicFrame
CFCinematicFrame.ClearAllPoints = function() end
CFCinematicFrame:SetPoint("TOPLEFT", 20, -100)
CFCinematicFrame.SetPoint = function() end
CFCinematicFrame:SetMovable(true)
CFCinematicFrame:SetUserPlaced(true)
CFCinematicFrame:SetClampedToScreen(true)

local MoveCinematicFrame = CreateFrame("Frame", nil, CFCinematicFrame)  
MoveCinematicFrame:SetHeight(15)
MoveCinematicFrame:ClearAllPoints()
MoveCinematicFrame:SetPoint("TOPLEFT", CFCinematicFrame)
MoveCinematicFrame:SetPoint("TOPRIGHT", CFCinematicFrame)
MoveCinematicFrame:EnableMouse(true)
MoveCinematicFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveCinematicFrame:RegisterForDrag("LeftButton")
MoveCinematicFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		CFCinematicFrame:StartMoving()
	end
end)
MoveCinematicFrame:SetScript("OnDragStop", function(self, button)
	CFCinematicFrame:StopMovingOrSizing()
end)
--CinematicFrame