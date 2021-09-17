Thirsty [thirsty]
=================

A Minetest mod that adds a "thirst" mechanic.

Version: 0.10.2

License:
  Code: LGPL 2.1 (see included LICENSE file)
  Textures: CC-BY-SA (see http://creativecommons.org/licenses/by-sa/4.0/)

Report bugs or request help on the forum topic.

Description
-----------

This is a mod for MineTest. It adds a thirst mechanic to the
game, similar to many hunger mods (but independent of them).
Players will slowly get thirstier over time, and will need to
drink or suffer damage.

The point of this mod is not to make the game more realistic,
or harder. The point is to have another mechanic that rewards
preparation and infrastructure. Players will now have an incentive
to build their base next to water (or add some water to their base),
and/or take some water with them when mining or travelling.

Terminology: "Thirst" vs. "hydration"
-------------------------------------

"Thirst" is the absence of "hydration" (a term suggested by
everamzah on the Minetest forums, thanks!). The overall mechanic
is still called "thirst", but the visible bar is that of
"hydration", meaning a full bar represents full hydration, not full
thirst. Players lose hydration (or "hydro points") over time, and
gain hydration when drinking.

Current behavior
----------------

**Tier 0**: stand in water (running or standing) to slowly drink.
You may not move during drinking (or you could cross an ocean without
getting thirsty).

	To register additional drinkable nodes use the function:
	
	*thirsty.register_hydrate_node(node_name,also_drinkable_with_cup,regen_rate_per_second)
	
	eg thirsty.register_hydrate_node("default:water_source")
	
    "node_name" registered node name
	
	"also_drinkable_with_cup" - optional will default to true, if true 
	 registers as per thirsty.register_drinkable_node()
	 
	"regen_rate_per_second" - optional will default to 0.5 hydration 
	 points per second standing still in the liquid.

**Tier 1**: use a container (e.g. from `vessels`) on water to instantly
fill your hydration. Craftable wooden bowl included.

	NODES
	Configure nodes that can be drunk from using a cup/glass etc assuming this was
	not done as part of Tier 0:
	
	* thirsty.register_drinkable_node(node_name)
	
	eg thirsty.register_drinkable_node("thirsty:drinking_fountain")
	
	ITEMS
	Configure cups/glasses/bowls etc that can be used to scoop up water and then
	drink from:
	
	*thirsty.augment_item_for_drinking(item_name, max_hydration)
	
	eg thirsty.augment_item_for_drinking('vessels:drinking_glass', 20)
	
	"item_name" registered item name
	
	"max_hydration" - optional will default to thirsty.config.start (default 20)
	 max hydration can be set above 20 to encourage use of items to drink with.
	
	This will overide/replace any existing code the item may have in it's 
	item_name.on_use. So not recommended for items with custom on_use
	code already.
	
	Integrate thirsty into item custom on_use code:
	
	*thirsty.on_use()
	
	eg  minetest.register_craftitem("mod_name:empty_cup", {
			description = S("Empty Cup"),
			inventory_image = "mod_name_empty_cup.png",
			liquids_pointable = true,
			on_use = function(itemstack,player,pointed_thing)					 
						local pos = pointed_thing.under
						local node_name

						if pointed_thing.type == "node" then
							local node = minetest.get_node(pos)
							node_name = node.name
						end
						
						if thirsty.config.node_drinkable[node_name] then
							thirsty.on_use()
						else
						 -- do something else
						end
					end,
		})
	
**Tier 2**: pre-made drinks and craftable canteens

	-- PREMADE DRINKS --
	Pre-made drinks can include anything the player may have had to craft 
	or cook and you wish the player to restore some thirst on_use:
	
	*thirsty.drink(player, amount, max_hydration, empty_vessel)
	
	eg  minetest.register_craftitem("mod_name:cup_of_soup", {
			description = S("Cup of Soup"),
			inventory_image = "mod_name_cup_of_soup.png",
			on_use = function(itemstack,player,pointed_thing)					 		   
						 thirsty.drink(player, 2, 20, "mod_name:empty_cup")					  
						 itemstack:take_item()
						 return itemstack
					 end,
		})
		
	"player" player object see minetest player object
	
	"amount" number of hydration points to restore
	
	"max hydration" - optional will default to thirsty.config.start (default 20)
	 max hydration can be set above 20 to encourage use of items to drink with.

	"empty_vessel" - optional empty vessel or item to return to player.

	-- CANTEENS, FLASKS or BOTTLES --
	Craftable items that you may wish to configure to hold a certain amount of 
	liquid hydration points. If used these items are converted to registered tools
	rather than straight regsitered items with stack maximum of 1 so that current 
	full/empty value is displayed to the player (using wear). Thirsty includes a 
	Steel canteen with 40 hydration point capacity and a Bronze canteen with 60 
	hydration point capacity. These can be refilled by clicking on any thirsty 
	registered hydrate_node.
	
	*thirsty.register_canteen(item_name,hydrate_capacity,max_hydration,on_use)
	
	eg thirsty.register_canteen("thirsty:bronze_canteen",60,25)
	
	"item_name" registered item name to convert to canteen type container
	
	"hydrate_capacity" how many hydration points the container holds 1 full bar = 20
	
	"max hydration" - optional will default to thirsty.config.start (default 20)
	 max hydration can be set above 20 to encourage use of items to drink with.
	 
	"on_use" - optional default is true. Will set item.on_use function to; thirsty.on_use(),
	 however if set to false on_use wont be over written. Mod registering item will 
	 need to manually include "thirsty.on_use()" inside its on_use item definition or 
	 canteen will not work note see Tier 1 - thirsty.on_use()
	 
	 -- COMPLEX CANTEENS, FLASKS or BOTTLES --
	 Using the above will mean items can no longer be stacked most importantly when they
	 are empty. The below function will overcome this as it will register a full version
	 of the empty vessel as a tool. Naturally if you do not wish or need the empty containers to 
	 stack just use thirsty.register_canteen. Once a container is empty it will be replaced
	 with the empty version.
	 
	 *thirsty.register_canteen_complex(item/node_name,hydrate_capacity,max_hydration,full_image)
	 
	 eg thirsty.register_canteen_complex("vessels:glass_bottle",10,22,"vessels_glass_bottle_full.png")
	 
	"item_name" or "node_name" registered item name to convert to canteen type tool container
	
	"hydrate_capacity" how many hydration points the container holds 1 full bar = 20
	
	"max hydration" - optional will default to thirsty.config.start (default 20)
	 max hydration can be set above 20 to encourage use of items to drink with.
	 
	 "full_image" The full image of the empty item used for inventory image and wield image
	

**Tier 3**: placeable drinking fountain / wash basin node: instantly
fills your hydration when used.

**Tier 4+**: placeable fountain node(s) to fill the hydration of all
players within range. Placing more nodes increases the range.

**Tier 5**: craftable trinkets/gadgets/amulets that constantly keep your
hydration filled when in your inventory, solving your thirst problem
once and for all.

API
---
Some functions of interest:

* thirsty.drink(player, amount, [max], empty_vessel) : instantly drink a bit (up to a max value, default 20)
* thirsty.get_hydro(player) : returns the current hydration of a player
* thirsty.set_thirst_factor(player, factor) : how fast does the given player get thirsty (default is 1.0)
* thirsty.get_thirst_factor(player) : returns the current thirst factor of a player

"player" refers to a player object, i.e. with a get_player_name() method.

Future plans
------------
Continued tidy and updating

Dependencies
------------
* default (optional but needed for included components)
* bucket (optional but needed for some included components)
* hudbars (optional): https://forum.minetest.net/viewtopic.php?f=11&t=11153
* vessels (optional): https://forum.minetest.net/viewtopic.php?id=2574

