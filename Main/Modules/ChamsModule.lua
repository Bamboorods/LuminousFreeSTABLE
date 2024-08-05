local ChamsModule = {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local features = {
    chams = {
        enabled = false,
        teamcheck = false,
        color = {fill = Color3.fromRGB(0, 7, 167), outline = Color3.fromRGB(0, 18, 64)},
        transparency = {fill = 0.74, outline = 0.38}
    }
}

local function get_players()
    local entity_list = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player:IsA("Model") then
            table.insert(entity_list, player)
        end
    end
    return entity_list
end

local function is_ally(player)
    if not player then return false end

    local helmet = player:FindFirstChildWhichIsA("Folder"):FindFirstChildOfClass("MeshPart")
    if not helmet then return false end

    return helmet.BrickColor == BrickColor.new("Black") and LocalPlayer.Team == "Phantoms" or LocalPlayer.Team == "Ghosts"
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
    features.chams.enabled = value
    update_chams()
end

function ChamsModule.isChamsEnabled()
    return features.chams.enabled
end

RunService.RenderStepped:Connect(function()
    if features.chams.enabled then
        update_chams()
    end
end)

return ChamsModule
