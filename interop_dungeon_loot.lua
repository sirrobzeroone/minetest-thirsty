------------------------------------------------------------
--             _____ _    _        _                      --
--            |_   _| |_ (_)_ _ __| |_ _  _               --
--              | | | ' \| | '_(_-<  _| || |              --
--              |_| |_||_|_|_| /__/\__|\_, |              --
--                                     |__/               --
------------------------------------------------------------
--             Thirsty mod [interop_ethereal]             --
------------------------------------------------------------
--            Settings to support Dungeon Loot            --
------------------------------------------------------------
if register_amulets == true then

	dungeon_loot.register({name = "thirsty:lesser_amulet_thirst", chance = 0.1, count = {1,1}})
	dungeon_loot.register({name = "thirsty:amulet_thirst", chance = 0.05, count = {1,1}, y = {-100, 32768}})
	dungeon_loot.register({name = "thirsty:greater_amulet_thirst", chance = 0.05, count = {1,1}, y = {-200, 32768}})

end