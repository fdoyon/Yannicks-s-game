require "animation"

function create_sonic()

  local sonic = {}
  sonic.animations={}
  sonic.speed=0
  sonic.max_speed=0
  sonic.left=100
  sonic.angle=0
  sonic.vertical_speed=0
  sonic.jump_start_at=0
  sonic.floor=0
  sonic.image = love.graphics.newImage("sonic2_transparent.png")
  sonic.is_walking=true
  create_animation  (42,40 ,8   ,62, 2,7,"walk",sonic,13,8,0)
  create_animation  (36,40 ,400 ,62, 4,3,"run",sonic,20,14,math.pi/6,"walk")
  create_animation  (36,40 ,8   ,15, 4,3,"stand",sonic,1,0,0)
  create_animation  (36,40 ,198 ,15, 4,5,"idle",sonic,1,0,0)
  create_animation  (36,30,8    ,340,4,4,"jump",sonic,8,0,0)
  
  
  for name,anim in pairs (sonic.animations) do
    load_animation(sonic.image,anim)
  end
  

  change_animation(sonic,"idle")
  
  return sonic

end


function draw_sonic(sonic, the_level, dt)
  screen_width, screen_height= love.graphics.getDimensions()  
  
  love.graphics.push()
  love.graphics.setColor(255,255,255,255)
--  love.graphics.draw(sonic.image,slice,sonic.left,sonic.floor,0,1,1,0,sonic.animation.sprite_height)
  
  love.graphics.draw(sonic.image,
    slice,
    sonic.right,
    sonic.floor,
    -sonic.angle,
    1,
    1,
    sonic.animation.sprite_width,
    sonic.animation.sprite_height)
 
 
--    love.graphics.print(string.format("max:%d - speed:%d - angle:%f - max:%f",sonic.animation.max_speed,sonic.speed,sonic.angle,sonic.animation.max_angle),0,0)
    
    love.graphics.pop()
end

function walk_sonic(sonic,the_level,dt,time)
    -- calculate sonic's speed
    sonic.speed= math.cos(sonic.angle)*sonic.animation.max_speed * game.speed_mult

    -- make sonic stick to the floor 
--    sonic.right=sonic.left+sonic.animation.sprite_width
--    sonic.floor,sonic.angle=level_get_height_at(the_level,sonic.right) 
    
end

function apply_gravity(sonic,the_level,dt,time)    
    sonic.vertical_speed = sonic.vertical_speed - (9.81 * dt)
    sonic.floor = sonic.floor  - sonic.vertical_speed
   
    -- is sonic going through the floor?
     floor,angle=level_get_height_at(the_level,sonic.right) 
     
    if(sonic.floor >= floor)
    then
      sonic.vertical_speed=(sonic.floor-floor)*dt
      sonic.floor=floor
      sonic.angle=angle
      if(sonic.is_walking == false)
      then
        sonic.vertical_speed=0
        sonic.is_walking=true
        change_animation(sonic,sonic.animation_before_jump)
      end
    end
     
     
end

function update_sonic(sonic,dt,time,the_level)
  -- is sonic above a ring
  check_sonic_on_ring(the_level,sonic,game)
  
  
  if(sonic.animation.max_angle > 0 and sonic.angle >sonic.animation.max_angle)
  then 
    change_animation(sonic,sonic.animation.fallback_to)
  end
  
  -- reset sonic's angle so he doesn't look like he's falling from a cliff backwards
  sonic.angle=0

  update_animation(sonic.animation,dt,time)
  
  apply_gravity(sonic,the_level,dt,time)
  if(sonic.is_walking)
  then  
    walk_sonic(sonic,the_level,dt,time)
  end

  -- update sonic's position so we can rotate his sprite if needed
  sonic.right=sonic.left+sonic.animation.sprite_width -- keep moving



end

function sonic_keyboard(sonic,key)

  if(key == "r" and sonic.is_walking and  sonic.angle < sonic.animations.run.max_angle)
  then
      change_animation(sonic,"run")
  end

  if(key == "w")
  then
    sonic.is_walking=true
    change_animation(sonic,"walk")
  end
  
  if(key =="s")
  then
    sonic.is_walking=true
    change_animation(sonic,"stand")
  end
  
  if(key == "i")
  then
    sonic.is_walking=true
    
    change_animation(sonic,"idle")
  end
  
  if(key == "j" and sonic.is_walking == true)
  then
    sonic.is_walking=false
    sonic.jump_start_at=time
    sonic.vertical_speed = 7
    sonic.animation_before_jump=sonic.animation.name
    change_animation(sonic,"jump")
  end  
end
  

function change_animation(sonic,to_anim)
  sonic.animation=sonic.animations[to_anim]
  sonic.animation.current_index=1 -- reset the frame counter
  sonic.animation.time_to_change=love.timer.getTime() + (1/sonic.animation.fps) -- also reschedule the animation timer
  sonic.max_speed=to_anim.max_speed
  sonic.right=sonic.left+sonic.animation.sprite_width
end
