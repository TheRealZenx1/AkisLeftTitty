-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ExploitGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 450)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Rounded corners for frame
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Exploit GUI"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 22
titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -40, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 22
closeButton.Text = "✕"
closeButton.Parent = titleBar

local closeUICorner = Instance.new("UICorner")
closeUICorner.CornerRadius = UDim.new(0, 5)
closeUICorner.Parent = closeButton

closeButton.MouseEnter:Connect(function()
	closeButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
end)

closeButton.MouseLeave:Connect(function()
	closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
end)

closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- Dragging logic
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Container for content (below title bar)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -50)
contentFrame.Position = UDim2.new(0, 10, 0, 45)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = contentFrame

-- Helper: Create Label
local function createLabel(text)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 24)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamSemibold
	lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
	lbl.TextSize = 18
	lbl.Text = text
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.LayoutOrder = #contentFrame:GetChildren() + 1
	lbl.Parent = contentFrame
	return lbl
end

-- Helper: Create Button
local function createButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 18
	btn.LayoutOrder = #contentFrame:GetChildren() + 1
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn

	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
	end)

	btn.MouseButton1Click:Connect(function()
		if callback then
			callback()
		end
	end)

	btn.Parent = contentFrame
	return btn
end

-- Helper: Create TextBox
local function createTextbox(placeholder)
	local tb = Instance.new("TextBox")
	tb.Size = UDim2.new(1, 0, 0, 32)
	tb.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
	tb.BorderSizePixel = 0
	tb.TextColor3 = Color3.fromRGB(230, 230, 230)
	tb.PlaceholderText = placeholder or ""
	tb.Font = Enum.Font.Gotham
	tb.TextSize = 18
	tb.ClearTextOnFocus = false
	tb.LayoutOrder = #contentFrame:GetChildren() + 1
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = tb

	tb.Parent = contentFrame
	return tb
end

-- Helper: Create Slider
local function createSlider(name, min, max, default, callback)
	local sliderContainer = Instance.new("Frame")
	sliderContainer.Size = UDim2.new(1, 0, 0, 60)
	sliderContainer.BackgroundTransparency = 1
	sliderContainer.LayoutOrder = #contentFrame:GetChildren() + 1
	sliderContainer.Parent = contentFrame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 24)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextColor3 = Color3.fromRGB(230, 230, 230)
	label.TextSize = 17
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = name .. ": " .. tostring(default)
	label.Parent = sliderContainer

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, 0, 0, 20)
	bar.Position = UDim2.new(0, 0, 0, 32)
	bar.BackgroundColor3 = Color3.fromRGB(65, 65, 85)
	bar.BorderSizePixel = 0
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = bar
	bar.Parent = sliderContainer

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	fill.BorderSizePixel = 0
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 10)
	fillCorner.Parent = fill
	fill.Parent = bar

	local dragging = false

	local function updateSlider(xPos)
		local relative = (xPos - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
		relative = math.clamp(relative, 0, 1)
		fill.Size = UDim2.new(relative, 0, 1, 0)
		local value = math.floor(min + (max - min) * relative)
		label.Text = name .. ": " .. tostring(value)
		if callback then callback(value) end
	end

	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			updateSlider(input.Position.X)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateSlider(input.Position.X)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	return sliderContainer
end

-- ======= TEST ELEMENTS =======
createLabel("Example Controls")

createButton("Click Me!", function()
	print("Button clicked!")
end)

createTextbox("Type your command here")

createSlider("Volume", 0, 100, 50, function(value)
	print("Volume set to:", value)
end)

createSlider("Brightness", 0, 10, 5, function(value)
	print("Brightness set to:", value)
end)

createTextbox("Another textbox")

createButton("Another Button", function()
	print("Another button pressed!")
end)
