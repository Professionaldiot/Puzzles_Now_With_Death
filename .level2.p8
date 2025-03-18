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
000000000044400000444000dd005566000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004ff000004ff0000dddd665055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000fff0f0f0fff00005550000dd0055660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44400000f33333f0f33333f0dd0055660dddd6d50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4ff0000000333000003330000dddd665dd0055660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fff3ff000011100000111000055500000dddd6d500000000000000000000000000000000000000000000000000000000000000000000000000000000000ff000
333311500050100000105000dd000556dd550066000000000000000000000000000000000000000000000000000000000000000000000000000000004ff33115
3ff3311500005000005000000ddddd660dddd6600000000000000000000000000000000000000000000000000000000000000000000000000000000044f33115
__gff__
0000010100050500000000000000000000000100000000000000000000000000000000010100000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
2400000000000000230000000000000000000000000000000000000000000000000000000000000000002300000000000000000000000000240024000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000240000000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000240024000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000240000000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000240024000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000240000000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000240024000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000240000000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000240024000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000240000000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000240024000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000050000000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000240024000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2402020202020202020202020306120202020202020203000000000000000000000000000000000000002400000000000000000000000000240024000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000240024000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000240024000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000023000000000000000000000000000000000000002400000000000000000000000000240024000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000024120202020202020203000000000000000000002400000000000000000000000000240024000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000024000000000023000000000000000000000000002400000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000024000000000005000000230000000000000000002400000000000000000000000000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202020202030600001202020203000006020202020202020202020203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000230000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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

