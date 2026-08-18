local cloneref = (cloneref or clonereference or function(i) return i end)

local CoreGui           = cloneref(game:GetService("CoreGui"))
local Players           = cloneref(game:GetService("Players"))
local UserInputService  = cloneref(game:GetService("UserInputService"))
local TweenService      = cloneref(game:GetService("TweenService"))
local RunService        = cloneref(game:GetService("RunService"))
local HttpService       = cloneref(game:GetService("HttpService"))

local LocalPlayer = Players.LocalPlayer

local function New(Class, Props, Children)
    local Obj = Instance.new(Class)
    if Props then
        for Key, Value in pairs(Props) do
            Obj[Key] = Value
        end
    end
    if Children then
        for _, Child in ipairs(Children) do
            Child.Parent = Obj
        end
    end
    return Obj
end

local function Tween(Obj, Props, Time)
    local Ok, T = pcall(function()
        return TweenService:Create(Obj, TweenInfo.new(Time or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), Props)
    end)
    if Ok and T then
        T:Play()
    else
        for Key, Value in pairs(Props) do
            pcall(function() Obj[Key] = Value end)
        end
    end
end

local function Round(Num, Increment)
    Increment = Increment or 1
    return math.floor(Num / Increment + 0.5) * Increment
end

local function Clamp(Num, Min, Max)
    return math.max(Min, math.min(Max, Num))
end

local C = {
    BG          = Color3.fromRGB(18, 18, 20),
    Sidebar     = Color3.fromRGB(22, 22, 25),
    TopBar      = Color3.fromRGB(28, 28, 32),
    Element     = Color3.fromRGB(31, 31, 35),
    ElementHover= Color3.fromRGB(40, 40, 46),
    Text        = Color3.fromRGB(236, 236, 236),
    SubText     = Color3.fromRGB(150, 150, 156),
    Accent      = Color3.fromRGB(224, 52, 72),
    AccentDim   = Color3.fromRGB(120, 32, 44),
    Divider     = Color3.fromRGB(46, 46, 52),
    Track       = Color3.fromRGB(58, 58, 64),
}

local FONT = Enum.Font.Gotham

local ConfigFolder = "lolui/config"
local ConfigFile   = ConfigFolder .. "/ui.json"

local function LoadConfigData()
    if not (isfolder and isfile and readfile) then return {} end
    local Ok, Data = pcall(function()
        if isfile(ConfigFile) then
            return HttpService:JSONDecode(readfile(ConfigFile))
        end
        return {}
    end)
    return (Ok and type(Data) == "table") and Data or {}
end

local function SaveConfigData(Data)
    if not (writefile and isfolder and makefolder) then return end
    pcall(function()
        if not isfolder(ConfigFolder) then
            makefolder(ConfigFolder)
        end
        writefile(ConfigFile, HttpService:JSONEncode(Data))
    end)
end

local Icons = { Packs = {} }

function Icons.AddIcons(Pack, Map)
    Icons.Packs[Pack] = Map
end

function Icons.Resolve(Icon)
    if type(Icon) ~= "string" or Icon == "" then
        return ""
    end
    local Pack, Name = Icon:match("^(.-):(.+)$")
    if Pack and Icons.Packs[Pack] then
        return Icons.Packs[Pack][Name] or Icon
    end
    return Icon
end

Icons.AddIcons("lucide", {
    ["user"] = "rbxassetid://11295273292",
    ["gamepad-2"] = "rbxassetid://11326876816",
    ["mouse-pointer-2"] = "rbxassetid://11432847583",
    ["skull"] = "rbxassetid://12967641870",
    ["users"] = "rbxassetid://11432832657",
    ["code"] = "rbxassetid://11419714821",
    ["settings"] = "rbxassetid://11432859220",
    ["search"] = "rbxassetid://11293977875",
    ["swords"] = "rbxassetid://12967641870",
    ["shield"] = "rbxassetid://11295273292",
    ["crosshair"] = "rbxassetid://11326876816",
    ["target"] = "rbxassetid://11432832657",
    ["zap"] = "rbxassetid://11419714821",
    ["eye"] = "rbxassetid://11432847583",
    ["box"] = "rbxassetid://14187686429",
    ["door-open"] = "rbxassetid://11293981586",
    ["help-circle"] = "rbxassetid://11432859220",
    ["info"] = "rbxassetid://11432859220",
    ["trash"] = "rbxassetid://11293981586",
    ["chevron-down"] = "rbxassetid://11293981980",
    ["check"] = "rbxassetid://11293980042",
    ["x"] = "rbxassetid://11293981586",
    ["plus"] = "rbxassetid://11293980310",
    ["refresh"] = "rbxassetid://11293978098",
})

local Themes = {
    Dark = {
        Name = "Dark",
        BG = Color3.fromRGB(18, 18, 20),
        Sidebar = Color3.fromRGB(22, 22, 25),
        TopBar = Color3.fromRGB(28, 28, 32),
        Element = Color3.fromRGB(31, 31, 35),
        ElementHover = Color3.fromRGB(40, 40, 46),
        Text = Color3.fromRGB(236, 236, 236),
        SubText = Color3.fromRGB(150, 150, 156),
        Accent = Color3.fromRGB(224, 52, 72),
        AccentDim = Color3.fromRGB(120, 32, 44),
        Divider = Color3.fromRGB(46, 46, 52),
        Track = Color3.fromRGB(58, 58, 64),
        Toggle = Color3.fromRGB(51, 199, 89),
        Slider = Color3.fromRGB(0, 145, 255),
    },
    Light = {
        Name = "Light",
        BG = Color3.fromRGB(245, 245, 245),
        Sidebar = Color3.fromRGB(255, 255, 255),
        TopBar = Color3.fromRGB(250, 250, 250),
        Element = Color3.fromRGB(240, 240, 240),
        ElementHover = Color3.fromRGB(230, 230, 230),
        Text = Color3.fromRGB(20, 20, 20),
        SubText = Color3.fromRGB(100, 100, 100),
        Accent = Color3.fromRGB(0, 120, 215),
        AccentDim = Color3.fromRGB(0, 80, 160),
        Divider = Color3.fromRGB(220, 220, 220),
        Track = Color3.fromRGB(200, 200, 200),
        Toggle = Color3.fromRGB(52, 168, 83),
        Slider = Color3.fromRGB(0, 120, 215),
    },
    AMOLED = {
        Name = "AMOLED",
        BG = Color3.fromRGB(0, 0, 0),
        Sidebar = Color3.fromRGB(10, 10, 10),
        TopBar = Color3.fromRGB(15, 15, 15),
        Element = Color3.fromRGB(18, 18, 18),
        ElementHover = Color3.fromRGB(30, 30, 30),
        Text = Color3.fromRGB(240, 240, 240),
        SubText = Color3.fromRGB(120, 120, 120),
        Accent = Color3.fromRGB(0, 180, 255),
        AccentDim = Color3.fromRGB(0, 100, 180),
        Divider = Color3.fromRGB(35, 35, 35),
        Track = Color3.fromRGB(45, 45, 45),
        Toggle = Color3.fromRGB(0, 200, 80),
        Slider = Color3.fromRGB(0, 180, 255),
    },
    Rose = {
        Name = "Rose",
        BG = Color3.fromRGB(31, 3, 8),
        Sidebar = Color3.fromRGB(40, 10, 15),
        TopBar = Color3.fromRGB(50, 12, 20),
        Element = Color3.fromRGB(56, 30, 35),
        ElementHover = Color3.fromRGB(70, 35, 42),
        Text = Color3.fromRGB(253, 242, 248),
        SubText = Color3.fromRGB(214, 122, 166),
        Accent = Color3.fromRGB(190, 24, 93),
        AccentDim = Color3.fromRGB(130, 16, 62),
        Divider = Color3.fromRGB(80, 30, 45),
        Track = Color3.fromRGB(100, 40, 55),
        Toggle = Color3.fromRGB(233, 95, 116),
        Slider = Color3.fromRGB(190, 24, 93),
    },
    Violet = {
        Name = "Violet",
        BG = Color3.fromRGB(30, 10, 62),
        Sidebar = Color3.fromRGB(38, 15, 72),
        TopBar = Color3.fromRGB(45, 18, 85),
        Element = Color3.fromRGB(52, 38, 80),
        ElementHover = Color3.fromRGB(65, 48, 95),
        Text = Color3.fromRGB(250, 245, 255),
        SubText = Color3.fromRGB(143, 126, 224),
        Accent = Color3.fromRGB(109, 40, 217),
        AccentDim = Color3.fromRGB(76, 28, 160),
        Divider = Color3.fromRGB(70, 50, 100),
        Track = Color3.fromRGB(85, 60, 120),
        Toggle = Color3.fromRGB(124, 58, 237),
        Slider = Color3.fromRGB(109, 40, 217),
    },
    Emerald = {
        Name = "Emerald",
        BG = Color3.fromRGB(1, 20, 17),
        Sidebar = Color3.fromRGB(5, 30, 25),
        TopBar = Color3.fromRGB(8, 38, 30),
        Element = Color3.fromRGB(32, 46, 42),
        ElementHover = Color3.fromRGB(42, 60, 55),
        Text = Color3.fromRGB(236, 253, 245),
        SubText = Color3.fromRGB(63, 191, 143),
        Accent = Color3.fromRGB(5, 150, 105),
        AccentDim = Color3.fromRGB(4, 100, 72),
        Divider = Color3.fromRGB(40, 65, 55),
        Track = Color3.fromRGB(50, 75, 65),
        Toggle = Color3.fromRGB(16, 185, 129),
        Slider = Color3.fromRGB(5, 150, 105),
    },
    Midnight = {
        Name = "Midnight",
        BG = Color3.fromRGB(10, 15, 30),
        Sidebar = Color3.fromRGB(15, 20, 38),
        TopBar = Color3.fromRGB(18, 25, 45),
        Element = Color3.fromRGB(36, 40, 54),
        ElementHover = Color3.fromRGB(45, 50, 65),
        Text = Color3.fromRGB(219, 234, 254),
        SubText = Color3.fromRGB(47, 116, 209),
        Accent = Color3.fromRGB(30, 58, 138),
        AccentDim = Color3.fromRGB(20, 40, 100),
        Divider = Color3.fromRGB(40, 48, 68),
        Track = Color3.fromRGB(50, 58, 78),
        Toggle = Color3.fromRGB(37, 99, 235),
        Slider = Color3.fromRGB(37, 99, 235),
    },
    Crimson = {
        Name = "Crimson",
        BG = Color3.fromRGB(12, 4, 4),
        Sidebar = Color3.fromRGB(20, 8, 8),
        TopBar = Color3.fromRGB(28, 10, 10),
        Element = Color3.fromRGB(37, 31, 31),
        ElementHover = Color3.fromRGB(50, 40, 40),
        Text = Color3.fromRGB(254, 242, 242),
        SubText = Color3.fromRGB(111, 117, 123),
        Accent = Color3.fromRGB(185, 28, 28),
        AccentDim = Color3.fromRGB(120, 18, 18),
        Divider = Color3.fromRGB(55, 40, 40),
        Track = Color3.fromRGB(70, 50, 50),
        Toggle = Color3.fromRGB(220, 38, 38),
        Slider = Color3.fromRGB(185, 28, 28),
    },
    Monokai = {
        Name = "Monokai",
        BG = Color3.fromRGB(25, 22, 34),
        Sidebar = Color3.fromRGB(32, 28, 42),
        TopBar = Color3.fromRGB(38, 34, 48),
        Element = Color3.fromRGB(50, 48, 57),
        ElementHover = Color3.fromRGB(62, 60, 68),
        Text = Color3.fromRGB(252, 252, 250),
        SubText = Color3.fromRGB(175, 175, 175),
        Accent = Color3.fromRGB(252, 152, 103),
        AccentDim = Color3.fromRGB(180, 100, 60),
        Divider = Color3.fromRGB(65, 60, 72),
        Track = Color3.fromRGB(78, 72, 85),
        Toggle = Color3.fromRGB(169, 220, 118),
        Slider = Color3.fromRGB(252, 152, 103),
    },
}

local function ApplyTheme(ThemeName)
    local T = Themes[ThemeName]
    if not T then return end
    C.BG = T.BG
    C.Sidebar = T.Sidebar
    C.TopBar = T.TopBar
    C.Element = T.Element
    C.ElementHover = T.ElementHover
    C.Text = T.Text
    C.SubText = T.SubText
    C.Accent = T.Accent
    C.AccentDim = T.AccentDim
    C.Divider = T.Divider
    C.Track = T.Track
end

local function GradientStops(Stops, Rotation)
    local ColorKPs = {}
    local TransKPs = {}
    for Pos, Stop in pairs(Stops) do
        local P = math.clamp(tonumber(Pos) / 100, 0, 1)
        table.insert(ColorKPs, ColorSequenceKeypoint.new(P, Stop.Color))
        table.insert(TransKPs, NumberSequenceKeypoint.new(P, Stop.Transparency or 0))
    end
    table.sort(ColorKPs, function(a, b) return a.Time < b.Time end)
    table.sort(TransKPs, function(a, b) return a.Time < b.Time end)
    if #ColorKPs < 2 then
        table.insert(ColorKPs, ColorSequenceKeypoint.new(1, ColorKPs[1].Value))
        table.insert(TransKPs, NumberSequenceKeypoint.new(1, TransKPs[1].Value))
    end
    return {
        Color = ColorSequence.new(ColorKPs),
        Transparency = NumberSequence.new(TransKPs),
        Rotation = Rotation or 0,
    }
end

local Library = {}
Library.Elements = {}
Library.Icons = Icons
Library.Themes = Themes
Library.CurrentTheme = "Dark"

Library.SetTheme = function(_, ThemeName)
    if Themes[ThemeName] then
        Library.CurrentTheme = ThemeName
        ApplyTheme(ThemeName)
    end
end

Library.Gradient = function(_, Stops, Rotation)
    return GradientStops(Stops, Rotation)
end

local NotifGui, NotifHolder, NotifCount = nil, nil, 0

local function EnsureNotifGui(Parent)
    if NotifGui then return end
    NotifGui = New("ScreenGui", {
        Name = "LolLib/Notifications",
        Parent = Parent,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 10000,
    })
    NotifHolder = New("Frame", {
        Name = "Holder",
        Parent = NotifGui,
        Size = UDim2.new(0, 320, 1, -60),
        Position = UDim2.new(1, -16, 0, 56),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
    }, {
        New("UIListLayout", {
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            Padding = UDim.new(0, 8),
        }),
        New("UIPadding", { PaddingTop = UDim.new(0, 4) }),
    })
end

Library.Notify = function(_, Config)
    Config = Config or {}
    EnsureNotifGui(Config.Parent or CoreGui)
    NotifCount = NotifCount + 1

    local Title = Config.Title or "Notification"
    local Content = Config.Content or ""
    local Duration = Config.Duration or 5
    local Icon = Config.Icon or ""

    local Container = New("Frame", {
        Name = "NotifContainer",
        Parent = NotifHolder,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = NotifCount,
    })

    local Main = New("Frame", {
        Name = "Main",
        Parent = Container,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(1.5, 0, 0, 0),
        BackgroundColor3 = C.TopBar,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
    }, {
        New("UICorner", { CornerRadius = UDim.new(0, 8) }),
        New("UIStroke", { Color = C.AccentDim, Thickness = 1, Transparency = 0.5 }),
        New("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
        }),
        New("UIListLayout", {
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),
    })

    local TitleLabel = New("TextLabel", {
        Name = "Title",
        Parent = Main,
        Size = UDim2.new(1, Icon ~= "" and -30 or 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Font = FONT,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = C.Text,
        Text = Title,
        RichText = true,
        LayoutOrder = 1,
    })

    if Icon ~= "" then
        New("ImageLabel", {
            Name = "Icon",
            Parent = Main,
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(1, -20, 0, 10),
            AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            Image = Icons.Resolve(Icon) or Icon,
            LayoutOrder = 0,
        })
    end

    if Content ~= "" then
        New("TextLabel", {
            Name = "Content",
            Parent = Main,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Font = FONT,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            TextColor3 = C.SubText,
            Text = Content,
            RichText = true,
            LayoutOrder = 2,
        })
    end

    local DurationBar = New("Frame", {
        Name = "DurationBar",
        Parent = Main,
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = C.Accent,
        BorderSizePixel = 0,
        LayoutOrder = 3,
    }, {
        New("UICorner", { CornerRadius = UDim.new(1, 0) }),
    })

    task.spawn(function()
        task.wait()
        Tween(Main, { Position = UDim2.new(0, 0, 0, 0) }, 0.35)
        Tween(Container, { Size = UDim2.new(1, 0, 0, Main.AbsoluteSize.Y) }, 0.35)
        Tween(DurationBar, { Size = UDim2.new(0, 0, 0, 2) }, Duration)
        task.wait(Duration + 0.1)
        Tween(Main, { Position = UDim2.new(1.5, 0, 0, 0) }, 0.35)
        task.wait(0.35)
        Container:Destroy()
    end)

    return {
        Close = function()
            Tween(Main, { Position = UDim2.new(1.5, 0, 0, 0) }, 0.35)
            task.wait(0.35)
            Container:Destroy()
        end,
    }
end

Library.Popup = function(_, Config)
    Config = Config or {}
    local Title = Config.Title or "Confirm"
    local Content = Config.Content or ""
    local Icon = Config.Icon or ""
    local Buttons = Config.Buttons or {}
    local OnButton = Config.Callback

    local PopupGui = New("ScreenGui", {
        Name = "LolLib/Popup",
        Parent = Config.Parent or CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 10001,
    })

    New("Frame", {
        Name = "Overlay",
        Parent = PopupGui,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.5,
    })

    local PopupFrame = New("Frame", {
        Name = "Popup",
        Parent = PopupGui,
        Size = UDim2.fromOffset(380, 0),
        Position = UDim2.new(0.5, -190, 0.5, -100),
        BackgroundColor3 = C.Sidebar,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
    }, {
        New("UICorner", { CornerRadius = UDim.new(0, 10) }),
        New("UIStroke", { Color = C.AccentDim, Thickness = 1, Transparency = 0.5 }),
        New("UIPadding", {
            PaddingTop = UDim.new(0, 20),
            PaddingBottom = UDim.new(0, 20),
            PaddingLeft = UDim.new(0, 20),
            PaddingRight = UDim.new(0, 20),
        }),
        New("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),
    })

    if Icon ~= "" then
        New("ImageLabel", {
            Name = "Icon",
            Parent = PopupFrame,
            Size = UDim2.new(0, 36, 0, 36),
            BackgroundTransparency = 1,
            Image = Icons.Resolve(Icon) or Icon,
            ImageColor3 = C.Accent,
            LayoutOrder = 1,
        })
    end

    New("TextLabel", {
        Name = "Title",
        Parent = PopupFrame,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Font = FONT,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = C.Text,
        Text = Title,
        RichText = true,
        LayoutOrder = 2,
    })

    if Content ~= "" then
        New("TextLabel", {
            Name = "Content",
            Parent = PopupFrame,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Font = FONT,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            TextColor3 = C.SubText,
            Text = Content,
            LayoutOrder = 3,
        })
    end

    local BtnContainer = New("Frame", {
        Name = "Buttons",
        Parent = PopupFrame,
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        LayoutOrder = 4,
    }, {
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 8),
        }),
    })

    for _, BtnConf in ipairs(Buttons) do
        local IsPrimary = BtnConf.Variant == "Primary"
        local Btn = New("TextButton", {
            Name = "Btn",
            Parent = BtnContainer,
            Size = UDim2.new(0, #Buttons > 1 and 100 or 140, 0, 32),
            BackgroundColor3 = IsPrimary and C.Accent or C.Element,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Font = FONT,
            TextSize = 13,
            TextColor3 = C.Text,
            Text = BtnConf.Name or "OK",
        }, {
            New("UICorner", { CornerRadius = UDim.new(0, 6) }),
        })
        Btn.MouseButton1Click:Connect(function()
            if BtnConf.Callback then pcall(BtnConf.Callback) end
            if OnButton then pcall(OnButton, BtnConf.Name) end
            PopupGui:Destroy()
        end)
        Btn.MouseEnter:Connect(function()
            Tween(Btn, { BackgroundColor3 = IsPrimary and C.AccentDim or C.ElementHover }, 0.1)
        end)
        Btn.MouseLeave:Connect(function()
            Tween(Btn, { BackgroundColor3 = IsPrimary and C.Accent or C.Element }, 0.1)
        end)
    end

    return PopupFrame
end

Library.AddIcons = function(_, Pack, Map)
    Icons.AddIcons(Pack, Map)
end

Library.CreateWindow = function(_, Options)
    Options = Options or {}

    local WindowName = Options.Name or "Lol Lib"
    local Parent     = Options.Parent or CoreGui
    local AutoSave   = Options.AutoSave
    local AutoShow   = Options.AutoShow
    local Size       = Options.Size or UDim2.fromOffset(560, 430)
    local Background = Options.Background
    local User       = Options.User
    local OpenButton = Options.OpenButton
    local SearchBar  = Options.SearchBar ~= false

    local ConfigData = (AutoSave and LoadConfigData()) or {}

    local Connections = {}
    local Tabs        = {}
    local TabOrder    = {}

    local ScreenGui = New("ScreenGui", {
        Name             = "LolLib",
        Parent           = Parent,
        ResetOnSpawn     = false,
        ZIndexBehavior   = Enum.ZIndexBehavior.Sibling,
        Enabled          = not not AutoShow,
        DisplayOrder     = 9999,
    })

    local Main = New("Frame", {
        Name             = "MainWindow",
        Parent           = ScreenGui,
        Size             = Size,
        Position         = UDim2.new(0.5, -Size.X.Offset / 2, 0.5, -Size.Y.Offset / 2),
        BackgroundColor3 = C.BG,
        BorderSizePixel  = 0,
        Active           = true,
        ClipsDescendants = true,
    }, {
        New("UICorner", { CornerRadius = UDim.new(0, 6) }),
        New("UIStroke", { Color = C.AccentDim, Thickness = 1, Transparency = 0.6 })
    })

    if Background then
        if type(Background) == "string" and (Background:find("video") or Background:find("webm") or Background:find("mp4")) then
            local VideoUrl = Background:match("video:(.+)")
            if VideoUrl then
                local Vid = New("VideoFrame", {
                    Name = "BackgroundVideo",
                    Parent = Main,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Video = VideoUrl,
                    Looping = true,
                    Playing = true,
                    Volume = 0,
                }, {
                    New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                })
                task.spawn(function()
                    Vid.Loaded:Wait()
                    Vid.Playing = true
                end)
            end
        else
            New("ImageLabel", {
                Name = "Background",
                Parent = Main,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Image = Background,
                ScaleType = Enum.ScaleType.Crop,
                ImageTransparency = 0.9,
                ZIndex = 0,
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 6) }),
            })
        end
    end

    if Options.Acrylic then
        pcall(function()
            local Blur = Instance.new("BlurEffect")
            Blur.Name = "AcrylicBlur"
            Blur.Size = 24
            Blur.Parent = game:GetService("Lighting")
            table.insert(Connections, {
                Disconnect = function()
                    Blur:Destroy()
                end,
            })
        end)
    end

    local OpenBtn
    if OpenButton and not AutoShow then
        OpenBtn = New("TextButton", {
            Name = "OpenButton",
            Parent = Parent,
            Size = UDim2.fromOffset(140, 36),
            Position = UDim2.new(0, 16, 1, -56),
            BackgroundColor3 = C.Accent,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Font = FONT,
            TextSize = 13,
            TextColor3 = Color3.new(1, 1, 1),
            Text = OpenButton.Title or "Open UI",
            Visible = true,
            ZIndex = 99999,
        }, {
            New("UICorner", { CornerRadius = OpenButton.CornerRadius or UDim.new(1, 0) }),
            New("UIStroke", { Color = C.AccentDim, Thickness = OpenButton.StrokeThickness or 0, Transparency = 0.3 }),
        })
        if OpenButton.Color then
            OpenBtn.BackgroundColor3 = OpenButton.Color
        end
        OpenBtn.MouseButton1Click:Connect(function()
            ScreenGui.Enabled = true
            Main.Visible = true
            if OpenBtn then OpenBtn.Visible = false end
        end)
        OpenBtn.MouseEnter:Connect(function()
            Tween(OpenBtn, { BackgroundColor3 = C.AccentDim }, 0.15)
        end)
        OpenBtn.MouseLeave:Connect(function()
            Tween(OpenBtn, { BackgroundColor3 = OpenButton.Color or C.Accent }, 0.15)
        end)
    end

    local TopBar = New("Frame", {
        Name             = "TopBar",
        Parent           = Main,
        Size             = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = C.TopBar,
        BorderSizePixel  = 0,
    }, {
        New("UICorner", { CornerRadius = UDim.new(0, 6) })
    })

    local Title = New("TextLabel", {
        Name             = "Title",
        Parent           = TopBar,
        Size             = UDim2.new(1, -90, 1, 0),
        Position         = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Font             = FONT,
        TextSize         = 14,
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextWrapped      = false,
        RichText         = true,
        TextColor3       = C.Text,
        Text             = WindowName,
    })

    local Controls = New("Frame", {
        Name             = "Controls",
        Parent           = TopBar,
        Size             = UDim2.new(0, 78, 1, 0),
        Position         = UDim2.new(1, -78, 0, 0),
        BackgroundTransparency = 1,
    }, {
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment   = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 4)
        })
    })

    local function MakeControl(Text, Color, Callback)
        local Btn = New("TextButton", {
            Name             = "Control",
            Parent           = Controls,
            Size             = UDim2.fromOffset(20, 20),
            BackgroundTransparency = 1,
            AutoButtonColor  = false,
            Text             = Text,
            Font             = FONT,
            TextSize         = 14,
            TextColor3       = Color,
        })
        Btn.MouseButton1Click:Connect(Callback)
        Btn.MouseEnter:Connect(function() Tween(Btn, { TextColor3 = C.Text }, 0.1) end)
        Btn.MouseLeave:Connect(function() Tween(Btn, { TextColor3 = Color }, 0.1) end)
        return Btn
    end

    local Body = New("Frame", {
        Name             = "Body",
        Parent           = Main,
        Size             = UDim2.new(1, 0, 1, -32),
        Position         = UDim2.new(0, 0, 0, 32),
        BackgroundColor3 = C.BG,
        BorderSizePixel  = 0,
    })

    local Sidebar = New("Frame", {
        Name             = "Sidebar",
        Parent           = Body,
        Size             = UDim2.new(0, 118, 1, 0),
        BackgroundColor3 = C.Sidebar,
        BorderSizePixel  = 0,
    }, {
        New("UICorner", { CornerRadius = UDim.new(0, 6) })
    })

    if User and User.Enabled then
        local UserFrame = New("Frame", {
            Name = "UserProfile",
            Parent = Sidebar,
            Size = UDim2.new(1, 0, 0, 48),
            BackgroundTransparency = 1,
            LayoutOrder = -100,
        }, {
            New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 6) }),
        })
        local Avatar = New("ImageLabel", {
            Name = "Avatar",
            Parent = UserFrame,
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = C.Element,
            BorderSizePixel = 0,
            Image = User.Avatar or "",
            ScaleType = Enum.ScaleType.Fit,
        }, {
            New("UICorner", { CornerRadius = UDim.new(1, 0) }),
        })
        if not User.Avatar or User.Avatar == "" then
            New("TextLabel", {
                Name = "Placeholder",
                Parent = Avatar,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Font = FONT,
                TextSize = 14,
                TextColor3 = C.Accent,
                Text = User.Anonymous and "?" or string.sub(User.Name or "U", 1, 1),
            })
        end
        local UserName = User.Name or (LocalPlayer and LocalPlayer.Name) or "User"
        if User.Anonymous then UserName = "Anonymous" end
        New("TextLabel", {
            Name = "Name",
            Parent = UserFrame,
            Size = UDim2.new(1, -38, 0, 14),
            Position = UDim2.new(0, 36, 0, 2),
            BackgroundTransparency = 1,
            Font = FONT,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = C.Text,
            Text = UserName,
        })
        New("TextLabel", {
            Name = "Sub",
            Parent = UserFrame,
            Size = UDim2.new(1, -38, 0, 12),
            Position = UDim2.new(0, 36, 0, 18),
            BackgroundTransparency = 1,
            Font = FONT,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = C.SubText,
            Text = User.Subtitle or "Lol Lib",
        })
        if User.Callback then
            local ClickArea = New("TextButton", {
                Name = "Click",
                Parent = UserFrame,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
            })
            ClickArea.MouseButton1Click:Connect(function()
                pcall(User.Callback)
            end)
        end
    end

    local SearchBox
    if SearchBar then
        SearchBox = New("Frame", {
            Name = "SearchBar",
            Parent = Sidebar,
            Size = UDim2.new(1, -16, 0, 28),
            BackgroundColor3 = C.Element,
            BorderSizePixel = 0,
            LayoutOrder = -50,
        }, {
            New("UICorner", { CornerRadius = UDim.new(0, 6) }),
            New("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }),
        })
        New("ImageLabel", {
            Name = "SearchIcon",
            Parent = SearchBox,
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new(0, 2, 0.5, -7),
            BackgroundTransparency = 1,
            Image = Icons.Resolve("lucide:search") or "",
            ImageColor3 = C.SubText,
        })
        local SearchInput = New("TextBox", {
            Name = "Input",
            Parent = SearchBox,
            Size = UDim2.new(1, -24, 1, 0),
            Position = UDim2.new(0, 22, 0, 0),
            BackgroundTransparency = 1,
            Font = FONT,
            TextSize = 12,
            TextColor3 = C.Text,
            PlaceholderColor3 = C.SubText,
            PlaceholderText = "Search...",
            ClearTextOnFocus = false,
            Text = "",
        })
        SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
            local Query = SearchInput.Text:lower()
            for _, Tab in ipairs(TabOrder) do
                local Match = false
                if Query == "" then
                    Match = true
                else
                    if Tab.Name:lower():find(Query, 1, true) then
                        Match = true
                    end
                    for _, El in ipairs(Tab.Elements or {}) do
                        if El.Frame and El.Frame:FindFirstChild("Label") then
                            if El.Frame.Label.Text:lower():find(Query, 1, true) then
                                Match = true
                            end
                        end
                    end
                end
                Tab.Button.Visible = Match
            end
        end)
    end

    local TabList = New("ScrollingFrame", {
        Name             = "TabList",
        Parent           = Sidebar,
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.AccentDim,
        CanvasSize       = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, {
        New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center }),
        New("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8) })
    })

    local ContentHolder = New("Frame", {
        Name             = "ContentHolder",
        Parent           = Body,
        Size             = UDim2.new(1, -118, 1, 0),
        Position         = UDim2.new(0, 118, 0, 0),
        BackgroundColor3 = C.BG,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
    })

    local ContentBG = New("ImageLabel", {
        Name             = "Background",
        Parent           = ContentHolder,
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ImageTransparency = 1,
        ScaleType        = Enum.ScaleType.Crop,
    })

    local Dragging, DragStart, StartPos

    TopBar.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = Vector2.new(Input.Position.X, Input.Position.Y)
            StartPos = Main.AbsolutePosition
        end
    end)

    TopBar.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)

    table.insert(Connections, UserInputService.InputChanged:Connect(function(Input)
        if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = Vector2.new(Input.Position.X, Input.Position.Y) - DragStart
            Main.Position = UDim2.fromOffset(StartPos.X + Delta.X, StartPos.Y + Delta.Y)
        end
    end))

    local ActiveTab = nil

    local function SelectTab(Tab)
        if ActiveTab == Tab then return end
        if ActiveTab then
            ActiveTab.Content.Visible = false
            if ActiveTab.Background then ActiveTab.Background.Visible = false end
            Tween(ActiveTab.Button, { BackgroundColor3 = C.Sidebar }, 0.12)
            Tween(ActiveTab.Button.Icon, { ImageTransparency = 0.35 }, 0.12)
            Tween(ActiveTab.Button.Label, { TextColor3 = C.SubText }, 0.12)
        end
        ActiveTab = Tab
        Tab.Content.Visible = true
        if Tab.Background then Tab.Background.Visible = true end
        Tween(Tab.Button, { BackgroundColor3 = C.AccentDim }, 0.12)
        Tween(Tab.Button.Icon, { ImageTransparency = 0 }, 0.12)
        Tween(Tab.Button.Label, { TextColor3 = C.Text }, 0.12)
    end

    local Window = {}
    Window.Tabs = Tabs

    Window.CreateTab = function(_, Opts)
        Opts = Opts or {}
        local TabName = Opts.Name or "Tab"
        local TabIcon = Icons.Resolve(Opts.Icon)

        local TabButton = New("Frame", {
            Name             = "TabButton",
            Parent           = TabList,
            Size             = UDim2.new(1, -12, 0, 36),
            BackgroundColor3 = C.Sidebar,
            BorderSizePixel  = 0,
        }, {
            New("UICorner", { CornerRadius = UDim.new(0, 5) })
        })

        local Icon = New("ImageLabel", {
            Name             = "Icon",
            Parent           = TabButton,
            Size             = UDim2.fromOffset(20, 20),
            Position         = UDim2.new(0, 8, 0.5, -10),
            BackgroundTransparency = 1,
            Image            = TabIcon,
            ImageTransparency = 0.35,
            ScaleType        = Enum.ScaleType.Fit,
        })

        local Label = New("TextLabel", {
            Name             = "Label",
            Parent           = TabButton,
            Size             = UDim2.new(1, -36, 1, 0),
            Position         = UDim2.new(0, 34, 0, 0),
            BackgroundTransparency = 1,
            Font             = FONT,
            TextSize         = 12,
            TextXAlignment   = Enum.TextXAlignment.Left,
            TextColor3       = C.SubText,
            Text             = TabName,
        })

        local Content = New("ScrollingFrame", {
            Name             = "Content_" .. TabName,
            Parent           = ContentHolder,
            Size             = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel  = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = C.AccentDim,
            CanvasSize       = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible          = false,
        }, {
            New("UIListLayout", { Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center }),
            New("UIPadding", { PaddingTop = UDim.new(0, 12), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12) })
        })

        local TabBackground = New("ImageLabel", {
            Name             = "TabBackground",
            Parent           = ContentHolder,
            Size             = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ImageTransparency = 1,
            ScaleType        = Enum.ScaleType.Crop,
            Visible          = false,
            ZIndex           = 0,
        })

        local Tab = {
            Name    = TabName,
            Icon    = TabIcon,
            Button  = TabButton,
            Content = Content,
            Background = TabBackground,
            Elements = {},
        }

        Tab.SetTheme = function(_, Image, Opts)
            Opts = Opts or {}
            TabBackground.Image = Image or ""
            TabBackground.ImageTransparency = Opts.ImageTransparency == nil and 1 or Opts.ImageTransparency
            TabBackground.Visible = (ActiveTab == Tab) and (Image ~= nil and Image ~= "")
        end

        TabButton.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                SelectTab(Tab)
            end
        end)

        Tabs[TabName] = Tab
        table.insert(TabOrder, Tab)

        if not ActiveTab then
            SelectTab(Tab)
        end

        local function Register(Element, Flag)
            Tab.Elements[#Tab.Elements + 1] = Element
            Library.Elements[Flag] = Element
            return Element
        end

        local function Persist(Flag, Value)
            if not Flag or not AutoSave then return end
            ConfigData[Flag] = Value
            SaveConfigData(ConfigData)
        end

        Tab.CreateSection = function(_, O)
            O = O or {}
            return New("Frame", {
                Name             = "Section",
                Parent           = Content,
                Size             = UDim2.new(1, 0, 0, 26),
                BackgroundTransparency = 1,
            }, {
                New("TextLabel", {
                    Name             = "Label",
                    Size             = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Font             = FONT,
                    TextSize         = 13,
                    FontWeight       = Enum.FontWeight.SemiBold,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                    TextColor3       = C.Text,
                    Text             = O.Name or "",
                }),
                New("Frame", {
                    Name             = "Underline",
                    Size             = UDim2.new(1, 0, 0, 2),
                    Position         = UDim2.new(0, 0, 1, -2),
                    BackgroundColor3 = C.Divider,
                    BorderSizePixel  = 0,
                })
            })
        end

        Tab.CreateDivider = function(_, O)
            O = O or {}
            return New("Frame", {
                Name             = "Divider",
                Parent           = Content,
                Size             = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = C.Divider,
                BorderSizePixel  = 0,
            })
        end

        Tab.CreateLabel = function(_, O)
            O = O or {}
            return New("TextLabel", {
                Name             = "Label",
                Parent           = Content,
                Size             = UDim2.new(1, 0, 0, 40),
                BackgroundTransparency = 1,
                Font             = FONT,
                TextSize         = 12,
                TextWrapped      = true,
                RichText         = true,
                TextXAlignment   = Enum.TextXAlignment.Left,
                TextYAlignment   = Enum.TextYAlignment.Top,
                TextColor3       = C.SubText,
                Text             = O.Name or "",
            })
        end

        Tab.CreateButton = function(_, O)
            O = O or {}
            local Frame = New("Frame", {
                Name             = "Button",
                Parent           = Content,
                Size             = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = C.Element,
                BorderSizePixel  = 0,
                ClipsDescendants = true,
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 5) }),
                New("TextLabel", {
                    Name             = "Label",
                    Size             = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Font             = FONT,
                    TextSize         = 13,
                    TextColor3       = C.Text,
                    Text             = O.Name or "Button",
                })
            })
            Frame.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Tween(Frame, { BackgroundColor3 = C.AccentDim }, 0.1)
                end
            end)
            Frame.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Tween(Frame, { BackgroundColor3 = C.Element }, 0.1)
                    if O.Callback then pcall(O.Callback) end
                end
            end)
            return Register({ Frame = Frame }, O.Flag)
        end

        Tab.CreateToggle = function(_, O)
            O = O or {}
            local State = (O.Value == nil and false) or O.Value
            local Frame = New("Frame", {
                Name             = "Toggle",
                Parent           = Content,
                Size             = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = C.Element,
                BorderSizePixel  = 0,
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 5) }),
                New("TextLabel", {
                    Name             = "Label",
                    Size             = UDim2.new(1, -60, 1, 0),
                    Position         = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Font             = FONT,
                    TextSize         = 13,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                    TextColor3       = C.Text,
                    Text             = O.Name or "Toggle",
                })
            })
            local Switch = New("Frame", {
                Name             = "Switch",
                Parent           = Frame,
                Size             = UDim2.fromOffset(38, 18),
                Position         = UDim2.new(1, -48, 0.5, -9),
                BackgroundColor3 = C.Track,
                BorderSizePixel  = 0,
            }, {
                New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                New("Frame", {
                    Name             = "Knob",
                    Size             = UDim2.fromOffset(14, 14),
                    Position         = UDim2.new(0, 2, 0.5, -7),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel  = 0,
                }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
            })
            local Knob = Switch.Knob
            local function Apply(Animate)
                if Animate then
                    Tween(Switch, { BackgroundColor3 = State and C.Accent or C.Track }, 0.15)
                    Tween(Knob, { Position = State and UDim2.new(0, 22, 0.5, -7) or UDim2.new(0, 2, 0.5, -7) }, 0.15)
                else
                    Switch.BackgroundColor3 = State and C.Accent or C.Track
                    Knob.Position = State and UDim2.new(0, 22, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                end
            end
            local function Fire()
                if O.Callback then pcall(O.Callback, State) end
                Persist(O.Flag, State)
            end
            Frame.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    State = not State
                    Apply(true)
                    Fire()
                end
            end)
            Apply(false)
            if O.Flag and ConfigData[O.Flag] ~= nil then
                State = ConfigData[O.Flag]
                Apply(false)
                Fire()
            end
            local Element = {
                Frame = Frame,
                Get = function() return State end,
                Set = function(_, V)
                    V = not not V
                    if V ~= State then
                        State = V
                        Apply(true)
                    end
                    Fire()
                    return Element
                end,
            }
            return Register(Element, O.Flag)
        end

        Tab.CreateSlider = function(_, O)
            O = O or {}
            local Range = O.Range or {0, 1}
            local Min, Max = Range[1], Range[2]
            local Inc = O.Increment or 1
            local Value = (O.Value == nil and Min) or O.Value
            local Frame = New("Frame", {
                Name             = "Slider",
                Parent           = Content,
                Size             = UDim2.new(1, 0, 0, 46),
                BackgroundColor3 = C.Element,
                BorderSizePixel  = 0,
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 5) }),
                New("TextLabel", {
                    Name             = "Label",
                    Size             = UDim2.new(1, -70, 0, 18),
                    Position         = UDim2.new(0, 10, 0, 4),
                    BackgroundTransparency = 1,
                    Font             = FONT,
                    TextSize         = 13,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                    TextColor3       = C.Text,
                    Text             = O.Name or "Slider",
                }),
                New("TextBox", {
                    Name             = "Value",
                    Size             = UDim2.fromOffset(54, 18),
                    Position         = UDim2.new(1, -64, 0, 4),
                    BackgroundColor3 = C.BG,
                    BorderSizePixel  = 0,
                    Font             = FONT,
                    TextSize         = 12,
                    TextColor3       = C.Text,
                    ClearTextOnFocus = false,
                    Text             = tostring(Value),
                }, { New("UICorner", { CornerRadius = UDim.new(0, 3) }) }),
                New("Frame", {
                    Name             = "Track",
                    Size             = UDim2.new(1, -20, 0, 6),
                    Position         = UDim2.new(0, 10, 1, -14),
                    BackgroundColor3 = C.Track,
                    BorderSizePixel  = 0,
                }, {
                    New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    New("Frame", {
                        Name             = "Fill",
                        Size             = UDim2.new(0, 0, 1, 0),
                        BackgroundColor3 = C.Accent,
                        BorderSizePixel  = 0,
                    }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) }),
                    New("Frame", {
                        Name             = "Thumb",
                        Size             = UDim2.fromOffset(12, 12),
                        Position         = UDim2.new(0, -6, 0.5, -6),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BorderSizePixel  = 0,
                    }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
                })
            })
            local Track = Frame.Track
            local Fill  = Track.Fill
            local Thumb = Track.Thumb
            local Box   = Frame.Value
            local function Percent()
                return (Value - Min) / (Max - Min)
            end
            local function Apply(Animate)
                local P = Clamp(Percent(), 0, 1)
                if Animate then
                    Tween(Fill, { Size = UDim2.new(P, 0, 1, 0) }, 0.1)
                    Tween(Thumb, { Position = UDim2.new(P, -6, 0.5, -6) }, 0.1)
                else
                    Fill.Size = UDim2.new(P, 0, 1, 0)
                    Thumb.Position = UDim2.new(P, -6, 0.5, -6)
                end
                if Box.Text ~= tostring(Value) then
                    Box.Text = tostring(Value)
                end
            end
            local function Fire()
                if O.Callback then pcall(O.Callback, Value) end
                Persist(O.Flag, Value)
            end
            local Dragging = false
            local function FromInput(Input)
                local P = Clamp((Input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                Value = Round(Min + P * (Max - Min), Inc)
                Value = Clamp(Value, Min, Max)
                Apply(true)
                Fire()
            end
            Track.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    FromInput(Input)
                end
            end)
            Track.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)
            table.insert(Connections, UserInputService.InputChanged:Connect(function(Input)
                if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                    FromInput(Input)
                end
            end))
            Box.FocusLost:Connect(function()
                local Num = tonumber(Box.Text)
                if Num then
                    Value = Clamp(Round(Num, Inc), Min, Max)
                    Apply(true)
                    Fire()
                else
                    Apply(false)
                end
            end)
            Apply(false)
            if O.Flag and ConfigData[O.Flag] ~= nil then
                Value = Clamp(ConfigData[O.Flag], Min, Max)
                Apply(false)
                Fire()
            end
            local Element = {
                Frame = Frame,
                Get = function() return Value end,
                Set = function(_, V)
                    V = Clamp(Round(V, Inc), Min, Max)
                    Value = V
                    Apply(true)
                    Fire()
                    return Element
                end,
            }
            return Register(Element, O.Flag)
        end

        Tab.CreateInput = function(_, O)
            O = O or {}
            local Value = O.Value or ""
            local Frame = New("Frame", {
                Name             = "Input",
                Parent           = Content,
                Size             = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = C.Element,
                BorderSizePixel  = 0,
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 5) }),
                New("TextLabel", {
                    Name             = "Label",
                    Size             = UDim2.new(1, -140, 1, 0),
                    Position         = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Font             = FONT,
                    TextSize         = 13,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                    TextColor3       = C.Text,
                    Text             = O.Name or "Input",
                }),
                New("TextBox", {
                    Name             = "Box",
                    Size             = UDim2.fromOffset(120, 22),
                    Position         = UDim2.new(1, -130, 0.5, -11),
                    BackgroundColor3 = C.BG,
                    BorderSizePixel  = 0,
                    Font             = FONT,
                    TextSize         = 12,
                    TextColor3       = C.Text,
                    PlaceholderColor3 = C.SubText,
                    PlaceholderText  = "Value",
                    ClearTextOnFocus = false,
                    Text             = tostring(Value),
                }, { New("UICorner", { CornerRadius = UDim.new(0, 3) }) })
            })
            local Box = Frame.Box
            local function Fire()
                if O.Callback then pcall(O.Callback, Value) end
                Persist(O.Flag, Value)
            end
            Box.FocusLost:Connect(function(Enter)
                if O.Numeric then
                    local Num = tonumber(Box.Text)
                    if Num == nil then
                        Box.Text = tostring(Value)
                        return
                    end
                    Value = Num
                else
                    Value = Box.Text
                end
                if O.Confirm and not Enter then
                    Box.Text = tostring(Value)
                    return
                end
                Fire()
            end)
            if O.Flag and ConfigData[O.Flag] ~= nil then
                Value = ConfigData[O.Flag]
                Box.Text = tostring(Value)
                Fire()
            end
            local Element = {
                Frame = Frame,
                Get = function() return Value end,
                Set = function(_, V)
                    Value = (O.Numeric and tonumber(V)) or tostring(V)
                    Box.Text = tostring(Value)
                    Fire()
                    return Element
                end,
            }
            return Register(Element, O.Flag)
        end

        Tab.CreatePicker = function(_, O)
            O = O or {}
            local Color
            if type(O.Value) == "table" then
                Color = Color3.fromHSV(O.Value.Hue or 0, O.Value.Saturation or 0, O.Value.Brightness or 1)
            else
                Color = O.Value or Color3.fromRGB(255, 255, 255)
            end
            local Frame = New("Frame", {
                Name             = "Picker",
                Parent           = Content,
                Size             = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = C.Element,
                BorderSizePixel  = 0,
                ClipsDescendants = true,
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 5) }),
                New("TextLabel", {
                    Name             = "Label",
                    Size             = UDim2.new(1, -50, 1, 0),
                    Position         = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Font             = FONT,
                    TextSize         = 13,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                    TextColor3       = C.Text,
                    Text             = O.Name or "Color",
                }),
                New("Frame", {
                    Name             = "Swatch",
                    Size             = UDim2.fromOffset(28, 22),
                    Position         = UDim2.new(1, -38, 0.5, -11),
                    BackgroundColor3 = Color,
                    BorderSizePixel  = 0,
                }, { New("UICorner", { CornerRadius = UDim.new(0, 3) }) })
            })
            local Swatch = Frame.Swatch
            local Open = false
            local Panel
            local H, S, V = Color3.toHSV(Color)
            local function Serialize()
                return { R = math.floor(Color.R * 255), G = math.floor(Color.G * 255), B = math.floor(Color.B * 255) }
            end
            local function Fire()
                if O.Callback then pcall(O.Callback, Color) end
                Persist(O.Flag, Serialize())
            end
            local function MakeSlider(Parent, Y, GetSet)
                local Track = New("Frame", {
                    Name             = "Track",
                    Parent           = Parent,
                    Size             = UDim2.new(1, -20, 0, 6),
                    Position         = UDim2.new(0, 10, 0, Y),
                    BackgroundColor3 = C.Track,
                    BorderSizePixel  = 0,
                }, {
                    New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    New("Frame", {
                        Name             = "Fill",
                        Size             = UDim2.new(0, 0, 1, 0),
                        BackgroundColor3 = C.Accent,
                        BorderSizePixel  = 0,
                    }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) }),
                    New("Frame", {
                        Name             = "Thumb",
                        Size             = UDim2.fromOffset(12, 12),
                        Position         = UDim2.new(0, -6, 0.5, -6),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BorderSizePixel  = 0,
                    }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
                })
                local Dragging = false
                local Fill, Thumb = Track.Fill, Track.Thumb
                local function Update(Input)
                    local P = Clamp((Input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                    GetSet(P)
                    Fill.Size = UDim2.new(P, 0, 1, 0)
                    Thumb.Position = UDim2.new(P, -6, 0.5, -6)
                    Color = Color3.fromHSV(H, S, V)
                    Swatch.BackgroundColor3 = Color
                    Fire()
                end
                Track.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                        Update(Input)
                    end
                end)
                Track.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = false
                    end
                end)
                table.insert(Connections, UserInputService.InputChanged:Connect(function(Input)
                    if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                        Update(Input)
                    end
                end))
                local P = GetSet()
                Fill.Size = UDim2.new(P, 0, 1, 0)
                Thumb.Position = UDim2.new(P, -6, 0.5, -6)
            end
            local function TogglePanel()
                Open = not Open
                if Open then
                    Panel = New("Frame", {
                        Name             = "Panel",
                        Parent           = Frame,
                        Size             = UDim2.new(1, 0, 0, 96),
                        Position         = UDim2.new(0, 0, 1, 0),
                        BackgroundColor3 = C.Sidebar,
                        BorderSizePixel  = 0,
                        ZIndex           = 5,
                    }, { New("UICorner", { CornerRadius = UDim.new(0, 5) }) })
                    for _, Desc in ipairs(Panel:GetDescendants()) do
                        if Desc:IsA("GuiObject") then Desc.ZIndex = 5 end
                    end
                    MakeSlider(Panel, 14, function(P) if P == nil then return H end H = P end)
                    MakeSlider(Panel, 44, function(P) if P == nil then return S end S = P end)
                    MakeSlider(Panel, 74, function(P) if P == nil then return V end V = P end)
                    Tween(Frame, { Size = UDim2.new(1, 0, 0, 32 + 100) }, 0.15)
                else
                    Tween(Frame, { Size = UDim2.new(1, 0, 0, 32) }, 0.15)
                    task.delay(0.16, function()
                        if Panel then Panel:Destroy(); Panel = nil end
                    end)
                end
            end
            Swatch.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    TogglePanel()
                end
            end)
            if O.Flag and ConfigData[O.Flag] then
                local D = ConfigData[O.Flag]
                if type(D) == "table" and D.R then
                    Color = Color3.fromRGB(D.R, D.G, D.B)
                    H, S, V = Color3.toHSV(Color)
                    Swatch.BackgroundColor3 = Color
                    Fire()
                end
            end
            local Element = {
                Frame = Frame,
                Get = function() return Color end,
                Set = function(_, Col)
                    Color = Col
                    H, S, V = Color3.toHSV(Color)
                    Swatch.BackgroundColor3 = Color
                    Fire()
                    return Element
                end,
            }
            return Register(Element, O.Flag)
        end

        Tab.CreateDropdown = function(_, O)
            O = O or {}
            local Options   = O.Options or {}
            local Multi     = O.MultiSelect
            local Selected  = {}
            if Multi then
                Selected = (O.Value and type(O.Value) == "table") and O.Value or {}
            else
                Selected = { O.Value or Options[1] or "" }
            end
            local Frame = New("Frame", {
                Name             = "Dropdown",
                Parent           = Content,
                Size             = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = C.Element,
                BorderSizePixel  = 0,
                ClipsDescendants = true,
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 5) }),
                New("TextLabel", {
                    Name             = "Label",
                    Size             = UDim2.new(1, -130, 1, 0),
                    Position         = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Font             = FONT,
                    TextSize         = 13,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                    TextColor3       = C.Text,
                    Text             = O.Name or "Dropdown",
                }),
                New("TextButton", {
                    Name             = "Trigger",
                    Size             = UDim2.fromOffset(110, 22),
                    Position         = UDim2.new(1, -120, 0.5, -11),
                    BackgroundColor3 = C.BG,
                    BorderSizePixel  = 0,
                    AutoButtonColor  = false,
                    Font             = FONT,
                    TextSize         = 12,
                    TextColor3       = C.Text,
                    Text             = "",
                }, { New("UICorner", { CornerRadius = UDim.new(0, 3) }) })
            })
            local Trigger = Frame.Trigger
            local Open = false
            local List
            local function DisplayText()
                if Multi then
                    return #Selected == 0 and "None" or table.concat(Selected, ", ")
                end
                return Selected[1] or "Select"
            end
            local function Fire()
                if O.Callback then pcall(O.Callback, Selected) end
                Persist(O.Flag, Selected)
            end
            local function BuildList()
                List = New("Frame", {
                    Name             = "List",
                    Parent           = Frame,
                    Size             = UDim2.new(1, 0, 0, math.min(20 * #Options, 140)),
                    Position         = UDim2.new(0, 0, 1, 0),
                    BackgroundColor3 = C.Sidebar,
                    BorderSizePixel  = 0,
                    ZIndex           = 6,
                    ClipsDescendants = true,
                }, {
                    New("UICorner", { CornerRadius = UDim.new(0, 5) }),
                    New("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }),
                    New("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4) })
                })
                for _, Desc in ipairs(List:GetDescendants()) do
                    if Desc:IsA("GuiObject") then Desc.ZIndex = 6 end
                end
                for _, Option in ipairs(Options) do
                    local IsSel = false
                    for _, S in ipairs(Selected) do
                        if S == Option then IsSel = true; break end
                    end
                    local Item = New("TextButton", {
                        Name             = "Item",
                        Parent           = List,
                        Size             = UDim2.new(1, -8, 0, 18),
                        Position         = UDim2.new(0, 4, 0, 0),
                        BackgroundColor3 = IsSel and C.AccentDim or C.Sidebar,
                        BorderSizePixel  = 0,
                        AutoButtonColor  = false,
                        Font             = FONT,
                        TextSize         = 12,
                        TextXAlignment   = Enum.TextXAlignment.Left,
                        TextColor3       = C.Text,
                        Text             = (IsSel and "✓ " or "") .. Option,
                        ZIndex           = 6,
                    }, { New("UICorner", { CornerRadius = UDim.new(0, 3) }) })
                    Item.MouseButton1Click:Connect(function()
                        if Multi then
                            local Found = false
                            for I, S in ipairs(Selected) do
                                if S == Option then table.remove(Selected, I); Found = true; break end
                            end
                            if not Found then table.insert(Selected, Option) end
                        else
                            Selected = { Option }
                            Open = false
                            Tween(Frame, { Size = UDim2.new(1, 0, 0, 32) }, 0.15)
                            task.delay(0.16, function() if List then List:Destroy(); List = nil end end)
                        end
                        Trigger.Text = DisplayText()
                        Fire()
                        if List then List:Destroy(); List = nil; BuildList() end
                    end)
                end
            end
            Trigger.Text = DisplayText()
            Trigger.MouseButton1Click:Connect(function()
                Open = not Open
                if Open then
                    BuildList()
                    Tween(Frame, { Size = UDim2.new(1, 0, 0, 32 + List.AbsoluteSize.Y + 6) }, 0.15)
                else
                    Tween(Frame, { Size = UDim2.new(1, 0, 0, 32) }, 0.15)
                    task.delay(0.16, function() if List then List:Destroy(); List = nil end end)
                end
            end)
            if O.Flag and ConfigData[O.Flag] then
                local D = ConfigData[O.Flag]
                if type(D) == "table" then
                    Selected = D
                    Trigger.Text = DisplayText()
                    Fire()
                end
            end
            local Element = {
                Frame = Frame,
                Get = function() return Selected end,
                Select = function(_, Vals)
                    Vals = Vals or {}
                    if Multi then
                        Selected = Vals
                    else
                        Selected = { Vals[1] or Options[1] or "" }
                    end
                    Trigger.Text = DisplayText()
                    Fire()
                    return Element
                end,
                Set = function(_, Vals)
                    return Element.Select(_, Vals)
                end,
            }
            return Register(Element, O.Flag)
        end

        return Tab
    end

    MakeControl("—", C.SubText, function()
        Main.Visible = false
        if OpenBtn then OpenBtn.Visible = true end
    end)

    local Maximized = false
    MakeControl("□", C.SubText, function()
        if Maximized then
            Tween(Main, { Size = Size }, 0.15)
            Maximized = false
        else
            Tween(Main, { Size = UDim2.fromOffset(Size.X.Offset, Size.Y.Offset + 190) }, 0.15)
            Maximized = true
        end
    end)

    MakeControl("×", Color3.fromRGB(230, 90, 90), function()
        Window:Flush()
    end)

    Window.Set = function(_, Visible)
        ScreenGui.Enabled = not not Visible
        if OpenBtn then OpenBtn.Visible = not Visible end
    end

    Window.Flush = function()
        for _, Connection in ipairs(Connections) do
            pcall(function() Connection:Disconnect() end)
        end
        Connections = {}
        pcall(function() ScreenGui:Destroy() end)
        if OpenBtn then pcall(function() OpenBtn:Destroy() end) end
        if NotifGui then pcall(function() NotifGui:Destroy() end) end
    end

    Window.Load = function()
        ScreenGui.Enabled = true
        Main.Visible = true
        if OpenBtn then OpenBtn.Visible = false end
    end

    Window.Notify = function(_, NotifConfig)
        NotifConfig = NotifConfig or {}
        NotifConfig.Parent = Parent
        Library:Notify(NotifConfig)
    end

    Window.Popup = function(_, PopupConfig)
        PopupConfig = PopupConfig or {}
        PopupConfig.Parent = Parent
        Library:Popup(PopupConfig)
    end

    Window.SetTheme = function(_, Image, Opts)
        Opts = Opts or {}
        ContentBG.Image = Image or ""
        ContentBG.ImageTransparency = Opts.ImageTransparency == nil and 1 or Opts.ImageTransparency
    end

    local SnowConn, SnowParts = nil, {}

    Window.SetSnowEffect = function(_, On)
        if SnowConn then
            pcall(SnowConn.Disconnect, SnowConn)
            SnowConn = nil
        end
        for _, P in ipairs(SnowParts) do pcall(P.Destroy, P) end
        SnowParts = {}
        if not On then return end
        for I = 1, 40 do
            local P = New("Frame", {
                Name             = "Snow",
                Parent           = Main,
                Size             = UDim2.fromOffset(3, 3),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel  = 0,
                ZIndex           = 50,
                Position         = UDim2.new(math.random(), 0, math.random(), 0),
            }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
            table.insert(SnowParts, P)
        end
        SnowConn = RunService.RenderStepped:Connect(function(Delta)
            for _, P in ipairs(SnowParts) do
                local Pos = P.Position
                local NY = Pos.Y.Scale + Delta * 0.15
                if NY > 1 then NY = -0.02 end
                P.Position = UDim2.new(Pos.X.Scale + math.sin(tick() + P.AbsolutePosition.Y) * 0.0005, 0, NY, 0)
            end
        end)
        table.insert(Connections, SnowConn)
    end

    Window.ClearSnow = function()
        Window:SetSnowEffect(false)
    end

    Library._Window = Window

    return Window
end

return Library
