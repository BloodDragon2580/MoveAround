--CharacterFrame
local CF = CharacterFrame
CF.ClearAllPoints = function() end
CF:SetPoint("TOPLEFT", 20, -100)
CF.SetPoint = function() end
CF:SetMovable(true)
CF:SetUserPlaced(true)
CF:SetClampedToScreen(true)

local MoveCharacterFrame = CreateFrame("Frame", nil, CF)  
MoveCharacterFrame:SetHeight(15)
MoveCharacterFrame:ClearAllPoints()
MoveCharacterFrame:SetPoint("TOPLEFT", CF)
MoveCharacterFrame:SetPoint("TOPRIGHT", CF)
MoveCharacterFrame:EnableMouse(true)
MoveCharacterFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveCharacterFrame:RegisterForDrag("LeftButton")
MoveCharacterFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		CF:StartMoving()
	end
end)
MoveCharacterFrame:SetScript("OnDragStop", function(self, button)
	CF:StopMovingOrSizing()
end)
--CharacterFrame