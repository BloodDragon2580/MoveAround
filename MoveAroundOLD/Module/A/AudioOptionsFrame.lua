--AudioOptionsFrame
local AOFAudioOptionsFrame = AudioOptionsFrame
AOFAudioOptionsFrame.ClearAllPoints = function() end
AOFAudioOptionsFrame:SetPoint("TOPLEFT", 20, -100)
AOFAudioOptionsFrame.SetPoint = function() end
AOFAudioOptionsFrame:SetMovable(true)
AOFAudioOptionsFrame:SetUserPlaced(true)
AOFAudioOptionsFrame:SetClampedToScreen(true)

local MoveAudioOptionsFrame = CreateFrame("Frame", nil, AOFAudioOptionsFrame)  
MoveAudioOptionsFrame:SetHeight(15)
MoveAudioOptionsFrame:ClearAllPoints()
MoveAudioOptionsFrame:SetPoint("TOPLEFT", AOFAudioOptionsFrame)
MoveAudioOptionsFrame:SetPoint("TOPRIGHT", AOFAudioOptionsFrame)
MoveAudioOptionsFrame:EnableMouse(true)
MoveAudioOptionsFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveAudioOptionsFrame:RegisterForDrag("LeftButton")
MoveAudioOptionsFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		AOFAudioOptionsFrame:StartMoving()
	end
end)
MoveAudioOptionsFrame:SetScript("OnDragStop", function(self, button)
	AOFAudioOptionsFrame:StopMovingOrSizing()
end)
--AudioOptionsFrame