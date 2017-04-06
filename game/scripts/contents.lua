--this script will control the contents of the page
function getLocale()
  if map[mapLocale]==nil then createMap() end
  bg1n,bg2n,bg3n=75,160,75
  if map[mapLocale].type=='grove' then  bg1n,bg2n,bg3n=100,130,100  end
end

--traps the player with trees. the next untraps them. the third draws them
function itIsTrap()
  if map[mapLocale].contains=='dangerAlone' then canSword=true end
  if distance((width/2),(height/2),(x+(w/2)),(y+(h/2)))<(height*.35)  then 
    doorBlock='udlr'
  if doorBlock~='' then if blockGrow<1 then blockGrow=blockGrow+.05 end else blockGrow=0 end
  end
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
      statue.tBnd=2*statue.hei/3
    end
    drawObj(statue,posit)
    if playerData.weapon==0 and posit==-1 and playerData.weapon==0 then drawObj(sword,2) end
    boundObj(statue)
    end
  if posit == 1 then
    drawBlocks(posit)
    love.graphics.draw(edgeForest,0,0)
  end
end

function drawObj(thisObj,posit)
  local sWidth,sHeight=thisObj.wid/thisObj.width,thisObj.hei/thisObj.height
  if thisObj.posY+(sHeight*thisObj.height/2)*posit > (y+h)*posit or posit==2 then
   love.graphics.draw(thisObj.pic,thisObj.posX-(sWidth*thisObj.width/2),thisObj.posY-(sHeight*thisObj.height/2),rotateCheck(thisObj),sWidth,sHeight) 
 end
end

function rotateCheck(this) if this.rotaion then return this.rotaion else return 0 end end

function boundObj(this)
  nGcon=''
  local widdy,higgy=this.wid/2.05,this.hei/1.5
  local tBnd,bBnd,lBnd,rBnd=(this.posY-higgy)+this.tBnd,this.posY+higgy,this.posX-widdy,this.posX+widdy
  if y+h<=bBnd and x+w>lBnd and x<rBnd and y+h>=bBnd*.9 then nGcon='u' end
  if y+h>=tBnd and x+w>lBnd and x<rBnd and y+h<=tBnd*1.1 then nGcon='d' end
  if y+h<=bBnd*.99 and x>rBnd*.9 and x<rBnd and y+h>=tBnd*1.1 then nGcon='l' end
  if y+h<=bBnd*.99 and x+w<lBnd*1.1 and x+w>lBnd and y+h>=tBnd*1.1 then nGcon='r' end
 end
