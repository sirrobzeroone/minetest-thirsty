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

--------------------------
-- Tier 0 Hydrate Nodes --
--------------------------
if minetest.registered_items[E.water_source] then
	thirsty.register_hydrate_node(E.water_source)
end

if minetest.registered_items[E.water_source_f] then
	thirsty.register_hydrate_node(E.water_source_f)
end

if minetest.registered_items[E.water_source_riv] then
	thirsty.register_hydrate_node(E.water_source_riv)
end

if minetest.registered_items[E.water_source_riv_f] then
	thirsty.register_hydrate_node(E.water_source_riv_f)
end


-------------------------------------------
-- Tier 1 Drink from nodes using cup etc --
-------------------------------------------
	-- Nodes --
	-- see drinking fountain

	-- Items --
	if minetest.registered_items[E.drinking_glass] and thirsty.config.register_vessels then
		-- add "drinking" to vessels
		thirsty.augment_item_for_drinking(E.drinking_glass, 20)
	end

	if thirsty.config.register_bowl and not minetest.registered_items[E.wood_bowl] then
		-- our own simple wooden bowl
		minetest.register_craftitem('thirsty:wooden_bowl', {
			description = "Wooden bowl",
			inventory_image = "thirsty_bowl_cc0.png",
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
	elseif thirsty.config.register_bowl and minetest.registered_items[E.wood_bowl] then
	
		thirsty.augment_item_for_drinking(E.wood_bowl, 22)
		
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

if thirsty.config.register_vessels and minetest.registered_items[E.glass_bottle] then	
	thirsty.register_canteen_complex(E.glass_bottle,10,22,E.glass_bottle_f)	
end

if thirsty.config.register_vessels and minetest.registered_items[E.steel_bottle] then	
	thirsty.register_canteen_complex(E.steel_bottle,20,24)	
end


if thirsty.config.register_canteens and 
   minetest.registered_items[E.steel_ingot] and 
   minetest.registered_items[E.bronze_ingot] then

    minetest.register_craftitem('thirsty:steel_canteen', {
        description = 'Steel canteen',
        inventory_image = "thirsty_steel_canteen_cc0.png",
    })

    minetest.register_craftitem("thirsty:bronze_canteen", {
        description = "Bronze canteen",
        inventory_image = "thirsty_bronze_canteen_cc0.png",
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

if thirsty.config.register_drinking_fountain and 
   minetest.registered_items[E.stone] and 
   minetest.registered_items[E.bucket_water]then

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

if thirsty.config.register_fountains and   
   minetest.registered_items[E.copper_ingot] and
   minetest.registered_items[E.mese_crystal] and   
   minetest.registered_items[E.bucket_water] then

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

if thirsty.config.register_amulets and
   minetest.registered_items[E.diamond] and
   minetest.registered_items[E.mese_crystal] and   
   minetest.registered_items[E.bucket_water] then

    minetest.register_craftitem("thirsty:amulet_of_hydration", {
        description = "Amulet of Hydration",
        inventory_image = "thirsty_amulet_hydration_cc0.png",
    })
    minetest.register_craft({
        output = "thirsty:amulet_of_hydration",
        recipe = {
            {E.diamond     ,E.mese_crystal,E.diamond},
            {E.mese_crystal,E.bucket_water,E.mese_crystal},
            {E.diamond     ,E.mese_crystal,E.diamond}
        }
    })

	thirsty.register_amulet_supplier("thirsty:amulet_of_hydration", 0.5)

    minetest.register_craftitem("thirsty:amulet_of_moisture", {
        description = "Amulet of Moisture",
        inventory_image = "thirsty_amulet_moisture_cc0.png",
    })
    minetest.register_craft({
        output = "thirsty:amulet_of_moisture",
        recipe = {
            {E.mese_crystal,E.diamond     ,E.mese_crystal},
            {E.diamond     ,E.bucket_water,E.diamond     },
            {E.mese_crystal,E.diamond     ,E.mese_crystal}
        }
    })

	thirsty.register_amulet_extractor("thirsty:amulet_of_moisture", 0.6)

	minetest.register_craftitem("thirsty:lesser_amulet_thirst", {
        description = "Lesser Amulet of Thirst",
        inventory_image = "thirsty_amulet_of_thirst_lesser_cc0.png",
    })
	
	minetest.register_craftitem("thirsty:amulet_thirst", {
        description = "Amulet of Thirst",
        inventory_image = "thirsty_amulet_of_thirst_cc0.png",
    })
	
	minetest.register_craftitem("thirsty:greater_amulet_thirst", {
        description = "Greater Amulet of Thirst",
        inventory_image = "thirsty_amulet_of_thirst_greater_cc0.png",
    })

	thirsty.register_amulet_thirst("thirsty:lesser_amulet_thirst",0.85)
	thirsty.register_amulet_thirst("thirsty:amulet_thirst",0.70)
	thirsty.register_amulet_thirst("thirsty:greater_amulet_thirst",0.55)
	
end
