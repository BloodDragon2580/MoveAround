--QuestLogPopupDetailFrame
local QLPDFQuestLogPopupDetailFrame = QuestLogPopupDetailFrame
QLPDFQuestLogPopupDetailFrame.ClearAllPoints = function() end
QLPDFQuestLogPopupDetailFrame:SetPoint("TOPLEFT", 20, -100)
QLPDFQuestLogPopupDetailFrame.SetPoint = function() end
QLPDFQuestLogPopupDetailFrame:SetMovable(true)
QLPDFQuestLogPopupDetailFrame:SetUserPlaced(true)
QLPDFQuestLogPopupDetailFrame:SetClampedToScreen(true)

local MoveQuestLogPopupDetailFrame = CreateFrame("Frame", nil, QLPDFQuestLogPopupDetailFrame)  
MoveQuestLogPopupDetailFrame:SetHeight(15)
MoveQuestLogPopupDetailFrame:ClearAllPoints()
MoveQuestLogPopupDetailFrame:SetPoint("TOPLEFT", QLPDFQuestLogPopupDetailFrame)
MoveQuestLogPopupDetailFrame:SetPoint("TOPRIGHT", QLPDFQuestLogPopupDetailFrame)
MoveQuestLogPopupDetailFrame:EnableMouse(true)
MoveQuestLogPopupDetailFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveQuestLogPopupDetailFrame:RegisterForDrag("LeftButton")
MoveQuestLogPopupDetailFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		QLPDFQuestLogPopupDetailFrame:StartMoving()
	end
end)
MoveQuestLogPopupDetailFrame:SetScript("OnDragStop", function(self, button)
	QLPDFQuestLogPopupDetailFrame:StopMovingOrSizing()
end)
--QuestLogPopupDetailFrame