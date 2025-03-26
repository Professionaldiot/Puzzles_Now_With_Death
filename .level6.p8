pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
    #include .enemy.p8
    #include random.p8
    #include .movement.p8:0
    cartdata("dc_capstone")
    menuitem(1,"save",function() save() end)
    menuitem(2,"load",function() lload() end)
    menuitem(3,"main menu",function() load("main-menu.p8") end)
    menuitem(4,"debug file on/off",function() debug_any() end)
    menuitem(5,"reset save data",function() r_save() end)
    botinit()
    player_init()
    r_save(false)
    if dget(13) then
        dset(13, false)
        lload()
    end
    if dget(12) == 0 then
		dset(12,1)
	end
end

function _update()
    player_update()
    manage_health()
    player_animate()
    cam_update(0, 0, 0)
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
    map(0,0)
    spr(player.sp, player.x, player.y, 1, 1, player.flp)
    spr(atk_spr.spr, atk_spr.x, atk_spr.y, 1, 1, atk_spr.flp)
    if proj.dx != 0 then
        spr(24, proj.x, proj.y, 1, 1, proj.flp)
    end
    draw_health()
end

__gfx__
0000000000444000bbbbbbbbbbbbbbbb0000222222220000000000000000000090000000500d0600000000000000000000000000000000000000000000000000
00000000004ff0003bbbb333333bbbbb000022222222000000000000000000000955000a050d0600000000000000000000000000000000000000000000000000
0070070000fff0003333333333333bbb0000000000000000000000000000000005906aa0050d0060000000000000000000000000000000000000000000000000
000770000333330099933399999a33bb000000000000000000000000000000000509a6000500d060000000000000000000000000000000000000000000000000
000770000f333f00a4493aaa6459a33322220000000022220000000000000000006900500050d060000000000000000000000000000000000000000000000000
007007000f111f004644645444445433222200000000222200000000000000000aa690500050d060000000000000000000000000000000000000000000000000
00000000005010004445444445455443000000000000000000000000000000000a005599005d0600000000000000000000000000000000000000000000000000
0000000000005000454444644645446300000000000000000000000000000000a000000905dd0600000000000000000000000000000000000000000000000000
0000000000444000bbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000444000
00444000004ff000bbbbb3330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000074f000
004ff00000fff000bbb3333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007ff4000
00fff00003333300bb33a999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000733344f0
033333000f333f00333a9546000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a9666550
0f111f000f111f003365444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070114400
0f101f00001050003445545400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007104000
00505000005000003644546400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000745000
004440000000000044444444bbbbbbbb516226155555555500000000000000000000000000000000000000000000000000000000000000000000000000444000
004ff0000044400004000040333bbbbb5162261551622615000000000000000000000000000000000000000000000000000000000000000000000000004ff000
00fff000004ff0004444444435333333516226155162261500000000000000000000000000000000000000000000000000000000000000000000000000fff000
f33333f000fff00004000040544563aa51622615516226150000000000000000000000000000000000000000000000000000000000000000000000000f333300
003330000333330044444444a44444445162261551622615000000000000000000000000000000000000000000000000000000000000000000000000f5333566
001110000f333f000400004046444464516226155162261500000000000000000000000000000000000000000000000000000000000000000000000055665f00
00505000051115004444444405000050516226155162261500000000000000000000000000000000000000000000000000000000000000000000000050511000
00000000000000000400004004000040516226155162261500000000000000000000000000000000000000000000000000000000000000000000000000505000
00000000004440000044400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004ff000004ff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044400000000000
0000000000fff0f0f0fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004ff00000000000
44400000f33333f0f33333f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000333330000000000
4ff00000003330000033300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f333f0000000000
fff3ff00001110000011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f111f00000ff000
3333115000501000001050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010004ff33115
3ff33115000050000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050500044f33115
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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

