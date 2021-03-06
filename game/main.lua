-- This happens when game is loaded
function love.load()
 --loads the seperate scripts
  require('scripts.player')
  require('scripts.contents')
  require('scripts.save')
  require('scripts.boundaries')
  require('scripts.enemies')
  --this gets the window dimensions
  width, height = love.graphics.getDimensions()
  --this is the background
  bgImage = love.graphics.newImage('backgroundImages/grassbg.png')
  edgeForest = love.graphics.newImage('backgroundImages/edgeforest.png')
  edgeForestBack = love.graphics.newImage('backgroundImages/edgeforestback.png')
  tree=love.graphics.newImage('backgroundImages/pinetree.png')
  bloody=love.graphics.newImage('enemies/blood.png')
  heartDrop=love.graphics.newImage('contents/heart.png')
  obstacles={}
  obstacles.rock=love.graphics.newImage('contents/rock.png')
  obstacles.tall=love.graphics.newImage('contents/rockTall.png')
  obstacles.cube=love.graphics.newImage('contents/rockCube.png')
  obstacles.shroom=love.graphics.newImage('contents/shroom.png')
  obstacles.spike=love.graphics.newImage('contents/spike.png')
  obstacles.log=love.graphics.newImage('contents/log.png')
  obstacles.options={'rock','tall','cube','shroom','spike','log'}
  bg1,bg2,bg3=75,160,75
  --this function located in scripts/save loads the map and player data
  startTable()
  --this imports the photos for the player
  loadPlayer(playerData.whichUko)
  img=player.d
  sword={}
  sword.pic = love.graphics.newImage('contents/sword.png')
  sword.picHand = love.graphics.newImage('contents/swordHand.png') 
  sword.width,sword.height=sword.pic:getDimensions()
  sword.posX,sword.posY=width/2,height*.65
  sword.wid,sword.hei=width/35,height/8
  sword.rotation,sword.add=math.pi,0
  --this initiates character location, size and speed
  w, h, player.speed = (width/12)*playerData.size, (height*.15)*playerData.size, width*.3*playerData.speed
  x, y =  (width/2)-(w/2), (height/2)-(h/2)
  hIncrement,wIncrement=height/12,width/12 --constant for page sliding
  player.curdir='' --used to move player (u,d,l,r)
  doorBlock='' --used to block doors (u,d,l,r)
  blockGrow=0 --index used to grow the trees foor doorBlock
  player.noGo='' --used to stop player when he runs into walls (u,d,l,r)
  nGcon='' --used to stop player when he runs into other shit. feeds into noGo (u,d,l,r)
  player.dir='d' -- direction player is facing
  player.mov='s1' --just counts an index when player walks to change the picture
  mapLocale='4242' --curent location (xxyy)
  spindex=10 --index for sword swing
  hurt=0
  pRed=150
  health=3
  directions={'d','l','u','r'}
end
function love.focus(f) if f==true then gameIsPaused=not f end   end
--scripts/player
function love.keypressed(key)
  if key=='space' then swingSword(true) end
   player.curdir = curDir(key) --scripts/player
  if key=='escape' or key=='p' then gameIsPaused=not gameIsPaused end
  if gameIsPaused then
    if key=='n' and mapLocale=='4242' then gone=true love.event.quit( "restart") end
    if key=='r' then love.event.quit('restart') end
    if key=='c' then gameIsPaused=false end
    if key=='q' then love.event.quit() end
  end
end
function love.keyreleased(key)
  player.curdir = curDirRel(key) --scripts/player
end
--this is pythagorean's theorum
function distance(p1x,p1y,p2x,p2y)
  local xDist=p1x-p2x
  local yDist=p1y-p2y
  return math.sqrt((xDist^2)+(yDist^2))
end
--this function updates every second
function love.update(dt)
  if gameIsPaused then return end
  if health<=0 then love.event.quit('restart') end
  player.posX,player.posY=x+(w/2),y+h
  if spindex<playerData.swordCool then if spindex<3 then swingSword() spindex=spindex+1 elseif spindex<9 then spindex=spindex+1 else sword.hei=height/8 sword.rotation=math.pi spindex=spindex+1 sword.add=0 end end
  --scripts/contents
  if string.match(map[mapLocale].contains,'danger')=='danger' then doorBlock='uldr' itIsTrap() elseif nMTrap then noMoreTrap() elseif doorBlock~=nil then blockGrow=1 else blockGrow=0 end --traps player if it's a trap
  if string.match(map[mapLocale].contains,'dangerAlone')=='dangerAlone' and canSword and playerData.weapon==0 and distance(x+(w/2),y+(w/2),sword.posX,sword.posY)<width/20 then canSword=nil playerData.weapon=1  noMoreTrap() end --scripts/boundaries
  movePlayer(player,dt)--scripts/player
  if map[mapLocale].enem~=nil then moveEnemies(dt) end
  if hurt>0 then hurtMe() end
  img=walk(player,player)--scripts/player
  player.noGo = checkEdgeForest()--scripts/boundaries
  if offscreen==nil then offscreen,bgx,bgy,num = offScreen() end--scripts/boundaries
end
--this draws the screen every second
function love.draw()
  if offscreen ~= nil then offscreen,x,y=offScreenSlide() end
  drawContents(-1)
  drawPlayer()
  drawContents(1)
end
function erase()
  love.filesystem.remove('map') love.filesystem.remove('playerData') print('save state removed')
end
function love.quit()
  serialize('playerData',playerData)
  serialize ('map',map)
  if gone then erase() end
  print('Thanks for playing! Come back soon!')
end
