
the_text="we are so cool!"
white={255,255,255} -- pixels are composed of 3 tiny tiny light bulbs
red={255,0,0}
green={0,255,0}
blue={0,0,255}
black={0,0,0}
allColors={white,red,green,blue,black}
colorIndex=1
change_every_seconds=1/4
time_to_change=0


function create_coordinate(start_at,speed,forward)
    coordinate = {}
    coordinate.position = start_at
    coordinate.speed=speed
    coordinate.forward = forward
    return coordinate
end

x = create_coordinate(200,3,true)
y = create_coordinate(300,2,false)


function move(axis,max)

   if (axis.position > max) -- are we past the end?
   then
      axis.forwad = false -- go back
      axis.speed=axis.speed * 2
   end
   
   if(axis.position < 0)  -- are we before the start?
   then
     axis.forward = true -- we want to go from start to finish
     axis.speed=axis.speed * 2
   end
   
   if(axis.speed > 20)
   then
     axis.speed=1
   end
   
   if(axis.forward)
   then
     axis.position = axis.position + axis.speed
   else
     axis.position = axis.position - axis.speed
   end
   
 
end

function love.draw()
  
  thecolor=allColors[colorIndex] -- select the color
  love.graphics.setColor(thecolor[1],thecolor[2],thecolor[3],255) -- set the color
  
  love.graphics.print(the_text, x.position, y.position) -- display the text
end



function love.update(dt)
    screen_width = love.graphics.getWidth()
    screen_height = love.graphics.getHeight()
    
    if(love.keyboard.isDown("space"))
    then
        x.forward = not x.forward
        y.forward = not y.forward

    end
    
    move(x,screen_width)
    move(y,screen_height)

    time = love.timer.getTime( )
    if(time < time_to_change) 
    then
      return
    end

    colorIndex=colorIndex+1 -- go to the next color
    
    if (colorIndex > #allColors) -- if the color index is greater than the number of colors (we want color number 5 but there are only 4 colors)
    then
      colorIndex = 1 -- then just go back to the first color
    end
    
    -- when do we want to change again?
    time_to_change = time + change_every_seconds
end
