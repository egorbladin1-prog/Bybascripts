-- ==========================================
-- BYBA HUB v4.0
-- Создатель: Byba (@whygoldzy)
-- Telegram канал: @BybaAL
-- Бот для ключей: @BybaHube_bot
-- ==========================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

print("BYBA HUB - ЗАГРУЗКА...")

-- ==========================================
-- ПРОВЕРКА КЛЮЧА
-- ==========================================
local function VerifyKey(Key)
    if Key == nil or Key == "" then return false end
    -- Локальный ключ для теста (бот выдаёт такие же)
    local ValidKeys = {"BYBA2026", "BYBA-HUB-2026", "BYBAHUB2026"}
    for _, v in ipairs(ValidKeys) do
        if Key == v then return true end
    end
    return false
end

-- ==========================================
-- ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
-- ==========================================
_G.AutoWin = false
_G.SelectedWinLevel = "Level 1"
_G.BYBAHubRunId = game:GetService("HttpService"):GenerateGUID(false)

-- СКОРОСТЬ АВТОВИНА (400)
local WALK_SPEED = 400

-- ==========================================
-- ХОДЬБА (СКОРОСТЬ 400)
-- ==========================================
local function WalkToTarget(TargetPos)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for i = 1, 30 do
        if not _G.AutoWin then break end

        local char = LocalPlayer.Character
        if not char then break end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then break end

        local dist = (TargetPos - hrp.Position).Magnitude
        if dist < 3 then
            hrp.CFrame = CFrame.new(TargetPos)
            break
        end

        local dir = (TargetPos - hrp.Position).Unit
        hrp.Velocity = dir * WALK_SPEED  -- СКОРОСТЬ 400
        task.wait(0.1)
    end

    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = Vector3.new(0, 0, 0)
    end
end

-- ==========================================
-- GUI (МЕНЮ)
-- ==========================================
local targetParent = gethui()
if targetParent:FindFirstChild("BYBAHub") then
    targetParent:FindFirstChild("BYBAHub"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BYBAHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = targetParent

local Theme = {
    Background = Color3.fromRGB(15, 15, 20),
    SidebarBg = Color3.fromRGB(10, 10, 12),
    Accent = Color3.fromRGB(255, 0, 100),
    AccentCyan = Color3.fromRGB(0, 255, 255),
    Text = Color3.fromRGB(240, 240, 245),
    SecondaryText = Color3.fromRGB(150, 150, 160),
    ToggleOn = Color3.fromRGB(255, 0, 100),
    ToggleOff = Color3.fromRGB(45, 45, 55),
}

-- ==========================================
-- ОКНО КЛЮЧА
-- ==========================================
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 320, 0, 220)
KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
KeyFrame.BackgroundColor3 = Theme.Background
KeyFrame.Parent = ScreenGui
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)
local KeyStroke = Instance.new("UIStroke", KeyFrame)
KeyStroke.Color = Theme.Accent
KeyStroke.Thickness = 1.5

local Title = Instance.new("TextLabel", KeyFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Theme.Accent
Title.TextSize = 18
Title.Text = "BYBA HUB"

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0.8, 0, 0, 36)
KeyInput.Position = UDim2.new(0.1, 0, 0.3, 0)
KeyInput.BackgroundColor3 = Theme.SidebarBg
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextColor3 = Theme.Text
KeyInput.PlaceholderText = "Enter key here..."
KeyInput.PlaceholderColor3 = Theme.SecondaryText
KeyInput.TextSize = 14
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 6)

local GetKeyBtn = Instance.new("TextButton", KeyFrame)
GetKeyBtn.Size = UDim2.new(0.38, 0, 0, 36)
GetKeyBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
GetKeyBtn.BackgroundColor3 = Theme.ToggleOff
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextColor3 = Theme.Text
GetKeyBtn.TextSize = 12
GetKeyBtn.Text = "Get Key"
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 6)

local SubmitBtn = Instance.new("TextButton", KeyFrame)
SubmitBtn.Size = UDim2.new(0.38, 0, 0, 36)
SubmitBtn.Position = UDim2.new(0.52, 0, 0.55, 0)
SubmitBtn.BackgroundColor3 = Theme.Accent
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextColor3 = Theme.Text
SubmitBtn.TextSize = 14
SubmitBtn.Text = "Verify"
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 6)

local StatusText = Instance.new("TextLabel", KeyFrame)
StatusText.Size = UDim2.new(1, 0, 0, 30)
StatusText.Position = UDim2.new(0, 0, 0.82, 0)
StatusText.BackgroundTransparency = 1
StatusText.Font = Enum.Font.Gotham
StatusText.TextColor3 = Theme.SecondaryText
StatusText.TextSize = 11
StatusText.Text = "TG: @whygoldzy"

GetKeyBtn.MouseButton1Click:Connect(function()
    local botLink = "https://t.me/BybaHube_bot"
    if setclipboard then
        pcall(function() setclipboard(botLink) end)
        StatusText.Text = "✅ Ссылка на бота скопирована!"
        StatusText.TextColor3 = Color3.fromRGB(0, 255, 0)
        task.wait(2)
        StatusText.Text = "TG: @whygoldzy"
        StatusText.TextColor3 = Theme.SecondaryText
    end
end)

SubmitBtn.MouseButton1Click:Connect(function()
    local key = KeyInput.Text
    if key == "" then
        StatusText.Text = "❌ Введите ключ!"
        StatusText.TextColor3 = Color3.fromRGB(255, 0, 0)
        return
    end
    StatusText.Text = "⏳ Проверка..."
    StatusText.TextColor3 = Color3.fromRGB(255, 255, 0)
    task.spawn(function()
        if VerifyKey(key) then
            StatusText.Text = "✅ КЛЮЧ ПРИНЯТ!"
            StatusText.TextColor3 = Color3.fromRGB(0, 255, 0)
            KeyStroke.Color = Color3.fromRGB(0, 255, 0)
            task.wait(0.5)
            TweenService:Create(KeyFrame, TweenInfo.new(0.5), {
                Position = UDim2.new(0.5, -160, 0.5, -500),
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.5)
            KeyFrame.Visible = false
            setupMainMenu()
        else
            StatusText.Text = "❌ НЕВЕРНЫЙ КЛЮЧ!"
            StatusText.TextColor3 = Color3.fromRGB(255, 0, 0)
            KeyStroke.Color = Color3.fromRGB(255, 0, 0)
            task.wait(1)
            KeyStroke.Color = Theme.Accent
            KeyInput.Text = ""
            StatusText.Text = "TG: @whygoldzy"
            StatusText.TextColor3 = Theme.SecondaryText
        end
    end)
end)

function setupMainMenu()
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 520, 0, 460)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -230)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = Theme.Accent
    Stroke.Thickness = 1.5

    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Theme.SidebarBg
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

    local Title = Instance.new("TextLabel", Sidebar)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Theme.Accent
    Title.TextSize = 15
    Title.Text = "BYBA HUB"

    local TabContainer = Instance.new("Frame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.BackgroundTransparency = 1

    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -160, 1, -50)
    ContentArea.Position = UDim2.new(0, 155, 0, 40)
    ContentArea.BackgroundTransparency = 1

    local tabs = {}
    local function SwitchTab(name)
        for tabName, container in pairs(tabs) do
            container.Visible = (tabName == name)
        end
    end

    local function CreateTab(name, icon)
        local btn = Instance.new("TextButton", TabContainer)
        btn.Size = UDim2.new(1, -10, 0, 34)
        btn.Position = UDim2.new(0, 5, 0, (#TabContainer:GetChildren() * 38))
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        btn.Font = Enum.Font.GothamMedium
        btn.TextColor3 = Theme.Text
        btn.TextSize = 11
        btn.Text = "  " .. icon .. "  " .. name
        btn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

        local page = Instance.new("ScrollingFrame", ContentArea)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = Theme.Accent
        page.Visible = false
        local layout = Instance.new("UIListLayout", page)
        layout.Padding = UDim.new(0, 8)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        tabs[name] = page
        btn.MouseButton1Click:Connect(function() SwitchTab(name) end)
        return page
    end

    local runId = game:GetService("HttpService"):GenerateGUID(false)
    _G.BYBAHubRunId = runId

    local tabMain = CreateTab("Main", "⚡")
    local tabFarming = CreateTab("Farming", "🌾")
    local tabVisuals = CreateTab("Visuals", "👁️")
    local tabShop = CreateTab("Shop", "🛒")
    local tabTeleports = CreateTab("Teleports", "📍")
    local tabExploits = CreateTab("Exploits", "⚙️")
    local tabAbout = CreateTab("About", "ℹ️")

    SwitchTab("Main")

    local function CreateToggle(parent, text, default, callback)
        local frame = Instance.new("Frame", parent)
        frame.Size = UDim2.new(0.95, 0, 0, 40)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.TextColor3 = Theme.Text
        label.TextSize = 12
        label.Text = text
        label.TextXAlignment = Enum.TextXAlignment.Left

        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(0, 36, 0, 18)
        btn.Position = UDim2.new(1, -46, 0.5, -9)
        btn.BackgroundColor3 = default and Theme.ToggleOn or Theme.ToggleOff
        btn.Text = ""
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

        local circle = Instance.new("Frame", btn)
        circle.Size = UDim2.new(0, 14, 0, 14)
        circle.Position = default and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        circle.BackgroundColor3 = Theme.Text
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

        local active = default
        btn.MouseButton1Click:Connect(function()
            active = not active
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = active and Theme.ToggleOn or Theme.ToggleOff}):Play()
            TweenService:Create(circle, TweenInfo.new(0.15), {Position = active and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}):Play()
            pcall(callback, active)
        end)
    end

    local function CreateDropdown(parent, text, options, default, callback)
        local frame = Instance.new("Frame", parent)
        frame.Size = UDim2.new(0.95, 0, 0, 40)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        frame.ClipsDescendants = true
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(0.5, 0, 0, 40)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.TextColor3 = Theme.Text
        label.TextSize = 12
        label.Text = text
        label.TextXAlignment = Enum.TextXAlignment.Left

        local mainBtn = Instance.new("TextButton", frame)
        mainBtn.Size = UDim2.new(0.4, 0, 0, 28)
        mainBtn.Position = UDim2.new(0.55, 0, 0, 6)
        mainBtn.BackgroundColor3 = Theme.SidebarBg
        mainBtn.Font = Enum.Font.Gotham
        mainBtn.TextColor3 = Theme.AccentCyan
        mainBtn.TextSize = 11
        mainBtn.Text = tostring(default)
        Instance.new("UICorner", mainBtn).CornerRadius = UDim.new(0, 4)

        local list = Instance.new("Frame", frame)
        list.Size = UDim2.new(0.4, 0, 0, #options * 26)
        list.Position = UDim2.new(0.55, 0, 0, 36)
        list.BackgroundColor3 = Theme.SidebarBg
        list.Visible = false
        list.ZIndex = 10
        Instance.new("UICorner", list).CornerRadius = UDim.new(0, 4)

        local open = false
        mainBtn.MouseButton1Click:Connect(function()
            open = not open
            list.Visible = open
            frame.Size = open and UDim2.new(0.95, 0, 0, 40 + (#options * 26)) or UDim2.new(0.95, 0, 0, 40)
        end)

        UserInputService.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and open then
                task.wait(0.1)
                if open then
                    local mousePos = UserInputService:GetMouseLocation()
                    local bPos = mainBtn.AbsolutePosition
                    local bSize = mainBtn.AbsoluteSize
                    local lPos = list.AbsolutePosition
                    local lSize = list.AbsoluteSize
                    if not (mousePos.X >= bPos.X and mousePos.X <= bPos.X + bSize.X and mousePos.Y >= bPos.Y and mousePos.Y <= bPos.Y + bSize.Y) and
                       not (mousePos.X >= lPos.X and mousePos.X <= lPos.X + lSize.X and mousePos.Y >= lPos.Y and mousePos.Y <= lPos.Y + lSize.Y) then
                        open = false
                        list.Visible = false
                        frame.Size = UDim2.new(0.95, 0, 0, 40)
                    end
                end
            end
        end)

        for i, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton", list)
            optBtn.Size = UDim2.new(1, 0, 0, 24)
            optBtn.Position = UDim2.new(0, 0, 0, (i-1)*24)
            optBtn.BackgroundTransparency = 1
            optBtn.Font = Enum.Font.Gotham
            optBtn.TextColor3 = Theme.Text
            optBtn.TextSize = 11
            optBtn.Text = tostring(opt)
            optBtn.ZIndex = 11
            optBtn.MouseButton1Click:Connect(function()
                mainBtn.Text = tostring(opt)
                list.Visible = false
                frame.Size = UDim2.new(0.95, 0, 0, 40)
                open = false
                pcall(callback, opt)
            end)
        end
    end

    local function CreateButton(parent, text, callback)
        local frame = Instance.new("Frame", parent)
        frame.Size = UDim2.new(0.95, 0, 0, 40)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1, -20, 1, -12)
        btn.Position = UDim2.new(0, 10, 0, 6)
        btn.BackgroundColor3 = Theme.Accent
        btn.Font = Enum.Font.GothamBold
        btn.TextColor3 = Theme.Text
        btn.TextSize = 12
        btn.Text = text
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        btn.MouseButton1Click:Connect(function() pcall(callback) end)
    end

    -- ==========================================
    -- MAIN
    -- ==========================================
    CreateToggle(tabMain, "Speed (WalkSpeed 250)", false, function(state)
        _G.SpeedEnabled = state
        task.spawn(function()
            while _G.SpeedEnabled and _G.BYBAHubRunId == runId do
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum.WalkSpeed = 250 end) end
                task.wait(0.5)
            end
        end)
    end)

    CreateToggle(tabMain, "Infinite Jump", false, function(state)
        _G.InfiniteJump = state
        if state then
            _G.JumpConnection = UserInputService.JumpRequest:Connect(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum:GetState() ~= Enum.HumanoidStateType.Jumping then
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                end
            end)
        else
            if _G.JumpConnection then
                _G.JumpConnection:Disconnect()
                _G.JumpConnection = nil
            end
        end
    end)

    CreateToggle(tabMain, "Auto Rebirth", false, function(state)
        _G.AutoRebirth = state
        task.spawn(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            local rebirth = remotes and remotes:FindFirstChild("Rebirth")
            while _G.AutoRebirth and _G.BYBAHubRunId == runId do
                if rebirth then
                    pcall(function() rebirth:FireServer() end)
                    task.wait(0.5)
                    local success = remotes and remotes:FindFirstChild("RebirthSuccess")
                    if success then pcall(function() success:FireServer() end) end
                end
                task.wait(10)
            end
        end)
    end)

    CreateToggle(tabMain, "Anti Ragdoll", false, function(state)
        _G.AntiRagdoll = state
        local function fixRagdoll(char)
            if not _G.AntiRagdoll then return end
            local rs = char:FindFirstChild("RagdollScript") or char:FindFirstChild("Ragdoll")
            if rs then rs.Disabled = true end
        end
        if LocalPlayer.Character then fixRagdoll(LocalPlayer.Character) end
        LocalPlayer.CharacterAdded:Connect(fixRagdoll)
    end)

    -- ==========================================
    -- FARMING (АВТОВИН СКОРОСТЬ 400)
    -- ==========================================
    local LobbyCFrame = CFrame.new(12, 13, -25)
    pcall(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then LobbyCFrame = hrp.CFrame end
    end)

    local function getStartSpawn(levelNum)
        if levelNum == 1 then
            return Workspace:FindFirstChild("Structure") and Workspace.Structure:FindFirstChild("Stage0_HUB")
        else
            local spawns = Workspace:FindFirstChild("Checkpoints") and Workspace.Checkpoints:FindFirstChild("Spawns")
            return spawns and spawns:FindFirstChild("Stage" .. tostring(levelNum))
        end
    end

    CreateDropdown(tabFarming, "Select Win Level", {"Level 1", "Level 2", "Level 3", "Level 4", "Level 5", "Level 6", "Level 7", "Level 8"}, "Level 1", function(val)
        _G.SelectedWinLevel = val
    end)

    CreateToggle(tabFarming, "Auto Farm Wins (Speed 400)", false, function(state)
        _G.AutoWin = state
        if state then
            task.spawn(function()
                while _G.AutoWin and _G.BYBAHubRunId == runId do
                    pcall(function()
                        local char, hrp, hum = LocalPlayer.Character, LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if not hrp or not hum then task.wait(0.5) return end

                        local levelNum = tonumber(_G.SelectedWinLevel:match("%d+")) or 1

                        local winPart = nil
                        for _, obj in pairs(Workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and obj.Name == "WinBlock" .. levelNum then
                                winPart = obj
                                break
                            end
                        end

                        local startSpawn = getStartSpawn(levelNum)

                        if winPart then
                            WalkToTarget(winPart.Position + Vector3.new(0, 2, 0))

                            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                            if remotes then
                                local addWin = remotes:FindFirstChild("AddWin")
                                if addWin then
                                    for i = 1, 3 do
                                        pcall(function() addWin:FireServer() end)
                                        task.wait(0.1)
                                    end
                                end
                            end

                            task.wait(0.2)

                            local spawnPos = (startSpawn and startSpawn.Position or LobbyCFrame.Position) + Vector3.new(0, 3, 0)
                            WalkToTarget(spawnPos)

                            if levelNum < 8 then
                                _G.SelectedWinLevel = "Level " .. (levelNum + 1)
                            else
                                _G.SelectedWinLevel = "Level 1"
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end)

    CreateToggle(tabFarming, "Farm Treadmill", false, function(state)
        _G.FarmTreadmill = state
        task.spawn(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            local ts = remotes and remotes:FindFirstChild("TreadmillSignal")
            while _G.FarmTreadmill and _G.BYBAHubRunId == runId do
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local treadmill = Workspace:FindFirstChild("Treadmill")
                if hrp and treadmill and ts then
                    pcall(function() ts:FireServer(treadmill) end)
                end
                task.wait(1)
            end
        end)
    end)

    CreateToggle(tabFarming, "Farm Admin Treadmill x100", false, function(state)
        _G.FarmAdminTreadmill = state
        task.spawn(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            local ts = remotes and remotes:FindFirstChild("TreadmillSignal")
            while _G.FarmAdminTreadmill and _G.BYBAHubRunId == runId do
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local admin = Workspace:FindFirstChild("TreadmillAdmin") or (Workspace:FindFirstChild("Treadmill") and Workspace.Treadmill:FindFirstChild("TreadmillAdmin"))
                if hrp and admin and ts then
                    pcall(function() ts:FireServer(admin) end)
                end
                task.wait(1)
            end
        end)
    end)

    -- ==========================================
    -- VISUALS (ESP)
    -- ==========================================
    local highlights = {}
    local function createHighlight(player, char)
        if not _G.EspEnabled or not char or player == LocalPlayer then return end
        if highlights[player] then
            pcall(function() highlights[player]:Destroy() end)
            highlights[player] = nil
        end
        local h = Instance.new("Highlight")
        h.Name = "BYBAESP"
        h.FillColor = Color3.fromRGB(0, 255, 255)
        h.OutlineColor = Color3.fromRGB(255, 0, 100)
        h.FillTransparency = 0.5
        h.OutlineTransparency = 0
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Adornee = char
        h.Parent = ScreenGui
        highlights[player] = h
    end

    local function applyESP(player)
        if player == LocalPlayer then return end
        player.CharacterAdded:Connect(function(char)
            task.wait(0.2)
            createHighlight(player, char)
        end)
        if player.Character then
            task.spawn(createHighlight, player, player.Character)
        end
    end

    local function enableESP()
        for _, player in pairs(Players:GetPlayers()) do
            applyESP(player)
        end
    end

    local function disableESP()
        for _, h in pairs(highlights) do
            pcall(function() h:Destroy() end)
        end
        table.clear(highlights)
    end

    for _, player in pairs(Players:GetPlayers()) do
        applyESP(player)
    end
    Players.PlayerAdded:Connect(applyESP)

    CreateToggle(tabVisuals, "Player ESP", false, function(state)
        _G.EspEnabled = state
        if state then enableESP() else disableESP() end
    end)

    CreateDropdown(tabVisuals, "Select Aura", {"GlowAura", "WindAura", "MedalAura", "WaterAura", "FireAura", "ElectricAura"}, "GlowAura", function(val)
        _G.SelectedAura = val
    end)

    CreateToggle(tabVisuals, "Auto Buy Aura", false, function(state)
        _G.AutoBuyAura = state
        task.spawn(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            local buy = remotes and remotes:FindFirstChild("BuyAura")
            while _G.AutoBuyAura and _G.BYBAHubRunId == runId do
                if buy then pcall(function() buy:InvokeServer(_G.SelectedAura) end) end
                task.wait(2)
            end
        end)
    end)

    CreateToggle(tabVisuals, "Auto Equip Aura", false, function(state)
        _G.AutoEquipAura = state
        task.spawn(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            local equip = remotes and remotes:FindFirstChild("EquipAura")
            while _G.AutoEquipAura and _G.BYBAHubRunId == runId do
                if equip then pcall(function() equip:FireServer(_G.SelectedAura) end) end
                task.wait(2)
            end
        end)
    end)

    CreateDropdown(tabVisuals, "Select Trail", {"GreenTrail", "BlueTrail", "PurpleTrail", "RedTrail", "RainbowTrail", "GalaxyTrail", "CosmicTrail"}, "GreenTrail", function(val)
        _G.SelectedTrail = val
    end)

    CreateToggle(tabVisuals, "Auto Buy Trail", false, function(state)
        _G.AutoBuyTrail = state
        task.spawn(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            local buy = remotes and remotes:FindFirstChild("BuyTrail")
            while _G.AutoBuyTrail and _G.BYBAHubRunId == runId do
                if buy then pcall(function() buy:InvokeServer(_G.SelectedTrail) end) end
                task.wait(2)
            end
        end)
    end)

    CreateToggle(tabVisuals, "Auto Equip Trail", false, function(state)
        _G.AutoEquipTrail = state
        task.spawn(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            local equip = remotes and remotes:FindFirstChild("EquipTrail")
            while _G.AutoEquipTrail and _G.BYBAHubRunId == runId do
                if equip then pcall(function() equip:FireServer(_G.SelectedTrail) end) end
                task.wait(2)
            end
        end)
    end)

    -- ==========================================
    -- SHOP
    -- ==========================================
    CreateDropdown(tabShop, "Select Crate", {"Common", "Uncommon", "Rare"}, "Common", function(val)
        _G.SelectedCrate = val
    end)

    CreateToggle(tabShop, "Auto Buy Crate", false, function(state)
        _G.AutoBuyCrate = state
        task.spawn(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            local action = remotes and remotes:FindFirstChild("ItemAction")
            while _G.AutoBuyCrate and _G.BYBAHubRunId == runId do
                if action then pcall(function() action:FireServer("BuyCrate", _G.SelectedCrate) end) end
                task.wait(1.5)
            end
        end)
    end)

    -- ==========================================
    -- TELEPORTS
    -- ==========================================
    CreateButton(tabTeleports, "Teleport to Spawn", function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(12, 13, -25) end
    end)

    for lvl = 1, 8 do
        CreateButton(tabTeleports, "Teleport to Level " .. lvl, function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local win = nil
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Name == "WinBlock" .. lvl then
                        win = obj
                        break
                    end
                end
                if win then
                    hrp.CFrame = win.CFrame + Vector3.new(0, 3, 0)
                end
            end
        end)
    end

    -- ==========================================
    -- EXPLOITS
    -- ==========================================
    CreateToggle(tabExploits, "Anti Trap (Lava/Walls)", false, function(state)
        _G.AntiTrap = state
        task.spawn(function()
            while _G.AntiTrap and _G.BYBAHubRunId == runId do
                pcall(function()
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            local name = obj.Name:lower()
                            if name:find("lava") or name:find("trap") or name:find("kill") or name:find("spike") or name:find("wall") then
                                obj:Destroy()
                            end
                        end
                    end
                end)
                task.wait(5)
            end
        end)
    end)

    CreateToggle(tabExploits, "Bypass Premium Barriers", false, function(state)
        _G.BypassTreadmill = state
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name == "PremiumBarrier" or obj.Name == "Barrier" or obj.Name == "Gate") then
                obj.CanCollide = not state
                obj.Transparency = state and 0.5 or 0
            end
        end
    end)

    CreateToggle(tabExploits, "Hold Jump to Fly", false, function(state)
        _G.HoldToFly = state
        task.spawn(function()
            while _G.HoldToFly and _G.BYBAHubRunId == runId do
                local _, hrp, hum = LocalPlayer.Character, LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and (hum.Jump or UserInputService:IsKeyDown(Enum.KeyCode.Space)) then
                    pcall(function() hrp.Velocity = Vector3.new(hrp.Velocity.X, 55, hrp.Velocity.Z) end)
                end
                task.wait(0.01)
            end
        end)
    end)

    -- ==========================================
    -- ABOUT (ИНФОРМАЦИЯ О СКРИПТЕ)
    -- ==========================================
    local AboutFrame = Instance.new("Frame", tabAbout)
    AboutFrame.Size = UDim2.new(0.95, 0, 0, 250)
    AboutFrame.Position = UDim2.new(0.025, 0, 0, 10)
    AboutFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Instance.new("UICorner", AboutFrame).CornerRadius = UDim.new(0, 8)

    local AboutText = Instance.new("TextLabel", AboutFrame)
    AboutText.Size = UDim2.new(1, -20, 1, -20)
    AboutText.Position = UDim2.new(0, 10, 0, 10)
    AboutText.BackgroundTransparency = 1
    AboutText.TextColor3 = Theme.Text
    AboutText.TextSize = 13
    AboutText.Font = Enum.Font.Gotham
    AboutText.TextWrapped = true
    AboutText.TextYAlignment = Enum.TextYAlignment.Top
    AboutText.Text = [[
📌 BYBA HUB v4.0

👤 Создатель: Byba (@whygoldzy)
📢 Канал: @BybaAL
🤖 Бот для ключей: @BybaHub_bot

🔑 Если ключ закончился — перейди в бота и получи новый!

📌 Все функции работают стабильно.
📌 Автовин скорость: 400

💬 По всем вопросам писать в ТГ: @whygoldzy
]]

    -- ==========================================
    -- КНОПКА "О СКРИПТЕ" В ОСТАЛЬНЫХ ВКЛАДКАХ
    -- ==========================================
    local function AddAboutButton(parent)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0.95, 0, 0, 40)
        btn.Position = UDim2.new(0.025, 0, 0, 350)
        btn.BackgroundColor3 = Theme.Accent
        btn.BackgroundTransparency = 0.2
        btn.Text = "ℹ️ О скрипте"
        btn.TextColor3 = Theme.Text
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(function()
            SwitchTab("About")
        end)
        return btn
    end

    AddAboutButton(tabMain)
    AddAboutButton(tabFarming)
    AddAboutButton(tabVisuals)
    AddAboutButton(tabShop)
    AddAboutButton(tabTeleports)
    AddAboutButton(tabExploits)

    -- ==========================================
    -- ИКОНКА
    -- ==========================================
    local FloatBtn = Instance.new("TextButton", ScreenGui)
    FloatBtn.Size = UDim2.new(0, 50, 0, 50)
    FloatBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
    FloatBtn.BackgroundColor3 = Theme.Background
    FloatBtn.Font = Enum.Font.GothamBold
    FloatBtn.TextColor3 = Theme.AccentCyan
    FloatBtn.TextSize = 12
    FloatBtn.Text = "BY"
    FloatBtn.Visible = false
    FloatBtn.Active = true
    FloatBtn.Draggable = true
    Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)
    local fs = Instance.new("UIStroke", FloatBtn)
    fs.Color = Theme.AccentCyan
    fs.Thickness = 2

    local CloseBtn = Instance.new("TextButton", MainFrame)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextColor3 = Theme.Accent
    CloseBtn.TextSize = 14
    CloseBtn.Text = "✕"
    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        FloatBtn.Visible = true
    end)

    FloatBtn.MouseButton1Click:Connect(function()
        FloatBtn.Visible = false
        MainFrame.Visible = true
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.RightShift then
            if MainFrame.Visible then
                MainFrame.Visible = false
                FloatBtn.Visible = true
            else
                FloatBtn.Visible = false
                MainFrame.Visible = true
            end
        end
    end)

    local dragToggle, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and UserInputService:GetFocusedTextBox() == nil then
            dragToggle = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    MainFrame.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragToggle then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    print("✅ BYBA HUB v4.0 - ЗАГРУЖЕН!")
    print("📌 Создатель: Byba (@whygoldzy)")
    print("📌 Канал: @BybaAL")
    print("📌 Бот: @BybaHube_bot")
end
