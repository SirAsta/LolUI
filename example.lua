local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SirAsta/LolUI/main/Lol%20Lib.lua"))()

local Window = Library:CreateWindow({
    Name = "Lol Lib <font color='rgb(255,0,0)'>v1.0</font>",
    Parent = game:GetService("CoreGui"),
    AutoShow = true,
    AutoSave = true,
    User = {
        Enabled = true,
        Name = game:GetService("Players").LocalPlayer.Name,
        Subtitle = "Lol Lib",
    },
    OpenButton = {
        Title = "Open Lol Lib",
        Enabled = true,
    },
})

Window:CreateTab({ Name = "Player",   Icon = "lucide:user" })
Window:CreateTab({ Name = "Combat",   Icon = "lucide:swords" })
Window:CreateTab({ Name = "Visuals",  Icon = "lucide:eye" })
Window:CreateTab({ Name = "Config",   Icon = "lucide:settings" })
Window:CreateTab({ Name = "Info",     Icon = "lucide:info" })

-- Player

Window.Tabs.Player:CreateSection({ Name = "Movement" })

local Speed = Window.Tabs.Player:CreateSlider({
    Name = "Walk Speed", Flag = "SPEED", Range = {0, 100}, Value = 16, Increment = 1,
    Callback = function(v) print("Speed:", v) end,
})

local Fly = Window.Tabs.Player:CreateToggle({
    Name = "Fly", Flag = "FLY", Value = false,
    Callback = function(v) print("Fly:", v) end,
})

Window.Tabs.Player:CreateInput({
    Name = "Teleport To", Flag = "TP", Value = "Username", Numeric = false,
    Callback = function(v) print("TP:", v) end,
})

Window.Tabs.Player:CreateButton({
    Name = "Pitch TP",
    Callback = function()
        Library:Notify({ Title = "Teleported", Content = "Teleported to pitch center", Duration = 3 })
    end,
})

-- Combat

Window.Tabs.Combat:CreateSection({ Name = "Aimbot" })

Window.Tabs.Combat:CreateToggle({
    Name = "Silent Aim", Flag = "SILENT", Value = false,
    Callback = function(v) print("Silent:", v) end,
})

Window.Tabs.Combat:CreateSlider({
    Name = "Aim FOV", Flag = "FOV", Range = {0, 500}, Value = 120, Increment = 1,
    Callback = function(v) print("FOV:", v) end,
})

Window.Tabs.Combat:CreateDropdown({
    Name = "Target Part", Flag = "PART",
    Options = { "Head", "Torso", "Random" },
    Callback = function(v) print("Part:", v[1]) end,
})

Window.Tabs.Combat:CreateDropdown({
    Name = "Mode", Flag = "MODE",
    Options = { "Legit", "Rage" },
}):Select({ "Rage" })

-- Visuals

Window.Tabs.Visuals:CreateSection({ Name = "ESP" })

Window.Tabs.Visuals:CreateToggle({
    Name = "Player ESP", Flag = "ESP", Value = false,
    Callback = function(v) print("ESP:", v) end,
})

Window.Tabs.Visuals:CreatePicker({
    Name = "ESP Color", Flag = "ESP_COLOR",
    Value = { Hue = 0, Saturation = 1, Brightness = 1 },
    Callback = function(c) print("Color:", c) end,
})

-- Config

Window.Tabs.Config:CreateSection({ Name = "Preferences" })

Window.Tabs.Config:CreateDropdown({
    Name = "UI Theme", Flag = "THEME",
    Options = { "Dark", "Light", "AMOLED", "Rose", "Violet", "Emerald", "Midnight", "Crimson", "Monokai" },
    Callback = function(v)
        Library:SetTheme(v[1])
    end,
}):Select({ "Dark" })

Window.Tabs.Config:CreateDropdown({
    Name = "Toggles", Flag = "TOGGLES",
    Options = { "Watermark", "FPS Counter", "Keybinds" },
    MultiSelect = true,
    Callback = function(v) print("Enabled:", table.concat(v, ", ")) end,
})

Window.Tabs.Config:CreateButton({
    Name = "Test Notification",
    Callback = function()
        Window:Notify({ Title = "Test", Content = "This is a notification", Duration = 4, Icon = "lucide:info" })
    end,
})

Window.Tabs.Config:CreateButton({
    Name = "Kill Script",
    Callback = function()
        Window:Flush()
    end,
})

-- Info

Window.Tabs.Info:CreateSection({ Name = "About" })

Window.Tabs.Info:CreateLabel({
    Name = "<font size='16'><b>Lol Lib</b></font>\nA standalone cheat UI library.\ngithub.com/SirAsta/LolUI",
})

Window:Load()
