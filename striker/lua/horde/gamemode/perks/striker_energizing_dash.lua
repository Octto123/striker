PERK.PrintName = "Energizing Dash" -- Name of Perk
PERK.Description = [[Adds {1} maximum Adrenaline stacks.
Dash grants {2} stack of adrenaline.]] -- Description of this perk
PERK.Icon = "materials/perks/haste.png"
PERK.Params = {
    [1] = {value = 3},
    [2] = {value = 2},
} -- Used in formatting the description above

PERK.Hooks = {} -- Hooks for perk functionality

PERK.Hooks.Horde_OnSetPerk = function(ply, perk) -- On selecting this Perk, obtain the described benefits
    if SERVER and perk == "striker_energizing_dash" then
        ply:Horde_SetMaxAdrenalineStack(ply:Horde_GetMaxAdrenalineStack() + 3) -- Increase maximum Adrenaline stacks by 3
        ply.Horde_Energizing_Dash_Ready = true -- Set Energizing Dash to true so that the perk can be activated
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk) -- On deselecting this Perk, lose the described benefits
    if SERVER and perk == "striker_energizing_dash" then
        ply:Horde_SetMaxAdrenalineStack(ply:Horde_GetMaxAdrenalineStack() - 3) -- Reduce maximum Adrenaline stacks by 3
        ply.Horde_Energizing_Dash_Ready = nil -- Set Energizing Dash to nil so that the perk cannot be activated
    end
end

PERK.Hooks.PlayerButtonDown = function (ply, key) -- Hook for Energizing Dash to activate on pressing middle mouse
    if key == MOUSE_MIDDLE and ply:IsOnGround() and ply.Horde_Energizing_Dash_Ready then -- If Energizing Dash is ready, player is 
                                                                                         -- on the ground, and middle mouse is pressed
        ply.Horde_Energizing_Dash_Ready = nil -- Set Energizing Dash ready to false to prevent chain Adrenaline stacks
        ply:Horde_AddAdrenalineStack() -- Add an Adrenaline Stack
        ply:Horde_AddAdrenalineStack() -- Add an Adrenaline Stack
        timer.Simple(ply.Dash_Cooldown+1, function() -- Starts a timer to enforce Energizing Dash cooldown
                                                     -- (cooldown+1 seems to achieve desired cooldown duration)
            ply.Horde_Energizing_Dash_Ready = true -- Set Energizing Dash to ready to enable Adrenaline gain agian
        end)
    end
end