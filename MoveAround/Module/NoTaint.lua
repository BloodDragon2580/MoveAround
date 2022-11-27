if not NoTaint_Proc_ResetActionButtonAction then
    NoTaint_Proc_ResetActionButtonAction = 1

    local TXT_WARNING_WINDOW = "Action Bars are tainted\n/reload is RECOMMENDED"
    local TXT_WARNING_CHAT_MESSAGE = "|cffffff00MoveAround:|r Your action bars are tainted by [|cffffff00%s|r], reload UI to prevent further damage."
    local TXT_NOTICE_DISABLE = "Use |cffffff00'/movearound'|r to stop showing the warning message."
    local TXT_SLASH_SHOW = "|cffffff00MoveAround:|r Will show warnings again."
    local TXT_SLASH_STOP = "|cffffff00MoveAround:|r Never show warnings for this account. use |cffffff00'/movearound show'|r to undo."

    if LOCALE_deDE then
        TXT_WARNING_WINDOW = "Aktionsleisten sind verboten\n/reload wird EMPFOHLEN"
        TXT_WARNING_CHAT_MESSAGE = "|cffffff00MoveAround:|r Ihre Aktionsleisten sind von [|cffffff00%s|r] veboten, lade die Benutzeroberfläche neu, um weiteren Schaden zu verhindern."
        TXT_NOTICE_DISABLE = "Verwende |cffffff00'/movearound'|r, um die Anzeige der Warnmeldung zu stoppen."
        TXT_SLASH_SHOW = "|cffffff00MoveAround:|r Zeigt wieder Warnungen an."
        TXT_SLASH_STOP = "|cffffff00MoveAround:|r Niemals Warnungen für diesen Charakter anzeigen. Verwende |cffffff00'/movearound show'|r, um dies rückgängig zu machen."
    end

    SLASH_MOVEAROUND1 = "/movearound"
    SlashCmdList["MOVEAROUND"] = function(msg)
        if msg and msg:lower() == "show" then
            DEFAULT_CHAT_FRAME:AddMessage(TXT_SLASH_SHOW)
            notaintstop = nil
            if U1DBG then U1DBG.NT2S = nil end
        else
            DEFAULT_CHAT_FRAME:AddMessage(TXT_SLASH_STOP)
            notaintstop = 1
            if U1DBG then U1DBG.NT2S = 1 end
        end
    end

    local last = 0
    function NoTaint_ShowWarning(tainted_by)
        if GetTime() - last > 300 then
            local show_warn = true
            if U1DBG then show_warn = not U1DBG.NT2S else show_warn = not notaintstop end
            if show_warn then
                DEFAULT_CHAT_FRAME:AddMessage(format(TXT_WARNING_CHAT_MESSAGE, tainted_by))
            end
            if last == 0 and show_warn then
                InvasionAlertSystem:AddAlert(nil, TXT_WARNING_WINDOW, false, 0, 0)
                DEFAULT_CHAT_FRAME:AddMessage(TXT_NOTICE_DISABLE)
            end
            if show_warn then last = GetTime() end
        end
    end

    function NoTaint_ResetActionButtonAction(self)
        local ok, tainted_by = issecurevariable(self, "action")
        if not ok and not InCombatLockdown() then
            self.action=nil
            self:SetAttribute("_aby", "action")
            if self:IsVisible() then NoTaint_ShowWarning(tainted_by) end
        end
    end

    for _, v in ipairs(ActionBarButtonEventsFrame.frames) do
        hooksecurefunc(v, "UpdateAction", NoTaint_ResetActionButtonAction)
    end

    local f1 = CreateFrame("Frame")
    f1:RegisterEvent("PLAYER_REGEN_ENABLED")
    f1:SetScript("OnEvent", function(self, event, ...)
        for _, v in ipairs(ActionBarButtonEventsFrame.frames) do
            NoTaint_ResetActionButtonAction(v)
        end
    end)
end

if not NoTaint_CleanStaticPopups then
    function NoTaint_CleanStaticPopups()
        for index = 1, STATICPOPUP_NUMDIALOGS, 1 do
            local frame = _G["StaticPopup"..index];
            if not issecurevariable(frame, "which") then
                if frame:IsShown() then
                    local info = StaticPopupDialogs[frame.which];
                    if info and not issecurevariable(info, "OnCancel") then
                        info.OnCancel()
                    end
                    frame:Hide()
                end
                frame.which = nil
            end
        end
    end

    function NoTaint_CleanDropDownList()
        local frameToShow = LFDQueueFrameTypeDropDown
        local parent = frameToShow:GetParent()
        frameToShow:SetParent(nil)
        frameToShow:SetParent(parent)
    end

    local global_obj_name = {
        UIDROPDOWNMENU_MAXBUTTONS = 1,
        UIDROPDOWNMENU_MAXLEVELS = 1,
        UIDROPDOWNMENU_OPEN_MENU = 1,
        UIDROPDOWNMENU_INIT_MENU = 1,
        OBJECTIVE_TRACKER_UPDATE_REASON = 1,
    }

    function NoTaint_CleanGlobal(self)
        for k, _ in pairs(global_obj_name) do
            if not issecurevariable(k) then
                _G[k] = nil
            end
        end
    end

    hooksecurefunc(EditModeManagerFrame, "ClearActiveChangesFlags", function(self)
        for _, systemFrame in ipairs(self.registeredSystemFrames) do
            systemFrame:SetHasActiveChanges(nil);
        end
        self:SetHasActiveChanges(nil);
    end)

    hooksecurefunc(EditModeManagerFrame, "HideSystemSelections", function(self)
        if self.editModeActive == false then
            self.editModeActive = nil
        end
    end)

    hooksecurefunc(EditModeManagerFrame, "IsEditModeLocked", function()
        NoTaint_CleanGlobal()
    end)

    local function cleanAll()
        NoTaint_CleanDropDownList()
        NoTaint_CleanStaticPopups()
        NoTaint_CleanGlobal()
    end

    local Origin_IsShown = EditModeManagerFrame.IsShown
    hooksecurefunc(EditModeManagerFrame, "IsShown", function(self)
        if Origin_IsShown(self) then return end
        local stack = debugstack(4)
        if stack:find('[string "=[C]"]: in function `ShowUIPanel\'\n', 1, true) then
            cleanAll()
        end
    end)

    GameMenuButtonEditMode:HookScript("PreClick", cleanAll)
end

if not NoTaint_Proc_StopEnterWorldLayout then
    NoTaint_Proc_StopEnterWorldLayout = 1
    local f2 = CreateFrame("Frame")
    f2:RegisterEvent("PLAYER_LEAVING_WORLD")
    f2:RegisterEvent("PLAYER_ENTERING_WORLD")
    f2:SetScript("OnEvent", function(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD" then
            local login, reload = ...
            if not login and not reload then
                NoTaint_CleanDropDownList()
                NoTaint_CleanStaticPopups()
                NoTaint_CleanGlobal()
            end
            EditModeManagerFrame:RegisterEvent("EDIT_MODE_LAYOUTS_UPDATED")
        elseif event == "PLAYER_LEAVING_WORLD" then
            EditModeManagerFrame:UnregisterEvent("EDIT_MODE_LAYOUTS_UPDATED")
        end
    end)
end

if not NoTaint_Proc_CleanActionButtonFlyout then
    NoTaint_Proc_CleanActionButtonFlyout = 1
    local barsToUpdate = { MainMenuBar, MultiBarBottomLeft, MultiBarBottomRight, StanceBar, PetActionBar, PossessActionBar, MultiBarRight, MultiBarLeft, MultiBar5, MultiBar6, MultiBar7 }
    for _, bar in ipairs(barsToUpdate) do
        hooksecurefunc(bar, "UpdateSpellFlyoutDirection", function(self)
            if not issecurevariable(self, "flyoutDirection") then
                self.flyoutDirection = nil
            end
            if not issecurevariable(self, "snappedToFrame") then
                self.snappedToFrame = nil
            end
        end)
    end

    hooksecurefunc("SetClampedTextureRotation", function(texture)
        local parent = texture and texture:GetParent()
        if parent and parent.FlyoutArrowPushed and parent.FlyoutArrowHighlight then
            if not issecurevariable(texture, "rotationDegrees") then
                texture.rotationDegrees = nil
            end
        end
    end)
end
