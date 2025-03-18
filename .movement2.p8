pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

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

-->8
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
    dis = dist(c.x_center, pos.x1, c.y_center, pos.y1)
    change_angle(c.angle_in_deg)
    c.angle_in_deg += c.da
    if c.angle_in_deg > 360 then
        c.angle_in_deg -= 360
    elseif c.angle_in_deg < 0 then
        c.angle_in_deg += 360
    end
    c.x = pos.x1
    c.y = pos.y1
end

function draw_circle()
    line(c.x_center, c.y_center, c.x, c.y, 9)
end