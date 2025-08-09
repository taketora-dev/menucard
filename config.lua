Config = {}
Config.Debug = false
Config.UseTarget = true -- Set to false if you want to disable target system
Config.Target = "ox_target" -- or "qb-target"

Config.menu = {
    coords = vector3(-171.14, 295.84, 94.06),
    size = 3.0, -- interaction distance
    heading = 0.0
}

Config.PaketCombo = {

    paketcomboa = {
        label = "Paket Combo A (5 Takoyaki & 5 Ocha)",
        order = 1,
        items = {
            { name = "takoyaki"},
            { name = "ocha"}
            },
        price = "$ 25",
        description = "5 Takoyaki & 5 Ocha"
        
    },
    paketcombob = {
        label = "Paket Combo B (10 Sushi & 10 Milktea)",
        order = 2,
        items = {
            { name = "sushi"},
            { name = "milktea"}
        },
        price = "$ 45",
        description = "10 Sushi & 10 Milktea"
    },
    paketcomboc = {
        label = "Paket Combo C (15 Ramen & 15 Sake)",
        order = 3,
        items = {
            { name = "ramen"},
            { name = "sake"}
        },
        price = "$ 65",
        description = "15 Ramen & 15 Sake"
    }
}
Config.Food = {
    ramen = {
        label = "Ramen",
        items = {
            { name = "ramen" },
        },
        price = "$ 5",
        description = "Delicious ramen with various toppings"
    },
    sushi = {
        label = "Sushi",
        items = {
            { name = "sushi" },
        },
        price = "$ 5",
        description = "Fresh sushi rolls with fish and vegetables"
    },
    takoyaki = {
        label = "Takoyaki",
        items = {
            { name = "takoyaki" },
        },
        price = "$ 5",
        description = "Octopus balls served with sauce"
    },
}

Config.Drinks = {
    ocha = {
        label = "Ocha",
        items = {
            { name = "ocha" },
        },
        price = "$ 5",
        description = "Refreshing green tea"
    },
    milktea = {
        label = "Milktea",
        items = {
            { name = "milktea" },
        },
        price = "$ 5",
        description = "Sweet and creamy milk tea"
    },
    sake = {
        label = "Sake",
        items = {
            { name = "sake" },
        },
        price = "$ 5",
        description = "Traditional Japanese rice wine"
    }
}

Config.Desserts = {
    cheescake = {
        label = "Cheesecake",
        items = {
            { name = "cheescake" },
        },
        price = "$ 5",
        description = "Creamy and delicious cheesecake"
    },
    cookie = {
        label = "Cookie",
        items = {
            { name = "cookie" },
        },
        price = "$ 5",
        description = "Sweet chocolate chip cookies"
    },
    cupcake = {
        label = "Cupcake",
        items = {
            { name = "cupcake" },
        },
        price = "$ 5",
        description = "Fluffy cupcake with frosting"
    },
    cutecake = {
        label = "Cutecake",
        items = {
            { name = "cutecake" },
        },
        price = "$ 5",
        description = "Delicious cutecake with frosting"
    },
    donut = {
        label = "Donut",
        items = {
            { name = "donut" },
        },
        price = "$ 5",
        description = "Delicious donut with sprinkles"
    },
    magnolia = {
        label = "Magnolia",
        items = {
            { name = "magnolia" },
        },
        price = "$ 5",
        description = "Sweet and creamy magnolia dessert"
    },
    waffle = {
        label = "Waffle",
        items = {
            { name = "waffle" },
        },
        price = "$ 5",
        description = "Sweet and creamy waffle dessert"
    },
    ricepudding = {
        label = "Rice Pudding",
        items = {
            { name = "ricepudding" },
        },
        price = "$ 5",
        description = "Creamy rice pudding with cinnamon"
    },
}
