local ChamsModule = {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or game.Players.LocalPlayer
local characterEventOn = false;



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

    highlight.FillColor = shared.chams.color.fill

    highlight.OutlineColor = shared.chams.color.outline

    highlight.FillTransparency = shared.chams.transparency.fill

    highlight.OutlineTransparency = shared.chams.transparency.outline

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

        if not shared.chams.enabled then
            highlight.Visible = false;
            return;
        end

        local shouldHighlight = not shared.chams.teamcheck or (shared.chams.teamcheck and not is_ally(player))

        highlight.Visible = shouldHighlight;
    end
    characterEventOn = true;
end

function ChamsModule:setChamsEnabled(value)
    ChamsModule.chams.enabled = value
end

function ChamsModule.isChamsEnabled()
    return ChamsModule.chams.enabled
end

Players.PlayerAdded:Connect(onPlayerAdded)

RunService.RenderStepped:Connect(function()
    updateChams()
end)


return ChamsModule
