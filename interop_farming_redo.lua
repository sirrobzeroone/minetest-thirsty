------------------------------------------------------------
--             _____ _    _        _                      --
--            |_   _| |_ (_)_ _ __| |_ _  _               --
--              | | | ' \| | '_(_-<  _| || |              --
--              |_| |_||_|_|_| /__/\__|\_, |              --
--                                     |__/               --
------------------------------------------------------------
--           Thirsty mod [interop_farming(redo)]          --
------------------------------------------------------------
--           Settings to support farming redo             --
------------------------------------------------------------

local E = thirsty.ext_nodes_items

--------------------
-- Hydrate only --
--------------------
local def = table.copy(minetest.registered_items["farming:glass_water"])
def.on_use = function(itemstack,player,pointed_thing)
				thirsty.drink(player,2,20,E.drinking_glass)
				itemstack:take_item()
				return itemstack
			 end
minetest.register_craftitem(":farming:glass_water", def)


local def = table.copy(minetest.registered_items["farming:rose_water"])
def.on_use = function(itemstack,player,pointed_thing)
				thirsty.drink(player,12,24,E.glass_bottle)
				itemstack:take_item()
				return itemstack
			 end
minetest.register_craftitem(":farming:rose_water", def)

----------------------------
-- Hydrate and Food Items --
----------------------------
thirsty.register_food_drink("farming:soy_milk"          ,1,0,4,22,E.drinking_glass)	
thirsty.register_food_drink("farming:pineapple_juice"   ,1,0,4,22,E.drinking_glass)
thirsty.register_food_drink("farming:carrot_juice"      ,1,0,4,22,E.drinking_glass)	
thirsty.register_food_drink("farming:smoothie_berry"    ,2,0,4,23,E.drinking_glass)
thirsty.register_food_drink("farming:smoothie_raspberry",2,0,4,23,E.drinking_glass)	
thirsty.register_food_drink("farming:mint_tea"          ,2,0,4,24,E.drinking_glass)
thirsty.register_food_drink("farming:coffee_cup"        ,2,0,4,22,E.drinking_glass)
thirsty.register_food_drink("farming:beetroot_soup"     ,4,0,2,20,E.wood_bowl)
thirsty.register_food_drink("farming:onion_soup"        ,5,0,2,20,E.wood_bowl)
thirsty.register_food_drink("farming:pea_soup"          ,6,0,2,20,E.wood_bowl)
thirsty.register_food_drink("farming:tomato_soup"       ,7,0,2,20,E.wood_bowl)
thirsty.register_food_drink("farming:chili_bowl"        ,7,0,-2,20,E.wood_bowl)
thirsty.register_food_drink("farming:chili_pepper"      ,1,-1,-5,40,nil)

--------------------	
-- Complex/Custom --
--------------------
local def = table.copy(minetest.registered_items["farming:cactus_juice"])
def.on_use = function(itemstack, player, pointed_thing)
				if player then
					if math.random(5) == 1 then
						thirsty.drink(player,-2,20,E.drinking_glass)
						itemstack:take_item()
						return itemstack	
					else
						thirsty.drink(player,6,20,E.drinking_glass)
						itemstack:take_item()
						return itemstack
					end
				end
			end
			 
minetest.register_craftitem(":farming:cactus_juice", def)

