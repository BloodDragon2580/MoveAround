--TradeFrame
local MTF = TradeFrame
MTF.ClearAllPoints = function() end
MTF:SetPoint("TOPLEFT", 20, -100)
MTF.SetPoint = function() end
MTF:SetMovable(true)
MTF:SetUserPlaced(true)
MTF:SetClampedToScreen(true)

local MoveTradeFrame = CreateFrame("Frame", nil, MTF)  
MoveTradeFrame:SetHeight(15)
MoveTradeFrame:ClearAllPoints()
MoveTradeFrame:SetPoint("TOPLEFT", MTF)
MoveTradeFrame:SetPoint("TOPRIGHT", MTF)
MoveTradeFrame:EnableMouse(true)
MoveTradeFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveTradeFrame:RegisterForDrag("LeftButton")
MoveTradeFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		MTF:StartMoving()
	end
end)
MoveTradeFrame:SetScript("OnDragStop", function(self, button)
	MTF:StopMovingOrSizing()
end)
--TradeFrame