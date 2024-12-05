pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--[[
BUGS:

*player can move over spring and it will still launch them upwards
]]
function debug_any()
    if debug then
        debug = false
    else
        debug = true
    end
end

function player_init()
    debug = true
    player = {
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

function cam_update()
    if player.dx >= 1.9 then
        cam_x += player.dx
    elseif player.dx <= -1.9 then
        cam_x += player.dx
    elseif player.dx > -1.9 and player.dx < 1.9 and player.dx != 0 then
        --calculate where the player is according to the camera, and move it towards the player
        if player.x - cam_x > 60 then
            cam_x += 1
        end
        if player.x - cam_x < 60 then
            cam_x -= 1
        end
    elseif player.dx == 0 then
        if 60 - flr(player.x - cam_x) != 0 then
            cam_x -= 60 - flr(player.x - cam_x)
        end
    end
    if player.dy >= 1.5 then
        cam_y += player.dy
    elseif player.dy <= -4 then
        cam_y += player.dy
    elseif player.dy > -4 and player.dy < 1.5 and player.dy != 0 then
        if player.y - cam_y > 80 then
            cam_y += 1
        end
        if player.y - cam_y < 80 then
            cam_y -= 1
        end
    elseif player.dy == 0 then
        if 80 - flr(player.y - cam_y) != 0 then
            cam_y -= 80 - flr(player.y - cam_y)
        end
    end
    camera(cam_x, cam_y)
end

function save()
    dset(0, player.x)
    dset(1, player.y)
    dset(2, cam_x)
    dset(3, cam_y)
    --save the player pos
    --now do the bot
    dset(4, bot.x)
    dset(5, bot.goalx)
    dset(6, bot.q1)
    dset(7, bot.mid)
    dset(8, bot.q3)
    dset(9, bot.aim)
    dset(10, bot.action)
    dset(11, bot.flp)
end

function r_save()
    dset(0, 59)--player.x
    dset(1, 100)--player.y
    dset(2, 0)--cam_x
    dset(3, 0)--cam_y
    dset(4, 0)--bot.x
    dset(5, nil)--bot.goalx
    dset(6, 0)--bot.q1
    dset(7, 0)--bot.mid
    dset(8, 0)--bot.q3
    dset(9, "right")--bot.aim
    dset(10, "stand")--bot.action
    dset(11, false)--bot.flp
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
        --do the bot now
        bot.x = dget(4)
        bot.goalx = dget(5)
        bot.q1 = dget(6)
        bot.mid = dget(7)
        bot.q3 = dget(8)
        bot.aim = dget(9)
        bot.action = dget(10)
        bot.flp = dget(11)
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
            --if collide_map()
        end
    elseif player.dx > 0 then
        player.dx = limit_speed(player.dx, player.max_dx)

        if collide_map(player, "right", 5) then
            player.dx = 0
            --if collide_map()
        end
        --if player.dx<0
    end
    --function stairs()
end

function ladder()
    --code allowing you to ascend
    --and descend a ladder at will
    if collide_map(player, "up", 1) then
        if btn(⬆️) then
            if collide_map(player, "up", 0) then
                player.y += 1
                --if collide_map
            end
            player.y -= 1
            player.climbing = true
            player.climbing_down = false
            --if btn()
        end
        if btn(⬇️) then
            player.y += 1
            player.climbing = false
            player.climbing_down = true
            --if btn()
        end
        player.dy = -.3
        --if collide_map(up)
    end
    --function ladder()
end

function btn_init()
    butts = {
        { x = 216, y = 104, sp = 19, act = "tp", p = false },
        { x = 72, y = 104, sp = 19, act = "nil", p = false },
        { x = 136, y = 104, sp = 19, act = "door", p = false }
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
    spring_locs = { { x = 104, y = 104, sp = 51 } }
end

function spring_update()
    for s in all(spring_locs) do
        if player.x >= s.x - 6 and player.x < s.x + 6 and player.start == 0 
                and flr(player.y) <= s.y and flr(player.y) > s.y - 2 
                and player.start==0 then
            s.sp =52
            player.start = time()
        elseif not (flr(player.y) <= s.y and flr(player.y) > s.y - 2 
                and player.x >= s.x - 6 and player.x < s.x + 6) 
                and s.sp == 52 then
            player.start = 0
            s.sp = 51
        elseif time() - player.start >= 0.5 and player.start != 0 then
            player.dy -= (player.boost * 1.6)
            player.landed = false
            player.start = 0
            s.sp = 51
        else
            for b = 1,3 do
                if box[b].x >= s.x - 6 and box[b].x < s.x + 6 and box[b].start == 0 
                        and flr(box[b].y) <= s.y and flr(box[b].y) > s.y - 2 
                        and box[b].start==0 and player.start == 0 then
                    s.sp =52
                    box[b].start = time()
                end
                if not (flr(box[b].y) <= s.y and flr(box[b].y) > s.y - 2 
                        and box[b].x >= s.x - 6 and box[b].x < s.x + 6) 
                        and s.sp == 52 and player.start == 0 then
                    box[b].start = 0
                    s.sp = 51
                end
                if time() - box[b].start >= 0.5 and box[b].start != 0 and player.start == 0 then
                    box[b].dy -= (box[b].boost * 1.6)
                    box[b].start = 0
                    s.sp = 51
                end--if
            end--for
        end--else
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
        { x = 240, y = 104, dx = 0, dy = 0, w = 8, h = 8, sp = 4, g = 0.3, f = 0.8, acc = 0.5, mx_dy = 6, mx_dx = 3, boost = 4, start = 0 },
        { x = 128, y = 88, dx = 0, dy = 0, w = 8, h = 8, sp = 4, g = 0.3, f = 0.8, acc = 0.5, mx_dy = 6, mx_dx = 3, boost = 4, start = 0 }
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
            if collide_map(b, "up", 0) then
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
        if collide_map(b, "right", 0) and b.dx >= 0 then
            b.dx = 0
            if player.dx > 0 and player.x + 8 > b.x and player.x < b.x and player.y <= b.y and player.y >= b.y - 7 then
                player.dx = 0
                player.x = b.x - 8
            end
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
        --for
    end
    --function
end

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