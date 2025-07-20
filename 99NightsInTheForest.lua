-- CheatXplorer HUB UI, UNHIDE BUTTON top-center, compact width, no text overlap

local plr = game.Players.LocalPlayer

pcall(function()
    plr.PlayerGui:FindFirstChild("BringFoliageUI"):Destroy()
end)

local gui = Instance.new("ScreenGui")
gui.Name = "BringFoliageUI"
gui.Parent = plr:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 240, 0, 420) -- Reduced width & height for compactness
main.BackgroundColor3 = Color3.fromRGB(34, 37, 44)
main.BorderSizePixel = 0
main.AnchorPoint = Vector2.new(0,0)
main.Parent = gui

local wasDragged = false

local function getCenterPosition(w, h)
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
    return UDim2.new(0, math.max(12, math.floor((vp.X-w)/2)), 0, math.max(12, math.floor((vp.Y-h)/2)))
end

local function updateMainSize()
    if wasDragged then return end
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
    local minW = 200
    local minH = 280
    local maxW = 270
    local maxH = 430
    local w = math.clamp(math.floor(vp.X * 0.45), minW, maxW)
    local h = math.clamp(math.floor(vp.Y * 0.7), minH, maxH)
    main.Size = UDim2.new(0, w, 0, h)
    main.Position = getCenterPosition(w, h)
end

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateMainSize)
end
updateMainSize()

local dbar = Instance.new("TextButton")
dbar.Size = UDim2.new(1, 0, 0, 36)
dbar.BackgroundColor3 = Color3.fromRGB(25, 28, 34)
dbar.BorderSizePixel = 0
dbar.Text = ""
dbar.TextTransparency = 1
dbar.Active = true
dbar.Selectable = true
dbar.AutoButtonColor = false
dbar.Parent = main

local dtitle = Instance.new("TextLabel")
dtitle.Size = UDim2.new(1, 0, 1, 0)
dtitle.BackgroundTransparency = 1
dtitle.Text = "CheatXplorer HUB"
dtitle.TextColor3 = Color3.fromRGB(0,255,127)
dtitle.Font = Enum.Font.GothamBold
dtitle.TextSize = 16
dtitle.Parent = dbar

local tbar = Instance.new("Frame")
tbar.Size = UDim2.new(1, -18, 0, 28)
tbar.Position = UDim2.new(0, 9, 0, 40)
tbar.BackgroundTransparency = 1
tbar.BorderSizePixel = 0
tbar.Parent = main

local btnW = 66
local btnH = 22

local btBring = Instance.new("TextButton")
btBring.Size = UDim2.new(0, btnW, 0, btnH)
btBring.Position = UDim2.new(0, 0, 0, 0)
btBring.Text = "BRING"
btBring.BackgroundColor3 = Color3.fromRGB(74, 125, 255)
btBring.TextColor3 = Color3.new(1,1,1)
btBring.Font = Enum.Font.GothamBold
btBring.TextSize = 13
btBring.BorderSizePixel = 0
btBring.AutoButtonColor = false
btBring.Parent = tbar

local btTp = Instance.new("TextButton")
btTp.Size = UDim2.new(0, btnW, 0, btnH)
btTp.Position = UDim2.new(0, btnW + 3, 0, 0)
btTp.Text = "TELEPORT"
btTp.BackgroundColor3 = Color3.fromRGB(60, 180, 120)
btTp.TextColor3 = Color3.new(1,1,1)
btTp.Font = Enum.Font.GothamBold
btTp.TextSize = 13
btTp.BorderSizePixel = 0
btTp.AutoButtonColor = false
btTp.Parent = tbar

local btPlr = Instance.new("TextButton")
btPlr.Size = UDim2.new(0, btnW, 0, btnH)
btPlr.Position = UDim2.new(0, (btnW + 3) * 2, 0, 0)
btPlr.Text = "PLAYER"
btPlr.BackgroundColor3 = Color3.fromRGB(140, 90, 250)
btPlr.TextColor3 = Color3.new(1,1,1)
btPlr.Font = Enum.Font.GothamBold
btPlr.TextSize = 13
btPlr.BorderSizePixel = 0
btPlr.AutoButtonColor = false
btPlr.Parent = tbar

local tabY = 40 + 28 + 6
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -10, 1, -(tabY + 44 + 6))
content.Position = UDim2.new(0, 5, 0, tabY)
content.BackgroundTransparency = 1
content.Parent = main

main:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    content.Size = UDim2.new(1, -10, 1, -(tabY + 44 + 6))
end)

local pgBring = Instance.new("Frame")
pgBring.Size = UDim2.new(1, 0, 1, 0)
pgBring.BackgroundTransparency = 1
pgBring.Parent = content

local scrBring = Instance.new("ScrollingFrame")
scrBring.Size = UDim2.new(1, 0, 1, 0)
scrBring.BackgroundColor3 = Color3.fromRGB(44, 64, 128)
scrBring.BackgroundTransparency = 0.17
scrBring.BorderSizePixel = 0
scrBring.CanvasSize = UDim2.new(0, 0, 0, 0)
scrBring.ScrollBarThickness = 8
scrBring.Parent = pgBring

local layBring = Instance.new("UIListLayout")
layBring.SortOrder = Enum.SortOrder.LayoutOrder
layBring.Padding = UDim.new(0,3)
layBring.Parent = scrBring

local function safeBtn(btn, cb)
    local dragging = false
    local dragStartPos
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
                cb()
            end
        end
    end)
end

local function bringModel(n)
    local char = plr.Character or plr.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    local items = workspace:FindFirstChild("Items")
    if not (root and items) then return end
    local pos = root.CFrame * CFrame.new(0, 0, -9)
    for _,m in ipairs(items:GetChildren()) do
        if m:IsA("Model") and m.Name == n and m.PrimaryPart then
            m:SetPrimaryPartCFrame(pos)
        end
    end
end

local function clearBring()
    for _,c in ipairs(scrBring:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
end

local function fillBring()
    clearBring()
    local items = workspace:FindFirstChild("Items")
    if not items then return end
    local names = {}
    for _,m in ipairs(items:GetChildren()) do
        if m:IsA("Model") and m.PrimaryPart and not names[m.Name] then
            names[m.Name] = true
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 28)
            b.Text = m.Name
            b.BackgroundColor3 = Color3.fromRGB(102, 153, 255)
            b.TextColor3 = Color3.new(1,1,1)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 12
            b.BorderSizePixel = 0
            b.AutoButtonColor = true
            b.Parent = scrBring
            b.ClipsDescendants = true
            b.TextWrapped = true
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 6)
            c.Parent = b
            local s = Instance.new("UIStroke")
            s.Color = Color3.fromRGB(55,55,90)
            s.Thickness = 1
            s.Parent = b
            safeBtn(b, function() bringModel(m.Name) end)
        end
    end
    scrBring.CanvasSize = UDim2.new(0,0,0,layBring.AbsoluteContentSize.Y+3)
end

local pgTp = Instance.new("Frame")
pgTp.Size = UDim2.new(1, 0, 1, 0)
pgTp.BackgroundTransparency = 1
pgTp.Parent = content

local scrTp = Instance.new("ScrollingFrame")
scrTp.Size = UDim2.new(1, 0, 1, 0)
scrTp.BackgroundColor3 = Color3.fromRGB(44, 128, 94)
scrTp.BackgroundTransparency = 0.14
scrTp.BorderSizePixel = 0
scrTp.CanvasSize = UDim2.new(0, 0, 0, 0)
scrTp.ScrollBarThickness = 8
scrTp.Parent = pgTp

local layTp = Instance.new("UIListLayout")
layTp.SortOrder = Enum.SortOrder.LayoutOrder
layTp.Padding = UDim.new(0,3)
layTp.Parent = scrTp

local function tpModel(n)
    local char = plr.Character or plr.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    local fol = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Foliage")
    if not (root and fol) then return end
    for _,m in ipairs(fol:GetChildren()) do
        if m:IsA("Model") and m.PrimaryPart and m.Name == n then
            root.CFrame = m.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
            return
        end
    end
end

local function clearTp()
    for _,c in ipairs(scrTp:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
end

local function fillTp()
    clearTp()
    local fol = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Foliage")
    if not fol then return end
    local names = {}
    for _,m in ipairs(fol:GetChildren()) do
        if m:IsA("Model") and m.PrimaryPart and not names[m.Name] then
            names[m.Name] = true
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 28)
            b.Text = m.Name
            b.BackgroundColor3 = Color3.fromRGB(80, 205, 140)
            b.TextColor3 = Color3.new(1,1,1)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 12
            b.BorderSizePixel = 0
            b.AutoButtonColor = true
            b.Parent = scrTp
            b.ClipsDescendants = true
            b.TextWrapped = true
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 6)
            c.Parent = b
            local s = Instance.new("UIStroke")
            s.Color = Color3.fromRGB(55,90,55)
            s.Thickness = 1
            s.Parent = b
            safeBtn(b, function() tpModel(m.Name) end)
        end
    end
    scrTp.CanvasSize = UDim2.new(0,0,0,layTp.AbsoluteContentSize.Y+3)
end

local function refreshList()
    fillBring()
    fillTp()
end
refreshList()

local pgPlr = Instance.new("Frame")
pgPlr.Size = UDim2.new(1, 0, 1, 0)
pgPlr.BackgroundTransparency = 1
pgPlr.Parent = content

local scrPlr = Instance.new("Frame")
scrPlr.Size = UDim2.new(1, 0, 1, 0)
scrPlr.BackgroundTransparency = 1
scrPlr.Parent = pgPlr

local layPlr = Instance.new("UIListLayout")
layPlr.SortOrder = Enum.SortOrder.LayoutOrder
layPlr.Padding = UDim.new(0, 4)
layPlr.Parent = scrPlr
layPlr.HorizontalAlignment = Enum.HorizontalAlignment.Center
layPlr.VerticalAlignment = Enum.VerticalAlignment.Top

local statWrap = Instance.new("Frame")
statWrap.Size = UDim2.new(1, -6, 0, 32)
statWrap.BackgroundTransparency = 1
statWrap.Parent = scrPlr

local statLay = Instance.new("UIListLayout")
statLay.SortOrder = Enum.SortOrder.LayoutOrder
statLay.Padding = UDim.new(0, 2)
statLay.Parent = statWrap
statLay.HorizontalAlignment = Enum.HorizontalAlignment.Center

local wsStat = Instance.new("TextLabel")
wsStat.Size = UDim2.new(0, 110, 0, 13)
wsStat.BackgroundTransparency = 1
wsStat.Text = "WalkSpeed: ..."
wsStat.TextColor3 = Color3.fromRGB(160,220,255)
wsStat.Font = Enum.Font.GothamBold
wsStat.TextSize = 11
wsStat.Parent = statWrap

local jumpStat = Instance.new("TextLabel")
jumpStat.Size = UDim2.new(0, 110, 0, 13)
jumpStat.BackgroundTransparency = 1
jumpStat.Text = "Unli Jump: ..."
jumpStat.TextColor3 = Color3.fromRGB(180,120,250)
jumpStat.Font = Enum.Font.GothamBold
jumpStat.TextSize = 11
jumpStat.Parent = statWrap

local infoBox = Instance.new("Frame")
infoBox.Size = UDim2.new(1, -10, 0, 55)
infoBox.BackgroundTransparency = 1
infoBox.Parent = scrPlr

local infoLay = Instance.new("UIListLayout")
infoLay.SortOrder = Enum.SortOrder.LayoutOrder
infoLay.Padding = UDim.new(0, 0)
infoLay.Parent = infoBox
infoLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
infoLay.VerticalAlignment = Enum.VerticalAlignment.Center

local lblGame = Instance.new("TextLabel")
lblGame.Size = UDim2.new(1, 0, 0, 14)
lblGame.BackgroundTransparency = 1
lblGame.Text = "Game: 99 Nights in the Forest"
lblGame.TextColor3 = Color3.fromRGB(170, 220, 255)
lblGame.Font = Enum.Font.GothamBold
lblGame.TextSize = 11
lblGame.TextStrokeTransparency = 0.7
lblGame.Parent = infoBox

local lblBy = Instance.new("TextLabel")
lblBy.Size = UDim2.new(1, 0, 0, 14)
lblBy.BackgroundTransparency = 1
lblBy.Text = "Creator: CheatXplorer"
lblBy.TextColor3 = Color3.fromRGB(140, 255, 180)
lblBy.Font = Enum.Font.GothamBold
lblBy.TextSize = 11
lblBy.TextStrokeTransparency = 0.7
lblBy.Parent = infoBox

local lblDisc = Instance.new("TextLabel")
lblDisc.Size = UDim2.new(1, 0, 0, 14)
lblDisc.BackgroundTransparency = 1
lblDisc.Text = "Discord: discord.gg/qQswtd3YGY"
lblDisc.TextColor3 = Color3.fromRGB(255, 200, 120)
lblDisc.Font = Enum.Font.GothamBold
lblDisc.TextSize = 11
lblDisc.TextStrokeTransparency = 0.7
lblDisc.Parent = infoBox

local function ws()
    local char = plr.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    return hum and hum.WalkSpeed or 0
end

local function updateStats()
    wsStat.Text = "WalkSpeed: " .. tostring(ws())
    jumpStat.Text = "Unli Jump: " .. (plr:GetAttribute("__UnliJumpEnabled") == true and "ENABLED" or "DISABLED")
    jumpStat.TextColor3 = plr:GetAttribute("__UnliJumpEnabled") == true and Color3.fromRGB(70,255,120) or Color3.fromRGB(220,100,100)
end

plr:GetPropertyChangedSignal("Character"):Connect(updateStats)
plr.CharacterAdded:Connect(updateStats)

local function mkBtn(txt, col, width)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, width or 97, 0, 17)
    b.Text = txt
    b.BackgroundColor3 = col
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.BorderSizePixel = 0
    b.AutoButtonColor = true
    b.TextWrapped = true
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = b
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(55,55,90)
    s.Thickness = 1
    s.Parent = b
    return b
end

local wsPlus = mkBtn("+1 Walkspeed", Color3.fromRGB(80, 170, 250))
wsPlus.Parent = scrPlr

local wsMinus = mkBtn("-1 Walkspeed", Color3.fromRGB(80, 120, 200))
wsMinus.Parent = scrPlr

local jumpOn = mkBtn("Enable Unli Jump", Color3.fromRGB(140, 90, 250))
jumpOn.Parent = scrPlr

local jumpOff = mkBtn("Disable Unli Jump", Color3.fromRGB(120, 120, 120))
jumpOff.Parent = scrPlr

safeBtn(wsPlus, function()
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = hum.WalkSpeed + 1 updateStats() end
end)
safeBtn(wsMinus, function()
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = math.max(0, hum.WalkSpeed - 1) updateStats() end
end)

local jumpConn
safeBtn(jumpOn, function()
    if jumpConn then jumpConn:Disconnect() end
    plr:SetAttribute("__UnliJumpEnabled", true)
    jumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
    updateStats()
end)
safeBtn(jumpOff, function()
    if jumpConn then jumpConn:Disconnect() jumpConn = nil end
    plr:SetAttribute("__UnliJumpEnabled", false)
    updateStats()
end)

if not plr:GetAttribute("__UnliJumpEnabled") then
    plr:SetAttribute("__UnliJumpEnabled", false)
end

local function watchHum()
    local char = plr.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:GetPropertyChangedSignal("WalkSpeed"):Connect(updateStats)
    end
end
plr.CharacterAdded:Connect(function() watchHum() updateStats() end)
watchHum()
updateStats()
plr:GetAttributeChangedSignal("__UnliJumpEnabled"):Connect(updateStats)

local function setTab(tab)
    pgBring.Visible = tab == "BRING"
    pgTp.Visible = tab == "TELEPORT"
    pgPlr.Visible = tab == "PLAYER"
    btBring.BackgroundColor3 = tab == "BRING" and Color3.fromRGB(74, 125, 255) or Color3.fromRGB(60,60,60)
    btBring.TextColor3 = tab == "BRING" and Color3.new(1,1,1) or Color3.fromRGB(0.7,0.7,0.7)
    btTp.BackgroundColor3 = tab == "TELEPORT" and Color3.fromRGB(80, 180, 80) or Color3.fromRGB(60,60,60)
    btTp.TextColor3 = tab == "TELEPORT" and Color3.new(1,1,1) or Color3.fromRGB(0.7,0.7,0.7)
    btPlr.BackgroundColor3 = tab == "PLAYER" and Color3.fromRGB(140, 90, 250) or Color3.fromRGB(60,60,60)
    btPlr.TextColor3 = tab == "PLAYER" and Color3.new(1,1,1) or Color3.fromRGB(0.7,0.7,0.7)
end

setTab("BRING")
btBring.MouseButton1Click:Connect(function() setTab("BRING") end)
btTp.MouseButton1Click:Connect(function() setTab("TELEPORT") end)
btPlr.MouseButton1Click:Connect(function() setTab("PLAYER") end)

local bottom = Instance.new("Frame")
bottom.Size = UDim2.new(1, -8, 0, 35)
bottom.Position = UDim2.new(0, 4, 1, -39)
bottom.BackgroundColor3 = Color3.fromRGB(30,30,30)
bottom.BackgroundTransparency = 0.07
bottom.Parent = main
bottom.BorderSizePixel = 0

local pad = Instance.new("UIPadding")
pad.PaddingLeft = UDim.new(0,4)
pad.PaddingRight = UDim.new(0,4)
pad.PaddingTop = UDim.new(0,4)
pad.PaddingBottom = UDim.new(0,4)
pad.Parent = bottom

local layBottom = Instance.new("UIListLayout")
layBottom.FillDirection = Enum.FillDirection.Horizontal
layBottom.VerticalAlignment = Enum.VerticalAlignment.Center
layBottom.HorizontalAlignment = Enum.HorizontalAlignment.Center
layBottom.Padding = UDim.new(0,2)
layBottom.Parent = bottom

local btnCamp = Instance.new("TextButton")
btnCamp.Size = UDim2.new(0, 50, 1, 0)
btnCamp.Text = "To Camp"
btnCamp.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
btnCamp.TextColor3 = Color3.new(1,1,1)
btnCamp.Font = Enum.Font.GothamBold
btnCamp.TextSize = 11
btnCamp.BorderSizePixel = 0
btnCamp.Parent = bottom
local c1 = Instance.new("UICorner")
c1.CornerRadius = UDim.new(0,5)
c1.Parent = btnCamp

local btnRef = Instance.new("TextButton")
btnRef.Size = UDim2.new(0, 58, 1, 0)
btnRef.Text = "REFRESH"
btnRef.BackgroundColor3 = Color3.fromRGB(34, 195, 102)
btnRef.TextColor3 = Color3.new(1,1,1)
btnRef.Font = Enum.Font.GothamBold
btnRef.TextSize = 10
btnRef.BorderSizePixel = 0
btnRef.Parent = bottom
local c2 = Instance.new("UICorner")
c2.CornerRadius = UDim.new(0,5)
c2.Parent = btnRef

local btnHide = Instance.new("TextButton")
btnHide.Size = UDim2.new(0, 38, 1, 0)
btnHide.Text = "HIDE"
btnHide.BackgroundColor3 = Color3.fromRGB(60, 60, 180)
btnHide.TextColor3 = Color3.new(1,1,1)
btnHide.Font = Enum.Font.GothamBold
btnHide.TextSize = 10
btnHide.BorderSizePixel = 0
btnHide.Parent = bottom
local c3 = Instance.new("UICorner")
c3.CornerRadius = UDim.new(0,5)
c3.Parent = btnHide

local btnClose = Instance.new("TextButton")
btnClose.Size = UDim2.new(0, 38, 1, 0)
btnClose.Text = "CLOSE"
btnClose.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
btnClose.TextColor3 = Color3.new(1,1,1)
btnClose.Font = Enum.Font.GothamBold
btnClose.TextSize = 10
btnClose.BorderSizePixel = 0
btnClose.Parent = bottom
local c4 = Instance.new("UICorner")
c4.CornerRadius = UDim.new(0,5)
c4.Parent = btnClose

-- UNHIDE BUTTON: top center, no text overlap, compact
local btnUnhide = Instance.new("TextButton")
btnUnhide.Size = UDim2.new(0, 90, 0, 26)
btnUnhide.AnchorPoint = Vector2.new(0.5, 0)
btnUnhide.Position = UDim2.new(0.5, 0, 0, 6)
btnUnhide.Text = "UNHIDE"
btnUnhide.BackgroundColor3 = Color3.fromRGB(60, 60, 180)
btnUnhide.TextColor3 = Color3.new(1,1,1)
btnUnhide.Font = Enum.Font.GothamBold
btnUnhide.TextSize = 12
btnUnhide.Parent = gui
btnUnhide.Visible = false
local c5 = Instance.new("UICorner")
c5.CornerRadius = UDim.new(0,5)
c5.Parent = btnUnhide

btnCamp.MouseButton1Click:Connect(function()
    local char = plr.Character or plr.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    local camp = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Campground")
    camp = camp and camp:FindFirstChild("MainFire")
    local center = camp and camp:FindFirstChild("Center")
    if center and center:IsA("BasePart") then
        root.CFrame = center.CFrame + Vector3.new(0, 5, 0)
    end
end)
btnRef.MouseButton1Click:Connect(refreshList)
btnClose.MouseButton1Click:Connect(function() gui:Destroy() end)
btnHide.MouseButton1Click:Connect(function()
    main.Visible = false
    btnUnhide.Visible = true
end)
btnUnhide.MouseButton1Click:Connect(function()
    main.Visible = true
    btnUnhide.Visible = false
end)

local UIS = game:GetService("UserInputService")
local dragging = false
local dragStart, startPos

dbar.MouseButton1Down:Connect(function()
    dragging = true
    wasDragged = true
    dragStart = UIS:GetMouseLocation()
    startPos = main.Position
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local cur = UIS:GetMouseLocation()
        local delta = cur - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragging = false
    end
end)
