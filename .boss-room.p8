pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

function _init()
    #include .movement.p8
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
    dset(12,1)
    if dget(13,true) then
      dset(13,false)
      lload()
    end
end

function _update()
    player_update()
    update_bot(player.x, player.y, time())
    cam_update(0, 1024, 562)
    player_animate()
    make_circle()
    manage_health()
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
    map(0,0)
    spr(bot.spr,bot.x,bot.y,1,1,bot.flp)
    spr(player.sp,player.x,player.y,1,1,player.flp)
    spr(atk_spr.spr, atk_spr.x, atk_spr.y)
    draw_health()
    draw_circle()
end

__gfx__
0000000000000000bbbbbbbbbbbbbbbb0000222222220000000000000000000090000000500d0600000000000000000000000000000000000000000000000000
00000000000000003bbbb333333bbbbb000022222222000000000000000000000955000a050d0600000000000000000000000000000000000000000000000000
00700700000000003333333333333bbb000000000000000008eeeee00000000005906aa0050d0060000000000000000000000000000000000000000000000000
0007700000dddd0099933399999a33bb0000000000000000088888e0000000000509a6000500d060000000000000000000000000000000000000000000000000
000770000dddddd0a4493aaa6459a33322220000000022220888888000000000006900500050d060000000000000000000000000000000000000000000000000
007007000dcddcd046446454444454332222000000002222022228800288eee00aa690500050d060000000000000000000000000000000000000000000000000
000000000dddddd0444544444545544300000000000000005dd666665dd666660a005599005d0600000000000000000000000000000000000000000000000000
0000000000dddd004544446446454463000000000000000055555dd655555dd6a000000905dd0600000000000000000000000000000000000000000000000000
0000000000000000bbbbbbbb45544556000000669455455665544554000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000bbbbb3339999aaa60000005a99999aa66aaa9999000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000bbb33333333333330000005a0000000033333333000000000000000000000000000000000000000000000000000000000000000000000000
00000000000dddd0bb33a99933aa333a000000490000000033aa333a000000000000000000000000000000000000000000000000000000000000000000000000
0000000000ddcdcd333a9546a99444330000005900000000a9944433000000000000000000000000000000000000000000000000000000000000000000000000
00dddd000ddddddd3365444446446454000000590000000046446454000000000000000000000000000000000000000000000000000000000000000000000000
0dcddcd0ddddddd03445545444454444000000490000000044454444000000000000000000000000000000000000000000000000000000000000000000000000
00dddd0000dddd003644546445444464000000990000000045444464000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000555500516226155555555500000000000000000000000000000000000000000000000000000000000000000000000000000000
00dddd00000dd0000000000000599700516226155111111500000000000000000000000000000000000000000000000000000000000000000000000000000000
0dcddcd0000dd0000000000055555777516226155166661500000000000000000000000000000000000000000000000000000000000000000000000000000000
0dddddd0000dd0000000000056666667516226155162261500000000000000000000000000000000000000000000000000000000000000000000000000000000
0dddddd000dddd000000000056666665516226155162261500000000000000000000000000000000000000000000000000000000000000000000000000000000
00dddd000dddddd00000000056666665516226155162261500000000000000000000000000000000000000000000000000000000000000000000000000000000
000dd0000dcddcd000000000d6666665516226155162261500000000000000000000000000000000000000000000000000000000000000000000000000000000
000dd00000dddd0000000000dddd5555516226155162261500000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000dddd00000dd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000dcddcd000dddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000dddddd000dddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000dddddd00dddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000ddd00dddddd00dddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000dcdcd00dddd000dddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ddddddd00dddd000dcddcd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088888800dddddd0
dddddddd000dd00000dddd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088288288dd5dd5dd
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00008880088888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0008a8a808a88a800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888888088888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888888008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
__gff__
0000010120400000000000000000000000000101000001000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
2400000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000120202020202020203000000000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000012020202020202020202020202020202030000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
