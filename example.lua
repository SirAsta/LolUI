--[[
    Lol Lib - Example / Usage
    Drop this in your exploit and run it to see the UI.
    Replace the URL with wherever you host "Lol Lib.lua".
]]

local Library = loadstring(game:HttpGet("https://your-cdn.com/Lol%20Lib.lua"))()

-- Optional: bring your own lucide icon pack (name -> rbxassetid)
-- Library:AddIcons("lucide", { sword = "rbxassetid://000000", ... })

local Window = Library:CreateWindow({
    Name = "Lol Lib <font color='rgb(255,0,0)'>v1.0</font>",
    Parent = game:GetService("CoreGui"),
    AutoShow = true,
    AutoSave = true,
})

-- Tabs (icons resolve "lucide:user" -> the built-in pack)
Window:CreateTab({ Name = "Player",     Icon = "lucide:user" })
Window:CreateTab({ Name = "Combat",     Icon = "lucide:swords" })
Window:CreateTab({ Name = "Visuals",    Icon = "lucide:eye" })
Window:CreateTab({ Name = "Settings",   Icon = "lucide:settings" })

-- Player tab
Window.Tabs.Player:CreateSection({ Name = "Movement" })

local Speed = Window.Tabs.Player:CreateSlider({
    Name = "Walk Speed",
    Flag = "PLAYER_SPEED",
    Range = { 0, 100 },
    Value = 16,
    Increment = 1,
    Callback = function(Value)
        print("Speed set to", Value)
    end,
})

local Fly = Window.Tabs.Player:CreateToggle({
    Name = "Fly",
    Flag = "PLAYER_FLY",
    Value = false,
    Callback = function(Value)
        print("Fly:", Value)
    end,
})

Window.Tabs.Player:CreateInput({
    Name = "Teleport To",
    Flag = "PLAYER_TP",
    Value = "Username",
    Numeric = false,
    Callback = function(Value)
        print("Teleport target:", Value)
    end,
})

Window.Tabs.Player:CreateDivider()

-- Combat tab
Window.Tabs.Combat:CreateSection({ Name = "Aimbot" })

Window.Tabs.Combat:CreateToggle({
    Name = "Silent Aim",
    Flag = "COMBAT_SILENT",
    Value = false,
    Callback = function(Value) print("Silent Aim:", Value) end,
})

Window.Tabs.Combat:CreateSlider({
    Name = "Aim FOV",
    Flag = "COMBAT_FOV",
    Range = { 0, 500 },
    Value = 120,
    Increment = 1,
    Callback = function(Value) print("FOV:", Value) end,
})

Window.Tabs.Combat:CreateDropdown({
    Name = "Target Part",
    Flag = "COMBAT_PART",
    Options = { "Head", "Torso", "Random" },
    Callback = function(Value)
        print("Part:", Value[1])
    end,
})

Window.Tabs.Combat:CreateButton({
    Name = "Kill All",
    Flag = "COMBAT_KILLALL",
    Callback = function()
        print("Kill all triggered")
    end,
})

-- Visuals tab (color picker + ESP)
Window.Tabs.Visuals:CreateSection({ Name = "ESP" })

Window.Tabs.Visuals:CreateToggle({
    Name = "Player ESP",
    Flag = "VIS_ESP",
    Value = false,
    Callback = function(Value) print("ESP:", Value) end,
})

Window.Tabs.Visuals:CreatePicker({
    Name = "ESP Color",
    Flag = "VIS_ESP_COLOR",
    Value = { Hue = 0, Saturation = 1, Brightness = 1 },
    Callback = function(Color)
        print("ESP color:", Color)
    end,
})

-- Settings tab (multi dropdown, labels, theme)
Window.Tabs.Settings:CreateSection({ Name = "Preferences" })

Window.Tabs.Settings:CreateDropdown({
    Name = "Toggles",
    Flag = "SET_MULTI",
    Options = { "Watermark", "FPS Counter", "Keybinds" },
    MultiSelect = true,
    Callback = function(Value)
        print("Enabled:", table.concat(Value, ", "))
    end,
})

Window.Tabs.Settings:CreateLabel({
    Name = "<font size='16'><b>Lol Lib</b></font>\nA standalone cheat UI library.",
})

Window.Tabs.Settings:CreateButton({
    Name = "Kill Script",
    Callback = function()
        Window:Flush()
    end,
})

-- Set a background image on a specific tab (like the Info tab in bh.txt)
Window.Tabs.Settings:SetTheme("rbxassetid://121134173616665", { ImageTransparency = 0.9 })

-- Programmatic control (mirrors how bh.txt drives elements)
task.wait(1)
Speed:Set(50)
Fly:Set(true)
Window.Tabs.Combat:CreateDropdown({
    Name = "Mode",
    Flag = "COMBAT_MODE",
    Options = { "Legit", "Rage" },
}):Select({ "Rage" })

Window:Load()
