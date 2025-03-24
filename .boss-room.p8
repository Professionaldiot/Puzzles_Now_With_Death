pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

function _init()
    #include .movement.p8:0
    #include .movement2.p8:1
    #include .enemy.p8
    #include random.p8
    cartdata("dc_capstone")
    player_init()
    botinit()
    circle_init()
    menuitem(1,"save",function() save() end)
    menuitem(2,"load",function() lload() end)
    menuitem(3,"main menu",function() load("main-menu.p8") end)
    menuitem(4,"debug file on/off",function() debug_any() end)
    menuitem(5,"reset save data",function() r_save() end)
    if dget(13,true) then
      dset(13,false)
      lload()
    end
end

function _update()
    player_update()
    update_bot(player.x, player.y, time())
    cam_update(0, 184, 0)
    player_animate()
    make_circle()
    manage_health()
    player_hit_bot(player.x, player.y)
    bot_debug()
    if collide_map(bot,"right",0) then
        bot.x-=1
    elseif collide_map(bot,"left",0) then
        bot.x+=1
    end
    draw_bot(time())
end

function _draw()
    cls()
    map_x = 64 + ((player.x - 8)/4.5)
    if map_x >= 100 then
        map_x -= 36
    end
    map(map_x, mid(0, 0 + (player.y - 112)/10, 512), cam_x, cam_y)
    map(0,0)
    spr(bot.spr,bot.x,bot.y,1,1,bot.flp)
    spr(player.sp,player.x,player.y,1,1,player.flp)
    spr(atk_spr.spr, atk_spr.x, atk_spr.y, 1, 1, atk_spr.flp)
    if proj.dx != 0 then
        spr(24, proj.x, proj.y, 1, 1, proj.flp)
    end
    draw_health()
    draw_circle()
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
0000000000444000bbbbbbbb45544556000000669455455665544554000000000000000000000000000000000000000000000000000000000000000000444000
00444000004ff000bbbbb3339999aaa60000005a99999aa66aaa999900000000000000000000000000000000000000000000000000000000000000000074f000
004ff00000fff000bbb33333333333330000005a0000000033333333000000000000000000000000000000000000000000000000000000000000000007ff4000
00fff00003333300bb33a99933aa333a000000490000000033aa333a0000000099000050000000000000000000000000000000000000000000000000733344f0
033333000f333f00333a9546a99444330000005900000000a9944433000000000aa66665000000000000000000000000000000000000000000000000a9666550
0f111f000f111f003365444446446454000000590000000046446454000000009900005000000000000000000000000000000000000000000000000070114400
0f101f00001050003445545444454444000000490000000044454444000000000000000000000000000000000000000000000000000000000000000007104000
00505000005000003644546445444464000000990000000045444464000000000000000000000000000000000000000000000000000000000000000000745000
00444000000000000000000000555500516226155555555500000000000000000000000000000000000000000000000000000000000000000000000000444000
004ff0000044400000000000005997005162261551111115000000000000000000000000000000000000000000000000000000000000000000000000004ff000
00fff000004ff0000000000055555777516226155166661500000000000000000000000000000000000000000000000000000000000000000000000000fff000
f33333f000fff000000000005666666751622615516226150000000000000000000000000000000000000000000000000000000000000000000000000f333300
003330000333330000000000566666655162261551622615000000000000000000000000000000000000000000000000000000000000000000000000f5333566
001110000f333f000000000056666665516226155162261500000000000000000000000000000000000000000000000000000000000000000000000055665f00
005050000511150000000000d6666665516226155162261500000000000000000000000000000000000000000000000000000000000000000000000050511000
000000000000000000000000dddd5555516226155162261500000000000000000000000000000000000000000000000000000000000000000000000000505000
00000000004440000044400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044400000000000
00000000004ff000004ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004ff00000000000
0000000000fff0f0f0fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fff00000000000
44400000f33333f0f33333f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000333330000000000
4ff00000003330000033300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f333f0000000000
fff3ff00001110000011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f111f00000ff000
3333115000501000001050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010004ff33115
3ff33115000050000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050500044f33115
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007700000000000000070000000000050000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000076600000000000000760000000000050000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000776000000cc0000007660000000000575000
0000000000888800000000000000000000000000000000000000000000000000000000000000000000000000000766000000c1cc0000d6600000000000070000
0000888008888880000000000000000000000000000000000000000000000000000000000000000000000000dd7760000001101c000d50006606000000070000
0008a8a808a88a800000000000000000000000000000000000000000000000000000000000000000000000000dd600000551001c00d50000055d000000070000
0888888808888880000000000000000000000000000000000000000000000000000000000000000000000000525d0000515000010d50000000d287000066d000
88888888008888000000000000000000000000000000000000000000000000000000000000000000000000005505000055000001d500000000d00288665ddd66
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000088a8a80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800088888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08a88a80888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888880000088800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88a8a000008888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8888800088888a8a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888800008888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888888000088800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800000880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08a88a80000880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888880000880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888880008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800088888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0008800008a88a800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088000008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
0000010120400000000000000000000000000101000001000000000000000000000000000101000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
2400000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000080808080808080808080808080808080808080808080808080808080808081828380808080808080808080808080808080808080808080808080808080808080
2400000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000080808080808080808080808080808080808080808080808080808080808091929380808080808080808080808080808080808080808080808080808080808080
2400000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000080808080808080808080808080808080808182838080808080808080808080808080808080808080808080808080808080808080808182838080808080808080
2400000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000080818283808080808080808080808080809192938080a1a2a3808080808080808080808080818283808080808080808080808080809192938080a1a2a3808080
2400000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000080919293808081828380808080a1a2a3808080808080b1b2b3808080808080808080808080919293808081828380808080a1a2a3808080808080b1b2b3808080
2400000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000080808080808091929380808080b1b2b3808080808080808080808080808080808080808080808080808091929380808080b1b2b3808080808080808080808080
24000000000000000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000000000000000000000000000808080808080808080808080808080808080808080808080808080808080a1a2a380808080808080808080808080808080808080808080808080808080808080
2400000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000080808080808080808080808080808080818283808080acbd808080808080b1b2b380808080808080808080808080808080808080818283808080acbd80808080
240000000000000000000000000012020202020202020300000000000000000000000000000024000000000000000000000000000000000000000000000000008080808080a1a2a380808080808080809192938080ab90bb8080808080808080808080808080808080a1a2a380808080808080809192938080ab90bb80808080
240000000000000000000000000000000000000000000000000000000000000000000000000024000000000000000000000000000000000000000000000000008080808080b1b2b380808080808080808080aebfaa909090babd808080808080808080808080808080b1b2b380808080808080808080aebfaa909090babd8080
2400000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000080808080808080808080808080b48899bfaa90909090909090bb8080808080808182838080808080808080808080808080b48899bfaa90909090909090bb8080
2400000000000000000012020202020202020202020202020202030000000000000000000000240000000000000000000000000000000000000000000000000080808080808080abbabe80b986b69fa790909090909090909090babe808080809192938080808080808080abbabe80b986b69fa790909090909090909090babe
240000000000000000000000000000000000000000000000000000000000000000000000000024000000000000000000000000000000000000000000000000008080808080adaa90909d8ab5b0b0c5cb94a49e9ca590909090909090bbae8080808080808080808080adaa90909d8ab5b0b0c5cb94a49e9ca590909090909090
2400000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000080808080acaa9090909bb7b0c5c3b5c9b08fb69f95909090909090909090babe8080808080808080acaa9090909bb7b0c5c3b5c9b08fb69f9590909090909090
020202020202020202020202020202020202020202020202020202020202020202020202020202000000000000000000000000000000000000000000000000008080bfaa90909e9c9ab6c6c3b6b0b08fc8cbb0b0b094a49e9090909090909090bb8080808080bfaa90909e9c9ab6c6c3b6b0b08fc8cbb0b0b094a49e90909090
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000adaa909e9c9ab0b0b0b0c4b7b0b0b0b0afc9b0b0b0b0b0b094a490909090909090ba8080adaa909e9c9ab0b0b0b0c4b7b0b0b0b0afc9b0b0b0b0b0b094a49090
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008e9c9ab6b0b0b0b0c5c3b6c0c1c2b0b0b0b0c8cac7b0b0b0b0b094a5909090909090bb808e9c9ab6b0b0b0b0c5c3b6c0c1c2b0b0b0b0c8cac7b0b0b0b0b094a5
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b0b0b0b0b0b0c6c3b6b0b0d0d1d2b0b0b0b0b0b0b0c8cbb0b0b0b0959e9ca5909090909bb0b0b0b0b0b0c6c3b6b0b0d0d1d2b0b0b0b0b0b0b0c8cbb0b0b0b095
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
