pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--goal of this is to create the
--'ai' needed to move an enemy
--towards the player
--64,65,80,81
function botinit()
			
			atk_frames={96,96,96,96,
															96,96,97,97,
															97,97,"end"}
			atk_cnt=0
			
			bot = {}
					bot.x=0
					bot.y=112
					bot.goalx=nil
					bot.w=8
					bot.h=8
					bot.spr=65
					bot.anim=0
					bot.aim="right"
					bot.action="stand"
					bot.flp=false
					bot.q1=0
					bot.mid=0
					bot.q3=0
					--65,81,64,80,96,97
end

function draw_bot(t)
		if atk_frames[atk_cnt]=="end" then
				atk_cnt=0
				bot.spr=65
				bot.anim=t
				move_goalx(random(bot.x,bot.y,t))
		elseif atk_cnt>0 then
				bot.spr=atk_frames[atk_cnt]
				atk_cnt+=1
				if atk_frames[atk_cnt]==97 then
						bot.x+=1
				end
		end
		if bot.action=="stand" then
				if t-bot.anim>=.3 and bot.spr==80 then
						bot.spr=65
						bot.anim=t
				elseif t-bot.anim>=.3 then
						bot.spr=80
						bot.anim=t
				end
		elseif bot.action=="walk" then
				if t-bot.anim>=.5 and bot.spr==81 then
						bot.spr=64
						bot.anim=t
				elseif t-bot.anim>=.5 then
						bot.spr=81
						bot.anim=t
				end
		end	
end

function update_bot(px,t)
		if bot.goalx==nil then
				if bot.x>=px then
						move_goalx(flr(px)+8)
				else
						move_goalx(flr(px)-8)
				end
		end
		if bot.x==bot.mid-1 then
				--left side of goalx
				check_px(px)
		elseif bot.x==bot.mid+1 then
				--right side of goalx
				check_px(px)
		elseif bot.x==bot.q1 then
				check_px(px)
		elseif bot.x==bot.q3 then
				check_px(px)
		elseif bot.x>=bot.goalx and
						bot.x>bot.q3 then
				check_px(px)
		elseif bot.x<=bot.goalx and
					bot.x<bot.q1 then
				--j.i.c we go past the goal
				--we want to set a new goal
				--somewhere
				check_px(px)
		else
		--a j.i.c statement that
		--makes it so we never have to
		--worry about the bot not
		--setting a goal somewhere
				move_goalx(random(bot.x,px,t))
		end
		move_to_goal()
end

function move_to_goal()
		if (bot.goalx+1)<bot.x then
				bot.x-=1
				bot.action="walk"
				bot.aim="left"
		elseif bot.x<(bot.goalx-1) then
				bot.x+=1
				bot.action="walk"
				bot.aim="right"
		else
				bot.action="stand"
		end
		if bot.aim=="left" then
				bot.flp=true
		else
				bot.flp=false
		end
end

function check_px(px)
		px=flr(px)
		--returns whether player the
		--goal needs to be changed
		local left_side=(bot.q1-(abs(bot.q1-bot.mid)))
		--gets the far left of the
		--bots' "safe space"
		local right_side=(bot.q3+(abs(bot.q3-bot.mid)))
		--does the right side
		if left_side<=px-8 and px+8<bot.mid then
				move_goalx(abs(bot.mid+left_side))
		elseif bot.mid<px-8 and px+8<=right_side then
				move_goalx(abs(right_side-bot.mid))
		else
				move_goalx(px)
		end
end

function move_goalx(new_goal)
		--will handle changing q1
		--and such
		bot.mid=flr(abs(new_goal-(abs(new_goal-bot.x)/2)))
		bot.q1=flr(abs((bot.mid-(abs(bot.mid-bot.x)/2))))
		bot.q3=flr(abs((bot.mid+(abs(bot.mid-bot.x)/2))))
		bot.goalx=flr(new_goal)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
