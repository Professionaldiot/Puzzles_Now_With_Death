pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--[[
0 is the box and spring functions
1 is the spring functinos
2 is the circle functions
3 is the portal functions
4 is the bridge functions
5 is the platform functions
]]

function box_init()
    --[[
    Intialzes the boxes for .level2.p8

    Variables: NIL

    returns NIL
    ]]
    box = {
        { x = 220, y = 72, dx = 0, dy = 0, w = 8, h = 8, sp = 4, g = 0.3, f = 0.8, acc = 0.5, mx_dy = 6, mx_dx = 3, boost = 4, start = 0 },
        { x = 240, y = 104, dx = 0, dy = 0, w = 8, h = 8, sp = 4, g = 0.3, f = 0.8, acc = 0.5, mx_dy = 6, mx_dx = 3, boost = 4, start = 0},
        { x = 128, y = 88, dx = 0, dy = 0, w = 8, h = 8, sp = 4, g = 0.3, f = 0.8, acc = 0.5, mx_dy = 6, mx_dx = 3, boost = 4, start = 0 },
        { x = 168, y = 88, dx = 0, dy = 0, w = 8, h = 8, sp = 4, g = 0.3, f = 0.8, acc = 0.5, mx_dy = 6, mx_dx = 3, boost = 4, start = 0 }
    }
end

function box_update(box_list, btn_list)
    --[[
    Updates the box based on whether the player is "pushing it" or not

    Variables: NIL

    returns NIL
    ]]
    --todo for 1.0
    --get boxes landing on top of each other
    --get boxes pushing each other
    --get boxes working with trapdoors, maybe stairs? i don't think it's needed though
    --def get boxes working with springs
    if box_list == nil then
        box_list = box
    end
    if btn_list == nil then
        btn_list = butts
    end
    for b in all(box_list) do
        if btn_list != nil then
            btn_update(btn_list, b)
        end
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
        --this checks if the player is standing on top of the box_list or not
        if player.dy > 0 and b.dy == 0 then
            if player.y < b.y - 4 and player.y >= b.y - 8 and player.x >= b.x - 6 and player.x <= b.x + 6 then
                player.falling = false
                player.landed = true
                player.y = b.y - 8
                player.dy = 0
            end
            --[[
            first we check if the player is attempting to enter the box_list, if the player is inside of the box_list we "push" the box_list by
            making it accelerate in the direction the player is going then we check collision and in those checks we stop the
            player moving into the box_list if necessary
            ]]
        elseif ((player.x >= b.x and player.x < b.x + 8) or (player.x >= b.x - 8 and player.x < b.x)) and (player.y <= b.y and player.y > b.y - 8) then
            if player.dx < 0 or player.x >= b.x + 8 then
                b.dx -= b.acc
            elseif player.dx > 0 or player.x + 8 <= b.x then
                b.dx += b.acc
            end
        end
        if collide_map(b, "right", 0) and collide_map(b, "right", 2) and b.dx >= 0 then
            b.dx = b.dx * 1.25
        elseif collide_map(b, "right", 0) and b.dx >= 0 then
            b.dx = 0
            if player.dx > 0 and player.x + 8 > b.x and player.x < b.x and player.y <= b.y and player.y >= b.y - 7 then
                player.dx = 0
                player.x = b.x - 8
            end
        elseif collide_map(b, "left", 0) and collide_map(b, "left", 2) and b.dx <= 0 then
            b.dx = b.dx * 1.25
        elseif collide_map(b, "left", 0) and b.dx <= 0 then
            b.dx = 0
            if player.dx < 0 and player.x < b.x + 8 and player.x > b.x and player.y <= b.y and player.y >= b.y - 7 then
                player.dx = 0
                player.x = b.x + 8
            end
        end

        b.dx = mid(-b.mx_dx * 2, b.dx, b.mx_dx * 2)
        b.dy = mid(-b.mx_dy, b.dy, b.mx_dy)

        b.x += b.dx
        b.y += b.dy
        for h in all(box_list) do
            --this checks for collision on all other box_listes
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
                    end--elseif the box_listes are the same height
                end--if box_list in other box_list
            end--if the box_list isn't the same as the box_list were on (to stop some bugs from happening that would occur from checking the box_list over again)
        end--for
    end--for
end--function

function box_draw(box_list)
    --[[
    Draws the box to the screen

    Variables: NIL

    returns NIL
    ]]
    if box_list == nil then
        box_list = box
    end
    for b in all(box_list) do
        spr(b.sp, b.x, b.y)
    end
end
-->8
--spring functions
function spring_init()
    --[[
    Intializes the spring for .level2.p8

    Variables: NIL

    returns NIL
    ]]
    spring_locs = { 
        { x = 104, y = 104, sp = 51, start = 51, down_sp = 52},
        { x = 368, y = 160, sp = 51, start = 51, down_sp = 52},
        { x = 288, y = 160, sp = 51, start = 51, down_sp = 52},
        { x = 22*8, y = 48, sp = 51, start = 51, down_sp = 52}
    }
end

function spring_update(box_to_check, spring_list, box_list)
    --[[
    Computes whether or not the player (or a box that's decided based on level) 
    should be sprung up or not and given immunity to fall damage

    Variables: 
    box_to_check: table --> the box to check whether the spring should launch that box or not

    returns NIL
    ]]
    b = box_to_check
    if box_list == nil then
        box_list = box
    end
    if spring_list == nil then
        spring_list = spring_locs
    end
    for s in all(spring_list) do
        if box_list[b].x >= s.x - 6 and box_list[b].x < s.x + 6 and box_list[b].start == 0 
                and flr(box_list[b].y) <= s.y and flr(box_list[b].y) > s.y - 2 
                and box_list[b].start==0 and player.start==0 then
            s.sp = s.down_sp
            box_list[b].start = time()
        elseif not (flr(box_list[b].y) <= s.y and flr(box_list[b].y) > s.y - 2 
                and box_list[b].x >= s.x - 6 and box_list[b].x < s.x + 6) 
                and s.sp == s.down and player.start==0 then
            box_list[b].start = 0
            s.sp = s.start
        elseif time() - box_list[b].start >= 0.5 and box_list[b].start != 0 and player.start==0 then
            box_list[b].dy -= (box_list[b].boost * 1.6)
            box_list[b].start = 0
            s.sp = s.start_sp
        end--if
        
        if player.x >= s.x - 6 and player.x < s.x + 6 and player.start == 0 
                and flr(player.y) <= s.y and flr(player.y) > s.y - 2 
                and player.start==0 and box_list[b].start==0 then
            s.sp = s.down_sp
            player.start = time()
        elseif not (flr(player.y) <= s.y and flr(player.y) > s.y - 2 
                and player.x >= s.x - 6 and player.x < s.x + 6) 
                and s.sp == s.down_sp and box_list[b].start==0 then
            player.start = 0
            s.sp = s.start
        elseif time() - player.start >= 0.5 and player.start != 0 and box_list[b].start == 0 then
            player.dy -= (player.boost * 1.6)
            player.landed = false
            player.spring = true
            player.start = 0
            s.sp = s.start
        end
    end
end

function spring_draw(spring_list)
    --[[
    Draws the spring to the screen

    Variables: NIL

    returns NIL
    ]]
    if spring_list == nil then
        spring_list = spring_locs
    end
    for s in all(spring_list) do
        spr(s.sp, s.x, s.y)
    end
end

-->8
--circle functions
function circle_init()
    --[[
    Intializes the circle for .boss-room.p8
    Variables: NIL

    returns NIL
    ]]
    c = {
        x = 0,
        y = 0,
        angle_in_deg = 270,
        x_center = 147,
        y_center = 64,
        radius = 50,
        da = 0,
        a_res = 0.6,
        acc = 0.5,
        grav = .1,
        values = {},
        time_since_hit = 0
    }
end

function update_circle_x(angle_in_deg)
    --[[
    Takes in an angle and returns a table of values that represents where the circle should be next

    Variables:
    angle_in_deg: int (0-360) --> the angle to calcute the next circle point to be on

    returns TABLE: a table of values containing an x and y coordinate and the angle it's at
    ]]
    p_angle = angle_in_deg/360
    x = c.x_center + c.radius * sin(p_angle)
    y = c.y_center + c.radius * cos(p_angle)
    h_angle = 360 - (180 - angle_in_deg)
    add(c.values, {x1 = x, y1 = y, hangle = h_angle, angle = angle_in_deg})
    return {x1 = x, y1 = y, hangle = h_angle, angle = angle_in_deg}
end

function change_angle(angle)
    --[[
    Takes the angle the circle is at, and changes the circles movement speed based on it's speed and angle

    Variables:
    angle: int (0-360) --> the angle the circle is currently at

    returns NIL
    ]]

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
    --[[
    Computes the euclidean distance of two points in space

    Variables:
    * x1: int --> first x point
    * x2: int --> second x point
    * y1: int --> first y point
    * y2: int --> second y point

    returns INT: a number rounded to the closest digit
    ]]
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
    --[[
    Makes the circle, doesn't need anything put into it

    Variables: NIL

    returns NIL
    ]]
    local in_box_x = player.x > c.x_center - 6 and player.x < c.x + 6
    local in_box_y = player.y > c.y_center and player.y < c.y
    pos = update_circle_x(c.angle_in_deg)
    dis = dist(c.x_center, pos.x1, c.y_center, pos.y1)
    if in_box_x and in_box_y and c.time_since_hit != 0 and time() - c.time_since_hit > 5 then
        player.health -= 3
        c.time_since_hit = time()
    elseif in_box_x and in_box_y and c.time_since_hit == 0 then
        player.health -= 3
        c.time_since_hit = time()
    elseif not (in_box_x and in_box_y) then
        c.time_since_hit = 0
    end
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
    --[[
    Draws the circle to the screen
    
    Variables: NIL

    returns NIL
    ]]
    line(c.x_center-6, c.y_center, c.x+6, c.y_center)
    line(c.x_center-6, c.y_center, c.x_center-6, c.y)
    line(c.x+6, c.y_center, c.x+6, c.y)
    line(c.x_center-6, c.y, c.x+6, c.y)


    line(c.x_center, c.y_center, c.x, c.y, 9)
end

-->8
--portal functions
function portal_update(portal_list, box_list)
    --[[
    Takes a list of portals on a level and does the computations to update them correctly

    Variables:
    * portal_list: list[table] --> the list of portals on the level, must have x, y, link, sp, g_sp, orig_sp and cooldown, cooldown_start, flp_x, flp_y, shoot_x
    * box_list: list[table] --> a list of the boxes on the level to check, if there are none to check, can be left as {}, but it cannot be nil
        * default: {}

    returns NIL
    ]]
    if box_list == nil then
        box_list = {}
    end
    local boost_x = 0
    local boost_y = 0
    for p in all(portal_list) do
        --if the portal is on cooldown draw the grayed out version sprite of it
        if ((player.y == p.y) or (player.y > p.y and player.y < p.y+8)) and p.cooldown == 0 then
            p.sp = p.orig_sp
            portal_list[p.link].sp = portal_list[p.link].orig_sp
            --if the player is on the same y level and the portal is off cooldown
            if (player.x > p.x and player.x < p.x + 8) or (player.x + player.w > p.x and player.x + player.w < p.x + 8) then
                    p.cooldown = p.cooldown_start --start the cooldown period
                    portal_list[p.link].cooldown = p.cooldown_start
                    if portal_list[p.link].shoot_x != 0 then
                        boost_x = 7 * sgn(portal_list[p.link].shoot_x)
                        
                    else
                        boost_y = -4.5
                        
                    end
                    player.x = portal_list[p.link].x
                    player.y = portal_list[p.link].y
                    if boost_x > 0 then
                        player.max_dx = boost_x
                    
                    end
                    player.dx = boost_x
                    player.dy = boost_y
                    player.landed = false
                    while player.x - cam_x > 60 do
                        cam_x += 10
                    end
                    while player.x - cam_x < 60 do
                        cam_x -= 10
                    end
                    while player.y - cam_y > 80 do
                        cam_y += 10
                    end
                    while player.y - cam_y < 80 do
                        cam_y -= 10
                    end
            end
        elseif p.cooldown == 30 and p.sfx == 0 then 
            sfx(62, 3)
            p.sfx = time()
        elseif p.cooldown >= 0 and p.cooldown < 30 and p.sfx != 0 then
            p.sfx = 0
        elseif p.cooldown > 0 then
            p.sp = p.g_sp
            portal_list[p.link].sp = portal_list[p.link].g_sp
            p.cooldown -= 1
        elseif p.cooldown <= 15 then
            player.max_dx = 2
        end
        if box_list != nil then
            for b in all(box_list) do
                if b.y == p.y and p.cooldown == 0 then
                    p.sp = p.orig_sp
                    portal_list[p.link].sp = portal_list[p.link].orig_sp
                    if (b.x > p.x and b.x < p.x + 8) or
                        (b.x + b.w > p.x and b.x + b.w < p.x + 8) then
                            p.cooldown = p.cooldown_start --start the cooldown period
                            portal_list[p.link].cooldown = p.cooldown_start
                            b.x = portal_list[p.link].x + b.w + 8
                            b.y = portal_list[p.link].y
                    end--if
                end--if
            end--for
        end--if
    end--for
end

function portal_draw(portal_list)
    --[[
    Draws the portals to the level from the portal list speficied

    Variables:
    * portal_list: list[table] --> the list of portals on the level, must have x, y, index_link, sp, g_sp, orig_sp and cooldown, cooldown_start, flp_x, flp_y

    returns NIL
    ]]
    for p in all(portal_list) do
        spr(p.sp, p.x, p.y, 1, 1, p.flp_x, p.flp_y)
    end
end

-->8
--bridge functions
function bridge_update(is_combo, current_combo, correct_combo, max_length, btn_list, btn_index_start, btn_index_end, btn_index)
    --[[
    Updates the brige based on whether a specific button is pressed, or whether a specific combination of buttons is pressed

    Variables:
    * is_combo: bool --> whether the function should use a combo or not
    * current_combo: list[int] --> the current combo of the player
    * correct_combo: list[int] --> the correct combo of buttons
    * max_length: int --> the max length of the combo
    * btn_list: list[table] --> a list of the buttons on the level, needs to have x, y, and sfx
    * btn_index_start: int --> the start of the index where the combo is
    * btn_index_end: int --> the end of the index where the combo is
    * btn_index: int --> the index of the button to check whether it is pressed or not, only used in non-combo button lists

    returns NIL
    ]]
    local max = 0
    if is_combo and not stop_bridge then
        --checks whether the plyaer combo should be reset and whether the combo is the correct length or not
        load_bridge = not combo_lock_update(current_combo, btn_list, correct_combo, max_length, 0, 0, 8, 8) and #current_combo == max_length
    elseif not stop_bridge then
        load_bridge = btn_list[btn_index].sfx > 0
    end
    if load_bridge and not stop_bridge then
        if dget(63) == -1 then
            if bridge_list[1].x > bridge_list[1].x_end then
                dset(63, bridge_list[1].x - (bridge_list[1].x_end-8))
                a = dget(63)
            else
                dset(63, (bridge_list[1].x_end+8) - bridge_list[1].x)
                a = dget(63)
            end
        end
        dset(63, dget(63) -1)--subtract one from the timer
        x = bridge_list[1].x + ((sgn(bridge_list[1].x_end - bridge_list[1].x)) * (dget(63) - max))-- x - sgn(end - x) * -(max - iterator   )
        if x%8 == 0 then
            add(bridge_list, {x = x, y = bridge_list[1].y, sp = bridge_list[1].sp})
        end
    end
    if dget(63) == 0 then
        load_bridge = false
        stop_bridge = true
    end
    for b in all(bridge_list) do
        if player.y >= b.y - 8 and player.y < b.y then
            if (player.x > b.x and player.x < b.x + 8) or 
                    (player.x + player.w > b.x and player.x + player.w < b.x + 8) then
                player.dy = 0
                player.y = b.y - 8
                player.landed = true
                player.falling = false
                player.trapdoor = true
            end--if
        end
    end--for
end

function bridge_draw()
    for b in all(bridge_list) do
        spr(b.sp, b.x, b.y)
    end
end

-->8
--platform functions
function platform_init(vertex_list)
    local v = vertex_list
    p = {
        sp = v[1].sp,
        x = v[2].x,
        dx = 0,
        y = v[2].y,
        prev_vertex = 1,
        next_vertex = 2
    }
end

function platform_update(vertex_list)
    --[[
    Updates the platform bsaed on the series of vertexes given

    Variables:
    * vertex_list: list[table] --> a list of the coordinates to the vertices of where the platform should go
        * list of {x = x, y = y} tuple pairs
        * list[1] is designated for holding the sprite information
        
    returns NIL
    ]]
    local v = vertex_list
    if p.next_vertex > #v then
        --set the prev_vertex to the next_vertex to stop the logic below from happening, since 
        p.next_vertex -= 1
        p.prev_vertex = p.next_vertex
        p.dx = player.dx

    elseif p.x == v[p.next_vertex].x and p.y == v[p.next_vertex].y and p.next_vertex <= #v then
        --increase the tracked vertex by one
        p.next_vertex += 1
        p.prev_vertex += 1
    end
    if p.next_vertex <= #v then
        --do the logic for moving the x direction
        if p.x >= v[p.prev_vertex].x and p.x < v[p.next_vertex].x then
            p.x += 1
            p.dx = 1 * player.dx
        elseif p.x <= v[p.prev_vertex].x and p.x > v[p.next_vertex].x then
            p.x -= 1
            p.dx = 1 * player.dx
        end
        if p.y >= v[p.prev_vertex].y and p.y < v[p.next_vertex].y then 
            p.y += 1
            if not player.dead then
                player.y += 1
            end
            p.dx = player.dx
        elseif p.y <= v[p.prev_vertex].y and p.y > v[p.next_vertex].y then
            p.y -= 1
            p.dx = player.dx
        end
    end
    if not player.dead then
        if player.y >= p.y - 8 and player.y < p.y - 4 then
            if (player.x > p.x - 4 and player.x < p.x + 19) or (player.x + player.w > p.x and player.x + player.w < p.x + 19) then
                player.max_dx = 1.25
                player.dx = p.dx
                player.dy = 0
                player.y = p.y - 8
                player.landed = true
                player.falling = false
                player.trapdoor = true
            end
        else
            player.max_dx = 2
        end
    end
end

function platform_draw()
    spr(p.sp-1, p.x-8, p.y)
    spr(p.sp, p.x, p.y)
    spr(p.sp+1, p.x+8, p.y)
    spr(p.sp+2, p.x+16, p.y)
end