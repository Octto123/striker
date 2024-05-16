PERK.PrintName = "Quick Dash" -- Name of Perk
PERK.Description = [[Dash cooldown reduced by {1} seconds.]] -- Description of this perk
PERK.Icon = "materials/perks/cardiac_overload.png"
PERK.Params = {
    [1] = {value = 3},
} -- Used in formatting the description above

PERK.Hooks = {} -- Hooks for perk functionality

PERK.Hooks.Horde_OnSetPerk = function(ply, perk) -- On selecting this Perk, obtain the described benefits
    if SERVER and perk == "striker_quick_dash" then
        ply.Dash_Cooldown = 2 -- Set Dash cooldown to 2 seconds
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk) -- On deselecting this Perk, lose the described benefits
    if SERVER and perk == "striker_quick_dash" then
        ply.Dash_Cooldown = 5 -- Set Dash cooldown back to 5 seconds
    end
end