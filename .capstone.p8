pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--[[
todo:
*add all the movement code to a seperate file and rename this file to level1
  > this includes any new mechanics from other levels, literally all the movement code
    and other player, puzzle checks will be there

*create a way to save the button layouts in any level

*create more levels

*update the bot to be able to jump and climb stairs and such
  > get bot gravity working
  > get bot collision down working
  > get bot climbing working
  > bot right and left collsion is working

*update the bot to let it attack the player
  > maybe update bot code to let multiple enemys be on screen at once

*actually create the story for this game

*design the character for the game

*actually create interesting bot desgins

]]
-->8
--all code
function _init()
  #include .enemy.p8
  #include .movement.p8
  cartdata("dc_capstone")
  menuitem(1,"save",function() save() end)
  menuitem(2,"load",function() lload() end)
  menuitem(3,"main menu",function() load("main-menu.p8") end)
  menuitem(4,"debug file on/off",function() debug_any() end)
  menuitem(5,"reset save data",function() r_save() end)
  player_init()
  botinit()
  td_init()
  lvl1_buttons={
  {x=352,y=112,sp=6,act="level2.p8",p=false},
  {x=136,y=48,sp=6,p=false},
  {x=24,y=24,sp=6,p=false}}
  dset(12,1)
  if dget(13,true) then
    dset(13,false)
    lload()
  end
end

--update and draw

function _update()
  if lvl1_buttons[1]["p"]==true then
    r_save()
    load(lvl1_buttons[1]["act"])
  elseif lvl1_buttons[2]["p"]==true then
    td_open()
  elseif lvl1_buttons[3]["p"]==true then
    td_open()
  end
  player_update()
  ladder()
  stairs()
  td_update()
  btn_update(lvl1_buttons,player)
  update_bot(player.x,time())
  if collide_map(bot,"right",0) then
		  bot.x-=1
		elseif collide_map(bot,"left",0) then
      bot.x+=1
  end
  draw_bot(time())
  player_animate()
 	cam_update()
end

function _draw()
  cls()
  map(0,0)
  btn_draw(lvl1_buttons)
  td_draw()
  spr(bot.spr,bot.x,bot.y,1,1,bot.flp)
  spr(player.sp,player.x,player.y,1,1,player.flp)
end

__gfx__
0000000000000000bbbbbbbbbbbbbbbb000022222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003bbbb333333bbbbb000022222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000003333333333333bbb000000000000000008eeeee0000000000000000000000000000000000000000000000000000000000000000000000000
0007700000dddd0099933399999a33bb0000000000000000088888e0000000000000000000000000000000000000000000000000000000000000000000000000
000770000dddddd0a4493aaa6459a333222200000000222208888880000000000000000000000000000000000000000000000000000000000000000000000000
007007000dcddcd046446454444454332222000000002222022228800288eee00000000000000000000000000000000000000000000000000000000000000000
000000000dddddd0444544444545544300000000000000005dd666665dd666660000000000000000000000000000000000000000000000000000000000000000
0000000000dddd004544446446454463000000000000000055555dd655555dd60000000000000000000000000000000000000000000000000000000000000000
0000000000000000bbbbbbbb45544556000000669455455665544554000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000bbbbb3339999aaa60000005a99999aa66aaa9999000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000bbb33333333333330000005a0000000033333333000000000000000000000000000000000000000000000000000000000000000000000000
00000000000dddd0bb33a99933aa333a000000490000000033aa333a000000000000000000000000000000000000000000000000000000000000000000000000
0000000000ddcdcd333a9546a99444330000005900000000a9944433000000000000000000000000000000000000000000000000000000000000000000000000
00dddd000ddddddd3365444446446454000000590000000046446454000000000000000000000000000000000000000000000000000000000000000000000000
0dcddcd0ddddddd03445545444454444000000490000000044454444000000000000000000000000000000000000000000000000000000000000000000000000
00dddd0000dddd003644546445444464000000990000000045444464000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000044444444bbbbbbbb516226155555555500000000000000000000000000000000000000000000000000000000000000000000000000000000
00dddd00000dd00004000040333bbbbb516226155111111500000000000000000000000000000000000000000000000000000000000000000000000000000000
0dcddcd0000dd0004444444435333333516226155166661500000000000000000000000000000000000000000000000000000000000000000000000000000000
0dddddd0000dd00004000040544563aa516226155162261500000000000000000000000000000000000000000000000000000000000000000000000000000000
0dddddd000dddd0044444444a4444444516226155162261500000000000000000000000000000000000000000000000000000000000000000000000000000000
00dddd000dddddd00400004046444464516226155162261500000000000000000000000000000000000000000000000000000000000000000000000000000000
000dd0000dcddcd04444444405000050516226155162261500000000000000000000000000000000000000000000000000000000000000000000000000000000
000dd00000dddd000400004004000040516226155162261500000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000dddd00000dd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000dcddcd000dddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000dddddd000dddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000dddddd00dddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000ddd00dddddd00dddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000dcdcd00dddd000dddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ddddddd00dddd000dcddcd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddd000dd00000dddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00088880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a8a88088888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088888a8a888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888888888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888880088800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888ffffff882222228888888888888888888888888888888888888888888888888888888888888888228228888ff88ff888222822888888822888888228888
88888f8888f882888828888888888888888888888888888888888888888888888888888888888888882288822888ffffff888222822888882282888888222888
88888ffffff882888828888888888888888888888888888888888888888888888888888888888888882288822888f8ff8f888222888888228882888888288888
88888888888882888828888888888888888888888888888888888888888888888888888888888888882288822888ffffff888888222888228882888822288888
88888f8f8f88828888288888888888888888888888888888888888888888888888888888888888888822888228888ffff8888228222888882282888222288888
888888f8f8f8822222288888888888888888888888888888888888888888888888888888888888888882282288888f88f8888228222888888822888222888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555550000000000000000000000000000000000000000005555555
55555550444444445555555566666666444444445555555555555555444444449999999905555550000000000011111111112222222222333333333305555555
55555550444444445555555566666666444444445555555555555555444444449999999905555550000000000011111111112222222222333333333305555555
55555550444444445555555566666666444444445555555555555555444444449999999905555550000000000011111111112222222222333333333305555555
55555550444444445555555566666666444444445555555555555555444444449999999905555550000000000011111111112222222222333333333305555555
55555550444444445555555566666666444444445555555555555555444444449999999905555550000000000011111111112222222222333333333305555555
55555550444444445555555566666666444444445555555555555555444444449999999905555550000000000011111111112222222222333333333305555555
55555550444444445555555566666666444444445555555555555555444444449999999905555550000000000011111111112222222222333333333305555555
55555550444444445555555566666666444444445555555555555555444444449999999905555550000000000011111111112222222222333333333305555555
5555555044444444aaaaaaaaaaaaaaaa999999999999999999999999999999999999999905555550000000000011111111177777777777733333333305555555
5555555044444444aaaaaaaaaaaaaaaa999999999999999999999999999999999999999905555550444444444455555555570000000000777777777705555555
5555555044444444aaaaaaaaaaaaaaaa999999999999999999999999999999999999999905555550444444444455555555570666666660777777777705555555
5555555044444444aaaaaaaaaaaaaaaa999999999999999999999999999999999999999905555550444444444455555555570666666660777777777705555555
5555555044444444aaaaaaaaaaaaaaaa999999999999999999999999999999999999999905555550444444444455555555570666666660777777777705555555
5555555044444444aaaaaaaaaaaaaaaa999999999999999999999999999999999999999905555550444444444455555555570666666660777777777705555555
5555555044444444aaaaaaaaaaaaaaaa999999999999999999999999999999999999999905555550444444444455555555570666666660777777777705555555
5555555044444444aaaaaaaaaaaaaaaa999999999999999999999999999999999999999905555550444444444455555555570666666660777777777705555555
55555550555555550000000000000000000000000000000000000000000000000000000005555550444444444455555555570666666660777777777705555555
55555550555555550000000000000000000000000000000000000000000000000000000005555550444444444455555555570000000000777777777705555555
555555505555555500000000000000000000000000000000000000000000000000000000055555508888888888999999999777777777777bbbbbbbbb05555555
5555555055555555000000000000000000000000000000000000000000000000000000000555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555055555555000000000000000000000000000000000000000000000000000000000555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555055555555000000000000000000000000000000000000000000000000000000000555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555055555555000000000000000000000000000000000000000000000000000000000555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555055555555000000000000000000000000000000000000000000000000000000000555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555000000000555555555555555500000000000000000000000000000000000000000555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555000000000555555555555555500000000000000000000000000000000000000000555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555000000000555555555555555500000001000000000000000000000000000000000555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
55555550000000005555555555555555000000171000000000000000000000000000000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550000000005555555555555555000001000100000000000000000000000000000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550000000005555555555555555000017000710000000000000000000000000000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550000000005555555555555555000001000100000000000000000000000000000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550000000005555555555555555000000171000000000000000000000000000000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550000000000000000000000000555555510000000000000000000000000000000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550000000000000000000000000555555550000000000000000000000000000000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550000000000000000000000000555555550000000000000000000000000000000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550000000000000000000000000555555550000000000000000000000000000000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550000000000000000000000000555555550000000000000000000000000000000005555550000000000000000000000000000000000000000005555555
55555550000000000000000000000000555555550000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000555555550000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000555555550000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000005555555500000000000000000000000005555550000000555556667655555555555555555555555555555555
55555550000000000000000000000000000000005555555500000000000000000000000005555550000000555555666555555555555555555555555555555555
5555555000000000000000000000000000000000555555550000000000000000000000000555555000000055555556dddddddddddddddddddddddd5555555555
555555500000000000000000000000000000000055555555000000000000000000000000055555500060005555555655555555555555555555555d5555555555
55555550000000000000000000000000000000005555555500000000000000000000000005555550000000555555576666666d6666666d666666655555555555
55555550000000000000000000000000000000005555555500000000000000000000000005555550000000555555555555555555555555555555555555555555
55555550000000000000000000000000000000005555555500000000000000000000000005555550000000555555555555555555555555555555555555555555
55555550000000000000000000000000000000005555555500000000000000000000000005555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000055555555555555550000000005555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000055555555555555550000000005555556665666555556667655555555555555555555555555555555
55555550000000000000000000000000000000000000000055555555555555550000000005555556555556555555666555555555555555555555555555555555
5555555000000000000000000000000000000000000000005555555555555555000000000555555555555555555556dddddddddddddddddddddddd5555555555
555555500000000000000000000000000000000000000000555555555555555500000000055555565555565555555655555555555555555555555d5555555555
55555550000000000000000000000000000000000000000055555555555555550000000005555556665666555555576666666d6666666d666666655555555555
55555550000000000000000000000000000000000000000055555555555555550000000005555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000055555555555555550000000005555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000005555555505555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000005555555505555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000005555555505555550005550005550005550005550005550005550005550005555
555555500000000000000000000000000000000000000000000000000000000055555555055555011d05011d05011d05011d05011d05011d05011d050ff70555
5555555000000000000000000000000000000000000000000000000000000000555555550555550111050111050111050111050111050111050111050fff0555
5555555000000000000000000000000000000000000000000000000000000000555555550555550111050111050111050111050111050111050111050fff0555
55555550000000000000000000000000000000000000000000000000000000005555555505555550005550005550005550005550005550005550005550005555
55555550000000000000000000000000000000000000000000000000000000005555555505555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555555575555555ddd55555d5d5d5d55555d5d555555555d5555555ddd5555554564554955555555555555555555555555555555555555555555555555
555555555555777555555ddd55555555555555555d5d5d55555555d55555d555d555554aa9999956666666666666555557777755555555555555555555555555
555555555557777755555ddd55555d55555d55555d5d5d555555555d555d55555d55555000000056ddd6ddd6ddd6555577ddd775566666555666665556666655
555555555577777555555ddd55555555555555555ddddd5555ddddddd55d55555d55550550000056d6d666d6d6d6555577d7d77566dd666566ddd66566ddd665
5555555557577755555ddddddd555d55555d555d5ddddd555d5ddddd555d55555d55550005000056d6d6ddd6d6d6555577d7d775666d66656666d665666dd665
5555555557557555555d55555d55555555555555dddddd555d55ddd55555d555d555550000500056d6d6d666d6d6555577ddd775666d666566d666656666d665
5555555557775555555ddddddd555d5d5d5d555555ddd5555d555d5555555ddd5555550000055056ddd6ddd6ddd655557777777566ddd66566ddd66566ddd665
55555555555555555555555555555555555555555555555555555555555555555555550000000556666666666666555577777775666666656666666566666665
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555566666665ddddddd5ddddddd5ddddddd5
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000bbbbbbbb56d11d65000022222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003bbbb33356d11d65000022222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000003333333356d11d65000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000dddd009993339956d11d65000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000dddddd0a4493aaa56d11d65222200000000222200000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000dcddcd04644645456d11d65222200000000222200000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000dddddd04445444456d11d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000dddd004544446456d11d07777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000bbbbbbbb44444407456455497000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000bbbbb33399aa99074aa999997000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000bbb33333aaabbb07500000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000dddd0bb33a999b3333307055000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000ddcdcd333a954633333307000500007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00dddd000ddddddd3365444433443307000050007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0dcddcd0ddddddd03445545444454407000005507000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00dddd0000dddd003644546445444407000000057000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000044444444bbbbbb07777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00dddd00000dd00004000040333bbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0dcddcd0000dd0004444444435333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0dddddd0000dd00004000040544563aa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0dddddd000dddd0044444444a4444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00dddd000dddddd00400004046444464000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000dd0000dcddcd04444444405000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000dd00000dddd000400004004000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000dddd00000dd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000dcddcd000dddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000dddddd000dddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000dddddd00dddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000ddd00dddddd00dddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000dcdcd00dddd000dddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ddddddd00dddd000dcddcd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddd000dd00000dddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__gff__
0000010120400000000000000000000000000101000001000000000000000000000002010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
2400000000002300000000000000250000000000000000000000000000000000000000000000000000000000002400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000002200000000000000240000000000000000000000000000000000000000000000000000000000002400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000002200000000000000240000000000000000000000000000000000000000000000000000000000002400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000002200000000000000240000000000000000002512020202020500000000000000000000000000002400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2402020202032212020202130000160000000000000000002400000000000005000023000000000000000000002400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000002200000000240000000000000000000000002400000000000000050022000000000000000000002400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000002200000000240000000000000000000000002400000000000000000522000000000000000000002400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000002200000000120202020202020213000016020300000000000000000022000000000000000000002400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000002200000000000000000000240000000000000000000000000000000022000000000000000000002400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000002200000000000000000000240000000000000000000000000000000022000000000000000000002400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000002200000000000000000000240202020300000000000000000000000022000000000000000000002400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000002200000000000000000000240000000000000000041202020202020322000000000000000000002400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000002200000000000000000000240000000000000004000000000000000000000000000000000000002400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000240000000000000400000000000000000000000000000000000000002400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000240000000000040000000000000000000000000000000000000000002400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000e00003001029020240201f0301d0301b0301803018020180201b01022010240101b0201b0301f010240201f0201b0101602013030110300f0100f0100f0100c0100c0100c0100f0201b010270101b03016030
000e00001a1401812017120171201612015120191202211026110261102411023110211101f1101b1201813017130161301613017120191201d1101f110201201e1301b13018140151201411016110191201d130
000e00000653006530065300553005530055300553004530045300453004530055300553005530055300653005530055300553004530045300453004530055300653006530065300453005530055300553006540
__music__
00 00024344

