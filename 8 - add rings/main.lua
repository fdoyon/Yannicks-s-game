require "game"
require "sonic"
require "level"


function love.load()  
  if arg[#arg] == "-debug" then require("mobdebug").start() end
 
  create_game("Gotta Go Fast!!!")
 
  
end


function love.update(dt)
  game.dt=dt
  update_game_screen(dt)
end
function update_game_screen(dt)
 if(game.over)
 then
   -- game over man!
   if(love.keyboard.isDown("y"))
   then
     game.over = false
     create_game(game.level_name)
   end
   
  return
 end
 
 
 time = love.timer.getTime( ) -- get the time
  
  update_level(dt,the_level,sonic.speed,true) -- the level moves as fast as sonic
  update_sonic(sonic,dt,time,the_level)

  -- update the background (it's just a bunch of levels)
  for b,background_layer in ipairs(background) do
    background_speed =sonic.speed  / ( b +3)  -- as b gets greater we want the speed to be smaller but not 0
    update_level(dt,background_layer,background_speed,false) -- do not create rings 
  end

  update_game(dt,sonic.speed)
 

end

super_gradient=255

function love.draw()
   -- if we are in the game
   draw_game_screen(game.dt)
   -- else
   -- draw_menu(dt)
end
function draw_game_screen(dt)
  -- draw back to front
  window_width,window_height = love.graphics.getDimensions()
  
  love.graphics.draw(planet,
    (window_width/2)-window_width * ((game.timer.max-game.timer.remain)/game.timer.max)
    ,0)
  
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

  love.graphics.print("From: Yannick & Uncle Florian 2017",o,window_height-20)

  -- score (top right)
  if(not game.is_super)
  then
    score_text=string.format("Time Remaining: %ds - Rings: %d - Score: %d",game.timer.remain,game.rings,game.score)
    love.graphics.printf(score_text,0,0,window_width,'right')
  else
      old_r,old_g,old_b,old_a = love.graphics.getColor()
      super_gradient=super_gradient + (dt*game.super_gradient_mult * 100)
      if(super_gradient > 255)
      then
        super_gradient = 255
        game.super_gradient_mult = -1
      end
      if(super_gradient<200)
      then
        game.super_gradient_mult=1
        super_gradient=200
      end
      
      
      love.graphics.setColor(super_gradient,super_gradient,0,255)
      score_text=string.format("Super! Time Remaining: %ds - Rings: %d - Score: %d",game.timer.remain,game.rings,game.score)
      love.graphics.printf(score_text,0,0,window_width,'right')
      love.graphics.setColor(old_r,old_g,old_b,old_a)
  end
  
  if(game.over)
  then
    game_over_text=string.format("Game over!\nYour score: %d\nRings: %d\nPress Y to start again.",game.score,game.rings)
    love.graphics.printf(game_over_text,0,window_height/3,800,'center')
  end


end

-- detect keyboard
function love.keypressed( key, scancode, isrepeat )
  if(isrepeat)
  then 
      return
  end
  sonic_keyboard(sonic,key)
end

