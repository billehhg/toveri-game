-- This happens when game is loaded
function love.load()
  --loads the seperate scripts
  require("scripts.player")

  --this gets the window dimensions
  width, height = love.graphics.getDimensions()

  --this initiates character location, size and speed
  x, y, w, h, pspeed = (width/2)-25, (height/2)-40, height/12, width/12, width/6

  --current direction string. used to remember which direction keys are pressed and move in right order
  curdir=""
  dir="d"
  mov="s1"
end

--this will checked if you're focused on the window

function love.focus(f) gameIsPaused = not f end

function love.keypressed(key)
  --this function is in scripts/player.lua
  curdir = curDir(key,curdir)
end

function love.keyreleased(key)
  --this function is in scripts/player.lua
  curdir = curDirRel(key,curdir)
end

--this function updates every second

function love.update(dt)
  if gameIsPaused then return end
    --these functions are in scripts/player.lua
  x,y,dir,mov = movePlayer(curdir,x,y,pspeed,dt)
  if offscreen==nil then offscreen = offScreen(x,y,w,h,width,height) end
end

--this draws the screen every second

function love.draw()
  --this function is in scripts/player
  if offscreen ~= nil then offscreen,x,y=offScreenSlide(x,y,h,w,width,height,offscreen) end


  --this is only here to show that the screen slides. It will be removed or replaced with actual graphics or something
  love.graphics.setColor(224, 189, 65)
  love.graphics.rectangle("fill", -width, 0, width, height)
  love.graphics.setColor(189, 224, 65)
  love.graphics.rectangle("fill", 0, -height, width, height)
  love.graphics.setColor(65, 224, 141)
  love.graphics.rectangle("fill", width, 0, width, height)
  love.graphics.setColor(65, 165, 224)
  love.graphics.rectangle("fill", 0, height, width, height)
--this is the end of the offscreen rectangles

--this function is in scripts/player
  mov=playerWalk(dir,mov)

--this draws the playable character
  love.graphics.rectangle("fill", x, y, w, h)
end

--this is run on close of the game. Not useful yet but will be nice when we need to remind people to save

function love.quit()
  print("Thanks for playing! Come back soon!")
end
