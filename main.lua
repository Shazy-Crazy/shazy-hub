# shazy-hub
shazy roblox hub
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- GUI
local shazyGui = Instance.new("ScreenGui")
shazyGui.Name = "shazy"
shazyGui.Parent = player:WaitForChild("PlayerGui")
shazyGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 80)
mainFrame.Position = UDim2.new(0.5, -90, 0.8, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = shazyGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 15)
frameCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 25)
title.Position = UDim2.new(0, 5, 0, 5)
title.BackgroundTransparency = 1
title.Text = "shazy"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

local actionButton = Instance.new("TextButton")
actionButton.Size = UDim2.new(1, -20, 0, 35)
actionButton.Position = UDim2.new(0, 10, 0, 30)
actionButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
actionButton.BorderSizePixel = 0
actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
actionButton.Text = "shazy"
actionButton.Font = Enum.Font.SourceSansBold
actionButton.TextSize = 14
actionButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = actionButton

-- Hover
actionButton.MouseEnter:Connect(function()
    TweenService:Create(actionButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    }):Play()
end)

actionButton.MouseLeave:Connect(function()
    TweenService:Create(actionButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    }):Play()
end)

-- Drag
local dragging = false
local dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Core
local Net = require(ReplicatedStorage:WaitForChild("Packages").Net)
local UseItem = Net:RemoteEvent("UseItem")

local function getClosest()
    local closest, shortest = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = plr
            end
        end
    end
    return closest
end

actionButton.MouseButton1Click:Connect(function()
    local target = getClosest()
    if not target then return end

    local char = player.Character or player.CharacterAdded:Wait()
    local tool = player.Backpack:FindFirstChild("Web Slinger") or char:FindFirstChild("Web Slinger")

    if tool then
        char.Humanoid:EquipTool(tool)
        UseItem:FireServer(
            target.Character.HumanoidRootPart.Position,
            target.Character.HumanoidRootPart
        )
    end
end)
