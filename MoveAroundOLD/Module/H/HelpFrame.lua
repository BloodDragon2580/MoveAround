--HelpFrame
local HFHelpFrame = HelpFrame
HFHelpFrame.ClearAllPoints = function() end
HFHelpFrame:SetPoint("TOPLEFT", 20, -100)
HFHelpFrame.SetPoint = function() end
HFHelpFrame:SetMovable(true)
HFHelpFrame:SetUserPlaced(true)
HFHelpFrame:SetClampedToScreen(true)

local MoveHelpFrame = CreateFrame("Frame", nil, HFHelpFrame)  
MoveHelpFrame:SetHeight(15)
MoveHelpFrame:ClearAllPoints()
MoveHelpFrame:SetPoint("TOPLEFT", HFHelpFrame)
MoveHelpFrame:SetPoint("TOPRIGHT", HFHelpFrame)
MoveHelpFrame:EnableMouse(true)
MoveHelpFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveHelpFrame:RegisterForDrag("LeftButton")
MoveHelpFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		HFHelpFrame:StartMoving()
	end
end)
MoveHelpFrame:SetScript("OnDragStop", function(self, button)
	HFHelpFrame:StopMovingOrSizing()
end)
--HelpFrame