Config = Config or {}

Config.Update = 2.5                      -- update all plant (proggress , water)
Config.Progress = math.random(25, 50)    -- add proggress when update plant
Config.Water = math.random(1, 10)        -- reduce water when update plant
Config.PlantAction = math.random(20, 40) -- added proggress/water

Config.Farming = {
    seeds = {
        -- item name
        pineapple = {
            label = 'Pineapple',
            stage = {
                -- stage update plant
                a = 'prop_plant_fern_01a',
                b = 'prop_plant_fern_01b',
                c = 'prop_pineapple',
            },
            last_stage = 'c', -- last stage harvest plant
        },
        pumpkin = {
            label = 'Pumpkin',
            stage = {
                a = 'prop_plant_fern_01a',
                b = 'prop_plant_fern_01b',
                c = 'prop_veg_crop_03_pump',
            },
            last_stage = 'c',
        },
        cabbage = {
            label = 'Cabbage',
            stage = {
                a = 'prop_plant_fern_01a',
                b = 'prop_plant_fern_01b',
                c = 'prop_veg_crop_03_cab',
            },
            last_stage = 'c',
        },
    },
    model = { -- model for check clossest object
        'prop_pineapple',
        'prop_veg_crop_03_pump',
        'prop_veg_crop_03_cab',
        'prop_plant_fern_01a',
        'prop_plant_fern_01b',
    },
    soil = {
        [2409420175] = true,
        -- [951832588] = 0.5,
        [3008270349] = true,
        [3833216577] = true,
        [223086562] = true,
        [1333033863] = true,
        [4170197704] = true,
        [3594309083] = true,
        [2461440131] = true,
        [1109728704] = true,
        [2352068586] = true,
        [1144315879] = true,
        [581794674] = true,
        [2128369009] = true,
        [-461750719] = true,
        [-1286696947] = true,
    }
}

Config.Shops = {
    label = 'Shops Farming',
    inventory = {
        { name = 'pineapple_seed', price = 10 },
        { name = 'pumpkin_seed',   price = 10 },
        { name = 'cabbage_seed',   price = 10 },
    },
    location = vec3(1967.1213, 4634.3149, 41.1015),
    blip = { id = 514, colour = 2, scale = 0.8, name = 'Shops Farming' },
    ped = {
        model = 'a_m_m_farmer_01',
        coords = vec4(1967.0812, 4634.3525, 40.1014, 33.0),
    }
}
