--VehicleSeatIndicator
local VSI = VehicleSeatIndicator
VSI.ClearAllPoints = function() end
VSI:SetPoint("TOPRIGHT", MinimapCluster, "BOTTOM", 45, -5) 
VSI.SetPoint = function() end
VSI:SetMovable(true)
VSI:SetUserPlaced(true)
VSI:SetClampedToScreen(true)

local MoveVehicleSeatIndicator = CreateFrame("Frame", nil, VSI)  
MoveVehicleSeatIndicator:SetHeight(15)
MoveVehicleSeatIndicator:ClearAllPoints()
MoveVehicleSeatIndicator:SetPoint("TOPLEFT", VSI)
MoveVehicleSeatIndicator:SetPoint("TOPRIGHT", VSI)
MoveVehicleSeatIndicator:EnableMouse(true)
MoveVehicleSeatIndicator:SetHitRectInsets(-5, -5, -5, -5)
MoveVehicleSeatIndicator:RegisterForDrag("LeftButton")
MoveVehicleSeatIndicator:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		VSI:StartMoving()
	end
end)
MoveVehicleSeatIndicator:SetScript("OnDragStop", function(self, button)
	VSI:StopMovingOrSizing()
end)
--VehicleSeatIndicator