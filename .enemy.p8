pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--goal of this is to create the
--'ai' needed to move an enemy
--towards the player
--64,65,80,81
function botinit()
			
			atk_frames={96,96,96,96
															96,96,97,97
															97,97,"end"}
			atk_cnt=0
			
			bot = {}
					bot.x=0
					bot.y=112
					bot.goalx=0
					bot.w=8
					bot.h=8
					bot.spr=65
					bot.q1=0
					bot.mid=0
					bot.q3=0
					--65,81,64,80,96,97
end

function draw_bot()
	
end

function update_bot(px)
	
end

function move_goalx(px)
	
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
