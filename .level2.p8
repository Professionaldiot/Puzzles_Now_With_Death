pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

function _init()
	#include .movement.p8
	#include .enemy.p8
	#include random.p8
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
	player_update()
	box_update()	
	btn_update(butts, player)
	if player.x >= 256 then
		if box[3]['x'] > 240 then
			spring_update(3)
		else
			spring_update(1)
		end
	else
		spring_update(3)
	end
	manage_health()
	cam_update(0, 328, 48)
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
	draw_health()
end
__gfx__
0000000000000000bbbbbbbbbbbbbbbb9999999951622615555555550000000090000000500d0600000000000000000000000000000000000000000000000000
00000000000000003bbbb333333bbbbb9d4444695d0000655d000065000000000955000a050d0600000000000000000000000000000000000000000000000000
00700700000000003333333333333bbb94d4464950d0060550d006050000000005906aa0050d0060000000000000000000000000000000000000000000000000
0007700000dddd0099933399999a33bb944d6449500d6005500d6005000000000509a6000500d060000000000000000000000000000000000000000000000000
000770000dddddd0a4493aaa6459a3339446d4495006d0055006d00500000000006900500050d060000000000000000000000000000000000000000000000000
007007000dcddcd0464464544444543394644d4950600d0550600d05000000000aa690500050d060000000000000000000000000000000000000000000000000
000000000dddddd04445444445455443964444d9560000d5560000d5000000000a005599005d0600000000000000000000000000000000000000000000000000
0000000000dddd00454444644645446399999999500000055000000500000000a000000905dd0600000000000000000000000000000000000000000000000000
0000000000000000bbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000bbbbb33300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000bbb3333308eeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000dddd0bb33a999088888e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000ddcdcd333a954608888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00dddd000ddddddd33654444022228800288eee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0dcddcd0ddddddd0344554545dd666665dd666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00dddd0000dddd003644546455555dd655555dd60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000055555555516226150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00dddd00000dd0000000000051622615516226150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0dcddcd0000dd0000000000051622615516226150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0dddddd0000dd0000000000051622615516226150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0dddddd000dddd000000000051622615516226150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00dddd000dddddd00000000051622615516226150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000dd0000dcddcd00000000051622615516226150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000dd00000dddd000000000051622615516226150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000dddd00000dd000dd005566000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000dcddcd000dddd000dddd665055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000dddddd000dddd0005550000dd0055660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000dddddd00dddddd0dd0055660dddd6d50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000ddd00dddddd00dddddd00dddd665dd0055660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000dcdcd00dddd000dddddd0055500000dddd6d50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ddddddd00dddd000dcddcd0dd000556dd550066000000000000000000000000000000000000000000000000000000000000000000000000000000000dddddd0
dddddddd000dd00000dddd000ddddd660dddd66000000000000000000000000000000000000000000000000000000000000000000000000000000000dd5dd5dd
__gff__
0000010100050500000000000000000000000100000000000000000000000000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
2400000000000000230000000000000000000000000000000000000000000000000000000000000000002300000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000240000000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000240000000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000240000000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000240000000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000240000000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000050000000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2402020202020202020202020306120202020202020203000000000000000000000000000000000000002400000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000023000000000000000000000000000000000000002400000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000024120202020202020203000000000000000000002400000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000024000000000023000000000000000000000000002400000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000024000000000005000000230000000000000000002400000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202020202030600001202020203000006020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000230000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000120202020202020202020202030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
