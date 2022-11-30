if not LibStub then error("MoveAround requires LibStub") end
local L = LibStub("AceLocale-3.0"):GetLocale("MoveAround", false)

if not MoveAroundOptions then MoveAroundOptions = {} end
local MoveAroundOptionsPanel = {}
MoveAroundOptionsPanel.config = {}

local isRetail = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)

local MOVEAROUND = "MOVEAROUND"
SLASH_MOVEAROUND1 = "/movearound"

local MOVEAROUNDRESET = "MOVEAROUNDRESET"
SLASH_MOVEAROUNDRESET1 = "/movearoundreset"

local function createCheckbox(name, point, relativeFrame, relativePoint, xOffset, yOffset, text, tooltipText)
	local checkbox = CreateFrame("CheckButton", name, relativeFrame, "ChatConfigCheckButtonTemplate")
	checkbox:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset)
	getglobal(checkbox:GetName() .. "Text"):SetText(text)
	checkbox.tooltip = tooltipText
	return checkbox
end

local function createButton(name, point, relativeFrame, relativePoint, xOffset, yOffset, width, height, text, tooltipText, onClickFunction)
	local button = CreateFrame("Button", name, relativeFrame, "GameMenuButtonTemplate")
	button:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset)
	button:SetSize(width, height)
	button:SetText(text)
	button:SetNormalFontObject("GameFontNormal")
	button:SetHighlightFontObject("GameFontHighlight")

	button.tooltipText = tooltipText
	button:SetScript(
		"OnEnter",
		function()
			GameTooltip:SetOwner(button, "ANCHOR_TOPRIGHT")
			GameTooltip:SetText(button.tooltipText, nil, nil, nil, nil, true)
		end
	)

	button:SetScript("OnClick", onClickFunction)

	return button
end

function MoveAroundHelpers:SetupConfig()
	if MoveAroundOptions.windowsDisabled == nil then
		MoveAroundOptions.windowsDisabled = false
	end
	if MoveAroundOptions.bagsDisabled == nil then
		MoveAroundOptions.bagsDisabled = true
	end
	if MoveAroundOptions.buttonsDisabled == nil then
		MoveAroundOptions.buttonsDisabled = true
	end
	if MoveAroundOptions.minimapDisabled == nil then
		MoveAroundOptions.minimapDisabled = true
	end
	if MoveAroundOptions.miscellaneousDisabled == nil then
		MoveAroundOptions.miscellaneousDisabled = true
	end

	MoveAroundOptionsPanel.optionspanel = CreateFrame("Frame", "MoveAroundOptionsPanel", UIParent)
	MoveAroundOptionsPanel.optionspanel.name = L["MoveAround"]
	local MoveAroundOptionsTitle = MoveAroundOptionsPanel.optionspanel:CreateFontString(nil, "BACKGROUND")
	MoveAroundOptionsTitle:SetFontObject("GameFontNormalLarge")
	MoveAroundOptionsTitle:SetText(L["MoveAround"])
	MoveAroundOptionsTitle:SetPoint("TOPLEFT", MoveAroundOptionsPanel.optionspanel, "TOPLEFT", 15, -15)
	InterfaceOptions_AddCategory(MoveAroundOptionsPanel.optionspanel)

	local frameToggleTitle = MoveAroundOptionsPanel.optionspanel:CreateFontString(nil, "BACKGROUND")
	frameToggleTitle:SetFontObject("GameFontNormal")
	frameToggleTitle:SetText(L["Enabled Frames"])
	frameToggleTitle:SetPoint("TOPLEFT", MoveAroundOptionsPanel.optionspanel, "TOPLEFT", 15, -90)

	yOffset = -110

	MoveAroundOptionsPanel.config.windowsEnabledCheckbox = createCheckbox(
		"WindowsEnabledCheckbox",
		"TOPLEFT",
		MoveAroundOptionsPanel.optionspanel,
		"TOPLEFT",
		15,
		yOffset,
		L["Windows"],
		L["Whether MoveAround will modify Windows (example: Talents)."]
	)
	MoveAroundOptionsPanel.config.windowsEnabledCheckbox:SetChecked(not MoveAroundOptions.windowsDisabled)
	yOffset = yOffset - 30

	MoveAroundOptionsPanel.config.bagsEnabledCheckbox = createCheckbox(
		"BagsEnabledCheckbox",
		"TOPLEFT",
		MoveAroundOptionsPanel.optionspanel,
		"TOPLEFT",
		15,
		yOffset,
		L["Bags"],
		L["Whether MoveAround will modify Bags."]
	)
	MoveAroundOptionsPanel.config.bagsEnabledCheckbox:SetChecked(not MoveAroundOptions.bagsDisabled)
	yOffset = yOffset - 30

	MoveAroundOptionsPanel.config.buttonsEnabledCheckbox = createCheckbox(
		"ButtonsEnabledCheckbox",
		"TOPLEFT",
		MoveAroundOptionsPanel.optionspanel,
		"TOPLEFT",
		15,
		yOffset,
		L["Buttons"],
		L["Whether MoveAround will modify Buttons (example: Open Ticket Button)."]
	)
	MoveAroundOptionsPanel.config.buttonsEnabledCheckbox:SetChecked(not MoveAroundOptions.buttonsDisabled)
	yOffset = yOffset - 30

	MoveAroundOptionsPanel.config.miscellaneousEnabledCheckbox = createCheckbox(
		"MiscellaneousEnabledCheckbox",
		"TOPLEFT",
		MoveAroundOptionsPanel.optionspanel,
		"TOPLEFT",
		15,
		yOffset,
		L["Miscellaneous"],
		L["Whether MoveAround will modify Miscellaneous Frames (example: QuestTracker)."]
	)
	MoveAroundOptionsPanel.config.miscellaneousEnabledCheckbox:SetChecked(not MoveAroundOptions.miscellaneousDisabled)

	StaticPopupDialogs["MoveAround_RESET_POSITIONS"] = {
		text = L["Are you sure you want to reset position for all modified frames?"],
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = MoveAroundHelpers.DeleteMoveAroundState,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
	}
	MoveAroundOptionsPanel.config.resetButton = createButton(
		"ResetButton",
		"TOPLEFT",
		MoveAroundOptionsPanel.optionspanel,
		"TOPLEFT",
		15,
		-47,
		150,
		25,
		L["Reset Frames"],
		L["Reset position for all modified frames."],
		function (self, button, down)
			StaticPopup_Show("MoveAround_RESET_POSITIONS")
		end
	)

	local updateFunction = function()
		local shouldReloadUI = false

		local oldWindowsDisabled = MoveAroundOptions.windowsDisabled
		MoveAroundOptions.windowsDisabled = not MoveAroundOptionsPanel.config.windowsEnabledCheckbox:GetChecked()
		if oldWindowsDisabled ~= MoveAroundOptions.windowsDisabled then
			shouldReloadUI = true
		end

		local oldBagsDisabled = MoveAroundOptions.bagsDisabled
		MoveAroundOptions.bagsDisabled = not MoveAroundOptionsPanel.config.bagsEnabledCheckbox:GetChecked()
		if oldBagsDisabled ~= MoveAroundOptions.bagsDisabled then
			if MoveAroundOptions.bagsDisabled then
				for i=1,13 do
					_G['ContainerFrame'..i]:ClearAllPoints()
					_G['ContainerFrame'..i]:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
				end
				if (ContainerFrameCombinedBags) then
					ContainerFrameCombinedBags:ClearAllPoints()
					ContainerFrameCombinedBags:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
				end
			end

			shouldReloadUI = true
		end

		local oldButtonsDisabled = MoveAroundOptions.buttonsDisabled
		MoveAroundOptions.buttonsDisabled = not MoveAroundOptionsPanel.config.buttonsEnabledCheckbox:GetChecked()
		if oldButtonsDisabled ~= MoveAroundOptions.buttonsDisabled then
			shouldReloadUI = true
		end

		local oldMiscellaneousDisabled = MoveAroundOptions.miscellaneousDisabled
		MoveAroundOptions.miscellaneousDisabled = not MoveAroundOptionsPanel.config.miscellaneousEnabledCheckbox:GetChecked()
		if oldMiscellaneousDisabled ~= MoveAroundOptions.miscellaneousDisabled then
			shouldReloadUI = true
		end

		if shouldReloadUI then
			ReloadUI()
		end
	end

	local cancelFunction = function()
		MoveAroundOptionsPanel.config.dragAltKeyEnabledCheckbox:SetChecked(MoveAroundOptions.dragAltKeyEnabled)
		MoveAroundOptionsPanel.config.dragCtrlKeyEnabledCheckbox:SetChecked(MoveAroundOptions.dragCtrlKeyEnabled)
		MoveAroundOptionsPanel.config.dragShiftKeyEnabledCheckbox:SetChecked(MoveAroundOptions.dragShiftKeyEnabled)

		MoveAroundOptionsPanel.config.windowsEnabledCheckbox:SetChecked(not MoveAroundOptions.windowsDisabled)
		MoveAroundOptionsPanel.config.bagsEnabledCheckbox:SetChecked(not MoveAroundOptions.bagsDisabled)
		MoveAroundOptionsPanel.config.buttonsEnabledCheckbox:SetChecked(not MoveAroundOptions.buttonsDisabled)
		MoveAroundOptionsPanel.config.miscellaneousEnabledCheckbox:SetChecked(not MoveAroundOptions.miscellaneousDisabled)
	end

	if (isRetail) then
		MoveAroundOptionsPanel.optionspanel:SetScript("OnHide", updateFunction)
	end
end


SlashCmdList[MOVEAROUND] = function(msg, editBox)
	MoveAroundHelpers:HandleSlashCommands(msg, editBox)
end

SlashCmdList[MOVEAROUNDRESET] = MoveAroundHelpers.DeleteMoveAroundState
