local sounds = require ("__base__.prototypes.entity.sounds")

local cupOfCoffee =
{
    type = "capsule",
    name = "cup-of-coffee",
    icon = "__pooptorio__/graphics/cup-of-coffee.png",
    icon_size = 64,
    subgroup = "raw-resource",
    capsule_action =
    {
        type = "use-on-self",
        attack_parameters =
        {
            type = "projectile",
            activation_type = "consume",
            ammo_category = "capsule",
            cooldown = 30,
            range = 0,
            ammo_type =
            {
                category = "capsule",
                target_type = "position",
                action =
                {
                    type = "direct",
                    action_delivery =
                    {
                        type = "instant",
                        target_effects =
                        {
                            {
                                type = "play-sound",
                                sound = sounds.eat_fish
                            }
                        }
                    }
                }
            }
        }
    },
    order = "k[cup-of-coffee]",
    stack_size = 10
}

local cupOfCoffeeRecipe =
{
    type = "recipe",
    name = "cup-of-coffee",
    category = "chemistry",
    ingredients =
    {
        { "coffee-cup", 1 },
        { type = "fluid", name = "coffee", amount = 100 }
    },
    energy_required = 10,
    result = "cup-of-coffee",
    subgroup = "raw-resource",
    crafting_machine_tint =
    {
        primary = {r = 0.000, g = 0.000, b = 0.000, a = 1.000},
        secondary = {r = 0.200, g = 0.200, b = 0.200, a = 1.000},
        tertiary = {r = 0.500, g = 0.500, b = 0.500, a = 1.000},
        quaternary = {r = 1.000, g =1.000, b = 1.000, a = 1.000},
    }
}

data:extend({
    cupOfCoffee,
    cupOfCoffeeRecipe
})
