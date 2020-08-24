--WorldMapFrame
local WMF = WorldMapFrame
WMF.ClearAllPoints = function() end
WMF:SetPoint("TOPLEFT", 20, -100)
WMF.SetPoint = function() end
WMF:SetMovable(true)
WMF:SetUserPlaced(true)
WMF:SetClampedToScreen(true)

local MoveWorldMapFrame = CreateFrame("Frame", nil, WMF)  
MoveWorldMapFrame:SetHeight(15)
MoveWorldMapFrame:ClearAllPoints()
MoveWorldMapFrame:SetPoint("TOPLEFT", WMF)
MoveWorldMapFrame:SetPoint("TOPRIGHT", WMF)
MoveWorldMapFrame:EnableMouse(true)
MoveWorldMapFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveWorldMapFrame:RegisterForDrag("LeftButton")
MoveWorldMapFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		WMF:StartMoving()
	end
end)
MoveWorldMapFrame:SetScript("OnDragStop", function(self, button)
	WMF:StopMovingOrSizing()
end)
--WorldMapFrame