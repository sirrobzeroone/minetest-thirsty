# Thirsty [thirsty]

A Minetest mod that adds a "thirst" mechanic.

Version: 0.10.2

## *License*
**Code**  
LGPL 2.1 (see included LICENSE file)
  
**Textures**   
vessels_glass_bottle_full_cc_by_sa_3.png  
Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0)  
modified from vessels_glass_bottle.png  
Copyright (C) 2012-2016 Vanessa Ezekowitz  
Copyright (C) 2016 Thomas-S  

thirsty_drop_100_24_cc0.png +.xcf  
thirsty_drop_100_16_cc0.png  
thirsty_wooden_bowl_cc0.png +.xcf  
thirsty_bronze_canteen_cc0.png +.xcf  
thirsty_steel_canteen_cc0.png  
thirsty_amulet_moisture_cc0.png +.xcf  
thirsty_amulet_hydration_cc0.png +.xcf 
Public Domain CC0 1.0 Universal  
Sirrobzeroone  

All other Images CC BY-SA 4.0 
(see http://creativecommons.org/licenses/by-sa/4.0/)
  
**Sounds**  
thirsty_breviceps_drink-drinking-liquid.ogg  
https://freesound.org/people/Breviceps/sounds/445970/  
Public Domain CC0 1.0 Universal

Report bugs or request help on the forum topic.

# Description

This is a mod for MineTest. It adds a thirst mechanic to the
game, similar to many hunger mods (but independent of them).
Players will slowly get thirstier over time, and will need to
drink or suffer damage.

The point of this mod is not to make the game more realistic,
or harder. The point is to have another mechanic that rewards
preparation and infrastructure. Players will now have an incentive
to build their base next to water (or add some water to their base),
and/or take some water with them when mining or travelling.

# Terminology: "Thirst" vs. "hydration"

"Thirst" is the absence of "hydration" (a term suggested by
everamzah on the Minetest forums, thanks!). The overall mechanic
is still called "thirst", but the visible bar is that of
"hydration", meaning a full bar represents full hydration, not full
thirst. Players lose hydration (or "hydro points") over time, and
gain hydration when drinking.

# Current behavior
## *Tier 0*

stand in water (running or standing) to slowly drink.
You may not move during drinking (or you could cross an ocean without
getting thirsty).

To register additional drinkable nodes use the function:
	
**thirsty.register_hydrate_node(node_name,also_drinkable_with_cup,regen_rate_per_second)**  

**"node_name"** - registered node name  
**"also_drinkable_with_cup"** - optional will default to true, if true 
 registers as per thirsty.register_drinkable_node() with max_hydration 
 equal to thirsty.config.start (default 20)  
**"regen_rate_per_second"** - optional will default to 0.5 hydration 
 points per second standing still in the liquid.  

**Example**

    thirsty.register_hydrate_node("default:water_source")

## *Tier 1*

Use a container (e.g. from `vessels`) on water to instantly
fill your hydration. Craftable wooden bowl included.

**NODES**  
Configure nodes that can be drunk from using a cup/glass etc assuming this was
not done as part of Tier 0 or if you wish to override max_hydration to be more
than the default value (normally 20):

**thirsty.register_drinkable_node(node_name,max_hydration)**  
**"item_name"** registered node name  
**"max_hydration"**  optional will default to thirsty.config.start (default 20)
 max hydration can be set above 20 to encourage use of drinking fountains or
 hydration/drinking infrastructure.  

**Example**

    thirsty.register_drinkable_node("thirsty:drinking_fountain",30)
	
**ITEMS**  
Configure cups/glasses/bowls etc that can be used to scoop up water and then
drink from:

**thirsty.augment_item_for_drinking(item_name, max_hydration)**  
**"item_name"** registered item name  
**"max_hydration"** optional will default to thirsty.config.start (default 20)
 max hydration can be set above 20 to encourage use of items to drink with.  

This will overide/replace any existing code the item may have in it's 
item_name.on_use. So not recommended for items with custom on_use
code already.
**Example**

    thirsty.augment_item_for_drinking('vessels:drinking_glass', 20)

**Integrate thirsty into item custom on_use code**  
thirsty.on_use()  
**Example**

    minetest.register_craftitem("mod_name:empty_cup", {
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
    })*
## *Tier 2*

Pre-made drinks and craftable canteens

**PREMADE DRINKS**  
Pre-made drinks can include anything the player may have had to craft 
or cook and you wish the player to restore some hydration on_use:
	
**thirsty.drink(player, amount, max_hydration, empty_vessel)**  
		
**"player"** player object see minetest player object  
**"amount"** number of hydration points to restore  
**"max hydration"** - optional will default to thirsty.config.start (default 20)
 max hydration can be set above 20 to encourage use of items to drink with.  
**"empty_vessel"** - optional empty vessel or item to return to player.  
  
**Example**

    minetest.register_craftitem("mod_name:cup_of_soup", {
    		description = S("Cup of Soup"),
    		inventory_image = "mod_name_cup_of_soup.png",
    		on_use = function(itemstack,player,pointed_thing)					 		   
    					 thirsty.drink(player, 2, 20,   "mod_name:empty_cup")					  
    					 itemstack:take_item()
    					 return itemstack
    				 end,
    	})

**CANTEENS, FLASKS or BOTTLES**  
	Craftable items that you may wish to configure to hold a certain amount of 
	liquid hydration points. If used these items are converted to registered tools
	rather than straight regsitered items with stack maximum of 1 so that current 
	full/empty value is displayed to the player (using wear). Thirsty includes a 
	Steel canteen with 40 hydration point capacity and a Bronze canteen with 60 
	hydration point capacity. These can be refilled by clicking on any thirsty 
	registered hydrate_node.  
	
**thirsty.register_canteen(item_name,hydrate_capacity,max_hydration,on_use)**
	
**"item_name"** Registered item name to convert to canteen type container  
**"hydrate_capacity"** How many hydration points the container holds 1 full bar = 20  
**"max hydration"**  Optional will default to thirsty.config.start (default 20)
 max hydration can be set above 20 to encourage use of items to drink with.  
**"on_use"**  Optional default is true. Will set item.on_use function to; thirsty.on_use(), however if set to false on_use wont be over written. Mod registering item will need to manually include "thirsty.on_use()" inside its on_use item definition or canteen will not work note see Tier 1 - thirsty.on_use()  

**Example**  

    thirsty.register_canteen("thirsty:bronze_canteen",60,25)

 
 **COMPLEX CANTEENS, FLASKS or BOTTLES**  
 Using the above will mean items can no longer be stacked most importantly when they are empty. The below function will overcome this as it will register a full version
 of the empty vessel as a tool. Naturally if you do not wish or need the empty containers to stack just use thirsty.register_canteen. Once a container is empty it will be replaced with the empty version.  
	 
**thirsty.register_canteen_complex(item/node_name,hydrate_capacity,max_hydration,full_image)**  
	 	 
**"item_name" or "node_name"** Registered item name to convert to canteen type tool container  
**"hydrate_capacity"** How many hydration points the container holds 1 full bar = 20  
**"max hydration"**  Optional will default to thirsty.config.start (default 20)
 max hydration can be set above 20 to encourage use of items to drink with.  
 **"full_image"** The full image of the empty item used for inventory image and wield image  
 
**Example**  

    thirsty.register_canteen_complex("vessels:glass_bottle",10,22,"vessels_glass_bottle_full.png")

	
## *Tier 3*

Placeable drinking fountain / wash basin node: instantly
fills your hydration when used.

Add the below to the on_rightclick function inside your node definition,
you'll also need to register the node as a drinkable node so you'll need
to also run - thirsty.register_drinkable_node(node_name). Recommended that
the node.drop for your node dosen't equal itself otherwise players will simply
use these as endless canteens/bottles.  

**thirsty.on_rightclick()**

    minetest.register_node('thirsty:drinking_fountain', {
    		description = 'Drinking fountain',
    		....
    			def info 
    					....
    		drop = "default:stone 4",
    		on_rightclick = thirsty.on_rightclick(),
    	})
    	
    
    minetest.register_craft({
    		output = "thirsty:drinking_fountain",
    		recipe = {
    			{ "default:stone", "bucket:bucket_water", "default:stone"},
    			{ ""             , "default:stone"      ,              ""},
    			{ ""             , "default:stone"      ,              ""}
    		},
    		replacements = {
    			{"bucket:bucket_water", "bucket:bucket_empty"}
    		}
    	})
    	
    thirsty.register_drinkable_node("thirsty:drinking_fountain",30)
		

## *Tier 4*
Placeable fountain node(s) to fill the hydration of all
players within range. Placing more nodes increases the range.

**thirsty.register_water_fountain(node_name)**  

**Example**	

    thirsty.register_water_fountain("thirsty:water_fountain")
	
**HOW TO USE WATER FOUNTAINS** *(Taken from forum posts)*
Water fountains are placeable, but these are not usable. Instead, 
they constantly fill the hydration of all players within a 5 node
radius, as if they were standing in water. Water fountains need 
actual water (source or flowing) near them to work.

You can extend the radius of water fountains with "water extenders", 
placeable nodes without any function of their own.

Specifically, a water fountain will check all the nodes in a 
5-node-high pyramid starting one node above itself. It will count all 
water nodes (source or flowing), and count all water fountains / 
water extenders. The smaller of these numbers is the "level" of the fountain, 
up to 20 (in other words, you need an equal amount of water and fountain blocks). 
Each level adds 5 more nodes to the working radius. A large fountain 
should cover a city block or two.

I'd recommend placing one water source above the "fountain" node, and 
arranging extenders under it, but the plan is to allow many working designs.


## *Tier 5*

Craftable trinkets/gadgets/amulets that constantly keep your
hydration filled when in your inventory, solving your thirst problem
once and for all.

**thirsty.register_amulet_extractor(item_name,value)**
	
**"item_name"**  Registered item name  
**"value"**            Number of Hydration points extracted per half second (thirsty.config.tick_time)  
 *Note: Container must be avaliable in Inventory with avaliable space to add hydration points to.*				  

**Example**

    thirsty.register_amulet_extractor("thirsty:amulet_of_moisture", 0.6)	

**Amulet of Moisture**  - Absorbs moisture from the surronding environment places it into a canteen or other water holding item. Must be held in Inventory.  

**thirsty.register_amulet_supplier(item_name,value)**

**"item_name"** Registered item name  
**"value"**     Number of Hydration points supplied to player per half second.(thirsty.config.tick_time)  
 *Note: Container must be avaliable in Inventory with avaliable space to add hydration points to.*  	
			  
**Example**  

    thirsty.register_amulet_supplier("thirsty:amulet_of_hydration", 0.5)

**Amulet of Hydration** - Feeds water from a Canteen or other water holding
item directly into the player to keep them always hydrated. Must be held in Inventory.  
  
The above two Amulets can be used in combination with each other plus a 
canteen. However this does permenantly fill 3 inventory slots the delibrate
downside to offset the significant bonus.  
						  
**Amulets of Thirst** - Three versions lesser,normal and greater each will slower the rate at which
a player becomes thirsty. Normal thirst factor is 1, however a "cursed" version could be created
which makes a player become thirsty faster.  

	thirsty.register_amulet_thirst(item_name, thirst_factor)  

**"item_name"** Registered item name  
**"thirst_factor"** Float value that represents the speed at which a player uses hydration points

**Example** 

	minetest.register_craftitem("thirsty:greater_amulet_thirst", {
        description = "Greater Amulet of Thirst",
        inventory_image = "thirsty_amulet_of_thirst_greater_cc0.png",
    })

	thirsty.register_amulet_thirst("thirsty:lesser_amulet_thirst",0.85)

*Note: Included Amulets of Thirst have no craft recipes and are only avaliable as   
*dungeon loot with more powerful versions only found in deeper dungeons.
 

## *Additional Functions*

*thirsty.get_hydro(player) : returns the current hydration of a player*

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