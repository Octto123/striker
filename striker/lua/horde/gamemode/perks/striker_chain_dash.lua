PERK.PrintName = "Chain Dash" -- Name of Perk
PERK.Description = [[Killing an enemy starts a Chain Dash for {1} seconds. ({2} second cooldown)
Chain Dash reduces Dash cooldown to {3} seconds.
Having the Quick Dash Perk further reduces the cooldown to {4} second.]] -- Description of this perk
PERK.Icon = "materials/perks/symbiosis.png"

PERK.Params = {
    [1] = {value = 6},
    [2] = {value = 18},
    [3] = {value = 2},
    [4] = {value = 1},
} -- Used in formatting the description above

PERK.Hooks = {} -- Hooks for perk functionality

PERK.Hooks.Horde_OnSetPerk = function(ply, perk) -- On selecting this Perk, obtain the described benefits
    if SERVER and perk == "striker_chain_dash" then
        ply.Horde_Chain_Dash_Ready = true -- Set Chain Dash to true so that the perk can be activated
        HORDE.Status_Chain_Dash_Active = 23 -- Sets the image for Chain Dash buff status indicator
        HORDE.Status_Chain_Dash_Cooldown = 2 -- Sets the image for Chain Dash cooldown status indicator
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk) -- On deselecting this Perk, lose the described benefits
    if SERVER and perk == "striker_chain_dash" then
        ply.Horde_Chain_Dash_Ready = nil -- Set Chain Dash to nil so that the perk cannot be activated
    end
end

PERK.Hooks.Horde_OnEnemyKilled = function(victim, killer, wpn) -- Hook that triggers when killing an enemy
    if killer:IsPlayer() and killer:Horde_GetPerk("striker_chain_dash") and killer.Horde_Chain_Dash_Ready then -- If the killer is a player
                                                                                                             -- with the Chain Dash perk,
                                                                                                             -- and Chain Dash is ready
        local Dash_Cooldown_Curr = killer.Dash_Cooldown -- Saves the value of the current Dash cooldown
        killer.Horde_Chain_Dash_Ready = nil -- Set Chain Dash ready to nil to prevent multiple activations
        net.Start("Horde_SyncStatus") -- Sends Chain Dash active status to the screen, adding the icon indicating that Chain Dash
                                      -- is active
            net.WriteUInt(HORDE.Status_Chain_Dash_Active, 8) -- Selects the Chain Dash Active status
            net.WriteUInt(1, 8) -- 1 adds the indicator
        net.Send(killer) -- Sends to the server
        timer.Create("ChainDashCooldown", 24, 1, function () -- Starts a timer to enforce Chain Dash cooldown
            killer.Horde_Chain_Dash_Ready = true -- Set Chain Dash to ready to allow the perk to activate again
            net.Start("Horde_SyncStatus") -- Removes Dash cooldown status indicator, removing the icon indicating that Dash is not ready
                net.WriteUInt(HORDE.Status_Chain_Dash_Cooldown, 8) -- Selects the Chain Dash cooldown status
                net.WriteUInt(0, 8) -- 0 removes the indicator
            net.Send(killer) -- Sends to the server
        end)
        timer.Create("ChainDashBuff", 6, 1, function () -- Starts a timer to enforce Chain Dash duration
            killer.Dash_Cooldown = Dash_Cooldown_Curr -- Sets Dash cooldown back to previous value
            net.Start("Horde_SyncStatus") -- Removes Spin Dash status indicator, removing the icon indicating that Dash is active
                net.WriteUInt(HORDE.Status_Chain_Dash_Active, 8) -- Selects the Chain Dash Active status
                net.WriteUInt(0, 8) -- 0 removes the indicator
            net.Send(killer) -- Sends to the server
            net.Start("Horde_SyncStatus") -- Sends Chain Dash Cooldown status to the screen, adding the icon indicating that Chain Dash
                                          -- is on cooldown
                net.WriteUInt(HORDE.Status_Chain_Dash_Cooldown, 8) -- Selects the Chain Dash cooldown status
                net.WriteUInt(1, 8) -- 1 adds the indicator
            net.Send(killer) -- Sends to the server
        end)
        killer.Horde_Dash_Ready = true -- Sets the Dash ready, so that we can use the dash immediately once this perk activates
        killer.Horde_Dash_Dmg_Ready = true -- Sets the Dash Dmg ready, so that damage can be done on next dash
        if killer:Horde_GetPerk("striker_no_sweat") then -- If the player has the No Sweat perk, set No Sweat ready so that regen can
                                                       -- be applied on the next dash
            killer.Horde_No_Sweat_Ready = true
        end
        if killer:Horde_GetPerk("striker_quick_dash") then -- If quick dash is selected, set the dash cooldown to 1 second
            killer.Dash_Cooldown = 1
        else
            killer.Dash_Cooldown = 2 -- Otherwise, set the dash cooldown to 2 seconds
        end
    end
end