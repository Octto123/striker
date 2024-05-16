PERK.PrintName = "B.F.D." -- Name of Perk
PERK.Description = [[While Dash is on cooldown, gain {1} bonus damage and movement speed.
Maximum Adrenaline stacks increased by {2}.]] -- Description of this perk
PERK.Icon = "materials/perks/rip_and_tear.png"
PERK.Params = {
    [1] = {value = .15, percent = true},
    [2] = {value = 1},
} -- Used in formatting the description above

PERK.Hooks = {} -- Hooks for perk functionality

PERK.Hooks.Horde_OnSetPerk = function(ply, perk) -- On selecting this Perk, obtain the described benefits
    if SERVER and perk == "striker_bfd" then
        ply:Horde_SetMaxAdrenalineStack(ply:Horde_GetMaxAdrenalineStack() + 1) -- Increase maximum Adrenaline stacks by 1
        hook.Add("Horde_OnPlayerDamage", "BFD_Damage", function (ply, npc, bonus, hitgroup) -- Creates a new hook and binds it
                                                                                            -- to OnPlayerDamage, which activates
                                                                                            -- if the player deals damage
            if not ply.Horde_Dash_Ready then -- If Dash is on cooldown
                bonus.increase = bonus.increase + .15 -- Deal 15% bonus damage
            end
        end)
        
        hook.Add("Horde_PlayerMoveBonus", "BFD_Movespeed", function(ply, bonus_walk, bonus_run) -- Creates a new hook and binds it
                                                                                                -- to PlayerMoveBonus, which activates
                                                                                                -- when calculating movement bonuses
            if not ply.Horde_Dash_Ready then -- If Dash is on cooldown
                local bonus2 = .15 -- Calculate movespeed bonus
                bonus_walk.increase = bonus_walk.increase + bonus2 -- Apply to walk speed
                bonus_run.increase = bonus_run.increase + bonus2 -- Apply to run speed
            end
        end)
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk) -- On deselecting this Perk, lose the described benefits
    if SERVER and perk == "striker_bfd" then
        ply:Horde_SetMaxAdrenalineStack(ply:Horde_GetMaxAdrenalineStack() - 1) -- Reduce maximum Adrenaline stacks by 1
        hook.Remove("Horde_OnPlayerDamage", "BFD_Damage") -- Removes the BFD_Damage hook
        hook.Remove("Horde_PlayerMoveBonus", "BFD_Movespeed") -- Removes the BFD_Movespeed hook
    end
end