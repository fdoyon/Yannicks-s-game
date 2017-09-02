
sonic = {}
sonic.all_animations={}

function create_animation (w , h, x , y , s_x, steps,name)
  anim= {}
  anim.steps=steps
  anim.sprite_width=w
  anim.sprite_height=h
  anim.x_margin=x
  anim.y_margin=y
  anim.space_x=s_x
  anim.slices={}
  sonic.all_animations[name]=anim
  return anim
end

sonic.walk = create_animation(42,40 ,8   ,62, 2,7,"walk")
sonic.run= create_animation  (36,40 ,400 ,62, 4,3,"run")
sonic.stand= create_animation  (36,40 ,400 ,62, 4,3,"stand")


current_index = 1
frames_per_seconds = 10
change_frames_every = 1 / frames_per_seconds -- 0.2


function load_slice(image,position_in_line,animation)
  return love.graphics.newQuad(
   animation.x_margin + ((animation.sprite_width + animation.space_x)*(position_in_line-1)), -- left
   animation.y_margin, -- top
   animation.sprite_width, -- width
   animation.sprite_height, -- height
   image:getDimensions()) -- never changes 
end

function load_animation (animation)
  for i = 1,animation.steps
  do
    animation.slices[i]= load_slice(sonic.image,i,animation)
  end
end


function love.load()  
  sonic.image = love.graphics.newImage("sonic2.png")

  load_animation(sonic.walk)
  load_animation(sonic.run)
    
  sonic.animation=sonic.walk;
  time_to_change = love.timer.getTime() + change_frames_every
end


function love.update(dt)
  time = love.timer.getTime( ) -- get the time
  if(time >= time_to_change) 
  then
    current_index = current_index + 1
    if ( current_index > #sonic.animation.slices)
    then
      current_index = 1
    end
    
    time_to_change = time + change_frames_every
  end
  
  if(love.keyboard.isDown("r"))
  then
    sonic.animation=sonic.run
    current_index=1
  end
  
  if(love.keyboard.isDown("w"))
  then
    sonic.animation=sonic.walk
    current_index=1
  end
  
  
  
end

function love.draw()
  love.graphics.draw(sonic.image,sonic.animation.slices[current_index],0,20)
  love.graphics.print(current_index,0,0)
end
