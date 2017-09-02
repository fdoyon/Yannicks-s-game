
-- an animation is an object with several properties
function create_animation (w , h, x , y , s_x, steps,name,to_animate,fps)

  anim= {} -- create an object
  anim.steps=steps -- how many steps?
  anim.sprite_width=w -- size of each frame
  anim.sprite_height=h -- height of each frame
  anim.x_margin=x -- x start position of the animation im our sprite sheet
  anim.y_margin=y -- y start position ""   ""   ""
  anim.space_x=s_x -- x spa
  anim.slices={} -- slices array
  anim.fps=fps -- frames per second
  anim.name=name -- name  anim.update=u
  to_animate.animations[name]=anim -- load it into something
end

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

function update_animation(self,dt,time)
  if(time >= self.time_to_change) 
  then
    self.current_index = self.current_index + 1
    if ( self.current_index > #self.slices)
    then
      self.current_index = 1
    end
    self.time_to_change = time + (1/self.fps)
  end
end
