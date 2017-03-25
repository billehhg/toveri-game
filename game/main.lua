-- This happens when game is loaded
function love.load()
  --this is the background
  bgImage = love.graphics.newImage('grassbg.png')
  bgClr1,bgClr2,bgClr3=115,230,183
  edgeForest = love.graphics.newImage('edgeforest.png')
  edgeForestBack = love.graphics.newImage('edgeforestback.png')

--this imports the photos for the player
  playD = love.graphics.newImage('playerDown.png')
  playDW = love.graphics.newImage('playerDownW.png')
  playU = love.graphics.newImage('playerUp.png')
  playUW = love.graphics.newImage('playerUpW.png')
  playL = love.graphics.newImage('playerLeft.png')
  playLW = love.graphics.newImage('playerLeftW.png')
  playR = love.graphics.newImage('playerRight.png')
  playRW = love.graphics.newImage('playerRightW.png')
  img=playD

 --loads the seperate scripts
  require("scripts.player")

  --this gets the window dimensions
  width, height = love.graphics.getDimensions()

  --this initiates character location, size and speed
  w, h, pspeed = width/14, height/9, width/6
  x, y =  (width/2)-(w/2), (height/2)-(h/2)

  --current direction string. used to remember which direction keys are pressed and move in right order
  curdir=""
  noGo=" "
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
  x,y,dir,mov = movePlayer(curdir,noGo,x,y,pspeed,dt)
  noGo = checkEdgeForest(width,height,x,y,h,w,noGo)
  if offscreen==nil then offscreen = offScreen(x,y,w,h,width,height) end
end

--this draws the screen every second
function love.draw()

  --this function is in scripts/player
  if offscreen ~= nil then offscreen,x,y=offScreenSlide(x,y,h,w,width,height,offscreen,bgClr1,bgClr2,bgClr3) end

--this sets the background image
  love.graphics.setColor(bgClr1,bgClr2,bgClr3)
  love.graphics.draw(bgImage,0,0)
  love.graphics.draw(edgeForestBack,0,0)

--this function is in scripts/player
  mov=playerWalk(dir,mov)

--this draws the playable character
  love.graphics.draw(img,x,y,0,w/200,h/300)

  --this puts trees in front of player when he's behind them
  love.graphics.setColor(bgClr1,bgClr2,bgClr3)
  love.graphics.draw(edgeForest,0,0)

end

--this is run on close of the game. Not useful yet but will be nice when we need to remind people to save

function love.quit()
  print("Thanks for playing! Come back soon!")
end
