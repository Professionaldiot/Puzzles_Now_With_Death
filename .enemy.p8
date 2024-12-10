pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--goal of this is to create the
--'ai' needed to move an enemy
--towards the player
--64,65,80,81
function botinit()
	atk_frames={96,96,96,96,96,96,97,97,97,97,"end"}
	atk_cnt=0

	min_jump = {}
	max_jump = {}
	stored_jump = 0
	stored_jump_y = 0
	prev_jump = 0
	prev_jump_y = 0
	
	bot = {}
		bot.x=32
		bot.y=112
		bot.dy=0
		bot.g=0.3
		bot.goalx=nil
		bot.landed=false
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

function player_above_bot(px, py)
	--function for determining bot movement when the player is above the bot on the stage
	--assume bot is below player
	local temp = {}
	temp.x = bot.x - bot.x%8
	temp.y = (bot.y - bot.y%8)
	temp.w = 8
	temp.h = 8
	local stored_y = temp.y
	local stored_x = temp.x
	local min_to_jump = 1025
	local max_to_jump = -1
	
	for i=0,3 do
		--check the y values above bot for 3 "spaces"
		--removed nested for loop for optimization, not readibilty
		--min is not getting returned correctly,
		temp.y-=8
		temp.x = stored_x
		if collide_map(temp, "right", 0) or collide_map(temp,"left",0) then
			--the bug is in here somehow
			return px
		else
			temp.x = stored_x + 8*3-i
			--this moves the temp.x to the outmost right hand side, which is at most 3 away
			if collide_map(temp, "right", 0) or collide_map(temp,"left",0) then
				--we now know, if we enter this expression, that the bot WILL collide with something
				--somewhere along it's path
				--found something on the right side
				min_to_jump = min(min_to_jump, temp.x)
				add(min_jump, min_to_jump)
			end
			temp.x = stored_x - 8*3-i
			--this moves the temp.x to the outermost left hand side, which is at most 3 away
			if collide_map(temp, "right", 0) or collide_map(temp,"left",0) then
				--we now know, if we enter this expression, that the bot WILL collide with something
				--somewhere along it's path
				--found something on the left side
				max_to_jump = max(max_to_jump, temp.x)
				add(max_jump, max_to_jump)
			end
			temp.y-=8

			--#2
			temp.x = stored_x + 8*3-i
			--this moves the temp.x to the outmost right hand side, which is at most 3 away
			if collide_map(temp, "right", 0) or collide_map(temp,"left",0) then
				--we now know, if we enter this expression, that the bot WILL collide with something
				--somewhere along it's path
				--found something on the right side
				min_to_jump = min(min_to_jump, temp.x)
				add(min_jump, min_to_jump)
			end
			temp.x = stored_x - 8*3-i
			--this moves the temp.x to the outermost left hand side, which is at most 3 away
			if collide_map(temp, "right", 0) or collide_map(temp,"left",0) then
				--we now know, if we enter this expression, that the bot WILL collide with something
				--somewhere along it's path
				--found something on the left side
				max_to_jump = max(max_to_jump, temp.x)
				add(max_jump, max_to_jump)
			end
			temp.y-=8

			--#3
			temp.x = stored_x + 8*3-i
			--this moves the temp.x to the outmost right hand side, which is at most 3 away
			if collide_map(temp, "right", 0) or collide_map(temp,"left",0) then
				--we now know, if we enter this expression, that the bot WILL collide with something
				--somewhere along it's path
				--found something on the right side
				min_to_jump = min(min_to_jump, temp.x)
				add(min_jump, min_to_jump)
			end
			temp.x = stored_x - 8*3-i
			--this moves the temp.x to the outermost left hand side, which is at most 3 away
			if collide_map(temp, "right", 0) or collide_map(temp,"left",0) then
				--we now know, if we enter this expression, that the bot WILL collide with something
				--somewhere along it's path
				--found something on the left side
				max_to_jump = max(max_to_jump, temp.x)
				add(max_jump, max_to_jump)
			end
			temp.x = stored_x
			temp.y = stored_y
		end
	end--for
	if bot.goalx != nil then
		--check = (bot.x >= bot.goalx-10 and bot.x <= bot.goalx+10)
		check = true
		if check and debug then
			printh("min: "..min_to_jump..
				" max: "..max_to_jump..
				" bot.goalx: "..bot.goalx..
				" bot.x: "..bot.x..
				" stored_jumps: "..stored_jump..
				" prev_jump: "..prev_jump, "bot_jumping_log.txt", false, true)
		end
	end
	if stored_jump == 0 and prev_jump == 0 then
		if max_to_jump == -1 then
			--if the max is still the same as what we set it as, then we know that the
			--min has something useful for us from the if statement before
			for o in all(min_jump) do
				min_to_jump = min(min_to_jump, o)
			end
			prev_jump = stored_jump
			prev_jump_y = stored_jump_y
			min_jump = {}
			return min_to_jump
		elseif min_to_jump == 1025 then
			--same for min
			for o in all(max_jump) do
				max_to_jump = max(max_to_jump, o)
			end
			prev_jump = stored_jump
			prev_jump_y = stored_jump_y
			return max_to_jump
		else
			for o in all(min_jump) do
				min_to_jump = min(min_to_jump,o)
			end
			return min_to_jump
		end--if
	elseif stored_jump == max_to_jump or stored_jump == min_to_jump then
		return stored_jump
	elseif max_to_jump == -1 and min_to_jump == 1025 then
		--if both are still what we set it as, then we know that the bot hasn't found any ground above him yet, and need 
		--move towards player
		return px
	elseif max_to_jump == -1 then
		--if the max is still the same as what we set it as, then we know that the
		--min has something useful for us from the if statement before
		for o in all(min_jump) do
			min_to_jump = min(min_to_jump,o)
		end
		prev_jump = stored_jump
		prev_jump_y = stored_jump_y
		if min_to_jump == bot.x and  max_to_jump != -1 and max_to_jump < min_to_jump then
			return max_to_jump
		end
		return min_to_jump
	elseif min_to_jump == 1025 then
		--same for min
		for o in all(max_jump) do
			max_to_jump = max(max_to_jump, o)
		end
		prev_jump = stored_jump
		prev_jump_y = stored_jump_y
		return max_to_jump
	else
		for o in all(min_jump) do
			min_to_jump = min(min_to_jump,o)
		end
		return min_to_jump
	end--if
end

function update_bot(px, py, t)
	--todo for 1.0
	--update the bot to let it attack the player
	--fix ladder bug
	--fix standing still bug
	--fix windmill bug -- getting close, still have a few edge cases to cover
	--fix bug that isn't updating goalx to player.x properly
	--player can cause bot to jump multiple times
	if bot.x < 0 then
		--this somehow fixes the bug causing the bot to favor the max over the min
		--don't know how, don't care tbh
		bot.x = 32
	end
	if collide_map(bot,"right",0) then
		bot.x-=1
	elseif collide_map(bot,"left",0) then
		bot.x+=1
	end
	if bot.dy != 0 then
		prev_jump = 0
		prev_jump_y = 0
		bot.landed = false
	end
	if collide_map(bot, "down", 0) then
		bot.dy=0
		bot.y -= ((bot.y + bot.h + 1) % 8) - 1
		bot.landed=true
		stored_jump = 0
	elseif collide_map(bot, "up", 0) then
		bot.dy = 0
		
		stored_jump = 0
		stored_jump_y = 0
	end

	bot.dy += bot.g
	if py < bot.y then
		local goal = player_above_bot(px, py)
		if goal == px then
			move_goalx(goal)
			move_to_goal()
		else
			move_goalx(goal)
			if bot.x != bot.goalx then
				move_to_goal()
			end
			if (bot.x >= bot.goalx-8 and bot.x <= bot.goalx+8) and bot.landed or (bot.x >= bot.goalx-16 and bot.x <= bot.goalx+16) and bot.landed then
				bot.dy -= 5.5
				bot.landed=false
				prev_jump = stored_jump
				prev_jump_y = stored_jump_y
				stored_jump = bot.x
				stored_jump_y = bot.y
			end
		end
	else
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
		elseif bot.x>=bot.goalx and bot.x>bot.q3 then
			check_px(px)
		elseif bot.x<=bot.goalx and bot.x<bot.q1 then
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
	bot.y += bot.dy
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
	if new_goal == nil then
		new_goal = 0
	end
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
