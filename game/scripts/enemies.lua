function enemy(input)
  if enemyList==nil then
    enemyList={}
    enemyList.hard={}
    enemyList.hard[1]=lassi
    enemyList.hard[2]={sisko,4}
--    enemyList.hard[4]=eemeli
    enemyList.hard.index=1
    enemyList.easy={}
    enemyList.easy[1]=jared
    enemyList.easy[2]=albert
    enemyList.boss={}
    enemyList.index={} enemyList.index.hard=0 enemyList.index.easy=0 enemyList.index.boss=0
    for i in pairs(enemyList.easy) do enemyList.index.easy = enemyList.index.easy + 1 end
    for i in pairs(enemyList.hard) do enemyList.index.hard = enemyList.index.hard + 1 end
    for i in pairs(enemyList.boss) do enemyList.index.boss = enemyList.index.boss + 1 end
    return enemy(input)
  else
    return (enemyList[input][math.random(#enemyList[input])])
  end
end
function moveEnemies(dt) for i in pairs(map[mapLocale].enem) do map[mapLocale].enem[i](i,dt) end end
function normEnem(this,init)
  if init then
    local t={}
    t.posX,t.posY=math.random(width*.5)+width*.25,math.random(height*.5)+height*.25
    t.hurt,t.hurtIndex='',0
    t.difficult='easy'
    t.move=true
    return t
  end
  if this.health==0 then
    dropShit(this)
    return
  end
  if this.hurtIndex<=0 then this.hurt=checkSword(this) if this.hurt~=nil then this.hurtIndex=10 end end
end
function flyPlay(dt,this,picT)
  local spid=this.speed*dt
  if this.hurtIndex<=0 then
    if this.posX<x+(w/2) then this.posX=this.posX+spid else this.posX=this.posX-spid end
    if this.posY<y+(h/2) then this.posY=this.posY+spid else this.posY=this.posY-spid end
    spid=spid*2
    this.posX,this.posY=this.posX+math.random(-spid,spid),this.posY+math.random(-spid,spid)
  else
    checkSword(this,dt)
  end
end
function pulsateRand(this)
  this.size=this.size+math.random(math.pi/12,math.pi/6)
  this.wid,this.hei=this.wid+math.sin(this.size),this.hei+math.sin(this.size)
end
function metaWalk(dt,this,picT)
  if this.hurtIndex<=0 then
    this.curdir=this.dir
    local nono=enBind(this)
    if nono=='u' and this.curdir=='u' then this.curdir='d' 
    elseif nono=='d' and this.curdir=='d' then this.curdir='r' 
    elseif nono=='r' and this.curdir=='r' then this.curdir='l' 
    elseif nono=='l' and this.curdir=='l' then this.curdir='r' end
    movePlayer(this,dt)
  else
    checkSword(this,dt)
  end
  this.pic=walk(this,picT)
end
function walkCircles(dt,this,picT)
  this.noGo=''
  local spid=dt*this.speed
  if this.trnIndex>=this.trnPrb and math.random(this.trnPrb*2)>=(this.trnPrb*2)-1 then 
    if this.dir=='u' then this.dir='r'
    elseif this.dir=='r' then this.dir='d'
    elseif this.dir=='d' then this.dir='l'
    elseif this.dir=='l' then this.dir='u'
    end
    this.trnIndex=0
  else
    this.trnIndex=this.trnIndex+1
  end
  metaWalk(dt,this,picT)
end
function walkRand(dt,this,picT)
  this.noGo=''
  local spid=dt*this.speed
  if math.random(this.trnPrb)>this.trnPrb-1 then
    if this.dir=='d' or this.dir=='u' then
      if math.random(2)>1 then this.dir='l' else this.dir='r' end
    else
      if math.random(2)>1 then this.dir='u' else this.dir='d' end
    end
  end
  metaWalk(dt,this,picT)
end
function sisko(this,dt)
  if not this then return "sisko" end
  if siskoT then
    if not dt then return end
    if enemies[this] then  
      if enemies[this].health==-1 then return end
      normEnem(enemies[this])
      if enemies[this].health==0 then return end
      walkCircles(dt,enemies[this],siskoT)
    else
      local t=normEnem(this,true)
      t.wid,t.hei=w/2,h*.4
      t.health=2
      t.dir=directions[math.random(4)]
      t.mov='s1'
      t.pic=siskoT.d
      t.speed,t.trnPrb=width/4,25
      t.trnIndex=0
      t.r,t.g,t.b,t.a=150,150,175,255
      enemies[this]=t
      return sisko(this)
    end
  else
    local t={}
    t.speed=width/8
    t.d=love.graphics.newImage('enemies/siskoDown.png')
    t.d1=love.graphics.newImage('enemies/siskoDown1.png')
    t.d2=t.d
    t.u=love.graphics.newImage('enemies/siskoUp.png')
    t.u1=love.graphics.newImage('enemies/siskoUp1.png')
    t.u2=t.u
    t.l=love.graphics.newImage('enemies/siskoLeft.png')
    t.l1=love.graphics.newImage('enemies/siskoLeft1.png')
    t.l2=t.l
    t.r=love.graphics.newImage('enemies/siskoRight.png')
    t.r1=love.graphics.newImage('enemies/siskoRight1.png')
    t.r2=t.r
    siskoT=t
    return sisko(this)
  end  
end
function jared(this,dt)
  if not this then return "jared" end
  if jaredT then
    if not dt then return end
    if enemies[this] then  
      if enemies[this].health==-1 then return end
      normEnem(enemies[this])
      if enemies[this].health==0 then return end
      walkRand(dt,enemies[this],jaredT)
    else
      local t=normEnem(this,true)
      t.wid,t.hei=w,h*.8
      t.health=4
      t.dir=directions[math.random(4)]
      t.mov='s1'
      t.pic=jaredT.d
      t.speed,t.trnPrb=width/10,50
      t.r,t.g,t.b,t.a=150,150,175,255
      enemies[this]=t
      return jared(this)
    end
  else
    local t={}
    t.speed=width/8
    t.d=love.graphics.newImage('enemies/jaredDown.png')
    t.d1=love.graphics.newImage('enemies/jaredDown1.png')
    t.d2=love.graphics.newImage('enemies/jaredDown2.png')
    t.u=love.graphics.newImage('enemies/jaredUp.png')
    t.u1=love.graphics.newImage('enemies/jaredUp1.png')
    t.u2=t.u
    t.l=love.graphics.newImage('enemies/jaredLeft.png')
    t.l1=love.graphics.newImage('enemies/jaredLeft1.png')
    t.l2=t.l
    t.r=love.graphics.newImage('enemies/jaredRight.png')
    t.r1=love.graphics.newImage('enemies/jaredRight1.png')
    t.r2=t.r
    jaredT=t
    return jared(this)
  end  
end
function eemeli()
end
function albert(this,dt)
  if not this then return "albert" end
  if albertT then
    if not dt then return end
    if enemies[this] then
      if enemies[this].health==-1 then return end
      normEnem(enemies[this])
      if enemies[this].health==0 then return end
      if string.match(player.mov,'m') then enemies[this].speed=width/10 else enemies[this].speed=width/20 end
      flyPlay(dt,enemies[this],albertT)
      pulsateRand(enemies[this])
      if enemies[this].hurtIndex>0 and enemies[this].move~=false then enemies[this].wid,enemies[this].hei=enemies[this].wid*.99,enemies[this].hei*.99 end
    else
      local t=normEnem(this,true)
      t.size=math.pi/6
      t.wid,t.hei=w*.8,h*.5
      t.health=3
      t.pic=albertT.pic
      t.r,t.g,t.b,t.a=bg1,bg2,bg3,255
      enemies[this]=t
      return albert(this)
    end
  else
    local t={}
    t.pic=love.graphics.newImage('enemies/albert.png')
    albertT=t
    return albert(this)
  end
end
function lassi(this,dt)
  if not this then return "lassi" end
  if lassiT then
    if not dt then return end
    if enemies[this] then
      if enemies[this].health==-1 then return end
      normEnem(enemies[this])
      if enemies[this].health==0 then return end
      flyPlay(dt,enemies[this],lassiT)
      if math.sin(enemies[this].picDex)>=0 then enemies[this].pic=lassiT.pic2 else enemies[this].pic=lassiT.pic1 end
      enemies[this].picDex=enemies[this].picDex+math.pi/2
    else
      local t=normEnem(this,true)
      t.size=math.pi/6
      t.wid,t.hei=w*1.3,h
      t.health=5
      t.speed=width/9
      t.pic=lassiT.pic1
      t.picDex=0
      t.r,t.g,t.b,t.a=150,150,150,255
      t.difficult='hard'
      enemies[this]=t
      return lassi(this)
    end
  else
    local t={}
    t.pic1=love.graphics.newImage('enemies/lassi1.png')
    t.pic2=love.graphics.newImage('enemies/lassi2.png')
    lassiT=t
    return lassi(this)
  end
end
function makeItBleed(this)
  if safeMode then return end
  blood[map[mapLocale].bloodI]={}
  blood[map[mapLocale].bloodI].pic=bloody
  blood[map[mapLocale].bloodI].posX,blood[map[mapLocale].bloodI].posY=this.posX+math.random(-width/35,width/35),this.posY+math.random(-width/35,width/35)
  blood[map[mapLocale].bloodI].wid,blood[map[mapLocale].bloodI].hei=w*.6,w*.6
  map[mapLocale].bloodI=map[mapLocale].bloodI+1
end
function dropShit(this)
  if this.dropIndex then
    if distance(this.posX,this.posY,player.posX,player.posY-(w/2))<=w/2 then
      if this.pic==heartDrop then
        health=health+1
        if health>playerData.health then health=playerData.health end
      end
      if this.health then this.health=-1 end
    end
    this.wid,this.hei=this.wid+(this.wid/50)*math.sin(this.dropIndex),this.hei+(this.hei/50)*math.sin(this.dropIndex)
    this.dropIndex=this.dropIndex-math.pi/20
    if this.dropIndex<=0 then
      if this.health then this.health=-1 end
    end
  else
    playerData.enemDead=playerData.enemDead+1
      if playerData.difici==1 or playerData.enemDead==(playerData.difici)^3 then
      playerData.difici=playerData.difici+1
    end
    if math.random(4)==4 then 
      local drop={heartDrop}
      this.pic=drop[math.random(#drop)]
      if this.pic==heartDrop then
        this.wid,this.hei=width/25,width/25
        this.r,this.g,this.b=175,125,125
      end
    else
      if this.health then this.health=-1 end
    end
    this.dropIndex=20*math.pi
  end
end
function checkSword(this,dt)
  if dt then
    local spid=width/20*dt
    if this.hurt=='l' then this.posX=this.posX-4*spid
    elseif this.hurt=='r' then this.posX=this.posX+4*spid
    elseif this.hurt=='u' then this.posY=this.posY-4*spid
    elseif this.hurt=='d' then this.posY=this.posY+4*spid
    end
    this.hurtIndex=this.hurtIndex-1
    if this.move==false then 
      makeItBleed(player)
      return 
    end
    makeItBleed(this)
    if this.hurtIndex==0 and this.health then this.health=this.health-1 end
    return
  end
  local tX,tY,tW,tH=this.posX,this.posY,this.wid,this.hei
  local tT,tB,tL,tR=tY-tH/2,tY+tH/2,tX-tW/2,tX+tW/2
  if tR>x and tL<x+w and tB>y+h/3 and tT<y+h then 
    this.move=false
    if hurt<=0 then 
      hurtMe(this.difficult) 
      if tX>=x and tX<=x+w then
        if tY>y+h then return 'd' else return 'u' end
      else
        if tX>x+w then return 'r' else return 'l' end
      end
    end
  else this.move=true end
  if spindex==2 then
    if player.dir=='l' and tR>x-sword.hei*.8 and tL<x+w and tB>y and tT<y+h 
    or player.dir=='r' and tR>x and tL<x+sword.hei*.8+w and tB>y and tT<y+h
    or player.dir=='u' and tR>x and tL<x+w and tB>y-sword.hei*.2 and tT<y+h
    or player.dir=='d' and tR>x and tL<x+w and tB>y and tT<y+h-sword.hei then
      return player.dir
    end
  end
end
