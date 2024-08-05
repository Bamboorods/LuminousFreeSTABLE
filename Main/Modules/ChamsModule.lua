local ChamsModule = {}
warn("ChamsModuleLoaded")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer


ChamsModule.features = {
    chams = {
        enabled = false,
        teamcheck = false,
        color = {
            fill = Color3.new(1, 1, 1),
            outline = Color3.new(0, 0, 0)
        },
        fill = {
            transparency = 0.5
        },
        transparency = {
            outline = 0.5
        }
    }
}

local function get_players()
    return Players:GetPlayers()
end

local function is_ally(player)
    return player.Team == LocalPlayer.Team
end

local function update_chams()
    for _, player in pairs(get_players()) do
        local highlight = player:FindFirstChildWhichIsA("Highlight")
        if features.chams.enabled then
            local ally = is_ally(player)
            local should_highlight = not features.chams.teamcheck or (features.chams.teamcheck and not ally)
            
            if should_highlight then
                if not highlight then
                    highlight = Instance.new("Highlight", player)
                end
                highlight.FillColor = features.chams.color.fill
                highlight.OutlineColor = features.chams.color.outline
                highlight.FillTransparency = features.chams.transparency.fill
                highlight.OutlineTransparency = features.chams.transparency.outline
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
    ChamsModule.features.chams.transparency.fill = value
    update_chams()
end

function ChamsModule.setOutlineTransparency(value)
    ChamsModule.features.chams.transparency.outline = value
    update_chams()
end

return ChamsModule
