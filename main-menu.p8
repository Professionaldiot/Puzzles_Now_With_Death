pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
	#include .movement.p8:0
	#include .enemy.p8
	botinit()
	cartdata("dc_capstone")
	lvl_hl=1
	dset(12,8)
	player={}
		player.x=44
		player.y=36
		player.spr=32
		player.anim=0
	cx=0
	cy=0
	canmove_d=true
	canmove_u=true
	action="play"
	version="1.30"
	level_select_init()
end

function _update()
		
	local menu={}
		menu.play_top=24
		menu.play_btm=48
		menu.quit_top=73
		menu.quit_btm=96
		menu.sel_top=48
		menu.sel_btm=72
			
	if btnp(⬇️) and canmove_d then
				player.y+=13
	end
	if btnp(⬆️) and canmove_u then
				player.y-=13
	end
	
	if player.y>=menu.play_top and player.y<=menu.play_btm and lvl_hl == 1 then
		player.y=36
		player.x=44
		cx=0
		canmove_u=false
		canmove_d=true
		action="play"
	elseif player.y>=menu.sel_top and player.y<=menu.sel_btm and player.x<=300 then
		player.y=60
		player.x=300
		cx=256
		canmove_u=true
		canmove_d=true
		action="select"
	elseif player.y>=menu.quit_top and player.y<=menu.quit_btm then
		player.y=85
		player.x=172
		cx=128
		canmove_u=true
		canmove_d=false
		action="quit"
	end
	
	if action=="play" and btn(🅾️) then
		if lload() then
			dset(13,true)
			load(lvl[dget(12)]["ld"])
		else
			load(".level1.p8")
		end
	end
	if action=="sel-screen" then
		sel_move()
		canmove_u=false
		canmove_d=false
	elseif action=="select" and btn(🅾️) then
		action="sel-screen"
		player.x=4
		player.y=176
		cx=0
		cy=152
		lvl_hl=1
		sel_move()
	end
	if action=="quit" and btn(🅾️) then
		stop()
	end
	
	if player.spr==48 and time()-player.anim>=.5 then
		player.spr=32
		player.anim=time()
	elseif time()-player.anim>=.5 then
		player.spr=48
		player.anim=time()
	end--if
end--function

function _draw()
	cls()
	for i = 0, 2 do
		map(50, 0, i*128, 0)
	end
	for i = 0, 7 do
		map(50, 0, i*144, 19*8)
	end
	map(50, 0, 832, 0)
	
	map(0,0)
	local str="version: b-"
	print(str..version,((72-#(str..version))/2),112,7)
	print(str..version,((72-#(str..version))/2)+128,112,7)
	print(str..version,((72-#(str..version))/2)+256,112,7)
	print("press: z/🅾️",80,38,8)
	print("press: z/🅾️",336,62,8)
	print("press: z/🅾️",208,87,8)
	draw_gray_sprites()
	spr(player.spr,player.x,player.y)
	camera(cx,cy)
end

function level_select_init()
	--[[
	Intializes the level select screen that is seen on the main-menu

    Variables: NIL

    returns NIL
    ]]
	lvl={
		{name=1,x=4,y=176,cx=0,cy=152,g=false,ld=".level1.p8"},
		{name=2,x=180,y=176,cx=144,cy=152,g=false,ld=".level2.p8"},
		{name=3,x=356,y=176,cx=288,cy=152,g=false,ld=".level3.p8"},
		{name=4,x=532,y=176,cx=432,cy=152,g=false,ld=".level4.p8"},
		{name=5,x=580,y=200,cx=576,cy=152,g=false,ld=".level5.p8"},
		{name=6,x=756,y=200,cx=720,cy=152,g=false,ld=".level6.p8"},
		{name=7,x=932,y=200,cx=864,cy=152,g=false,ld=".level7.p8"},
		{name=8,x=932,y=48,cx=832,cy=0,g=false,ld=".level8.p8"}
	}
end

function draw_gray_sprites()
	--[[
	Draws gray sprites over levels the player cannot enter

    Variables: NIL

    returns NIL
    ]]
	for l in all(lvl) do
		if l.name>dget(12) then
			l.g=true
		end
	end
	for v in all(lvl) do
		if action=="sel-screen" then
		str1="press: up arrow/⬆️ to"
		str2="return to menu"
		str3="press: x/❎ to enter a level"
		print(str1,cx+24,cy+102) --this prints it at your screen
		print(str2,cx+37,cy+110)
		print(str3,cx+9,cy+120)
		
		print(str1,cx+168,cy+102) ---this prints it at the screen to the right
		print(str2,cx+181,cy+110)
		print(str3,cx+153,cy+120)
		
		print(str1,cx-120,cy+102) -- this prints it at the screen to the left
		print(str2,cx-107,cy+110)
		print(str3,cx-135,cy+120)
	
		print(str1,cx+24,cy-42) -- this prints it to the screen above it
		print(str2,cx+37,cy-34)
		print(str3,cx+9,cy-24)
		
		print(str1,cx+24,cy+246) --and this prints to the screen below
		print(str2,cx+37,cy+254)
		print(str3,cx+9,cy+264)
			if v.g then
				spr(v.name+39,(v.x-v.cx)+cx+12,(v.y-v.cy)+cy)
				spr(v.name+39,(v.x-v.cx)+cx-132,(v.y-v.cy)+cy)
				spr(v.name+39,(v.x-v.cx)+cx+156,(v.y-v.cy)+cy)
			end
		end
	end
end

function sel_move()
	--[[
	Moves the level the player is highlighting based on inputs

    Variables: NIL

    returns NIL
    ]]
	if btnp(➡️) and lvl_hl!=8 then
		if lvl[lvl_hl+1]["g"]==false then
			lvl_hl+=1
			player.y=lvl[lvl_hl]["y"]
			player.x=lvl[lvl_hl]["x"]
			cx=lvl[lvl_hl]["cx"]
			cy=lvl[lvl_hl]["cy"]
		end
	elseif btnp(⬅️) and lvl_hl!=1 then
		if lvl[lvl_hl-1]["g"]==false then
			lvl_hl-=1
			player.y=lvl[lvl_hl]["y"]
			player.x=lvl[lvl_hl]["x"]
			cx=lvl[lvl_hl]["cx"]
			cy=lvl[lvl_hl]["cy"]
		end
	elseif btnp(❎) then
		load(lvl[lvl_hl]["ld"])
	elseif btnp(⬆️) then
		lvl_hl = 1
		player.y=60
		player.x=300
		cx=256
		cy=0
		canmove_u=true
		canmove_d=true
		action="select"
	end
end



__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000008800000888000008888000080080000888800000880000088880000088000
00700700000000000000000000000000000000000000000000000000000000000080800000000800000008000080080000800000008000000000080000800800
00077000000000000000000000000000000000000000000000000000000000000000800000000800000080000088880000088000008880000000080000088000
00077000000000000000000000000000000000000000000000000000000000000000800000088000000080000000080000000800008008000000800000800800
00700700888080000000000000000000000000000000000000000000000000000000800000800000000008000000080000000800008008000008000000800800
00000000808080000000000008880000008008000880080800080088088800000088880000888800008888000000080000888000000880000008000000088000
00000000880080008800800880008000000008008000800800800800008000000000000000000000000000000000000000000000000000000000000000000000
33333333800080080080800880080080808088800800880800880800008000000000000000000000000000000000000000000000000000000000000000000000
3333333380008008088008888008008080800800008080080080080000800000000ee00000eee00000eeee0000e00e0000eeee00000ee00000eeee00000ee000
333333338000080080800008088080088080080088008800808808880080000000e0e00000000e0000000e0000e00e0000e0000000e0000000000e0000e00e00
33333333000000000000008000008000000000000000000000000000000000000000e00000000e000000e00000eeee00000ee00000eee00000000e00000ee000
33333333000000000000880000000000000000000000000000000000000000000000e000000ee0000000e00000000e0000000e0000e00e000000e00000e00e00
33333333000000000000000000000000000000000000000000000000000000000000e00000e0000000000e0000000e0000000e0000e00e00000e000000e00e00
333333330000000000000000000000000000000000000000000000000000000000eeee0000eeee0000eeee0000000e0000eee000000ee000000e0000000ee000
33333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8eee0000000000000000000000000000000000000000000000000000000000000005500000555000005555000050050000555500000550000055550000055000
888eee00000000000000000000000000000000000000000000000000000000000050500000000500000005000050050000500000005000000000050000500500
88888eee000000000000000000000000000000000000000000000000000000000000500000000500000050000055550000055000005550000000050000055000
88888888000000000000000000000000000000000000000000000000000000000000500000055000000050000000050000000500005005000000500000500500
28888800eee0e0000000000000000000000000000000000000000000000000000000500000500000000005000000050000000500005005000005000000500500
22220000e0e0e000000000000eee000000e00e000ee00e0e000e00ee0eee00000055550000555500005555000000050000555000000550000005000000055000
22000000ee00e000ee00e00ee000e00000000e00e000e00e00e00e0000e000000000000000000000000000000000000000000000000000000000000000000000
00000000e000e00e00e0e00ee00e00e0e0e0eee00e00ee0e00ee0e0000e000000000000000000000000000000000000000000000000000000000000000000000
00000000e000e00e0ee00eeee00e00e0e0e00e0000e0e00e00e00e0000e000000000000000000000000000000000000000000000000000000000000000000000
00000000e0000e00e0e0000e0ee0e00ee0e00e00ee00ee00e0ee0eee00e000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000e00000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb111b77aaa0000000000000000000000000000aaa0000000000aa000a000000000000009000a00000000000000aa00000000000000000000000000000000000
1111111790aa000000000000000000000000000000a00000000090a00a0000000000000090a0a00000000a0000090a00000000000000a0000a00000000000000
111ee11b900a000000000000000000000000000000900000000090a00a0000000000000090a0a00a00a00a00000900a0000000000a00a0000a00000000000000
b18d6e1199900a0a0aaa0aaa00a000aaa0aaa000990000000000900a0a00aa0090a0a00090a0900000a00a0000090090aaa00a000a00a0000900000000000000
312051119000090a000a000a00a0009000900000900000000000900a0a0900a090a0a00090909009099a09a000090090900090a099a09a000900000000000000
31128111a00009090090009000900099000a00000000000000009000a90900909090a000090a0009009009090009090099009990090090900000000000000000
1112111ba0000990099a099a009aa099a099a000900000000000900009009900090a000009090009009009090009900099a09090090090900900000000000000
11383113000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccccccccccccccccccccccccccccccccbbbbbbbb33333333cccccbbbcccccbbbcccccccccccccccccc56756556d76dcccc56756556d76dcccccccccccccccccc
cccccccccccccccccccccccccccccccc3333bbbb33333333cccbbbb3ccccbbbbcccccccccccccccccc56756556d76dcccc56756556d76dccccccddddddddcccc
cccc77cccccccccccccccccccccccccc3333333333333333ccbbbb33cccbbbbbcccccccccccccccccc56756556d76dcccc56756556d76dcccc5557dddd7dddcc
ccc77777cccccccccc7777cccccccccc3333333333333333cbbbb333cccbbbb3cccccccccccccccccc56756556d76dcccc56756556d76dcc555577dddd77dddd
cc7777677ccccccc667777777777cccc3333333333333333bbbbb333ccbbbb33ccccccbbcccccccccc56756556d76dcccc56756556d76dcc567577dddd77d76d
c6777667777777cc677777777777777c3333333333333333bbbb3333cbbbb333ccccbbbbcccccccbcc56756556d76dcccc56756556d76dcc567567dddd76d76d
667776777777777767777767777677773333333333333333bbb33333bbbb3333ccbbbbbbccccccbbcc56756556d76dccbb56756556d76dcc5675577dd77dd76d
677776677667777767777766677667773333333333333333bb333333bbbb3333bbbbbbbbcccccbbbcc56756556d76bbbbbb6756556d76dcc5677577dd77d776d
66677766776667776666777767776667ccccccccccccccccbbbcccccbbbccccccccccccccccccccccc56756556bb3333bbbbb56556d76dcc5667567dd76d766d
c666777777777777cc6667766777777cccccccccccccccccbbbbbcccbbbbcccccccccccccccccccccc56bbb3333333333bbbbbbbbbbb6dcc5567557dd7dd76dd
ccc6667777777777cc6777667666ccccccccccbbcccccccc3bbbbbccbbbbbcccccccccccccccccccbb33333333333333333bbbbbbbbbbbbbc5677575d7d776dc
ccccc6667777777ccc67777766ccccccccccb333cccccccc33bbbbbc3bbbbccccccccccccccccccc333333333333333333333bbbbbbbbbbbc5567575d7d76ddc
ccccccc6667777cccc6777766cccccccccbb3333cccccccc33333bbb33bbbbccbbcccccccccccccc33333333333333333333333333bbbbbbcc567565d6d76dcc
cccccccc6666ccccccc66666ccccccccb3333333cccccccc333333bb333bbbbcbbbbccccbccccccc33333333333333333333333333333333cc567565d6d76dcc
cccccccccccccccccccccccccccccccc33333333cccccccc3333333b3333bbbbbbbbbbccbbcccccc33333333333333333333333333333333cc567565d6d76dcc
cccccccccccccccccccccccccccccccc33333333bbbbbbbb333333333333bbbbbbbbbbbbbbbccccc33333333333333333333333333333333cc56756556d76dcc
cccccccccccccccc0000000000000000cccccccccccccccccccccccc00000000000000000000000000000000000000000000000000000000cc56756556d76dcc
cccccccccc444ccc0000000000000000cccccccccccccccccccccccc00000000000000000000000000000000000000000000000000000000cc56756556d76dcc
cccccccccc444ccc0000000000000000ccccccccbbcccccccccccccc00000000000000000000000000000000000000000000000000000000cc56756556d76dcc
ccccccccccfffccc0000000000000000ccccccccbbbbbccccccccccc00000000000000000000000000000000000000000000000000000000cc56756556d76dcc
ccccccccc33333cc0000000000000000ccccccccbbbbbbbbbbcccccc00000000000000000000000000000000000000000000000000000000cc56756556d76dcc
cccccccccf333fcc0000000000000000cccccbbb3333bbbbbbbbcccc00000000000000000000000000000000000000000000000000000000cc56756556d76dcc
cccccccccf111fcc0000000000000000ccb33333333333333bbbbbcc00000000000000000000000000000000000000000000000000000000cc56756556d76dcc
ccccccccbf1b1fbb0000000000000000b33333333333333333333bbb00000000000000000000000000000000000000000000000000000000cc56756556d76dcc
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888ffffff882222228888888888888888888888888888888888888888888888888888888888888888228228888228822888fff8ff888888822888888228888
88888f8888f882888828888888888888888888888888888888888888888888888888888888888888882288822888222222888fff8ff888882282888888222888
88888ffffff882888828888888888888888888888888888888888888888888888888888888888888882288822888282282888fff888888228882888888288888
88888888888882888828888888888888888888888888888888888888888888888888888888888888882288822888222222888888fff888228882888822288888
88888f8f8f8882888828888888888888888888888888888888888888888888888888888888888888882288822888822228888ff8fff888882282888222288888
888888f8f8f882222228888888888888888888888888888888888888888888888888888888888888888228228888828828888ff8fff888888822888222888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333eee3e3333333333333333333333333333333333333333333333333333333333388838333
33333333333333333333333333333333333333333333333333333333e3e3e3333333333333333333333333333333333333333333333333333333333383838333
33333333333333333333333333333333333333333333333333333333ee33e333ee33e33e33333333333333333333333333333333333333333333333388338333
33333333333333333333333333333333333333333333333333333333e333e33e33e3e33e33333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333e333e33e3ee33eee33333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333e3333e33e3e3333e33333333333333333333333333333333333333333333333333333333
3333333333333333333333333333333333333333333333333333333333333333333333e333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333ee3333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333377777777777777777733333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333373333333333333333733333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333373333333333333333733333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333373313333333333333733333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333373171333333333333733333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333373177133333333333733333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333373177713333333333733333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333388338373177771838883333733333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333833383373177113333833333733333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333383388373311713333833333733333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333338383373383383333833333733333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333883388378388388833833333733333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333373333333333333333733333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333373333333333333333733333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333373333333333333333733333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333373333333333333333733333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333373333333333333333733333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333377777777777777777733333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333388833333383383333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333833383333333383333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333833833838383888333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333833833838383383333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333388383388383383333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333383333333333333333333333333333333333333333333333333333333333333333333
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555555575555555ddd55555d5d5d5d55555d5d555555555d5555555ddd555555bbbbbbbb55555555555555555555555555555555555555555555555555
555555555555777555555ddd55555555555555555d5d5d55555555d55555d555d55555bbbbbbbb56666666666666555555555555577777555555555555555555
555555555557777755555ddd55555d55555d55555d5d5d555555555d555d55555d5555bbbbbbbb56ddd6d666ddd655555666665577dd77755666665556666655
555555555577777555555ddd55555555555555555ddddd5555ddddddd55d55555d55555bb5bbb556d6d6d66666d6555566ddd665777d777566ddd66566ddd665
5555555557577755555ddddddd555d55555d555d5ddddd555d5ddddd555d55555d55555bb5bbb556d6d6ddd666d6555566d6d665777d77756666d665666dd665
5555555557557555555d55555d55555555555555dddddd555d55ddd55555d555d55555bbb5bbb556d6d6d6d666d6555566d6d66577ddd77566d666656666d665
5555555557775555555ddddddd555d5d5d5d555555ddd5555d555d5555555ddd5555555bb555b556ddd6ddd666d6555566ddd6657777777566ddd66566ddd665
5555555555555555555555555555555555555555555555555555555555555555555555bbbbbbbb56666666666666555566666665777777756666666566666665
555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555ddddddd566666665ddddddd5ddddddd5
00000000000000000000000777777777777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cc111cccb5555bbbbbbbbb07bbbbbbbbbbbbbbbb705bbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111cb5bb5bbbbbbbbb07bbbbbbbbbbbbbbbb70b5bbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
111ee11cb5bb5bbbbbbbbb07bbbbbbbbbbbbbbbb70b5bbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
c18d6e11b555bb5b5b555b075bb5bbb555b555bb705bbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
c1805111b5bbbb5b5bbb5b075bb5bbb5bbb5bbbb70bbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
c1188111b5bbbb5b5bb5bb07bbb5bbb55bbb5bbb70bbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
1118111cb5bbbb55bb555b075bb555b555b555bb70bbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
11c8c11cbbbbbbbbbbbbbb07bbbbbbbbbbbbbbbb70bbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbb07bbbbbbbbbbbbbbbb70bbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbb07bbbbbbbbbbbbbbbb70bbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbb07bbbbbbbbbbbbbbbb70bbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbb07bbbbbbbbbbbbbbbb70bbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbb07bbbbbbbbbbbbbbbb70bbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbb07bbbbbbbbbbbbbbbb70bbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbb07bbbbbbbbbbbbbbbb70bbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbb07bbbbbbbbbbbbbbbb70bbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000777777777777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88282888882228222822288888282888882228222822288888888888888888888888888888888888888888888888888888888888888888888888888888888888
88282882882828282828288888282882882828282888288888888888888888888888888888888888888888888888888888888888888888888888888888888888
88828888882828282822288888222888882828282888288888888888888888888888888888888888888888888888888888888888888888888888888888888888
88282882882828282828288888882882882828282888288888888888888888888888888888888888888888888888888888888888888888888888888888888888
88282888882228222822288888222888882228222888288888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008080808080808080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000707070707070705253707070707050510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000004142434445000000000000000000000041424344450000000000000000000000414243444500000000000000707050517070706263707070707060610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000707060617070707050517052537070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000464748494a4b4c4d4e00000000000000464748494a4b4c4d4e00000000000000464748494a4b4c4d4e0000000000707070707070707060617062637070700000000000000000000000000000000000000000000000000000000000000000000000000000000008000000090000000a0000000b000000000000000000
0000000000000021220000000000000000000000000000010200000000000000000000000000000102000000000000000000707070707070707070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000031320000000000000000000000000000111200000000000000000000000000001112000000000000000000707070707070707070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070705e5f70707070707070705e5f7070000000000000000000000000000000000000000000000000000000000000000000000000000000000c0000000d0000000e0000001f000000000000000000
000000000000000506070000000000000000000000000005060700000000000000000000000000252627000000000000000070706e6f70707070707070706e6f70700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000001516170000000000000000000000000015161700000000000000000000000000353637000000000000000070707e7f70707070707070707e7f70700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070707e7f70707070707070707e7f70700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000304000000000000000000000000000023240000000000000000000000000000030400000000000000000070707e7f70705968717070707e7f70700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000001314000000000000000000000000000033340000000000000000000000000000131400000000000000000070707e7f70705755546668707e7f70700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070705a5b58565555555555665c5d70700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000074646a6b55555555555555556c6d75760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000555555555555555555555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000555555555555555555555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000018000000090000000a0000000b000000000008000000190000000a0000000b000000000008000000090000001a0000000b000000000008000000090000000a0000001b000000000008000000090000000a0000000b000000000008000000090000000a0000000b000000000008000000090000000a0000000b0000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000c0000000d0000000e0000000f00000000000c0000000d0000000e0000000f00000000000c0000000d0000000e0000000f00000000000c0000000d0000000e0000000f00000000001c0000000d0000000e0000000f00000000000c0000001d0000000e0000000f00000000000c0000000d0000001e0000000f0000000000
