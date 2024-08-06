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


local function onPlayerAdded(player)
    player.CharacterAdded:Connect()
end

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

local function onCharacterLoad(character)
    local highlight = Instance.new("Highlight");

    highlight.FillColor = features.chams.color.fill

    highlight.OutlineColor = features.chams.color.outline

    highlight.FillTransparency = features.chams.transparency.fill

    highlight.OutlineTransparency = features.chams.transparency.outline

    highlight.Parent = character;
end



local function updateChams()
    for _, player in ipairs(get_players()) do
        local highlight = player:FindFirstChild("Highlight")

        if not highlight then
            return;
        end

        if not features.chams.enabled then
            highlight.Visible = false;
            return;
        end

        local ally = is_ally(player)
        local shouldHighlight = not features.chams.teamcheck or (features.chams.teamcheck and not ally)
            
        if not shouldHighlight then
            highlight.Visible = false;
            return
        end

        highlight.Visible = true;
    end
end

function ChamsModule.setChamsEnabled(value)
    features.chams.enabled = value
    updateChams()
end

function ChamsModule.isChamsEnabled()
    return features.chams.enabled
end

Players.PlayerAdded:Connect(onPlayerAdded)

RunService.RenderStepped:Connect(function()
    if features.chams.enabled then
        updateChams()
    end
end)


return ChamsModule {
    setChamsEnabled = ChamsModule.setChamsEnabled,
    isChamsEnabled = ChamsModule.isChamsEnabled,
    onCharacterLoad = onCharacterLoad,
    features = features,
    get_players = get_players,
}
