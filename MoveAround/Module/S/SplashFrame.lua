--SplashFrame
local SFSplashFrame = SplashFrame
SFSplashFrame.ClearAllPoints = function() end
SFSplashFrame:SetPoint("TOPLEFT", 20, -100)
SFSplashFrame.SetPoint = function() end
SFSplashFrame:SetMovable(true)
SFSplashFrame:SetUserPlaced(true)
SFSplashFrame:SetClampedToScreen(true)

local MoveSplashFrame = CreateFrame("Frame", nil, SFSplashFrame)  
MoveSplashFrame:SetHeight(15)
MoveSplashFrame:ClearAllPoints()
MoveSplashFrame:SetPoint("TOPLEFT", SFSplashFrame)
MoveSplashFrame:SetPoint("TOPRIGHT", SFSplashFrame)
MoveSplashFrame:EnableMouse(true)
MoveSplashFrame:SetHitRectInsets(-5, -5, -5, -5)
MoveSplashFrame:RegisterForDrag("LeftButton")
MoveSplashFrame:SetScript("OnDragStart", function(self, button)
	if button=="LeftButton" and IsModifiedClick()then
		SFSplashFrame:StartMoving()
	end
end)
MoveSplashFrame:SetScript("OnDragStop", function(self, button)
	SFSplashFrame:StopMovingOrSizing()
end)
--SplashFrame