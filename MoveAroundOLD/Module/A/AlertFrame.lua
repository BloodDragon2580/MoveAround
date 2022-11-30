--AlertFrame
local AFAlertFrame = AlertFrame
AFAlertFrame.ClearAllPoints = function() end
AFAlertFrame:SetPoint("TOPLEFT", 20, -100)
AFAlertFrame.SetPoint = function() end
AFAlertFrame:SetMovable(true)
AFAlertFrame:SetUserPlaced(true)
AFAlertFrame:SetClampedToScreen(true)

local MoveAlertFrame = CreateFrame("Frame", nil, AFAlertFrame)  
MoveAlertFrame:SetHeight(15)
MoveAlertFrame:ClearAllPoints()
MoveAlertFrame:SetPoint("TOPLEFT", AFAlertFrame)
MoveAlertFrame:SetPoint("TOPRIGHT", AFAlertFrame)
MoveAlertFrame:EnableMouse(true)
MoveAlertFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveAlertFrame:RegisterForDrag("LeftButton")
MoveAlertFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		AFAlertFrame:StartMoving()
	end
end)
MoveAlertFrame:SetScript("OnDragStop", function(self, button)
	AFAlertFrame:StopMovingOrSizing()
end)
--AlertFrame