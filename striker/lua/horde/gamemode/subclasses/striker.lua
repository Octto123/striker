SUBCLASS.PrintName = "Striker" -- Name of Subclass
SUBCLASS.UnlockCost = 25 -- How many skull tokens are required to unlock this class
SUBCLASS.ParentClass = HORDE.Class_Assault -- Parent Class of the Subclass
SUBCLASS.Icon = "subclasses/striker.png" -- Subclass Icon
SUBCLASS.Description = [[
Assault Subclass.
A fast-paced class focused on dashes
and adrenaline.]] -- Description of the Subclass
SUBCLASS.BasePerk = "striker_base" -- Base Perk of the Subclass
SUBCLASS.Perks = {
    [1] = {title = "Impact", choices = {"striker_heavy_impact", "striker_explosive_impact"}},
    [2] = {title = "Stamina", choices = {"striker_no_sweat", "striker_quick_dash"}},
    [3] = {title = "Adrenaline", choices = {"striker_energizing_dash", "striker_amped_up"}},
    [4] = {title = "Speed", choices = {"striker_chain_dash", "striker_bfd"}},
} -- Set of perks for the Subclass