pico-8 cartridge // http://www.pico-8.com
version 42
__lua__


--export -i 64 pnwd.bin .level1.p8 .level2.p8 .level3.p8 .level4.p8 .level5.p8 .level6.p8 .level7.p8 .level8.p8 .boss-room.p8 main-menu.p8
--[[.movement.p8:0 is the player's code, and code that will be in every level
0 is player functions
1 is the trapdoor functions
2 is the stair function
3 is the ladder function
4 is the button functinons
5 is combo lock + block functions
6 is the door functions
]]

function special_pickup_init(x, y, spr, min_spr)
    --[[
    Creates the special pickup for the player to pick up

    Variables:
    * x: int --> x coordinate of the special pickup
    * y: int --> y coordinate of the special pickup
    * spr: int --> sprite of the special pickup
    * min_spr: int --> minimum sprite of the special pickup, max_spr is min_spr + 4
    ]]
    --only one special pickup per level
    pickup = {x = x, y = y, spr = spr, picked_up = false, anim = 0, max_spr = spr + 4, min_spr = spr}
end 

function special_pickup_update()
    --[[
    Checks whether the player should collect the pickup or not
    Variables: NIL

    returns NIL
    ]]
    if player.y == pickup.y and not pickup.picked_up then
        if (player.x > pickup.x and player.x < pickup.x + 8) or 
            (player.x + player.w > pickup.x and player.x + player.w < pickup.x + 8) then
                pickup.picked_up = true
                player.m_base_dmg *= 2.5
                player.r_base_dmg *= 2.5
                player.m_start_dmg = player.m_base_dmg
                player.r_start_dmg = player.r_base_dmg
        end
    end
end

function special_pickup_draw()
    --[[
    Draws the special pickups to the screen

    Variables: NIL

    returns NIL
    ]]
    if time() - pickup.anim >= 0.1 then
        if pickup.spr >= pickup.max_spr - 1 then
            pickup.spr = pickup.min_spr
        else
            pickup.spr += 1
        end
        pickup.anim = time()
    end
    if not pickup.picked_up then
        spr(pickup.spr, pickup.x, pickup.y)
    end
end

function weapon_pickup_init(x_table, y_table, possible_weapons_table, best_value_time, best_value_mult)
    --[[
    Intializes the weapons for a stage, with semi random choices based on the x and y table given.

    Variables:
    * x_table: list[int] --> x coordinates to place weapons at
    * y_table: list[int] --> y coordinates to place weapons at, have to be correlated to the x_table
    * possible_weapons_table: list[table] --> a list of possible weapons for the level
        * as long as the x and y stay the same the weapons will be the same between play sessions
    * best_value_time: int --> the best value to multiply time by for each level
    * best_value_mult: int --> the best value to multiply the addition to the time for each level
        * creates further apart time differences if higher 
    
    returns: NIL
    ]]
    --table[i] --> starts at one
    local pwt = possible_weapons_table
    local c_total = #x_table
    local time_table = {}
    j = 0
    while j < c_total + 1 do
        --simulate time, since we are doing this at the beginning of the game
        add(time_table, (100*best_value_time)+(j*best_value_mult))
        j+=1
    end
    i = 1
    weapon_pickups = {}
    while i < c_total + 1 do
        --create weapons
        weapon =  random(x_table[i], y_table[i], time_table[i], #pwt)%c_total
        if weapon == 0 or weapon >= c_total then
            weapon = i
        else
            weapon =  random(x_table[i], y_table[i], time_table[i], #pwt)%c_total
        end
    
        --weapons need atk_mult, sp, ranged
        add(weapon_pickups, {x = x_table[i], y = y_table[i], atk_mult = pwt[weapon].atk_mult, 
                            sp = pwt[weapon].sp, ranged = pwt[weapon].ranged, picked_up = false})
        i+=1
    end
end

function update_weapons()
    local max_ranged_dmg = 10
    local max_melee_dmg = 5.25
    local wp = weapon_pickups
    for w in all(wp) do
        if player.y == w.y and not w.picked_up then
            if (player.x > w.x and player.x < w.x + 8) or 
                (player.x + player.w > w.x and player.x + player.w < w.x + 8) then
                w.picked_up = true
                if w.ranged then
                    if player.r_base_dmg < w.atk_mult and not pickup.picked_up then
                        player.r_base_dmg = w.atk_mult
                        player.r_start_dmg  = player.r_base_dmg
                    elseif pickup.picked_up then
                        --hopefully this doesn't happen as much, but it can happen
                        --levels will be designed around the fact that the special 
                        --pickup is the last thing you have to pickup
                        player.r_base_dmg *= w.atk_mult
                        if player.r_base_dmg >= max_ranged_dmg then
                            player.r_base_dmg = max_ranged_dmg
                        end
                        player.r_start_dmg  = player.r_base_dmg
                    end
                else
                    if player.m_base_dmg < w.atk_mult and not pickup.picked_up then
                        player.m_base_dmg = w.atk_mult
                        player.m_start_dmg  = player.m_base_dmg
                    elseif pickup.picked_up then
                        player.m_base_dmg *= w.atk_mult
                        if player.m_base_dmg >= max_melee_dmg then
                            player.m_base_dmg = max_melee_dmg
                        end
                        player.m_start_dmg  = player.m_base_dmg
                    end
                end--if player ranged
            end--if player on weapon
        end--if player y == w.y
    end--for                 
end 

function draw_weapons()
    --[[
    Draws the weapons to the screen

    Variables: NIL

    returns NIL
    ]]
    for i = 1, #weapon_pickups do
        if not weapon_pickups[i].picked_up then
            spr(weapon_pickups[i].sp, weapon_pickups[i].x, weapon_pickups[i].y)
        end
    end
end

function draw_health()
    --[[
    Draws the player health to the screen

    Variables: NIL

    returns NIL
    ]]
    health = player.health.."/"
    m_base = "melee: "..flr(player.m_base_dmg).."/10"
    r_base = "ranged: "..flr(player.r_base_dmg).."/5"
  	h_px = abs((#health * 4) - 16)

    rectfill(cam_x, cam_y, 128 + cam_x, 8 + cam_y, 5)--draw the main background color for status bar
    rectfill(cam_x, cam_y, 100 + cam_x, 8 + cam_y, 13)--draw the padding for health bar
    rectfill(cam_x + 1, cam_y + 1, 99 + cam_x, 7 + cam_y, 2)--draw the red bar under the health bar
	if player.health > 0 then
		rectfill(cam_x + 1, cam_y + 1, player.health + cam_x, 7 + cam_y, 3)
    end
	print(health, cam_x + 102 + h_px/2, cam_y+2, 11)
	print(player.max_health, cam_x + 119 - h_px/2, cam_y+2, 8)
    print(r_base.."    "..m_base, cam_x + 16 - #m_base/2, cam_y+10, 8)
    if player.dead or player.health == 0 then
        local str = 'you died'
        local str2 = "press 🅾️ to restart level"
        print(str, (64 + cam_x)-(#str*2), 112 + cam_y, 8)
        print(str2, (64 + cam_x)- (#str2/2) - abs(#str2 - #str)*2, 120 + cam_y, 8)
    end
end

function manage_health()
    --[[
    Checks whether to remove health from the player or not based on a variety of factors

    Variables: NIL

    returns NIL
    ]]
    --this function checks whether to remove health from the player that will be displayed later
    local damage = 0
    if old_y > player.y then
        old_x = 1024
        old_y = 512
    end
    if player.dy >= 2.5 and old_y == 512 then
        old_y = player.y
        old_x = player.x
    end
    if player.dy == 0 and old_y != 512 and (player.y - old_y) >= 50 then
        damage = min(ceil((player.y - old_y)*player.max_health%player.health), ((player.y - old_y)*(player.health/player.max_health)))
        old_y = 512
        old_x = 1024
    elseif player.dy == 0 then
        old_y = 512
        old_x = 1024
    end

    if collide_map(player, "right", 1) or collide_map(player, "left", 1) or
            collide_map(player, "down", 5) or collide_map(player,"down", 6) or player.spring then
        damage = 0
    end
    rand = random(player.x, player.y, time(), 100)
    while rand == 0 do
        --removes the possibility of dealing 0 damage
        rand = random(player.x, player.y, time(), 100)
    end
    rand = flr(rand/10)
    damage = ceil(damage)
    damage = min(damage, min((1/3) * player.health, player.max_health))
    damage = ceil(damage)
    damage = min(damage, rand)
    player.health -= damage
    if player.health <= 0 then
        player.health = 0
        player.dead = true
        --do kill anim?
    end
end

function reset_level()
    --[[
    Resets the level

    Variables: NIL

    returns NIL
    ]]
    local level_on = dget(12)
    local levels = {".level1.p8", ".level2.p8", ".level3.p8",".level4.p8", ".level5.p8", ".level6.p8",".level7.p8", ".level8.p8"}
    r_save()
    load(levels[level_on])
end

function projectile_init()
    --[[
    Intializes the projectile that the player shoots

    Variables: NIL

    returns NIL
    ]]
    proj = {
        x = 0,
        y = 0,
        w = 8,
        h = 8,
        x_start = 0,
        x_end = 0,
        dmg = 0,
        dx = 0,
        flp = false,
        stop = false
    }
end

function projectile_hit_reg()
    --[[
    Computes whether the projectile is hitting something on the map (or an enemy) or not
    Variables: NIL

    returns NIL
    ]]
    --make a box around it that will do damage ONCE, then remove it
    local bx = bot.x + 4
    local by = bot.y + 4 -- the middle of the bot is probs best for hit reg
    local x_check = bx > proj.x and bx < proj.x + 8
    local y_check = by > proj.y and by < proj.y + 8
    local hit_bot = x_check and y_check
    if proj.dx > 0 then
        if collide_map(proj, "right", 0) then
            proj.stop = true
        elseif hit_bot then
            proj.stop = true
            bot.health -= proj.dmg
        end
    elseif proj.dx < 0 then
        if collide_map(proj, "left", 0) then
            proj.stop = true
        elseif hit_bot then
            proj.stop = true
            bot.health -= proj.dmg
        end
    end
end

function projectile_update()
    --[[
    Updates the projectile based on whether the player is charging or not, and if they're shooting or not

    Variables: NIL

    returns NIL
    ]]
    if proj.dmg == nil then
        proj.dmg = 1 * player.r_base_dmg
    end
    if proj.dmg == 0 or player.charging then
        proj.dmg = player.r_base_dmg
        proj.y = player.y
    end
    projectile_hit_reg()
    if proj.stop then
        proj.x = 0
        proj.y = 0
        proj.x_start = 0
        proj.x_end = 0
        proj.dx = 0
        proj.flp = 0
        player.shooting = false
        proj.dmg = player.r_start_dmg
        proj.stop = false
    elseif (not player.charging) and player.shooting and player.ranged then
        --when the player stops holding the charge, store the damage the proj will do on impact
        --then set atk_spr.charge to 0 and player.charging = false
        --dget(60) stores the value for the start of the line
        --dget(61) stores the max value of the line
        if proj.flp == 0 then
            proj.flp = player.flp
        end
        if proj.x_start == 0 then
            if player.flp then
                proj.x_start = player.x
                proj.dx = -2.5 -- the player is now out of control of the bullet until it stops flying
            else
                proj.x_start = player.x + 8
                proj.dx = 2.5 -- the player is now out of control of the bullet until it stops flying
            end
        end
        --the projectile can only go so far, need to max it out on the edge of the screen
        if proj.x_end == 0 then
            if player.flp then
                proj.x_end = (player.x - (player.x - cam_x))
            else
                proj.x_end = (player.x + (128 - (player.x - cam_x)))
            end
        end
        if proj.x == 0 then
            proj.x = player.x -- set the starting point for the proj, this RAM address will be what moves in value
        elseif proj.x > 0 and ((proj.dx == -2.5 and (proj.x > proj.x_end)) or (proj.dx == 2.5 and (proj.x < proj.x_end))) then
            proj.x += proj.dx
        else -- the proj reached the end of the path, reset everything
            proj.x = 0
            proj.y = 0
            proj.x_start = 0
            proj.x_end = 0
            proj.dmg = 0
            proj.dx = 0
            proj.flp = 0
            proj.dmg = player.r_start_dmg
            player.shooting = false
        end
    end
end

function player_init()
    --[[
    Intializes both the player and projectiles that they shoot

    Variables: NIL

    returns NIL
    ]]
    projectile_init()
    atk_spr = {}
        atk_spr.anim = 0
        atk_spr.spr = 10
        atk_spr.x = 0
        atk_spr.y = 0
        atk_spr.flp = false
        atk_spr.charge = 0
    debug = true
    old_x = 512
    old_y = 512
    player = {
        dead = false,
        spring = false,
        health = 99,
        max_health = 99,
        m_start_dmg = 1,
        r_start_dmg = 1,
        m_base_dmg = 1,
        r_base_dmg = 2,
        start = 0,
        sp = 1,
        x = 24,
        y = 100,
        w = 8,
        h = 8,
        flp = false,
        dx = 0,
        dy = 0,
        max_dx = 2,
        max_dy = 3,
        acc = 0.5,
        boost = 4,
        anim = 0,
        stairs = false,
        trapdoor = false,
        running = false,
        jumping = false,
        falling = false,
        climbing = false,
        climbing_down = false,
        sliding = false,
        landed = false,
        attacking = false,
        hitting = false,
        shooting = false,
        charging = false,
        melee = true,
        ranged = false
    }

    gravity = 0.3
    friction = 0.85

    --simple camera
    cam_x = 0
    cam_y = 0

    --map limits
    map_start = 0
    map_end = 1024
    map_heightlimit = 512
    map_heightmin = 0
end

function player_update()
    --[[
    The main function for all player updating, controls everything the player does

    Variables: NIL

    returns NIL
    ]]
    if player.y > 300 then
        player.dead = true
    end
    if not player.dead then
        if (collide_map(player, "down", 2) or collide_map(player, "right", 2) or collide_map(player, "left", 2)) then
            player.health = 0
            player.dead = true
        end
        --physics
        player.dy += gravity
        player.dx *= friction

        --controls
        if btn(⬅️) then
            player.dx -= player.acc
            player.running = true
            player.flp = true
        end
        if btn(➡️) then
            player.dx += player.acc
            player.running = true
            player.flp = false
        end

        --stairs
        if player.falling and player.stairs and player.dy < 0 then
            player.stairs = false
        end
        if player.running and player.stairs and player.dy >= 0 then
            --set the stair flag to false when not on the stairs
            player.stairs = false
        end

        --slide
        if player.running
                and not btn(⬅️)
                and not btn(➡️)
                and not player.falling
                and not player.jumping then
            player.running = false
            player.sliding = true
        end

        --jump
        if btnp(⬆️)
                and player.landed then
            player.dy -= player.boost
            player.landed = false
            player.trapdoor = false
        end
        --❎🅾️
        if btnp(❎) then
            if player.melee then 
                player.ranged = true
                player.melee = false
            else
                player.melee = true
                player.ranged = false
            end
        end
        if btn(🅾️) and player.melee then
            player.attacking = true
            atk_spr.flp = player.flp 
            if not player.charging and atk_spr.charge == 0 then
                player.charging = true
                atk_spr.charge = time()
            end
        elseif btn(🅾️) and player.ranged then
            player.shooting = true
            atk_spr.flp = player.flp
            if not player.charging and atk_spr.charge == 0 then
                player.charging = true
                atk_spr.charge = time()
            end
        end
        if atk_spr.charge != 0 and player.charging then
            if player.melee then
                player.m_base_dmg = mid(player.m_start_dmg, (time() - atk_spr.charge), 10)
            else
                player.r_base_dmg = mid(player.r_start_dmg, (time()-atk_spr.charge), 5)
            end
        end
        if (not btn(🅾️)) and (player.attacking or player.hitting) then
            player.attacking = false
            player.hitting = true
            player.charging = false
            atk_spr.charge = 0
            local px = player.x
            local bw_d = bot.w*2
            local bw_h = bot.w/2
            local bot_right = px + 8 > bot.x - 4 and px + 8 < bot.x + 16 --player on the right side of the bot
            local bot_left = px > bot.x - bw_d and px < bot.x + bw_d --player on the left side of the bot
            if bot_right then
                if not player.flp and player.hitting then
                    if player.melee then
                        bot.health -= player.m_base_dmg
                    else
                        bot.health -= player.r_base_dmg
                    end
                    player.hitting = false
                end
            end
            if bot_left then
                if player.flp and player.hitting then
                    if player.melee then
                        bot.health -= player.m_base_dmg
                    else
                        bot.health -= player.r_base_dmg
                    end
                end
            end
        end
        if (not btn(🅾️)) and (player.ranged or player.shooting) then
            player.charging = false
            atk_spr.charge = 0
            local px = player.x
            local bw_d = bot.w*2
            local bw_h = bot.w/2
            local bot_right = px + 8 > bot.x - 4 and px + 8 < bot.x + 16 --player on the right side of the bot
            local bot_left = px > bot.x - bw_d and px < bot.x + bw_d --player on the left side of the bot
            if bot_right then
                if not player.flp and player.hitting then
                    if player.melee then
                        bot.health -= player.m_base_dmg
                    else
                        bot.health -= player.r_base_dmg
                    end
                end
            end
            if bot_left then
                if player.flp and player.hitting then
                    if player.melee then
                        bot.health -= player.m_base_dmg
                    else
                        bot.health -= player.r_base_dmg
                    end
                end
            end
        end
        projectile_update()

        if not player.attacking and not player.hitting and not player.charging then
            lold_x = player.x
            lold_y = player.y
        elseif player.attacking or player.hitting or player.charging then
            player.x = lold_x
            player.y = lold_y
            player.dy = 0
            player.dx = 0
        end

        --check collision up and down
        if player.dy > 0 then
            player.falling = true
            player.landed = false
            player.jumping = false

            player.dy = limit_speed(player.dy, player.max_dy)

            if collide_map(player, "down", 0) then
                if player.spring then
                    old_y = 512
                    old_x = 1024
                end
                player.spring = false
                player.landed = true
                player.falling = false
                player.dy = 0
                player.y -= ((player.y + player.h + 1) % 8) - 1
            end
        elseif player.dy < 0 then
            player.jumping = true
            if collide_map(player, "up", 0) then
                player.dy = 0
            end
        end

        --check collision left and right
        if player.dx < 0 then
            player.dx = limit_speed(player.dx, player.max_dx)

            if collide_map(player, "left", 0) then
                player.dx = 0
            end
        elseif player.dx > 0 then
            player.dx = limit_speed(player.dx, player.max_dx)

            if collide_map(player, "right", 0) then
                player.dx = 0
            end
        end

        --stop sliding
        if player.sliding then
            if abs(player.dx) < .2 or player.running then
                player.dx = 0
                player.sliding = false
            end
        end

        --stop climbing
        if player.climbing or player.climbing_down then
            if not collide_map(player, "up", 3) or not collide_map(player, "down", 3) then
                player.climbing = false
                player.climbing_down = false
            end
        end

        player.x += player.dx
        player.y += player.dy

        --limit player to map
        if player.x < map_start then
            player.x = map_start
        end
        if player.x > map_end - player.w then
            player.x = map_end - player.w
        end
    else
        player.sp = 63
        player.anim = time()
        player.dy = 0
        player.dx = 0
        local j = 0
        local levels = {".level1.p8", ".level2.p8", ".level3.p8",".level4.p8", ".level5.p8", ".level6.p8",".level7.p8", ".level8.p8", ".boss-room.p8"}
        if btn(🅾️) then
            for i = 1, dget(12) do
                j += 1
            end
            if dget(12) >= 9 then
                j = 9
            end
            load(levels[j])
        end
            
    end
    if player.attacking and not player.hitting then
        if time() - atk_spr.anim >= .3 then
            player.hitting = true
            player.attacking = false
            atk_spr.anim = time()
            atk_spr.spr = 9
            atk_spr.y = player.y
            atk_spr.flp = player.flp
            if player.flp then
                atk_spr.x = player.x - 8
            else
                atk_spr.x = player.x + 8
            end
        else

        end
    elseif player.hitting then
        if time() - atk_spr.anim > 0.1 then
            player.hitting = false
            atk_spr.anim = time()
            atk_spr.spr = 8
        end
    elseif not player.hitting then
        if time() - atk_spr.anim > 0.1 then
            atk_spr.spr = 10
            atk_spr.anim = time()
        end
    end
    if atk_spr.spr < 8 then
        atk_spr.spr = 10
        atk_spr.anim = 0
        player.hitting = false
        player.attacking = false
    end
end

function player_animate()
    --[[
    Decides which sprite the player should be using based on action in the game

    Variables: NIL

    returns NIL
    ]]
    if player.attacking and player.melee then
        player.sp = 47
    elseif player.charging and player.ranged then
        player.sp = 31
    elseif player.climbing or player.climbing_down then
        if time() - player.anim > .3 then
            player.anim = time()
            if player.sp == 49 then
                player.sp = 50
            else
                player.sp = 49
            end
        end
    elseif player.jumping and not player.stairs then
        player.sp = 32
    elseif player.falling and not player.trapdoor and not player.stairs then
        player.sp = 33
    elseif (player.running or player.stairs) then
        if time() - player.anim > .1 then
            player.anim = time()
            if player.sp == 17 then
                player.sp = 1
            else
                player.sp = 17
            end
        end
    elseif player.sliding then
        player.sp = 48
    elseif atk_spr.charge == 0 or (not player.attacking and not player.hitting and not player.shooting and not player.charging) then
        --player idle
        if time() - player.anim > .3 then
            player.anim = time()
            if player.sp == 16 then
                player.sp = 62
            else
                player.sp = 16
            end
        end
    end
end

function limit_speed(current_speed, maximum_speed)
    --[[
    Limits the speed of the player

    Variables:
    * current_speed: int --> the current speed of the player
    * maximum: int --> the maximum speed to be expected, minimum speed is (-1 * maximum_speed)

    returns INT: the speed the player should be going, limited to -maximum_speed, maximum_speed
    ]]
    return mid(-maximum_speed, current_speed, maximum_speed)
end

function collide_map(object, aim, flag)
    --[[
    Checks whether an object is colliding with something on the map, based on direction

    Variables:
    * object: table --> the object to check collision on
    * aim: string --> the direction of the object to check collision in
    * flag: int --> the flag (0-7) to check collision for

    returns BOOL: whether the object is colliding with the map or not
    ]]
    --obj = table needs x,y,w,h
    --aim = left,right,up,down

    local obj = object
    local x = obj.x
    local y = obj.y
    local w = obj.w
    local h = obj.h

    local x1 = 0
    local y1 = 0
    local x2 = 0
    local y2 = 0

    if aim == "left" then
        x1 = x - 1 y1 = y
        x2 = x y2 = y + h - 1
    elseif aim == "right" then
        x1 = x + w - 1 y1 = y
        x2 = x + w y2 = y + h - 1
    elseif aim == "up" then
        x1 = x + 2 y1 = y - 1
        x2 = x + w - 3 y2 = y
    elseif aim == "down" then
        x1 = x + 2 y1 = y + h
        x2 = x + w - 3 y2 = y + h
    end

    --pixels to tiles
    x1 /= 8
    y1 /= 8
    x2 /= 8
    y2 /= 8

    if fget(mget(x1, y1), flag)
            or fget(mget(x1, y2), flag)
            or fget(mget(x2, y1), flag)
            or fget(mget(x2, y2), flag) then
        return true
    else
        return false
    end
end

function cam_update(min_map_x, max_map_x, max_map_y)
    --[[
    Updates the camera based on the players movement speed

    Varaibles:
    min_map_x: int --> the minimum x coordinate of the map the player is on
    max_map_x: int --> the maximum x coordinate of the map the player is on
    max_map_y: int --> the maximum y coordinate of the map the plaeyr is on (min_map_y is always 0)

    returns NIL
    ]]
    --update the camera based on player.dx
    min_map_y = 0
    if player.dx >= 1 then
        cam_x += player.dx*1.1
    elseif player.dx <= -1 then
        cam_x += player.dx*1.1
    elseif player.dx > -1 and player.dx < 1 and player.dx != 0 then
        --calculate where the player is according to the camera, and move it towards the player
        if player.x - cam_x > 60 then
            cam_x += 1
        end
        if player.x - cam_x < 60 then
            cam_x -= 1
        end
    elseif player.dx == 0 then
        if 60 - flr(player.x - cam_x) != 0 then
            cam_x -= mid(-2, 60 - flr(player.x - cam_x), 2)
        end
    end
    if cam_x <= min_map_x then 
        cam_x = 0
    end
    if cam_x >= max_map_x then
        cam_x = max_map_x
    end
    if player.dy >= 1.5 then
        cam_y += player.dy
    elseif player.dy <= -4 then
        cam_y += player.dy
    elseif player.dy > -4 and player.dy < 1.5 and player.dy != 0 then
        if player.y - cam_y > 80 then
            --this moves the camera down if the difference between player.y and the cameras y is greater than 80
            --(the player is below where the camera is sitting)
            cam_y += 1
        end
        if player.y - cam_y < 80 then
            --this moves the camera up if the player.y and the camera y have a difference of less than 80
            --(the player is above where the camera is sitting)
            cam_y -= 1
        end
    elseif player.dy == 0 then
        --this moves the camera back towards 80, and has a tendency to smooth out the speed when it gets faster
        if 80 - flr(player.y - cam_y) != 0 then
            cam_y -= mid(-8, 80 - flr(player.y - cam_y), 8)
        end
    end
    if cam_y <= min_map_y then
        cam_y = min_map_y
    end
    if cam_y >= max_map_y then
        cam_y = max_map_y
    end

    camera(cam_x, cam_y)
end

function save()
    --[[
    Lets the player save the game

    Variables: NIL

    returns NIL
    ]]
    dset(0, player.x)
    dset(1, player.y)
    dset(2, cam_x)
    dset(3, cam_y)
    dset(4, player.health)
    dset(5, player.dead)
    dset(6, player.m_base_dmg)
    dset(7, player.r_base_dmg)
    dset(8, player.m_start_dmg)
    dset(9, player.r_start_dmg)
    dset(13, true)
    if dget(12) == 7 then
        dset(22, p.x)
        dset(23, p.y)
        dset(24, p.next_vertex)
        dset(25, p.prev_vertex)
    end
    --save the player pos
    --now do the bot
    dset(14, bot.x)
    dset(15, bot.goalx)
    dset(16, bot.q1)
    dset(17, bot.mid)
    dset(18, bot.q3)
    dset(19, bot.aim)
    dset(20, bot.action)
    dset(21, bot.flp)
end

function r_save(r_health, r_base_dmg)
    --[[
    Resets the player save game

    Variables:
    * r_save: bool --> whether to reset the health or not in memory (the save)

    returns NIL
    ]]
    if r_base_dmg == nil then
        r_base_dmg = true
    end
    if r_health == nil then
        r_health = true
    end
    dset(0, 59)--player.x
    dset(1, 100)--player.y
    dset(2, 0)--cam_x
    dset(3, 0)--cam_y
    if r_health then
        dset(4, 99)
        dset(5, 0)
    end
    if r_base_dmg then
        dset(6, 1)
        dset(7, 2)
        dset(8, 1)
        dset(9, 2)
    end
    --dset(12, 1)--level player is on
    dset(14, 0)--bot.x
    dset(15, nil)--bot.goalx
    dset(16, 0)--bot.q1
    dset(17, 0)--bot.mid
    dset(18, 0)--bot.q3
    dset(19, "right")--bot.aim
    dset(20, "stand")--bot.action
    dset(21, false)--bot.flp

    dset(12, 1)--level on
    dset(13, false)--level load

    dset(22, 0)--platform.x
    dset(23, 0)--platform.y
    dset(24, 2)--platform.next_vertex
    dset(25, 1)--platform.prev_vertex
end

function lload()
    --[[
    Allows the player to load a savefile they've created with the save() function

    Variables: NIL

    returns NIL
    ]]
    if dget(0) == 0 then
        return false
    else
        player.x = dget(0)
        player.y = dget(1)
        cam_x = dget(2)
        cam_y = dget(3)
        player.health = dget(4)
        if dget(5) == 0 or dget(5) == false then
            player.dead = false
        else
            player.dead = dget(5)
        end
        player.m_base_dmg = dget(6)
        player.r_base_dmg = dget(7)
        player.m_start_dmg = dget(8)
        player.r_start_dmg = dget(9)
        --do the bot now
        bot.x = dget(14)
        bot.goalx = dget(15)
        bot.q1 = dget(16)
        bot.mid = dget(17)
        bot.q3 = dget(18)
        bot.aim = dget(19)
        bot.action = dget(20)
        bot.flp = dget(21)
        if dget(12) == 7 then
            p.x = dget(22)
            p.y = dget(23)
            if p.x == 0 then
                p.x = 4
            end
            if p.y == 0 then
                p.y = 97
            end
            p.next_vertex = dget(24)
            p.prev_vertex = dget(25)
        end
        return true
    end
end

-->8
--trapdoor functions
function td_init()
    --[[
    Intializes the trapdoors for .level1.p8

    Variables: NIL

    returns NIL
    ]]
    td_locs = {
        {x = 120, y = 80, sp = 21, flp = true, open = false}, -- 3
        {x = 128, y = 80, sp = 21, flp = false, open = false},

        {x = 96, y = 24, sp = 21, flp = true, open = false},
        {x = 104, y = 24, sp = 21, flp = false, open = false}, -- 4
        
        {x = 160, y = 96, sp = 21, flp = true, open = false},
        {x = 168, y = 96, sp = 21, flp = false, open = false}, -- 5

        {x = 336, y = 96, sp = 21, flp = true, open = false}, -- 2
        {x = 344, y = 96, sp = 21, flp = false, open = false}
    }
end

function td_grav(td_list)
    --[[
    Decides whether the player should fall or not when standing over where a trapdoor is

    Variables: NIL

    returns NIL
    ]]
    if td_list == nil then
        td_list = td_locs
    end
    for t in all(td_list) do
        if flr(player.y) >= t.y - 8 and flr(player.y) < t.y and player.x >= t.x - 5 and player.x < t.x + 5 and not t.open then
            player.dy = 0
            player.y = t.y - 8
            player.falling = false
            player.landed = true
            player.trapdoor = true
        end
    end
end

function td_update(level, td_list)
    --[[
    Updates the trapdoors based on level the player is on

    Variables:
    * level: int --> the level that the player is on

    returns NIL
    ]]
    if td_list == nil then
        td_list = td_locs
    end
    if level == 2 then
        if td_list[1].open == false and lvl2_buttons[3].p == true then
            for t = 1, 2 do
                td_list[t].open = true
                td_list[t].sp -= 1
            end
        elseif td_list[3].open == false and lvl2_buttons[4].p == true then
            for t = 3, 4 do
                td_list[t].open = true
                td_list[t].sp -= 1
            end
        elseif td_list[5].open == false and lvl2_buttons[5].p == true then
            for t = 5, 6 do
                td_list[t].open = true
                td_list[t].sp -= 1
            end
        elseif td_list[7].open == false and lvl2_buttons[2].p == true then
            for t = 7, 8 do
                td_list[t].open = true
                td_list[t].sp -= 1
            end
        end
    end
end

function td_draw(td_list)
    --[[
    Draws the trapdoors to the screen

    Variables: NIL

    returns NIL
    ]]
    if td_list == nil then
        td_list = td_locs
    end
    for t in all(td_list) do
        spr(t.sp, t.x, t.y, 1, 1, t.flp)
    end
end

-->8
--stair function
function stairs()
    --[[
    Allows the player to 'go up' stairs at will

    Variables: NIL

    returns NIL
    ]]
    --nullify gravity
    --set player.dy to 0
    --check for stairs on right
    --[[
    btn(➡️)
    btn(⬅️)
    ]]
    --check collision left and right
    if collide_map(player, "right", 5) then
        if btn(➡️) then
            player.x += 1
            player.y -= 1.5
            player.dy = -.3
            player.stairs = true
        end--if btn()
    end--if collide_map()
    if collide_map(player, "left", 6) then
        if btn(⬅️) then
            player.x -= 1
            player.y -= 1.5
            player.dy = -.3
            player.stairs = true
        end--if btn()
    end--if collide_map()

    if player.dy > 0 then
        player.falling = true
        player.landed = false
        player.jumping = false

        player.dy = limit_speed(player.dy, player.max_dy)

        if collide_map(player, "down", 5) or collide_map(player, "down", 6) then
            player.landed = true
            player.falling = false
            player.dy = 0
            player.y -= ((player.y + player.h + 1) % 8) - 1
        end--if collide_map()
    elseif player.dy < 0 then
        player.jumping = true
    end--if player.dy < 0
    if player.dx < 0 then
        player.dx = limit_speed(player.dx, player.max_dx)

        if collide_map(player, "left", 6) then
            player.dx = 0
        end--if collide_map()
    elseif player.dx > 0 then
        player.dx = limit_speed(player.dx, player.max_dx)

        if collide_map(player, "right", 5) then
            player.dx = 0
        end--if collide_map()
    end--if player.dx > 0
end --function stairs()

-->8
--ladder function
function ladder()
    --[[
    Allows the player to climb and descend ladders

    Variables: NIL

    returns NIL
    ]]
    if collide_map(player, "up", 1) then
        if btn(⬆️) then
            if collide_map(player, "up", 0) then
                player.y += 1
            end--if collide_map
            player.y -= 1
            player.climbing = true
            player.climbing_down = false
        end--if btn()
        if btn(⬇️) then
            player.y += 1
            player.climbing = false
            player.climbing_down = true
        end--if btn()
        player.dy = -.3
    end--if collide_map(up)
end--function ladder()
    
-->8
--button code
function btn_init()
    --[[
    Intializes the button list for .level3.p8

    Variables: NIL

    returns NIL
    ]]
    butts = {
        { x = 216, y = 104, sp = 19, act = "tp", p = false, sfx = 0},
        { x = 72, y = 104, sp = 19, act = "nil", p = false, sfx = 0},--2
        { x = 136, y = 104, sp = 19, act = "door", p = false, sfx = 0},
        { x = 56, y = 48, sp = 19, act = "nil", p = false, sfx = 0},--4
        { x = 57*8, y = 104, sp = 19, act=".boss-room.p8", p = false, sfx = 0}
    }
end

function btn_update(btn_list, object)
    --[[
    Updates the button sprites if the player stands on them
    
    Variables:
    * btn_list: list[table] --> a list containing all the buttons to check if they are press or not
    *object: table --> the object to check buttons pressing on

    returns NIL
    ]]
    local btns = btn_list
    local obj = object
    i = 1
    while i <= #btns do
        if btns[i].p == true then
            if btns[i].sfx >= 0 and time() - btns[i].sfx <= 0.1 then
                sfx(63, 3)
                btns[i].p = false
            elseif btns[i].sfx == 0 then
                btns[i].sfx = time()
            end
        end
        i+=1
    end
    for b in all(btns) do
        if obj.x - 8 <= b.x and b.x <= obj.x + 4 and obj.y - 8 <= b.y and b.y <= obj.y + 2 and not b.p and b.sfx == 0 then
            b.sp += 1
            b.p = true
        end
    end
end

function btn_draw(btns)
    --[[
    Draws the buttons to the screen

    Variables:
    * btns: list[table] --> a list of all the buttons in the level

    returns NIL
    ]]
    for b in all(btns) do
        spr(b.sp, b.x, b.y)
    end
end

-->8
--combo lock + block code
function combo_lock_update(combo, btn_list, combo_as_list, max_length, block_x, block_y, block_w, block_h)
    --[[
    Updates the combo lock [buttons] based on the combo the player provides

    Variables:
    * combo: list[int] --> the combo the user is inputting
    * btn_list: list[table] --> a list containing all the buttons in the level
    * combo_as_list: list[int] --> a list of ints that describe the correct combo, i.e. {1,2,3}
    * max_length: int --> the maximum length of the combo
    * block_x: int --> the x coordinate of the block to be placed
    * block_y: int --> the y coordinate of the block to be placed
    * block_w: int --> block width
    * block_h: int --> block height

    returns BOOL: whether to reset the stored_combo and the buttons associated with those buttons
    ]]
    local reset_combo = false
    if #combo == max_length then
        if check_combo(combo_as_list, combo) then
            --create a block at x, y
            block = {x = block_x, y = block_y, w = block_w, h = block_h, sp = 78}
        else
            reset_combo = true
        end
    end
    return reset_combo
end

function check_block_collision(b)
    --[[
    Checks whether the player should be pushed out of the block based on their x and y

    Variables:
    * b: table --> the block to check collision on

    returns NIL
    ]]
    --block needs a x, y, w, h
    y_check = flr(player.y) >= b.y - 8 and flr(player.y) < b.y and player.x >= b.x - 5 and player.x < b.x + 5
    --check player.x + 8 (right)
    if player.x + 8 > b.x and player.x + 8 < b.x + 8 and player.y + 4 > b.y and player.y + 4 < b.y + 8 then
        --push the player out
        player.dx = 0
        player.x = b.x - 8
    end
    --check player.x (left)
    if player.x > b.x and player.x < b.x + 8 and player.y + 4 > b.y and player.y + 4 < b.y + 8 then
        player.dx = 0
        player.x = b.x + 8
    end
    --check player.y + 8 (down)
    if flr(player.y) >= b.y - 8 and flr(player.y) < b.y and player.x >= b.x - 4 and player.x < b.x + 8 then
        player.dy = 0
        player.y = b.y - 8
        player.falling = false
    end
    --check player.y (up)
    if flr(player.y) >= b.y and flr(player.y) < b.y + 8 and player.x > b.x - 4 and player.x < b.x + 8 then
        player.dy = 0
        player.y = b.y + 8
    end
end

function draw_block(b)
    --[[
    Draws the block to the screen

    Variables:
    * b: table --> the block to check collision on

    returns NIL
    ]]
    spr(b.sp, b.x, b.y)
end

function check_combo(correct_combo, current_attempt)
    --[[
    Checks the combo that the player is doing on the stage and compares it with the correct combo

    Variables:
    * correct_combo: list[int] --> describes the correct combo as a list of ints
    * current_attempt: list[int] --> describes the current attempt that user is providing

    returns BOOL: whether the current combo is correct or not
    ]]
    --runs in O(n) time
    for i = 1, #correct_combo do
        if correct_combo[i] != current_attempt[i] then
            return false
        end
    end
    return true
end

-->8
--door functions
function door_init(x, y)
    --[[
    Intializes the door on the stage with a given x, y

    Variables:
    * x: int --> x coordinate of the door
    * y: int --> y coordinate of the door

    returns NIL
    ]]
    all_pressed = false
    door = {x = x, y = y, open = false, sp = 79}
end

function door_update(btn_list, index_list)
    --[[
    Updates the door based on whether certain buttons are pressed or not

    Variables:
    * btn_list: list[table] --> a list of buttons on the level
    * index_list: list[int] --> a list of the indexs to check whether they are pressed or not in the level

    returns NIL
    ]]
    --door_amnt is the total amount of doors, 0 < door_amnt < 1 to not stress the program too much
    --index_list is a table like the following: {1,3,4}, this tells the program where to check the button list for door stuff
    -- 0 < #index_list < 5
    if player.flp and not door.open then
        if player.x < door.x + 8 and player.x > door.x and player.y == door.y then
            --player is to the right of the door, and its not open, push them out
            player.dx = 0
            player.x = door.x + 8
        end
    elseif not door.open then
        if player.x + 8 > door.x and player.x + 8 < door.x + 8 and player.y == door.y then
            player.dx = 0
            player.x = door.x - 8
        end
    end
    if not all_pressed then
        all_pressed = true
        for item in all(index_list) do
            if btn_list[item].sfx == 0 then
                all_pressed = false
            end
        end
    else
        door.open = true
        door.sp = 77
    end
end

function door_draw()
    --[[
    Draws the door to the screen

    Variables: NIL

    returns NIL
    ]]
    spr(door.sp, door.x, door.y)
end





__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000