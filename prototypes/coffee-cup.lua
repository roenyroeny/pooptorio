local coffeeCup =
{
    type = "item",
    name = "coffee-cup",
    icon = "__pooptorio__/graphics/coffee-cup.png",
    icon_size = 64,
    subgroup = "raw-resource",
    order = "i[coffe-cup]",
    stack_size = 10
}

local coffeeCupRecipe =
{
    type = "recipe",
    name = "coffee-cup",
    category = "crafting-with-fluid",
    ingredients =
    {
        { "stone", 5 },
    },
    energy_required = 10,
    result = "coffee-cup"
}

data:extend({
    coffeeCup,
    coffeeCupRecipe
})
