--ObjectiveTrackerFrame
local QT = ObjectiveTrackerFrame
QT.ClearAllPoints = function() end
QT:SetPoint("TOPRIGHT", MinimapCluster, "BOTTOM", 45, -5) 
QT.SetPoint = function() end
QT:SetMovable(true)
QT:SetUserPlaced(true)
QT:SetClampedToScreen(true)
QT:SetHeight(550)
QT:SetWidth(190)

local MoveObjectiveTrackerFrame = CreateFrame("Frame", nil, QT)  
MoveObjectiveTrackerFrame:SetHeight(15)
MoveObjectiveTrackerFrame:ClearAllPoints()
MoveObjectiveTrackerFrame:SetPoint("TOPLEFT", QT)
MoveObjectiveTrackerFrame:SetPoint("TOPRIGHT", QT)
MoveObjectiveTrackerFrame:EnableMouse(true)
MoveObjectiveTrackerFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveObjectiveTrackerFrame:RegisterForDrag("LeftButton")
MoveObjectiveTrackerFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		QT:StartMoving()
	end
end)
MoveObjectiveTrackerFrame:SetScript("OnDragStop", function(self, button)
	QT:StopMovingOrSizing()
end)
--ObjectiveTrackerFrame