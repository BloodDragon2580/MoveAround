    local EventFrame = CreateFrame("Frame", "MacroFrameMover", UIParent)
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
        if name == 'Blizzard_MacroUI' then
            self:UnregisterAllEvents()
            local MFMacroFrame = MacroFrame
            self:SetParent(MFMacroFrame)
            self:SetSize(MFMacroFrame:GetWidth()-50, 15) -- -50 to not block the close button
            MFMacroFrame:ClearAllPoints()
            MFMacroFrame:SetPoint("TOP", self)
            MFMacroFrame.ClearAllPoints = function() end
            MFMacroFrame.SetPoint = function() end
            self:Show()
        end
    end)
    EventFrame:RegisterEvent('ADDON_LOADED')