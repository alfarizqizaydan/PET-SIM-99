-- Pet Simulator 99 Simple Tool (Single File)

local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Notifikasi loading script
StarterGui:SetCore("SendNotification", {
    Title = "PetSim99 Script",
    Text = "Memulai load script...",
    Duration = 3
})
wait(3)

StarterGui:SetCore("SendNotification", {
    Title = "PetSim99 Script",
    Text = "Script berhasil dimuat! Membuka UI...",
    Duration = 3
})
wait(2)

-- Simpan state opsi UI
local settings = {
    AutoMailRainbowPencilsAmountSlider = 5, -- 1-25
    AutoMailPencilsToggle = false,
    AutoMailDoodleGiftsAccountUsernameInput = "",
    AutoMailDoodleGiftsAmountSlider = 5, -- 1-25
    AutoMailDoodleGiftsToggle = false,
    AutoCompleteTimeTrialsRaceModeDropdown = "Mode 1", -- "Mode 1", "Mode 2"
    AutoCompleteTimeTrialsRaceToggle = false,
    WalkSpeedSlider = 16, -- 0-500
    WalkSpeedEnablerToggle = false,
    NoClipToggle = false,
    ServerHopTypeDropdown = "Random" -- "Random", "Best Ping", "Most Players", "Least Players"
}

-- Fungsi buat UI simpel
local function createUI()
    if PlayerGui:FindFirstChild("PetSim99SimpleUI") then
        PlayerGui.PetSim99SimpleUI:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PetSim99SimpleUI"
    ScreenGui.Parent = PlayerGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 350, 0, 400)
    Frame.Position = UDim2.new(0.5, -175, 0.5, -200)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "Pet Simulator 99 Tools"
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 24
    Title.Parent = Frame

    local yPos = 50

    -- Toggle helper function
    local function addToggle(name, default, callback)
        local lbl = Instance.new("TextLabel", Frame)
        lbl.Text = name
        lbl.TextColor3 = Color3.new(1,1,1)
        lbl.BackgroundTransparency = 1
        lbl.Position = UDim2.new(0, 10, 0, yPos)
        lbl.Size = UDim2.new(0, 220, 0, 25)
        lbl.Font = Enum.Font.SourceSans
        lbl.TextSize = 18

        local btn = Instance.new("TextButton", Frame)
        btn.Size = UDim2.new(0, 80, 0, 25)
        btn.Position = UDim2.new(0, 240, 0, yPos)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 18
        btn.TextColor3 = Color3.new(1,1,1)
        btn.BackgroundColor3 = default and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        btn.Text = default and "ON" or "OFF"

        btn.MouseButton1Click:Connect(function()
            local newVal = not (btn.Text == "ON")
            btn.Text = newVal and "ON" or "OFF"
            btn.BackgroundColor3 = newVal and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
            callback(newVal)
        end)
        yPos = yPos + 40
    end

    -- Slider helper function
    local function addSlider(name, min, max, default, callback)
        local lbl = Instance.new("TextLabel", Frame)
        lbl.Text = name.." ("..default..")"
        lbl.TextColor3 = Color3.new(1,1,1)
        lbl.BackgroundTransparency = 1
        lbl.Position = UDim2.new(0, 10, 0, yPos)
        lbl.Size = UDim2.new(0, 320, 0, 20)
        lbl.Font = Enum.Font.SourceSans
        lbl.TextSize = 16

        local slider = Instance.new("TextButton", Frame)
        slider.Text = ""
        slider.BackgroundColor3 = Color3.fromRGB(50,50,50)
        slider.Position = UDim2.new(0, 10, 0, yPos+25)
        slider.Size = UDim2.new(0, 320, 0, 20)

        local fill = Instance.new("Frame", slider)
        fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)

        local dragging = false
        slider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        slider.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        slider.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local x = math.clamp(input.Position.X - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X)
                local ratio = x / slider.AbsoluteSize.X
                local val = math.floor(min + (max - min) * ratio + 0.5)
                fill.Size = UDim2.new(ratio, 0, 1, 0)
                lbl.Text = name.." ("..val..")"
                callback(val)
            end
        end)

        yPos = yPos + 60
    end

    -- Dropdown helper function
    local function addDropdown(name, options, default, callback)
        local lbl = Instance.new("TextLabel", Frame)
        lbl.Text = name..": "..default
        lbl.TextColor3 = Color3.new(1,1,1)
        lbl.BackgroundTransparency = 1
        lbl.Position = UDim2.new(0, 10, 0, yPos)
        lbl.Size = UDim2.new(0, 320, 0, 25)
        lbl.Font = Enum.Font.SourceSans
        lbl.TextSize = 18

        local btn = Instance.new("TextButton", Frame)
        btn.Text = "Change"
        btn.Position = UDim2.new(0, 240, 0, yPos)
        btn.Size = UDim2.new(0, 80, 0, 25)
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 18

        btn.MouseButton1Click:Connect(function()
            local currentIndex = table.find(options, default) or 1
            local newIndex = currentIndex + 1
            if newIndex > #options then newIndex = 1 end
            default = options[newIndex]
            lbl.Text = name..": "..default
            callback(default)
        end)

        yPos = yPos + 40
    end

    -- Buat UI elemen sesuai setting dan contoh
    addToggle("Auto Mail Pencils", settings.AutoMailPencilsToggle, function(val)
        settings.AutoMailPencilsToggle = val
        -- contoh logika aktifasi
        print("Auto Mail Pencils set to", val)
    end)

    addSlider("Auto Mail Rainbow Pencils Amount", 1, 25, settings.AutoMailRainbowPencilsAmountSlider, function(val)
        settings.AutoMailRainbowPencilsAmountSlider = val
        print("Rainbow Pencils Amount set to", val)
    end)

    addToggle("Auto Mail Doodle Gifts", settings.AutoMailDoodleGiftsToggle, function(val)
        settings.AutoMailDoodleGiftsToggle = val
        print("Auto Mail Doodle Gifts set to", val)
    end)

    addSlider("Auto Mail Doodle Gifts Amount", 1, 25, settings.AutoMailDoodleGiftsAmountSlider, function(val)
        settings.AutoMailDoodleGiftsAmountSlider = val
        print("Doodle Gifts Amount set to", val)
    end)

    addDropdown("Race Mode", {"Mode 1", "Mode 2"}, settings.AutoCompleteTimeTrialsRaceModeDropdown, function(val)
        settings.AutoCompleteTimeTrialsRaceModeDropdown = val
        print("Race Mode set to", val)
    end)

    addToggle("Auto Complete Time Trials", settings.AutoCompleteTimeTrialsRaceToggle, function(val)
        settings.AutoCompleteTimeTrialsRaceToggle = val
        print("Auto Complete Time Trials set to", val)
    end)

    addToggle("Walk Speed Enable", settings.WalkSpeedEnablerToggle, function(val)
        settings.WalkSpeedEnablerToggle = val
        if val then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = settings.WalkSpeedSlider
        else
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
        print("Walk Speed Enable set to", val)
    end)

    addSlider("Walk Speed", 0, 500, settings.WalkSpeedSlider, function(val)
        settings.WalkSpeedSlider = val
        if settings.WalkSpeedEnablerToggle then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
        end
        print("Walk Speed set to", val)
    end)

    addToggle("NoClip", settings.NoClipToggle, function(val)
        settings.NoClipToggle = val
        print("NoClip set to", val)
        if val then
            -- Simple noclip loop
            spawn(function()
                while settings.NoClipToggle do
                    wait(0.1)
                    local char = game.Players.LocalPlayer.Character
                    if char then
                        for _, part in pairs(char:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end)
        else
            local char = game.Players.LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end)

    addDropdown("Server Hop Type", {"Random", "Best Ping", "Most Players", "Least Players"}, settings.ServerHopTypeDropdown, function(val)
        settings.ServerHopTypeDropdown = val
        print("Server Hop Type set to", val)
    end)

end

createUI()

