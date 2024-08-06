getgenv()["load_rewrite"] = true

--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local Teams = game:GetService("Teams")
local LocalPlayer = Players.LocalPlayer or game.Players.LocalPlayer
local Library = nil
local ChamsModule = nil
local shared = {
    chams = {
        enabled = false,
        teamcheck = false,
        color = {fill = Color3.fromRGB(0, 7, 167), outline = Color3.fromRGB(0, 18, 64)},
        transparency = {fill = 0.74, outline = 0.38}
    }
}

--// Modules
local function loadModule(url)
    local success, module = pcall(function()
        return loadstring(game:HttpGet(url, true))()
    end)
    if success then
        return module
    else
        warn("Failed to load module from: " .. url)
        warn(module)
        return nil
    end
end

Library = loadModule("https://raw.githubusercontent.com/Bamboorods/LuminousFreeSTABLE/UNSTABLEWIP/Dependencies/UiLibrary.lua")
ChamsModule = loadModule("https://raw.githubusercontent.com/Bamboorods/LuminousFreeSTABLE/UNSTABLEWIP/Main/Modules/ChamsModule.lua")

if not Library or not ChamsModule then
    warn("One or more modules failed to load. Script will not continue.")
    return
end

local PepsisWorld = Library:CreateWindow({
    Name = 'Luminous',
    Themeable = {
        Info = 'Luminous V0.5',
        Credit = true,
    },
})



Library.Notify({
    Text = "Script Developed by 💿Bamboorods",
    Duration = 2
})

local CombatTab = PepsisWorld:CreateTab({
    Name = 'Combat'
})

local VisualsTab = PepsisWorld:CreateTab({
    Name = 'Visuals'
})

local MiscTab = PepsisWorld:CreateTab({
    Name = 'Misc'
})

local ESPSection = VisualsTab:CreateSection({
    Name = 'ESP',
    Side = 'Left'
})

ESPSection:AddToggle({
    Name = "Toggle",
    Flag = "ESPSection_Enabled",
    Value = shared.chams.enabled,
    Callback = function(state)
        shared.chams.enabled = state
        ChamsModule.setEnabled(state)
    end
})

ESPSection:AddToggle({
    Name = "Team Check",
    Flag = "ESPSection_TeamCheck",
    Value = shared.chams.teamcheck,
    Callback = function(state)
        shared.chams.teamcheck = state
        ChamsModule.setTeamCheckEnabled(state)
    end
})

ESPSection:AddColorPicker({
    Name = "Fill Color",
    Flag = "ESPSection_FillColor",
    Value = shared.chams.color.fill,
    Callback = function(color)
        shared.chams.color.fill = color
        ChamsModule.setFillColor(color)
    end
})

ESPSection:AddColorPicker({
    Name = "Outline Color",
    Flag = "ESPSection_OutlineColor",
    Value = shared.chams.color.outline,
    Callback = function(color)
        shared.chams.color.outline = color
        ChamsModule.setOutlineColor(color)
    end
})

ESPSection:AddSlider({
    Name = "Fill Transparency",
    Flag = "ESPSection_FillTransparency",
    Value = shared.chams.transparency.fill,
    Min = 0,
    Max = 1,
    Decimals = 2,
    Callback = function(value)
        shared.chams.transparency.fill = value
        ChamsModule.setFillTransparency(value)
    end
})

ESPSection:AddSlider({
    Name = "Outline Transparency",
    Flag = "ESPSection_OutlineTransparency",
    Value = shared.chams.transparency.outline,
    Min = 0,
    Max = 1,
    Decimals = 2,
    Callback = function(value)
        shared.chams.transparency.outline = value
        ChamsModule.setOutlineTransparency(value)
    end
})
