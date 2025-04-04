pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
    #include .enemy.p8
    #include random.p8
    #include .movement.p8
    cartdata("dc_capstone")
    menuitem(1,"save",function() save() end)
    menuitem(2,"load",function() lload() end)
    menuitem(3,"main menu",function() load("main-menu.p8") end)
    menuitem(5,"restart level",function() reset_level() end)
    botinit()
    player_init()
    p = {}
    weapon_xs = {128, 240, 128, 472, 304}
    weapon_ys = {32, 32, 96, 48, 128}
    pw = {{atk_mult = 1.25, sp = 75, ranged = false}, 
            {atk_mult = 1.35, sp = 76, ranged = false},
            {atk_mult = 1.9, sp = 77, ranged = false},
            {atk_mult = 2.1, sp = 78, ranged = false},
            {atk_mult = 2.4, sp = 79, ranged = false}
            }
    weapon_pickup_init(weapon_xs, weapon_ys, pw, 2, 3)
    --weapons need atk_mult, sp, ranged
    if dget(13,true) then
        dset(13,false)
        lload()
    else
        rsave()
    end
    lvl_buttons = {{x = 496, y = 144, sp = 6, p = false, sfx = 0}}
    special_pickup_init(328, 32, 51, 51)
    if dget(12) != 1 then
		dset(12,1)
	end

end

function _update()
    player_update()
    update_weapons()
    btn_update(lvl_buttons, player)
    if lvl_buttons[1].sfx != 0 then
        save()
        r_save(false, false)
        dset(12, 11)
        dset(13, true)
		dset(6, player.m_base_dmg)
        dset(7, player.r_base_dmg)
        dset(8, player.m_start_dmg)
        dset(9, player.r_start_dmg)
        load(".boss-room.p8")
    end
    special_pickup_update()
    ladder()
    stairs()
    manage_health()
    player_animate()
    cam_update(0, 384, 32)
end

function print_tuts()
    --⬇️⬆️⬅️➡️
    local jmp = "press ⬆️ to jump"
    local lorr = "press ⬅️ or ➡️ to move"
    local lorr2 = "in that direction"
    local strs = "hold ⬅️ or ➡️ to"
    local strs2 = "ascend/descend stairs"
    local ldr = "hold ⬇️ or ⬆️ to"
    local ldr2 = "ascend/descend ladders"
    local dne = "the button on the far    right"
    local dne2 = "of the map ends the level and"
    local dne3 = "brings you to the boss room"
    local star = "this is a special pickup!"
    local star2 = "they will be locked behind"
    local star3 = "complicated puzzles, but they"
    local star4 = "give you x2.5 base mult"
    local star5 = "(inlcuding weapons base mult)"
    local star6 = "when in the boss room!"
    print(jmp, 144-(#jmp/2),121)
    print(lorr, 24-(#lorr/2), 113)
    print(lorr2, 24-(#lorr2/2) + (abs((#lorr - #lorr2))/2)*5, 121)
    print(strs, 207-(#strs/2) + (#strs2 - #strs), 97)
    print(strs2, 207-(#strs2/2), 105)
    print(ldr, 313, 137)
    print(ldr2, 304, 145)
    print(dne, 384, 105)
    print(dne2, 384, 113)
    print(dne3, 384, 121)
    print(star, 284, 49)
    print(star2, 284 + (#star - #star2)*2, 57)
    print(star3, 284 + (#star - #star3)*2, 65)
    print(star4, 284 + (#star - #star4)*2, 73)
    print(star5, 284 + (#star - #star5)*2, 81)
    print(star6, 284 + (#star - #star6)*2, 89)
end

function _draw()
    cls()
    map_x = 64 + ((player.x - 8)/5)
	if map_x >= 100 then
	  map_x -= 36
	end
	if cam_x >= 239 and map_x >= 100 then
		map_x -= 36
	end
	map(map_x, mid(0, 0 + (player.y - 112)/10, 512), cam_x, cam_y)
    btn_draw(lvl_buttons)
    draw_weapons()
    map(0,0)
    print_tuts()
    spr(player.sp, player.x, player.y, 1, 1, player.flp)
    special_pickup_draw()
    spr(atk_spr.spr, atk_spr.x, atk_spr.y, 1, 1, atk_spr.flp)
    if proj.dx != 0 then
        spr(24, proj.x, proj.y, 1, 1, proj.flp)
    end
    draw_health()
end

__gfx__
0000000000444000bbbbbbbbbbbbbbbb0000222222220000000000000000000090000000500d0600000000000000000000000000000000000000000000000000
00000000004ff0003bbbb333333bbbbb000022222222000000000000000000000955000a050d0600000000000000000000000000000000000000000000000000
0070070000fff0003333333333333bbb000000000000000008eeeee00000000005906aa0050d0060000000000000000000000000000000000000000000000000
000770000333330099933399999a33bb0000000000000000088888e0000000000509a6000500d060000000000000000000000000000000000000000000000000
000770000f333f00a4493aaa6459a33322220000000022220888888000000000006900500050d060000000000000000000000000000000000000000000000000
007007000f111f0046446454444454332222000000002222022228800288eee00aa690500050d060000000000000000000000000000000000000000000000000
0000000000501000444544444545544300000000000000005dd666665dd666660a005599005d0600000000000000000000000000000000000000000000000000
00000000000050004544446446454463000000000000000055555dd655555dd6a000000905dd0600000000000000000000000000000000000000000000000000
0000000000444000bbbbbbbbaaaaaaaaaaaaaaaa9999999a00000000000000000000000000000000000000000000000000000000000000000000000000444000
00444000004ff000bbbbb333555d666a6666dd55455d66660000000000000000000000000000000000000000000000000000000000000000000000000074f000
004ff00000fff000bbb3333349999999444444444444444400000000000000000000000000000000000000000000000000000000000000000000000007ff4000
00fff00003333300bb33a999dd6600000000000000000000000000000000000099000050000000000000000000000000000000000000000000000000733344f0
033333000f333f00333a954600006d00000000000000000000000000000000000aa66665000000000000000000000000000000000000000000000000a9666550
0f111f000f111f0033654444000000d0000000000000000000000000000000009900005000000000000000000000000000000000000000000000000070114400
0f101f00001050003445545400000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007104000
00505000005000003644546400000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000745000
004440000000000044444444bbbbbbbb516226155555555500000000000000000000000000000000000000000000000000000000000000000000000000444000
004ff0000044400004000040333bbbbb5162261551622615000000000000000000000000000000000000000000000000000000000000000000000000004ff000
00fff000004ff0004444444435333333516226155162261500000000000000000000000000000000000000000000000000000000000000000000000000fff000
f33333f000fff00004000040544563aa51622615516226150000000000000000000000000000000000000000000000000000000000000000000000000f333300
003330000333330044444444a44444445162261551622615000000000000000000000000000000000000000000000000000000000000000000000000f5333566
001110000f333f000400004046444464516226155162261500000000000000000000000000000000000000000000000000000000000000000000000055665f00
00505000051115004444444405000050516226155162261500000000000000000000000000000000000000000000000000000000000000000000000050511000
00000000000000000400004004000040516226155162261500000000000000000000000000000000000000000000000000000000000000000000000000505000
00000000000444000044400000077000000770000007700000077000000000000000000000000000000000000000000000000000000000000044400000000000
000000000004ff00004ff00000aaa7000088870000eee70000bbb70000000000000000000000000000000000000000000000000000000000004ff00000000000
00000000000fff0ff0fff000aaaaaa7788888877eeeeee77bbbbbb770000000000000000000000000000000000000000000000000000000000fff00000000000
444000000f33333ff33333f09aaaaaaa288888888eeeeeee3bbbbbbb000000000000000000000000000000000000000000000000000000000333330000000000
4ff00000000333000033300009aaaaa00288888008eeeee003bbbbb0000000000000000000000000000000000000000000000000000000000f333f0000000000
fff3ff0000011100001110000099aa00002288000088ee000033bb00000000000000000000000000000000000000000000000000000000000f111f00000ff000
33331150000501000010500009999aa00222288008888ee003333bb000000000000000000000000000000000000000000000000000000000001010004ff33115
3ff3311500000500005000009990099a222002288880088e3330033b000000000000000000000000000000000000000000000000000000000050500044f33115
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007700000000000000070000000000050000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000076600000000000000760000000000050000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000776000000dd0000007660000000000575000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000766000000d1dd0000d6600000000000070000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dd7760000001101d000d50006606000000070000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dd600000551001d00d50000055d000000070000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000525d0000515000010d50000000d287000066d000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000005505000055000001d500000000d00288665ddd66
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000500000055000005550000555500055555005555550555555500000000
00000000000000000000000000000000000000000000000000000000000000000000000500000055000005550000555500055555005555550555555500000000
00000000000000000000000000000000000000000000000000000000000000000000000500000055000005550000555500055555005555550555555500000000
00000000000000000000000000000000000000000000000000000000000000000000000500000055000005550000555500055555005555550555555500000000
00000000000000000000000000000000000000000000000000000000000000000000000500000055000005550000555500055555005555550555555500000000
00000000000000000000000000000000000000000000000000000000000000000000000500000055000005550000555500055555005555550555555500000000
00000000000000000000000000000000000000000000000000000000000000000000000500000055000005550000555500055555005555550555555500000000
00000000000000000000000000000000000000000000000000000000000000000000000500000055000005550000555500055555005555550555555500000000
00000000000000000000000000000000000000000000000000000000000000005000000055000000555000005555000055555000555555005555555055555555
00000000000000000000000000000000000000000000000000000000000000005000000055000000555000005555000055555000555555005555555055555555
00000000000000000000000000000000000000000000000000000000000000005000000055000000555000005555000055555000555555005555555055555555
00000000000000000000000000000000000000000000000000000000000000005000000055000000555000005555000055555000555555005555555055555555
00000000000000000000000000000000000000000000000000000000000000005000000055000000555000005555000055555000555555005555555055555555
00000000000000000000000000000000000000000000000000000000000000005000000055000000555000005555000055555000555555005555555055555555
00000000000000000000000000000000000000000000000000000000000000005000000055000000555000005555000055555000555555005555555055555555
00000000000000000000000000000000000000000000000000000000000000005000000055000000555000005555000055555000555555005555555055555555
ccccccccccccccccccccccccccccccccc9aaaaaaaaaaaaa9ccccc777ccccc766cccccccccccccccc11ccc77711ccc766cccccccccccccccccccc1111ddd55666
ccccccccccccccccccccccccccccccccc99aaaaaaaaaaa9cccc77665cccc7666cccccccccccccccc1117766511cc7666cccccccc1cccccccccc11111ddddd555
ccccccccccccccccc7777ccccccccccccc99aaaaaaaaa99ccc766655ccc77666cccccccccccccccc1176665511177666111ccccc1ccccccccc111111dddddddd
ccccccccccccccc777777777ccccccccccc99aaaaaaa99ccc766655dccc76665cccccccccccccccc1766655d1117666511111ccc111cccccc1111111dddddddd
ccccccccccccc6667777777777cccccccccc9999aa999ccc766665ddcc766655cccccc77cccccccc766665dd11766655111111771111ccccc1111111dddddddd
ccccccccccc66677777777776677ccccccccccc9999ccccc66665dddc766655dcccc7776ccccccc766665ddd1766655d1111777611111cc711111111dddddddd
ccccccccc66667777777777677777ccccccccccccccccccc666ddddd776655ddcc777666cccccc76666ddddd776655dd117776661111117611111111dddddddd
cccccccc66677777777777667777777ccccccccccccccccc66dddddd76665ddd77766666ccccc76666dddddd76665ddd777666661111176677777777dddddddd
11111111cc66677777777776677777777771111166711111777ccccc667ccccccccccccccccccccc111117771111176611111111111111111111111166666556
11111111cccc666666677777667777cc566771116667111156677ccc6667cccccccccccccccccccc1117766511117666111111111111111111111111dddd6665
11111111ccccccccc67777777777cccc5566671166677111556667cc66677ccccccccccccccccccc1176665511177666111111111111111111111111dddddd66
11111111ccccccccc677777777ccccccd556667156667111d556667c56667ccccccccccccccccccc1766655d11176665111111111111111111111111dddddddd
11111111ccccccccc66777777cccccccdd56666755666711dd566667556667cc77cccccccccccccc766665dd11766655111111771111111111111111dddddddd
11111111cccccccccc6677767cccccccddd56666d5566671ddd56666d556667c6777cccc7ccccccc66665ddd1766655d111177761111111711111111dddddddd
11111111ccccccccccc66666ccccccccddddd666dd556677ddddd666dd556677666777cc67cccccc666ddddd776655dd117776661111117611111111dddddddd
11111111ccccccccccccccccccccccccdddddd66ddd56667dddddd66ddd5666766666777667ccccc66dddddd76665ddd777666661111176677777777dddddddd
66666666cccccccccccccccccccccccc1111111111111111777ccccc667cc111ccccccc1ccccccc1ccccc111ccccc111ccccccccccccccccccccccccddddddd6
66666666cccc777777cccccccccccccc111111111111111156677cc166671111ccccc111ccccccc1ccc11111cccc1111ccccccccccccccccccccccccddddddd6
66666666ccc77777777ccccccccccccc11111111111111115566671166677111cccc1111cccccc11cc111111ccc11111ccccccccccccccccccccccccddddddd5
66666666cc777777777ccccccccccccc1111111111111111d556667156667111ccc11111ccccc111c1111111ccc11111ccccccccccccccccccccccccdddddddd
66666666c77777777777cccccccccccc7711111111111111dd5666675566671177111111cc11111111111111cc111111cccccc11ccccccccccccccccdddddddd
66666666c7777776677777cccccccccc6777111171111111ddd56666d5566671677711117111111111111111c1111111cccc1111ccccccc1ccccccccdddddddd
66666666c677777776777777cccccccc6667771167111111ddddd666dd55667766677711671111111111111111111111cc111111cccccc11ccccccccdddddddd
66666666c66777777767677777777ccc6666677766711111dddddd66ddd566676666677766711111111111111111111111111111ccccc11111111111dddddddd
ddddddddcc6776677667767776677777cccccccc6556666666655ddd6dddddddcccccccccccccccc111ccccc111ccccccccccccccccccccccccccccccccccccc
ddddddddccc66677667777666777766ccccccccc5666dddd555ddddd6dddddddcccccccccccccccc11111ccc1111cccccccccccccccccccccccccccccccccccc
ddddddddccccc6777777777777666ccccccccccc66dddddddddddddd5dddddddcccccccccccccccc111111cc11111ccccccccccccccccccccccccccccccccccc
ddddddddcccccc677777777666ccccccccccccccddddddddddddddddddddddddcccccccccccccccc1111111c11111ccccccccccccccccccccccccccccccccccc
ddddddddcccccc6677777766ccccccccccccccccdddddddddddddddddddddddd77cccccccccccc7711111111111111cc11cccccccccccccc11cccccccccccc11
ddddddddcccccccc666666ccccccccccccccccccdddddddddddddddddddddddd6677cccccccc7766111111111111111c1111cccc1ccccccc1111cccccccc1111
ddddddddccccccccccccccccccccccccccccccccdddddddddddddddddddddddd66677cccccc776661111111111111111111111cc11cccccc11111cccccc11111
ddddddddcccccccccccccccccccccccc77777777dddddddddddddddddddddddd6666777777776666111111111111111111111111111ccccc1111111111111111
ddddddddddddddddddddddddddddd777ddddd766dddddddddddddddddddddddd777ddddd667ddddddddddddddddddddd00000000000000000000000000000000
dddddd6666ddddddddddddddddd77665dddd7666dddddddddddddddddddddddd56677ddd6667dddddddddddddddddddd00000000000000000000000000000000
ddd66661166666dddddddddddd766655ddd77666dddddddddddddddddddddddd556667dd66677ddddddddddddddddddd00000000000000000000000000000000
dd6611111111166dddddddddd766655dddd76665ddddddddddddddddddddddddd556667d56667ddddddddddddddddddd00000000000000000000000000000000
d661111111111166dddddddd766665dddd766655dddddd77dddddddddddddddddd566667556667dd77dddddddddddddd00000000000000000000000000000000
d611111111111116dddddddd66665dddd766655ddddd7776ddddddd7ddddddddddd56666d556667d6777dddd7ddddddd00000000000000000000000000000000
66111111111111116ddddddd666ddddd776655dddd777666dddddd76ddddddddddddd666dd556677666777dd67dddddd00000000000000000000000000000000
61111111111111116ddddddd66dddddd76665ddd77766666ddddd76677777777dddddd66ddd5666766666777667ddddd00000000000000000000000000000000
6a1111111111111166ddddddddddddd7ddd5566600000000000000000000000066655ddd7ddddddd000000000000000000000000000000000000000000000000
641111111111111116ddddddddddddd7dddd56660000000000000000000000006665dddd7ddddddd000000000000000000000000000000000000000000000000
d677111111111111776ddddddddddd77dddd55660000000000000000000000006655dddd77dddddd000000000000000000000000000000000000000000000000
d677777117777777766ddddddddddd76ddddd566000000000000000000000000665ddddd67dddddd000000000000000000000000000000000000000000000000
dd6777777777766666dddddddddddd76dddddd6600000000000000000000000066dddddd67dddddd000000000000000000000000000000000000000000000000
ddd66677777766ddddddddddddddd766dddddd6600000000000000000000000066dddddd667ddddd000000000000000000000000000000000000000000000000
dddddd667766ddddddddddddddddd766ddddddd60000000000000000000000006ddddddd667ddddd000000000000000000000000000000000000000000000000
ddddddd6666dddddddddddddddddd766ddddddd60000000000000000000000006ddddddd667ddddd000000000000000000000000000000000000000000000000
__gff__
0000010120400000000000000000000000000101010100000000000000000000000002010101000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
2400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002480808080808080808080808080808080808080808080808080808080808081828380808080808080808080808080808080808080808080808080808080808080
2400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002480808080808080808080808080808080808080808080808080808080808091929380808080808080808080808080808080808080808080808080808080808080
2400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002480808080808080808080808080808080808182838080808080808080808080808080808080808080808080808080808080808080808182838080808080808080
2400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002480818283808080808080808080808080809192938080a1a2a3808080808080808080808080818283808080808080808080808080809192938080a1a2a3808080
2400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002480919293808081828380808080a1a2a3808080808080b1b2b3808080808080808080808080919293808081828380808080a1a2a3808080808080b1b2b3808080
2400000000000000000000020202020202020202020300000000000012020202030000000012020202020202020300000025050000000000000000000000002480808080808091929380808080b1b2b3808080808080808080808080808080808080808080808080808091929380808080b1b2b3808080808080808080808080
24000000000000000000000000000000000000000000000000000000000000000000006c7f7f7f7f7f7f7f7f7f7f7f7e00240005000000000000000000000024808080808080808080808080808080808080808080808080808080808080a1a2a380808080808080808080808080808080808080808080808080808080808080
24000000000000000000000000000000000000000000000000000000000000000000006e7f7f7f7f7f7f7f7f7f7f7f7f7924000005000000000000230000002480808080808080808080808080808080818283808080acbd808080808080b1b2b380808080808080808080808080808080808080818283808080acbd80808080
240000000000000000000000000000000000000000000000000000000000000000006c7f7f7f7f7f7f7f7f7f7f7f7f7f7f2400000005000000000022000000248080808080a1a2a380808080808080809192938080ab90bb8080808080808080808080808080808080a1a2a380808080808080809192938080ab90bb80808080
2400000000000000000000000000000000000000000000000000000000000000000000687f7f7f7f7f7f7f7f7f7f7f7b002400000000050000000022000000248080808080b1b2b380808080808080808080aebfaa909090babd808080808080808080808080808080b1b2b380808080808080808080aebfaa909090babd8080
240000000000000000000000000000000000000000020202020202020300000000006c7f7f7f7f7f7f7f7f7f7f7f7f7f7f24000000000005000000220000002480808080808080808080808080b48899bfaa90909090909090bb8080808080808182838080808080808080808080808080b48899bfaa90909090909090bb8080
2400000000000000000000000000000000000000000000000000000000000000000000007f7f7f7f7f7f7f7f7f7f7f780024000000000000050000220000002480808080808080abbabe80b986b69fa790909090909090909090babe808080809192938080808080808080abbabe80b986b69fa790909090909090909090babe
24000000000000000000000000000000000000000000000000697f7f7f7f7f7f7f7e0000041202020202022303000012020202020202020203000022120202248080808080adaa90909d8ab5b0b0c5cb94a49e9ca590909090909090bbae8080808080808080808080adaa90909d8ab5b0b0c5cb94a49e9ca590909090909090
2400000000000000000000000012020202020203000000006c7f7f7f7f7f7f7f7f7f7f040025000000000022000000247f7f7f7f7f7f7f7f7f7f7f227f7f7f2480808080acaa9090909bb7b0c5c3b5c9b08fb69f95909090909090909090babe8080808080808080acaa9090909bb7b0c5c3b5c9b08fb69f9590909090909090
246a7f7f7f7f7f7f7f7f7f7f7d00000000000000000000000000000000000000000004000024000000000022000000247f7f7f7f7f7f7f7f7f7f7f7f7f7f7b248080bfaa90909e9c9ab6c6c3b6b0b08fc8cbb0b0b094a49e9090909090909090bb8080808080bfaa90909e9c9ab6c6c3b6b0b08fc8cbb0b0b094a49e90909090
2400697f7f7f7f7f7f7f7f7a00000000687f7f7f7f7f7f7f7f00000000000000000400000024000004120322120202037f7f7f7f7f7f7f7f7f7f7f7f7f7b0024adaa909e9c9ab0b0b0b0c4b7b0b0b0b0afc9b0b0b0b0b0b094a490909090909090ba8080adaa909e9c9ab0b0b0b0c4b7b0b0b0b0afc9b0b0b0b0b0b094a49090
240000000000000000000000000000000000000000000000000000000000000004000000002400040000002200000000000000000000000000000000151413248e9c9ab6b0b0b0b0c5c3b6c0c1c2b0b0b0b0c8cac7b0b0b0b0b094a5909090909090bb808e9c9ab6b0b0b0b0c5c3b6c0c1c2b0b0b0b0c8cac7b0b0b0b0b094a5
2400000000000000000000000000000000001202020202000000000000000004000000000024037f7f7f7f7f7f7f7f7800000000000000000000000000000024b5b0b0b0b0b0c6c3b6b0b0d0d1d2b0b0b0b0b0b0b0c8cbb0b0b0b0959e9ca5909090909bb5b0b0b0b0b0c6c3b6b0b0d0d1d2b0b0b0b0b0b0b0c8cbb0b0b0b095
24000000000000000000000000000000000024000000240000000000000004000000000000247f7f7f7f7f7f7f7f7f7f7f000000000000000000000000000024b0b0b0b0b0b0c4b7b0b0b0b0b0b0b0b0b0b0b0b0b0b0c9b0b0b0b0b0b0b09590909d9ab0b0b0b0b0b0b0c4b7b0b0b0b0b0b0b0b0b0b0b0b0b0b0c9b0b0b0b0b0
02020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202b0b0b0b0b0d3d8b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0d4d9b0b0b0b0b0b0b094a49bb0b0b0b0b0b0b0d3d8b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0d4d9b0b0b0b0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b0b0b0b0b0c4b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0afc9b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0c4b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0afc9b0b0b0b0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0d4d9b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0d4d9b0b0b0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0afc9b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0afc9b0b0b0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0
__sfx__
001080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000282502a2502b2502c2502c2502c2502b25029250262501f2501b250132502520027200282000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 00024344

