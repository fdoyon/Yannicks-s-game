require "sonic"
require "level"


function love.load()  
  if arg[#arg] == "-debug" then require("mobdebug").start() end

  sonic=create_sonic()
  the_level = create_level(1200,500,200)

end


function love.update(dt)
  time = love.timer.getTime( ) -- get the time
  
  update_level(dt,the_level)
  update_sonic(sonic,dt,time,the_level)


end

function love.draw(dt)
  
  window_width,window_height = love.graphics.getDimensions()
  draw_level(dt,the_level)

-- draw sonic
  
  slice=sonic.animation.slices[sonic.animation.current_index]
  
  
  
  draw_sonic(sonic,the_level,dt)
  -- draw the level

end
