------------------------------------------------------------
--             _____ _    _        _                      --
--            |_   _| |_ (_)_ _ __| |_ _  _               --
--              | | | ' \| | '_(_-<  _| || |              --
--              |_| |_||_|_|_| /__/\__|\_, |              --
--                                     |__/               --
------------------------------------------------------------
--            Thirsty mod external nodes items            --
------------------------------------------------------------
--                See init.lua for license                --
------------------------------------------------------------

--[[ 
These are nodes and items required to make canteens and 
fountains. Simply change the name here to change the reference
across the whole mod.
]]--
local E = thirsty.ext_nodes_items

-- item and node mod aliases, change these as needed.
-- if item dosen't exist as either Ing or Aug item
-- it wont register.

-- Basic Water, change here or register 
-- using thirsty.register_hydrate_node() 
-- and leave these unchanged.
E.water_source       = "default:water_source"
E.water_source_f     = "default:water_flowing"
E.water_source_riv   = "default:river_water_source"
E.water_source_riv_f = "default:river_water_flowing"

-- Ingredients
E.group_wood     = "group:wood"
E.stone          = "default:stone"
E.steel_ingot    = "default:steel_ingot"
E.bronze_ingot   = "default:bronze_ingot"
E.copper_ingot   = "default:copper_ingot"
E.mese_crystal   = "default:mese_crystal"
E.diamond        = "default:diamond"
E.bucket_water   = "bucket:bucket_water"
E.bucket_empty   = "bucket:bucket_empty"

-- Augumented Items
E.drinking_glass = "vessels:drinking_glass"
E.glass_bottle   = "vessels:glass_bottle"                      -- looks like glass potion bottle
E.glass_bottle_f = "vessels_glass_bottle_full_cc_by_sa_3.png"  -- image for registering full version of above
E.steel_bottle   = "vessels:steel_bottle"
E.wood_bowl      = "farming:bowl"
E.glass_milk     = "mobs:glass_milk"       -- note needs E.drinking_glass for empty return item
