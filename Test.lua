local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")

-- Create the main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 300)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Parent = screenGui
mainFrame.BorderSizePixel = 0

local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 12)
mainFrameCorner.Parent = mainFrame

local sideBar = Instance.new("Frame")
sideBar.Size = UDim2.new(0, 100, 1, 0)
sideBar.Position = UDim2.new(0, 0, 0, 0)
sideBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
sideBar.Parent = mainFrame

local sideBarCorner = Instance.new("UICorner")
sideBarCorner.CornerRadius = UDim.new(0, 12)
sideBarCorner.Parent = sideBar

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.Parent = mainFrame

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 12)
titleBarCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.Text = "My Custom UI"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 18
titleText.Font = Enum.Font.SourceSansBold
titleText.TextXAlignment = Enum.TextXAlignment.Center
titleText.BackgroundTransparency = 1
titleText.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20
closeButton.Parent = titleBar

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -100, 1, -50)
contentArea.Position = UDim2.new(0, 100, 0, 50)
contentArea.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
contentArea.BackgroundTransparency = 0.1
contentArea.Parent = mainFrame

local contentAreaCorner = Instance.new("UICorner")
contentAreaCorner.CornerRadius = UDim.new(0, 12)
contentAreaCorner.Parent = contentArea

local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 250, 0, 40)
speedButton.Position = UDim2.new(0, 10, 0, 30)
speedButton.Text = "Player Speed"
speedButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.TextSize = 16
speedButton.Parent = contentArea

local speedButtonCorner = Instance.new("UICorner")
speedButtonCorner.CornerRadius = UDim.new(0, 8)
speedButtonCorner.Parent = speedButton

local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(0, 250, 0, 10)
sliderFrame.Position = UDim2.new(0, 10, 0, 80)
sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sliderFrame.Parent = contentArea
sliderFrame.Visible = false

local sliderHandle = Instance.new("Frame")
sliderHandle.Size = UDim2.new(0, 20, 0, 20)
sliderHandle.Position = UDim2.new(0, 0, 0, -5)
sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderHandle.BorderSizePixel = 0
sliderHandle.Parent = sliderFrame

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(0, 250, 0, 20)
sliderLabel.Position = UDim2.new(0, 10, 0, 100)
sliderLabel.Text = "Walk Speed: 16"
sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderLabel.TextSize = 16
sliderLabel.Font = Enum.Font.SourceSansBold
sliderLabel.BackgroundTransparency = 1
sliderLabel.Parent = contentArea
sliderLabel.Visible = false

local function updateSpeed()
    local sliderPosition = sliderHandle.Position.X.Offset
    local sliderWidth = sliderFrame.Size.X.Offset
    local percentage = sliderPosition / (sliderWidth - sliderHandle.Size.X.Offset)
    local walkSpeed = 16 + (percentage * (200 - 16))
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid.WalkSpeed = walkSpeed
    end
    sliderLabel.Text = "Walk Speed: " .. math.floor(walkSpeed)
end

local draggingSlider = false

sliderHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = true
    end
end)

userInputService.InputChanged:Connect(function(input)
    if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mouseX = input.Position.X
        local trackStartX = sliderFrame.AbsolutePosition.X
        local trackEndX = trackStartX + sliderFrame.Size.X.Offset
        local minX = trackStartX
        local maxX = trackEndX - sliderHandle.Size.X.Offset
        local newX = math.clamp(mouseX - trackStartX, 0, maxX - trackStartX)
        sliderHandle.Position = UDim2.new(0, newX, 0, -5)
        updateSpeed()
    end
end)

sliderHandle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = false
    end
end)

speedButton.MouseButton1Click:Connect(function()
    sliderFrame.Visible = not sliderFrame.Visible
    sliderLabel.Visible = not sliderLabel.Visible
end)

local mainButton = Instance.new("TextButton")
mainButton.Size = UDim2.new(0, 80, 0, 40)
mainButton.Position = UDim2.new(0, 10, 0, 60)
mainButton.Text = "Main"
mainButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mainButton.TextSize = 16
mainButton.Parent = sideBar

local mainButtonCorner = Instance.new("UICorner")
mainButtonCorner.CornerRadius = UDim.new(0, 8)
mainButtonCorner.Parent = mainButton

local settingsButton = Instance.new("TextButton")
settingsButton.Size = UDim2.new(0, 80, 0, 40)
settingsButton.Position = UDim2.new(0, 10, 1, -50)
settingsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsButton.TextSize = 20
settingsButton.Text = "⚙️"
settingsButton.Parent = sideBar

local settingsButtonCorner = Instance.new("UICorner")
settingsButtonCorner.CornerRadius = UDim.new(0, 8)
settingsButtonCorner.Parent = settingsButton

-- Create the Reset button with smaller size, to the right of Player Speed button
local resetButton = Instance.new("TextButton")
resetButton.Size = UDim2.new(0, 60, 0, 30) -- slightly smaller
resetButton.Position = UDim2.new(0, 10 + 250 + 10, 0, 35) -- adjusted position
resetButton.Text = "Reset"
resetButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resetButton.TextSize = 14
resetButton.Parent = contentArea

local resetButtonCorner = Instance.new("UICorner")
resetButtonCorner.CornerRadius = UDim.new(0, 6)
resetButtonCorner.Parent = resetButton

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    print("Close Button clicked")
    mainFrame.Visible = false
end)

-- Draggable GUI
local dragging = false
local dragInput, mousePos, framePos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragInput = input
        mousePos = input.Position
        framePos = mainFrame.Position
    end
end)

userInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - mousePos
        mainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

userInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Reset button functionality
resetButton.MouseButton1Click:Connect(function()
    -- Reset handle position to start
    sliderHandle.Position = UDim2.new(0, 0, 0, -5)
    updateSpeed()
end)