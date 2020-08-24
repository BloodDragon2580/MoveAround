--MailFrame
local MMF = MailFrame
MMF.ClearAllPoints = function() end
MMF:SetPoint("TOPLEFT", 20, -100)
MMF.SetPoint = function() end
MMF:SetMovable(true)
MMF:SetUserPlaced(true)
MMF:SetClampedToScreen(true)

local MoveMailFrame = CreateFrame("Frame", nil, MMF)  
MoveMailFrame:SetHeight(15)
MoveMailFrame:ClearAllPoints()
MoveMailFrame:SetPoint("TOPLEFT", MMF)
MoveMailFrame:SetPoint("TOPRIGHT", MMF)
MoveMailFrame:EnableMouse(true)
MoveMailFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveMailFrame:RegisterForDrag("LeftButton")
MoveMailFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		MMF:StartMoving()
	end
end)
MoveMailFrame:SetScript("OnDragStop", function(self, button)
	MMF:StopMovingOrSizing()
end)
--MailFrame