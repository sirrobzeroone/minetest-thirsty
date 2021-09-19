------------------------------------------------------------
--             _____ _    _        _                      --
--            |_   _| |_ (_)_ _ __| |_ _  _               --
--              | | | ' \| | '_(_-<  _| || |              --
--              |_| |_||_|_|_| /__/\__|\_, |              --
--                                     |__/               --
------------------------------------------------------------
--                 Thirsty mod [components]               --
------------------------------------------------------------
--                See init.lua for license                --
------------------------------------------------------------

local E = thirsty.ext_nodes_items

----------------------------
-- Tier 0 Hydrate Nodes --
----------------------------
if minetest.get_modpath("default") then	
	thirsty.register_hydrate_node("default:water_source")
	thirsty.register_hydrate_node("default:water_flowing")
	thirsty.register_hydrate_node("default:river_water_source")
	thirsty.register_hydrate_node("default:river_water_flowing")	
end

-------------------------------------------
-- Tier 1 Drink from nodes using cup etc --
-------------------------------------------

	-- Nodes --
	-- see drinking fountain


	-- Items --
	if minetest.get_modpath("vessels") and thirsty.config.register_vessels then
		-- add "drinking" to vessels
		thirsty.augment_item_for_drinking('vessels:drinking_glass', 20)
	end

	if minetest.get_modpath("default") and thirsty.config.register_bowl and not minetest.registered_craftitems["farming:bowl"] then
		-- our own simple wooden bowl
		minetest.register_craftitem('thirsty:wooden_bowl', {
			description = "Wooden bowl",
			inventory_image = "thirsty_bowl_16.png",
			liquids_pointable = true,
		})

		minetest.register_craft({
			output = "thirsty:wooden_bowl",
			recipe = {
				{E.group_wood,          "", E.group_wood},
				{          "",E.group_wood,           ""}
			}
		})
		
		thirsty.augment_item_for_drinking("thirsty:wooden_bowl", 22)
		
	-- modify farming redo wooden bowl to be usable.	
	elseif thirsty.config.register_bowl and minetest.registered_craftitems["farming:bowl"] then
	
		thirsty.augment_item_for_drinking("farming:bowl", 22)
		
	end

--[[

Tier 2 Hydro Containers

Defines canteens (currently two types, with different capacities),
tools which store hydro. They use wear to show their content
level in their durability bar; they do not disappear when used up.

Wear corresponds to hydro level as follows:
- a wear of 0     shows no durability bar       -> empty (initial state)
- a wear of 1     shows a full durability bar   -> full
- a wear of 65535 shows an empty durability bar -> empty

]]

if minetest.get_modpath("mobs_animal") and thirsty.config.register_glass_milk and minetest.registered_items["mobs:glass_milk"] then	

	local def = table.copy(minetest.registered_items["mobs:glass_milk"])
	      def.on_use =  function(itemstack,player,pointed_thing)
							thirsty.drink(player,2,22,"vessels:drinking_glass")
							minetest.do_item_eat(1,nil, itemstack:take_item(), player, pointed_thing)
							return itemstack
						end
		
minetest.register_craftitem(":mobs:glass_milk", def)

end

if minetest.get_modpath("vessels") and thirsty.config.register_vessels then	

	thirsty.register_canteen_complex("vessels:glass_bottle",10,22,"vessels_glass_bottle_full_cc_by_sa_3.png")
	thirsty.register_canteen_complex("vessels:steel_bottle",20,24)
	
end


if minetest.get_modpath("default") and thirsty.config.register_canteens then

    minetest.register_craftitem('thirsty:steel_canteen', {
        description = 'Steel canteen',
        inventory_image = "thirsty_steel_canteen_16.png",
    })

    minetest.register_craftitem("thirsty:bronze_canteen", {
        description = "Bronze canteen",
        inventory_image = "thirsty_bronze_canteen_16.png",
    })
	
	thirsty.register_canteen("thirsty:steel_canteen",40,25)
	thirsty.register_canteen("thirsty:bronze_canteen",60,25)
	
    minetest.register_craft({
        output = "thirsty:steel_canteen",
        recipe = {
            {E.group_wood, ""},
            {E.steel_ingot,E.steel_ingot},
            {E.steel_ingot,E.steel_ingot}
        }
    })
    minetest.register_craft({
        output = "thirsty:bronze_canteen",
        recipe = {
            {E.group_wood, ""},
            {E.bronze_ingot,E.bronze_ingot},
            {E.bronze_ingot,E.bronze_ingot}
        }
    })

end

-------------------------------
--  Tier 3 Drinking Fountain --
-------------------------------

if minetest.get_modpath("default") and minetest.get_modpath("bucket") and thirsty.config.register_drinking_fountain then

    minetest.register_node('thirsty:drinking_fountain', {
        description = 'Drinking fountain',
        drawtype = 'nodebox',
		drop = E.stone.." 4",
        tiles = {
            -- top, bottom, right, left, front, back
            'thirsty_drinkfount_top.png',
            'thirsty_drinkfount_bottom.png',
            'thirsty_drinkfount_side.png',
            'thirsty_drinkfount_side.png',
            'thirsty_drinkfount_side.png',
            'thirsty_drinkfount_side.png',
        },
        paramtype = 'light',
        groups = { cracky = 2 },
        node_box = {
            type = "fixed",
            fixed = {
                { -3/16, -8/16, -3/16, 3/16, 3/16, 3/16 },
                { -8/16, 3/16, -8/16, 8/16, 6/16, 8/16 },
                { -8/16, 6/16, -8/16, 8/16, 8/16, -6/16 },
                { -8/16, 6/16, 6/16, 8/16, 8/16, 8/16 },
                { -8/16, 6/16, -6/16, -6/16, 8/16, 6/16 },
                { 6/16, 6/16, -6/16, 8/16, 8/16, 6/16 },
            },
        },
        selection_box = {
            type = "regular",
        },
        collision_box = {
            type = "regular",
        },
        on_rightclick = thirsty.on_rightclick(nil),
    })	
    
	minetest.register_craft({
        output = "thirsty:drinking_fountain",
        recipe = {
            {E.stone,E.bucket_water,E.stone},
            { ""    ,E.stone       ,     ""},
            { ""    ,E.stone       ,     ""}
        },
		replacements = {
			{E.bucket_water,E.bucket_empty}
		}
    })
	
	thirsty.register_drinkable_node("thirsty:drinking_fountain",30)

end


----------------------------------------------
-- Tier 4: Water fountains, Water extenders --
----------------------------------------------

if minetest.get_modpath("default") and minetest.get_modpath("bucket") and thirsty.config.register_fountains then

    minetest.register_node('thirsty:water_fountain', {
        description = 'Water fountain',
        tiles = {
            -- top, bottom, right, left, front, back
            'thirsty_waterfountain_top.png',
            'thirsty_waterfountain_top.png',
            'thirsty_waterfountain_side.png',
            'thirsty_waterfountain_side.png',
            'thirsty_waterfountain_side.png',
            'thirsty_waterfountain_side.png',
        },
        paramtype = 'light',
        groups = { cracky = 2 },
    })

    minetest.register_node('thirsty:water_extender', {
        description = 'Water fountain extender',
        tiles = {
            'thirsty_waterextender_top.png',
            'thirsty_waterextender_top.png',
            'thirsty_waterextender_side.png',
            'thirsty_waterextender_side.png',
            'thirsty_waterextender_side.png',
            'thirsty_waterextender_side.png',
        },
        paramtype = 'light',
        groups = { cracky = 2 },
    })

    minetest.register_craft({
        output = "thirsty:water_fountain",
        recipe = {
            {E.copper_ingot,E.bucket_water,E.copper_ingot},
            {""            ,E.copper_ingot,            ""},
            {E.copper_ingot,E.mese_crystal,E.copper_ingot}
        }
    })
    minetest.register_craft({
        output = "thirsty:water_extender",
        recipe = {
            { ""           ,E.bucket_water,            ""},
            { ""           ,E.copper_ingot,            ""},
            {E.copper_ingot,E.mese_crystal,E.copper_ingot}
        }
    })

	thirsty.register_water_fountain("thirsty:water_fountain")
	thirsty.register_water_fountain("thirsty:water_extender")
	
    minetest.register_abm({
        nodenames = {"thirsty:water_fountain"},
        interval = 2,
        chance = 5,
        action = thirsty.fountain_abm,
    })

end

--[[

Tier 5

These amulets don't do much; the actual code is above, where
they are searched for in player's inventories

]]

if minetest.get_modpath("default") and minetest.get_modpath("bucket") and thirsty.config.register_amulets then

    minetest.register_craftitem('thirsty:injector', {
        description = 'Amulet of Hydration',
        inventory_image = "thirsty_amulet_hydration_cc0.png",
    })
    minetest.register_craft({
        output = "thirsty:injector",
        recipe = {
            {E.diamond     ,E.mese_crystal,E.diamond},
            {E.mese_crystal,E.bucket_water,E.mese_crystal},
            {E.diamond     ,E.mese_crystal,E.diamond}
        }
    })

	thirsty.register_amulet_supplier("thirsty:injector", 0.5)

    minetest.register_craftitem('thirsty:extractor', {
        description = "Amulet of Moisture",
        inventory_image = "thirsty_amulet_moisture_cc0.png",
    })
    minetest.register_craft({
        output = "thirsty:extractor",
        recipe = {
            {E.mese_crystal,E.diamond     ,E.mese_crystal},
            {E.diamond     ,E.bucket_water,E.diamond     },
            {E.mese_crystal,E.diamond     ,E.mese_crystal}
        }
    })

	thirsty.register_amulet_extractor("thirsty:extractor", 0.6)

end
