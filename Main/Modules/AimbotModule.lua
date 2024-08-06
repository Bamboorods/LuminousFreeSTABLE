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
local FoVRadius = 100

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
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, aimPos)
    end
end

--// Event Listeners
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == AimKey then
        AimbotEnabled = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == AimKey then
        AimbotEnabled = false
    end
end)

RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = getClosestPlayer()
        aimAt(target)
    end
end)

return {
    Enable = function() AimbotEnabled = true end,
    Disable = function() AimbotEnabled = false end,
    SetAimKey = function(key) AimKey = key end,
    SetAimPart = function(part) AimPart = part end,
    SetTeamCheck = function(enabled) TeamCheck = enabled end,
    SetFoVRadius = function(radius) FoVRadius = radius end
}
