--this file contains all the scripts dealing with the game's main playable character. It will not contain persistant player characteristics.

--this controls player movement, storing which direction keys are pressed and the direction in which they are pressed.
--The following function removes the keys when they're released

function curDir(n,curdir)
  if n == 'w' then    return curdir .. 'w'
  elseif n == 's' then    return curdir .. 's'
  elseif n == 'a' then    return curdir .. 'a'
  elseif n == 'd' then    return curdir .. 'd'
  else  return curdir end
end

function curDirRel(n,curdir)
  if n == 'w' then    return curdir:gsub('w','')
  elseif  n == 's' then    return curdir:gsub('s','')
  elseif  n == 'a' then    return curdir:gsub('a','')
  elseif  n == 'd' then    return curdir:gsub('d','')
  else  return curdir end
end

--this keeps the player out of the forest. I'd prefer to code golf this but couldn't think of how to easily.
function checkEdgeForest(width,height,x,y,h,w,noGo)
  local nG=""
  local xX=width/12
  local xDoor=((y+h) <= (height*.42) or (y+h) >= (height*.59))
  local yDoor=(x <= (.42*width) or (x+w) >= (width*.6))
  if x <= xX then
    if xDoor then
      nG=nG.."a"
    else
      if ((y+h) <= (height*.45)) and ((x*1.1)<=xX) then nG=nG.."w" end
      if ((y+h) >= (height*.53)) and ((x*1.1)<=xX) then nG=nG.."s" end
    end
  end
  if (x+w) >= (width-xX) then
    if xDoor then
      nG=nG.."d"
    else
      if (y+h) <= (height*.45) and (x+(w*.99))>=(width-xX) then nG=nG.."w" end
      if (y+h) >= (height*.53) and (x+(w*.99))>=(width-xX) then nG=nG.."s" end
    end
  end
  if (y+h) <= (height/6) then
    if yDoor then
      nG=nG .. "w"
    else
      if (x <= (.45*width)) and ((y+h)*.9)<=(height/7) then nG=nG..'a' end
      if (x+w) >= (width*.59) and ((y+h)*.9)<=(height/7) then nG=nG..'d' end
    end
  end
  if (y+h) >= (height-(height/10)) then
    if yDoor then
      nG=nG.."s"
    else
      if (x <= (.45*width)) and (y+(h*.9))>=(height-(height/10)) then nG=nG..'a' end
      if (x+w) >= (width*.59) and (y+(h*.9))>=(height-(height/10)) then nG=nG..'d' end
    end
  end
  return nG
end

--this assigns the players direction and movement based on 'curdir'

function movePlayer(curdir,noGo,x,y,pspeed,dt)
  if curdir:sub(-1) == 'w' then
    if string.match(noGo,'w')~='w' then y = y - (pspeed * dt) end
    dir = 'u'
    mov = mov:gsub(mov:sub(1,1),'m')
  elseif curdir:sub(-1) == 's' then
    if  string.match(noGo,'s')~='s' then y = y + (pspeed * dt) end
    dir = 'd'
    mov = mov:gsub(mov:sub(1,1),'m')
  elseif curdir:sub(-1) == 'a' then
    if string.match(noGo,'a')~='a' then x = x - (pspeed * dt) end
    dir = 'l'
    mov = mov:gsub(mov:sub(1,1),'m')
  elseif curdir:sub(-1) == 'd' then
    if string.match(noGo,'d')~='d' then x = x + (pspeed * dt) end
    dir='r'
    mov=mov:gsub(mov:sub(1,1),'m')
  else
    mov = 's1'
  end
  return x,y,dir,mov
end

--this detects if player is offscreen

function offScreen(x,y,w,h,width,height)
  local zw = 2*(w/3)
  local zh = 2*(h/3)
  if (x+zw) <= 0 then return 'l' end
  if ((x-zw) + w) >= width then  return 'r'  end
  if (y+zh) <= 0 then  return 'u'  end
  if ((y-zh) + h) >= height then return 'd'  end
end

--this slides the screen and moves the player to the other side when players leave screen

function offScreenSlide(x,y,h,w,width,height,offscreen,bg1,bg2,bg3)
  --declares things at beginning of animation (how much to slide and whatnot)
  if offscreenx==nil then
    offscreenx=0
    offscreeny=0
    if offscreen == 'l' or offscreen == 'r' then
      num=width/20
    else
      num=height/20
    end
  end

  love.graphics.setColor(bg1,bg2,bg3)
  --slides the screen
  if offscreen == 'l' then
    offscreenx = offscreenx + 20
    bgx,bgy=-800,0
  end
  if offscreen == 'r' then
    offscreenx = offscreenx - 20
    bgx,bgy=800,0
  end
  if offscreen == 'u' then
    offscreeny = offscreeny + 20
    bgx,bgy=-0,-600
  end
  if offscreen == 'd' then
    offscreeny = offscreeny - 20
    bgx,bgy=-0,600
  end
  love.graphics.translate(offscreenx,offscreeny)
  love.graphics.draw(bgImage,bgx,bgy)
  love.graphics.draw(edgeForest,bgx,bgy)
  love.graphics.draw(edgeForestBack,bgx,bgy)
  love.timer.sleep(1/200)
  num=num-1
  --keeps game paused while screen slides and ends slide once complete
  if num == 0 then
    local xx = offscreenx
    offscreenx=nil
    gameIsPaused=false
    return nil,x+xx,y+offscreeny
  else
    gameIsPaused=true
    return offscreen,x,y
  end
end


--this determines the animation to display for the player (standing, moving)
function playerWalk(dir,mov)
  wnum=tonumber(mov:sub(2,2))
  if dir == 'u' then
    if mov:sub(1,1) == 'm' then
      if wnum <= 5 then
        img=playU
        return mov:gsub(wnum,wnum+1)
      elseif wnum < 10 then
        img=playUW
        return mov:gsub(wnum,wnum+1)
      end
    else
      img=playU
      return mov
    end
  end
  if dir == 'd' then
    if mov:sub(1,1) == 'm' then
      if wnum <= 5 then
        img=playD
        return mov:gsub(wnum,wnum+1)
      elseif wnum < 10 then
        img=playDW
        return mov:gsub(wnum,wnum+1)
      end
    else
      img=playD
      return mov
    end
  end
  if dir == 'l' then
    if mov:sub(1,1) == 'm' then
      if wnum <= 5 then
        img=playL
        return mov:gsub(wnum,wnum+1)
      elseif wnum < 10 then
        img=playLW
        return mov:gsub(wnum,wnum+1)
      end
    else
      img=playL
      return mov
    end
  end
  if dir == 'r' then
    if mov:sub(1,1) == 'm' then
      if wnum <= 5 then
        img=playR
        return mov:gsub(wnum,wnum+1)
      elseif wnum < 10 then
        img=playRW
        return mov:gsub(wnum,wnum+1)
      end
    else
      img=playR
      return mov
    end
  end
end
