--this script will control the contents of the page
function getLocale()
  if map[mapLocale]==nil then createMap() end
  bg1n,bg2n,bg3n=75,160,75
  if map[mapLocale].type=='grove' then  bg1n,bg2n,bg3n=100,130,100  end
end
--traps the player with trees. the next untraps them. the third draws them
function itIsTrap()
  if map[mapLocale].contains=='dangerAlone' then canSword=true end
  doorBlock='udlr'
  if doorBlock~='' then if blockGrow<1 then blockGrow=blockGrow+.05 end else blockGrow=0 end
end
function noMoreTrap()
  nMTrap=true
  map[mapLocale].contains=map[mapLocale].contains:gsub('danger','')
  blockGrow=blockGrow-.05
  if blockGrow<=0 then nMTrap=false doorBlock='' end
end
function drawBlocks(posit)
  if posit==1 then
  if string.match(doorBlock,'l') then
  love.graphics.draw(tree,0,(height/10)*4,0,blockGrow,blockGrow)
  end
  if string.match(doorBlock,'r') then
  love.graphics.draw(tree,(width/10)*9,(height/10)*4,0,blockGrow,blockGrow)
  end
  if string.match(doorBlock,'d') then
  love.graphics.draw(tree,(width/10)*4.55,(height/10)*8.5,0,blockGrow,blockGrow)
  end
  end
  if posit==-1 then  
  if string.match(doorBlock,'u') then
  love.graphics.draw(tree,(width/10)*4.55,0,0,blockGrow,blockGrow)
  end
  end
end
--draws the contents of the page either behind(posit==-1) or in front (posit==1)
function drawContents(posit)
  if posit == -1 then
    love.graphics.setColor(bg1,bg2,bg3)
    love.graphics.draw(bgImage,0,0)
    love.graphics.draw(edgeForestBack,0,0)
    drawBlocks(posit)
  if blood then
    love.graphics.setColor(155,100,100,200)
    for i in pairs(blood) do
      drawObj(blood[i],2)
    end
    love.graphics.setColor(bg1,bg2,bg3)
  end
  end
  if gameIsPaused then--will only draw the player and the boundaries if game is paused. not everything
    drawBlocks(posit)
    love.graphics.draw(edgeForest,0,0)
    return
  end
  --map specific contents
  if string.match(map[mapLocale].contains,'Alone')=='Alone' then --this is the fancy sword room
  if not statue then
    statue = {} 
    statue.pic = love.graphics.newImage('contents/oldMan.png') 
    statue.width,statue.height=statue.pic:getDimensions()
    statue.posX,statue.posY=width/2,height*.35
    statue.wid,statue.hei=width/6,height/4
  end
  drawObj(statue,posit)
  if playerData.weapon==0 and posit==-1 and playerData.weapon==0 then drawObj(sword,2) end
  boundObj(statue)
  end
  if map[mapLocale].enem~=nil then
    for k in pairs(map[mapLocale].enem) do
     local enTab=map[mapLocale].enem[k](k)
     if enTab then
      love.graphics.setColor(enTab.r,enTab.g,enTab.b,enTab.a)
      enTab.width,enTab.height=enTab.pic:getDimensions()
      drawObj(enTab,posit)
    end end
    love.graphics.setColor(bg1,bg2,bg3)
  end
  if posit == 1 then
    drawBlocks(posit)
    love.graphics.draw(edgeForest,0,0)
  end
end
function drawObj(thisObj,posit)
  if not thisObj.width then thisObj.width,thisObj.height=thisObj.pic:getDimensions() end
  local sWidth,sHeight=thisObj.wid/thisObj.width,thisObj.hei/thisObj.height
  if thisObj.posY+(sHeight*thisObj.height/2)*posit > (y+h)*posit or posit==2 then
    love.graphics.push()
    love.graphics.translate(thisObj.posX,thisObj.posY)
  if thisObj.rotation then love.graphics.rotate(thisObj.rotation) end
    love.graphics.draw(thisObj.pic,-(sWidth*thisObj.width/2),-(sHeight*thisObj.height/2),0,sWidth,sHeight) 
    love.graphics.pop()
  end
end
function rotateCheck(this) if this.rotaion then return this.rotaion else return 0 end end
function boundObj(this)
  nGcon=''
  local bBnd=this.posY+(this.hei/2)+(h/3)
  local tBnd=this.posY
  local lBnd=this.posX-(this.wid/2)
  local rBnd=this.posX+(this.wid/2)
  if y+h<=bBnd and x+w>=lBnd and x<=rBnd and y+h>=bBnd-h/7 then nGcon=nGcon..'u' end
  if y+h>=tBnd and x+w>lBnd and x<rBnd and y+h<=tBnd*1.2 then nGcon=nGcon..'d' end
  if y+h<=bBnd*.99 and x>rBnd-w/8 and x<rBnd and y+h>=tBnd*1.1 then nGcon=nGcon..'l' end
  if y+h<=bBnd*.99 and x+w<lBnd+w/8 and x+w>lBnd and y+h>=tBnd*1.1 then nGcon=nGcon..'r' end
 end
