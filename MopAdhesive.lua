--[[
    🚀 MOB STICKER & SPEED HUB (MOBILE OPTIMIZED)
    ✅ نظام اختيار الموب الذكي (Smart Select)
    ✅ الالتصاق بالموب (Stick to Mob)
    ✅ حماية الأزرار (UI Protection)
    ✅ شريط السرعة (Speed Slider)
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- متغيرات التحكم
local stickEnabled = false
local isSelecting = false
local selectedMob = nil
local playerSpeed = 16

-- ==================== دالة السحب (Draggable) ====================
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
        end
    end)
end

-- ==================== بناء الواجهة (GUI) ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobStickHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 260)
mainFrame.Position = UDim2.new(0.5, -100, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Text = "🎯 MOB STICKER"
title.Size = UDim2.new(1, 0, 0, 35)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

local mobNameDisplay = Instance.new("TextLabel")
mobNameDisplay.Text = "Target: None"
mobNameDisplay.Size = UDim2.new(0.9, 0, 0, 25)
mobNameDisplay.Position = UDim2.new(0.05, 0, 0.15, 0)
mobNameDisplay.TextColor3 = Color3.fromRGB(255, 200, 0)
mobNameDisplay.BackgroundTransparency = 1
mobNameDisplay.Font = Enum.Font.GothamMedium
mobNameDisplay.TextSize = 12
mobNameDisplay.Parent = mainFrame

-- زر الاختيار (Select)
local selectBtn = Instance.new("TextButton")
selectBtn.Size = UDim2.new(0.85, 0, 0, 35)
selectBtn.Position = UDim2.new(0.075, 0, 0.3, 0)
selectBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
selectBtn.Text = "CLICK TO SELECT"
selectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
selectBtn.Font = Enum.Font.GothamBold
selectBtn.TextSize = 12
selectBtn.Parent = mainFrame

local btnCorner1 = Instance.new("UICorner")
btnCorner1.CornerRadius = UDim.new(0, 6)
btnCorner1.Parent = selectBtn

-- زر التشغيل (Stick On/Off)
local stickBtn = Instance.new("TextButton")
stickBtn.Size = UDim2.new(0.85, 0, 0, 35)
stickBtn.Position = UDim2.new(0.075, 0, 0.47, 0)
stickBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stickBtn.Text = "STICK: OFF"
stickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stickBtn.Font = Enum.Font.GothamBold
stickBtn.TextSize = 12
stickBtn.Parent = mainFrame

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 6)
btnCorner2.Parent = stickBtn

-- زر الريسيرش (Reset)
local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0.85, 0, 0, 30)
resetBtn.Position = UDim2.new(0.075, 0, 0.63, 0)
resetBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
resetBtn.Text = "RESET TARGET"
resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 11
resetBtn.Parent = mainFrame

local btnCorner3 = Instance.new("UICorner")
btnCorner3.CornerRadius = UDim.new(0, 6)
btnCorner3.Parent = resetBtn

-- نظام السرعة (Slider)
local speedTitle = Instance.new("TextLabel")
speedTitle.Text = "Walk Speed: 16"
speedTitle.Size = UDim2.new(1, 0, 0, 20)
speedTitle.Position = UDim2.new(0, 0, 0.78, 0)
speedTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
speedTitle.BackgroundTransparency = 1
speedTitle.Font = Enum.Font.Gotham
speedTitle.TextSize = 11
speedTitle.Parent = mainFrame

local sliderBack = Instance.new("Frame")
sliderBack.Size = UDim2.new(0.8, 0, 0, 4)
sliderBack.Position = UDim2.new(0.1, 0, 0.9, 0)
sliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sliderBack.Parent = mainFrame

local sliderBtn = Instance.new("TextButton")
sliderBtn.Size = UDim2.new(0, 14, 0, 14)
sliderBtn.Position = UDim2.new(0.16, -7, 0.5, -7)
sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderBtn.Text = ""
sliderBtn.Parent = sliderBack

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1, 0)
sliderCorner.Parent = sliderBtn

makeDraggable(mainFrame)

-- ==================== الوظائف المنطقية ====================

-- وظيفة التحقق من عدم وجود واجهة تحت الضغطة
local function isPointerOverGui()
    local objects = player.PlayerGui:GetGuiObjectsAtPosition(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    for _, obj in pairs(objects) do
        if obj:IsDescendantOf(mainFrame) then return true end
    end
    return false
end

-- اختيار الموب
UserInputService.InputBegan:Connect(function(input)
    if isSelecting and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        if isPointerOverGui() then return end -- تجاهل لو ضغط على الواجهة
        
        local target = mouse.Target
        if target then
            local model = target:FindFirstAncestorOfClass("Model")
            if model then
                selectedMob = model
                mobNameDisplay.Text = "Target: " .. model.Name
                isSelecting = false
                selectBtn.Text = "SELECT MOB"
                selectBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
            end
        end
    end
end)

selectBtn.MouseButton1Click:Connect(function()
    isSelecting = not isSelecting
    if isSelecting then
        selectBtn.Text = "TAP A MOB..."
        selectBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    else
        selectBtn.Text = "SELECT MOB"
        selectBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
    end
end)

-- زر الالتصاق
stickBtn.MouseButton1Click:Connect(function()
    if not selectedMob then 
        mobNameDisplay.Text = "SELECT A MOB FIRST!"
        task.wait(1)
        mobNameDisplay.Text = "Target: None"
        return 
    end
    
    stickEnabled = not stickEnabled
    if stickEnabled then
        stickBtn.Text = "STICK: ON"
        stickBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        stickBtn.Text = "STICK: OFF"
        stickBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

-- زر الريسيرش
resetBtn.MouseButton1Click:Connect(function()
    selectedMob = nil
    stickEnabled = false
    mobNameDisplay.Text = "Target: None"
    stickBtn.Text = "STICK: OFF"
    stickBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)

-- حلقة الالتصاق (RunService للنعومة)
RunService.RenderStepped:Connect(function()
    if stickEnabled and selectedMob then
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        -- البحث عن الجزء الأساسي للموب للالتصاق به
        local targetPart = selectedMob.PrimaryPart or selectedMob:FindFirstChildWhichIsA("BasePart")
        
        if root and targetPart then
            -- الالتصاق بمنتصف الموب
            root.CFrame = targetPart.CFrame
        elseif not selectedMob:IsDescendantOf(workspace) then
            -- لو الموب اختفى أو مات
            stickEnabled = false
            selectedMob = nil
            mobNameDisplay.Text = "MOB DISAPPEARED"
            stickBtn.Text = "STICK: OFF"
            stickBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
    end
end)

-- نظام السرعة (Slider logic)
local isSliding = false
local function updateSpeed(input)
    local rect = sliderBack.AbsolutePosition
    local width = sliderBack.AbsoluteSize.X
    local x = math.clamp(input.Position.X - rect.X, 0, width)
    local percentage = x / width
    sliderBtn.Position = UDim2.new(percentage, -7, 0.5, -7)
    playerSpeed = math.floor(percentage * 200) -- سرعة حتى 200
    speedTitle.Text = "Walk Speed: " .. playerSpeed
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = playerSpeed
    end
end

sliderBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isSliding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isSliding = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSpeed(input)
    end
end)

-- الحفاظ على السرعة عند الموت
player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    task.wait(1)
    hum.WalkSpeed = playerSpeed
end)

print("✅ Mob Sticker Hub Loaded!")
