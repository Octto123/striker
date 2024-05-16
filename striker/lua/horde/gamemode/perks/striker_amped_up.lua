PERK.PrintName = "Amped Up" -- Name of Perk
PERK.Description = [[Adds {1} maximum Adrenaline stacks.
While at maximum Adrenaline stacks, gain an additional {2} damage and speed.]] -- Description of this perk
PERK.Icon = "materials/perks/phase_walk.png"
PERK.Params = {
    [1] = {value = 2},
    [2] = {value = .12, percent = true},
} -- Used in formatting the description above

PERK.Hooks = {} -- Hooks for perk functionality

PERK.Hooks.Horde_OnSetPerk = function(ply, perk) -- On selecting this Perk, obtain the described benefits
    if SERVER and perk == "striker_amped_up" then
        ply:Horde_SetMaxAdrenalineStack(ply:Horde_GetMaxAdrenalineStack() + 2) -- Increase maximum Adrenaline stacks by 2
        hook.Add("Horde_OnPlayerDamage", "AmpedUp_Damage", function (ply, npc, bonus, hitgroup) -- Creates a new hook and binds it
                                                                                                -- to OnPlayerDamage, which activates
                                                                                                -- if the player deals damage
            if ply:Horde_GetAdrenalineStack() == ply:Horde_GetMaxAdrenalineStack() then -- If on maximum Adrenaline stacks
                bonus.increase = bonus.increase + 2 * 0.06 -- Apply damage forumla
            end
        end)
        
        hook.Add("Horde_PlayerMoveBonus", "AmpedUp_Movespeed", function(ply, bonus_walk, bonus_run) -- Creates a new hook and binds it
                                                                                                    -- to PlayerMoveBonus, which activates
                                                                                                    -- when calculating movement bonuses
            if ply:Horde_GetAdrenalineStack() == ply:Horde_GetMaxAdrenalineStack() then -- If on maximum Adrenaline stacks
                local bonus2 = 2 * 0.06 -- Calculate movespeed bonus
                bonus_walk.increase = bonus_walk.increase + bonus2 -- Apply to walk speed
                bonus_run.increase = bonus_run.increase + bonus2 -- Apply to run speed
            end
        end)
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk) -- On deselecting this Perk, lose the described benefits
    if SERVER and perk == "striker_amped_up" then
        ply:Horde_SetMaxAdrenalineStack(ply:Horde_GetMaxAdrenalineStack() - 2) -- Reduce maximum Adrenaline stacks by 2
        hook.Remove("Horde_OnPlayerDamage", "AmpedUp_Damage") -- Removes the AmpedUp_Damage hook
        hook.Remove("Horde_OnPlayerDamage", "AmpedUp_Movespeed") -- Removes the AmpedUp_Movespeed hook
    end
end