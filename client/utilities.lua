local Utils = {}

local SetTextScale = SetTextScale
local SetTextFont = SetTextFont
local SetTextColour = SetTextColour
local BeginTextCommandDisplayText = BeginTextCommandDisplayText
local SetTextCentre = SetTextCentre
local AddTextComponentSubstringPlayerName = AddTextComponentSubstringPlayerName
local SetTextJustification = SetTextJustification
local EndTextCommandDisplayText = EndTextCommandDisplayText
local SetScriptGfxAlignParams = SetScriptGfxAlignParams
local SetDrawOrigin = SetDrawOrigin
local ResetScriptGfxAlign = ResetScriptGfxAlign
local DrawSprite = DrawSprite 
local ClearDrawOrigin = ClearDrawOrigin

local Settings = require 'config.settings'
local Textures = Settings.Textures

function Utils.getOptionsWidth(options)
    local width = 0.0
    for _, data in pairs(options) do
        local factor = (string.len(data.label)) / 370
        local newWidth = 0.03 + factor

        if newWidth > width then
            width = newWidth
        end
    end

    return width
end

function Utils.drawOption(coords, text, spriteDict, spriteName, row, width, showDot)
    SetScriptGfxAlignParams((showDot == true and 0.03 or 0.018) + (width / 2), row * 0.03 - 0.0125, 0.0, 0.0)
    SetTextScale(0, 0.3)
    SetTextFont(4)
    SetTextColour(255, 255, 255, 255)
    BeginTextCommandDisplayText("STRING")
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    SetTextJustification(0)
    EndTextCommandDisplayText(0.0, 0.0)
    ResetScriptGfxAlign()

    SetScriptGfxAlignParams((showDot == true and 0.03 or 0.018) + (width / 2), row * 0.03 - 0.015, 0.0, 0.0)
    DrawSprite(spriteDict, spriteName, 0.0, 0.014, width, 0.025, 0.0, 255, 255, 255, 255)
    ResetScriptGfxAlign()

    if showDot then
        local newSpritename = spriteName == Textures.selected and Textures.select_opt or Textures.unselect_opt
        SetScriptGfxAlignParams(0.018, row * 0.03 - 0.015, 0.0, 0.0)
        DrawSprite(spriteDict, newSpritename, 0.0, 0.014, 0.01, 0.02, 0.0, 255, 255, 255, 255)
        ResetScriptGfxAlign()
    end

    ClearDrawOrigin()
end

local DoesEntityExist = DoesEntityExist
local GetEntityBonePosition_2 = GetEntityBonePosition_2
local GetEntityBoneIndexByName = GetEntityBoneIndexByName
local GetOffsetFromEntityInWorldCoords = GetOffsetFromEntityInWorldCoords
local IsEntityAPed = IsEntityAPed
local GetEntityCoords = GetEntityCoords

function Utils.getCoordsFromInteract(interaction)
    if interaction.entity then
        if DoesEntityExist(interaction.entity) then
            if interaction.bone then
                return GetEntityBonePosition_2(interaction.entity, GetEntityBoneIndexByName(interaction.entity, interaction.bone))
            elseif interaction.model then
                return GetOffsetFromEntityInWorldCoords(interaction.entity, 0.0 + interaction.offset.x, 0.0 + interaction.offset.y, 0.0 + interaction.offset.z)
            else
                if IsEntityAPed(interaction.entity) then
                    if interaction.offset and interaction.offset ~= vec3(0.0, 0.0, 0.0) then
                        return GetOffsetFromEntityInWorldCoords(interaction.entity, 0.0 + interaction.offset.x, 0.0 + interaction.offset.y, 0.0 + interaction.offset.z)
                    end
                    return GetEntityBonePosition_2(interaction.entity, 0) -- SKEL_ROOT
                else
                    if interaction.offset and interaction.offset ~= vec3(0.0, 0.0, 0.0) then
                        return GetOffsetFromEntityInWorldCoords(interaction.entity, 0.0 + interaction.offset.x, 0.0 + interaction.offset.y, 0.0 + interaction.offset.z)
                    end
                    return GetEntityCoords(interaction.entity)
                end
            end
        end
    end

    return vec3(0.0, 0.0, 0.0)
end












return Utils