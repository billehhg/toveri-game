--this script will control the contents of the page
function getLocale()
  if map[mapLocale]==nil then createMap() end
  repeat
  until map[mapLocale]~=nil 
  bg1n,bg2n,bg3n=75,160,75
  if map[mapLocale].type=='grove' then  bg1n,bg2n,bg3n=100,130,100  end
end
--traps the player with trees. the next untraps them. the third draws them
function itIsTrap()
  if map[mapLocale].contains=='dangerAlone' then canSword=true end
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
    if blood then
      love.graphics.setColor(155,100,100,200)
      for i in pairs(blood) do
        drawObj(blood[i],2)
      end
      love.graphics.setColor(bg1,bg2,bg3)
    end
    love.graphics.draw(edgeForestBack,0,0)
    drawBlocks(posit)
  end
  if gameIsPaused then--will only draw the player and the boundaries if game is paused. not everything
    drawBlocks(posit)
    love.graphics.draw(edgeForest,0,0)
    if offscreen==nil then
      if menu then
        love.graphics.setColor(bg1-130,bg2-130,bg3-130)
        drawObj(menu,2)
        love.graphics.setColor(bg1-10,bg2-10,bg3-10)
        if mapLocale~='4242' then
          newGame.pic=restarT
        else
          newGame.pic=newgamE
        end
        drawObj(continue,2)
        drawObj(quit,2)
        drawObj(logo,2)
        if health<=0 then love.graphics.setColor(bg1-100,bg2-100,bg3-100) end
        drawObj(newGame,2)
      else
        menu={pic=love.graphics.newImage('contents/menu.png'),wid=width,hei=height,posX=width/2,posY=height/2}
        continue={wid=width/5,hei=height/30,posX=width/3,posY=(3*height)/10}
        newGame={}
        quit={}
        for i,j in pairs(continue) do
          newGame[i]=j
          quit[i]=j
        end
        newGame.posY=newGame.posY+height/10
        newGame.wid=width/5
        newGame.posX=continue.posX-continue.wid/2+newGame.wid/2
        quit.posY=quit.posY+2*height/10
        quit.wid=width/9
        quit.posX=continue.posX-continue.wid/2+quit.wid/2
        continue.pic=love.graphics.newImage('contents/continue.png')
        restarT=love.graphics.newImage('contents/restart.png')
        newgamE=love.graphics.newImage('contents/newGame.png')
        quit.pic=love.graphics.newImage('contents/quit.png')
        logo={pic=love.graphics.newImage('contents/logo.png'),wid=w*2,hei=h*2,posX=4*width/6,posY=height*.6}
      end
    end
    return
  end
  if map[mapLocale].obs then
    local this=map[mapLocale].obs
    love.graphics.setColor(150,150,150)
    if this.pic then 
      drawObj(this,posit)
      boundObj(this)
    else
      this.pic=obstacles[this.obj]
    end
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
  if map[mapLocale].contains=='start' then
    love.graphics.setColor(bg1+20,bg2+20,bg3+20,180)
    if not keyboard then 
      keyboard={pic=love.graphics.newImage('contents/keyboard.png'),wid=width/5,hei=height*.4,posX=width/2,posY=5*height/9}
    end
    if posit==-1 then drawObj(keyboard,2) end
  end
  if map[mapLocale].enem~=nil then
    for k in pairs(map[mapLocale].enem) do
     local enTab=enemies[k]
     if enTab and enTab.health~=-1 then
      love.graphics.setColor(enTab.r,enTab.g,enTab.b,enTab.a)
      enTab.width,enTab.height=enTab.pic:getDimensions()
      drawObj(enTab,posit)
    end end
  end
  love.graphics.setColor(bg1,bg2,bg3)
  if posit == 1 then
    drawBlocks(posit)
    love.graphics.draw(edgeForest,0,0)
  end
end
function drawObj(this,posit)
  if not this.width then this.width,this.height=this.pic:getDimensions() end
  local sWidth,sHeight=this.wid/this.width,this.hei/this.height
  if this.posY+(sHeight*this.height/2)*posit > (y+h)*posit or posit==2 then
    love.graphics.push()
    love.graphics.translate(this.posX,this.posY)
  if this.rotation then love.graphics.rotate(this.rotation) end
    love.graphics.draw(this.pic,-(sWidth*this.width/2),-(sHeight*this.height/2),0,sWidth,sHeight) 
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
