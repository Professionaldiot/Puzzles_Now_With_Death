pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

function special_pickup_init(x, y, spr, min_spr)
    --only one special pickup per level
    pickup = {x = x, y = y, spr = spr, picked_up = false, anim = 0, max_spr = spr + 4, min_spr = spr}
end

function special_pickup_update()
    if player.y == pickup.y then
        if (player.x > pickup.x and player.x < pickup.x + 8) or 
            (player.x + player.w > pickup.x and player.x + player.w < pickup.x + 8) then
                pickup.picked_up = true
        end
    end
end

function special_pickup_draw()
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

function weapon_pickup_init(x_table, y_table, possible_weapons_table)
    --table[i] --> starts at one
    pwt = possible_weapons_table
    local c_x = count(x_table)
    local c_y = count(y_table)
    local c_total = c_x
    if c_x != c_y then
        if c_x > c_y then
            c_total = c_y
            --if the length of the x_table is shorter then the y_table, then
            --we would be using c_x anyways, so since its the first assigned value, it doesn't matter
        end
    end
    local time_table = {}
    j = 0
    while j < c_total do
        add(time_table, 100+j)
    end
    i = 1
    local weapon_pickups = {}
    while i < c_total do
        random(x_table[i], y_table[i], time_table[i], count(pwt))
        add(weapon_pickups, {x = x_table[i], y_table[i]})
        i+=1
    end
end

function circle_init()
    c = {
        x = 0,
        y = 0,
        angle_in_deg = 270,
        x_center = 147,
        y_center = 80,
        radius = 30,
        da = 0,
        a_res = 0.6,
        acc = 0.5,
        grav = .1,
        values = {}
    }
end

function update_circle_x(angle_in_deg)
    p_angle = angle_in_deg/360
    x = c.x_center + c.radius * sin(p_angle)
    y = c.y_center + c.radius * cos(p_angle)
    h_angle = 360 - (180 - angle_in_deg)
    add(c.values, {x1 = x, y1 = y, hangle = h_angle, angle = angle_in_deg})
    return {x1 = x, y1 = y, hangle = h_angle, angle = angle_in_deg}
end

function change_angle(angle)
    --[[
    try to vectorize the angle, y will be a constant since gravity will be pulling down on it always, the rest to figure
    out is how large and how much the resulting x vector should be
    ]]
    local cday = -c.grav --set as zero for right now

    local x_ang = 360 - (180 - angle) --gets the angle of the resulting vector 

    if x_ang >= 360 then
        x_ang -= 360
    elseif x_ang < 0 then
        x_ang += 360
    end

    cday *= ((x_ang - 180)/90) --make gravity heavy for higher angles
    --this tells us, in percentage, how far away from 180 we are, where 0 is the closest and 135 SHOULD be the max
    local cdax = 1 - cday
    cdax = cdax * c.acc
    cdax *= c.a_res
    c.da += cdax * cday
    if (c.da < 2 and c.da >= 0 and angle > 90 and angle < 180) or (c.da > -2 and c.da <= 0 and angle < 270 and angle > 180) then
        --simulate momentum loss when reaching the top of the swing
        --bigger = quicker time to go down after reaching 90 or 270
        --less means slower to go down and more momentum perserved
        c.da *= sgn(cdax) * 0.8
    elseif (c.da > 0.1 or c.da < -0.1) then
        --simulate momentum loss
        --increasing x in the formula 1/x will make the "swing" stay in motion longer, while smaller x values
        --will make it stop quicker, but make it take longer to stop once it gets real slow
        c.da += -sgn(c.da) * (1/1000)
    elseif c.da <= 0.1 and c.da >= -0.1 and (angle <= 1 or angle >= 359) then
        --if we're going real slow, just stop it, otherwise it will never stop
        c.da = 0
    end


    if c.da >= 2 then
        c.da = 2
    elseif c.da <= -2 then
        c.da = -2
    end

end

function dist(x1, x2, y1, y2)
    num = sqrt(((x2-x1)*(x2-x1)) + ((y2-y1)*(y2-y1)))
    if sgn(num-6) == -1 then
        return flr(num)
    elseif sgn(num-6) == 1 then
        return ceil(num)
    else
        return num
    end
end

function make_circle()
    pos = update_circle_x(c.angle_in_deg)
    dis = dist(c.x_center, pos["x1"], c.y_center, pos["y1"])
    change_angle(c.angle_in_deg)
    c.angle_in_deg += c.da
    if c.angle_in_deg > 360 then
        c.angle_in_deg -= 360
    elseif c.angle_in_deg < 0 then
        c.angle_in_deg += 360
    end
    c.x = pos['x1']
    c.y = pos['y1']
end

function draw_circle()
    line(c.x_center, c.y_center, c.x, c.y, 9)
end

function draw_health()
    health = player.health.."/"
  	h_px = abs((#health * 4) - 16)
    rectfill(cam_x, cam_y, 128 + cam_x, 8 + cam_y, 5)--draw the main background color for status bar
    rectfill(cam_x, cam_y, 100 + cam_x, 8 + cam_y, 13)--draw the padding for health bar
    rectfill(cam_x + 1, cam_y + 1, 99 + cam_x, 7 + cam_y, 2)--draw the red bar under the health bar
	if player.health > 0 then
		rectfill(cam_x + 1, cam_y + 1, player.health + cam_x, 7 + cam_y, 3)
    end
	print(health, cam_x + 102 + h_px/2, cam_y+2, 11)
	print(player.max_health, cam_x + 119 - h_px/2, cam_y+2, 8)
    if player.dead then
        str = 'you died'
        print(str, 64-(#str*2) + cam_x, 112 + cam_y, 8)
    end
end

function manage_health()
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
    r_save()
    load("level2.p8")
end

function debug_any()
    if debug then
        debug = false
    else
        debug = true
    end
end

function player_init()
    debug = true
    old_x = 512
    old_y = 512
    player = {
        dead = false,
        spring = false,
        health = 99,
        max_health = 99,
        start = 0,
        sp = 1,
        x = 59,
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
        running = false,
        jumping = false,
        falling = false,
        climbing = false,
        climbing_down = false,
        sliding = false,
        landed = false
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
    --debug
    if debug then
        printh("player.x: "..player.x..
               " player.y: "..player.y..
               " player.dx: "..player.dx..
               " player.dy: "..player.dy..
               " player.sp: "..player.sp, "player_movement_log.txt", false, true)
    end
    if not player.dead then
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
        if player.climbing
                or player.climbing_down then
            if not collide_map(player, "up", 2) or not collide_map(player, "down", 2) then
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
    end
end

function player_animate()
    if player.climbing then
        player.sp = 49
    elseif player.climbing_down then
        player.sp = 50
    elseif player.jumping then
        player.sp = 32
    elseif player.falling then
        player.sp = 33
    elseif player.sliding then
        player.sp = 48
    elseif player.running then
        if time() - player.anim > .1 then
            player.anim = time()
            if player.sp == 17 then
                player.sp = 1
            else
                player.sp = 17
            end
        end
    else
        --player idle
        if time() - player.anim > .3 then
            player.anim = time()
            if player.sp == 16 then
                player.sp = 1
            else
                player.sp = 16
            end
        end
    end
end

function limit_speed(num, maximum)
    return mid(-maximum, num, maximum)
end

function collide_map(obj, aim, flag)
    --obj = table needs x,y,w,h
    --aim = left,right,up,down

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
    dset(0, player.x)
    dset(1, player.y)
    dset(2, cam_x)
    dset(3, cam_y)
    dset(4, player.health)
    dset(5, player.dead)
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

function r_save(r_health)
    if r_health == nil then
        r_health = true
    end
    dset(0, 59)--player.x
    dset(1, 100)--player.y
    dset(2, 0)--cam_x
    dset(3, 0)--cam_y
    if r_health then
        dset(4, 99)
    end
    if r_health then
        dset(5, 0)--player.dead
    end
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
end

function lload()
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
        --do the bot now
        bot.x = dget(14)
        bot.goalx = dget(15)
        bot.q1 = dget(16)
        bot.mid = dget(17)
        bot.q3 = dget(18)
        bot.aim = dget(19)
        bot.action = dget(20)
        bot.flp = dget(21)
        return true
    end
end

function td_init()
    td_locs = {
        { x = 160, y = 56, sp = 21, flp = true, open = false },
        { x = 168, y = 56, sp = 21, flp = false, open = false },
        { x = 96, y = 32, sp = 21, flp = true, open = false },
        { x = 104, y = 32, sp = 21, flp = false, open = false }
    }
end

function td_update()
    for t in all(td_locs) do
        if flr(player.y) <= t.y - 8 and flr(player.y) > t.y - 11 and player.x >= t.x - 5 and player.x < t.x + 5 and not t.open then
            player.dy = 0
            player.y = t.y - 8
            player.falling = false
            player.landed = true
        end
    end
end

function td_open()
    if td_locs[1]["open"] == false and lvl1_buttons[2]["p"] == true then
        for t = 1, 2 do
            td_locs[t]["open"] = true
            td_locs[t]["sp"] -= 1
        end
    elseif td_locs[3]["open"] == false and lvl1_buttons[3]["p"] == true then
        for t = 3, 4 do
            td_locs[t]["open"] = true
            td_locs[t]["sp"] -= 1
        end
    end
end

function td_draw()
    for t in all(td_locs) do
        spr(t.sp, t.x, t.y, 1, 1, t.flp)
    end
end

function stairs()
    --nullify gravity
    --set player.dy to 0
    --check for stairs on right
    if collide_map(player, "right", 5) then
        if btn(➡️) then
            player.x += 1
            player.y -= 1.5
            player.dy = -.3
            --if btn()
        end
        --if collide_map()
    end
    if collide_map(player, "left", 6) then
        if btn(⬅️) then
            player.x -= 1
            player.y -= 1.5
            player.dy = -.3
            --if btn()
        end
        --if collide_map()
    end

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
            --if collide_map()
        end
    elseif player.dy < 0 then
        player.jumping = true
        --if player.dy>0
    end

    --check collision left and right
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
    end--if player.dx<0
end --function stairs()

function ladder()
    --code allowing you to ascend
    --and descend a ladder at will
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

function btn_init()
    butts = {
        { x = 216, y = 104, sp = 19, act = "tp", p = false },
        { x = 72, y = 104, sp = 19, act = "nil", p = false },
        { x = 136, y = 104, sp = 19, act = "door", p = false },
        { x = 56, y = 48, sp = 19, act = "nil", p = false}
    }
end

function btn_update(btns, obj)
    --updates the button sprites
    --if the player stands on them

    for b in all(btns) do
        if obj.x - 8 <= b.x and b.x <= obj.x + 4 and obj.y - 8 <= b.y and b.y <= obj.y + 2 and not b.p then
            b.sp += 1
            b.p = true
        end
    end
end

function btn_draw(btns)
    for b in all(btns) do
        spr(b.sp, b.x, b.y)
    end
end

function spring_init()
    spring_locs = { 
        { x = 104, y = 104, sp = 51 },
        { x = 368, y = 160, sp = 51 },
        { x = 288, y = 160, sp = 51 },
        { x = 22*8, y = 48, sp = 51 }
    }
end

function spring_update(boxToCheck)
    b = boxToCheck
    for s in all(spring_locs) do
        if box[b].x >= s.x - 6 and box[b].x < s.x + 6 and box[b].start == 0 
                and flr(box[b].y) <= s.y and flr(box[b].y) > s.y - 2 
                and box[b].start==0 and player.start==0 then
            s.sp =52
            box[b].start = time()
        elseif not (flr(box[b].y) <= s.y and flr(box[b].y) > s.y - 2 
                and box[b].x >= s.x - 6 and box[b].x < s.x + 6) 
                and s.sp == 52 and player.start==0 then
            box[b].start = 0
            s.sp = 51
        elseif time() - box[b].start >= 0.5 and box[b].start != 0 and player.start==0 then
            box[b].dy -= (box[b].boost * 1.6)
            box[b].start = 0
            s.sp = 51
        end--if
        
        if player.x >= s.x - 6 and player.x < s.x + 6 and player.start == 0 
                and flr(player.y) <= s.y and flr(player.y) > s.y - 2 
                and player.start==0 and box[b].start==0 then
            s.sp =52
            player.start = time()
        elseif not (flr(player.y) <= s.y and flr(player.y) > s.y - 2 
                and player.x >= s.x - 6 and player.x < s.x + 6) 
                and s.sp == 52 and box[b].start==0 then
            player.start = 0
            s.sp = 51
        elseif time() - player.start >= 0.5 and player.start != 0 and box[b].start==0 then
            player.dy -= (player.boost * 1.6)
            player.landed = false
            player.spring = true
            player.start = 0
            s.sp = 51
        end
    end
end

function spring_draw()
    for s in all(spring_locs) do
        spr(s.sp, s.x, s.y)
    end
end

function box_init()
    box = {
        { x = 220, y = 72, dx = 0, dy = 0, w = 8, h = 8, sp = 4, g = 0.3, f = 0.8, acc = 0.5, mx_dy = 6, mx_dx = 3, boost = 4, start = 0 },
        { x = 240, y = 104, dx = 0, dy = 0, w = 8, h = 8, sp = 4, g = 0.3, f = 0.8, acc = 0.5, mx_dy = 6, mx_dx = 3, boost = 4, start = 0},
        { x = 128, y = 88, dx = 0, dy = 0, w = 8, h = 8, sp = 4, g = 0.3, f = 0.8, acc = 0.5, mx_dy = 6, mx_dx = 3, boost = 4, start = 0 },
        { x = 168, y = 88, dx = 0, dy = 0, w = 8, h = 8, sp = 4, g = 0.3, f = 0.8, acc = 0.5, mx_dy = 6, mx_dx = 3, boost = 4, start = 0 }
    }
end

function box_update()
    --todo for 1.0
    --get boxes landing on top of each other
    --get boxes pushing each other
    --get boxes working with trapdoors, maybe stairs? i don't think it's needed though
    --def get boxes working with springs
    for b in all(box) do
        btn_update(butts, b)
        b.dy += b.g
        b.dx *= b.f

        if b.dy > 0 then
            b.dy = mid(-b.mx_dy, b.dy, b.mx_dy)
            if collide_map(b, "down", 0) then
                b.dy = 0
                b.y -= ((b.y + b.h + 1) % 8) - 1
                --if
            end
        elseif b.dy < 0 then
            if collide_map(b, "up", 0) and collide_map(b,"up", 2) then
                b.dy = b.dy
            elseif collide_map(b, "up", 0) then
                b.dy = 0
            end
            --if
        end
        --this checks if the player is standing on top of the box or not
        if player.dy > 0 and b.dy == 0 then
            if player.y < b.y - 4 and player.y >= b.y - 8 and player.x >= b.x - 6 and player.x <= b.x + 6 then
                player.falling = false
                player.landed = true
                player.y = b.y - 8
                player.dy = 0
            end
            --[[
            first we check if the player is attempting to enter the box, if the player is inside of the box we "push" the box by
            making it accelerate in the direction the player is going then we check collision and in those checks we stop the
            player moving into the box if necessary
            ]]
        elseif ((player.x >= b.x and player.x < b.x + 8) or (player.x >= b.x - 8 and player.x < b.x)) and (player.y <= b.y and player.y > b.y - 8) then
            if player.dx < 0 or player.x >= b.x + 8 then
                b.dx -= b.acc
            elseif player.dx > 0 or player.x + 8 <= b.x then
                b.dx += b.acc
            end
        end
        if collide_map(b, "right", 0) and collide_map(b, "right", 2) and b.dx >= 0 then
            b.dx = b.dx
        elseif collide_map(b, "right", 0) and b.dx >= 0 then
            b.dx = 0
            if player.dx > 0 and player.x + 8 > b.x and player.x < b.x and player.y <= b.y and player.y >= b.y - 7 then
                player.dx = 0
                player.x = b.x - 8
            end
        elseif collide_map(b, "left", 0) and collide_map(b, "left", 2) and b.dx <= 0 then
            b.dx = b.dx
        elseif collide_map(b, "left", 0) and b.dx <= 0 then
            b.dx = 0
            if player.dx < 0 and player.x < b.x + 8 and player.x > b.x and player.y <= b.y and player.y >= b.y - 7 then
                player.dx = 0
                player.x = b.x + 8
            end
        end

        b.dx = mid(-b.mx_dx, b.dx, b.mx_dx)
        b.dy = mid(-b.mx_dy, b.dy, b.mx_dy)

        b.x += b.dx
        b.y += b.dy
        for h in all(box) do
            --this checks for collision on all other boxes
            if h != b then
                --check collision
                if (b.x >= h.x and b.x <= h.x + 8 and b.y == h.y)
                        or (b.x + 8 >= h.x and 
                        b.x + 8 <= h.x + 8 and b.y == h.y) then
                    if b.x+7 >= h.x and b.x + 8 <= h.x + 8 and b.y == h.y then
                        --push it to the left, actually
                        if collide_map(b,"right",0) and collide_map(b,"right",2)
                                or collide_map(h,"right",0) and collide_map(h,"right",2) then
                            b.dx = b.dx
                        end
                        if collide_map(h,"right",0) then
                            b.x -= b.dx
                            if (b.x >= h.x and b.x <= h.x + 8
                                     and b.y == h.y and b.dx == 0)
                                    or (b.x + 8 >= h.x and b.x + 8 <= h.x + 8 
                                    and b.y == h.y and b.dx == 0) then
                                b.x = h.x - 8
                            end 
                            b.dx = 0
                            if player.dx > 0 and player.x + 8 > b.x and player.x < b.x 
                                    and player.y <= b.y and player.y >= b.y - 7 then
                                player.dx = 0
                                player.x = b.x - 8
                            end
                        else
                            h.dx = b.dx
                            b.dx *= b.f/4
                        end
                    elseif b.y == h.y then
                        --push it to the right, actually
                        if collide_map(b,"left",0) and collide_map(b,"left",2)
                                or collide_map(h,"left", 0) and collide_map(h,"left",2) then
                            b.dx = b.dx
                        elseif collide_map(h,"left",0) then
                            b.x += b.dx
                            if (b.x >= h.x and b.x <= h.x + 8
                                     and b.y == h.y and b.dx == 0)
                                    or (b.x + 8 >= h.x and b.x + 8 <= h.x + 8 
                                    and b.y == h.y and b.dx == 0) then
                                b.x = h.x + 8
                            end
                            b.dx = 0
                            if player.dx > 0 and player.x + 8 > b.x and player.x < b.x 
                                    and player.y <= b.y and player.y >= b.y - 7 then
                                player.dx = 0
                                player.x = b.x - 8
                            end
                        else
                            h.dx = b.dx
                            b.dx *= b.f/4
                        end--if/else collide_map(h,"left",0)
                    end--elseif the boxes are the same height
                end--if box in other box
            end--if the box isn't the same as the box were on (to stop some bugs from happening that would occur from checking the box over again)
        end--for
    end--for
end--function

function box_draw()
    for b in all(box) do
        spr(b.sp, b.x, b.y)
    end
end


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000