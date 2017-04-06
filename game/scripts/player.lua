--this controls player movement, storing which direction keys are pressed and the direction in which they are pressed.
function curDir(n)
  if n == 'w' then    return curdir .. 'u'
  elseif n == 's' then    return curdir .. 'd'
  elseif n == 'a' then    return curdir .. 'l'
  elseif n == 'd' then    return curdir .. 'r'
  else  return curdir end
end
function curDirRel(n)
  if n == 'w' then    return curdir:gsub('u','')
  elseif  n == 's' then    return curdir:gsub('d','')
  elseif  n == 'a' then    return curdir:gsub('l','')
  elseif  n == 'd' then    return curdir:gsub('r','')
  else  return curdir end
end

--this assigns the players direction and movement based on 'curdir'
function movePlayer(dt)
  if curdir:sub(-1) == 'u' then
    if string.match(noGo,'u')~='u' then y = y - (pspeed * dt) end
    dir = 'u'
    mov = mov:gsub(mov:sub(1,1),'m')
  elseif curdir:sub(-1) == 'd' then
    if  string.match(noGo,'d')~='d' then y = y + (pspeed * dt) end
    dir = 'd'
    mov = mov:gsub(mov:sub(1,1),'m')
  elseif curdir:sub(-1) == 'l' then
    if string.match(noGo,'l')~='l' then x = x - (pspeed * dt) end
    dir = 'l'
    mov = mov:gsub(mov:sub(1,1),'m')
  elseif curdir:sub(-1) == 'r' then
    if string.match(noGo,'r')~='r' then x = x + (pspeed * dt) end
    dir='r'
    mov = mov:gsub(mov:sub(1,1),'m')
  else
    mov = 's1'
  end
end

--this determines the animation to display for the player (standing, moving)
function playerWalk()
  local constant=5
  wnum=tonumber(mov:sub(2,2))
  local direct=dir
  if mov:sub(1,1) == 'm' then
    if wnum <= 5 then
      direct=direct..'1'
      mov = mov:gsub(wnum,wnum+1)
    elseif wnum < 10 then
      direct=direct..'2'
      mov = mov:gsub(wnum,wnum+1)
    end
  end
  img = uko[direct]
end

function drawPlayer()
	local pWidth,pHeight = img:getDimensions()
	local sWidth,sHeight=(w/6)/sword.width,(5*h/6)/sword.height
	love.graphics.setColor(150,150,150)
	love.graphics.push()
	if playerData.weapon~=0 and dir=='u' then
		love.graphics.translate(x+w/2,y+sword.hei*.9)
	end
	if playerData.weapon~=0 and dir=='l' then
		love.graphics.translate(x+sword.wid/2,y+sword.hei)
	end
	if playerData.weapon~=0 and dir=='r' then
		love.graphics.translate(x+w-sword.wid/2,y+sword.hei)
	end
	love.graphics.rotate(sword.rotation)
	if playerData.weapon~=0 and dir~='d' then love.graphics.draw(sword.pic,-sword.wid/2,0,0,sWidth,sHeight) end
	love.graphics.pop()
 	love.graphics.draw(img,x,y,0,w/pWidth,h/pHeight)
	love.graphics.push()
	if playerData.weapon~=0 and dir=='d' then
		love.graphics.translate(x+w/2,y+sword.hei)
		love.graphics.rotate(sword.rotation)
		love.graphics.draw(sword.pic,-sword.wid/2,0,0,sWidth,sHeight) 
	end
	love.graphics.pop()
	love.graphics.setColor(bg1,bg2,bg3)
end

function swingSword()
	if spindex<6 then return else spindex=0 end
	if dir == 'u' then 
		sword.rotation=-math.pi/2
	end
	if dir == 'l' then
		sword.rotation=math.pi
	end
	if dir == 'r' then
		sword.rotation=0
	end
	if dir == 'd' then
		sword.rotation=math.pi/2
	end
end

--these are the players
function loadPlayer(whichUko)
  uko={}
  if whichUko == 'pepsoGirl' then
    uko.d=love.graphics.newImage('playerImages/playerDown.png')
    uko.d1 = love.graphics.newImage('playerImages/playerDown1.png')
    uko.d2 = love.graphics.newImage('playerImages/playerDown2.png')
    uko.u = love.graphics.newImage('playerImages/playerUp.png')
    uko.u1 = love.graphics.newImage('playerImages/playerUp1.png')
    uko.u2 = love.graphics.newImage('playerImages/playerUp2.png')
    uko.l = love.graphics.newImage('playerImages/playerLeft.png')
    uko.l1 = love.graphics.newImage('playerImages/playerLeftW.png')
    uko.l2=uko.l
    uko.r = love.graphics.newImage('playerImages/playerRight.png')
    uko.r1 = love.graphics.newImage('playerImages/playerRightW.png')
    uko.r2=uko.r
  end
end
