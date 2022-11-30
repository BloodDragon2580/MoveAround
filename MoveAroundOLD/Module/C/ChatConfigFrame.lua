--ChatConfigFrame
local CCFChatConfigFrame = ChatConfigFrame
CCFChatConfigFrame.ClearAllPoints = function() end
CCFChatConfigFrame:SetPoint("TOPLEFT", 20, -100)
CCFChatConfigFrame.SetPoint = function() end
CCFChatConfigFrame:SetMovable(true)
CCFChatConfigFrame:SetUserPlaced(true)
CCFChatConfigFrame:SetClampedToScreen(true)

local MoveChatConfigFrame = CreateFrame("Frame", nil, CCFChatConfigFrame)  
MoveChatConfigFrame:SetHeight(15)
MoveChatConfigFrame:ClearAllPoints()
MoveChatConfigFrame:SetPoint("TOPLEFT", CCFChatConfigFrame)
MoveChatConfigFrame:SetPoint("TOPRIGHT", CCFChatConfigFrame)
MoveChatConfigFrame:EnableMouse(true)
MoveChatConfigFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveChatConfigFrame:RegisterForDrag("LeftButton")
MoveChatConfigFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		CCFChatConfigFrame:StartMoving()
	end
end)
MoveChatConfigFrame:SetScript("OnDragStop", function(self, button)
	CCFChatConfigFrame:StopMovingOrSizing()
end)
--ChatConfigFrame