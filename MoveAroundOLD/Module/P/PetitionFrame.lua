--PetitionFrame
local PFPetitionFrame = PetitionFrame
PFPetitionFrame.ClearAllPoints = function() end
PFPetitionFrame:SetPoint("TOPLEFT", 20, -100)
PFPetitionFrame.SetPoint = function() end
PFPetitionFrame:SetMovable(true)
PFPetitionFrame:SetUserPlaced(true)
PFPetitionFrame:SetClampedToScreen(true)

local MovePetitionFrame = CreateFrame("Frame", nil, PFPetitionFrame)  
MovePetitionFrame:SetHeight(15)
MovePetitionFrame:ClearAllPoints()
MovePetitionFrame:SetPoint("TOPLEFT", PFPetitionFrame)
MovePetitionFrame:SetPoint("TOPRIGHT", PFPetitionFrame)
MovePetitionFrame:EnableMouse(true)
MovePetitionFrame:SetHitRectInsets(-5, -5, -5, -5)
MovePetitionFrame:RegisterForDrag("LeftButton")
MovePetitionFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		PFPetitionFrame:StartMoving()
	end
end)
MovePetitionFrame:SetScript("OnDragStop", function(self, button)
	PFPetitionFrame:StopMovingOrSizing()
end)
--PetitionFrame