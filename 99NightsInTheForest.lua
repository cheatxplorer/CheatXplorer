-- Roblox bring/teleport/player tab GUI, compact, no 'Bring:'/'Teleport:', drag only moves UI (not player/camera/game).

pcall(function() game.Players.LocalPlayer.PlayerGui.BringFoliageUI:Destroy() end)

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "BringFoliageUI"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 455)
frame.Position = UDim2.new(0, 80, 0, 80)
frame.BackgroundColor3 = Color3.fromRGB(34, 37, 44)
frame.BackgroundTransparency = 0
frame.BorderSizePixel = 0
frame.Parent = gui

-- Drag bar is now a TextButton for proper UI-only drag!
local dragBar = Instance.new("TextButton")
dragBar.Size = UDim2.new(1, 0, 0, 36)
dragBar.Position = UDim2.new(0, 0, 0, 0)
dragBar.BackgroundColor3 = Color3.fromRGB(25, 28, 34)
dragBar.BorderSizePixel = 0
dragBar.Text = ""
dragBar.TextTransparency = 1
dragBar.Active = true
dragBar.Selectable = true
dragBar.AutoButtonColor = false
dragBar.Parent = frame

local dragTitle = Instance.new("TextLabel")
dragTitle.Size = UDim2.new(1, 0, 1, 0)
dragTitle.BackgroundTransparency = 1
dragTitle.Text = "Bring/Teleport/Player"
dragTitle.TextColor3 = Color3.fromRGB(0,255,127)
dragTitle.Font = Enum.Font.GothamBold
dragTitle.TextSize = 18
dragTitle.Parent = dragBar

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, -24, 0, 32)
topBar.Position = UDim2.new(0, 12, 0, 40)
topBar.BackgroundTransparency = 1
topBar.BorderSizePixel = 0
topBar.Parent = frame

local btnW, btnH = 76, 26
local bringTabBtn = Instance.new("TextButton")
bringTabBtn.Size = UDim2.new(0, btnW, 0, btnH)
bringTabBtn.Position = UDim2.new(0, 0, 0, 0)
bringTabBtn.Text = "BRING"
bringTabBtn.BackgroundColor3 = Color3.fromRGB(74, 125, 255)
bringTabBtn.TextColor3 = Color3.new(1,1,1)
bringTabBtn.Font = Enum.Font.GothamBold
bringTabBtn.TextSize = 14
bringTabBtn.BorderSizePixel = 0
bringTabBtn.AutoButtonColor = false
bringTabBtn.Parent = topBar

local teleportTabBtn = Instance.new("TextButton")
teleportTabBtn.Size = UDim2.new(0, btnW, 0, btnH)
teleportTabBtn.Position = UDim2.new(0, btnW + 4, 0, 0)
teleportTabBtn.Text = "TELEPORT"
teleportTabBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 120)
teleportTabBtn.TextColor3 = Color3.new(1,1,1)
teleportTabBtn.Font = Enum.Font.GothamBold
teleportTabBtn.TextSize = 14
teleportTabBtn.BorderSizePixel = 0
teleportTabBtn.AutoButtonColor = false
teleportTabBtn.Parent = topBar

local playerTabBtn = Instance.new("TextButton")
playerTabBtn.Size = UDim2.new(0, btnW, 0, btnH)
playerTabBtn.Position = UDim2.new(0, (btnW + 4) * 2, 0, 0)
playerTabBtn.Text = "PLAYER"
playerTabBtn.BackgroundColor3 = Color3.fromRGB(140, 90, 250)
playerTabBtn.TextColor3 = Color3.new(1,1,1)
playerTabBtn.Font = Enum.Font.GothamBold
playerTabBtn.TextSize = 14
playerTabBtn.BorderSizePixel = 0
playerTabBtn.AutoButtonColor = false
playerTabBtn.Parent = topBar

local tabY = 40 + 32 + 7
local tabH = 455 - tabY - 52
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -16, 0, tabH)
contentArea.Position = UDim2.new(0, 8, 0, tabY)
contentArea.BackgroundTransparency = 1
contentArea.Parent = frame

-- Bring tab page
local bringPage = Instance.new("Frame")
bringPage.Size = UDim2.new(1, 0, 1, 0)
bringPage.Position = UDim2.new(0, 0, 0, 0)
bringPage.BackgroundTransparency = 1
bringPage.Parent = contentArea

local bringScroll = Instance.new("ScrollingFrame")
bringScroll.Size = UDim2.new(1, 0, 1, 0)
bringScroll.Position = UDim2.new(0, 0, 0, 0)
bringScroll.BackgroundColor3 = Color3.fromRGB(44, 64, 128)
bringScroll.BackgroundTransparency = 0.17
bringScroll.BorderSizePixel = 0
bringScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
bringScroll.ScrollBarThickness = 8
bringScroll.Parent = bringPage

local bringUIList = Instance.new("UIListLayout")
bringUIList.SortOrder = Enum.SortOrder.LayoutOrder
bringUIList.Padding = UDim.new(0,4)
bringUIList.Parent = bringScroll

local function makeSafeButton(btn, callback)
    local dragging = false
    local dragStartPos = nil
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStartPos = input.Position
        end
    end)
    btn.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
            if dragStartPos and (input.Position - dragStartPos).magnitude < 8 then
                callback()
            end
        end
    end)
end

local function bringModelByName(modelName)
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then warn("No HumanoidRootPart!") return end
    local itemsFolder = workspace:FindFirstChild("Items")
    if not itemsFolder then warn("No Items folder!") return end
    local targetPos = root.CFrame * CFrame.new(0, 0, -10)
    for _,model in ipairs(itemsFolder:GetChildren()) do
        if model:IsA("Model") and model.Name == modelName and model.PrimaryPart then
            model:SetPrimaryPartCFrame(targetPos)
        end
    end
end

local function clearBringButtons()
    for _,child in ipairs(bringScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
end

local function createBringButtons()
    clearBringButtons()
    local itemsFolder = workspace:FindFirstChild("Items")
    if not itemsFolder then return end
    local nameSet = {}
    for _,model in ipairs(itemsFolder:GetChildren()) do
        if model:IsA("Model") and model.PrimaryPart and not nameSet[model.Name] then
            nameSet[model.Name] = true
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 32)
            btn.Text = model.Name
            btn.BackgroundColor3 = Color3.fromRGB(102, 153, 255)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 15
            btn.BorderSizePixel = 0
            btn.AutoButtonColor = true
            btn.Parent = bringScroll
            btn.ClipsDescendants = true
            btn.TextWrapped = true
            local uicorner = Instance.new("UICorner")
            uicorner.CornerRadius = UDim.new(0, 7)
            uicorner.Parent = btn
            local uistroke = Instance.new("UIStroke")
            uistroke.Color = Color3.fromRGB(55,55,90)
            uistroke.Thickness = 1
            uistroke.Parent = btn
            makeSafeButton(btn, function()
                bringModelByName(model.Name)
            end)
        end
    end
    task.wait()
    bringScroll.CanvasSize = UDim2.new(0,0,0,bringUIList.AbsoluteContentSize.Y+4)
end

-- TELEPORT TAB
local teleportPage = Instance.new("Frame")
teleportPage.Size = UDim2.new(1, 0, 1, 0)
teleportPage.Position = UDim2.new(0, 0, 0, 0)
teleportPage.BackgroundTransparency = 1
teleportPage.Parent = contentArea

local teleportScroll = Instance.new("ScrollingFrame")
teleportScroll.Size = UDim2.new(1, 0, 1, 0)
teleportScroll.Position = UDim2.new(0, 0, 0, 0)
teleportScroll.BackgroundColor3 = Color3.fromRGB(44, 128, 94)
teleportScroll.BackgroundTransparency = 0.14
teleportScroll.BorderSizePixel = 0
teleportScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
teleportScroll.ScrollBarThickness = 8
teleportScroll.Parent = teleportPage

local teleportUIList = Instance.new("UIListLayout")
teleportUIList.SortOrder = Enum.SortOrder.LayoutOrder
teleportUIList.Padding = UDim.new(0,4)
teleportUIList.Parent = teleportScroll

local function teleportToModel(modelName)
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then warn("No HumanoidRootPart!") return end
    local foliageFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Foliage")
    if not foliageFolder then warn("No Foliage folder!") return end
    for _,model in ipairs(foliageFolder:GetChildren()) do
        if model:IsA("Model") and model.PrimaryPart and model.Name == modelName then
            root.CFrame = model.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
            return
        end
    end
end

local function clearTeleportButtons()
    for _,child in ipairs(teleportScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
end

local function createTeleportButtons()
    clearTeleportButtons()
    local foliageFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Foliage")
    if not foliageFolder then return end
    local nameSet = {}
    for _,model in ipairs(foliageFolder:GetChildren()) do
        if model:IsA("Model") and model.PrimaryPart and not nameSet[model.Name] then
            nameSet[model.Name] = true
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 32)
            btn.Text = model.Name
            btn.BackgroundColor3 = Color3.fromRGB(80, 205, 140)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 15
            btn.BorderSizePixel = 0
            btn.AutoButtonColor = true
            btn.Parent = teleportScroll
            btn.ClipsDescendants = true
            btn.TextWrapped = true
            local uicorner = Instance.new("UICorner")
            uicorner.CornerRadius = UDim.new(0, 7)
            uicorner.Parent = btn
            local uistroke = Instance.new("UIStroke")
            uistroke.Color = Color3.fromRGB(55,90,55)
            uistroke.Thickness = 1
            uistroke.Parent = btn
            makeSafeButton(btn, function()
                teleportToModel(model.Name)
            end)
        end
    end
    task.wait()
    teleportScroll.CanvasSize = UDim2.new(0,0,0,teleportUIList.AbsoluteContentSize.Y+4)
end

local function refreshBothTabs()
    createBringButtons()
    createTeleportButtons()
end
refreshBothTabs()

-- PLAYER TAB, compact status
local playerPage = Instance.new("Frame")
playerPage.Size = UDim2.new(1, 0, 1, 0)
playerPage.Position = UDim2.new(0, 0, 0, 0)
playerPage.BackgroundTransparency = 1
playerPage.Parent = contentArea

local playerScroll = Instance.new("Frame")
playerScroll.Size = UDim2.new(1, 0, 1, 0)
playerScroll.Position = UDim2.new(0, 0, 0, 0)
playerScroll.BackgroundTransparency = 1
playerScroll.Parent = playerPage

local playerList = Instance.new("UIListLayout")
playerList.SortOrder = Enum.SortOrder.LayoutOrder
playerList.Padding = UDim.new(0, 6)
playerList.Parent = playerScroll
playerList.HorizontalAlignment = Enum.HorizontalAlignment.Center
playerList.VerticalAlignment = Enum.VerticalAlignment.Top

local statusHolder = Instance.new("Frame")
statusHolder.Size = UDim2.new(1, -10, 0, 38)
statusHolder.BackgroundTransparency = 1
statusHolder.Parent = playerScroll

local statusList = Instance.new("UIListLayout")
statusList.SortOrder = Enum.SortOrder.LayoutOrder
statusList.Padding = UDim.new(0, 3)
statusList.Parent = statusHolder
statusList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local wsStatus = Instance.new("TextLabel")
wsStatus.Size = UDim2.new(0, 140, 0, 16)
wsStatus.BackgroundTransparency = 1
wsStatus.Text = "WalkSpeed: ..."
wsStatus.TextColor3 = Color3.fromRGB(160,220,255)
wsStatus.Font = Enum.Font.GothamBold
wsStatus.TextSize = 12
wsStatus.Parent = statusHolder

local jumpStatus = Instance.new("TextLabel")
jumpStatus.Size = UDim2.new(0, 140, 0, 16)
jumpStatus.BackgroundTransparency = 1
jumpStatus.Text = "Unli Jump: ..."
jumpStatus.TextColor3 = Color3.fromRGB(180,120,250)
jumpStatus.Font = Enum.Font.GothamBold
jumpStatus.TextSize = 12
jumpStatus.Parent = statusHolder

local function getWalkspeed()
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.WalkSpeed or 0
end

local function updateStatus()
    wsStatus.Text = "WalkSpeed: " .. tostring(getWalkspeed())
    jumpStatus.Text = "Unli Jump: " .. (player:GetAttribute("__UnliJumpEnabled") == true and "ENABLED" or "DISABLED")
    jumpStatus.TextColor3 = player:GetAttribute("__UnliJumpEnabled") == true and Color3.fromRGB(70,255,120) or Color3.fromRGB(220,100,100)
end

player:GetPropertyChangedSignal("Character"):Connect(updateStatus)
player.CharacterAdded:Connect(updateStatus)

local function makeBigBtn(text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 0, 22)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    btn.TextWrapped = true
    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 6)
    uicorner.Parent = btn
    local uistroke = Instance.new("UIStroke")
    uistroke.Color = Color3.fromRGB(55,55,90)
    uistroke.Thickness = 1
    uistroke.Parent = btn
    return btn
end

local plusWalk = makeBigBtn("+1 Walkspeed", Color3.fromRGB(80, 170, 250))
plusWalk.Parent = playerScroll

local minusWalk = makeBigBtn("-1 Walkspeed", Color3.fromRGB(80, 120, 200))
minusWalk.Parent = playerScroll

local enableJump = makeBigBtn("Enable Unli Jump", Color3.fromRGB(140, 90, 250))
enableJump.Parent = playerScroll

local disableJump = makeBigBtn("Disable Unli Jump", Color3.fromRGB(120, 120, 120))
disableJump.Parent = playerScroll

makeSafeButton(plusWalk, function()
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = humanoid.WalkSpeed + 1
        updateStatus()
    end
end)
makeSafeButton(minusWalk, function()
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = math.max(0, humanoid.WalkSpeed - 1)
        updateStatus()
    end
end)

local unliJumpConn
makeSafeButton(enableJump, function()
    if unliJumpConn then unliJumpConn:Disconnect() end
    player:SetAttribute("__UnliJumpEnabled", true)
    unliJumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
    updateStatus()
end)
makeSafeButton(disableJump, function()
    if unliJumpConn then
        unliJumpConn:Disconnect()
        unliJumpConn = nil
    end
    player:SetAttribute("__UnliJumpEnabled", false)
    updateStatus()
end)

if not player:GetAttribute("__UnliJumpEnabled") then
    player:SetAttribute("__UnliJumpEnabled", false)
end

local function watchHumanoid()
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(updateStatus)
    end
end
player.CharacterAdded:Connect(function()
    watchHumanoid()
    updateStatus()
end)
watchHumanoid()
updateStatus()
player:GetAttributeChangedSignal("__UnliJumpEnabled"):Connect(updateStatus)

-- TAB SWITCHING
local function selectTab(tabName)
    bringPage.Visible = tabName == "BRING"
    teleportPage.Visible = tabName == "TELEPORT"
    playerPage.Visible = tabName == "PLAYER"
    bringTabBtn.BackgroundColor3 = tabName == "BRING" and Color3.fromRGB(74, 125, 255) or Color3.fromRGB(60,60,60)
    bringTabBtn.TextColor3 = tabName == "BRING" and Color3.new(1,1,1) or Color3.fromRGB(0.7,0.7,0.7)
    teleportTabBtn.BackgroundColor3 = tabName == "TELEPORT" and Color3.fromRGB(80, 180, 80) or Color3.fromRGB(60,60,60)
    teleportTabBtn.TextColor3 = tabName == "TELEPORT" and Color3.new(1,1,1) or Color3.fromRGB(0.7,0.7,0.7)
    playerTabBtn.BackgroundColor3 = tabName == "PLAYER" and Color3.fromRGB(140, 90, 250) or Color3.fromRGB(60,60,60)
    playerTabBtn.TextColor3 = tabName == "PLAYER" and Color3.new(1,1,1) or Color3.fromRGB(0.7,0.7,0.7)
end

selectTab("BRING")
bringTabBtn.MouseButton1Click:Connect(function() selectTab("BRING") end)
teleportTabBtn.MouseButton1Click:Connect(function() selectTab("TELEPORT") end)
playerTabBtn.MouseButton1Click:Connect(function() selectTab("PLAYER") end)

-- BOTTOM BAR
local bottomBar = Instance.new("Frame")
bottomBar.Size = UDim2.new(1, -12, 0, 40)
bottomBar.Position = UDim2.new(0, 6, 1, -46)
bottomBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
bottomBar.BackgroundTransparency = 0.07
bottomBar.Parent = frame
bottomBar.BorderSizePixel = 0

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0,6)
padding.PaddingRight = UDim.new(0,6)
padding.PaddingTop = UDim.new(0,6)
padding.PaddingBottom = UDim.new(0,6)
padding.Parent = bottomBar

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Padding = UDim.new(0,6)
layout.Parent = bottomBar

local teleportToCampBtn = Instance.new("TextButton")
teleportToCampBtn.Size = UDim2.new(0, 74, 1, 0)
teleportToCampBtn.Text = "To Camp"
teleportToCampBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
teleportToCampBtn.TextColor3 = Color3.new(1,1,1)
teleportToCampBtn.Font = Enum.Font.GothamBold
teleportToCampBtn.TextSize = 12
teleportToCampBtn.BorderSizePixel = 0
teleportToCampBtn.Parent = bottomBar
local uicornerC = Instance.new("UICorner")
uicornerC.CornerRadius = UDim.new(0,6)
uicornerC.Parent = teleportToCampBtn

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0, 44, 1, 0)
refreshBtn.Text = "REF"
refreshBtn.BackgroundColor3 = Color3.fromRGB(34, 195, 102)
refreshBtn.TextColor3 = Color3.new(1,1,1)
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 12
refreshBtn.BorderSizePixel = 0
refreshBtn.Parent = bottomBar
local uicornerR = Instance.new("UICorner")
uicornerR.CornerRadius = UDim.new(0,6)
uicornerR.Parent = refreshBtn

local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 44, 1, 0)
hideBtn.Text = "HIDE"
hideBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 180)
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextSize = 12
hideBtn.BorderSizePixel = 0
hideBtn.Parent = bottomBar
local uicornerH = Instance.new("UICorner")
uicornerH.CornerRadius = UDim.new(0,6)
uicornerH.Parent = hideBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 44, 1, 0)
closeBtn.Text = "CLOSE"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.BorderSizePixel = 0
closeBtn.Parent = bottomBar
local uicornerX = Instance.new("UICorner")
uicornerX.CornerRadius = UDim.new(0,6)
uicornerX.Parent = closeBtn

local unhideBtn = Instance.new("TextButton")
unhideBtn.Size = UDim2.new(0, 90, 0, 30)
unhideBtn.Position = UDim2.new(0, 6, 0, 6)
unhideBtn.Text = "UNHIDE GUI"
unhideBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 180)
unhideBtn.TextColor3 = Color3.new(1,1,1)
unhideBtn.Font = Enum.Font.GothamBold
unhideBtn.TextSize = 12
unhideBtn.Parent = gui
unhideBtn.Visible = false
local uicornerU = Instance.new("UICorner")
uicornerU.CornerRadius = UDim.new(0,6)
uicornerU.Parent = unhideBtn

teleportToCampBtn.MouseButton1Click:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then warn("No HumanoidRootPart!") return end
    local campModel = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Campground")
    campModel = campModel and campModel:FindFirstChild("MainFire")
    local center = campModel and campModel:FindFirstChild("Center")
    if center and center:IsA("BasePart") then
        root.CFrame = center.CFrame + Vector3.new(0, 5, 0)
    else
        warn("workspace.Map.Campground.MainFire.Center not found or is not a BasePart!")
    end
end)

refreshBtn.MouseButton1Click:Connect(refreshBothTabs)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
hideBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    unhideBtn.Visible = true
end)
unhideBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    unhideBtn.Visible = false
end)

-- DRAG ONLY UI, NOT GAME/PLAYER
local dragBlocker = Instance.new("TextButton")
dragBlocker.Name = "DragBlocker"
dragBlocker.AutoButtonColor = false
dragBlocker.BackgroundTransparency = 1
dragBlocker.Size = UDim2.new(1,0,1,0)
dragBlocker.Position = UDim2.new(0,0,0,0)
dragBlocker.Visible = false
dragBlocker.Parent = gui
dragBlocker.ZIndex = 9
dragBlocker.MouseButton1Down:Connect(function() end)
dragBlocker.MouseButton1Click:Connect(function() end)

do
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    dragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            dragBlocker.Visible = true
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    dragBlocker.Visible = false
                end
            end)
        end
    end)
    dragBar.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)
end
