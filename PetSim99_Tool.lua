local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Fungsi UI simpel ringan
local function createSimpleUI()
    -- Hapus UI lama kalau ada
    if PlayerGui:FindFirstChild("PetSim99SimpleUI") then
        PlayerGui.PetSim99SimpleUI:Destroy()
    end

    -- Bikin ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PetSim99SimpleUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    -- Frame utama
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 280, 0, 200)
    Frame.Position = UDim2.new(0.5, -140, 0.5, -100)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "Pet Simulator 99 Tools (Simple UI)"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 22
    Title.Parent = Frame

    -- Status Label
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -20, 0, 25)
    StatusLabel.Position = UDim2.new(0, 10, 0, 45)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Status: Idle"
    StatusLabel.TextColor3 = Color3.new(1, 1, 1)
    StatusLabel.Font = Enum.Font.SourceSans
    StatusLabel.TextSize = 16
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.Parent = Frame

    -- Contoh toggle sederhana (Auto Claim Paint)
    local AutoClaim = false
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 260, 0, 35)
    ToggleButton.Position = UDim2.new(0, 10, 0, 80)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleButton.TextColor3 = Color3.new(1, 1, 1)
    ToggleButton.Font = Enum.Font.SourceSansBold
    ToggleButton.TextSize = 18
    ToggleButton.Text = "Auto Claim Paint: OFF"
    ToggleButton.Parent = Frame

    ToggleButton.MouseButton1Click:Connect(function()
        AutoClaim = not AutoClaim
        if AutoClaim then
            ToggleButton.Text = "Auto Claim Paint: ON"
            StatusLabel.Text = "Status: Auto Claim Paint Enabled"
        else
            ToggleButton.Text = "Auto Claim Paint: OFF"
            StatusLabel.Text = "Status: Auto Claim Paint Disabled"
        end
    end)
end

-- Coba load OrionLib UI dulu
local success, OrionLib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
end)

-- Notifikasi berhasil load script
StarterGui:SetCore("SendNotification", {
    Title = "PetSim99 Script",
    Text = "Script berhasil dimuat! Membuka UI...",
    Duration = 4
})

wait(4)

if success and OrionLib then
    -- Pakai OrionLib UI
    local Window = OrionLib:MakeWindow({
        Name = "Pet Simulator 99 Tools",
        HidePremium = false,
        SaveConfig = true,
        ConfigFolder = "PetSim99Tools"
    })

    -- Paint Splotches Tab
    local PaintTab = Window:MakeTab({Name = "Paint Splotches", Icon = "rbxassetid://4483345998", PremiumOnly = false})
    PaintTab:AddToggle({
        Name = "Auto Claim Paint Splotches",
        Default = false,
        Callback = function(Value) getgenv().AutoClaimPaint = Value end
    })
    PaintTab:AddDropdown({
        Name = "Paint Color",
        Default = "Red Paint Splotche",
        Options = {"Red Paint Splotche", "Green Paint Splotche", "Blue Paint Splotche"},
        Callback = function(Value) getgenv().PaintColor = Value end
    })

    -- Mail Pencils Tab
    local PencilsTab = Window:MakeTab({Name = "Mail Pencils", Icon = "rbxassetid://4483345998", PremiumOnly = false})
    PencilsTab:AddToggle({
        Name = "Enable Auto Mail Pencils",
        Default = false,
        Callback = function(Value) getgenv().AutoMailPencils = Value end
    })
    PencilsTab:AddTextbox({
        Name = "Account Username",
        Default = "",
        TextDisappear = false,
        Callback = function(Value) getgenv().PencilUser = Value end
    })
    PencilsTab:AddDropdown({
        Name = "Select Pencils",
        Multi = true,
        Options = {"Golden Pencil", "Diamond Pencil", "Rainbow Pencil"},
        Callback = function(Value) getgenv().SelectedPencils = Value end
    })
    PencilsTab:AddSlider({
        Name = "Golden Pencil Amount",
        Min = 1,
        Max = 100,
        Default = 25,
        Callback = function(Value) getgenv().GoldenAmount = Value end
    })
    PencilsTab:AddSlider({
        Name = "Diamond Pencil Amount",
        Min = 1,
        Max = 50,
        Default = 10,
        Callback = function(Value) getgenv().DiamondAmount = Value end
    })
    PencilsTab:AddSlider({
        Name = "Rainbow Pencil Amount",
        Min = 1,
        Max = 25,
        Default = 5,
        Callback = function(Value) getgenv().RainbowAmount = Value end
    })

    -- Doodle Gifts Tab
    local GiftsTab = Window:MakeTab({Name = "Doodle Gifts", Icon = "rbxassetid://4483345998", PremiumOnly = false})
    GiftsTab:AddToggle({
        Name = "Enable Auto Mail Doodle Gifts",
        Default = false,
        Callback = function(Value) getgenv().AutoMailGifts = Value end
    })
    GiftsTab:AddTextbox({
        Name = "Account Username",
        Default = "",
        TextDisappear = false,
        Callback = function(Value) getgenv().GiftUser = Value end
    })
    GiftsTab:AddSlider({
        Name = "Gift Amount",
        Min = 1,
        Max = 25,
        Default = 5,
        Callback = function(Value) getgenv().GiftAmount = Value end
    })

    -- Miscellaneous Tab
    local MiscTab = Window:MakeTab({Name = "Misc Tools", Icon = "rbxassetid://4483345998", PremiumOnly = false})
    MiscTab:AddDropdown({
        Name = "Race Mode",
        Options = {"Mode 1", "Mode 2"},
        Default = "Mode 1",
        Callback = function(Value) getgenv().RaceMode = Value end
    })
    MiscTab:AddToggle({
        Name = "Auto Complete Time Trials",
        Default = false,
        Callback = function(Value) getgenv().AutoTimeTrials = Value end
    })
    MiscTab:AddSlider({
        Name = "Walk Speed",
        Min = 0,
        Max = 500,
        Default = 16,
        Callback = function(Value)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = Value
            end
        end
    })
    MiscTab:AddToggle({
        Name = "Enable NoClip",
        Default = false,
        Callback = function(Value)
            getgenv().NoClip = Value
            if Value then
                local RunService = game:GetService("RunService")
                getgenv().NoClipConnection = RunService.Stepped:Connect(function()
                    if getgenv().NoClip and LocalPlayer.Character then
                        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") and part.CanCollide then
                                part.CanCollide = false
                            end
                        end
                    elseif getgenv().NoClipConnection then
                        getgenv().NoClipConnection:Disconnect()
                        getgenv().NoClipConnection = nil
                    end
                end)
            elseif getgenv().NoClipConnection then
                getgenv().NoClipConnection:Disconnect()
                getgenv().NoClipConnection = nil
            end
        end
    })

    OrionLib:Init()
else
    -- Kalau gagal load OrionLib, pakai UI simpel
    createSimpleUI()
end
