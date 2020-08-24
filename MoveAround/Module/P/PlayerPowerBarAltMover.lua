--PlayerPowerBarAltMover
local PPBM = PlayerPowerBarAlt
PPBM.ClearAllPoints = function() end
PPBM:SetPoint("TOPLEFT", 20, -100)
PPBM.SetPoint = function() end
PPBM:SetMovable(true)
PPBM:SetUserPlaced(true)
PPBM:SetClampedToScreen(true)
PPBM:SetHeight(550)
PPBM:SetWidth(190)

local MovePlayerPowerBarAltMover = CreateFrame("Frame", nil, PPBM)  
MovePlayerPowerBarAltMover:SetHeight(15)
MovePlayerPowerBarAltMover:ClearAllPoints()
MovePlayerPowerBarAltMover:SetPoint("TOPLEFT", PPBM)
MovePlayerPowerBarAltMover:SetPoint("TOPRIGHT", PPBM)
MovePlayerPowerBarAltMover:EnableMouse(true)
MovePlayerPowerBarAltMover:SetHitRectInsets(-5, -5, -5, -5)
MovePlayerPowerBarAltMover:RegisterForDrag("LeftButton")
MovePlayerPowerBarAltMover:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		PPBM:StartMoving()
	end
end)
MovePlayerPowerBarAltMover:SetScript("OnDragStop", function(self, button)
	PPBM:StopMovingOrSizing()
end)
--PlayerPowerBarAltMover