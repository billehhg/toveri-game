-- This happens when game is loaded
function love.load()
--  love.window.setMode(0,0)
--love.window.setFullscreen(true, "desktop")
  --this gets the screen dimensions
  width, height = love.graphics.getDimensions()
  --this draws a rectangle in the center of the screen at (x,y) sized (w,h)
  x, y, w, h = (width/2)-25, (height/2)-40, height/12, width/12
  pspeed = width/6
  --current direction string. used to restrict diagonal movment without hurting functionality of x.y movment
  curdir=""
  dir="d"
  mov="s1"
  offscreen=""
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
   if dt < 1/60 then
      love.timer.sleep(1/60 - dt)
   end
  if gameIsPaused then return end
--mov the damn thing
  if curdir:sub(-1) == "w" then  y = y - (pspeed * dt)  dir = "u" mov = mov:gsub(mov:sub(1,1),"m") end
  if curdir:sub(-1) == "s" then  y = y + (pspeed * dt)  dir = "d" mov = mov:gsub(mov:sub(1,1),"m") end
  if curdir:sub(-1) == "a" then  x = x - (pspeed * dt)  dir = "l" mov = mov:gsub(mov:sub(1,1),"m") end
  if curdir:sub(-1) == "d" then  x = x + (pspeed * dt)  dir = "r" mov = mov:gsub(mov:sub(1,1),"m") end
  if curdir == "" then  mov = "s1" end
  --slide left when thing eaves screen
  if offscreen == "" then
    if x <= 0 then
      offscreen="l"
    end
    if (x + w) >= width then
      offscreen="r"
    end
    if y <= 0 then
      offscreen="u"
    end
    if (y + h) >= height then
      offscreen="d"
    end
  end
end

--this draws the screen every second
function love.draw()
  --this is probably fixed by setting offscreen as a two part variable
  if offscreen == "l" then
    num = width/20
    offscreenx=20
    offscreeny=0
    offscreen= offscreen .. "y"
  end
  if offscreen == "r" then
    num = width/20
    offscreenx=-20
    offscreeny=0
    offscreen= offscreen .. "y"
  end
  if offscreen == "u" then
    num = height/20
    offscreenx=0
    offscreeny=20
    offscreen= offscreen .. "y"
  end
  if offscreen == "d" then
    num = height/20
    offscreenx=0
    offscreeny=-20
    offscreen= offscreen .. "y"
  end
  if offscreen:sub(2,2) == "y" then
      if offscreen:sub(1,1) == "l" then offscreenx = offscreenx + 20 end
      if offscreen:sub(1,1) == "r" then offscreenx = offscreenx - 20 end
      if offscreen:sub(1,1) == "u" then offscreeny = offscreeny + 20 end
      if offscreen:sub(1,1) == "d" then offscreeny = offscreeny - 20 end
      love.graphics.translate(offscreenx,offscreeny)
      love.timer.sleep(1/200)
      love.graphics.setColor(224, 189, 65)
      love.graphics.rectangle("fill", -width, 0, width, height)
      love.graphics.setColor(189, 224, 65)
      love.graphics.rectangle("fill", 0, -height, width, height)
      love.graphics.setColor(65, 224, 141)
      love.graphics.rectangle("fill", width, 0, width, height)
      love.graphics.setColor(65, 165, 224)
      love.graphics.rectangle("fill", 0, height, width, height)
      love.graphics.rectangle("fill", x, y, w, h)
      num=num-1
      print (10 *((width/10)-num))
      if num == 0 then
        offscreen="done"
      end
  end
  wnum=tonumber(mov:sub(2,2))
  if dir == "u" then
--love.graphics.setColor(244, 146, 66)
--love.graphics.rectangle("fill", -width, 0, width, height)
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
        love.graphics.setColor(0, 50, 100)
      else
        mov = mov:gsub(wnum,1)
        love.graphics.setColor(0, 50, 50)
      end
    else
      love.graphics.setColor(0, 50, 200)
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
