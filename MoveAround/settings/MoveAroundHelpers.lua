if not LibStub then error("MoveAround requires LibStub") end
local L = LibStub("AceLocale-3.0"):GetLocale("MoveAround", false)

MoveAroundHelpers = {}

if not MoveAroundPoints then MoveAroundPoints = {} end
local ALPHA_DURING_MOVE = 0.3

MoveAroundHelpers.waitTable = {}
MoveAroundHelpers.resetTable = {}
MoveAroundHelpers.waitFrame = nil

local MAX_SCALE = 1.5
local MIN_SCALE = 0.5
local SCALE_INCREMENT = 0.01
local ALPHA_DURING_SCALE = 0.3
MoveAroundHelpers.scaleHandlerFrame = nil
MoveAroundHelpers.prevMouseX = nil
MoveAroundHelpers.prevMouseY = nil
MoveAroundHelpers.frameBeingScaled = nil
if not MoveAroundScales then MoveAroundScales = {} end

local phantomMinimapCluster = nil
local minimapMover = CreateFrame("Frame", "MinimapMover", UIParent)
local minimapMoverTexture = minimapMover:CreateTexture(nil, "BACKGROUND")

local collectionsJournalMover = CreateFrame("Frame", "CollectionsJournalMover", UIParent)
local collectionsJournalMoverTexture = collectionsJournalMover:CreateTexture(nil, "BACKGROUND")

local communitiesMover = CreateFrame("Frame", "CommunitiesMover", UIParent)
local communitiesMoverTexture = communitiesMover:CreateTexture(nil, "BACKGROUND")

local TOTAL_BAGS = 13

local isRetail = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)
local isClassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)
local isWC = (WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC)

local hasFixedBags = false
local hasFixedPlayerChoice = false
local hasFixedMinimap = false
local hasFixedCollections = false
local hasFixedCommunities = false
local hasFixedFramesForElvUIRetail = false
local hasFixedQuestWatchClassic = false
local hasFixedWatchWC = false
local hasFixedTimeManager = false
local hasFixedMicroMenu = false
local hasFixedEncounterJournal = false
local hasFixedTradeSkillMaster = false

local function getInCombatLockdown()
	return InCombatLockdown()
end

local function frameCannotBeModified(frame)
	return frame:IsProtected() and getInCombatLockdown()
end

local function shouldMove(frame)
	if frame.MoveAroundUnmovable then
		print("|cffFFC125MoveAround:|r Moving not supported for " .. frame:GetName() .. ".")
		return false
	end

	if frameCannotBeModified(frame) then
		print(L["MoveAround: Cannot move "] .. frame:GetName() .. L[" during combat."])
		return false
	end

	if not MoveAroundOptions.frameDragIsLocked then
		return true
	elseif ((MoveAroundOptions.dragAltKeyEnabled and IsAltKeyDown()) or
			(MoveAroundOptions.dragCtrlKeyEnabled and IsControlKeyDown()) or
			(MoveAroundOptions.dragShiftKeyEnabled and IsShiftKeyDown())) then
		return true
	else
		return false
	end
end

local function shouldScale(frame)
	if frame.MoveAroundUnscalable then
		print("|cffFFC125MoveAround:|r Scaling not supported for " .. frame:GetName() .. ".")
		return false
	end

	if frameCannotBeModified(frame) then
		print("|cffFFC125MoveAround:|r Cannot scale " .. frame:GetName() .. " during combat.")
		return false
	end

	if not MoveAroundOptions.frameScaleIsLocked then
		return true
	elseif ((MoveAroundOptions.scaleAltKeyEnabled and IsAltKeyDown()) or
			(MoveAroundOptions.scaleCtrlKeyEnabled and IsControlKeyDown()) or
			(MoveAroundOptions.scaleShiftKeyEnabled and IsShiftKeyDown())) then
		return true
	else
		return false
	end
end

local function getFrame(frameName)
	if not frameName then
		return nil
	end

	local frame = _G[frameName]
	if frame then
		return frame
	end

	local frameNames = {}
	for name in string.gmatch(frameName, "[^%.]+") do
		table.insert(frameNames, name)
	end
	if #frameNames < 2 then
		return nil
	end

	frame = _G[frameNames[1]]
	if frame then
		for idx = 2, #frameNames do
			frame = frame[frameNames[idx]]
		end
	end

	return frame
end

local function resetScaleAndPosition(frame)
	local frameToMove = frame.MoveAroundDelegate or frame

	if frameCannotBeModified(frame) or frameCannotBeModified(frameToMove) then
		return
	end

	if frameToMove.MoveAroundIsMoving or frameToMove.MoveAroundIsScaling then
		return
	end

	local scale = MoveAroundScales[frameToMove:GetName()]
	if scale then
		frameToMove.MoveAroundAboutToSetScale = true
		frameToMove:SetScale(scale)
	end

	local point = MoveAroundPoints[frameToMove:GetName()]
	if point then
		frameToMove:ClearAllPoints()
		frameToMove.MoveAroundAboutToSetPoint = true
		xpcall(
			frameToMove.SetPoint,
			function() end,
			frameToMove,
			point["point"],
			point["relativeTo"],
			point["relativePoint"],
			point["xOfs"],
			point["yOfs"]
		)

		if frame.MoveAroundHasMover then
			if (hasFixedCommunities) then
				communitiesMover:SetWidth(CommunitiesFrame:GetWidth())
				communitiesMover:SetHeight(CommunitiesFrame:GetHeight())
			end

			frame:ClearAllPoints()
			xpcall(
				frame.SetPoint,
				function() end,
				frame,
				point["point"],
				point["relativeTo"],
				point["relativePoint"],
				point["xOfs"],
				point["yOfs"]
			)
		end
	end
end

local function onDragStart(frame, button)
	local frameToMove = frame.MoveAroundDelegate or frame

	if button == "LeftButton" then
		if not shouldMove(frameToMove) or not shouldMove(frame) then
			return
		end

		frame:RegisterForDrag("LeftButton")

		frameToMove:StartMoving()

		frameToMove:SetAlpha(ALPHA_DURING_MOVE)

		frameToMove.MoveAroundIsMoving = true

	elseif button == "RightButton" then
		if not shouldScale(frameToMove) or not shouldScale(frame) then
			return
		end

		frame:RegisterForDrag("RightButton")

		frameToMove:SetAlpha(ALPHA_DURING_SCALE)

		frameToMove.MoveAroundIsScaling = true

		MoveAroundHelpers.prevMouseX = nil
		MoveAroundHelpers.prevMouseY = nil

		MoveAroundHelpers.frameBeingScaled = frameToMove
	end
end

local function onDragStop(frame)
	local frameToMove = frame.MoveAroundDelegate or frame

	if frameCannotBeModified(frame) or frameCannotBeModified(frameToMove) then
		return
	end

	frameToMove:StopMovingOrSizing()
	frameToMove:SetAlpha(1)

	if (frameToMove.MoveAroundIsMoving) then
		local point, _, relativePoint, xOfs, yOfs = frameToMove:GetPoint()
		if (point ~= nil and relativePoint ~= nil and xOfs ~= nil and yOfs ~= nil) then
			MoveAroundPoints[frameToMove:GetName()] = {
				["point"] = point,
				["relativeTo"] = "UIParent",
				["relativePoint"] = relativePoint,
				["xOfs"] = xOfs,
				["yOfs"] = yOfs
			}
		end
	end
	frameToMove.MoveAroundIsMoving = false

	if (frameToMove.MoveAroundIsScaling) then
		MoveAroundScales[frameToMove:GetName()] = frameToMove:GetScale()
	end
	frameToMove.MoveAroundIsScaling = false
	MoveAroundHelpers.frameBeingScaled = nil

	if frame.MoveAroundHasMover then
		frameToMove:SetAlpha(0)
		resetScaleAndPosition(frame)
	end

	GameTooltip:Hide()

	frame:RegisterForDrag("LeftButton", "RightButton")
end

local function makeModifiable(frame)
	if frame.MoveAroundModifiable then
		return
	end

	local frameToMove = frame.MoveAroundDelegate or frame
	frame:SetMovable(true)
	frameToMove:SetMovable(true)
	frameToMove:SetUserPlaced(true)
	frameToMove:SetClampedToScreen(true)
	frame:EnableMouse(true)
	frame:SetClampedToScreen(true)
	frame:RegisterForDrag("LeftButton", "RightButton")
	frame:SetScript("OnDragStart", onDragStart)
	frame:SetScript("OnDragStop", onDragStop)
	frame:HookScript("OnHide", onDragStop)

	frame.MoveAroundModifiable = true
end

local function hookSet(frameOriginal)
	local frame = frameOriginal.MoveAroundDelegate or frameOriginal
	local setTarget = (frameOriginal.MoveAroundHasMover and frameOriginal) or frame

	if frame.MoveAroundHookSet then
		return
	end

	hooksecurefunc(
		setTarget,
		"SetPoint",
		function()
			if frame.MoveAroundAboutToSetPoint then
				frame.MoveAroundAboutToSetPoint = false
			else
				resetScaleAndPosition(setTarget)
			end
		end
	)

	hooksecurefunc(
		setTarget,
		"SetScale",
		function()
			if frame.MoveAroundAboutToSetScale then
				frame.MoveAroundAboutToSetScale = false
			else
				resetScaleAndPosition(setTarget)
			end
		end
	)

	frame.MoveAroundHookSet = true
end

function MoveAroundHelpers:DeleteMoveAroundState()
	MoveAroundPoints = {}

	for frameName, _ in pairs(MoveAroundScales) do
		local frame = getFrame(frameName)
		if frame then
			frame.MoveAroundAboutToSetScale = true
			frame:SetScale(1)
		end
	end

	MoveAroundScales = {}

	ReloadUI()
end

function MoveAroundHelpers:PrintAllowedCommands()
	print(L["MoveAround: Allowed commands:"])
	print(L["/MoveAround - Print allowed commands."])
	print(L["/MoveAround help - Print help message."])
	print(L["/MoveAround version|r - Print addon version."])
	print(L["/MoveAround reset - Reset position for all modified frames."])
end

function MoveAroundHelpers:PrintHelp()
	local interfaceOptionsLabel = "Interface"
	if isClassic then
		interfaceOptionsLabel = "Interface Options"
	end

	print(L["MoveAround: Modifies default UI frames so you can click and drag to move. "] ..
		  L["Left-click and drag anywhere to move a frame. "] ..
		  L["Right-click and drag up or down to scale a frame. "] ..
		  L["Position for each frame are saved. "] ..
		  L["For additional configuration options, visit "] .. interfaceOptionsLabel .. L[" -> AddOns -> MoveAround."]
	)
end

function MoveAroundHelpers:PrintVersion()
	print("|cffFFC125MoveAround:|r Version " .. GetAddOnMetadata("MoveAround", "Version"))
end

function MoveAroundHelpers:HandleSlashCommands(msg, editBox)
	local cmd = msg
	if (cmd == nil or cmd == "") then
		MoveAroundHelpers:PrintAllowedCommands()
	elseif (cmd == "help") then
		MoveAroundHelpers:PrintHelp()
	elseif (cmd == "version") then
		MoveAroundHelpers:PrintVersion()
	elseif (cmd == "reset") then
		MoveAroundHelpers:DeleteMoveAroundState()
	else
		print("|cffFFC125MoveAround:|r Unknown command '" .. cmd .. "'")
		MoveAroundHelpers:PrintAllowedCommands()
	end
end

function MoveAroundHelpers:ModifyFrames(frames)
	if (getInCombatLockdown()) then
		return
	end

	if MoveAroundHelpers.scaleHandlerFrame == nil then
		MoveAroundHelpers.scaleHandlerFrame = CreateFrame("Frame", "ScaleHandlerFrame", UIParent)
		MoveAroundHelpers.scaleHandlerFrame:SetScript(
			"OnUpdate",
			function(self)
				if (MoveAroundHelpers.frameBeingScaled) then
					local curMouseX, curMouseY = GetCursorPosition()

					if MoveAroundHelpers.prevMouseX and MoveAroundHelpers.prevMouseY then
						if curMouseY > MoveAroundHelpers.prevMouseY then
							local newScale = math.min(
								MoveAroundHelpers.frameBeingScaled:GetScale() + SCALE_INCREMENT,
								MAX_SCALE
							)

							MoveAroundHelpers.frameBeingScaled.MoveAroundAboutToSetScale = true
							MoveAroundHelpers.frameBeingScaled:SetScale(newScale)
						elseif curMouseY < MoveAroundHelpers.prevMouseY then
							local newScale = math.max(
								MoveAroundHelpers.frameBeingScaled:GetScale() - SCALE_INCREMENT,
								MIN_SCALE
							)

							MoveAroundHelpers.frameBeingScaled.MoveAroundAboutToSetScale = true
							MoveAroundHelpers.frameBeingScaled:SetScale(newScale)
						end
					end

					GameTooltip:SetOwner(MoveAroundHelpers.frameBeingScaled)
					GameTooltip:SetText(
						"" .. math.floor(MoveAroundHelpers.frameBeingScaled:GetScale() * 100) .. "%",
						1.0,
						1.0,
						1.0,
						1.0,
						true
					)

					MoveAroundHelpers.prevMouseX = curMouseX
					MoveAroundHelpers.prevMouseY = curMouseY
				end
			end
		)
	end

	if (isClassic) and (not MoveAroundOptions.objectivesDisabled) then
		MoveAroundHelpers:FixQuestWatchClassic()
	end

	for frameName, properties in pairs(frames) do
		local frame = getFrame(frameName)
		if frame then
			if not frame:GetName() then
				frame.GetName = function()
					return frameName
				end
			end
			if properties.MoveAroundUnscalable then
				frame.MoveAroundUnscalable = true
			end
			if properties.MoveAroundUnmovable then
				frame.MoveAroundUnmovable = true
			end
			if properties.MoveAroundHasMover then
				frame.MoveAroundHasMover = true
			end
			if properties.MoveAroundDelegate then
				frame.MoveAroundDelegate = getFrame(properties.MoveAroundDelegate) or frame
			end

			makeModifiable(frame)
			hookSet(frame)
		end
	end

	if not MoveAroundOptions.bagsDisabled then
		MoveAroundHelpers:FixBags()
	end

	if not MoveAroundOptions.windowsDisabled then
		MoveAroundHelpers:FixPlayerChoiceFrame()
	end

	if (not isRetail) and (not MoveAroundOptions.minimapDisabled) then
		MoveAroundHelpers:FixMinimap()
	end

	if not MoveAroundOptions.windowsDisabled then
		MoveAroundHelpers:FixCollectionsJournal()
	end

	if not MoveAroundOptions.windowsDisabled then
		MoveAroundHelpers:FixCommunities(frames)
	end

	if (isRetail) and (not MoveAroundOptions.windowsDisabled) then
		MoveAroundHelpers:FixFramesForElvUIRetail()
	end

	if not MoveAroundOptions.windowsDisabled then
		MoveAroundHelpers:FixTimeManagerFrame()
	end

	if (isWC) and (not MoveAroundOptions.objectivesDisabled) then
		MoveAroundHelpers:FixWatchWC()
	end

	if (not MoveAroundOptions.buttonsDisabled) then
		MoveAroundHelpers:FixMicroMenu()
	end

	if (not MoveAroundOptions.windowsDisabled) then
		MoveAroundHelpers:FixEncounterJournal()
	end

	if (not MoveAroundOptions.windowsDisabled) then
		MoveAroundHelpers:FixTradeSkillMaster()
	end

	for frameName, _ in pairs(frames) do
		local frame = getFrame(frameName)
		if frame then
			resetScaleAndPosition(frame)
		end
	end
end

function MoveAroundHelpers:FixBags()
	if hasFixedBags then
		return
	end

	for i=1,TOTAL_BAGS do
		_G["ContainerFrame"..i]:HookScript(
			"OnHide",
			function(self, event, ...)
				if (not MoveAroundHelpers:IsAnyBagShown()) then
					MoveAroundHelpers:RevertBags()
				end
			end
		)
	end

	if (ContainerFrameCombinedBags) then
		ContainerFrameCombinedBags:HookScript(
			"OnHide",
			function(self, event, ...)
				if (not MoveAroundHelpers:IsAnyBagShown()) then
					MoveAroundHelpers:RevertBags()
				end
			end
		)
	end

	hasFixedBags = true
end

function MoveAroundHelpers:FixPlayerChoiceFrame()
	if hasFixedPlayerChoice then
		return
	end

	if (PlayerChoiceFrame) then
		PlayerChoiceFrame:HookScript(
			"OnHide",
			function()
				PlayerChoiceFrame:ClearAllPoints()
			end
		)
		hasFixedPlayerChoice = true
	end
end

function MoveAroundHelpers:FixMinimap()
	if hasFixedMinimap then
		return
	end

	if nil == MinimapCluster then
		return
	end

	phantomMinimapCluster = CreateFrame("Frame", "PhantomMinimapCluster", UIParent)
	phantomMinimapCluster:SetFrameStrata("BACKGROUND")
	phantomMinimapCluster:SetWidth(MinimapCluster:GetWidth())
	phantomMinimapCluster:SetHeight(MinimapCluster:GetHeight())
	phantomMinimapCluster:SetPoint("TOPRIGHT")

	MinimapCluster.GetBottom = function ()
		return phantomMinimapCluster:GetBottom()
	end

	if (isWC) then
		minimapMover:SetFrameStrata("MEDIUM")
		minimapMover:SetWidth(MinimapCluster:GetWidth())
		minimapMover:SetHeight(MinimapCluster:GetHeight())
		minimapMoverTexture:SetAllPoints(minimapMover)
		minimapMover.texture = minimapMoverTexture
		minimapMover:SetAllPoints(MinimapCluster)
		minimapMover:SetAlpha(0)
		minimapMover:Show()

		MinimapCluster:HookScript("OnDragStart", function()
			minimapMoverTexture:SetTexture("Interface\\Collections\\CollectionsBackgroundTile.blp")
		end)
		MinimapCluster:HookScript("OnDragStop", function()
			minimapMoverTexture:SetTexture(nil)
		end)

		hooksecurefunc(
			"FCF_DockUpdate",
			function() resetScaleAndPosition(MinimapCluster) end
		)
	end

	hasFixedMinimap = true
end

function MoveAroundHelpers:FixCollectionsJournal()
	if hasFixedCollections then
		return
	end

	if (CollectionsJournal) then
		collectionsJournalMover:SetFrameStrata("MEDIUM")
		collectionsJournalMover:SetWidth(CollectionsJournal:GetWidth()) 
		collectionsJournalMover:SetHeight(CollectionsJournal:GetHeight())
		collectionsJournalMoverTexture:SetTexture("Interface\\Collections\\CollectionsBackgroundTile.blp")
		collectionsJournalMoverTexture:SetAllPoints(collectionsJournalMover)
		collectionsJournalMover.texture = collectionsJournalMoverTexture
		collectionsJournalMover:SetAllPoints(CollectionsJournal)
		collectionsJournalMover:SetAlpha(0)
		collectionsJournalMover:Show()

		hasFixedCollections = true
	end
end

function MoveAroundHelpers:FixCommunities(frames)
	if hasFixedCommunities then
		return
	end

	if (CommunitiesFrame) then
		communitiesMover:SetFrameStrata("MEDIUM")
		communitiesMover:SetWidth(CommunitiesFrame:GetWidth())
		communitiesMover:SetHeight(CommunitiesFrame:GetHeight())
		communitiesMoverTexture:SetTexture("Interface\\Collections\\CollectionsBackgroundTile.blp")
		communitiesMoverTexture:SetAllPoints(communitiesMover)
		communitiesMover.texture = communitiesMoverTexture
		communitiesMover:SetAllPoints(CommunitiesFrame)
		communitiesMover:SetAlpha(0)
		communitiesMover:Show()

		hasFixedCommunities = true
	end
end

function MoveAroundHelpers:FixFramesForElvUIRetail()
	if hasFixedFramesForElvUIRetail then
		return
	end

	if not isRetail then
		return
	end

	if not IsAddOnLoaded("ElvUI") then
		return
	end

	if (MailFrame and TokenFrame and TokenFramePopup) then
		MailFrame:HookScript(
			"OnShow",
			function()
				if (MailFrameInset) and (MailFrameInset:GetParent() ~= MailFrame) then
					MailFrameInset:SetParent(MailFrame)
				end
			end
		)

		TokenFramePopup:ClearAllPoints()
		xpcall(
			TokenFramePopup.SetPoint,
			function() end,
			TokenFramePopup,
			"TOPLEFT",
			TokenFrame,
			"TOPRIGHT",
			3,
			-28
		)

		hasFixedFramesForElvUIRetail = true
	end
end

function MoveAroundHelpers:FixQuestWatchClassic()
	if hasFixedQuestWatchClassic then
		return
	end

	if (not isClassic) then
		return
	end

	if (QuestWatchFrame) then
		local QuestWatchFrame_SetPoint_Original = QuestWatchFrame.SetPoint
		QuestWatchFrame.SetPoint = function(_, point, relativeTo, relativePoint, ofsx, ofsy)
			if "MinimapCluster" == relativeTo then
				return
			end
			QuestWatchFrame_SetPoint_Original(QuestWatchFrame, point, relativeTo, relativePoint, ofsx, ofsy)
		end

		hasFixedQuestWatchClassic = true
	end
end

function MoveAroundHelpers:FixTimeManagerFrame()
	if hasFixedTimeManager then
		return
	end

	hooksecurefunc(
		"TimeManager_LoadUI",
		function() resetScaleAndPosition(TimeManagerFrame) end
	)

	hasFixedTimeManager = true
end

function MoveAroundHelpers:FixWatchWC()
	if hasFixedWatchWC then
		return
	end

	if (not isWC) then
		return
	end

	if (WatchFrame) then
		hooksecurefunc(
			"FCF_DockUpdate",
			function() resetScaleAndPosition(WatchFrame) end
		)

		hasFixedWatchWC = true
	end
end

function MoveAroundHelpers:FixMicroMenu()
	if hasFixedMicroMenu then
		return
	end

	if MicroMenu and HelpOpenWebTicketButton then
		hooksecurefunc(
			MicroMenu,
			"GetEdgeButton",
			function()
				HelpOpenWebTicketButton:ClearAllPoints()
			end
		)

		hasFixedMicroMenu = true
	end
end

function MoveAroundHelpers:FixEncounterJournal()
	if hasFixedEncounterJournal then
		return
	end

	if (not isRetail) then
		return
	end

	if EncounterJournal then
		EncounterJournal:HookScript(
			"OnShow",
			function()
				EncounterJournalTooltip:ClearAllPoints()
			end
		)

		hasFixedEncounterJournal = true
	end
end

function MoveAroundHelpers:FixTradeSkillMaster()
	if hasFixedTradeSkillMaster then
		return
	end

	if not IsAddOnLoaded("TradeSkillMaster") then
		return
	end

	if MerchantFrame then
		MoveAroundPoints[MerchantFrame:GetName()] = nil
		MerchantFrame:SetClampedToScreen(false)
		hasFixedTradeSkillMaster = true
	end
end

function MoveAroundHelpers:IsAnyBagShown()
	local anyBagShown = false
	for i=1,TOTAL_BAGS do
		local frameName = "ContainerFrame"..i
		if _G[frameName]:IsShown() then
			anyBagShown = true
		end
	end
	if ContainerFrameCombinedBags and ContainerFrameCombinedBags:IsShown() then
		anyBagShown = true
	end
	return anyBagShown
end

function MoveAroundHelpers:RevertBags()
	for i=1,TOTAL_BAGS do
		local frameName = "ContainerFrame"..i
		_G[frameName]:ClearAllPoints()
		_G[frameName].MoveAroundAboutToSetPoint = true
		xpcall(
			_G[frameName].SetPoint,
			function() end,
			_G[frameName],
			"BOTTOMRIGHT",
			UIParent,
			"BOTTOMRIGHT",
			0,
			0
		)
	end
	if (ContainerFrameCombinedBags) then
		ContainerFrameCombinedBags:ClearAllPoints()
		ContainerFrameCombinedBags.MoveAroundAboutToSetPoint = true
		xpcall(
			ContainerFrameCombinedBags.SetPoint,
			function() end,
			ContainerFrameCombinedBags,
			"BOTTOMRIGHT",
			UIParent,
			"BOTTOMRIGHT",
			0,
			0
		)
	end
end
