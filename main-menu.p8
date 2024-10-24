pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
		cartdata("dc_capstone")
		lvl_hl=1
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
		version="0.8.1"
		level_select_init()
		--export -i 64 game-test.bin 
		--.capstone.p8 level2.p8
end

function _update60()
		
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
		
		if player.y>=menu.play_top and
				player.y<=menu.play_btm then
					player.y=36
					player.x=44
					cx=0
					canmove_u=false
					canmove_d=true
					action="play"
		elseif player.y>=menu.sel_top and
				player.y<=menu.sel_btm
				and player.x<=300 then
					player.y=60
					player.x=300
					cx=256
					canmove_u=true
					canmove_d=true
					action="select"
		elseif player.y>=menu.quit_top
				and player.y<=menu.quit_btm then
					player.y=85
					player.x=172
					cx=128
					canmove_u=true
					canmove_d=false
					action="quit"
		end
		
		if action=="play" and btn(🅾️) then
				load(".capstone.p8")
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
		
		if player.spr==48 and 
				time()-player.anim>=.5 then
					player.spr=32
					player.anim=time()
		elseif time()-player.anim>=.5 then
					player.spr=48
					player.anim=time()
		end--if
end--function


function _draw()
		cls()
		map(0,0)
		local str="version: a-"
		print(str..version,39,112,7)
		print(str..version,167,112,7)
		print(str..version,295,112,7)
		print("press: z/🅾️",80,38,8)
		print("press: z/🅾️",336,62,8)
		print("press: z/🅾️",208,87,8)
		draw_gray_sprites()
		spr(player.spr,player.x,player.y)
		camera(cx,cy)
end
-->8
function level_select_init()
		lvl={
		{name=1,x=4,y=176,cx=0,cy=152,g=false,ld=".capstone.p8"},
		{name=2,x=180,y=176,cx=144,cy=152,g=false,ld="level2.p8"},
		{name=3,x=356,y=176,cx=288,cy=152,g=false},
		{name=4,x=532,y=176,cx=432,cy=152,g=false},
		{name=5,x=580,y=200,cx=576,cy=152,g=false},
		{name=6,x=756,y=200,cx=720,cy=152,g=false},
		{name=7,x=932,y=200,cx=864,cy=152,g=false},
		{name=8,x=964,y=56,cx=864,cy=8,g=false}}
end


--add gray sprites where to
--where you could move?
--would solve flickering issue
function draw_gray_sprites()
		for l in all(lvl) do
				if l.name>dget(12) then
						l.g=false
				end
		end
		for v in all(lvl) do
				if action=="sel-screen" then
				str1="press: up arrow/⬆️ to"
				str2="return to menu"
				str3="press: x/❎ to enter a level"
				print(str1,cx+24,cy+102)
				print(str2,cx+37,cy+110)
				print(str3,cx+9,cy+120)
						if v.g then
								spr(v.name+39,(v.x-v.cx)+cx+12,(v.y-v.cy)+cy)
						end
				end
		end
end

function sel_move()
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
00000000333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
00000000333333333333333333333333333333333333333333333333333333333338833333888333338888333383383333888833333883333388883333388333
00700700333333333333333333333333333333333333333333333333333333333383833333333833333338333383383333833333338333333333383333833833
00077000333333333333333333333333333333333333333333333333333333333333833333333833333383333388883333388333338883333333383333388333
00077000333333333333333333333333333333333333333333333333333333333333833333388333333383333333383333333833338338333333833333833833
00700700888383333333333333333333333333333333333333333333333333333333833333833333333338333333383333333833338338333338333333833833
00000000838383333333333338883333338338333883383833383388388833333388883333888833338888333333383333888333333883333338333333388333
00000000883383338833833883338333333338338333833833833833338333333333333333333333333333333333333333333333333333333333333333333333
33333333833383383383833883383383838388833833883833883833338333333333333333333333333333333333333333333333333333333333333333333333
3333333383338338388338888338338383833833338383383383383333833333333ee33333eee33333eeee3333e33e3333eeee33333ee33333eeee33333ee333
333333338333383383833338388383388383383388338833838838883383333333e3e33333333e3333333e3333e33e3333e3333333e3333333333e3333e33e33
33333333333333333333338333338333333333333333333333333333333333333333e33333333e333333e33333eeee33333ee33333eee33333333e33333ee333
33333333333333333333883333333333333333333333333333333333333333333333e333333ee3333333e33333333e3333333e3333e33e333333e33333e33e33
33333333333333333333333333333333333333333333333333333333333333333333e33333e3333333333e3333333e3333333e3333e33e33333e333333e33e33
333333333333333333333333333333333333333333333333333333333333333333eeee3333eeee3333eeee3333333e3333eee333333ee333333e3333333ee333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
ee000000333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
8eee0000333333333333333333333333333333333333333333333333333333333335533333555333335555333353353333555533333553333355553333355333
888eee00333333333333333333333333333333333333333333333333333333333353533333333533333335333353353333533333335333333333353333533533
88888eee333333333333333333333333333333333333333333333333333333333333533333333533333353333355553333355333335553333333353333355333
88888888333333333333333333333333333333333333333333333333333333333333533333355333333353333333353333333533335335333333533333533533
28888800eee3e3333333333333333333333333333333333333333333333333333333533333533333333335333333353333333533335335333335333333533533
22220000e3e3e333333333333eee333333e33e333ee33e3e333e33ee3eee33333355553333555533335555333333353333555333333553333335333333355333
22000000ee33e333ee33e33ee333e33333333e33e333e33e33e33e3333e333333333333333333333333333333333333333333333333333333333333333333333
00000000e333e33e33e3e33ee33e33e3e3e3eee33e33ee3e33ee3e3333e333330000000000000000000000000000000000000000000000000000000000000000
00000000e333e33e3ee33eeee33e33e3e3e33e3333e3e33e33e33e3333e333330000000000000000000000000000000000000000000000000000000000000000
00000000e3333e33e3e3333e3ee3e33ee3e33e33ee33ee33e3ee3eee33e333330000000000000000000000000000000000000000000000000000000000000000
0000000033333333333333e33333e333333333333333333333333333333333330000000000000000000000000000000000000000000000000000000000000000
00000000333333333333ee3333333333333333333333333333333333333333330000000000000000000000000000000000000000000000000000000000000000
00000000333333333333333333333333333333333333333333333333333333330000000000000000000000000000000000000000000000000000000000000000
00000000333333333333333333333333333333333333333333333333333333330000000000000000000000000000000000000000000000000000000000000000
00000000333333333333333333333333333333333333333333333333333333330000000000000000000000000000000000000000000000000000000000000000
99999aaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8888999a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fff8889a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fffff899000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddff889000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cc7fff89000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fc7fff89000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffff88000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
01010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101
01010101010100000101010101010101010101010101010100000101010101010101010101010101010100000101010101010101010101010101010100000000
01010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101
01010101010100000101010101010101010101010101010100000101010101010101010101010101010100000101010101010101010101010101010100000000
01010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101
01010101010100000101010101010101010101010101010100000101010101010101010101010101010100000101010101010101010101010101010100000000
__map__
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010101010101000000000
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010101010101000000000
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010101010101000000000
101010101010102122101010101010101010101010101001021010101010101010101010101010010210101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101008101010091010100a1010100b1000000000
1010101010101031321010101010101010101010101010111210101010101010101010101010101112101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010101010101000000000
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010101010101000000000
10101010101010050607101010101010101010101010100506071010101010101010101010101025262710101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010100c1010100d1010100e1010101f1000000000
1010101010101015161710101010101010101010101010151617101010101010101010101010103536371010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010101010101000000000
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010101010101000000000
1010101010101003041010101010101010101010101010232410101010101010101010101010100304101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010101010101000000000
1010101010101013141010101010101010101010101010333410101010101010101010101010101314101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010101010101000000000
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010101010101000000000
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010101010101000000000
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010101010101000000000
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010101010101000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010101010101000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000000000
1010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000000000
1010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000000000
101018101010091010100a1010100b100000101008101010191010100a1010100b100000101008101010091010101a1010100b100000101008101010091010100a1010101b100000101008101010091010100a1010100b100000101008101010091010100a1010100b100000101008101010091010100a1010100b1000000000
1010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000000000
1010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000000000
10100c1010100d1010100e1010100f10000010100c1010100d1010100e1010100f10000010100c1010100d1010100e1010100f10000010100c1010100d1010100e1010100f10000010101c1010100d1010100e1010100f10000010100c1010101d1010100e1010100f10000010100c1010100d1010101e1010100f1000000000
1010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000000000
1010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000000000
1010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000000000
1010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000000000
1010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000000000
1010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000001010101010101010101010101010101000000000
