require "game"
require "sonic"
require "level"


function love.load()  
  if arg[#arg] == "-debug" then require("mobdebug").start() end
 
  create_game("Yannick rocks!")
 
  
end


function love.update(dt)
  update_game_screen(dt)
end
function update_game_screen(dt)
 if(game.over)
 then
   -- game over man!
  return
 end
 
 
 time = love.timer.getTime( ) -- get the time
  
  update_level(dt,the_level,sonic.speed) -- the level moves as fast as sonic
  update_sonic(sonic,dt,time,the_level)

  -- update the background (it's just a bunch of levels)
  for b,background_layer in ipairs(background) do
    background_speed =sonic.speed  / ( b +3)  -- as b gets greater we want the speed to be smaller but not 0
    update_level(dt,background_layer,background_speed) 
  end

  update_game(dt,sonic.speed)
 

end

function love.draw(dt)
   -- if we are in the game
   draw_game_screen(dt)
   -- else
   -- draw_menu(dt)
end
function draw_game_screen(dt)
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

   -- score (top right)
   score_text=string.format("Remaining: %d - Score: %d",game.timer.remain,game.score)
   love.graphics.printf(score_text,0,0,window_width,'right')
  
  if(game.over)
  then
    game_over_text=string.format("Game over!\nYour score: %d",game.score)
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

