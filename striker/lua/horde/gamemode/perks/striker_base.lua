--[[
File contains the code for the base perk of the Striker Subclass of the Assault Class.
]]--

PERK.PrintName = "Striker Base" -- Name of Perk
PERK.Description = [[
The Striker class is a nimble fighter focused on speed and dashing.
Complexity: MEDIUM

{1} more movement speed. ({2} per level, up to {3}).
Press MMB to Dash, launching forwards ({4} second cooldown).

Gain Adrenaline when you kill an enemy.
Adrenaline increases damage and speed by {5}.]] -- Description of Base Perk (what you recieve for picking this subclass as a baseline)

PERK.Params = { -- Used in formatting the description above
    [1] = {percent = true, level = 0.008, max = 0.20, classname = "Striker"},
    [2] = {value = 0.008, percent = true},
    [3] = {value = 0.20, percent = true},
    [4] = {value = 5},
    [5] = {value = 0.06, percent = true},
}

PERK.Hooks = {} -- Hooks for perk functionality

PERK.Hooks.Horde_OnSetPerk = function(ply, perk) -- On selecting this subclass, obtain base perks
    if SERVER and perk == "striker_base" then
        ply.Dash_Cooldown = 5 -- Set base Dash cooldown
        ply.Horde_Dash_Ready = true -- Set Dash to ready
        HORDE.Status_Dash_Ready = 48 -- Sets the image for Dash Ready status indicator
        ply:Horde_SetMaxAdrenalineStack(ply:Horde_GetMaxAdrenalineStack() + 1) -- Increase maximum Adrenaline stacks by 1
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk) -- On deselecting this subclass, lose base perks
    if SERVER and perk == "striker_base" then
        ply.Dash_Cooldown = nil -- Set base Dash cooldown to nil (cannot use Dash without base perk)
        ply.Horde_Dash_Ready = nil -- Set Dash to nil so that players without base perk cannot Dash
        ply:Horde_SetMaxAdrenalineStack(ply:Horde_GetMaxAdrenalineStack() - 1) -- Decrease maximum Adrenaline stacks by 1
    end
end

PERK.Hooks.Horde_PrecomputePerkLevelBonus = function (ply) -- Calculation for any perk formulas
    if SERVER then
        ply:Horde_SetPerkLevelBonus("striker_base", 1 + math.min(0.20, 0.008 * ply:Horde_GetLevel("Striker"))) -- Formula described in
    end                                                                                                    -- base perk description
end

PERK.Hooks.Horde_PlayerMoveBonus = function(ply, bonus_walk, bonus_run) -- Movespeed bonus that increases with level
    if not ply:Horde_GetPerk("striker_base") then return end
    bonus_walk.more = bonus_walk.more * ply:Horde_GetPerkLevelBonus("striker_base") -- Increases walk speed proportional to level
    bonus_run.more = bonus_run.more * ply:Horde_GetPerkLevelBonus("striker_base") -- Increases run speed proportional to level
end

PERK.Hooks.PlayerButtonDown = function (ply, key) -- Hook for Dash to activate on pressing middle mouse
    if key == MOUSE_MIDDLE and ply:IsOnGround() and ply.Horde_Dash_Ready then -- If Dash is ready, player is on the ground,
                                                                                   -- and middle mouse is pressed
        ply.Horde_Dash_Ready = false -- Set Dash ready to false to prevent chain dashing
        net.Start("Horde_SyncStatus") -- Removes Dash Status indicator, removing the icon indicating that Dash is not ready
                net.WriteUInt(HORDE.Status_Dash_Ready, 8) -- Selects the Dash Ready status
                net.WriteUInt(0, 8) -- 0 removes the indicator
            net.Send(ply) -- Sends to the server
        local dir = ply:GetAimVector() * 10 -- Obtain direction that the player is looking
        dir = dir * Vector(1,1,0) -- Remove Z-axis component of vector
        local vel = dir * math.max(590, (ply:GetVelocity():Length()) + 250) -- Calculate desired player's velocity for Dash
        ply:SetLocalVelocity(vel) -- Set player's velocity to desired value (this is the dash)
        local e = EffectData() -- Creates a visual and audio effect for the Dash
            e:SetNormal(Vector(0,0,1))
            e:SetOrigin(ply:GetPos())
            e:SetRadius(200)
        util.Effect("seismic_wave", e, true, true)
        timer.Simple(ply.Dash_Cooldown+1, function() -- Starts a timer to enforce Dash cooldown
                                                     -- (cooldown+1 seems to achieve desired cooldown duration)
            net.Start("Horde_SyncStatus") -- Sends Cooldown status to the screen, adding the icon indicating that Dash is ready
                net.WriteUInt(HORDE.Status_Dash_Ready, 8) -- Selects the Dash Ready status
                net.WriteUInt(1, 8) -- 1 adds the indicator
            net.Send(ply) -- Sends to the server
            ply.Horde_Dash_Ready = true -- Set Dash to ready to enable dashing agian
            ply.Horde_Dash_Dmg_Ready = true -- Set Dash Damage to true so that Dash may deal damage again 
                                                 -- (see striker_heavy_impact.lua and striker_explosive_impact.lua)
        end)
    end
end