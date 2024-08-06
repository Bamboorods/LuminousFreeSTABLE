local ChamsModule = {chams = {
    enabled = false,
    teamcheck = false,
    color = {fill = Color3.fromRGB(0, 7, 167), outline = Color3.fromRGB(0, 18, 64)},
    transparency = {fill = 0.74, outline = 0.38}
}}

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

    highlight.FillColor = ChamsModule.chams.color.fill

    highlight.OutlineColor = ChamsModule.chams.color.outline

    highlight.FillTransparency = ChamsModule.chams.transparency.fill

    highlight.OutlineTransparency = ChamsModule.chams.transparency.outline

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
        local character = player.Character
        if character then
            if not characterEventOn then
                assignHighlight(character)
            else
                local highlight = character:FindFirstChild("Highlight")
                if not highlight then
                    assignHighlight(character)
                    highlight = character:FindFirstChild("Highlight")
                end

                if not ChamsModule.chams.enabled then
                    highlight.Visible = false
                else
                    local shouldHighlight = not ChamsModule.chams.teamcheck or (ChamsModule.chams.teamcheck and not is_ally(player))
                    highlight.Visible = shouldHighlight
                end
            end
        end
    end
    characterEventOn = true
end

function ChamsModule:setChamsEnabled(value)
    ChamsModule.chams.enabled = value
    updateChams()
end

function ChamsModule.isChamsEnabled()
    return ChamsModule.chams.enabled
end

Players.PlayerAdded:Connect(onPlayerAdded)

RunService.RenderStepped:Connect(function()
    updateChams()
end)


return ChamsModule
