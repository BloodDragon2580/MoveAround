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

local InterfaceOptions_AddCategory = InterfaceOptions_AddCategory
if not InterfaceOptions_AddCategory then
	InterfaceOptions_AddCategory = function(frame, addOn, position)
		frame.OnCommit = frame.okay;
		frame.OnDefault = frame.default;
		frame.OnRefresh = frame.refresh;

		if frame.parent then
			local category = Settings.GetCategory(frame.parent);
			local subcategory, layout = Settings.RegisterCanvasLayoutSubcategory(category, frame, frame.name, frame.name);
			subcategory.ID = frame.name;
			return subcategory, category;
		else
			local category, layout = Settings.RegisterCanvasLayoutCategory(frame, frame.name, frame.name);
			category.ID = frame.name;
			Settings.RegisterAddOnCategory(category);
			return category;
		end
	end
end

function MoveAroundHelpers:SetupConfig()
	if MoveAroundOptions.frameDragIsLocked == nil then
		MoveAroundOptions.frameDragIsLocked = false
	end
	if MoveAroundOptions.frameScaleIsLocked == nil then
		MoveAroundOptions.frameScaleIsLocked = false
	end
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
	if MoveAroundOptions.objectivesDisabled == nil then
		MoveAroundOptions.objectivesDisabled = true
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

	local lockMoveTitle = MoveAroundOptionsPanel.optionspanel:CreateFontString(nil, "BACKGROUND")
	lockMoveTitle:SetFontObject("GameFontNormal")
	lockMoveTitle:SetText("Frame Dragging")
	lockMoveTitle:SetPoint("TOPLEFT", MoveAroundOptionsPanel.optionspanel, "TOPLEFT", 190, -90)

	local yOffset = -110

	MoveAroundOptionsPanel.config.frameMoveLockedCheckbox = createCheckbox(
		"FrameMoveLockedCheckbox",
		"TOPLEFT",
		MoveAroundOptionsPanel.optionspanel,
		"TOPLEFT",
		190,
		yOffset,
		L["Lock Frame Dragging"],
		L["While frame dragging is locked, a modifier key must be pressed to drag a frame."]
	)
	MoveAroundOptionsPanel.config.frameMoveLockedCheckbox:SetChecked(MoveAroundOptions.frameDragIsLocked)
	yOffset = yOffset - 30

	MoveAroundOptionsPanel.config.dragAltKeyEnabledCheckbox = createCheckbox(
		"DragAltKeyEnabledCheckbox",
		"TOPLEFT",
		MoveAroundOptionsPanel.optionspanel,
		"TOPLEFT",
		205,
		yOffset,
		L["ALT To Drag"],
		L["Whether ALT can be pressed while frame dragging is locked to drag a frame."]
	)
	MoveAroundOptionsPanel.config.dragAltKeyEnabledCheckbox:SetChecked(MoveAroundOptions.dragAltKeyEnabled)
	yOffset = yOffset - 30

	MoveAroundOptionsPanel.config.dragCtrlKeyEnabledCheckbox = createCheckbox(
		"DragCtrlKeyEnabledCheckbox",
		"TOPLEFT",
		MoveAroundOptionsPanel.optionspanel,
		"TOPLEFT",
		205,
		yOffset,
		L["CTRL To Drag"],
		L["Whether CTRL can be pressed while frame dragging is locked to drag a frame."]
	)
	MoveAroundOptionsPanel.config.dragCtrlKeyEnabledCheckbox:SetChecked(MoveAroundOptions.dragCtrlKeyEnabled)
	yOffset = yOffset - 30

	MoveAroundOptionsPanel.config.dragShiftKeyEnabledCheckbox = createCheckbox(
		"DragShiftKeyEnabledCheckbox",
		"TOPLEFT",
		MoveAroundOptionsPanel.optionspanel,
		"TOPLEFT",
		205,
		yOffset,
		L["SHIFT To Drag"],
		L["Whether SHIFT can be pressed while frame dragging is locked to drag a frame."]
	)
	MoveAroundOptionsPanel.config.dragShiftKeyEnabledCheckbox:SetChecked(MoveAroundOptions.dragShiftKeyEnabled)
	yOffset = yOffset - 40

	local lockScaleTitle = MoveAroundOptionsPanel.optionspanel:CreateFontString(nil, "BACKGROUND")
	lockScaleTitle:SetFontObject("GameFontNormal")
	lockScaleTitle:SetText("Frame Scaling")
	lockScaleTitle:SetPoint("TOPLEFT", MoveAroundOptionsPanel.optionspanel, "TOPLEFT", 190, yOffset)
	yOffset = yOffset - 20

	MoveAroundOptionsPanel.config.frameScaleLockedCheckbox = createCheckbox(
		"FrameScaleLockedCheckbox",
		"TOPLEFT",
		MoveAroundOptionsPanel.optionspanel,
		"TOPLEFT",
		190,
		yOffset,
		" Lock Frame Scaling",
		"While frame scaling is locked, a modifier key must be pressed to scale a frame."
	)
	MoveAroundOptionsPanel.config.frameScaleLockedCheckbox:SetChecked(MoveAroundOptions.frameScaleIsLocked)
	yOffset = yOffset - 30

	MoveAroundOptionsPanel.config.scaleAltKeyEnabledCheckbox = createCheckbox(
		"ScaleAltKeyEnabledCheckbox",
		"TOPLEFT",
		MoveAroundOptionsPanel.optionspanel,
		"TOPLEFT",
		205,
		yOffset,
		" ALT To Scale",
		"Whether ALT can be pressed while frame scaling is locked to scale a frame."
	)
	MoveAroundOptionsPanel.config.scaleAltKeyEnabledCheckbox:SetChecked(MoveAroundOptions.scaleAltKeyEnabled)
	yOffset = yOffset - 30

	MoveAroundOptionsPanel.config.scaleCtrlKeyEnabledCheckbox = createCheckbox(
		"ScaleCtrlKeyEnabledCheckbox",
		"TOPLEFT",
		MoveAroundOptionsPanel.optionspanel,
		"TOPLEFT",
		205,
		yOffset,
		" CTRL To Scale",
		"Whether CTRL can be pressed while frame scaling is locked to scale a frame."
	)
	MoveAroundOptionsPanel.config.scaleCtrlKeyEnabledCheckbox:SetChecked(MoveAroundOptions.scaleCtrlKeyEnabled)
	yOffset = yOffset - 30

	MoveAroundOptionsPanel.config.scaleShiftKeyEnabledCheckbox = createCheckbox(
		"ScaleShiftKeyEnabledCheckbox",
		"TOPLEFT",
		MoveAroundOptionsPanel.optionspanel,
		"TOPLEFT",
		205,
		yOffset,
		" SHIFT To Scale",
		"Whether SHIFT can be pressed while frame scaling is locked to scale a frame."
	)
	MoveAroundOptionsPanel.config.scaleShiftKeyEnabledCheckbox:SetChecked(MoveAroundOptions.scaleShiftKeyEnabled)

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

	if (not isRetail) then
		MoveAroundOptionsPanel.config.minimapEnabledCheckbox = createCheckbox(
			"MinimapEnabledCheckbox",
			"TOPLEFT",
			MoveAroundOptionsPanel.optionspanel,
			"TOPLEFT",
			15,
			yOffset,
			" Minimap",
			"Whether MoveAround will modify the Minimap."
		)
		MoveAroundOptionsPanel.config.minimapEnabledCheckbox:SetChecked(not MoveAroundOptions.minimapDisabled)
		yOffset = yOffset - 30
	end

	MoveAroundOptionsPanel.config.objectivesEnabledCheckbox = createCheckbox(
		"ObjectivesEnabledCheckbox",
		"TOPLEFT",
		MoveAroundOptionsPanel.optionspanel,
		"TOPLEFT",
		15,
		yOffset,
		" Objectives",
		"Whether MoveAround will modify Objectives."
	)
	MoveAroundOptionsPanel.config.objectivesEnabledCheckbox:SetChecked(not MoveAroundOptions.objectivesDisabled)
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

	local MoveAroundOptionsVersionLabel = MoveAroundOptionsPanel.optionspanel:CreateFontString(nil, "BACKGROUND")
	MoveAroundOptionsVersionLabel:SetFontObject("GameFontNormal")
	MoveAroundOptionsVersionLabel:SetText("Version:")
	MoveAroundOptionsVersionLabel:SetJustifyH("LEFT")
	MoveAroundOptionsVersionLabel:SetPoint("BOTTOMLEFT", MoveAroundOptionsPanel.optionspanel, "BOTTOMLEFT", 15, 30)

	local MoveAroundOptionsVersionContent = MoveAroundOptionsPanel.optionspanel:CreateFontString(nil, "BACKGROUND")
	MoveAroundOptionsVersionContent:SetFontObject("GameFontHighlight")
	MoveAroundOptionsVersionContent:SetText(C_AddOns.GetAddOnMetadata("MoveAround", "Version"))
	MoveAroundOptionsVersionContent:SetJustifyH("LEFT")
	MoveAroundOptionsVersionContent:SetPoint("BOTTOMLEFT", MoveAroundOptionsPanel.optionspanel, "BOTTOMLEFT", 70, 30)

	local MoveAroundOptionsAuthorLabel = MoveAroundOptionsPanel.optionspanel:CreateFontString(nil, "BACKGROUND")
	MoveAroundOptionsAuthorLabel:SetFontObject("GameFontNormal")
	MoveAroundOptionsAuthorLabel:SetText("Author:")
	MoveAroundOptionsAuthorLabel:SetJustifyH("LEFT")
	MoveAroundOptionsAuthorLabel:SetPoint("BOTTOMLEFT", MoveAroundOptionsPanel.optionspanel, "BOTTOMLEFT", 15, 15)

	local MoveAroundOptionsAuthorContent = MoveAroundOptionsPanel.optionspanel:CreateFontString(nil, "BACKGROUND")
	MoveAroundOptionsAuthorContent:SetFontObject("GameFontHighlight")
	MoveAroundOptionsAuthorContent:SetText("BloodDragon2580")
	MoveAroundOptionsAuthorContent:SetJustifyH("LEFT")
	MoveAroundOptionsAuthorContent:SetPoint("BOTTOMLEFT", MoveAroundOptionsPanel.optionspanel, "BOTTOMLEFT", 70, 15)

	local updateFunction = function()
		local shouldReloadUI = false

		MoveAroundOptions.frameDragIsLocked = MoveAroundOptionsPanel.config.frameMoveLockedCheckbox:GetChecked()
		MoveAroundOptions.dragAltKeyEnabled = MoveAroundOptionsPanel.config.dragAltKeyEnabledCheckbox:GetChecked()
		MoveAroundOptions.dragCtrlKeyEnabled = MoveAroundOptionsPanel.config.dragCtrlKeyEnabledCheckbox:GetChecked()
		MoveAroundOptions.dragShiftKeyEnabled = MoveAroundOptionsPanel.config.dragShiftKeyEnabledCheckbox:GetChecked()

		MoveAroundOptions.frameScaleIsLocked = MoveAroundOptionsPanel.config.frameScaleLockedCheckbox:GetChecked()
		MoveAroundOptions.scaleAltKeyEnabled = MoveAroundOptionsPanel.config.scaleAltKeyEnabledCheckbox:GetChecked()
		MoveAroundOptions.scaleCtrlKeyEnabled = MoveAroundOptionsPanel.config.scaleCtrlKeyEnabledCheckbox:GetChecked()
		MoveAroundOptions.scaleShiftKeyEnabled = MoveAroundOptionsPanel.config.scaleShiftKeyEnabledCheckbox:GetChecked()

		local oldWindowsDisabled = MoveAroundOptions.windowsDisabled
		MoveAroundOptions.windowsDisabled = not MoveAroundOptionsPanel.config.windowsEnabledCheckbox:GetChecked()
		if oldWindowsDisabled ~= MoveAroundOptions.windowsDisabled then
			shouldReloadUI = true
		end

		local oldBagsDisabled = MoveAroundOptions.bagsDisabled
		MoveAroundOptions.bagsDisabled = not MoveAroundOptionsPanel.config.bagsEnabledCheckbox:GetChecked()
		if oldBagsDisabled ~= MoveAroundOptions.bagsDisabled then
			shouldReloadUI = true
		end

		local oldButtonsDisabled = MoveAroundOptions.buttonsDisabled
		MoveAroundOptions.buttonsDisabled = not MoveAroundOptionsPanel.config.buttonsEnabledCheckbox:GetChecked()
		if oldButtonsDisabled ~= MoveAroundOptions.buttonsDisabled then
			shouldReloadUI = true
		end

		if (not isRetail) then
			local oldMinimapDisabled = MoveAroundOptions.minimapDisabled
			MoveAroundOptions.minimapDisabled = not MoveAroundOptionsPanel.config.minimapEnabledCheckbox:GetChecked()
			if oldMinimapDisabled ~= MoveAroundOptions.minimapDisabled then
				shouldReloadUI = true
			end
		end

		local oldObjectivesDisabled = MoveAroundOptions.objectivesDisabled
		MoveAroundOptions.objectivesDisabled = not MoveAroundOptionsPanel.config.objectivesEnabledCheckbox:GetChecked()
		if oldObjectivesDisabled ~= MoveAroundOptions.objectivesDisabled then
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

	MoveAroundOptionsPanel.optionspanel:SetScript("OnHide", updateFunction)
end

SlashCmdList[MOVEAROUND] = function(msg, editBox)
	MoveAroundHelpers:HandleSlashCommands(msg, editBox)
end

SlashCmdList[MOVEAROUNDRESET] = MoveAroundHelpers.DeleteMoveAroundState
