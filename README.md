# zh-farming

 ["pineapple_seed"] = {
        label = "Pineapple seed",
        weight = 200,
        stack = true,
        client = {
            export = 'zh-farming.pineapple'
        },
    },

    ["pineapple"] = {
        label = "Pineapple",
        weight = 200,
        stack = true,
    },

    ["juice_pineapple"] = {
        label = "Juice Pineapple",
        weight = 200,
        stack = true,
        client = {
            status = { thirst = 200000 },
            anim = {
                dict = "amb@world_human_drinking@coffee@male@idle_a",
                clip = "idle_c",
                flag = 49
            },
            prop = { model = "prop_plastic_cup_02", bone = 28422, pos = vec3(0, 0, 0), rot = vec3(0, 0, 0) },
            disable = { move = true, car = true, combat = true },
            usetime = 10000,
        }
    },

    ["pumpkin_seed"] = {
        label = "Pumpkin seed",
        weight = 200,
        stack = true,
        client = {
            export = 'zh-farming.pumpkin'
        },
    },

    ["pumpkin"] = {
        label = "Pumpkin",
        weight = 200,
        stack = true,
    },

    ["soup_pumpkin"] = {
        label = "Soup Pumpkin",
        weight = 200,
        stack = true,
        client = {
            status = { hunger = 200000 },
            anim = {
                dict = "anim@scripted@island@special_peds@pavel@hs4_pavel_ig5_caviar_p1",
                clip = "base_idle",
                flag = 49
            },
            prop = {
                { model = "prop_cs_plate_01",            bone = 60309, pos = vec3(0, 0, 0), rot = vec3(0, 0, 0) },
                { model = "h4_prop_h4_caviar_spoon_01a", bone = 28422, pos = vec3(0, 0, 0), rot = vec3(0, 0, 0) }
            },
            disable = { move = true, car = true, combat = true },
            usetime = 10000,
        }
    },

    ["cabbage_seed"] = {
        label = "Cabbage seed",
        weight = 200,
        stack = true,
        client = {
            export = 'zh-farming.cabbage'
        },
    },

    ["cabbage"] = {
        label = "Cabbage",
        weight = 200,
        stack = true,
    },

    ["soup_cabbage"] = {
        label = "Soup Cabbage",
        weight = 200,
        stack = true,
        client = {
            status = { hunger = 200000 },
            anim = {
                dict = "anim@scripted@island@special_peds@pavel@hs4_pavel_ig5_caviar_p1",
                clip = "base_idle",
                flag = 49
            },
            prop = {
                { model = "prop_cs_plate_01",            bone = 60309, pos = vec3(0, 0, 0), rot = vec3(0, 0, 0) },
                { model = "h4_prop_h4_caviar_spoon_01a", bone = 28422, pos = vec3(0, 0, 0), rot = vec3(0, 0, 0) }
            },
            disable = { move = true, car = true, combat = true },
            usetime = 10000,
        }
    },

    ["mushroom"] = {
        label = "Mush room",
        weight = 200,
        stack = true,
        client = {
            export = 'zh-farming.EffectMushroom'
        }
    },

    ["weed_seed"] = {
        label = "Weed seed",
        weight = 200,
        stack = true,
        client = {
            export = 'zh-farming.weed'
        },
    },

    ["weed"] = {
        label = "Weed",
        weight = 200,
        stack = true,
    },