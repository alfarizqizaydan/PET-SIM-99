local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Settings default
local settings = {
    AutoBuyFarmEggToggle = false,
    AutoPlaceFarmEggToggle = false,
    AutoHarvestFarmEggToggle = false,
    AutoBuyFarmSupplyToggle = false,
    AutoFeedFarmPetsToggle = false,
    AutoSellFarmPetsToggle = false,
    AutoCraftPetsToggle = false,
    AutoClaimFarmStorageToggle = false,
    AutoCompleteFarmingQuestToggle = false,
    AutoClaimFarmingQuestsRewardToggle = false,
    AutoBuyFarmPetsSlotToggle = false,
    AutoBuyFarmStorageSlotToggle = false,
    AutoSellFarmPetsMinimumAgeSlider = 25,
    AutoSellFarmPetsMaximumAgeSlider = 50,
    -- contoh multi dropdown isi (harus kamu isi manual sendiri sesuai opsi)
    AutoBuyFarmEggTableMultiDropdown = {},
}

-- Fungsi buat toggle UI
local function addToggle(parent, name, default, callback, yPos)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Text = name
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 10, 0, yPos)
    lbl.Size = UDim2.new(0, 250, 0, 25)
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 18

    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 70, 0, 25)
    btn.Position = UDim2.new(0, 260, 0, yPos)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    btn.Text = default and "ON" or "OFF"

    btn.MouseButton1Click:Connect(function()
        local newVal = not (btn.Text == "ON")
        btn.Text = newVal and "ON" or "OFF"
        btn.BackgroundColor3 = newVal and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        callback(newVal)
    end)
end

-- Fungsi buat slider UI (integer)
local function addSlider(parent, name, min, max, default, callback, yPos)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Text = name .. " (" .. default .. ")"
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 10, 0, yPos)
    lbl.Size = UDim2.new(0, 320, 0, 20)
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 16

    local slider = Instance.new("TextButton", parent)
    slider.Text = ""
    slider.BackgroundColor3 = Color3.fromRGB(50,50,50)
    slider.Position = UDim2.new(0, 10, 0, yPos + 25)
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
            lbl.Text = name .. " (" .. val .. ")"
            callback(val)
        end
    end)
end

-- Fungsi buat multi-select dropdown sederhana (klik cycle)
local function addMultiDropdown(parent, name, options, defaultTable, callback, yPos)
    local lbl = Instance.new("TextLabel", parent)
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 10, 0, yPos)
    lbl.Size = UDim2.new(0, 320, 0, 40)
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 16

    local function updateText()
        if #defaultTable == 0 then
            lbl.Text = name .. ": (none)"
        else
            lbl.Text = name .. ": " .. table.concat(defaultTable, ", ")
        end
    end
    updateText()

    lbl.MouseButton1Click = nil
    lbl.Active = true
    lbl.Selectable = true
    lbl.AutoButtonColor = true

    lbl.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- cycle options: add or remove first option for demo
            local opt = options[1]
            local found = false
            for i,v in ipairs(defaultTable) do
                if v == opt then
                    table.remove(defaultTable, i)
                    found = true
                    break
                end
            end
            if not found then
                table.insert(defaultTable, opt)
            end
            updateText()
            callback(defaultTable)
        end
    end)
end

-- Buat UI Frame
if PlayerGui:FindFirstChild("PetSimFarmUI") then
    PlayerGui.PetSimFarmUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PetSimFarmUI"
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 350, 0, 600)
Frame.Position = UDim2.new(0.5, -175, 0.5, -300)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Pet Simulator 99 Farm Tools"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 24
Title.Parent = Frame

local yPos = 50

-- Toggle examples
addToggle(Frame, "Auto Buy Farm Egg", settings.AutoBuyFarmEggToggle, function(val)
    settings.AutoBuyFarmEggToggle = val
    print("AutoBuyFarmEggToggle =", val)
end, yPos); yPos = yPos + 40

addToggle(Frame, "Auto Place Farm Egg", settings.AutoPlaceFarmEggToggle, function(val)
    settings.AutoPlaceFarmEggToggle = val
    print("AutoPlaceFarmEggToggle =", val)
end, yPos); yPos = yPos + 40

addToggle(Frame, "Auto Harvest Farm Egg", settings.AutoHarvestFarmEggToggle, function(val)
    settings.AutoHarvestFarmEggToggle = val
    print("AutoHarvestFarmEggToggle =", val)
end, yPos); yPos = yPos + 40

addToggle(Frame, "Auto Buy Farm Supply", settings.AutoBuyFarmSupplyToggle, function(val)
    settings.AutoBuyFarmSupplyToggle = val
    print("AutoBuyFarmSupplyToggle =", val)
end, yPos); yPos = yPos + 40

addToggle(Frame, "Auto Feed Farm Pets", settings.AutoFeedFarmPetsToggle, function(val)
    settings.AutoFeedFarmPetsToggle = val
    print("AutoFeedFarmPetsToggle =", val)
end, yPos); yPos = yPos + 40

addToggle(Frame, "Auto Sell Farm Pets", settings.AutoSellFarmPetsToggle, function(val)
    settings.AutoSellFarmPetsToggle = val
    print("AutoSellFarmPetsToggle =", val)
end, yPos); yPos = yPos + 40

addToggle(Frame, "Auto Craft Pets", settings.AutoCraftPetsToggle, function(val)
    settings.AutoCraftPetsToggle = val
    print("AutoCraftPetsToggle =", val)
end, yPos); yPos = yPos + 40

-- Slider example
addSlider(Frame, "Auto Sell Pets Min Age", 0, 100, settings.AutoSellFarmPetsMinimumAgeSlider, function(val)
    settings.AutoSellFarmPetsMinimumAgeSlider = val
    print("AutoSellFarmPetsMinimumAgeSlider =", val)
end, yPos); yPos = yPos + 60

addSlider(Frame, "Auto Sell Pets Max Age", 0, 100, settings.AutoSellFarmPetsMaximumAgeSlider, function(val)
    settings.AutoSellFarmPetsMaximumAgeSlider = val
    print("AutoSellFarmPetsMaximumAgeSlider =", val)
end, yPos); yPos = yPos + 60

-- MultiDropdown example (sederhana, hanya cycle opsi pertama)
addMultiDropdown(Frame, "Auto Buy Farm Eggs", {"Pixel Chick Egg", "Pixel Cat Egg", "Pixel Piggy Egg"}, settings.AutoBuyFarmEggTableMultiDropdown, function(tbl)
    settings.AutoBuyFarmEggTableMultiDropdown = tbl
    print("AutoBuyFarmEggTableMultiDropdown =", table.concat(tbl, ", "))
end, yPos); yPos = yPos + 50

-- Kamu bisa tambahkan toggle lain sama cara seperti di atas

print("UI siap dan berjalan.")
