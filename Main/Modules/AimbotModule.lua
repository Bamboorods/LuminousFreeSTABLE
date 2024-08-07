--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

--// Variables
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local AimbotEnabled = false
local AimKey = Enum.KeyCode.T
local AimPart = "HumanoidRootPart"
local TeamCheck = false
local FoVRadius = 400
local ShowFoV = true
local Smoothing = 0.1  -- Lower value for faster smoothing, higher for slower
local WallCheckEnabled = true  -- Set to true to enable wall checking
local PredictionFactor = 0.5  -- Higher value for more prediction, lower for less

local CurrentTarget = nil  
local TargetDirection = Workspace.CurrentCamera.CFrame.LookVector

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

local function isVisible(target)
    if not WallCheckEnabled then
        return true
    end
    
    local camera = Workspace.CurrentCamera
    local targetPos = target.Character[AimPart].Position
    local ray = Ray.new(camera.CFrame.Position, (targetPos - camera.CFrame.Position).unit * 1000)
    local hitPart, hitPosition = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
    
    -- If hitPart is not nil and it's not the target's part, then it's blocked by something
    if hitPart and hitPart:IsDescendantOf(target.Character) == false then
        return false
    end
    return true
end

local function predictPosition(target)
    if not target or not target.Character or not target.Character:FindFirstChild(AimPart) then
        return nil
    end

    local targetPos = target.Character[AimPart].Position
    local targetVelocity = target.Character:FindFirstChild("HumanoidRootPart") and target.Character.HumanoidRootPart.Velocity or Vector3.new(0, 0, 0)
    
    -- Calculate the predicted position
    local predictionTime = (Vector3.new(Mouse.X, Mouse.Y, 0) - targetPos).magnitude / (targetVelocity.magnitude + 1)  -- Adding 1 to avoid division by zero
    local predictedPosition = targetPos + targetVelocity * (predictionTime * PredictionFactor)
    
    return predictedPosition
end

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = FoVRadius

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimPart) and isEnemy(player) then
            local partPos = player.Character[AimPart].Position
            local screenPos, onScreen = Workspace.CurrentCamera:WorldToScreenPoint(partPos)
            if onScreen then
                local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).magnitude
                if distance < shortestDistance and isVisible(player) then
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
        local predictedPos = predictPosition(target)
        if isVisible(target) then
            local cameraPos = Workspace.CurrentCamera.CFrame.Position
            local aimDirection = (predictedPos - cameraPos).unit

            -- Smoothly interpolate the direction
            TargetDirection = TargetDirection:Lerp(aimDirection, Smoothing)
            local newLookVector = TargetDirection
            Workspace.CurrentCamera.CFrame = CFrame.new(cameraPos, cameraPos + newLookVector)
        else
            -- Target is behind a wall, so stop aiming at this target
            CurrentTarget = nil
        end
    else
        -- Target is invalid, so stop aiming
        CurrentTarget = nil
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
        if not CurrentTarget or not CurrentTarget.Character or not CurrentTarget.Character:FindFirstChild(AimPart) or not isVisible(CurrentTarget) then
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
