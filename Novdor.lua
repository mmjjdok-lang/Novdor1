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

local HorrorLibrary = {}

-- نظام محرك التدرج المتحرك (Blue & Purple Gradient Engine)
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

function HorrorLibrary:CreateWindow(config)
	config = config or {}
	local TitleText = config.Title or "SYSTEM UI"
	local SubTitleText = config.SubTitle or "Advanced System 2026"
	local Size = config.Size or UDim2.new(0, 580, 0, 350)
	local SelectedFont = GetValidFont(config.Font or Enum.Font.FredokaOne)
	local GlobalBackgroundImage = FormatAssetId(config.BackgroundImage or "103371567195289")

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "AdvancedGradientGui"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = PlayerGui

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = Size
	MainFrame.Position = UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2)
	MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
	MainFrame.BorderSizePixel = 0
	MainFrame.Active = true
	MainFrame.Draggable = true
	MainFrame.ClipsDescendants = true
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

	-- زر Open Button
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

	-- شريط العنوان
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
	CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CloseBtn.Text = "✕"
	CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseBtn.Font = SelectedFont
	CloseBtn.TextSize = 14
	CloseBtn.BorderSizePixel = 0
	CloseBtn.Parent = TitleBar
	CreateAnimatedGradient(CloseBtn)

	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0, 8)
	CloseCorner.Parent = CloseBtn

	CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

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

		-- شريط التبويبات الفرعية في اليسار بالأعلى (Sub-Tabs Bar)
		local SubTabBar = Instance.new("ScrollingFrame")
		SubTabBar.Size = UDim2.new(1, 0, 0, 30)
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
		SubContentContainer.Size = UDim2.new(1, 0, 1, -35)
		SubContentContainer.Position = UDim2.new(0, 0, 0, 35)
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

		-- نظام التبويبات الداخلي/الفرعي (Sub-Tabs System)
		function Tab:CreateSubTab(subTabName)
			local SubBtn = Instance.new("TextButton")
			SubBtn.Size = UDim2.new(0, 90, 1, 0)
			SubBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
			SubBtn.BorderSizePixel = 0
			SubBtn.Text = subTabName
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

			-- عناصر التحكم داخل التبويب الفرعي
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

				-- نظام زر الإعدادات باليمين فتح صفحة فرعية (Button Settings Page System)
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
						-- صفحة الإعدادات لـ هذا الزر
						local SettingsPage = Instance.new("Frame")
						SettingsPage.Size = UDim2.new(1, 0, 1, 0)
						SettingsPage.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
						SettingsPage.BorderSizePixel = 0
						SettingsPage.ZIndex = 5
						SettingsPage.Parent = SubContentContainer

						local SettPageCorner = Instance.new("UICorner")
						SettPageCorner.CornerRadius = UDim.new(0, 10)
						SettPageCorner.Parent = SettingsPage

						-- شريط العودة من صفحة الإعدادات
						local BackHeader = Instance.new("Frame")
						BackHeader.Size = UDim2.new(1, 0, 0, 32)
						BackHeader.BackgroundTransparency = 1
						BackHeader.ZIndex = 6
						BackHeader.Parent = SettingsPage

						local BackBtn = Instance.new("TextButton")
						BackBtn.Size = UDim2.new(0, 80, 0, 26)
						BackBtn.Position = UDim2.new(0, 6, 0.5, -13)
						BackBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
						BackBtn.Text = "◄ Exit"
						BackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
						BackBtn.Font = SelectedFont
						BackBtn.TextSize = 12
						BackBtn.ZIndex = 6
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
						SettTitle.ZIndex = 6
						SettTitle.Parent = BackHeader

						local SettingsContainer = Instance.new("ScrollingFrame")
						SettingsContainer.Size = UDim2.new(1, -12, 1, -40)
						SettingsContainer.Position = UDim2.new(0, 6, 0, 36)
						SettingsContainer.BackgroundTransparency = 1
						SettingsContainer.ZIndex = 6
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

			return SubTab
		end

		return Tab
	end

	MainFrame.Size = UDim2.new(0, 0, 0, 0)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame:TweenSizeAndPosition(Size, UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.4, true)

	return Window
end

return HorrorLibrary
