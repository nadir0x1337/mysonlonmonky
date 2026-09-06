-- =========================================================
-- HEAVYFISH — USER ID WHITELIST GATE (LOADER)
-- Based on Cultifucksi Whitelist System
-- Created for: HeavyFish WindUI Edition (by nadir0x1337)
-- =========================================================

if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

do
    -- URL Pastebin / GitHub Raw yang berisi daftar Roblox User ID (1 ID per baris)
    local WHITELIST_URL = "https://pastebin.com/raw/TiL99Nbf"

    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local TeleportService = game:GetService("TeleportService")
    local TweenService = game:GetService("TweenService")

    local LP = Players.LocalPlayer
    local myId = tostring(LP.UserId)

    -- Parent GUI (aman untuk executor yang mendukung gethui / CoreGui)
    local function getGuiParent()
        local ok, parent = pcall(function()
            return gethui and gethui() or (CoreGui or LP:WaitForChild("PlayerGui"))
        end)
        return ok and parent or LP:WaitForChild("PlayerGui")
    end

    -- == Splash Loading Screen ==
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HeavyFishWhitelistGate"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = getGuiParent()

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(10, 8, 16)
    bg.BackgroundTransparency = 0.15
    bg.Parent = screenGui

    local card = Instance.new("Frame")
    card.Size = UDim2.fromOffset(400, 190)
    card.Position = UDim2.new(0.5, -200, 0.5, -95)
    card.BackgroundColor3 = Color3.fromRGB(18, 16, 26)
    card.BorderSizePixel = 0
    card.Parent = bg
    local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 14); cc.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromHex("#8A2BE2")
    stroke.Thickness = 1.8
    stroke.Parent = card

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, 0, 0, 40)
    titleLbl.Position = UDim2.new(0, 0, 0, 14)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "🎣  HeavyFish — ID Whitelist Check"
    titleLbl.TextColor3 = Color3.fromHex("#B388FF")
    titleLbl.TextSize = 16
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Parent = card

    local userLbl = Instance.new("TextLabel")
    userLbl.Size = UDim2.new(1, -40, 0, 22)
    userLbl.Position = UDim2.new(0, 20, 0, 58)
    userLbl.BackgroundTransparency = 1
    userLbl.Text = "Roblox ID: " .. myId .. "  |  @" .. LP.Name
    userLbl.TextColor3 = Color3.fromRGB(180, 180, 205)
    userLbl.TextSize = 13
    userLbl.Font = Enum.Font.Gotham
    userLbl.TextXAlignment = Enum.TextXAlignment.Left
    userLbl.Parent = card

    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size = UDim2.new(1, -40, 0, 26)
    statusLbl.Position = UDim2.new(0, 20, 0, 88)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = "⏳ Memeriksa ID whitelist..."
    statusLbl.TextColor3 = Color3.fromRGB(210, 210, 230)
    statusLbl.TextSize = 14
    statusLbl.Font = Enum.Font.GothamMedium
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left
    statusLbl.Parent = card

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -40, 0, 6)
    barBg.Position = UDim2.new(0, 20, 0, 134)
    barBg.BackgroundColor3 = Color3.fromRGB(32, 28, 46)
    barBg.BorderSizePixel = 0
    barBg.Parent = card
    local barBgCorner = Instance.new("UICorner"); barBgCorner.CornerRadius = UDim.new(1, 0); barBgCorner.Parent = barBg

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromHex("#8A2BE2")
    bar.BorderSizePixel = 0
    bar.Parent = barBg
    local barCorner = Instance.new("UICorner"); barCorner.CornerRadius = UDim.new(1, 0); barCorner.Parent = bar

    -- Animate loading bar
    task.spawn(function()
        local t = 0
        while t < 0.85 do
            t = t + 0.05
            bar.Size = UDim2.new(math.min(t, 0.85), 0, 1, 0)
            task.wait(0.04)
        end
    end)

    task.wait(0.6)

    -- Fetch whitelist dari server
    local ok, raw = pcall(function()
        return game:HttpGet(WHITELIST_URL)
    end)

    local isWhitelisted = false
    if ok and raw then
        for line in raw:gmatch("[^\r\n]+") do
            local trimmed = line:match("^%s*(.-)%s*$")
            if trimmed == myId then
                isWhitelisted = true
                break
            end
        end
    end

    if isWhitelisted then
        statusLbl.Text = "✅ Akses diberikan! ID: " .. myId
        statusLbl.TextColor3 = Color3.fromHex("#30FF6A")
        bar.BackgroundColor3 = Color3.fromHex("#30FF6A")
        stroke.Color = Color3.fromHex("#30FF6A")
        bar.Size = UDim2.new(1, 0, 1, 0)
        task.wait(1.0)
        screenGui:Destroy()
    else
        bar.BackgroundColor3 = Color3.fromHex("#FF3030")
        stroke.Color = Color3.fromHex("#FF3030")
        statusLbl.Text = "❌ ID " .. myId .. " tidak terdaftar. Keluar..."
        statusLbl.TextColor3 = Color3.fromHex("#FF3030")
        task.wait(2.0)
        pcall(function()
            TeleportService:Teleport(game.PlaceId, LP)
        end)
        return
    end
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/nadir0x1337/heavyfish/refs/heads/main/hv__.lua?token=GHSAT0AAAAAAEICW3PCWN5VBXNNQHAXYQJQ2U5R6FQ"))()
