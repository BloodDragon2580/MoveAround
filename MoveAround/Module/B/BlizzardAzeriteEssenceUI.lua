    local EventFrame = CreateFrame("Frame", "AzeriteEssenceUIMOVER", UIParent)
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
        if name == 'Blizzard_AzeriteEssenceUI' then
            self:UnregisterAllEvents()
            local MAEU = AzeriteEssenceUI
            self:SetParent(MAEU)
            self:SetSize(MAEU:GetWidth()-50, 15) -- -50 to not block the close button
            MAEU:ClearAllPoints()
            MAEU:SetPoint("TOP", self)
            MAEU.ClearAllPoints = function() end
            MAEU.SetPoint = function() end
            self:Show()
        end
    end)
    EventFrame:RegisterEvent('ADDON_LOADED')