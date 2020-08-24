    local EventFrame = CreateFrame("Frame", "LookingForGuildFrameMover", UIParent)
    EventFrame:Hide()
    EventFrame:SetSize(50, 15)
    EventFrame:SetFrameStrata("HIGH")
    EventFrame:SetPoint("TOPLEFT", 20, -100)
    EventFrame:SetMovable(true)
    EventFrame:SetClampedToScreen(true)
    EventFrame:EnableMouse(true)
    EventFrame:SetHitRectInsets(-5, -5, -5, -5)
    EventFrame:RegisterForDrag("LeftButton")
    EventFrame:SetUserPlaced(true)
    EventFrame:SetScript("OnDragStart", function(self, button)
        if button=="LeftButton" and IsModifiedClick()then
            self:StartMoving()
        end
    end)
    EventFrame:SetScript("OnDragStop", function(self, button)
        self:StopMovingOrSizing()
    end)
    EventFrame:SetScript('OnEvent', function(self, event, name)
        if name == 'Blizzard_LookingForGuildUI' then
            self:UnregisterAllEvents()
            local LFGFLookingForGuildFrame = LookingForGuildFrame
            self:SetParent(LFGFLookingForGuildFrame)
            self:SetSize(LFGFLookingForGuildFrame:GetWidth()-50, 15) -- -50 to not block the close button
            LFGFLookingForGuildFrame:ClearAllPoints()
            LFGFLookingForGuildFrame:SetPoint("TOP", self)
            LFGFLookingForGuildFrame.ClearAllPoints = function() end
            LFGFLookingForGuildFrame.SetPoint = function() end
            self:Show()
        end
    end)
    EventFrame:RegisterEvent('ADDON_LOADED')