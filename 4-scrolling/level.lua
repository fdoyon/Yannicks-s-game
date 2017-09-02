require "animation"

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
    level.min_height=min_height
    level.max_height=max_height
    level.scroll=0
    remaining_width_to_fill = total_width
           
    hill_start = love.math.random(min_height,max_height)
      -- create as many hills as we need to fill the level width
    while remaining_width_to_fill > 0 do
        hill_length= love.math.random(50,300)
        hill_end = love.math.random(min_height,max_height)
        the_hill=create_hill(hill_start,hill_end,hill_length) -- build a hill
        level.hills[#level.hills+1] = the_hill-- # means the position of the last thing in our bag / table
        remaining_width_to_fill = remaining_width_to_fill - the_hill.length -- we consumed length pixels of the level length
        hill_start=hill_end
    end
    
    
    return level
  end

--- LEVEL STUFF
function update_level(dt,the_level)
-- scroll the level
  the_level.scroll = the_level.scroll+5
  
  -- detect if we are running out of level
  screen_width,screen_height=love.graphics.getDimensions()
  
    -- cleanup after ourselves when a hill goest out of the screen
    
  if(the_level.scroll > the_level.hills[1].length )
  then
      hill_to_remove = the_level.hills[1]
      table.remove(the_level.hills,1) -- remove it
      the_level.scroll=the_level.scroll - hill_to_remove.length
  end
  
  hill_width_needed = screen_width + the_level.scroll -- we need to print 1 screen plus what we already have scrolled on the left of the level

  prev_hill={}
  for i,hill in ipairs(the_level.hills) do -- for each hill in our level
    hill_width_needed = hill_width_needed - hill.length
    prev_hill=hill
  end
  
   while( hill_width_needed > 0 )
   do
     -- we need to create more hills!
      hill_length= love.math.random(50,300)
      hill_end = love.math.random( the_level.min_height, the_level.max_height)
      new_hill=create_hill(prev_hill.end_y,hill_end,hill_length)
      
      -- keep track of the hill length we stitched to the end
      hill_width_needed = hill_width_needed - hill_length
      -- stitch the hill to the end of the level
      the_level.hills[#the_level.hills+1]= new_hill
   end
   
  
end


function draw_level(dt,the_level)
  screen_width,screen_height = love.graphics.getDimensions()
  
  hill_x=-the_level.scroll -- start from the left of the screen
  for i,hill in ipairs( the_level.hills) do -- for each pair (hill_index, and hill)
    love.graphics.line(hill_x,hill.start_y,hill_x+hill.length ,hill.end_y) -- draw the line for the hill
    
    -- draw the separation between hills

    love.graphics.polygon('fill',
      hill_x, screen_height,-- bottom left
      hill_x, hill.start_y, -- top left
      hill.length + hill_x,hill.end_y, -- top right
      hill.length + hill_x ,screen_height -- bottom right
      )
      
    hill_x = hill_x + hill.length     -- advance our drawing position by the length of the hill

  end
end

function level_get_height_at(the_level,x)
  screen_width,screen_height = love.graphics.getDimensions()
  
  --  advance until we find the 100th pixel of the screen
  -- and find-out how much of the hill we consumed
  consumed_x=-the_level.scroll -- 
  
  for i,hill in ipairs( the_level.hills) do -- for each pair (hill_index, and hill)
      consumed_x = consumed_x + hill.length
      if(consumed_x >= x)
      then
        -- this is our hill
        -- drow vertical line at the end of the hill
        end_of_hill_as_screen=consumed_x
        love.graphics.line(end_of_hill_as_screen,0,end_of_hill_as_screen,screen_height)
        
        
        begining_of_hill_as_screen=consumed_x-hill.length
        hill_consumed =x - begining_of_hill_as_screen;

        
        -- draw where we think this is
        r,g,b,a=love.graphics.getColor() -- save the pen
        love.graphics.setColor(0,255,0,255)       -- user our own pen      
        love.graphics.line(begining_of_hill_as_screen,hill.start_y,begining_of_hill_as_screen+hill_consumed,hill.start_y)
        love.graphics.setColor(r,g,b,a) -- reload the pen
        
        adjacent = hill.length
        opposite = math.abs(hill.start_y - hill.end_y)
        tan_phi =  opposite / adjacent
        
        consumed_y = tan_phi * hill_consumed 
        
        -- draw where we think this is
        r,g,b,a=love.graphics.getColor() -- save the pen
        love.graphics.setColor(0,0,255,255)       -- user our own pen      
        love.graphics.line(
          begining_of_hill_as_screen + hill_consumed,
          hill.start_y,
          begining_of_hill_as_screen + hill_consumed,
          hill.start_y + consumed_y)
        love.graphics.setColor(r,g,b,a) -- reload the pen
        
        if(hill.start_y > hill.end_y)
        then
           -- going up
           return hill.start_y - consumed_y
        else
          -- going down
          return hill.start_y + consumed_y
        end
      
      end
      

  end
end
