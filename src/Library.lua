local Library = {}
Library.Elements = {}
Library.Icons = Icons

Library.AddIcons = function(_, Pack, Map)
    Icons.AddIcons(Pack, Map)
end

Library.CreateWindow = function(Options)
    Options = Options or {}

    local WindowName = Options.Name or "Biggie Hub"
    local Parent     = Options.Parent or CoreGui
    local AutoSave   = Options.AutoSave
    local AutoShow   = Options.AutoShow

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
        Size             = UDim2.fromOffset(560, 430),
        Position         = UDim2.new(0.5, -280, 0.5, -215),
        BackgroundColor3 = C.BG,
        BorderSizePixel  = 0,
        Active           = true,
        ClipsDescendants = true,
    }, {
        New("UICorner", { CornerRadius = UDim.new(0, 6) }),
        New("UIStroke", { Color = C.AccentDim, Thickness = 1, Transparency = 0.6 })
    })

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
        Main.Visible = not Main.Visible
        if Main.Visible then Main.Position = UDim2.new(0.5, -280, 0.5, -215) end
    end)

    MakeControl("□", C.SubText, function()
        if Main.Size.Y.Offset > 460 then
            Tween(Main, { Size = UDim2.fromOffset(560, 430) }, 0.15)
        else
            Tween(Main, { Size = UDim2.fromOffset(560, 620) }, 0.15)
        end
    end)

    MakeControl("×", Color3.fromRGB(230, 90, 90), function()
        Window:Flush()
    end)

    Window.Set = function(_, Visible)
        ScreenGui.Enabled = not not Visible
    end

    Window.Flush = function()
        for _, Connection in ipairs(Connections) do
            pcall(function() Connection:Disconnect() end)
        end
        Connections = {}
        pcall(function() ScreenGui:Destroy() end)
    end

    Window.Load = function()
        ScreenGui.Enabled = true
        Main.Visible = true
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
