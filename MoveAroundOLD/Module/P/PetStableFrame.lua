--PetStableFrame
local PSFPetStableFrame = PetStableFrame
PSFPetStableFrame.ClearAllPoints = function() end
PSFPetStableFrame:SetPoint("TOPLEFT", 20, -100)
PSFPetStableFrame.SetPoint = function() end
PSFPetStableFrame:SetMovable(true)
PSFPetStableFrame:SetUserPlaced(true)
PSFPetStableFrame:SetClampedToScreen(true)

local MovePetStableFrame = CreateFrame("Frame", nil, PSFPetStableFrame)  
MovePetStableFrame:SetHeight(15)
MovePetStableFrame:ClearAllPoints()
MovePetStableFrame:SetPoint("TOPLEFT", PSFPetStableFrame)
MovePetStableFrame:SetPoint("TOPRIGHT", PSFPetStableFrame)
MovePetStableFrame:EnableMouse(true)
MovePetStableFrame:SetHitRectInsets(-5, -5, -5, -5)
MovePetStableFrame:RegisterForDrag("LeftButton")
MovePetStableFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		PSFPetStableFrame:StartMoving()
	end
end)
MovePetStableFrame:SetScript("OnDragStop", function(self, button)
	PSFPetStableFrame:StopMovingOrSizing()
end)
--PetStableFrame