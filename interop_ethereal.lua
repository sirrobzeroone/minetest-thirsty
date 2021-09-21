------------------------------------------------------------
--             _____ _    _        _                      --
--            |_   _| |_ (_)_ _ __| |_ _  _               --
--              | | | ' \| | '_(_-<  _| || |              --
--              |_| |_||_|_|_| /__/\__|\_, |              --
--                                     |__/               --
------------------------------------------------------------
--             Thirsty mod [interop_ethereal]             --
------------------------------------------------------------
--              Settings to support Ethereal              --
------------------------------------------------------------

local E = thirsty.ext_nodes_items
----------------------------
-- Hydrate and Food Items --
----------------------------
thirsty.register_hb_hng_drink("ethereal:firethorn_jelly" ,1,0,1,20,E.glass_bottle)
thirsty.register_hb_hng_drink("ethereal:mushroom_soup"   ,2.5,0,2,20,ethereal:bowl)
thirsty.register_hb_hng_drink("ethereal:hearty_stew"     ,7.0,0,1,20,ethereal:bowl)
thirsty.register_hb_hng_drink("ethereal:golden_apple"    ,10,10,10,30,nil)