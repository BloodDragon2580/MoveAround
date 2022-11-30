--BankFrame
local BFBankFrame = BankFrame
BFBankFrame.ClearAllPoints = function() end
BFBankFrame:SetPoint("TOPLEFT", 20, -100)
BFBankFrame.SetPoint = function() end
BFBankFrame:SetMovable(true)
BFBankFrame:SetUserPlaced(true)
BFBankFrame:SetClampedToScreen(true)

local MoveBankFrame = CreateFrame("Frame", nil, BFBankFrame)  
MoveBankFrame:SetHeight(15)
MoveBankFrame:ClearAllPoints()
MoveBankFrame:SetPoint("TOPLEFT", BFBankFrame)
MoveBankFrame:SetPoint("TOPRIGHT", BFBankFrame)
MoveBankFrame:EnableMouse(true)
MoveBankFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveBankFrame:RegisterForDrag("LeftButton")
MoveBankFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		BFBankFrame:StartMoving()
	end
end)
MoveBankFrame:SetScript("OnDragStop", function(self, button)
	BFBankFrame:StopMovingOrSizing()
end)
--BankFrame