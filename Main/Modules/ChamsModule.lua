warn("ChamsModuleLoaded")

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

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

local function get_players()
    return Players:GetPlayers()
end

local function is_ally(player)
    return player.Team == LocalPlayer.Team
end

function update_chams()
    for _, player in pairs(get_players()) do
        if player.Character then
            local highlight = player.Character:FindFirstChildWhichIsA("Highlight")
            if ChamsModule.features.chams.enabled then
                local ally = is_ally(player)
                local should_highlight = not ChamsModule.features.chams.teamcheck or (ChamsModule.features.chams.teamcheck and not ally)

                if should_highlight then
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Parent = player.Character
                    end
                    highlight.FillColor = ChamsModule.features.chams.color.fill
                    highlight.OutlineColor = ChamsModule.features.chams.color.outline
                    highlight.FillTransparency = ChamsModule.features.chams.ctransparency.fill
                    highlight.OutlineTransparency = ChamsModule.features.chams.ctransparency.outline
                else
                    if highlight then
                        highlight:Destroy()
                    end
                end
            else
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end

function ChamsModule.setChamsEnabled(value)
    ChamsModule.features.chams.enabled = value
    update_chams()
end

function ChamsModule.setTeamCheckEnabled(value)
    ChamsModule.features.chams.teamcheck = value
    update_chams()
end

function ChamsModule.setFillColor(color)
    ChamsModule.features.chams.color.fill = color
    update_chams()
end

function ChamsModule.setOutlineColor(color)
    ChamsModule.features.chams.color.outline = color
    update_chams()
end

function ChamsModule.setFillTransparency(value)
    ChamsModule.features.chams.ctransparency.fill = value
    update_chams()
end

function ChamsModule.setOutlineTransparency(value)
    ChamsModule.features.chams.ctransparency.outline = value
    update_chams()
end

RunService.RenderStepped:Connect(function()
    if ChamsModule.features.chams.enabled then
        update_chams()
    end
end)

return ChamsModule
