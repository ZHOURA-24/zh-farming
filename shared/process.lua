Config = Config or {}

Config.Process = {
    {
        label = 'Process 1',
        -- object = 'prop_cooker_03',
        object = 'v_ret_fh_kitchtable',
        coords = vec3(2306.8852539063, 4868.0161132813, 40.79877243042),
        rotation = vec3(0.0, 0.0, -44.265079498291),
        items = {
            juice_pineapple = {
                pineapple = 1,
                water = 1
            },
            soup_pumpkin = {
                pumpkin = 1,
                water = 1
            },
            soup_cabbage = {
                cabbage = 1,
                water = 1
            },
        },
        progress = {
            dict_effect = 'core',
            effect = 'ent_amb_smoke_foundry',
            effect_pos = vec3(0, 0, 0),
            dict = "amb@prop_human_bbq@male@idle_a",
            clip = "idle_b",
            model = "prop_fish_slice_01",
            pos = vec3(0.0, 0.0, 0.0),
            rot = vec3(0.0, 0.0, 0.0),
            bone = 28422
        }
    },
    {
        label = 'Process 2',
        object = 'bkr_prop_weed_table_01a',
        coords = vec3(1346.6627, 4390.7539, 43.3440),
        rotation = vec3(0.0, 0.0, -11.822427749634),
        items = {
            joint = {
                weed = 1,
            },
        },
        progress = {
            dict_effect = 'core',
            effect = 'ent_amb_stoner_woodchip_drop',
            effect_pos = vec3(0, 0, 0.8),
            dict = "missheist_agency3aig_23",
            clip = "urinal_sink_loop",
        }
    }
}
