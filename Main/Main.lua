--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Teams = game:GetService("Teams")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

--// Variables
-- Player Variables
    local LocalPlayer = Players.LocalPlayer
    local LocalGui = StarterGui:WaitForChild("PlayerGui")
    local LocalChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = char:FindFirstChildOfClass("Humanoid")
    local playerTeam = Teams:FindFirstChild("DefaultTeam")

-- World Variables
    local CurrentCamera = Workspace.CurrentCamera

--// Modules

--// Tables

--// Functions

--// Logic

--// UI


