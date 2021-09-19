------------------------------------------------------------
--             _____ _    _        _                      --
--            |_   _| |_ (_)_ _ __| |_ _  _               --
--              | | | ' \| | '_(_-<  _| || |              --
--              |_| |_||_|_|_| /__/\__|\_, |              --
--                                     |__/               --
------------------------------------------------------------
--                 Thirsty mod [thirsty]                  --
------------------------------------------------------------
-- A mod that adds a "thirst" mechanic, similar to hunger --
--  Copyright (C) 2015 Ben Deutsch <ben@bendeutsch.de>    --
------------------------------------------------------------
---------------
--[[ License --
---------------

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301
USA

--Media/Images--
vessels_glass_bottle_full_cc_by_sa_3.png
	Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0)
	modified from vessels_glass_bottle.png
	Copyright (C) 2012-2016 Vanessa Ezekowitz
	Copyright (C) 2016 Thomas-S
	
thirsty_amulet_moisture_cc0.png
	Public Domain CC0 
	Sirrobzeroone

thirsty_amulet_hydration_cc0.png
	Public Domain CC0 
	Sirrobzeroone

-------------------------------------------
-- Terminology: "Thirst" vs. "hydration" --
-------------------------------------------

"Thirst" is the absence of "hydration" (a term suggested by
everamzah on the Minetest forums, thanks!). The overall mechanic
is still called "thirst", but the visible bar is that of
"hydration", filled with "hydro points".

]]--

-- the main module variable
thirsty = {
    -- Configuration variables
    config = {
			  -- configuration in Settings>>Mods>>Thirsty
			  -- Best to not change defaults here
			  -- [General]
			  tick_time = minetest.setting_get("thirsty_tick_time") or 0.5, 
			  start = minetest.setting_get("thirsty_starting_value") or 20,
			  thirst_per_second = minetest.setting_get("thirst_per_second") or 1.0 / 30,
			  damage_per_second = minetest.setting_get("damage_per_second") or 1.0 / 10.0,
			  stand_still_for_drink = minetest.setting_get("stand_still_for_drink") or 1.0,
			  stand_still_for_afk = minetest.setting_get("stand_still_for_afk") or 120.0,
			  
			  -- [Water Fountain]
			  regen_from_fountain = minetest.setting_get("regen_from_fountain") or 0.5,
			  fountain_height = minetest.setting_get("fountain_height") or 4,
			  fountain_max_level = minetest.setting_get("fountain_max_level") or 20,
			  fountain_distance_per_level = minetest.setting_get("fountain_distance_per_level") or 5,
			  
			  -- [Thirsty Mod Items]
			  register_bowl = minetest.setting_get("register_bowl") or true,
			  register_canteens = minetest.setting_get("register_canteens") or true,
			  register_drinking_fountain = minetest.setting_get("register_drinking") or true,
			  register_fountains = minetest.setting_get("register_fountains") or true,
			  register_amulets = minetest.setting_get("register_amulets") or true,
			  
			  -- [Other Mods]
			  register_vessels = minetest.setting_get("register_vessels") or true,
			  register_glass_milk = minetest.setting_get("register_glass_milk") or true,
			  
			  -- [Node/Item Tables] Do not change names without code updates. 
			  -- Use API functions to register to these tables
			  regen_from_node      = {},
			  node_drinkable       = {},
			  drink_from_container = {},
			  container_capacity   = {},
			  drink_from_node      = {},
			  fountain_type        = {},
			  extraction_for_item  = {},
			  injection_for_item   = {}
             },

    -- the players' values
    players = {
        --[[
        name = {
            last_pos = '-10:3',
            time_in_pos = 0.0,
            pending_dmg = 0.0,
            thirst_factor = 1.0,
        }
        ]]
    },

    -- water fountains
    fountains = {
        --[[
        x:y:z = {
            pos = { x=x, y=y, z=z },
            level = 4,
            time_until_check = 20,
            -- something about times
        }
        ]]
    },
	ext_nodes_items = {
		  --[[ acts as an internal
		       mod aliasing for ingredients
			   used in Canteen/Fountain recipes.
               to change edit:
               components_external_nodes_items.lua
			   
			   steel_ingot = default:steel_ingot
            ]]			   
	},

    -- general settings
    time_next_tick = 0.0,
}

local M = thirsty
local C = M.config

thirsty.time_next_tick = thirsty.config.tick_time

dofile(minetest.get_modpath('thirsty')..'/hud.lua')
dofile(minetest.get_modpath('thirsty')..'/functions.lua')

minetest.register_on_joinplayer(thirsty.on_joinplayer)
minetest.register_on_dieplayer(thirsty.on_dieplayer)
minetest.register_globalstep(thirsty.main_loop)

dofile(minetest.get_modpath('thirsty')..'/components_external_nodes_items.lua')
dofile(minetest.get_modpath('thirsty')..'/components.lua')