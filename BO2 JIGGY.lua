-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Colors (BO2 theme)
local bo2Orange = Color3.fromRGB(255, 165, 0)
local bo2Dark = Color3.fromRGB(40, 40, 40)
local bo2Gray = Color3.fromRGB(30, 30, 30)
local bo2LightGray = Color3.fromRGB(80, 80, 80)

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "BO2ModMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0, 20, 0.5, -200)
mainFrame.BackgroundColor3 = bo2Dark
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local UICorner = Instance.new("UICorner", mainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

-- Title Label
local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "BO2 Mod Menu"
titleLabel.TextColor3 = bo2Orange
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 28

-- Button Creator Utility
local function createButton(text, callback)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, (#mainFrame:GetChildren()-2) * 40 + 50)
    btn.BackgroundColor3 = bo2Gray
    btn.TextColor3 = bo2Orange
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = text
    btn.AutoButtonColor = false
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = bo2LightGray
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = bo2Gray
    end)

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ESP Setup (Improved)
local espEnabled = false
local espLabels = {}

local function createESP(plr)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_"..plr.Name
    billboard.Adornee = nil
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.AlwaysOnTop = true
    billboard.ExtentsOffset = Vector3.new(0, 3, 0) -- Raise above head
    billboard.Parent = gui

    local text = Instance.new("TextLabel", billboard)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.new(1, 1, 1)
    text.TextStrokeTransparency = 0
    text.Text = plr.Name
    text.Size = UDim2.new(1, 0, 1, 0)
    text.Font = Enum.Font.GothamBold
    text.TextScaled = true
    text.TextWrapped = true

    return billboard
end

local function addESPForPlayer(plr)
    if espLabels[plr] then return end
    local function onCharacterAdded(char)
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if hrp and espEnabled then
            local billboard = createESP(plr)
            billboard.Adornee = hrp
            espLabels[plr] = billboard
        end
    end

    if plr.Character then
        onCharacterAdded(plr.Character)
    end

    plr.CharacterAdded:Connect(onCharacterAdded)
end

local function removeESPForPlayer(plr)
    if espLabels[plr] then
        espLabels[plr]:Destroy()
        espLabels[plr] = nil
    end
end

local function toggleESP()
    espEnabled = not espEnabled

    if espEnabled then
        -- Add ESP for all current players
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then
                addESPForPlayer(plr)
            end
        end

        -- Listen for new players joining
        Players.PlayerAdded:Connect(function(plr)
            if espEnabled then
                addESPForPlayer(plr)
            end
        end)

        -- Remove ESP when players leave
        Players.PlayerRemoving:Connect(function(plr)
            removeESPForPlayer(plr)
        end)
    else
        -- Disable ESP - remove all labels
        for plr, billboard in pairs(espLabels) do
            if billboard then
                billboard:Destroy()
            end
        end
        espLabels = {}
    end
end

-- Fly Toggle Placeholder
local flying = false
local function toggleFly()
    flying = not flying
    -- Implement fly logic here or leave as placeholder
    print("Fly toggled:", flying)
end

-- Noclip Toggle Placeholder
local noclipEnabled = false
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    -- Implement noclip logic here or leave as placeholder
    print("Noclip toggled:", noclipEnabled)
end

-- Teleport to Mouse
local function teleportToMouse()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local targetPos = mouse.Hit.Position
    root.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
end

-- Speed Change Toggle (speed up/down)
local function changeSpeed()
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if humanoid.WalkSpeed == 16 then
        humanoid.WalkSpeed = 50
    else
        humanoid.WalkSpeed = 16
    end
end

-- Jump Power Toggle (jump up/down)
local function changeJump()
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if humanoid.JumpPower == 50 then
        humanoid.JumpPower = 100
    else
        humanoid.JumpPower = 50
    end
end

-- SPAWN MENU SETUP
local spawnMenuFrame = Instance.new("Frame")
spawnMenuFrame.Size = UDim2.new(0, 250, 0, 200)
spawnMenuFrame.Position = UDim2.new(0, 320, 0.5, -100)
spawnMenuFrame.BackgroundColor3 = bo2Dark
spawnMenuFrame.BorderSizePixel = 0
spawnMenuFrame.Visible = false
spawnMenuFrame.Parent = gui
local spawnUICorner = Instance.new("UICorner", spawnMenuFrame)
spawnUICorner.CornerRadius = UDim.new(0, 8)

local spawnTitle = Instance.new("TextLabel", spawnMenuFrame)
spawnTitle.Size = UDim2.new(1, 0, 0, 40)
spawnTitle.BackgroundTransparency = 1
spawnTitle.Text = "Spawn Menu"
spawnTitle.TextColor3 = bo2Orange
spawnTitle.Font = Enum.Font.GothamBlack
spawnTitle.TextSize = 24

local spawnButtonsFrame = Instance.new("ScrollingFrame", spawnMenuFrame)
spawnButtonsFrame.Size = UDim2.new(1, -20, 1, -50)
spawnButtonsFrame.Position = UDim2.new(0, 10, 0, 45)
spawnButtonsFrame.BackgroundTransparency = 1
spawnButtonsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
spawnButtonsFrame.ScrollBarThickness = 6
spawnButtonsFrame.Parent = spawnMenuFrame

local function createSpawnButton(text, callback)
    local btn = Instance.new("TextButton", spawnButtonsFrame)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Position = UDim2.new(0, 0, 0, (#spawnButtonsFrame:GetChildren()-1) * 40)
    btn.BackgroundColor3 = bo2Gray
    btn.TextColor3 = bo2Orange
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = text
    btn.AutoButtonColor = false
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = bo2LightGray
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = bo2Gray
    end)

    btn.MouseButton1Click:Connect(callback)

    -- Update canvas size to fit buttons
    spawnButtonsFrame.CanvasSize = UDim2.new(0, 0, 0, btn.Position.Y.Offset + btn.Size.Y.Offset + 10)
    return btn
end

-- Spawn Care Package in front of player (standable)
local function spawnCarePackage()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local carePackage = Instance.new("Part")
    carePackage.Name = "CarePackage"
    carePackage.Size = Vector3.new(6, 4, 6)
    carePackage.Position = root.Position + root.CFrame.LookVector * 10 + Vector3.new(0, 2, 0)
    carePackage.Anchored = true
    carePackage.CanCollide = true
    carePackage.Transparency = 0
    carePackage.Material = Enum.Material.Neon
    carePackage.Color = bo2Orange
    carePackage.Parent = workspace

    local selectionBox = Instance.new("SelectionBox", carePackage)
    selectionBox.Adornee = carePackage
    selectionBox.Color3 = Color3.new(1, 1, 1)
    selectionBox.LineThickness = 0.05

    delay(20, function()
        if carePackage then
            carePackage:Destroy()
        end
    end)
end

-- Keybind for spawning care package at mouse cursor
local carePackageKeybind

local function spawnCarePackageAtCursor()
    local mousePos = mouse.Hit.Position
    if not mousePos then return end

    local carePackage = Instance.new("Part")
    carePackage.Name = "CarePackage"
    carePackage.Size = Vector3.new(6, 4, 6)
    carePackage.Position = mousePos + Vector3.new(0, 2, 0)
    carePackage.Anchored = true
    carePackage.CanCollide = true
    carePackage.Transparency = 0
    carePackage.Material = Enum.Material.Neon
    carePackage.Color = bo2Orange
    carePackage.Parent = workspace

    local selectionBox = Instance.new("SelectionBox", carePackage)
    selectionBox.Adornee = carePackage
    selectionBox.Color3 = Color3.new(1, 1, 1)
    selectionBox.LineThickness = 0.05

    delay(20, function()
        if carePackage then
            carePackage:Destroy()
        end
    end)
end

-- Bind a key to spawn care package at cursor
local function bindKeyToSpawn()
    local promptLabel = Instance.new("TextLabel", spawnMenuFrame)
    promptLabel.Size = UDim2.new(1, -20, 0, 30)
    promptLabel.Position = UDim2.new(0, 10, 1, -40)
    promptLabel.BackgroundColor3 = bo2Gray
    promptLabel.TextColor3 = bo2Orange
    promptLabel.Text = "Press any key to bind for Care Package spawn..."
    promptLabel.Font = Enum.Font.GothamBold
    promptLabel.TextSize = 16
    promptLabel.TextScaled = true
    promptLabel.TextWrapped = true
    promptLabel.AnchorPoint = Vector2.new(0, 0)
    promptLabel.ZIndex = 10
    promptLabel.Visible = true

    spawnButtonsFrame.Active = false

    local conn
    conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            carePackageKeybind = input.KeyCode
            promptLabel.Text = "Bound Care Package spawn to key: ".. tostring(carePackageKeybind.Name)
            wait(2)
            promptLabel:Destroy()
            spawnButtonsFrame.Active = true
            conn:Disconnect()
        end
    end)
end

-- Detect key press for bound key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if carePackageKeybind and input.KeyCode == carePackageKeybind then
        spawnCarePackageAtCursor()
    end
end)

-- Square Spawner (spawns on mouse when key pressed)
local squareSpawnerKey
local squareSize = Vector3.new(10, 1, 10)

local function spawnSquareAtMouse()
    local mousePos = mouse.Hit.Position
    if not mousePos then return end

    local square = Instance.new("Part")
    square.Name = "SpawnedSquare"
    square.Size = squareSize
    square.Position = mousePos + Vector3.new(0, squareSize.Y/2, 0)
    square.Anchored = true
    square.CanCollide = true
    square.Material = Enum.Material.Neon
    square.Color = bo2Orange
    square.Parent = workspace

    delay(20, function()
        if square then
            square:Destroy()
        end
    end)
end

local function bindSquareSpawnerKey()
    local promptLabel = Instance.new("TextLabel", spawnMenuFrame)
    promptLabel.Size = UDim2.new(1, -20, 0, 30)
    promptLabel.Position = UDim2.new(0, 10, 1, -40)
    promptLabel.BackgroundColor3 = bo2Gray
    promptLabel.TextColor3 = bo2Orange
    promptLabel.Text = "Press any key to bind Square Spawner..."
    promptLabel.Font = Enum.Font.GothamBold
    promptLabel.TextSize = 16
    promptLabel.TextScaled = true
    promptLabel.TextWrapped = true
    promptLabel.AnchorPoint = Vector2.new(0, 0)
    promptLabel.ZIndex = 10
    promptLabel.Visible = true

    spawnButtonsFrame.Active = false

    local conn
    conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            squareSpawnerKey = input.KeyCode
            promptLabel.Text = "Bound Square Spawner to key: ".. tostring(squareSpawnerKey.Name)
            wait(2)
            promptLabel:Destroy()
            spawnButtonsFrame.Active = true
            conn:Disconnect()
        end
    end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if squareSpawnerKey and input.KeyCode == squareSpawnerKey then
        spawnSquareAtMouse()
    end
end)

-- Main Buttons
createButton("ESP Toggle", toggleESP)
createButton("Fly Toggle", toggleFly)
createButton("Noclip Toggle", toggleNoclip)
createButton("Teleport To Mouse", teleportToMouse)
createButton("Speed Up/Down", changeSpeed)
createButton("Jump Up/Down", changeJump)

local spawnMenuToggleBtn = createButton("Toggle Spawn Menu", function()
    spawnMenuFrame.Visible = not spawnMenuFrame.Visible
end)

-- Spawn Menu Buttons
createSpawnButton("Spawn Care Package", spawnCarePackage)
createSpawnButton("Bind Care Package Key", bindKeyToSpawn)
createSpawnButton("Bind Square Spawner Key", bindSquareSpawnerKey)

-- Optional: Auto-update spawnButtonsFrame.CanvasSize if dynamic buttons added in future
