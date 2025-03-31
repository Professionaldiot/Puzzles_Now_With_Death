pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
    #include .enemy.p8
    #include random.p8
    #include .movement.p8:0
    #include .movement.p8:4
    #include .movement2.p8:0
    #include .movement2.p8:2
    cartdata("dc_capstone")
    menuitem(1,"save",function() save() end)
    menuitem(2,"load",function() lload() end)
    menuitem(3,"main menu",function() load("main-menu.p8") end)
    menuitem(4,"debug file on/off",function() debug_any() end)
    menuitem(5,"reset save data",function() r_save() end)
    botinit()
    boxes = {
        {x = 104, y = 112, dx = 0, dy = 0, w = 8, h = 8, sp = 38, g = 0.3, f = 0.8, acc = 0.5, mx_dy = 6, mx_dx = 3, boost = 4, start = 0},
    }
    buttons = {{x = 496, y = 24, sp = 6, p = false, sfx = 0}}
    player_init()
    r_save(false)
    springs = {
        {x = 392, y = 88, sp = 23, start = 23, down_sp = 24}
    }
    portals = {
        {x = 132, y = 112, link = 2, sp = 19, g_sp = 22, orig_sp = 19, cooldown = 0, cooldown_start = 32, flp_x = false, flp_y = false, shoot_x = 0},
        {x = 408, y = 112, link = 1, sp = 19, g_sp = 22, orig_sp = 19, cooldown = 0, cooldown_start = 32, flp_x = false, flp_y = false, shoot_x = 0},
        {x = 392, y = 112, link = 4, sp = 20, g_sp = 22, orig_sp = 20, cooldown = 0, cooldown_start = 32, flp_x = false, flp_y = false, shoot_x = 0},
        {x = 336, y = 40, link = 3, sp = 20, g_sp = 22, orig_sp = 20, cooldown = 0, cooldown_start = 32, flp_x = false, flp_y = false, shoot_x = 0},
        {x = 120, y = 40, link = 6, sp = 21, g_sp = 22, orig_sp = 21, cooldown = 0, cooldown_start = 32, flp_x = false, flp_y = false, shoot_x = 0},
        {x = 456, y = 112, link = 5, sp = 21, g_sp = 22, orig_sp = 21, cooldown = 0, cooldown_start = 32, flp_x = false, flp_y = false, shoot_x = 0}
    }
    if dget(13) then
        dset(13, false)
        lload()
    end
    if dget(12) != 4 then
		dset(12,4)
	end
end

function _update()
    player_update()
    box_update(boxes, buttons)
    btn_update(buttons, player)
    if buttons[1].sfx != 0 then
        save()
    	r_save(false)
		dset(12, 5)
		dset(6, player.r_base_dmg)
        dset(7, player.m_base_dmg)
		load(".boss-room.p8")
    end
    portal_update(portals, boxes)
    spring_update(1, springs, boxes)
    manage_health()
    player_animate()
    cam_update(0, 384, 0)
    camera(cam_x, cam_y)
end

function _draw()
    cls()
    map_x = 64 + ((player.x - 8)/40)
	if map_x >= 100 then
	  map_x -= 36
	end
	if cam_x >= 239 and map_x >= 100 then
		map_x -= 36
	end
	map(map_x, mid(0, 0 + (player.y - 112)/10, 512), cam_x, cam_y)
    map(0,0)
    spr(player.sp, player.x, player.y, 1, 1, player.flp)
    spr(atk_spr.spr, atk_spr.x, atk_spr.y, 1, 1, atk_spr.flp)
    if proj.dx != 0 then
        spr(24, proj.x, proj.y, 1, 1, proj.flp)
    end
    portal_draw(portals)
    btn_draw(buttons)
    box_draw(boxes)
    spring_draw(springs)
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
0000000000444000bbbbbbbb00000000000000000000000000000000dd0055660000000000000000000000000000000000000000000000000000000000444000
00444000004ff000bbbbb333000000000000000000000000000000000dddd665055000000000000000000000000000000000000000000000000000000074f000
004ff00000fff000bbb333330000000000000000000000000000000005550000dd00556600000000000000000000000000000000000000000000000007ff4000
00fff00003333300bb33a99900000000000000000000000000000000dd0055660dddd6d5000000000000000000000000000000000000000000000000733344f0
033333000f333f00333a9546066666600666666006666660066666600dddd665dd005566000000000000000000000000000000000000000000000000a9666550
0f111f000f111f0033654444628eeee661dcccc6649aaaa665d77776055500000dddd6d500000000000000000000000000000000000000000000000070114400
0f101f00001050003445545456622665566116655664466556655665dd000556dd55006600000000000000000000000000000000000000000000000007104000
005050000050000036445464555665555556655555566555555665550ddddd660dddd66000000000000000000000000000000000000000000000000000745000
004440000000000044444444bbbbbbbb516226155555555599999999516226155555555500000000000000000000000000000000000000000000000000444000
004ff0000044400004000040333bbbbb51622615516226159d4444695d0000655d000065000000000000000000000000000000000000000000000000004ff000
00fff000004ff0004444444435333333516226155162261594d4464950d0060550d0060500000000000000000000000000000000000000000000000000fff000
f33333f000fff00004000040544563aa5162261551622615944d6449500d6005500d60050000000000000000000000000000000000000000000000000f333300
003330000333330044444444a444444451622615516226159446d4495006d0055006d005000000000000000000000000000000000000000000000000f5333566
001110000f333f000400004046444464516226155162261594644d4950600d0550600d0500000000000000000000000000000000000000000000000055665f00
005050000511150044444444050000505162261551622615964444d9560000d5560000d500000000000000000000000000000000000000000000000050511000
00000000000000000400004004000040516226155162261599999999500000055000000500000000000000000000000000000000000000000000000000505000
00000000004440000044400000077000000770000007700000077000000000000000000000000000000000000000000000000000000000000044400000000000
00000000004ff000004ff00000aaa7000088870000eee70000bbb70000000000000000000000000000000000000000000000000000000000004ff00000000000
0000000000fff0f0f0fff000aaaaaa7788888877eeeeee77bbbbbb770000000000000000000000000000000000000000000000000000000000fff00000000000
44400000f33333f0f33333f09aaaaaaa288888888eeeeeee3bbbbbbb000000000000000000000000000000000000000000000000000000000333330000000000
4ff00000003330000033300009aaaaa00288888008eeeee003bbbbb0000000000000000000000000000000000000000000000000000000000f333f0000000000
fff3ff0000111000001110000099aa00002288000088ee000033bb00000000000000000000000000000000000000000000000000000000000f111f00000ff000
33331150005010000010500009999aa00222288008888ee003333bb000000000000000000000000000000000000000000000000000000000001010004ff33115
3ff3311500005000005000009990099a222002288880088e3330033b000000000000000000000000000000000000000000000000000000000050500044f33115
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
0000010120400000000000000000000000000100000000000000000000000000000002010101000505000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
2500000000000000000000000000000202020202020000000000000000020202020202020202020202020202000000000000020202020202020202020202020080808080808080808080808080808080808080808080808080808080808081828380808080808080808080808080808080808080808080808080808080808080
2400000000000000000000000000250000000000002500000000000025000000000000000000000000000025000000000000000000000000000000000025002580808080808080808080808080808080808080808080808080808080808091929380808080808080808080808080808080808080808080808080808080808080
2400000000000000000000000000240000000000002400000000000024000000000000000000000000000024000000000000000000000000000000000024002480808080808080808080808080808080808182838080808080808080808080808080808080808080808080808080808080808080808182838080808080808080
2400000000000000000000000000240000000000002400000000000024000000000000000000000000000024000000000000000000000000000000000027002480818283808080808080808080808080809192938080a1a2a3808080808080808080808080818283808080808080808080808080809192938080a1a2a3808080
2400000000000000000000000000240000000000002400000000000024000000000000000000000000000024000000001228120202020202020202020202032480919293808081828380808080a1a2a3808080808080b1b2b3808080808080808080808080919293808081828380808080a1a2a3808080808080b1b2b3808080
2400000000000000000000000000240000000000002700000000000024000000000000000000000000000024000000000000000000000000000000000000002480808080808091929380808080b1b2b3808080808080808080808080808080808080808080808080808091929380808080b1b2b3808080808080808080808080
24000000000000000000000000001202020202020203000000000000240012020202020202020202020202030000000000000000000000000000000000000024808080808080808080808080808080808080808080808080808080808080a1a2a380808080808080808080808080808080808080808080808080808080808080
2400000000000000000000000000000000000000000000000000000024000000000000000000000000000000000012030000000000000000000000000000002480808080808080808080808080808080818283808080acbd808080808080b1b2b380808080808080808080808080808080808080818283808080acbd80808080
240000000000000000000000000000000000000000000000000000002400000000000000000000000000000000000000000000000000000000000000000000248080808080a1a2a380808080808080809192938080ab90bb8080808080808080808080808080808080a1a2a380808080808080809192938080ab90bb80808080
240000000000000000000000000000000000000000000000000000002402020202020203000000000000000000000000000000000000000000000000000000248080808080b1b2b380808080808080808080aebfaa909090babd808080808080808080808080808080b1b2b380808080808080808080aebfaa909090babd8080
2400000000000000000000000000000000000000000000000000000024000000000000000202030000000000000000000000000000000000000000000000002480808080808080808080808080b48899bfaa90909090909090bb8080808080808182838080808080808080808080808080b48899bfaa90909090909090bb8080
2400000000000000000000000000000000000000000000000000000027000000000000000000000202030000000000000000000000000000000000000000002480808080808080abbabe80b986b69fa790909090909090909090babe808080809192938080808080808080abbabe80b986b69fa790909090909090909090babe
240000000000000000000000000000000000000000120202020202022400000000000000000000000000020202020202020203000000000000000000000000248080808080adaa90909d8ab5b0b0c5cb94a49e9ca590909090909090bbae8080808080808080808080adaa90909d8ab5b0b0c5cb94a49e9ca590909090909090
2400000000000000000000000000000000000000000000000000000024000000000000000000000000000000000000000000250000000000000000000000002480808080acaa9090909bb7b0c5c3b5c9b08fb69f95909090909090909090babe8080808080808080acaa9090909bb7b0c5c3b5c9b08fb69f9590909090909090
240000000000000000000000000000000000000000000000000000002400000000000000000000000000000000000000000024000000000000000000000000248080bfaa90909e9c9ab6c6c3b6b0b08fc8cbb0b0b094a49e9090909090909090bb8080808080bfaa90909e9c9ab6c6c3b6b0b08fc8cbb0b0b094a49e90909090
12020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203adaa909e9c9ab0b0b0b0c4b7b0b0b0b0afc9b0b0b0b0b0b094a490909090909090ba8080adaa909e9c9ab0b0b0b0c4b7b0b0b0b0afc9b0b0b0b0b0b094a49090
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008e9c9ab6b0b0b0b0c5c3b6c0c1c2b0b0b0b0c8cac7b0b0b0b0b094a5909090909090bb808e9c9ab6b0b0b0b0c5c3b6c0c1c2b0b0b0b0c8cac7b0b0b0b0b094a5
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b5b0b0b0b0b0c6c3b6b0b0d0d1d2b0b0b0b0b0b0b0c8cbb0b0b0b0959e9ca5909090909bb5b0b0b0b0b0c6c3b6b0b0d0d1d2b0b0b0b0b0b0b0c8cbb0b0b0b095
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b0b0b0b0b0b0c4b7b0b0b0b0b0b0b0b0b0b0b0b0b0b0c9b0b0b0b0b0b0b09590909d9ab0b0b0b0b0b0b0c4b7b0b0b0b0b0b0b0b0b0b0b0b0b0b0c9b0b0b0b0b0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b0b0b0b0b0d3d8b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0d4d9b0b0b0b0b0b0b094a49bb0b0b0b0b0b0b0d3d8b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0d4d9b0b0b0b0
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

