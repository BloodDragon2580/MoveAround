--InterfaceOptionsFrame
local IOFInterfaceOptionsFrame = InterfaceOptionsFrame
IOFInterfaceOptionsFrame.ClearAllPoints = function() end
IOFInterfaceOptionsFrame:SetPoint("TOPLEFT", 20, -100)
IOFInterfaceOptionsFrame.SetPoint = function() end
IOFInterfaceOptionsFrame:SetMovable(true)
IOFInterfaceOptionsFrame:SetUserPlaced(true)
IOFInterfaceOptionsFrame:SetClampedToScreen(true)

local MoveInterfaceOptionsFrame = CreateFrame("Frame", nil, IOFInterfaceOptionsFrame)  
MoveInterfaceOptionsFrame:SetHeight(15)
MoveInterfaceOptionsFrame:ClearAllPoints()
MoveInterfaceOptionsFrame:SetPoint("TOPLEFT", IOFInterfaceOptionsFrame)
MoveInterfaceOptionsFrame:SetPoint("TOPRIGHT", IOFInterfaceOptionsFrame)
MoveInterfaceOptionsFrame:EnableMouse(true)
MoveInterfaceOptionsFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveInterfaceOptionsFrame:RegisterForDrag("LeftButton")
MoveInterfaceOptionsFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		IOFInterfaceOptionsFrame:StartMoving()
	end
end)
MoveInterfaceOptionsFrame:SetScript("OnDragStop", function(self, button)
	IOFInterfaceOptionsFrame:StopMovingOrSizing()
end)
--InterfaceOptionsFrame