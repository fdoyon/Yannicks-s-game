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
  create_animation  (42,40 ,8   ,62, 2,7,"walk",sonic,13,6,0)
  create_animation  (36,40 ,400 ,62, 4,3,"run",sonic,20,12,math.pi/6,"walk")
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
  
    love.graphics.print(string.format("max:%d - speed:%d - angle:%f - max:%f",sonic.animation.max_speed,sonic.speed,sonic.angle,
        sonic.animation.max_angle
        ),0,0)
end

function walk_sonic(sonic,the_level,dt,time)
    -- calculate sonic's speed
    sonic.speed= math.cos(sonic.angle)*sonic.animation.max_speed 

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
       sonic.floor=floor
       sonic.angle=angle
       sonic.vertical_speed=0
       if(sonic.is_walking == false)
       then
        sonic.is_walking=true
        change_animation(sonic,sonic.animation_before_jump)
      end
     end
     
     
end


function update_sonic(self,dt,time,the_level)
  if(sonic.animation.max_angle > 0 and sonic.angle >sonic.animation.max_angle)
  then 
    change_animation(sonic,sonic.animation.fallback_to)
  end

  update_animation(self.animation,dt,time)
  
  apply_gravity(sonic,the_level,dt,time)
  if(sonic.is_walking)
  then  
    walk_sonic(sonic,the_level,dt,time)
  end

  -- update sonic's position so we can rotate his sprite if needed
  sonic.right=sonic.left+sonic.animation.sprite_width -- keep moving

  if(love.keyboard.isDown("r") and  sonic.angle < sonic.animations.run.max_angle)
  then
      change_animation(self,"run")
  end

    if(love.keyboard.isDown("w"))
  then
    sonic.is_walking=true
    change_animation(self,"walk")
  end
  if(love.keyboard.isDown("s"))
  then
    sonic.is_walking=true
    change_animation(self,"stand")
  end
  if(love.keyboard.isDown("i"))
  then
    sonic.is_walking=true
    
    change_animation(self,"idle")
  end
  
  if(love.keyboard.isDown("j") and sonic.is_walking == true)
  then
    sonic.is_walking=false
    sonic.jump_start_at=time
    sonic.vertical_speed = 7
    sonic.animation_before_jump=sonic.animation.name
    change_animation(self,"jump")
  end

end

function change_animation(sonic,to_anim)
  sonic.animation=sonic.animations[to_anim]
  sonic.animation.current_index=1 -- reset the frame counter
  sonic.animation.time_to_change=love.timer.getTime() + (1/sonic.animation.fps) -- also reschedule the animation timer
  sonic.max_speed=to_anim.max_speed
  sonic.right=sonic.left+sonic.animation.sprite_width
end
