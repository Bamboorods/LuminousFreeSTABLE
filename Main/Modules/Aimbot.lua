--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local Teams = game:GetService("Teams")


--// Variables
local player = Players.LocalPlayer

--//Modules
local function loadModule(url)
    local success, module = pcall(function()
        return loadstring(game:HttpGet(url, true))()
    end)
    if success then
        return module
    else
        warn("Failed to load module from: " .. url)
        return nil
    end
end

local Library = loadModule("https://raw.githubusercontent.com/Bamboorods/LuminousFreeSTABLE/UNSTABLEWIP/Dependencies/UiLibrary.lua")

if not Library then
    warn("One or more modules failed to load. Script will not continue.")
    return
end

local Configuration = {
    Aimbot = false,
    Smoothing = false,
    SmoothingValue = 0.5
    AimKey = "RMB",
    AimPart = "HumanoidRootPart",
    TeamCheck = false,
    WallCheck = false,
    --Fov
    Fov = false,,
    FovRadius= 100,,
    Fov.NumSides = 650,
    Fov.Thickness = 2
    FovTransparency = 0.5,
    FovColour = Color3.fromRGB(255, 0, 0)
}

local function Visualize(Object)
    if not Fluent or not getfenv().Drawing or not Object then
        warn("UnableToObject")
    elseif string.lower(Object) == "fov" then
        local FoV = getfenv().Drawing.new("Circle")
        FoV.Visible = false
        if FoV.ZIndex then
            FoV.ZIndex = 2
        end
        FoV.Filled = false
        FoV.NumSides = 1000
        FoV.Radius = Configuration.FoVRadius
        FoV.Thickness = Configuration.FoVThickness
        FoV.Transparency = Configuration.FoVTransparency
        FoV.Color = Configuration.FoVColour
        return FoV

warn("true1111")
