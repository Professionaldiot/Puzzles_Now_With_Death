pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

function _init()
	#include .movement.p8:0
	#include .movement.p8:2
	#include .enemy.p8
	#include random.p8
	#include .movement2.p8
	cartdata("dc_capstone")
	player_init()
	spring_init()
	btn_init()
	botinit()
	box_init()
	r_save(false)
	menuitem(1,"save",function() save() end)
	menuitem(2,"load",function() lload() end)
	menuitem(3,"main menu",function() load("main-menu.p8") end)
	menuitem(4,"level reset",function() reset_level() end)
	menuitem(5,"health = 1",function() player.health = 1 end)
	if dget(12) > 0 and dget(12) < 2 then
		dset(12,2)
	end
	if dget(13,true) then
		lload()
		
		player.health = dget(4)
		dset(13,false)
	end
end

function _update()
	if butts[5].sp == 20 then
		save()
    	r_save(false)
		dset(15, 3)
		load(butts[5].act)
	end
	player_update()
	box_update()	
	btn_update(butts, player)
	if player.x >= 256 then
		if box[3].x > 240 then
			spring_update(3)
		else
			spring_update(1)
		end
	else
		spring_update(3)
	end
	manage_health()
	cam_update(0, 344, 48)
	player_animate()
end

function _draw()
	cls()
	map(64 + (player.x - 8)/17, 0, cam_x, cam_y)
	map(0,0)
	btn_draw(butts)
	spring_draw()
	box_draw()
	spr(player.sp,player.x,player.y,1,1,player.flp)
	spr(atk_spr.spr, atk_spr.x, atk_spr.y, 1, 1, atk_spr.flp)
	if proj.dx != 0 then
        spr(24, proj.x, proj.y, 1, 1, proj.flp)
    end
	draw_health()
end
__gfx__
0000000000444000bbbbbbbbbbbbbbbb9999999951622615555555550000000090000000500d0600000000000000000000000000000000000000000000000000
00000000004ff0003bbbb333333bbbbb9d4444695d0000655d000065000000000955000a050d0600000000000000000000000000000000000000000000000000
0070070000fff0003333333333333bbb94d4464950d0060550d006050000000005906aa0050d0060000000000000000000000000000000000000000000000000
000770000333330099933399999a33bb944d6449500d6005500d6005000000000509a6000500d060000000000000000000000000000000000000000000000000
000770000f333f00a4493aaa6459a3339446d4495006d0055006d00500000000006900500050d060000000000000000000000000000000000000000000000000
007007000f111f00464464544444543394644d4950600d0550600d05000000000aa690500050d060000000000000000000000000000000000000000000000000
00000000005010004445444445455443964444d9560000d5560000d5000000000a005599005d0600000000000000000000000000000000000000000000000000
0000000000005000454444644645446399999999500000055000000500000000a000000905dd0600000000000000000000000000000000000000000000000000
0000000000444000bbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000444000
00444000004ff000bbbbb3330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000074f000
004ff00000fff000bbb3333308eeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007ff4000
00fff00003333300bb33a999088888e00000000000000000000000000000000099000050000000000000000000000000000000000000000000000000733344f0
033333000f333f00333a954608888880000000000000000000000000000000000aa66665000000000000000000000000000000000000000000000000a9666550
0f111f000f111f0033654444022228800288eee00000000000000000000000009900005000000000000000000000000000000000000000000000000070114400
0f101f0000105000344554545dd666665dd666660000000000000000000000000000000000000000000000000000000000000000000000000000000007104000
00505000005000003644546455555dd655555dd60000000000000000000000000000000000000000000000000000000000000000000000000000000000745000
00444000000000000000000055555555516226150000000000000000000000000000000000000000000000000000000000000000000000000000000000444000
004ff0000044400000000000516226155162261500000000000000000000000000000000000000000000000000000000000000000000000000000000004ff000
00fff000004ff0000000000051622615516226150000000000000000000000000000000000000000000000000000000000000000000000000000000000fff000
f33333f000fff000000000005162261551622615000000000000000000000000000000000000000000000000000000000000000000000000000000000f333300
003330000333330000000000516226155162261500000000000000000000000000000000000000000000000000000000000000000000000000000000f5333566
001110000f333f000000000051622615516226150000000000000000000000000000000000000000000000000000000000000000000000000000000055665f00
00505000051115000000000051622615516226150000000000000000000000000000000000000000000000000000000000000000000000000000000050511000
00000000000000000000000051622615516226150000000000000000000000000000000000000000000000000000000000000000000000000000000000505000
000000000044400000444000dd005566000000000000000000000000000000000000000000000000000000000000000000000000000000000044400000000000
00000000004ff000004ff0000dddd66505500000000000000000000000000000000000000000000000000000000000000000000000000000004ff00000000000
0000000000fff0f0f0fff00005550000dd00556600000000000000000000000000000000000000000000000000000000000000000000000000fff00000000000
44400000f33333f0f33333f0dd0055660dddd6d50000000000000000000000000000000000000000000000000000000000000000000000000333330000000000
4ff0000000333000003330000dddd665dd0055660000000000000000000000000000000000000000000000000000000000000000000000000f333f0000000000
fff3ff000011100000111000055500000dddd6d50000000000000000000000000000000000000000000000000000000000000000000000000f111f00000ff000
333311500050100000105000dd000556dd550066000000000000000000000000000000000000000000000000000000000000000000000000001010004ff33115
3ff3311500005000005000000ddddd660dddd6600000000000000000000000000000000000000000000000000000000000000000000000000050500044f33115
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
__gff__
0000010100050500000000000000000000000100000000000000000000000000000000010100000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
2400000000000000230000000000000000000000000000000000000000000000000000000000000000002300000000000000000000000000240024000000000080808080808080808080808080808080808080808080808080808080808081828380808080808080808080808080808000000000000000000000000000000000
24000000000000002400000000000000000000000000000000000000000000000000000000000000000024000000000000000000000000002400240000000000808080808080808080808485808080808080808080808080808080808080919293808080808080a1a2a380808080808000000000000000000000000000000000
24000000000000002400000000000000000000000000000000000000000000000000000000000000000024000000000000000000000000002400240000000000808080808080808080808080808080808080808080808080808080808080808080808080808080b1b2b380808080808000000000000000000000000000000000
2400000000000000240000000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000240024000000000080818283808080808080808080808080808080808080a1a2a3808080808080808080808080808080808080808080808000000000000000000000000000000000
2400000000000000240000000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000240024000000000080919293808080808080808080a1a2a3808080808080b1b2b3808080808080808080808080808080808080808080808000000000000000000000000000000000
2400000000000000240000000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000240024000000000080808080808080808080808080b1b2b3808080808080808080808080808080808080808080808080808081828380808000000000000000000000000000000000
24000000000000000500000000000000000000000000000000000000000000000000000000000000000024000000000000000000000000002400240000000000808080808080808080808080808080808080808080808080808080808080a1a2a380808080808080808091929380808000000000000000000000000000000000
2402020202020202020202020306120202020202020203000000000000000000000000000000000000002400000000000000000000000000240024000000000080808080808080808080808080808080818283808080acbd808080808080b1b2b380808080808080808080808080808000000000000000000000000000000000
240000000000000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000024002400000000008080808080a1a2a380808080808080809192938080ab90bb808080808080808080808080808080a1a2a380808080808000000000000000000000000000000000
240000000000000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000024002400000000008080808080b1b2b380808080808080808080aebfaa909090babd80808080808080808080808080b1b2b380808080808000000000000000000000000000000000
2400000000000000000000000000000000000000000023000000000000000000000000000000000000002400000000000000000000000000240024000000000080808080808080808080808080b48899bfaa90909090909090bb8080808080808080808080808080808080808080808000000000000000000000000000000000
2400000000000000000000000000000000000000000024120202020202020203000000000000000000002400000000000000000000000000240024000000000080808080808080abbabe80b986b69fa790909090909090909090babe808080808080808080808080808080808080808000000000000000000000000000000000
240000000000000000000000000000000000000000002400000000002300000000000000000000000000240000000000000000000000000024000000000000008080808080adaa90909d8ab5b0b0b08f94a49e9ca590909090909090bbae80808080808080808080808080808080808000000000000000000000000000000000
2400000000000000000000000000000000000000000024000000000005000000230000000000000000002400000000000000000000000000050000000000000080808080acaa9090909bb7b0b0b0b0b0b08fb69f95909090909090909090babe8080808080808080808080808080808000000000000000000000000000000000
020202020202020202020202020202020202020202020202020202020202020202020203060000120202020300000602020202020202020202020300000000008080bfaa90909e9c9ab6b0b0b0b0b0b0b0b0b0b0b094a49e9090909090909090bb80808080808080808080808080808000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000024000000000000000000000023000000000000000000000000000000008080909090b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0909090909090909080808080808080808080808080808000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000120202020202020202020202030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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

