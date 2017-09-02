require "animation"

function create_hill(start_y,end_y,length,with_rings)
    local hill = {} -- a hill is an object
    hill.start_y = start_y
    hill.end_y = end_y
    hill.length = length
    hill.angle = math.atan2(start_y-end_y,length)
    hill.tan_phi = (start_y - end_y) / length


    hill.rings = {}
    hill.rings.enabled=with_rings -- background has no rings :)
    if (with_rings 
      and love.math.random(1,3) ==1 -- 1 hill out of 3 has rings on average
      )
    then 
      hill.rings.count=love.math.random(3,9)
    
      hill.rings.start_x = love.math.random(0,length*.75)
      hill.rings.start_height = 5 + love.math.random(5,40) -- numbers of pixels the line starts ABOVE the ground
      hill.rings.angle= math.max(((math.pi * love.math.random()) - (math.pi/2)),hill.angle)
      hill.rings.tan_angle= math.tan(hill.rings.angle)
      hill.rings.the_rings={}
      -- now we need to create the rings we just rolled at random
      for i = 1,hill.rings.count do
        ring={}
        ring.collected=false
        ring.height=20
        ring.width=20
        ring.left=hill.rings.start_x + ((i-1)*20) -- rings are 20 apart
      
        ring.bottom = hill.start_y - hill.rings.start_height - (ring.left * hill.rings.tan_angle)
        ring.center_y = ring.bottom - 10
        
        hill.rings.the_rings[i]=ring
      end
    else
      hill.rings.count=0
    end
    
    hill.rings.length = 20 * hill.rings.count
    return hill
end

function create_color(red,green,blue,transparent)
  color={}
  color.red=red
  color.green=green
  color.blue=blue
  return color
end

function create_level(total_width,max_height,min_height,color,with_rings)
    local level = {}
    level.hills={}
    level.min_height=min_height
    level.max_height=max_height
    level.scroll=0
    level.color=color
    remaining_width_to_fill = total_width
           
    hill_start = love.math.random(min_height,max_height)
      -- create as many hills as we need to fill the level width
    while remaining_width_to_fill > 0 do
        hill_length= love.math.random(30,300)
        hill_end = love.math.random(min_height,max_height)
        the_hill=create_hill(hill_start,hill_end,hill_length,with_rings) -- build a hill
        level.hills[#level.hills+1] = the_hill-- # means the position of the last thing in our bag / table
        remaining_width_to_fill = remaining_width_to_fill - the_hill.length -- we consumed length pixels of the level length
        hill_start=hill_end
    end
    
    
    return level
  end

--- LEVEL STUFF
function update_level(dt,the_level,scroll_by,is_main_level)
-- scroll the level
  the_level.scroll = the_level.scroll+scroll_by

  -- detect if we are running out of level
  screen_width,screen_height=love.graphics.getDimensions()
  
    -- cleanup after ourselves when a hill goest out of the screen
    
  if(the_level.scroll > the_level.hills[1].length + the_level.hills[2].length + the_level.hills[3].length )
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
      new_hill=create_hill(prev_hill.end_y,hill_end,hill_length,is_main_level)
      
      -- keep track of the hill length we stitched to the end
      hill_width_needed = hill_width_needed - hill_length
      -- stitch the hill to the end of the level
      the_level.hills[#the_level.hills+1]= new_hill
   end
   
  
end


function draw_level(dt,the_level)
  screen_width,screen_height = love.graphics.getDimensions()
  
  -- save the pen's position and color on our stack of pens
  love.graphics.push()

  -- change the color (use the level's)
  color=the_level.color;
  love.graphics.setColor(color.red, color.green, color.blue, color.transparent)
  
  
  hill_x=-the_level.scroll -- start from the left of the screen
  for i,hill in ipairs( the_level.hills) do -- for each pair (hill_index, and hill)
    
    old_r,old_g,old_b,old_a=love.graphics.getColor()
    love.graphics.push()
    love.graphics.setColor(240,230,0,255)
    r = 1
    while (r <= hill.rings.count)
    do
      local ring = hill.rings.the_rings[r]
      
      if(not ring.collected) -- only draw non-collected rings
      then
        love.graphics.circle("line",ring.left+10+hill_x,ring.bottom-10,9)
      end
    r = r + 1  
    end
    love.graphics.pop()
    love.graphics.setColor(old_r,old_g,old_b,old_a)
    
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

-- take the previous pen's position and color and remove it from our stack of pen and make it love's current
love.graphics.pop()
end

function check_sonic_on_ring(the_level,sonic,game)
   hill_x=-the_level.scroll -- start from the left of the screen
   
   sonic.center_x=sonic.left + (sonic.animation.sprite_width /2)
   sonic.center_y = sonic.floor - (sonic.animation.sprite_height / 2 )
   
   
  for i,hill in ipairs( the_level.hills) do -- for each pair (hill_index, and hill)
    if(hill_x > sonic.right) 
    then
      return
    end
    
    r = 1
    while (r <= hill.rings.count)
    do
      local ring = hill.rings.the_rings[r]
      
      if(not ring.collected) 
      then
        
        ring.center_x=hill_x+ring.left+10
        
        if(
          math.abs(sonic.center_x - ring.center_x) * 2 < (sonic.animation.sprite_width + ring.width)
          and math.abs(sonic.center_y - ring.center_y) * 2 < (sonic.animation.sprite_height + ring.height)
          )
        then
          -- intersect
            ring.collected = true
            game.rings = game.rings + 1
            if(game.rings == game.super_speed_rings)
            then
              game.is_super=true
              game.speed_mult=game.super_speed_mult
            end
        end
      end
    r = r + 1  
    end
    hill_x=hill_x+hill.length
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
                
        consumed_y = hill.tan_phi * hill_consumed 
        
        -- draw where we think this is
        r,g,b,a=love.graphics.getColor() -- save the pen
        love.graphics.setColor(0,0,255,255)       -- user our own pen      
        love.graphics.line(
          begining_of_hill_as_screen + hill_consumed,
          hill.start_y,
          begining_of_hill_as_screen + hill_consumed,
          hill.start_y + consumed_y)
        love.graphics.setColor(r,g,b,a) -- reload the pen
        
          return hill.start_y - consumed_y , hill.angle
      
      end
      

  end
end
