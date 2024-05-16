PERK.PrintName = "Explosive Impact" -- Name of Perk
PERK.Description = [[Upon colliding with an enemy, Dash deals {1} damage
to enemies in a {2} HU radius.]] -- Description of this perk
PERK.Icon = "materials/perks/seismic_wave.png"
PERK.Params = {
    [1] = {value = 120},
    [2] = {value = 200},
} -- Used in formatting the description above

PERK.Hooks = {} -- Hooks for perk functionality

PERK.Hooks.Horde_OnSetPerk = function(ply, perk) -- On selecting this Perk, obtain the described benefits
    if SERVER and perk == "striker_explosive_impact" then
        ply.Horde_Dash_Dmg_Ready = true -- Set Dash Damage to ready (used to ensure damage is only dealt once)
        hook.Add("ShouldCollide", "ExplosiveImpact", function(ent1, ent2) -- Creates a new hook and binds it to ShouldCollide, which
                                                                          -- checks if two entities will collide given current velocity
            local ply = nil -- Creates a ply to represent the player
            local ent = nil -- Creates an ent to represent the entity being collided with
            if ent1:IsPlayer() and ent2:IsNPC() then -- Case where ent1 is the player
                ply = ent1
                ent = ent2
            elseif ent2:IsPlayer() and ent1:IsNPC() then -- Case where ent2 is the player
                ply = ent2
                ent = ent1
            else
                return -- Case where neither are the player
            end
            if not ply.Horde_Dash_Ready and ply.Horde_Dash_Dmg_Ready then -- If Dash is on cooldown and
                                                                                    -- damage has not been dealt
                ply.Horde_Dash_Dmg_Ready = nil -- Set Dash Damage ready to nil so that damage is only dealt once
                if (ply:IsPlayer() and ent:IsNPC()) then -- Additional check to ensure that the ply is the player and ent is the NPC
                    local dmginfo = DamageInfo() -- Creates a DamageInfo for single target damage to be applied to the entity
                    dmginfo:SetAttacker(ply) -- Attacker is the player
                    dmginfo:SetInflictor(ply) -- Inflictor is the player
                    dmginfo:SetDamageType(DMG_GENERIC) -- Generic damage type
                    dmginfo:SetDamage(120) -- Set the damage inflicted to 120
                    HORDE:ApplyDamageInRadius(ply:GetPos(), 200, dmginfo, callback) -- Applies damage to all enemies in the radius
                    local e = EffectData() -- Generates a visual and audio effect for the Explosive Impact
                        e:SetNormal(Vector(0,0,1))
                        e:SetOrigin(ply:GetPos())
                        e:SetRadius(200)
                    util.Effect("seismic_wave", e, true, true)
                end
            end
        end)
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk) -- On deselecting this Perk, lose the described benefits
    if SERVER and perk == "striker_explosive_impact" then
        hook.Remove("ShouldCollide", "ExplosiveImpact") -- Removes the ExplosiveImpact hook
        ply.Horde_Dash_Dmg_Ready = nil -- Sets Dash Damage Ready to nil so that damage cannot be dealt with the dash
    end
end