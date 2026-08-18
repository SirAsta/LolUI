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

local ConfigFolder = "biggiehub/config"
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

