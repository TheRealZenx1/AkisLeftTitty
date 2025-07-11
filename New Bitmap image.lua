-- Load your custom Exploit GUI Manager from GitHub (replace with your real URL if needed)
local UIManager = (function()
    -- This is your ExploitGUIManager code embedded here for simplicity.
    -- You can also host this on GitHub and load with loadstring(game:HttpGet(...))()

    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")

    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local ExploitGUIManager = {}
    ExploitGUIManager.Windows = {}

    local function createRoundedFrame(parent, size, position, bgColor)
        local frame = Instance.new("Frame")
        frame.Size = size
        frame.Position = position
        frame.BackgroundColor3 = bgColor
        frame.BorderSizePixel = 0
        frame.Parent = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame

        return frame
    end

    local function createLabel(parent, text, size)
        local label = Instance.new("TextLabel")
        label.Size = size or UDim2.new(1, 0, 0, 24)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamSemibold
        label.TextColor3 = Color3.fromRGB(230, 230, 230)
        label.TextSize = 18
        label.Text = text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = parent
        return label
    end

    local function createButton(parent, text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 18
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

        btn.Parent = parent
        return btn
    end

    local function createSlider(parent, name, min, max, default, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 60)
        container.BackgroundTransparency = 1
        container.Parent = parent

        local label = createLabel(container, name .. ": " .. tostring(default), UDim2.new(1,0,0,24))

        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, 0, 0, 20)
        bar.Position = UDim2.new(0, 0, 0, 32)
        bar.BackgroundColor3 = Color3.fromRGB(65, 65, 85)
        bar.BorderSizePixel = 0
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = bar
        bar.Parent = container

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
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

        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input.Position.X)
            end
        end)

        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        return container
    end

    local function createTextbox(parent, placeholder, callback)
        local tb = Instance.new("TextBox")
        tb.Size = UDim2.new(1, 0, 0, 32)
        tb.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
        tb.BorderSizePixel = 0
        tb.TextColor3 = Color3.fromRGB(230, 230, 230)
        tb.PlaceholderText = placeholder or ""
        tb.Font = Enum.Font.Gotham
        tb.TextSize = 18
        tb.ClearTextOnFocus = false
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = tb

        tb.Parent = parent

        if callback then
            tb:GetPropertyChangedSignal("Text"):Connect(function()
                callback(tb.Text)
            end)
        end

        return tb
    end

    function ExploitGUIManager.CreateWindow(title)
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = title:gsub(" ", "") .. "Window"
        screenGui.Parent = playerGui
        screenGui.ResetOnSpawn = false

        local mainFrame = createRoundedFrame(screenGui, UDim2.new(0, 400, 0, 450), UDim2.new(0.5, -200, 0.5, -225), Color3.fromRGB(20, 20, 25))

        local titleBar = createRoundedFrame(mainFrame, UDim2.new(1, 0, 0, 35), UDim2.new(0, 0, 0, 0), Color3.fromRGB(35, 35, 45))
        titleBar.ClipsDescendants = true

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -40, 1, 0)
        titleLabel.Position = UDim2.new(0, 10, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 22
        titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = titleBar

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
            ExploitGUIManager.Windows[title] = nil
        end)

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

        local contentFrame = Instance.new("Frame")
        contentFrame.Size = UDim2.new(1, -20, 1, -50)
        contentFrame.Position = UDim2.new(0, 10, 0, 45)
        contentFrame.BackgroundTransparency = 1
        contentFrame.Parent = mainFrame

        -- API
        local window = {
            ScreenGui = screenGui,
            MainFrame = mainFrame,
            TitleBar = titleBar,
            ContentFrame = contentFrame,

            AddButton = function(self, text, callback)
                return createButton(contentFrame, text, callback)
            end,

            AddSlider = function(self, name, min, max, default, callback)
                return createSlider(contentFrame, name, min, max, default, callback)
            end,

            AddTextbox = function(self, placeholder, callback)
                return createTextbox(contentFrame, placeholder, callback)
            end,
        }

        ExploitGUIManager.Windows[title] = window
        return window
    end

    return ExploitGUIManager
end)()


-- Create your window and UI elements

local window = UIManager.CreateWindow("Exploit GUI")

window:AddButton("Run GitHub Script", function()
    local url = "https://raw.githubusercontent.com/TheRealZenx1/AkisLeftTitty/refs/heads/main/New%20Bitmap%20image.lua"
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success and result then
        local func, err = loadstring(result)
        if func then
            func()
            print("[Exploit GUI] Successfully ran GitHub script.")
        else
            warn("[Exploit GUI] Failed to load script:", err)
        end
    else
        warn("[Exploit GUI] Failed to fetch script from GitHub.")
    end
end)

window:AddButton("Test Button", function()
    print("Test Button clicked!")
end)

window:AddSlider("Volume", 0, 100, 50, function(value)
    print("Volume set to:", value)
end)

window:AddTextbox("Enter your name", function(text)
    print("Text entered:", text)
end)
