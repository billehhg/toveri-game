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
function walk(this)
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
  return this[direct]
end

function drawPlayer()
	local pWidth,pHeight = img:getDimensions()
	local sWidth,sHeight=sword.wid/sword.width,sword.hei/sword.height
	love.graphics.setColor(pRed,300-pRed,300-pRed)
	love.graphics.push()
	if playerData.weapon~=0 and dir=='u' then
		love.graphics.translate(x+w/2,y+sword.hei*.8-sword.add)
		love.graphics.rotate(sword.rotation+math.pi/25)
	end
	if playerData.weapon~=0 and dir=='l' then
		love.graphics.translate(x+sword.wid/3+sword.add,y+sword.hei*.85)
		love.graphics.rotate(sword.rotation+math.pi/25)
	end
	if playerData.weapon~=0 and dir=='r' then
		love.graphics.translate(x+w-sword.wid/3-sword.add,y+sword.hei*.85)
		love.graphics.rotate(sword.rotation-math.pi/25)
	end
	if playerData.weapon~=0 and dir~='d' then love.graphics.draw(sword.pic,-sword.wid/2,0,0,sWidth,sHeight) end
	love.graphics.pop()
 	love.graphics.draw(img,x,y,0,w/pWidth,h/pHeight)
	love.graphics.push()
	if playerData.weapon~=0 and dir=='d' then
		love.graphics.translate(x+w/2,y+sword.hei*.95+sword.add)
		love.graphics.rotate(sword.rotation-math.pi/25)
		love.graphics.draw(sword.picHand,-sword.wid/2,0,0,sWidth,sHeight) 
	end
	love.graphics.pop()
	love.graphics.setColor(bg1,bg2,bg3)
end

function swingSword(init)
	if init then
		if spindex<playerData.swordCool or playerData.weapon==0 then return 
		else 
			if dir~='d' and dir~='u' then spindex=0 else spindex=-3 end
		end 
	else
	if dir=='r' then sword.rotation=sword.rotation+(math.pi/6) sword.add=width/80
	elseif dir=='l' then sword.rotation=sword.rotation-(math.pi/6) sword.add=width/80
	elseif dir=='d' then sword.hei=sword.hei-(height/28) sword.add=sword.add+height/32 sword.rotation=sword.rotation-math.pi/200
	elseif dir=='u' then sword.add=-1*sword.add+height/40 sword.rotation=sword.rotation-math.pi/40
	end end
end
function hurtMe()
	if hurt==0 then hurt=20 health=health-.5 if health==0 then killMe() end end
	if hurt>16 then pRed=250 elseif hurt>12 then pRed=150 elseif hurt>8 then pRed=150 elseif hurt>4 then pRed=250 elseif hurt>0 then pRed=150 end
	hurt=hurt-1
end
function killMe()
	love.event.quit('restart')
end
--these are the players
function loadPlayer(whichUko)
  uko={}
  if whichUko == 'hikerDude' then
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
