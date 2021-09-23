------------------------------------------------------------
--             _____ _    _        _                      --
--            |_   _| |_ (_)_ _ __| |_ _  _               --
--              | | | ' \| | '_(_-<  _| || |              --
--              |_| |_||_|_|_| /__/\__|\_, |              --
--                                     |__/               --
------------------------------------------------------------
--        Thirsty mod [interoperability function]         --
------------------------------------------------------------
--       because I'm lazy and like small code blocks      --
------------------------------------------------------------

thirsty.register_food_drink = function (item_name,satiate_value,heal_value,hyd_value,hyd_max,rtn_item_name)
	
	local is_hunger_ng = false
	local is_hbhunger = false
	if minetest.get_modpath("hunger_ng") then is_hunger_ng = true end
	if minetest.get_modpath("hbhunger") then is_hbhunger = true end

	if is_hunger_ng then
		hunger_ng.add_hunger_data(item_name,{
			satiates = satiate_value,
			heals = heal_value,
			returns = nil,
			timeout = nil
			})
	end
	
	if is_hbhunger then
		hbhunger.register_food(item_name, satiate_value)
	end

	local def = table.copy(minetest.registered_items[item_name])
	      def.on_use =  function(itemstack,player,pointed_thing)

						thirsty.drink(player,hyd_value,hyd_max,rtn_item_name)
							
							if minetest.registered_items[item_name]._hunger_ng then
								minetest.sound_play("hunger_ng_eat", {to_player = player:get_player_name(), gain = 2.0 })
								hunger_ng.alter_hunger(player:get_player_name(), satiate_value, "from:thirsty-"..item_name)
								player:set_hp(player:get_hp()+heal_value)								
								itemstack:take_item()
								return itemstack
							else
								minetest.do_item_eat(satiate_value,nil, itemstack:take_item(), player, pointed_thing)
								return itemstack
							end
							
						end
	
	if def.type == "node" then
		minetest.register_node(":"..item_name, def)
	else
		minetest.register_craftitem(":"..item_name, def)
	end
end