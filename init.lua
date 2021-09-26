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
See Readme.MD - Mix of:
CC BY-SA 3.0
CC BY-SA 4.0
CC0 1.0 Universal

-------------------------------------------
-- Terminology: "Thirst" vs. "hydration" --
-------------------------------------------

"Thirst" is the absence of "hydration" (a term suggested by
everamzah on the Minetest forums, thanks!). The overall mechanic
is still called "thirst", but the visible bar is that of
"hydration", filled with "hydro points".
]]--

thirsty = {}

-- simple toboolean function that handles nil
thirsty.tobool = function(value)
	if value == nil then
		return nil
	elseif value == "true" or value == 1 then
		return true
	else
		return false
	end
end

    -- Configuration variables
thirsty.config = {
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
			  register_bowl      = thirsty.tobool(minetest.setting_get("register_bowl")) or true,
			  register_canteens  = thirsty.tobool(minetest.setting_get("register_canteens")) or true,
			  register_drinking_fountain = thirsty.tobool(minetest.setting_get("register_drinking")) or true,
			  register_fountains = thirsty.tobool(minetest.setting_get("register_fountains")) or true,
			  register_amulets   = thirsty.tobool(minetest.setting_get("register_amulets")) or true,
			  
			  -- [Other Mods]
			  register_vessels = thirsty.tobool(minetest.setting_get("register_vessels")) or true,
			  
			  -- [Node/Item Tables] Do not change names without code updates. 
			  -- Use API functions to register to these tables
			  regen_from_node      = {},
			  node_drinkable       = {},
			  drink_from_container = {},
			  container_capacity   = {},
			  drink_from_node      = {},
			  fountain_type        = {},
			  extraction_for_item  = {},
			  injection_for_item   = {},
			  thirst_adjust_item   = {}
             }

    -- water fountains
thirsty.fountains = {
        --[[
        x:y:z = {
            pos = { x=x, y=y, z=z },
            level = 4,
            time_until_check = 20,
            -- something about times
        }
        ]]
    }
	
thirsty.ext_nodes_items = {
		  --[[ acts as an internal
		       mod aliasing for ingredients
			   used in Canteen/Fountain recipes.
               to change edit:
               components_external_nodes_items.lua
			   
			   steel_ingot = default:steel_ingot
            ]]			   
	}

    -- general settings
thirsty.time_next_tick = 0.0


local M = thirsty
local C = M.config
local modpath = minetest.get_modpath("thirsty")

thirsty.time_next_tick = thirsty.config.tick_time

dofile(modpath..'/hud.lua')
dofile(modpath..'/functions.lua')

minetest.register_on_joinplayer(thirsty.on_joinplayer)
minetest.register_on_dieplayer(thirsty.on_dieplayer)
minetest.register_globalstep(thirsty.main_loop)

dofile(modpath..'/components_external_nodes_items.lua')
dofile(modpath..'/components.lua')
dofile(modpath..'/interop_a_functions.lua')

-- dungeon_loot for Aumlets of Thirst
if minetest.get_modpath("dungeon_loot") then
	dofile(modpath..'/interop_dungeon_loot.lua')
end 

-- mobs_animal specific config
if minetest.get_modpath("mobs_animal") then
	dofile(modpath..'/interop_mobs_animal.lua')
end

-- farming(redo) specific config
if minetest.get_modpath("farming") and 
   farming.mod == "redo" then
	dofile(modpath..'/interop_farming_redo.lua')
end

-- ethereal specific config
if minetest.get_modpath("ethereal") then
	dofile(modpath..'/interop_ethereal.lua')
end