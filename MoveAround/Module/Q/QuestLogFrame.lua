--QuestLogFrame
local QLFQuestLogFrame = QuestLogFrame
QLFQuestLogFrame.ClearAllPoints = function() end
QLFQuestLogFrame:SetPoint("TOPLEFT", 20, -100)
QLFQuestLogFrame.SetPoint = function() end
QLFQuestLogFrame:SetMovable(true)
QLFQuestLogFrame:SetUserPlaced(true)
QLFQuestLogFrame:SetClampedToScreen(true)

local MoveQuestLogFrame = CreateFrame("Frame", nil, QLFQuestLogFrame)  
MoveQuestLogFrame:SetHeight(15)
MoveQuestLogFrame:ClearAllPoints()
MoveQuestLogFrame:SetPoint("TOPLEFT", QLFQuestLogFrame)
MoveQuestLogFrame:SetPoint("TOPRIGHT", QLFQuestLogFrame)
MoveQuestLogFrame:EnableMouse(true)
MoveQuestLogFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveQuestLogFrame:RegisterForDrag("LeftButton")
MoveQuestLogFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		QLFQuestLogFrame:StartMoving()
	end
end)
MoveQuestLogFrame:SetScript("OnDragStop", function(self, button)
	QLFQuestLogFrame:StopMovingOrSizing()
end)
--QuestLogFrame