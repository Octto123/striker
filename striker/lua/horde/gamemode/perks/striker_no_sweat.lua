PERK.PrintName = "No Sweat" -- Name of Perk
PERK.Description = [[Dash grants {1} health regeneration for {2} seconds.]] -- Description of this perk
PERK.Icon = "materials/perks/charge.png"
PERK.Params = {
    [1] = {value = .02, percent = true},
    [2] = {value = 5},
} -- Used in formatting the description above

PERK.Hooks = {} -- Hooks for perk functionality

PERK.Hooks.Horde_OnSetPerk = function(ply, perk) -- On selecting this Perk, obtain the described benefits
    if SERVER and perk == "striker_no_sweat" then
        ply.Horde_No_Sweat_Ready = true -- Sets No Sweat Ready to true so that the perk can be activated
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk) -- On deselecting this Perk, lose the described benefits
    if SERVER and perk == "striker_no_sweat" then
        ply.Horde_No_Sweat_Ready = nil -- Sets No Sweat Ready to nil so that the perk cannot be activated
        ply:Horde_SetHealthRegenPercentage(0) -- Removes the HealthRegen granted by this perk to prevent edge classname
                                              -- where the player removes the perk while having health regeneration
    end
end

PERK.Hooks.PlayerButtonDown = function (ply, key) -- Hook for No Sweat to activate on pressing middle mouse
    if key == MOUSE_MIDDLE and ply:IsOnGround() and ply.Horde_No_Sweat_Ready then -- If No Sweat is ready, player is on the ground,
                                                                                  -- and middle mouse is pressed
        ply.Horde_No_Sweat_Ready = nil -- Set No Sweat ready to nil to prevent chain regen
        ply:Horde_SetHealthRegenPercentage(0.02) -- Set the health regen rate to 2% per second
        timer.Simple(ply.Dash_Cooldown+1, function() -- Starts a timer to enforce No Sweat cooldown
                                                     -- (cooldown+1 seems to achieve desired cooldown duration)
            ply.Horde_No_Sweat_Ready = true -- Set No Sweat to ready to enable regen agian
            ply:Horde_SetHealthRegenPercentage(0) -- Set heath regen rate to 0% so that the player loses the benefit of the perk
                                                  -- until they dash again
        end)
    end
end