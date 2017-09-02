require "animation"

sonic = {}
sonic.animations={}

function create_sonic()
  
  
  sonic.image = love.graphics.newImage("sonic2.png")
  create_animation  (42,40 ,8   ,62, 2,7,"walk",sonic,13)
  create_animation  (36,40 ,400 ,62, 4,3,"run",sonic,20,math.pi/8,"walk")
  create_animation  (36,40 ,8   ,15, 4,3,"stand",sonic,1)
  create_animation  (36,40 ,198 ,15, 4,5,"idle",sonic,1)
  
  for name,anim in pairs (sonic.animations) do
    load_animation(anim)
  end
  

  change_animation(sonic,"idle")

end
function draw_sonic(sonic, the_level, dt,floor)
  screen_width, screen_height= love.graphics.getDimensions()
  
  love.graphics.draw(sonic.image,slice,100,floor-sonic.animation.sprite_height)
  sonic_right=100+sonic.animation.sprite_width
  sonic_bottom=floor
  
  r,g,b,a=love.graphics.getColor()

-- change the pen
  
  love.graphics.setColor(255,0,0,255)
  love.graphics.line(sonic_right,sonic_bottom,screen_width,sonic_bottom)
  love.graphics.line(sonic_right,sonic_bottom,sonic_right,screen_width)
  -- reuse the old pen
  
  love.graphics.setColor(r,g,b,a)

  
end

function update_sonic(sonic,dt,time)

  update_animation(sonic.animation,dt,time)

  if(love.keyboard.isDown("r"))
  then
    change_animation(sonic,"run")
  end

  if(love.keyboard.isDown("w"))
  then
    change_animation(sonic,"walk")
  end
  if(love.keyboard.isDown("s"))
  then
    change_animation(sonic,"stand")
  end
  if(love.keyboard.isDown("i"))
  then
    change_animation(sonic,"idle")
  end

end

function change_animation(self,to_anim)
  self.animation=self.animations[to_anim]
  self.animation.current_index=1 -- reset the frame counter
  self.animation.time_to_change=love.timer.getTime() + (1/self.animation.fps) -- also reschedule the animation timer
end
