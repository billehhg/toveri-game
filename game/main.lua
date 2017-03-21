-- This happens when game is loaded
function love.load()
--My computer reads windows in a weird way. This makes sure it fills screen
  love.window.setMode(0,0)
  --this makes it fullscreen
  love.window.setFullscreen(true, "desktop")
  --this gets the screen dimensions
  width, height = love.graphics.getDimensions()
  --this draws a rectangle in the center of the screen at (x,y) sized (w,h)
  x, y, w, h = (width/2)-25, (height/2)-40, 50, 80
end

--this will checked if you're focused on the window
function love.focus(f) gameIsPaused = not f end
--this section should move to it's own file
function love.keypressed(key)
  --check if (w,a,s,d) are pressed for (up,left,down,right)
  if key == 'w' then    up = true  end
  if key == 's' then    down = true  end
  if key == 'a' then    left = true  end
  if key == 'd' then    right = true  end
end

function love.keyreleased(key)
  --check if (w,a,s,d) are pressed for (up,left,down,right)
  if key == 'w' then    up = false  end
  if key == 's' then    down = false  end
  if key == 'a' then    left = false  end
  if key == 'd' then    right = false  end
end

--this function updates every second
function love.update(dt)
  if gameIsPaused then return end
--move the damn thing !!!speed should become a variable
  if up == true then  y = y - 3  end
  if down == true then  y = y + 3  end
  if left == true then  x = x - 3  end
  if right == true then  x = x + 3  end
end


--this draws the screen every secont
function love.draw()
  love.graphics.setColor(0, 100, 100)
  love.graphics.rectangle("fill", x, y, w, h)
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
