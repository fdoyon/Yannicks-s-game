
sonic = {}
sonic.animations={}

function create_hill(start_y,end_y,length)
    hill = {} -- a hill is an object
    hill.start_y = start_y
    hill.end_y = end_y
    hill.length = length
    return hill
end


function create_level(total_width,max_height,min_height)
    level = {}
    level.hills={}
    
    remaining_width_to_fill = total_width
           
    hill_start = love.math.random(min_height,max_height)
      -- create as many hills as we need to fill the level width
    while remaining_width_to_fill > 0 do
        hill_length= love.math.random(50,300)
        hill_end = love.math.random(min_height,max_height)
        the_hill=create_hill(hill_start,hill_end,hill_length)
        level.hills[#level.hills+1] = the_hill-- # means the position of the last thing in our bag / table
        remaining_width_to_fill = remaining_width_to_fill - the_hill.length -- we consumed length pixels of the level length
        hill_start=hill_end
    end
    
    
    return level
  end


-- an animation is an object with several properties
function create_animation (w , h, x , y , s_x, steps,name,into,fps)
  anim= {} -- create an object
  anim.steps=steps -- how many steps?
  anim.sprite_width=w -- size of each frame
  anim.sprite_height=h -- height of each frame
  anim.x_margin=x -- x start position of the animation im our sprite sheet
  anim.y_margin=y -- y start position ""   ""   ""
  anim.space_x=s_x -- x spa
  anim.slices={} -- slices array
  anim.fps=fps -- frames per second
  anim.name=name -- name
  into[name]=anim -- load it into something
end

current_index = 1


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
  if arg[#arg] == "-debug" then require("mobdebug").start() end

  sonic.image = love.graphics.newImage("sonic2.png")

  create_animation  (42,40 ,8   ,62, 2,7,"walk",sonic.animations,13)
  create_animation  (36,40 ,400 ,62, 4,3,"run",sonic.animations,20)
  create_animation  (36,40 ,8   ,15, 4,3,"stand",sonic.animations,1)
  create_animation  (36,40 ,198 ,15, 4,5,"idle",sonic.animations,1)
  
  for name,anim in pairs (sonic.animations) do
    load_animation(anim)
  end
  
  change_animation(sonic.animations.idle)

  -- load the level
  the_level = create_level(1200,500,100)

end

function change_animation(to_anim)
  sonic.animation=to_anim
  current_index=1 -- reset the frame counter
  time_to_change=love.timer.getTime() + (1/to_anim.fps) -- also reschedule the animation timer
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
    
    time_to_change = time + (1/sonic.animation.fps)
  end
  
  if(love.keyboard.isDown("r"))
  then
    change_animation(sonic.animations.run)
  end
  
  if(love.keyboard.isDown("w"))
  then
    change_animation(sonic.animations.walk)
  end
  if(love.keyboard.isDown("s"))
  then
    change_animation(sonic.animations.stand)
  end
  if(love.keyboard.isDown("i"))
  then
    change_animation(sonic.animations.idle)
  end
  
  
  
end

function love.draw()
  
  window_width,window_height = love.graphics.getDimensions()
  
  slice=sonic.animation.slices[current_index]
  
  love.graphics.draw(sonic.image,slice,100,300)
  
  
  hill_x=0
  for i,hill in ipairs( the_level.hills) do
  
  love.graphics.line(hill_x,hill.start_y,hill_x+hill.length ,hill.end_y)
  hill_x = hill_x + hill.length
    
  end
  
end
