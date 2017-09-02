require "level"
require "sonic"

-- use the level name as a random seed so the random numbers
-- we use to make the level are always the same for a given level
function make_level_random_from_name(name)
  -- we go through every character to try and make a number from the level name
  number = 13
  for i = 1, #name do
    local c = string.byte(name:sub(i,i))
    -- do something with c
    number = number  + c
  end
  
  love.math.setRandomSeed(number)
  
end
-- this is where we put all the game stuff
function create_game(level_name)

  make_level_random_from_name(level_name)

  planet= love.graphics.newImage("jupiter.jpg")

  sonic=create_sonic()
  the_level = create_level(1200,550,350,create_color(220,220,220,255),true) -- we want rings

  -- to give an impression of speed we will draw another level in the back but moving slowly
  background = {}
  -- we create an array of levels where the level 1 is the closest
  background[1]=create_level(1200,525,350,create_color(180,180,180,255),false) -- no rings!
  background[2]=create_level(1200,535,250,create_color(130,130,130,255),false)
 
  game = {}
  game.level_name=level_name
  game.timer={}
  game.over=false
  game.timer.max=60 -- 60 seconds
  game.timer.remain=game.timer.max
  game.score=0
  game.rings=0
  game.super_gradient_mult=-1
  game.super_speed_rings=100
  game.super_speed_mult=1.5
  game.speed_mult=1
  game.is_super = false
  return game
end

function update_game(dt,scrolled_by)
  game.score = game.score + scrolled_by -- update the score 
  
  game.timer.remain = game.timer.remain - dt -- decrement timer
  
  if(game.timer.remain <= 0)
  then
    game.timer.remain=0
    game.over=true
  end

end
