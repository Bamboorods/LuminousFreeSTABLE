local AimbotModule = {}

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

--// Variables
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local AimbotEnabled = false
local AimKey = Enum.KeyCode.V
local AimPart = "HumanoidRootPart"
local TeamCheck = false
local FoVRadius = 700
local ShowFoV = false
local Smoothing = 10 

local CurrentTarget = nil  

--// Drawing
local FoVCircle = Drawing.new("Circle")
FoVCircle.Thickness = 2
FoVCircle.NumSides = 32
FoVCircle.Radius = FoVRadius
FoVCircle.Filled = false
FoVCircle.Transparency = 0.8
FoVCircle.Color = Color3.fromRGB(255, 255, 255)

--// Functions
local function isEnemy(player)
    if TeamCheck then
        return player.Team ~= LocalPlayer.Team
    end
    return true
end

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = FoVRadius

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimPart) and isEnemy(player) then
            local partPos = player.Character[AimPart].Position
            local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(partPos)
            if onScreen then
                local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).magnitude
                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end

    return closestPlayer
end

local function aimAt(target)
    if target and target.Character and target.Character:FindFirstChild(AimPart) then
        local aimPos = target.Character[AimPart].Position
        local cameraPos = workspace.CurrentCamera.CFrame.Position
        local currentLookVector = workspace.CurrentCamera.CFrame.LookVector
        local aimDirection = (aimPos - cameraPos).unit
        local newLookVector = currentLookVector:Lerp(aimDirection, math.clamp(1 / Smoothing, 0.1, 1)) 
        workspace.CurrentCamera.CFrame = CFrame.new(cameraPos, cameraPos + newLookVector)
    end
end

--// Event Listeners
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == AimKey then
        AimbotEnabled = true
        CurrentTarget = nil  
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == AimKey then
        AimbotEnabled = false
        CurrentTarget = nil  
    end
end)

RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        if not CurrentTarget or not CurrentTarget.Character or not CurrentTarget.Character:FindFirstChild(AimPart) then
            CurrentTarget = getClosestPlayer()
        end

        aimAt(CurrentTarget)
    end
    if ShowFoV then
        FoVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
        FoVCircle.Radius = FoVRadius
        FoVCircle.Visible = true
    else
        FoVCircle.Visible = false
    end
end)



return AimbotModule{
    Enable = function() AimbotEnabled = true end,
    Disable = function() AimbotEnabled = false end,
    SetAimKey = function(key) AimKey = key end,
    SetAimPart = function(part) AimPart = part end,
    SetTeamCheck = function(enabled) TeamCheck = enabled end,
    SetFoVRadius = function(radius) FoVRadius = radius end,
    SetSmoothing = function(value) Smoothing = value end,
    ShowFoV = function(show) ShowFoV = show end
}
