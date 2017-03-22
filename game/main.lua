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
  --current direction string. used to restrict diagonal movment without hurting functionality of x.y movment
  curdir=""
  dir="d"
  mov="s1"
end

--this will checked if you're focused on the window
function love.focus(f) gameIsPaused = not f end
--this section should mov to it's own file
function love.keypressed(key)
  --check if (w,a,s,d) are pressed for (up,left,down,right)
  if key == 'w' then    curdir = curdir .. "w"   end
  if key == 's' then    curdir = curdir .. "s"   end
  if key == 'a' then    curdir = curdir .. "a"  end
  if key == 'd' then    curdir = curdir .. "d"  end
end

function love.keyreleased(key)
  --check if (w,a,s,d) are pressed for (up,left,down,right)
  if key == 'w' then    curdir = curdir:gsub("w","")  end
  if key == 's' then    curdir = curdir:gsub("s","")  end
  if key == 'a' then    curdir = curdir:gsub("a","")  end
  if key == 'd' then    curdir = curdir:gsub("d","")  end
end

--this function updates every second
function love.update(dt)
  if gameIsPaused then return end
--mov the damn thing !!!speed should become a variable
  if curdir:sub(-1) == "w" then  y = y - 3  dir = "u" mov = mov:gsub(mov:sub(1,1),"m") end
  if curdir:sub(-1) == "s" then  y = y + 3  dir = "d" mov = mov:gsub(mov:sub(1,1),"m") end
  if curdir:sub(-1) == "a" then  x = x - 3  dir = "l" mov = mov:gsub(mov:sub(1,1),"m") end
  if curdir:sub(-1) == "d" then  x = x + 3  dir = "r" mov = mov:gsub(mov:sub(1,1),"m") end
  if curdir == "" then  mov = "s1" end
end

--this draws the screen every second
function love.draw()
  wnum=tonumber(mov:sub(2,2))
  if dir == "u" then
    if mov:sub(1,1) == 'm' then
      if wnum <= 5 then
        mov = mov:gsub(wnum,wnum+1)
        love.graphics.setColor(0, 100, 0)
      else
        mov = mov:gsub(wnum,1)
        love.graphics.setColor(0, 255, 0)
      end
    else
      love.graphics.setColor(0, 200, 0)
    end
  end
  if dir == "d" then
    if mov:sub(1,1) == 'm' then
      if wnum <= 5 then
        mov = mov:gsub(wnum,wnum+1)
        love.graphics.setColor(0, 0, 100)
      else
        mov = mov:gsub(wnum,1)
        love.graphics.setColor(0, 0, 50)
      end
    else
      love.graphics.setColor(0, 0, 200)
    end
  end
  if dir == "l" then
    if mov:sub(1,1) == 'm' then
      if wnum <= 5 then
        mov = mov:gsub(wnum,wnum+1)
        love.graphics.setColor(100, 0, 0)
      else
        mov = mov:gsub(wnum,1)
        love.graphics.setColor(50, 0, 0)
      end
    else
      love.graphics.setColor(200, 0, 0)
    end
  end
  if dir == "r" then
    if mov:sub(1,1) == 'm' then
      if wnum <= 5 then
        mov = mov:gsub(wnum,wnum+1)
        love.graphics.setColor(100, 100, 100)
      else
        mov = mov:gsub(wnum,1)
        love.graphics.setColor(50, 50, 50)
      end
    else
      love.graphics.setColor(200, 200, 200)
    end
  end
  love.graphics.rectangle("fill", x, y, w, h)
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
