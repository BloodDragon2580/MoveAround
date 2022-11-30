--SpellBookFrame
local SBF = SpellBookFrame
SBF.ClearAllPoints = function() end
SBF:SetPoint("TOPLEFT", 20, -100) 
SBF.SetPoint = function() end
SBF:SetMovable(true)
SBF:SetUserPlaced(true)
SBF:SetClampedToScreen(true)

local MoveSpellBookFrame = CreateFrame("Frame", nil, SBF)  
MoveSpellBookFrame:SetHeight(15)
MoveSpellBookFrame:ClearAllPoints()
MoveSpellBookFrame:SetPoint("TOPLEFT", SBF)
MoveSpellBookFrame:SetPoint("TOPRIGHT", SBF)
MoveSpellBookFrame:EnableMouse(true)
MoveSpellBookFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveSpellBookFrame:RegisterForDrag("LeftButton")
MoveSpellBookFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		SBF:StartMoving()
	end
end)
MoveSpellBookFrame:SetScript("OnDragStop", function(self, button)
	SBF:StopMovingOrSizing()
end)
--SpellBookFrame