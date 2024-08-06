local ChamsModule = {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local characterEventOn = false;
local features = {
    chams = {
        enabled = false,
        teamcheck = false,
        color = {fill = Color3.fromRGB(0, 7, 167), outline = Color3.fromRGB(0, 18, 64)},
        transparency = {fill = 0.74, outline = 0.38}
    }
}



local function get_players()
    --[[
    local entity_list = {}
    for _, player in ipairs() do
        if player:IsA("Model") then
            table.insert(entity_list, player)
        end
    end ]]
    return Players:GetPlayers()
end

local function is_ally(player)
    if not player then return false end

    local helmet = player:FindFirstChildWhichIsA("Folder"):FindFirstChildOfClass("MeshPart")
    if not helmet then return false end

    return helmet.BrickColor == BrickColor.new("Black") and LocalPlayer.Team == "Phantoms" or LocalPlayer.Team == "Ghosts"
end

local function assignHighlight(character)
    local highlight = Instance.new("Highlight");

    highlight.FillColor = features.chams.color.fill

    highlight.OutlineColor = features.chams.color.outline

    highlight.FillTransparency = features.chams.transparency.fill

    highlight.OutlineTransparency = features.chams.transparency.outline

    highlight.Parent = character;
end



local function onCharacterAdded(character)
    assignHighlight(character);
end


local function onPlayerAdded(player)
    player.CharacterAdded:Connect(onCharacterAdded)
end

local function updateChams()
    for _, player in ipairs(get_players()) do
        
        if not characterEventOn then
            assignHighlight(player.Character)
            return;
        end


        local highlight = player:FindFirstChild("Highlight")


        if not highlight then
            return;
        end

        if not features.chams.enabled then
            highlight.Visible = false;
            return;
        end

        local shouldHighlight = not features.chams.teamcheck or (features.chams.teamcheck and not is_ally(player))
            
        if not shouldHighlight then
            highlight.Visible = false;
            return
        end

        highlight.Visible = true;
    end
    characterEventOn = true;
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


return ChamsModule
