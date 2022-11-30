--QuestFrame
local QFQuestFrame = QuestFrame
QFQuestFrame.ClearAllPoints = function() end
QFQuestFrame:SetPoint("TOPLEFT", 20, -100)
QFQuestFrame.SetPoint = function() end
QFQuestFrame:SetMovable(true)
QFQuestFrame:SetUserPlaced(true)
QFQuestFrame:SetClampedToScreen(true)

local MoveQuestFrame = CreateFrame("Frame", nil, QFQuestFrame)  
MoveQuestFrame:SetHeight(15)
MoveQuestFrame:ClearAllPoints()
MoveQuestFrame:SetPoint("TOPLEFT", QFQuestFrame)
MoveQuestFrame:SetPoint("TOPRIGHT", QFQuestFrame)
MoveQuestFrame:EnableMouse(true)
MoveQuestFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveQuestFrame:RegisterForDrag("LeftButton")
MoveQuestFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		QFQuestFrame:StartMoving()
	end
end)
MoveQuestFrame:SetScript("OnDragStop", function(self, button)
	QFQuestFrame:StopMovingOrSizing()
end)
--QuestFrame