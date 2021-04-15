local coffee =
{
    type = "fluid",
    name = "coffee",
    default_temperature = 80,
    max_temperature = 100,
    heat_capacity = "0.2KJ",
    base_color = { r = 0, g = 0, b = 0 },
    flow_color = { r = 0, g = 0, b = 0 },
    icon = "__pooptorio__/graphics/coffee.png",
    icon_size = 32,
    order = "f[coffee]"
}


local coffeeRecipe =
{
    type = "recipe",
    name = "coffee",
    category = "chemistry",
    enabled = false,
    energy_required = 1,
    ingredients =
    {
        { type = "fluid", name = "water", amount = 50 },
        { type = "fluid", name = "crude-oil", amount = 100 }
    },
    results =
    {
        { type = "fluid", name = "coffee", amount = 10, temperature = 80 }
    },
    subgroup = "fluid-recipes",
    crafting_machine_tint =
    {
        primary = {r = 0.000, g = 0.000, b = 0.000, a = 1.000},
        secondary = {r = 0.200, g = 0.200, b = 0.200, a = 1.000},
        tertiary = {r = 0.500, g = 0.500, b = 0.500, a = 1.000},
        quaternary = {r = 1.000, g =1.000, b = 1.000, a = 1.000},
    }
}

data:extend({
    coffee,
    coffeeRecipe
})