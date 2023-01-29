if not LibStub then error("MoveAround requires LibStub") end
local L = LibStub("AceLocale-3.0"):GetLocale("MoveAround", false)

local frames = {
	["ContainerFrame1"] = {
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame1.ClickableTitleFrame"] = {
		MoveAroundDelegate = "ContainerFrame1",
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame2"] = {
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame2.ClickableTitleFrame"] = {
		MoveAroundDelegate = "ContainerFrame2",
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame3"] = {
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame3.ClickableTitleFrame"] = {
		MoveAroundDelegate = "ContainerFrame3",
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame4"] = {
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame4.ClickableTitleFrame"] = {
		MoveAroundDelegate = "ContainerFrame4",
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame5"] = {
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame5.ClickableTitleFrame"] = {
		MoveAroundDelegate = "ContainerFrame5",
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame6"] = {
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame6.ClickableTitleFrame"] = {
		MoveAroundDelegate = "ContainerFrame6",
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame7"] = {
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame7.ClickableTitleFrame"] = {
		MoveAroundDelegate = "ContainerFrame7",
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame8"] = {
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame8.ClickableTitleFrame"] = {
		MoveAroundDelegate = "ContainerFrame8",
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame9"] = {
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame9.ClickableTitleFrame"] = {
		MoveAroundDelegate = "ContainerFrame9",
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame10"] = {
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame10.ClickableTitleFrame"] = {
		MoveAroundDelegate = "ContainerFrame10",
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame11"] = {
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame11.ClickableTitleFrame"] = {
		MoveAroundDelegate = "ContainerFrame11",
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame12"] = {
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame12.ClickableTitleFrame"] = {
		MoveAroundDelegate = "ContainerFrame12",
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame13"] = {
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrame13.ClickableTitleFrame"] = {
		MoveAroundDelegate = "ContainerFrame13",
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrameCombinedBags"] = {
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["ContainerFrameCombinedBags.TitleContainer"] = {
		MoveAroundDelegate = "ContainerFrameCombinedBags",
		MoveAroundDisabledBy = "bagsDisabled"
	},
	["CharacterFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
		MoveAroundTabs = {
			"CharacterFrameTab1",
			"CharacterFrameTab2",
			"CharacterFrameTab3"
		}
	},
	["GearManagerPopupFrame"] = {
		DriftDisabledBy = "windowsDisabled",
	},
	["TokenFramePopup"] = {
		DriftDisabledBy = "windowsDisabled",
	},
	["TradeSkillFrame"] = {
		DriftDisabledBy = "windowsDisabled",
	},
	["TradeSkillFrame.OptionalReagentList"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["ProfessionsFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["CraftFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["ArchaeologyFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["QuestLogPopupDetailFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["QuestLogFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["QuestFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["QuestChoiceFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["WarboardQuestChoiceFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["GossipFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["CollectionsJournal"] = {
		MoveAroundDisabledBy = "windowsDisabled",
		MoveAroundDelegate = "CollectionsJournalMover"
	},
	["CommunitiesFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
		MoveAroundDelegate = "CommunitiesMover",
		MoveAroundTabs = {
			"CommunitiesFrame.MaximizeMinimizeFrame.MaximizeButton",
			"CommunitiesFrame.MaximizeMinimizeFrame.MinimizeButton",
			"CommunitiesFrame.ChatTab",
			"CommunitiesFrame.RosterTab",
			"CommunitiesFrame.GuildBenefitsTab",
			"CommunitiesFrame.GuildInfoTab",
			"ClubFinderCommunityAndGuildFinderFrame.ClubFinderPendingTab",
		}
	},
	["CommunitiesFrame.GuildMemberDetailFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["SpellBookFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["ClassTalentFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["AchievementFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["AchievementFrame.Header"] = {
		MoveAroundDisabledBy = "windowsDisabled",
		MoveAroundDelegate = "AchievementFrame"
	},
	["AchievementFrame.SearchResults"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["WorldMapFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
		MoveAroundUnscalable = true
	},
	["QuestScrollFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
		MoveAroundDelegate = "WorldMapFrame"
	},
	["LookingForGuildFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["PVEFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
		MoveAroundTabs = {
			"PVEFrameTab1",
			"PVEFrameTab2",
			"PVEFrameTab3",
			"PVPQueueFrameCategoryButton1",
			"PVPQueueFrameCategoryButton2",
			"PVPQueueFrameCategoryButton3"
		}
	},
	["EncounterJournal"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["FriendsFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["BNToastFrame"] = {
		MoveAroundDisabledBy = "miscellaneousDisabled",
	},
	["QuickJoinToastButton"] = {
		MoveAroundDisabledBy = "buttonsDisabled",
	},
	["QuickJoinToastButton.Toast"] = {
		MoveAroundDisabledBy = "miscellaneousDisabled",
	},
	["QuickJoinToastButton.Toast2"] = {
		MoveAroundDisabledBy = "miscellaneousDisabled",
	},
	["ReputationDetailFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["RecruitAFriendRewardsFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["ChannelFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["RaidInfoFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["DressUpFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
		MoveAroundTabs = {
			"DressUpFrame.ToggleOutfitDetailsButton",
			"DressUpFrame.MaximizeMinimizeFrame.MinimizeButton",
			"DressUpFrame.MaximizeMinimizeFrame.MaximizeButton"
		}
	},
	["SideDressUpFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["AddonList"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["MerchantFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["MailFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["SendMailFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
		MoveAroundDelegate = "MailFrame"
	},
	["OpenMailFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["BankFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["GameMenuFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["SettingsPanel"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["VideoOptionsFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["AudioOptionsFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["InterfaceOptionsFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["KeyBindingFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["HelpFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["HelpOpenWebTicketButton"] = {
		MoveAroundDisabledBy = "buttonsDisabled",
	},
	["RaidParentFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["RaidBrowserFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["TradeFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["TimeManagerFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["TabardFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["GuildBankFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["GuildRegistrarFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["GuildControlUI"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["PetitionFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["ColorPickerFrame.Header"] = {
		MoveAroundDisabledBy = "windowsDisabled",
		MoveAroundDelegate = "ColorPickerFrame"
	},
	["AzeriteEmpoweredItemUI"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["AzeriteEssenceUI"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["AzeriteRespecFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["InspectFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["ItemSocketingFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["MacroFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["MacroPopupFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["VoidStorageFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["SplashFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["WardrobeFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["CalendarFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["CalendarViewEventFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["CalendarViewEventFrame.Header"] = {
		MoveAroundDisabledBy = "windowsDisabled",
		MoveAroundDelegate = "CalendarViewEventFrame"
	},
	["CalendarViewEventFrame.HeaderFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
		MoveAroundDelegate = "CalendarViewEventFrame"
	},
	["CalendarViewHolidayFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["CalendarViewRaidFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["ClassTrainerFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["AuctionFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["AuctionHouseFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["BlackMarketFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["ReforgingFrame"] = {
		DriftDisabledBy = "windowsDisabled",
	},
	["ExpansionLandingPage"] = {
		DriftDisabledBy = "windowsDisabled",
	},
	["MajorFactionRenownFrame"] = {
		DriftDisabledBy = "windowsDisabled",
	},
	["GarrisonBuildingFrame"] = {
		DriftDisabledBy = "windowsDisabled",
	},
	["GarrisonLandingPage"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["GarrisonMissionFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["GarrisonShipyardFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["GarrisonMonumentFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["GarrisonRecruiterFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["GarrisonRecruitSelectFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["GarrisonCapacitiveDisplayFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["GarrisonLandingPageMinimapButton"] = {
		MoveAroundDisabledBy = "buttonsDisabled",
	},
	["ExpansionLandingPageMinimapButton"] = {
		MoveAroundDisabledBy = "buttonsDisabled",
	},
	["OrderHallMissionFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["OrderHallTalentFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["BFAMissionFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["ArtifactFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["ItemTextFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["PetStableFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["TaxiFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["FlightMapFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["PVPMatchScoreboard"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["PVPMatchResults"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["AlliedRacesFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["ChatConfigFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["ScrappingMachineFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["IslandsQueueFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["ItemUpgradeFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["ItemInteractionFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["ChallengesKeystoneFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["BonusRollFrame"] = {
		MoveAroundDisabledBy = "miscellaneousDisabled",
	},
	["GhostFrame"] = {
		MoveAroundDisabledBy = "buttonsDisabled",
	},
	["ObliterumForgeFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["PlayerChoiceFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["PlayerChoiceToggleButton"] = {
		MoveAroundDisabledBy = "buttonsDisabled",
	},
	["CypherPlayerChoiceToggleButton"] = {
		MoveAroundDisabledBy = "buttonsDisabled",
	},
	["ChromieTimeFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["WarfrontsPartyPoseFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["CovenantPreviewFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["CovenantRenownFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["CovenantSanctumFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["CovenantMissionFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["SoulbindViewer"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["TorghastLevelPickerFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["RuneforgeFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["WeeklyRewardsFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["AnimaDiversionFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["ContributionCollectionFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["DurabilityFrame"] = {
		DriftDisabledBy = "miscellaneousDisabled",
	},
	["VehicleSeatIndicator"] = {
		MoveAroundDisabledBy = "miscellaneousDisabled",
	},
	["GenericTraitFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
	["ObjectiveTrackerFrame"] = {
		MoveAroundDisabledBy = "miscellaneousDisabled",
		MoveAroundUnmovable = true
	},
	["ProfessionsCustomerOrdersFrame"] = {
		MoveAroundDisabledBy = "windowsDisabled",
	},
}

local MoveAround = CreateFrame("Frame")

local function eventHandler(self, event, ...)
	if event == "ADDON_LOADED" or event == "PLAYER_REGEN_ENABLED" then
		MoveAroundHelpers:ModifyFrames(frames)
	elseif event == "VARIABLES_LOADED" then
		MoveAroundHelpers:SetupConfig()

		for frameName, properties in pairs(frames) do
			local disabledBy = properties.MoveAroundDisabledBy
			if disabledBy ~= nil and MoveAroundOptions[disabledBy] then
				frames[frameName] = nil
			end
		end

		MoveAroundHelpers:ModifyFrames(frames)

		MoveAround:RegisterEvent("ADDON_LOADED")

		MoveAround:RegisterEvent("PLAYER_REGEN_ENABLED")
	end
end

MoveAround:SetScript("OnEvent", eventHandler)
MoveAround:RegisterEvent("VARIABLES_LOADED")