MoveAroundSlider = MoveAroundSlider or {}

local ListChanged = false

CurrencySlider = {}

local function Update_MoveAroundSlider(numTokenTypes,currencyInfo)
	local HeaderOrdering = {}
	local CurrentHead = currencyInfo[1].name
	for i=1, #MoveAroundSlider do
		HeaderOrdering[MoveAroundSlider[i].name] = i
	end
	for i = 1, numTokenTypes do
		local name, isHeader = currencyInfo[i].name, currencyInfo[i].isHeader
		if isHeader then
			if CurrentHead ~= name then
				MoveAroundSlider[HeaderOrdering[CurrentHead]].stop = i - 1
				HeaderOrdering[CurrentHead] = nil
			end
			CurrentHead = name
			if not HeaderOrdering[CurrentHead] then
				HeaderOrdering[CurrentHead] = #MoveAroundSlider + 1
			end
			MoveAroundSlider[HeaderOrdering[CurrentHead]] = {name = name, start = i}
		end
		if i == numTokenTypes then
			MoveAroundSlider[HeaderOrdering[CurrentHead]].stop = i
			HeaderOrdering[CurrentHead] = nil
		end
	end
	for _, v in pairs(HeaderOrdering) do
		tremove(MoveAroundSlider,v)
	end
end

local function FirstTimeSetup(numTokenTypes)
	local Cat = 1
	local Headers = 0
	for i = 1, numTokenTypes do
		local currencyInfo = C_CurrencyInfo.GetCurrencyListInfo(i)
		if currencyInfo.isHeader then
			Headers = Headers + 1
			if MoveAroundSlider[Cat] and not ( i == MoveAroundSlider[Cat].start) then
				MoveAroundSlider[Cat].stop = i - 1
				Cat = Cat + 1
			end
			local Category = {}
			Category.name = currencyInfo.name
			Category.start = i
			MoveAroundSlider[Cat] = Category
		end
		if i == numTokenTypes then
			MoveAroundSlider[Cat].stop = i
		end
	end
	MoveAroundSlider.Firsttime = true
	MoveAroundSlider.NumCat = Headers
	ListChanged = false
end


local function BuildList(numTokenTypes)
	if numTokenTypes == 0 then
		return
	end
	local Headers = 0
	local currencyInfo = {}
	if not(MoveAroundSlider.Firsttime) then
		FirstTimeSetup(numTokenTypes)
	else
		for i = 1,  numTokenTypes do
			currencyInfo[i] = C_CurrencyInfo.GetCurrencyListInfo(i)
			if currencyInfo[i].isHeader then
				Headers = Headers + 1
			end
		end
		ListChanged = ListChanged or MoveAroundSlider.NumCat ~= Headers or MoveAroundSlider.Nummax ~= numTokenTypes
	end

	MoveAroundSlider.Nummax = numTokenTypes
	MoveAroundSlider.NumCat = Headers

	if ListChanged then
		Update_MoveAroundSlider(numTokenTypes,currencyInfo)
		ListChanged = false
	end

	local Pos = 1
	local IndexList = {}
	for i = 1, #MoveAroundSlider do
		for I = MoveAroundSlider[i].start, MoveAroundSlider[i].stop do
			IndexList[Pos] = {index = I}
			Pos = Pos + 1
		end
	end
	return IndexList
end
local function Mod_TokenFrame_Update(resetScrollPosition)
	local numTokenTypes = C_CurrencyInfo.GetCurrencyListSize();
	if CharacterFrameTab3:IsVisible() then
		local newDataProvider = CreateDataProvider(BuildList(numTokenTypes));
		CharacterFrame.TokenFrame.ScrollBox:SetDataProvider(newDataProvider, not resetScrollPosition and ScrollBoxConstants.RetainScrollPosition);
	end
end

function CurrencySlider.MoveUp(frame)
	ListChanged = true
	for i = 1, #MoveAroundSlider do
		if MoveAroundSlider[i].name == frame:GetParent().Name:GetText() and i ~= 1 then
			local Temp = MoveAroundSlider[i]
			tremove(MoveAroundSlider,i)
			tinsert(MoveAroundSlider, i - 1, Temp)
			Mod_TokenFrame_Update()
			break
		end
	end
end

function CurrencySlider.MoveDown(frame)
	ListChanged = true
	for i = 1, #MoveAroundSlider do
		if MoveAroundSlider[i].name == frame:GetParent().Name:GetText() and i ~= #MoveAroundSlider then
			local Temp = MoveAroundSlider[i]
			tremove(MoveAroundSlider,i)
			tinsert(MoveAroundSlider, i + 1, Temp)
			Mod_TokenFrame_Update()
			break
		end
	end
end

local function CreateResetButton()
	local Button = CreateFrame("Button","$parentRevertButton",TokenFrame)
	Button:SetHeight(22)
	Button:SetWidth(22)
	Button:SetPoint("TOPRIGHT",TokenFrame,"TOPRIGHT",-8,-40)
	Button:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
	Button:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down");
	Button:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled");
	Button:Show()
	Button:SetFrameStrata("HIGH")
	Button:SetScript("OnEnter", function()
		GameTooltip:SetOwner(Button,"ANCHOR_RIGHT")
		GameTooltip:SetText("Reset to default sorting")
	end)
	Button:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	Button:SetScript("OnClick", function()
	MoveAroundSlider={}
	Mod_TokenFrame_Update()
	end	)
end


local ButtonsCreated = false
local function CreateArrowButtons()

	if ButtonsCreated then return end
	for i, frame in pairs(TokenFrame.ScrollBox:GetFrames()) do
		CreateFrame("Button", nil, frame ,"SortUpArrowTemplate", i)
		CreateFrame("Button", nil, frame ,"SortDownArrowTemplate", i)
		frame:HookScript("OnEnter", function (self)
			if self.isHeader then
				self.SortUpArrow:Show()
				self.SortDownArrow:Show()
			end
		end)
		frame:HookScript("OnLeave", function (self)
			self.SortUpArrow:Hide()
			self.SortDownArrow:Hide()
		end)
	end
	ButtonsCreated = true
end


local eventFrame = CreateFrame("FRAME")

local function Load()
	hooksecurefunc("TokenFrame_Update", Mod_TokenFrame_Update)
	TokenFrame:HookScript("OnShow",CreateArrowButtons)
	CreateResetButton()
	eventFrame:UnregisterEvent("ADDON_LOADED")
end

eventFrame:SetScript("OnEvent", function(_,event, name)
	if event == "ADDON_LOADED" then
		if name =="MoveAround" then
			if IsAddOnLoaded("Blizzard_TokenUI") then
				Load()
			end
		elseif name == "Blizzard_TokenUI" then
			Load()
		end
	end
end)
eventFrame:RegisterEvent("ADDON_LOADED")