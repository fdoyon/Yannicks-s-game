require "sonic"
require "level"


function love.load()  
  if arg[#arg] == "-debug" then require("mobdebug").start() end

  planet= love.graphics.newImage("jupiter.jpg")

  sonic=create_sonic()
  the_level = create_level(1200,500,350,create_color(220,220,220,255))

  -- to give an impression of speed we will draw another level in the back but moving slowly
  background = {}
  -- we create an array of levels where the level 1 is the closest
  background[1]=create_level(1200,525,300,create_color(180,180,180,255))
  background[2]=create_level(1200,350,250,create_color(130,130,130,255))
  -- we ne
  
end


function love.update(dt)
  time = love.timer.getTime( ) -- get the time
  
  update_level(dt,the_level,sonic.speed) -- the level moves as fast as sonic
  update_sonic(sonic,dt,time,the_level)

  -- update the background (it's just a bunch of levels)
  for b,background_layer in ipairs(background) do
    background_speed =sonic.speed  / ( b +3)  -- as b gets greater we want the speed to be smaller but not 0
    update_level(dt,background_layer,background_speed) 
  end

end

function love.draw(dt)
  -- draw back to front
  window_width,window_height = love.graphics.getDimensions()
  
  love.graphics.draw(planet,0,0)
  
  -- draw the background, but back to front again!
  -- how do we do that?  we start our loop with the last one
  -- and stop at the first one!
  b=#background
  while (b >0 )
  do
    background_layer=background[b] 
    draw_level(dt,background_layer) 
    b = b -1 -- previous one please!
  end 
  
  draw_level(dt,the_level)

-- draw sonic  
  slice=sonic.animation.slices[sonic.animation.current_index]
  
  draw_sonic(sonic,the_level,dt)


end
