-- This happens when game is loaded
function love.load()
  --this is the background
  bgImage = love.graphics.newImage('backgroundImages/grassbg.png')
  bgClr1,bgClr2,bgClr3=115,230,183
  edgeForest = love.graphics.newImage('backgroundImages/edgeforest.png')
  edgeForestBack = love.graphics.newImage('backgroundImages/edgeforestback.png')

--this imports the photos for the player
  playD = love.graphics.newImage('playerImages/playerDown.png')
  playD1 = love.graphics.newImage('playerImages/playerDown1.png')
  playD2 = love.graphics.newImage('playerImages/playerDown2.png')
  playU = love.graphics.newImage('playerImages/playerUp.png')
  playU1 = love.graphics.newImage('playerImages/playerUp1.png')
  playU2 = love.graphics.newImage('playerImages/playerUp2.png')
  playL = love.graphics.newImage('playerImages/playerLeft.png')
  playLW = love.graphics.newImage('playerImages/playerLeftW.png')
  playR = love.graphics.newImage('playerImages/playerRight.png')
  playRW = love.graphics.newImage('playerImages/playerRightW.png')
  img=playD

 --loads the seperate scripts
  require('scripts.player')

  --this gets the window dimensions
  width, height = love.graphics.getDimensions()
--vec3 hsv(float h,float s,float v) { return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v; }
  --this initiates character location, size and speed
  w, h, baseSpeed = width/14, height/9, width*.2
  pspeed=baseSpeed*1
  x, y =  (width/2)-(w/2), (height/2)-(h/2)

  --current direction string. used to remember which direction keys are pressed and move in right order
  curdir=''
  noGo=' '
  dir='d'
  mov='s1'
  mapLocale='4242'
end

--this will checked if you're focused on the window

function love.focus(f) gameIsPaused = not f end

function love.keypressed(key)
  --this function is in scripts/player.lua
  curdir = curDir(key)
end

function love.keyreleased(key)
  --this function is in scripts/player.lua
  curdir = curDirRel(key)
end

--this function updates every second

function love.update(dt)
  if gameIsPaused then return end
    --these functions are in scripts/player.lua
  x,y,dir,mov = movePlayer(dt)
  noGo = checkEdgeForest()
  if offscreen==nil then offscreen,mapLocale = offScreen() end
end

--this draws the screen every second
function love.draw()
  
  --this function is in scripts/player
  if offscreen ~= nil then offscreen,x,y=offScreenSlide(bgClr1,bgClr2,bgClr3) end

--this sets the background image
  love.graphics.setColor(bgClr1,bgClr2,bgClr3)
  love.graphics.draw(bgImage,0,0)
  love.graphics.draw(edgeForestBack,0,0)

--this function is in scripts/player
  mov=playerWalk()

--this draws the playable character
  love.graphics.setColor(200,200,200)
  love.graphics.draw(img,x,y,0,w/200,h/300)

  --this puts trees in front of player when he's behind them
  love.graphics.setColor(bgClr1,bgClr2,bgClr3)
  love.graphics.draw(edgeForest,0,0)

end

--this is run on close of the game. Not useful yet but will be nice when we need to remind people to save

function love.quit()
  print('Thanks for playing! Come back soon!')
end
