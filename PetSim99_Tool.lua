
-- Pet Simulator 99 Simple Tool - OrionLib UI

-- Load UI Library
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- Create Main Window
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
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})
MiscTab:AddToggle({
    Name = "Enable NoClip",
    Default = false,
    Callback = function(Value)
        getgenv().NoClip = Value
        if Value then
            game:GetService("RunService").Stepped:Connect(function()
                if getgenv().NoClip and game.Players.LocalPlayer.Character then
                    for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
})

-- Finalize
OrionLib:Init()
