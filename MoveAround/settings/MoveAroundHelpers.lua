if not LibStub then error("MoveAround requires LibStub") end
local L = LibStub("AceLocale-3.0"):GetLocale("MoveAround", false)

MoveAroundHelpers = {}

if not MoveAroundPoints then MoveAroundPoints = {} end

MoveAroundHelpers.waitTable = {}
MoveAroundHelpers.resetTable = {}
MoveAroundHelpers.waitFrame = nil

local phantomMinimapCluster = nil
local minimapMover = CreateFrame("Frame", "MinimapMover", UIParent)
local minimapMoverTexture = minimapMover:CreateTexture(nil, "BACKGROUND")

local collectionsJournalMover = CreateFrame("Frame", "CollectionsJournalMover", UIParent)
local collectionsJournalMoverTexture = collectionsJournalMover:CreateTexture(nil, "BACKGROUND")

local communitiesMover = CreateFrame("Frame", "CommunitiesMover", UIParent)
local communitiesMoverTexture = communitiesMover:CreateTexture(nil, "BACKGROUND")

local isRetail = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)

local hasFixedPVPTalentList = false
local hasFixedPlayerChoice = false
local hasFixedMinimap = false
local hasFixedObjectives = false
local hasFixedCollections = false
local hasFixedCommunities = false
local hasFixedFramesForElvUI = false
local hasFixedManageFramePositions = false


local function getInCombatLockdown()
	return InCombatLockdown()
end

local function frameCannotBeModified(frame)
	return frame:IsProtected() and getInCombatLockdown()
end

local function shouldMove(frame)
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

local function onDragStart(frame, button)
	local frameToMove = frame.MoveAroundDelegate or frame

	if button == "LeftButton" and IsModifiedClick()then
		if not shouldMove(frameToMove) then
			return
		end

		frame:RegisterForDrag("LeftButton")
		frameToMove:StartMoving()
		frameToMove.MoveAroundIsMoving = true
	end
end

local function onDragStop(frame)
	local frameToMove = frame.MoveAroundDelegate or frame

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
			if ("CollectionsJournal" == frame:GetName() or "CommunitiesFrame" == frame:GetName()) then
				frame:ClearAllPoints()
				frame:SetPoint(
					point,
					"UIParent",
					relativePoint,
					xOfs,
					yOfs
				)
			end
		end
	end
	frameToMove.MoveAroundIsMoving = false

	if (frameToMove.MoveAroundIsScaling) then
		MoveAroundScales[frameToMove:GetName()] = frameToMove:GetScale()
	end
	frameToMove.MoveAroundIsScaling = false
	MoveAroundHelpers.frameBeingScaled = nil

	GameTooltip:Hide()

	frame:RegisterForDrag("LeftButton", "RightButton")
end

local function resetScaleAndPosition(frame)
	local modifiedSet = {}
	local frameToMove = frame.MoveAroundDelegate or frame

	if frameCannotBeModified(frameToMove) then
		modifiedSet["unmodifiable"] = true
		return modifiedSet
	end

	if frameToMove.MoveAroundIsMoving or frameToMove.MoveAroundIsScaling then
		modifiedSet["isModifying"] = true
		return modifiedSet
	end

	local point = MoveAroundPoints[frameToMove:GetName()]
	if point then
		frameToMove:ClearAllPoints()
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

		if ("CollectionsJournal" == frame:GetName() or "CommunitiesFrame" == frame:GetName()) then
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
		modifiedSet["position"] = true
	end

	return modifiedSet
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

local function makeSticky(frame, frames)
	if frame.MoveAroundSticky then
		return
	end

	frame:HookScript(
		"OnShow",
		function(self, event, ...)
			resetScaleAndPosition(frame)
			MoveAroundHelpers:BroadcastReset(frames)
		end
	)

	frame:HookScript(
		"OnHide",
		function(self, event, ...)
			MoveAroundHelpers:BroadcastReset(frames)
		end
	)

	frame:HookScript(
		"OnUpdate",
		function(self, event, ...)
			if frame.MoveAroundResetNeeded then
				resetScaleAndPosition(frame)
				frame.MoveAroundResetNeeded = nil
			end
		end
	)

	frame.MoveAroundSticky = true
end

local function makeTabsSticky(frame, frames)
	if frame.MoveAroundTabs then
		for _, tab in pairs(frame.MoveAroundTabs) do
			if not tab.MoveAroundTabSticky then
				tab:HookScript(
					"OnClick",
					function(self, event, ...)
						resetScaleAndPosition(frame)
						MoveAroundHelpers:BroadcastReset(frames)
					end
				)
				tab.MoveAroundTabSticky = true
			end
		end
	end
end

local function makeChildMovers(frame, frames)
	if not frame.MoveAroundChildMovers then
		return
	end

	if frame.MoveAroundChildMoversHooked then
		return
	end

	local function makeMovers()
		local children = { frame:GetChildren() }
		for _, child in ipairs(children) do
			child.MoveAroundDelegate = frame
			makeModifiable(child)
			makeSticky(child, frames)
			makeTabsSticky(child, frames)
		end
	end
	makeMovers()

	frame:RegisterEvent("UPDATE_UI_WIDGET")
	frame:HookScript(
		"OnEvent",
		function(self, event, ...)
			if event == "UPDATE_UI_WIDGET" then
				makeMovers()
			end
		end
	)

	frame.MoveAroundChildMoversHooked = true
end

function MoveAroundHelpers:DeleteMoveAroundState()
	MoveAroundPoints = {}

	for frameName, _ in pairs(MoveAroundScales) do
		local frame = getFrame(frameName)
		if frame then
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
	print(L["/MoveAround reset - Reset position for all modified frames."])
end

function MoveAroundHelpers:PrintHelp()
	local interfaceOptionsLabel = "Interface"

	print(L["MoveAround: Modifies default UI frames so you can click and drag to move. "] ..
		  L["Left-click and drag anywhere to move a frame. "] ..
		  L["Position for each frame are saved. "] ..
		  L["For additional configuration options, visit "] .. interfaceOptionsLabel .. L[" -> AddOns -> MoveAround."]
	)
end

function MoveAroundHelpers:HandleSlashCommands(msg, editBox)
	local cmd = msg
	if (cmd == nil or cmd == "") then
		MoveAroundHelpers:PrintAllowedCommands()
	elseif (cmd == "help") then
		MoveAroundHelpers:PrintHelp()
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
			if properties.MoveAroundDelegate then
				frame.MoveAroundDelegate = getFrame(properties.MoveAroundDelegate) or frame
			end
			if properties.MoveAroundTabs then
				frame.MoveAroundTabs = {}
				for _, tabName in pairs(properties.MoveAroundTabs) do
					local tabFrame = getFrame(tabName)
					if tabFrame then
						table.insert(frame.MoveAroundTabs, tabFrame)
					end
				end
			end
			if properties.MoveAroundChildMovers then
				frame.MoveAroundChildMovers = true
			end

			makeModifiable(frame)
			makeSticky(frame, frames)
			makeTabsSticky(frame, frames)
			makeChildMovers(frame, frames)
		end
	end

	if not MoveAroundOptions.windowsDisabled and EncounterJournalTooltip then
		EncounterJournalTooltip:ClearAllPoints()
	end

	if not MoveAroundOptions.bagsDisabled then
		if (isRetail) then
			UpdateContainerFrameAnchors = function() end
		else
			UpdateContainerFrameAnchors = MoveAroundHelpers.UpdateContainerFrameAnchorsClassic
		end
	end

	if not MoveAroundOptions.windowsDisabled then
		MoveAroundHelpers:FixPVPTalentsList(frames)
	end

	if not MoveAroundOptions.windowsDisabled then
		MoveAroundHelpers:FixPlayerChoiceFrame()
	end

	if (not isRetail) and (not MoveAroundOptions.minimapDisabled) then
		MoveAroundHelpers:FixMinimap()
	end

	if not MoveAroundOptions.objectivesDisabled then
		MoveAroundHelpers:FixObjectives()
	end

	if not MoveAroundOptions.windowsDisabled then
		MacroPopupFrame_AdjustAnchors = function() end
	end

	if not MoveAroundOptions.windowsDisabled then
		MoveAroundHelpers:FixCollectionsJournal()
	end

	if not MoveAroundOptions.windowsDisabled then
		MoveAroundHelpers:FixCommunities(frames)
	end

	if not MoveAroundOptions.windowsDisabled and OrderHallTalentFrame then
		MoveAroundHelpers.resetTable["OrderHallTalentFrame"] = OrderHallTalentFrame
	end

	MoveAroundHelpers:HookFCF_DockUpdate(frames)
	MoveAroundHelpers:BroadcastReset(frames)
end

function MoveAroundHelpers:UpdateContainerFrameAnchorsClassic()
	for i=1,13 do
		local frameName = 'ContainerFrame'..i
		if not MoveAroundPoints[frameName] then
			_G[frameName]:ClearAllPoints()
			_G[frameName]:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
		end
	end
end

function MoveAroundHelpers:FixPVPTalentsList(frames)
	if hasFixedPVPTalentList then
		return
	end

	local talentListFrame = _G['PlayerTalentFrameTalentsPvpTalentFrameTalentList']
	if (talentListFrame) then
		talentListFrame:HookScript(
			"OnHide",
			function(self, event, ...)
				MoveAroundHelpers:BroadcastReset(frames)
			end
		)
		hasFixedPVPTalentList = true
	end
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

	hasFixedMinimap = true
end

function MoveAroundHelpers:FixObjectives()
	if hasFixedObjectives then
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

		hasFixedObjectives = true
	end
end

function MoveAroundHelpers:FixCollectionsJournal()
	if hasFixedCollections then
		return
	end

	if (CollectionsJournal) then
		WardrobeFrame:HookScript("OnShow", function() collectionsJournalMover:SetAlpha(0) end)

		collectionsJournalMover:SetFrameStrata("MEDIUM")
		collectionsJournalMover:SetWidth(CollectionsJournal:GetWidth()) 
		collectionsJournalMover:SetHeight(CollectionsJournal:GetHeight())
		collectionsJournalMoverTexture:SetTexture("Interface\\Collections\\CollectionsBackgroundTile.blp")
		collectionsJournalMoverTexture:SetAllPoints(collectionsJournalMover)
		collectionsJournalMover.texture = collectionsJournalMoverTexture
		collectionsJournalMover:SetAllPoints(CollectionsJournal)
		collectionsJournalMover:Show()

		CollectionsJournal:SetParent(collectionsJournalMover)

		local CollectionsJournal_OnShow_Original = CollectionsJournal_OnShow
		CollectionsJournal:SetScript("OnShow", function()
			WardrobeFrame:ClearAllPoints()

			local point = MoveAroundPoints["CollectionsJournalMover"]
			if point then
				CollectionsJournal:ClearAllPoints()
				xpcall(
					CollectionsJournal.SetPoint,
					function() end,
					CollectionsJournal,
					point["point"],
					point["relativeTo"],
					point["relativePoint"],
					point["xOfs"],
					point["yOfs"]
				)
			end

			collectionsJournalMover:SetAlpha(1)

			CollectionsJournal_OnShow_Original(CollectionsJournal)
		end)
		CollectionsJournal:HookScript("OnHide", function() collectionsJournalMover:SetAlpha(0) end)

		if not CollectionsJournal:IsShown() then
			collectionsJournalMover:SetAlpha(0)
		end

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
		communitiesMover:Show()

		CommunitiesFrame:SetParent(communitiesMover)

		CommunitiesFrame:HookScript("OnShow", function()
			local point = MoveAroundPoints["CommunitiesFrameMover"]
			if point then
				CommunitiesFrame:ClearAllPoints()
				xpcall(
					CommunitiesFrame.SetPoint,
					function() end,
					CommunitiesFrame,
					point["point"],
					point["relativeTo"],
					point["relativePoint"],
					point["xOfs"],
					point["yOfs"]
				)
			end

			communitiesMover:SetAlpha(1)
		end)
		CommunitiesFrame:HookScript("OnHide", function() communitiesMover:SetAlpha(0) end)

		if not CommunitiesFrame:IsShown() then
			communitiesMover:SetAlpha(0)
		end

		if (ClubFinderGuildFinderFrame) then
			ClubFinderGuildFinderFrame:HookScript(
				"OnShow",
				function(self, event, ...)
					MoveAroundHelpers:BroadcastReset(frames)
				end
			)
		end

		if (CommunitiesFrameInset) then
			CommunitiesFrameInset:HookScript(
				"OnShow",
				function(self, event, ...)
					MoveAroundHelpers:BroadcastReset(frames)
				end
			)
		end

		if (ClubFinderCommunityAndGuildFinderFrame) then
			ClubFinderCommunityAndGuildFinderFrame:HookScript(
				"OnShow",
				function(self, event, ...)
					MoveAroundHelpers:BroadcastReset(frames)
				end
			)
		end

		if (CommunitiesFrame.ClubFinderInvitationFrame) then
			CommunitiesFrame.ClubFinderInvitationFrame:HookScript(
				"OnShow",
				function(self, event, ...)
					MoveAroundHelpers:BroadcastReset(frames)
				end
			)
		end

		if (CommunitiesFrame.Chat) then
			CommunitiesFrame.Chat:HookScript(
				"OnShow",
				function(self, event, ...)
					MoveAroundHelpers:BroadcastReset(frames)
				end
			)
		end

		hasFixedCommunities = true
	end
end

function MoveAroundHelpers:FixFramesForElvUI()
	if hasFixedFramesForElvUI then
		return
	end

	local UpdateUIPanelPositions_Original = UpdateUIPanelPositions
	function UpdateUIPanelPositions(currentFrame)
		if currentFrame == FriendsFrame and MoveAroundPoints["FriendsFrame"] then
			return
		end
		if currentFrame == CharacterFrame and MoveAroundPoints["CharacterFrame"] then
			return
		end
		UpdateUIPanelPositions_Original(currentFrame)
	end

	hasFixedFramesForElvUI = true
end

function MoveAroundHelpers:HookFCF_DockUpdate(frames)
	if hasFixedManageFramePositions then
		return
	end

	hooksecurefunc(
		"FCF_DockUpdate",
		function()
			MoveAroundHelpers:BroadcastReset(frames)
		end
	)

	hasFixedManageFramePositions = true
end

function MoveAroundHelpers:Wait(delay, func, ...)
	if type(delay) ~= "number" or type(func) ~= "function" then
		return false
	end

	if MoveAroundHelpers.waitFrame == nil then
		MoveAroundHelpers.waitFrame = CreateFrame("Frame", "WaitFrame", UIParent)
		MoveAroundHelpers.waitFrame:SetScript(
			"OnUpdate",
			function(self, elapse)
				local count = #MoveAroundHelpers.waitTable
				local i = 1
				while (i <= count) do
					local waitRecord = tremove(MoveAroundHelpers.waitTable, i)
					local d = tremove(waitRecord, 1)
					local f = tremove(waitRecord, 1)
					local p = tremove(waitRecord, 1)
					if (d > elapse) then
						tinsert(MoveAroundHelpers.waitTable, i, {d - elapse, f, p})
						i = i + 1
					else
						count = count - 1
						f(unpack(p))
					end
				end

				for frameName, frame in pairs(MoveAroundHelpers.resetTable) do
					if frame.MoveAroundResetNeeded then
						resetScaleAndPosition(frame)
						frame.MoveAroundResetNeeded = nil
					end
				end
			end
		)
	end

	tinsert(MoveAroundHelpers.waitTable, {delay, func, {...}})
	return true
end

function MoveAroundHelpers:BroadcastReset(frames)
	for frameName, _ in pairs(frames) do
		local frame = getFrame(frameName)
		if frame and frame:IsVisible() then
			frame.MoveAroundResetNeeded = true
		end
	end
end
