--// Services
local Players_service = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local Teams = game:GetService("Teams")
local RunService = game:GetService("RunService")

local player = Players_service.LocalPlayer or Players_service.LocalPlayer:wait();

--// Tables
ChamsModule = {}
ChamsModule.features = {
    chams = {
        enabled = false,
        teamcheck = false,
        color = {
            fill = Color3.fromRGB(0, 7, 167),
            outline = Color3.fromRGB(0, 18, 64)
        },
        ctransparency = {
            fill = 0.74,
            outline = 0.38
        }
    }
}

--// Functions
local function get_players()
    return Players_service:GetPlayers() 
end

local function is_ally(player)
    return player.Team == LocalPlayer.Team
end

function update_chams()
    for _, player in pairs(get_players()) do
        if player.Character or player.CharacterAdded:wait() then
            local highlight = player.Character:FindFirstChildWhichIsA("Highlight")
            if ChamsModule.features.chams.enabled then
                local ally = is_ally(player)
                local should_highlight = not ChamsModule.features.chams.teamcheck or (ChamsModule.features.chams.teamcheck and not ally)

                if should_highlight then
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Parent = player
                        print("Highlight created for player:", player.Name)
                    end
                    highlight.FillColor = ChamsModule.features.chams.color.fill
                    highlight.OutlineColor = ChamsModule.features.chams.color.outline
                    highlight.FillTransparency = ChamsModule.features.chams.ctransparency.fill
                    highlight.OutlineTransparency = ChamsModule.features.chams.ctransparency.outline
                else
                    if highlight then
                        highlight:Destroy()
                        print("Highlight destroyed for player:", player.Name)
                    end
                end
            else
                if highlight then
                    highlight:Destroy()
                    print("Highlight destroyed for player:", player.Name)
                end
            end
        else
            print("Player character not found for player:", player.Name)
        end
    end
end

function ChamsModule.setChamsEnabled(value)
    ChamsModule.features.chams.enabled = value
end

function ChamsModule.setTeamCheckEnabled(value)
    ChamsModule.features.chams.teamcheck = value
end

function ChamsModule.setFillColor(color)
    ChamsModule.features.chams.color.fill = color
end

function ChamsModule.setOutlineColor(color)
    ChamsModule.features.chams.color.outline = color
end

function ChamsModule.setFillTransparency(value)
    ChamsModule.features.chams.ctransparency.fill = value
end

function ChamsModule.setOutlineTransparency(value)
    ChamsModule.features.chams.ctransparency.outline = value
end

RunService.RenderStepped:Connect(function()
    if ChamsModule.features.chams.enabled then
        update_chams()
    end
end)
warn("ChamsModuleLoaded")
return ChamsModule
