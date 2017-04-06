-- This happens when game is loaded
function love.load()
 --loads the seperate scripts
	require('scripts.player')
	require('scripts.contents')
	require('scripts.save')
	require('scripts.boundaries')

	--this gets the window dimensions
	width, height = love.graphics.getDimensions()

	--this is the background
	bgImage = love.graphics.newImage('backgroundImages/grassbg.png')
	edgeForest = love.graphics.newImage('backgroundImages/edgeforest.png')
	edgeForestBack = love.graphics.newImage('backgroundImages/edgeforestback.png')
	tree=love.graphics.newImage('backgroundImages/pinetree.png')
	bg1,bg2,bg3=75,160,75
	
	--this function located in scripts/save loads the map and player data
	startTable()

--this imports the photos for the player
	loadPlayer(playerData.whichUko)
	img=uko.d

	sword={}
	sword.pic = love.graphics.newImage('contents/sword.png')
	sword.width,sword.height=sword.pic:getDimensions()
	sword.posX,sword.posY=width/2,height*.65
	sword.wid,sword.hei=width/55,height/9
	sword.rotation=math.pi

	--this initiates character location, size and speed
	w, h, pspeed = (width/11)*playerData.size, (height/7)*playerData.size, width*.35*playerData.speed
	x, y =	(width/2)-(w/2), (height/2)-(h/2)

	hIncrement,wIncrement=height/12,width/12 --constant for page sliding
	curdir='' --used to move player (u,d,l,r)
	doorBlock='' --used to block doors (u,d,l,r)
	blockGrow=0 --index used to grow the trees foor doorBlock
	noGo='' --used to stop player when he runs into walls (u,d,l,r)
	nGcon='' --used to stop player when he runs into other shit. feeds into noGo (u,d,l,r)
	dir='d' -- direction player is facing
	mov='s1' --just counts an index when player walks to change the picture
	mapLocale='4242' --curent location (xxyy)
	spindex=6 --index for sword swing

	--this limits the frame rate so shit doesn't break
	min_dt = 1/30
	next_time = love.timer.getTime()
end

function love.focus(f) gameIsPaused = not f end
--scripts/player
function love.keypressed(key)
	if key=='space' then swingSword() end
 	curdir = curDir(key) --scripts/player
	if key=='p' then gone=true love.event.quit() end --debugging purposes. deletes all the save files
end
function love.keyreleased(key)
	curdir = curDirRel(key) --scripts/player
end
--this is pythagorean's theorum
function distance(p1x,p1y,p2x,p2y)
	local xDist=p1x-p2x
	local yDist=p1y-p2y
	return math.sqrt((xDist^2)+(yDist^2))
end

--this function updates every second
function love.update(dt)
	--this is for the frame rate
	next_time = next_time + min_dt
	if gameIsPaused then return end
	if spindex<6 then spindex=spindex+1 sword.rotation=sword.rotation-(math.pi/6) else sword.rotation=math.pi end --spins sword
	--scripts/contents
	if string.match(map[mapLocale].contains,'danger')=='danger' then itIsTrap() elseif nMTrap then noMoreTrap() end --traps player if it's a trap
	movePlayer(dt)--scripts/player
	playerWalk()--scripts/player
	noGo = checkEdgeForest()--scripts/boundaries
	if offscreen==nil then offscreen,bgx,bgy,num = offScreen() end--scripts/boundaries
	if canSword and playerData.weapon==0 and distance(x+(w/2),y+(w/2),sword.posX,sword.posY)<width/20 then canSword=nil playerData.weapon=1 noMoreTrap() end --scripts/boundaries
end

--this draws the screen every second
function love.draw()
	if offscreen ~= nil then offscreen,x,y=offScreenSlide() end

--this draws stuff behind player, draws player and draws stuff in front of player
	drawContents(-1)
	drawPlayer()
	drawContents(1)

	--frame rate
	local cur_time = love.timer.getTime()
	if next_time <= cur_time then
		next_time = cur_time
		return
	end
	love.timer.sleep(next_time - cur_time)
end

--this is run on close of the game. Not useful yet but will be nice when we need to remind people to save
function love.quit()
	serialize('playerData',playerData)
	serialize ('map',map)
	if gone then love.filesystem.remove('map') love.filesystem.remove('playerData') print('save state removed') end
	--if map['4241']==nil and map['4243']==nil and map['4142']==nil and map['4342']==nil then love.filesystem.remove('map') end
	print('Thanks for playing! Come back soon!')
end
