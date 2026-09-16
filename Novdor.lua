local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ClickSound = Instance.new("Sound")
ClickSound.SoundId = "rbxassetid://131100371"
ClickSound.Volume = 0.5
ClickSound.Parent = SoundService

local NovdorLibrary = {}

local AnimatedGradients = {}

local function CreateAnimatedGradient(parent)
	local Gradient = Instance.new("UIGradient")
	Gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 102, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(153, 0, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 102, 255))
	})
	Gradient.Rotation = 45
	Gradient.Parent = parent
	table.insert(AnimatedGradients, Gradient)
	return Gradient
end

RunService.RenderStepped:Connect(function(deltaTime)
	for _, gradient in ipairs(AnimatedGradients) do
		if gradient and gradient.Parent then
			gradient.Rotation = (gradient.Rotation + (deltaTime * 250)) % 360
		end
	end
end)

local function GetValidFont(fontInput)
	local defaultFont = Enum.Font.FredokaOne
	if not fontInput then return defaultFont end
	if typeof(fontInput) == "EnumItem" and fontInput.EnumType == Enum.Font then
		return fontInput
	elseif type(fontInput) == "string" then
		local success, fontEnum = pcall(function() return Enum.Font[fontInput] end)
		if success and fontEnum then return fontEnum end
	end
	return defaultFont
end

local function FormatAssetId(id)
	if not id then return "rbxassetid://103371567195289" end
	local strId = tostring(id)
	if strId:find("rbxassetid://") then return strId
	else
		local cleanId = strId:match("%d+")
		if cleanId then return "rbxassetid://" .. cleanId end
	end
	return "rbxassetid://103371567195289"
end

function NovdorLibrary:CreateWindow(config)
	config = config or {}
	local TitleText = config.Title or "NOVDOR UI"
	local SubTitleText = config.SubTitle or "Animated Blue-Purple Theme"
	local Size = config.Size or UDim2.new(0, 580, 0, 350)
	local SelectedFont = GetValidFont(config.Font or Enum.Font.FredokaOne)
	local GlobalBackgroundImage = FormatAssetId(config.BackgroundImage or "103371567195289")

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "NovdorGui"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.DisplayOrder = 999
	ScreenGui.Parent = PlayerGui

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = Size
	MainFrame.Position = UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2)
	MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
	MainFrame.BorderSizePixel = 0
	MainFrame.Active = true
	MainFrame.Draggable = true
	MainFrame.ClipsDescendants = false
	MainFrame.Parent = ScreenGui

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 16)
	MainCorner.Parent = MainFrame

	local MainStroke = Instance.new("UIStroke")
	MainStroke.Thickness = 2.5
	MainStroke.Parent = MainFrame
	CreateAnimatedGradient(MainStroke)

	local BackgroundImage = Instance.new("ImageLabel")
	BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
	BackgroundImage.Image = GlobalBackgroundImage
	BackgroundImage.ImageTransparency = 0.85
	BackgroundImage.BackgroundTransparency = 1
	BackgroundImage.ScaleType = Enum.ScaleType.Crop
	BackgroundImage.Parent = MainFrame

	local NotificationContainer = Instance.new("Frame")
	NotificationContainer.Name = "NotificationContainer"
	NotificationContainer.Size = UDim2.new(0, 260, 1, -20)
	NotificationContainer.Position = UDim2.new(1, -270, 0, 10)
	NotificationContainer.BackgroundTransparency = 1
	NotificationContainer.Parent = ScreenGui

	local NotifLayout = Instance.new("UIListLayout")
	NotifLayout.Parent = NotificationContainer
	NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
	NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	NotifLayout.Padding = UDim.new(0, 8)

	function NovdorLibrary:Notify(notifConfig)
		notifConfig = notifConfig or {}
		local nTitle = notifConfig.Title or "NOTIFICATION"
		local nText = notifConfig.Text or ""
		local duration = notifConfig.Duration or 4

		local NotifFrame = Instance.new("Frame")
		NotifFrame.Size = UDim2.new(1, 0, 0, 65)
		NotifFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
		NotifFrame.BorderSizePixel = 0
		NotifFrame.ClipsDescendants = true
		NotifFrame.Parent = NotificationContainer

		local NotifCorner = Instance.new("UICorner")
		NotifCorner.CornerRadius = UDim.new(0, 12)
		NotifCorner.Parent = NotifFrame

		local NotifStroke = Instance.new("UIStroke")
		NotifStroke.Thickness = 2
		NotifStroke.Parent = NotifFrame
		CreateAnimatedGradient(NotifStroke)

		local NotifTitle = Instance.new("TextLabel")
		NotifTitle.Size = UDim2.new(1, -16, 0, 20)
		NotifTitle.Position = UDim2.new(0, 12, 0, 8)
		NotifTitle.Text = nTitle
		NotifTitle.TextColor3 = Color3.fromRGB(180, 130, 255)
		NotifTitle.Font = SelectedFont
		NotifTitle.TextSize = 14
		NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
		NotifTitle.BackgroundTransparency = 1
		NotifTitle.Parent = NotifFrame

		local NotifDesc = Instance.new("TextLabel")
		NotifDesc.Size = UDim2.new(1, -16, 0, 25)
		NotifDesc.Position = UDim2.new(0, 12, 0, 28)
		NotifDesc.Text = nText
		NotifDesc.TextColor3 = Color3.fromRGB(220, 220, 230)
		NotifDesc.Font = SelectedFont
		NotifDesc.TextSize = 12
		NotifDesc.TextXAlignment = Enum.TextXAlignment.Left
		NotifDesc.BackgroundTransparency = 1
		NotifDesc.Parent = NotifFrame

		local ProgressBarBg = Instance.new("Frame")
		ProgressBarBg.Size = UDim2.new(1, -24, 0, 4)
		ProgressBarBg.Position = UDim2.new(0, 12, 1, -8)
		ProgressBarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
		ProgressBarBg.BorderSizePixel = 0
		ProgressBarBg.Parent = NotifFrame

		local BarCorner = Instance.new("UICorner")
		BarCorner.CornerRadius = UDim.new(1, 0)
		BarCorner.Parent = ProgressBarBg

		local ProgressBarFill = Instance.new("Frame")
		ProgressBarFill.Size = UDim2.new(1, 0, 1, 0)
		ProgressBarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ProgressBarFill.BorderSizePixel = 0
		ProgressBarFill.Parent = ProgressBarBg
		CreateAnimatedGradient(ProgressBarFill)

		local FillCorner = Instance.new("UICorner")
		FillCorner.CornerRadius = UDim.new(1, 0)
		FillCorner.Parent = ProgressBarFill

		ClickSound:Play()
		TweenService:Create(ProgressBarFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()

		task.delay(duration, function()
			TweenService:Create(NotifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
			NotifFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true, function()
				NotifFrame:Destroy()
			end)
		end)
	end

	local OpenBtn = Instance.new("TextButton")
	OpenBtn.Name = "OpenButton"
	OpenBtn.Size = UDim2.new(0, 90, 0, 40)
	OpenBtn.Position = UDim2.new(0, 20, 1, -60)
	OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
	OpenBtn.BorderSizePixel = 0
	OpenBtn.Text = "OPEN"
	OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	OpenBtn.Font = SelectedFont
	OpenBtn.TextSize = 15
	OpenBtn.Active = true
	OpenBtn.Draggable = true
	OpenBtn.Parent = ScreenGui

	local OpenCorner = Instance.new("UICorner")
	OpenCorner.CornerRadius = UDim.new(0, 12)
	OpenCorner.Parent = OpenBtn

	local OpenStroke = Instance.new("UIStroke")
	OpenStroke.Thickness = 2
	OpenStroke.Parent = OpenBtn
	CreateAnimatedGradient(OpenStroke)

	local isOpened = true
	OpenBtn.MouseButton1Click:Connect(function()
		ClickSound:Play()
		isOpened = not isOpened
		if isOpened then
			MainFrame.Visible = true
			MainFrame:TweenSizeAndPosition(Size, UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
		else
			MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.3, true, function()
				MainFrame.Visible = false
			end)
		end
	end)

	local TitleBar = Instance.new("Frame")
	TitleBar.Size = UDim2.new(1, 0, 0, 50)
	TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
	TitleBar.BorderSizePixel = 0
	TitleBar.Parent = MainFrame

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1, -100, 0, 22)
	TitleLabel.Position = UDim2.new(0, 16, 0, 8)
	TitleLabel.Text = TitleText
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.TextSize = 18
	TitleLabel.Font = SelectedFont
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Parent = TitleBar

	local SubTitleLabel = Instance.new("TextLabel")
	SubTitleLabel.Size = UDim2.new(1, -100, 0, 15)
	SubTitleLabel.Position = UDim2.new(0, 16, 0, 28)
	SubTitleLabel.Text = SubTitleText
	SubTitleLabel.TextColor3 = Color3.fromRGB(170, 140, 255)
	SubTitleLabel.TextSize = 11
	SubTitleLabel.Font = SelectedFont
	SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	SubTitleLabel.BackgroundTransparency = 1
	SubTitleLabel.Parent = TitleBar

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Size = UDim2.new(0, 28, 0, 28)
	CloseBtn.Position = UDim2.new(1, -34, 0, 11)
	CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
	CloseBtn.Text = "✕"
	CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseBtn.Font = SelectedFont
	CloseBtn.TextSize = 14
	CloseBtn.BorderSizePixel = 0
	CloseBtn.Parent = TitleBar

	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0, 8)
	CloseCorner.Parent = CloseBtn

	CloseBtn.MouseButton1Click:Connect(function()
		ClickSound:Play()
		local ConfirmFrame = Instance.new("Frame")
		ConfirmFrame.Size = UDim2.new(0, 300, 0, 140)
		ConfirmFrame.Position = UDim2.new(0.5, -150, 0.5, -70)
		ConfirmFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
		ConfirmFrame.BorderSizePixel = 0
		ConfirmFrame.ZIndex = 50
		ConfirmFrame.Parent = ScreenGui

		local ConfirmCorner = Instance.new("UICorner")
		ConfirmCorner.CornerRadius = UDim.new(0, 12)
		ConfirmCorner.Parent = ConfirmFrame

		local ConfirmStroke = Instance.new("UIStroke")
		ConfirmStroke.Thickness = 2
		ConfirmStroke.Parent = ConfirmFrame
		CreateAnimatedGradient(ConfirmStroke)

		local ConfirmTitle = Instance.new("TextLabel")
		ConfirmTitle.Size = UDim2.new(1, 0, 0, 50)
		ConfirmTitle.Text = "هل أنت متأكد من إغلاق وحذف السكربت؟"
		ConfirmTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		ConfirmTitle.Font = SelectedFont
		ConfirmTitle.TextSize = 13
		ConfirmTitle.BackgroundTransparency = 1
		ConfirmTitle.ZIndex = 51
		ConfirmTitle.Parent = ConfirmFrame

		local YesBtn = Instance.new("TextButton")
		YesBtn.Size = UDim2.new(0, 110, 0, 34)
		YesBtn.Position = UDim2.new(0, 25, 1, -50)
		YesBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
		YesBtn.Text = "نعم (حذف)"
		YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		YesBtn.Font = SelectedFont
		YesBtn.TextSize = 13
		YesBtn.ZIndex = 51
		YesBtn.Parent = ConfirmFrame

		local YesCorner = Instance.new("UICorner")
		YesCorner.CornerRadius = UDim.new(0, 8)
		YesCorner.Parent = YesBtn

		local NoBtn = Instance.new("TextButton")
		NoBtn.Size = UDim2.new(0, 110, 0, 34)
		NoBtn.Position = UDim2.new(1, -135, 1, -50)
		NoBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
		NoBtn.Text = "إلغاء"
		NoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		NoBtn.Font = SelectedFont
		NoBtn.TextSize = 13
		NoBtn.ZIndex = 51
		NoBtn.Parent = ConfirmFrame

		local NoCorner = Instance.new("UICorner")
		NoCorner.CornerRadius = UDim.new(0, 8)
		NoCorner.Parent = NoBtn

		YesBtn.MouseButton1Click:Connect(function()
			ClickSound:Play()
			ScreenGui:Destroy()
		end)

		NoBtn.MouseButton1Click:Connect(function()
			ClickSound:Play()
			ConfirmFrame:Destroy()
		end)
	end)

	local TabSidebar = Instance.new("ScrollingFrame")
	TabSidebar.Size = UDim2.new(0, 140, 1, -65)
	TabSidebar.Position = UDim2.new(0, 10, 0, 58)
	TabSidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
	TabSidebar.BorderSizePixel = 0
	TabSidebar.ScrollBarThickness = 2
	TabSidebar.Parent = MainFrame

	local SideCorner = Instance.new("UICorner")
	SideCorner.CornerRadius = UDim.new(0, 12)
	SideCorner.Parent = TabSidebar

	local SidebarLayout = Instance.new("UIListLayout")
	SidebarLayout.Parent = TabSidebar
	SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SidebarLayout.Padding = UDim.new(0, 6)

	SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabSidebar.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 10)
	end)

	local ContentContainer = Instance.new("Frame")
	ContentContainer.Size = UDim2.new(1, -170, 1, -65)
	ContentContainer.Position = UDim2.new(0, 160, 0, 58)
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Parent = MainFrame

	local Window = { Tabs = {} }

	function Window:CreateTab(tabName)
		local TabButton = Instance.new("TextButton")
		TabButton.Size = UDim2.new(1, -8, 0, 34)
		TabButton.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
		TabButton.BorderSizePixel = 0
		TabButton.Text = tabName
		TabButton.TextColor3 = Color3.fromRGB(180, 180, 200)
		TabButton.Font = SelectedFont
		TabButton.TextSize = 13
		TabButton.Parent = TabSidebar

		local TabBtnCorner = Instance.new("UICorner")
		TabBtnCorner.CornerRadius = UDim.new(0, 8)
		TabBtnCorner.Parent = TabButton

		local TabStroke = Instance.new("UIStroke")
		TabStroke.Thickness = 1.5
		TabStroke.Transparency = 1
		TabStroke.Parent = TabButton
		CreateAnimatedGradient(TabStroke)

		local TabPage = Instance.new("Frame")
		TabPage.Size = UDim2.new(1, 0, 1, 0)
		TabPage.BackgroundTransparency = 1
		TabPage.Visible = false
		TabPage.Parent = ContentContainer

		local SubTabBar = Instance.new("ScrollingFrame")
		SubTabBar.Size = UDim2.new(1, 0, 0, 32)
		SubTabBar.Position = UDim2.new(0, 0, 0, 0)
		SubTabBar.BackgroundTransparency = 1
		SubTabBar.BorderSizePixel = 0
		SubTabBar.ScrollBarThickness = 0
		SubTabBar.Parent = TabPage

		local SubTabLayout = Instance.new("UIListLayout")
		SubTabLayout.Parent = SubTabBar
		SubTabLayout.FillDirection = Enum.FillDirection.Horizontal
		SubTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
		SubTabLayout.Padding = UDim.new(0, 6)

		local SubContentContainer = Instance.new("Frame")
		SubContentContainer.Size = UDim2.new(1, 0, 1, -38)
		SubContentContainer.Position = UDim2.new(0, 0, 0, 38)
		SubContentContainer.BackgroundTransparency = 1
		SubContentContainer.Parent = TabPage

		TabButton.MouseButton1Click:Connect(function()
			ClickSound:Play()
			for _, tab in pairs(Window.Tabs) do
				tab.Page.Visible = false
				tab.Stroke.Transparency = 1
				TweenService:Create(tab.Button, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(180, 180, 200)}):Play()
			end
			TabPage.Visible = true
			TabStroke.Transparency = 0
			TweenService:Create(TabButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		end)

		if #Window.Tabs == 0 then
			TabPage.Visible = true
			TabStroke.Transparency = 0
			TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		end

		local Tab = {Button = TabButton, Page = TabPage, Stroke = TabStroke, SubTabs = {}}

		function Tab:CreateSubTab(subTabName)
			local SubBtn = Instance.new("TextButton")
			SubBtn.Size = UDim2.new(0, 100, 1, 0)
			SubBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
			SubBtn.BorderSizePixel = 0
			SubBtn.Text = subTabName or "Sub Tab"
			SubBtn.TextColor3 = Color3.fromRGB(160, 160, 180)
			SubBtn.Font = SelectedFont
			SubBtn.TextSize = 12
			SubBtn.Parent = SubTabBar

			local SubBtnCorner = Instance.new("UICorner")
			SubBtnCorner.CornerRadius = UDim.new(0, 6)
			SubBtnCorner.Parent = SubBtn

			local SubBtnStroke = Instance.new("UIStroke")
			SubBtnStroke.Thickness = 1
			SubBtnStroke.Transparency = 1
			SubBtnStroke.Parent = SubBtn
			CreateAnimatedGradient(SubBtnStroke)

			local SubPage = Instance.new("ScrollingFrame")
			SubPage.Size = UDim2.new(1, 0, 1, 0)
			SubPage.BackgroundTransparency = 1
			SubPage.Visible = false
			SubPage.ScrollBarThickness = 2
			SubPage.Parent = SubContentContainer

			local PageLayout = Instance.new("UIListLayout")
			PageLayout.Parent = SubPage
			PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
			PageLayout.Padding = UDim.new(0, 8)

			PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				SubPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
			end)

			SubBtn.MouseButton1Click:Connect(function()
				ClickSound:Play()
				for _, sub in pairs(Tab.SubTabs) do
					sub.Page.Visible = false
					sub.Stroke.Transparency = 1
					sub.Btn.TextColor3 = Color3.fromRGB(160, 160, 180)
				end
				SubPage.Visible = true
				SubBtnStroke.Transparency = 0
				SubBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			end)

			if #Tab.SubTabs == 0 then
				SubPage.Visible = true
				SubBtnStroke.Transparency = 0
				SubBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			end

			local SubTab = {Btn = SubBtn, Page = SubPage, Stroke = SubBtnStroke}
			table.insert(Tab.SubTabs, SubTab)

			function SubTab:AddButton(text, callback, settingsCallback)
				local BtnFrame = Instance.new("Frame")
				BtnFrame.Size = UDim2.new(1, -6, 0, 36)
				BtnFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
				BtnFrame.BorderSizePixel = 0
				BtnFrame.Parent = SubPage

				local BtnCorner = Instance.new("UICorner")
				BtnCorner.CornerRadius = UDim.new(0, 8)
				BtnCorner.Parent = BtnFrame

				local BtnStroke = Instance.new("UIStroke")
				BtnStroke.Thickness = 1.5
				BtnStroke.Parent = BtnFrame
				CreateAnimatedGradient(BtnStroke)

				local ActionBtn = Instance.new("TextButton")
				ActionBtn.Size = settingsCallback and UDim2.new(1, -40, 1, 0) or UDim2.new(1, 0, 1, 0)
				ActionBtn.BackgroundTransparency = 1
				ActionBtn.Text = text
				ActionBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
				ActionBtn.Font = SelectedFont
				ActionBtn.TextSize = 13
				ActionBtn.Parent = BtnFrame

				ActionBtn.MouseButton1Click:Connect(function()
					ClickSound:Play()
					if callback then callback() end
				end)

				if settingsCallback then
					local SettingsBtn = Instance.new("TextButton")
					SettingsBtn.Size = UDim2.new(0, 30, 0, 30)
					SettingsBtn.Position = UDim2.new(1, -33, 0.5, -15)
					SettingsBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
					SettingsBtn.Text = "⚙️"
					SettingsBtn.TextSize = 14
					SettingsBtn.Parent = BtnFrame

					local SettCorner = Instance.new("UICorner")
					SettCorner.CornerRadius = UDim.new(0, 6)
					SettCorner.Parent = SettingsBtn

					SettingsBtn.MouseButton1Click:Connect(function()
						ClickSound:Play()
						local SettingsPage = Instance.new("Frame")
						SettingsPage.Size = UDim2.new(1, 0, 1, 0)
						SettingsPage.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
						SettingsPage.BorderSizePixel = 0
						SettingsPage.ZIndex = 15
						SettingsPage.Parent = SubContentContainer

						local SettPageCorner = Instance.new("UICorner")
						SettPageCorner.CornerRadius = UDim.new(0, 10)
						SettPageCorner.Parent = SettingsPage

						local BackHeader = Instance.new("Frame")
						BackHeader.Size = UDim2.new(1, 0, 0, 32)
						BackHeader.BackgroundTransparency = 1
						BackHeader.ZIndex = 16
						BackHeader.Parent = SettingsPage

						local BackBtn = Instance.new("TextButton")
						BackBtn.Size = UDim2.new(0, 80, 0, 26)
						BackBtn.Position = UDim2.new(0, 6, 0.5, -13)
						BackBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
						BackBtn.Text = "◄ Exit"
						BackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
						BackBtn.Font = SelectedFont
						BackBtn.TextSize = 12
						BackBtn.ZIndex = 16
						BackBtn.Parent = BackHeader

						local BackCorner = Instance.new("UICorner")
						BackCorner.CornerRadius = UDim.new(0, 6)
						BackCorner.Parent = BackBtn

						local SettTitle = Instance.new("TextLabel")
						SettTitle.Size = UDim2.new(1, -100, 1, 0)
						SettTitle.Position = UDim2.new(0, 95, 0, 0)
						SettTitle.Text = text .. " Settings"
						SettTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
						SettTitle.Font = SelectedFont
						SettTitle.TextSize = 13
						SettTitle.TextXAlignment = Enum.TextXAlignment.Left
						SettTitle.BackgroundTransparency = 1
						SettTitle.ZIndex = 16
						SettTitle.Parent = BackHeader

						local SettingsContainer = Instance.new("ScrollingFrame")
						SettingsContainer.Size = UDim2.new(1, -12, 1, -40)
						SettingsContainer.Position = UDim2.new(0, 6, 0, 36)
						SettingsContainer.BackgroundTransparency = 1
						SettingsContainer.ZIndex = 16
						SettingsContainer.Parent = SettingsPage

						local SettLayout = Instance.new("UIListLayout")
						SettLayout.Parent = SettingsContainer
						SettLayout.Padding = UDim.new(0, 6)

						BackBtn.MouseButton1Click:Connect(function()
							ClickSound:Play()
							SettingsPage:Destroy()
						end)

						if settingsCallback then settingsCallback(SettingsContainer) end
					end)
				end
			end

			function SubTab:AddToggle(text, default, callback)
				local TglFrame = Instance.new("Frame")
				TglFrame.Size = UDim2.new(1, -6, 0, 36)
				TglFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
				TglFrame.BorderSizePixel = 0
				TglFrame.Parent = SubPage

				local TglCorner = Instance.new("UICorner")
				TglCorner.CornerRadius = UDim.new(0, 8)
				TglCorner.Parent = TglFrame

				local TglStroke = Instance.new("UIStroke")
				TglStroke.Thickness = 1
				TglStroke.Transparency = 0.5
				TglStroke.Parent = TglFrame
				CreateAnimatedGradient(TglStroke)

				local TglLabel = Instance.new("TextLabel")
				TglLabel.Size = UDim2.new(1, -60, 1, 0)
				TglLabel.Position = UDim2.new(0, 12, 0, 0)
				TglLabel.Text = text
				TglLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
				TglLabel.Font = SelectedFont
				TglLabel.TextSize = 13
				TglLabel.TextXAlignment = Enum.TextXAlignment.Left
				TglLabel.BackgroundTransparency = 1
				TglLabel.Parent = TglFrame

				local SwitchBg = Instance.new("Frame")
				SwitchBg.Size = UDim2.new(0, 38, 0, 20)
				SwitchBg.Position = UDim2.new(1, -48, 0.5, -10)
				SwitchBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
				SwitchBg.BorderSizePixel = 0
				SwitchBg.Parent = TglFrame

				local SwitchCorner = Instance.new("UICorner")
				SwitchCorner.CornerRadius = UDim.new(1, 0)
				SwitchCorner.Parent = SwitchBg

				local SwitchGradient = CreateAnimatedGradient(SwitchBg)
				SwitchGradient.Enabled = default or false

				local Dot = Instance.new("Frame")
				Dot.Size = UDim2.new(0, 14, 0, 14)
				Dot.Position = default and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
				Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Dot.BorderSizePixel = 0
				Dot.Parent = SwitchBg

				local DotCorner = Instance.new("UICorner")
				DotCorner.CornerRadius = UDim.new(1, 0)
				DotCorner.Parent = Dot

				local TriggerBtn = Instance.new("TextButton")
				TriggerBtn.Size = UDim2.new(1, 0, 1, 0)
				TriggerBtn.BackgroundTransparency = 1
				TriggerBtn.Text = ""
				TriggerBtn.Parent = TglFrame

				local state = default or false
				TriggerBtn.MouseButton1Click:Connect(function()
					ClickSound:Play()
					state = not state
					SwitchGradient.Enabled = state
					TweenService:Create(Dot, TweenInfo.new(0.2), {
						Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
					}):Play()
					if callback then callback(state) end
				end)
			end

			function SubTab:AddSlider(text, min, max, default, callback)
				local SldFrame = Instance.new("Frame")
				SldFrame.Size = UDim2.new(1, -6, 0, 45)
				SldFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
				SldFrame.BorderSizePixel = 0
				SldFrame.Parent = SubPage

				local SldCorner = Instance.new("UICorner")
				SldCorner.CornerRadius = UDim.new(0, 8)
				SldCorner.Parent = SldFrame

				local SldStroke = Instance.new("UIStroke")
				SldStroke.Thickness = 1
				SldStroke.Transparency = 0.5
				SldStroke.Parent = SldFrame
				CreateAnimatedGradient(SldStroke)

				local SldLabel = Instance.new("TextLabel")
				SldLabel.Size = UDim2.new(1, -60, 0, 20)
				SldLabel.Position = UDim2.new(0, 12, 0, 4)
				SldLabel.Text = text
				SldLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
				SldLabel.Font = SelectedFont
				SldLabel.TextSize = 12
				SldLabel.TextXAlignment = Enum.TextXAlignment.Left
				SldLabel.BackgroundTransparency = 1
				SldLabel.Parent = SldFrame

				local ValLabel = Instance.new("TextLabel")
				ValLabel.Size = UDim2.new(0, 50, 0, 20)
				ValLabel.Position = UDim2.new(1, -55, 0, 4)
				ValLabel.Text = tostring(default or min)
				ValLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
				ValLabel.Font = SelectedFont
				ValLabel.TextSize = 12
				ValLabel.TextXAlignment = Enum.TextXAlignment.Right
				ValLabel.BackgroundTransparency = 1
				ValLabel.Parent = SldFrame

				local BarBg = Instance.new("Frame")
				BarBg.Size = UDim2.new(1, -24, 0, 6)
				BarBg.Position = UDim2.new(0, 12, 1, -12)
				BarBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
				BarBg.BorderSizePixel = 0
				BarBg.Parent = SldFrame

				local BarBgCorner = Instance.new("UICorner")
				BarBgCorner.CornerRadius = UDim.new(1, 0)
				BarBgCorner.Parent = BarBg

				local BarFill = Instance.new("Frame")
				BarFill.Size = UDim2.new(math.clamp(((default or min) - min) / (max - min), 0, 1), 0, 1, 0)
				BarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				BarFill.BorderSizePixel = 0
				BarFill.Parent = BarBg
				CreateAnimatedGradient(BarFill)

				local BarFillCorner = Instance.new("UICorner")
				BarFillCorner.CornerRadius = UDim.new(1, 0)
				BarFillCorner.Parent = BarFill

				local isDragging = false
				local function UpdateSlider(input)
					local pos = math.clamp((input.Position.X - BarBg.AbsolutePosition.X) / BarBg.AbsoluteSize.X, 0, 1)
					local val = math.floor(min + (max - min) * pos)
					BarFill.Size = UDim2.new(pos, 0, 1, 0)
					ValLabel.Text = tostring(val)
					if callback then callback(val) end
				end

				BarBg.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						isDragging = true
						UpdateSlider(input)
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						isDragging = false
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						UpdateSlider(input)
					end
				end)
			end

			function SubTab:AddTextBox(text, placeholder, callback)
				local BoxFrame = Instance.new("Frame")
				BoxFrame.Size = UDim2.new(1, -6, 0, 36)
				BoxFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
				BoxFrame.BorderSizePixel = 0
				BoxFrame.Parent = SubPage

				local BoxCorner = Instance.new("UICorner")
				BoxCorner.CornerRadius = UDim.new(0, 8)
				BoxCorner.Parent = BoxFrame

				local BoxStroke = Instance.new("UIStroke")
				BoxStroke.Thickness = 1
				BoxStroke.Transparency = 0.5
				BoxStroke.Parent = BoxFrame
				CreateAnimatedGradient(BoxStroke)

				local BoxLabel = Instance.new("TextLabel")
				BoxLabel.Size = UDim2.new(0.5, -10, 1, 0)
				BoxLabel.Position = UDim2.new(0, 12, 0, 0)
				BoxLabel.Text = text
				BoxLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
				BoxLabel.Font = SelectedFont
				BoxLabel.TextSize = 13
				BoxLabel.TextXAlignment = Enum.TextXAlignment.Left
				BoxLabel.BackgroundTransparency = 1
				BoxLabel.Parent = BoxFrame

				local InputBox = Instance.new("TextBox")
				InputBox.Size = UDim2.new(0.5, -12, 0, 24)
				InputBox.Position = UDim2.new(0.5, 0, 0.5, -12)
				InputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
				InputBox.BorderSizePixel = 0
				InputBox.Text = ""
				InputBox.PlaceholderText = placeholder or "Enter text..."
				InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
				InputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
				InputBox.Font = SelectedFont
				InputBox.TextSize = 12
				InputBox.Parent = BoxFrame

				local InputCorner = Instance.new("UICorner")
				InputCorner.CornerRadius = UDim.new(0, 6)
				InputCorner.Parent = InputBox

				InputBox.FocusLost:Connect(function(enterPressed)
					if enterPressed and callback then
						callback(InputBox.Text)
					end
				end)
			end

			function SubTab:AddDropdown(text, options, callback)
				options = options or {}
				local DropFrame = Instance.new("Frame")
				DropFrame.Size = UDim2.new(1, -6, 0, 36)
				DropFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
				DropFrame.BorderSizePixel = 0
				DropFrame.ClipsDescendants = true
				DropFrame.Parent = SubPage

				local DropCorner = Instance.new("UICorner")
				DropCorner.CornerRadius = UDim.new(0, 8)
				DropCorner.Parent = DropFrame

				local DropStroke = Instance.new("UIStroke")
				DropStroke.Thickness = 1
				DropStroke.Transparency = 0.5
				DropStroke.Parent = DropFrame
				CreateAnimatedGradient(DropStroke)

				local DropLabel = Instance.new("TextLabel")
				DropLabel.Size = UDim2.new(1, -40, 0, 36)
				DropLabel.Position = UDim2.new(0, 12, 0, 0)
				DropLabel.Text = text
				DropLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
				DropLabel.Font = SelectedFont
				DropLabel.TextSize = 13
				DropLabel.TextXAlignment = Enum.TextXAlignment.Left
				DropLabel.BackgroundTransparency = 1
				DropLabel.Parent = DropFrame

				local Arrow = Instance.new("TextLabel")
				Arrow.Size = UDim2.new(0, 30, 0, 36)
				Arrow.Position = UDim2.new(1, -30, 0, 0)
				Arrow.Text = "▼"
				Arrow.TextColor3 = Color3.fromRGB(180, 180, 200)
				Arrow.Font = SelectedFont
				Arrow.TextSize = 12
				Arrow.BackgroundTransparency = 1
				Arrow.Parent = DropFrame

				local OptionContainer = Instance.new("Frame")
				OptionContainer.Size = UDim2.new(1, -12, 0, #options * 28)
				OptionContainer.Position = UDim2.new(0, 6, 0, 36)
				OptionContainer.BackgroundTransparency = 1
				OptionContainer.Parent = DropFrame

				local OptLayout = Instance.new("UIListLayout")
				OptLayout.Parent = OptionContainer
				OptLayout.Padding = UDim.new(0, 2)

				local isOpen = false
				local DropBtn = Instance.new("TextButton")
				DropBtn.Size = UDim2.new(1, 0, 0, 36)
				DropBtn.BackgroundTransparency = 1
				DropBtn.Text = ""
				DropBtn.Parent = DropFrame

				DropBtn.MouseButton1Click:Connect(function()
					ClickSound:Play()
					isOpen = not isOpen
					Arrow.Text = isOpen and "▲" or "▼"
					local targetSize = isOpen and UDim2.new(1, -6, 0, 40 + (#options * 28)) or UDim2.new(1, -6, 0, 36)
					TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = targetSize}):Play()
				end)

				for _, optName in ipairs(options) do
					local OptBtn = Instance.new("TextButton")
					OptBtn.Size = UDim2.new(1, 0, 0, 26)
					OptBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
					OptBtn.BorderSizePixel = 0
					OptBtn.Text = optName
					OptBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
					OptBtn.Font = SelectedFont
					OptBtn.TextSize = 12
					OptBtn.Parent = OptionContainer

					local OptCorner = Instance.new("UICorner")
					OptCorner.CornerRadius = UDim.new(0, 4)
					OptCorner.Parent = OptBtn

					OptBtn.MouseButton1Click:Connect(function()
						ClickSound:Play()
						DropLabel.Text = text .. " (" .. optName .. ")"
						isOpen = false
						Arrow.Text = "▼"
						TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -6, 0, 36)}):Play()
						if callback then callback(optName) end
					end)
				end
			end

			return SubTab
		end

		table.insert(Window.Tabs, Tab)
		return Tab
	end

	MainFrame.Size = UDim2.new(0, 0, 0, 0)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame:TweenSizeAndPosition(Size, UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.4, true)

	return Window
end

local Utilities = {}

function Utilities:CreateShadow(parent)
	local Shadow = Instance.new("ImageLabel")
	Shadow.Name = "DropShadow"
	Shadow.Size = UDim2.new(1, 10, 1, 10)
	Shadow.Position = UDim2.new(0, -5, 0, -5)
	Shadow.BackgroundTransparency = 1
	Shadow.Image = "rbxassetid://1316045217"
	Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	Shadow.ImageTransparency = 0.5
	Shadow.ScaleType = Enum.ScaleType.Slice
	Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
	Shadow.Parent = parent
	return Shadow
end

function Utilities:AddToolTip(guiObject, text)
	local Tooltip = Instance.new("TextLabel")
	Tooltip.Name = "Tooltip"
	Tooltip.Size = UDim2.new(0, 100, 0, 20)
	Tooltip.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	Tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
	Tooltip.Text = text
	Tooltip.TextSize = 11
	Tooltip.Visible = false
	Tooltip.ZIndex = 10
	Tooltip.Parent = PlayerGui

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 4)
	Corner.Parent = Tooltip

	guiObject.MouseEnter:Connect(function()
		Tooltip.Visible = true
	end)

	guiObject.MouseLeave:Connect(function()
		Tooltip.Visible = false
	end)

	guiObject.MouseMoved:Connect(function(x, y)
		Tooltip.Position = UDim2.new(0, x + 10, 0, y + 10)
	end)
end

function Utilities:RippleEffect(button)
	button.ClipsDescendants = true
	button.MouseButton1Click:Connect(function()
		local mouse = LocalPlayer:GetMouse()
		local x = mouse.X - button.AbsolutePosition.X
		local y = mouse.Y - button.AbsolutePosition.Y

		local Circle = Instance.new("Frame")
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 0.6
		Circle.Position = UDim2.new(0, x, 0, y)
		Circle.Size = UDim2.new(0, 0, 0, 0)
		Circle.Parent = button

		local CircleCorner = Instance.new("UICorner")
		CircleCorner.CornerRadius = UDim.new(1, 0)
		CircleCorner.Parent = Circle

		local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2

		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tween = TweenService:Create(Circle, tweenInfo, {
			Size = UDim2.new(0, maxSize, 0, maxSize),
			Position = UDim2.new(0, x - maxSize / 2, 0, y - maxSize / 2),
			BackgroundTransparency = 1
		})

		tween:Play()
		tween.Completed:Connect(function()
			Circle:Destroy()
		end)
	end)
end

function NovdorLibrary:Destroy()
	for _, gui in ipairs(PlayerGui:GetChildren()) do
		if gui.Name == "NovdorGui" then
			gui:Destroy()
		end
	end
end

return NovdorLibrary
