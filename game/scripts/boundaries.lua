--this script controls the boundaries of the page and forest
function checkEdgeForest()
  local nG=nGcon
  local xX=width/11
  local con1=.47*height
  local con2=.58*height
  local con3=.44*width
  local con4=.59*width
  local xDoor=((y+h) <= con1 or (y+h) >= con2)
  local yDoor=(x <= con3 or (x+w) >= con4)
  if x <= xX then
    if xDoor or string.match(doorBlock,'l') then
      nG=nG..'l'
    else
      if ((y+h) <= con1*1.05) and ((x*1.15)<=xX) then nG=nG..'u' end
      if ((y+h) >= con2*.95) and ((x*1.15)<=xX) then nG=nG..'d' end
    end
  end
  if (x+w) >= (width-xX*1.1) then
    if xDoor or string.match(doorBlock,'r') then
      nG=nG..'r'
    else
      if (y+h) <= con1*1.05 and (x+(w*.9))>=(width-xX) then nG=nG..'u' end
      if (y+h) >= con2*.95 and (x+(w*.9))>=(width-xX) then nG=nG..'d' end
    end
  end
  if (y+h) <= (height/4) then
    if yDoor or string.match(doorBlock,'u') then
      nG=nG .. 'u'
    else
      if x <= con3*1.05 and y+h<=height/5 then nG=nG..'l' end
      if (x+w) >= con4*.95 and y+h<=height/5 then nG=nG..'r' end
    end
  end
  if (y+h) >= (height-(height/9)) then
    if yDoor or string.match(doorBlock,'d') then
      nG=nG..'d'
    else
      if (x <= con3*1.05) and (y+(h*.9))>=(height-(height/10)) then nG=nG..'l' end
      if (x+w) >= con4*.95 and (y+(h*.9))>=(height-(height/10)) then nG=nG..'r' end
    end
  end
  return nG
end

--this detects if player is offscreen and tracks position on metamap
function offScreen()
  local zw = 2*(w/3)
  local zh = 2*(h/3)
  local mapX = tonumber(mapLocale:sub(1,2))
  local mapY = tonumber(mapLocale:sub(3,4))
  offscreenx,offscreeny=0,0
  if (x+zw) <= 0 then mapLocale=(mapX-1)..mapY  return 'l',-width,0,width/wIncrement end
  if ((x-zw) + w) >= width then mapLocale=(mapX+1)..mapY return 'r',width,0,width/wIncrement end
  if (y+zh) <= 0 then mapLocale=mapX..(mapY-1) return 'u',0,-height,height/hIncrement  end
  if ((y-zh) + h) >= height then mapLocale=mapX..(mapY+1) return 'd',0,height,height/hIncrement end
  return offscreen,bgx,bgy,num
end

--this slides the screen and moves the player to the other side when players leave screen
function offScreenSlide()
  if offscreen == 'l' then  offscreenx = offscreenx + wIncrement  end
  if offscreen == 'r' then  offscreenx = offscreenx - wIncrement  end
  if offscreen == 'u' then  offscreeny = offscreeny + hIncrement  end
  if offscreen == 'd' then  offscreeny = offscreeny - hIncrement  end
  getLocale()
  love.graphics.setColor(bg1n,bg2n,bg3n)
  love.graphics.translate(offscreenx,offscreeny)
  love.graphics.draw(bgImage,bgx,bgy)
  love.graphics.draw(edgeForest,bgx,bgy)
  love.graphics.draw(edgeForestBack,bgx,bgy)
  num=num-1
  if num == 0 then
    bg1,bg2,bg3=bg1n,bg2n,bg3n
    blockGrow=0
    gameIsPaused=false
    return nil,x+offscreenx,y+offscreeny
  else
    gameIsPaused=true
    return offscreen,x,y
  end
end
