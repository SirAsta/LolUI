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

