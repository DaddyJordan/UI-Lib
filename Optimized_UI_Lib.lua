local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService('CoreGui')

local plr = Players.LocalPlayer
local mouse = plr:GetMouse()
local pgui = plr.PlayerGui

-- Destroy old UI if exists
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "FluxLib" and v:IsA("ScreenGui") then
        v:Destroy()
    end
end

-- Main GUI
local baseui = Instance.new("ScreenGui")
baseui.Name = "FluxLib"
baseui.Parent = RunService:IsStudio() and pgui or CoreGui
baseui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local BG = Instance.new("Frame")
BG.Name = "BackgroundFrame"
BG.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BG.Position = UDim2.new(0.5, 0, 0.5, 0)
BG.AnchorPoint = Vector2.new(0.5, 0.5)
BG.Size = UDim2.new(0, 743, 0, 448)
BG.Parent = baseui
BG.Active = true

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 16)
bgCorner.Parent = BG

-- Draggable functionality
local function makeDraggable(topbar, object)
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

makeDraggable(BG, BG)

-- Tab management system
local tabs = {}
local selectedTab = nil

-- Adds a tab with the given name
function addTab(name)
    local tabButton = Instance.new("TextButton", BG)
    tabButton.Text = name
    tabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tabButton.Size = UDim2.new(0, 100, 0, 50)
    tabButton.Position = UDim2.new(0, #tabs * 110, 1, -50)
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)

    local content = Instance.new("Frame", BG)
    content.Size = UDim2.new(1, -20, 1, -60)
    content.Position = UDim2.new(0, 10, 0, 10)
    content.Visible = false
    content.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    content.BackgroundTransparency = 0.1

    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 6)
    contentCorner.Parent = content

    tabButton.MouseButton1Click:Connect(function()
        if selectedTab then
            selectedTab.content.Visible = false
            selectedTab.tabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        end
        selectedTab = {tabButton = tabButton, content = content}
        content.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(45, 40, 50)
    end)

    tabs[name] = {tabButton = tabButton, content = content}
    if not selectedTab then
        selectedTab = {tabButton = tabButton, content = content}
        content.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(45, 40, 50)
    end
end

-- Example tabs
addTab("Settings")
addTab("Stats")
addTab("Credits")
addTab("About")

-- Further UI Elements within the tabs
local function createLabel(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 0, 50)
    label.Position = UDim2.new(0, 10, 0, 10)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = text
    label.BackgroundTransparency = 1
    label.Parent = parent
end

createLabel(tabs["Settings"].content, "Settings Panel")
createLabel(tabs["Stats"].content, "Statistics Panel")
createLabel(tabs["Credits"].content, "Credits Panel")
createLabel(tabs["About"].content, "About Panel")

-- You can continue adding more complex UI elements and logic as required.
