function enemy(input)
  if enemyList==nil then
    enemyList={}
    enemyList.hard={}
    enemyList.hard['1']=eemeli
    enemyList.hard.index=1
    enemyList.easy={}
    enemyList.easy[1]=jared
    enemyList.easy[2]=albert
    enemyList.boss={}
    enemyList.boss['1']=quinn
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
function jared(this,dt)
  if not this then return "jared" end
  if jaredT then
    if enemies[this] then  
      if enemies[this].health==-1 then return end
      if dt then
        if enemies[this].health==0 then
          dropShit(enemies[this])
          return
        end
        enemies[this].noGo=''
        if enemies[this].hurtIndex<=0 then enemies[this].hurt=checkSword(enemies[this]) if enemies[this].hurt~=nil then enemies[this].hurtIndex=10 end end
        local spid=dt*width/30
        if math.random(50)>49 then
          if enemies[this].dir=='d' or enemies[this].dir=='u' then
            if math.random(2)>1 then enemies[this].dir='l' else enemies[this].dir='r' end
          else
            if math.random(2)>1 then enemies[this].dir='u' else enemies[this].dir='d' end
          end
        end
        if enemies[this].hurtIndex<=0 then
          enemies[this].curdir=enemies[this].dir
          local nono=enBind(enemies[this])
          if nono=='u' then enemies[this].curdir='d' 
          elseif nono=='d' then enemies[this].curdir='u' 
          elseif nono=='r' then enemies[this].curdir='l' 
          elseif nono=='l' then enemies[this].curdir='r' end
          movePlayer(enemies[this],dt)
        else
          checkSword(enemies[this],dt)
        end
        if enemies[this].dir=='l' or enemies[this].dir=='r' then enemies[this].wid=w*.75 else enemies[this].wid=w*1.4 end
        enemies[this].pic=walk(enemies[this],jaredT)
      else
        return enemies[this]
      end
    else
      enemies[this]={}
      enemies[this].posX,enemies[this].posY=width/2,height/2
      enemies[this].wid,enemies[this].hei=w*1.5,h*.8
      enemies[this].health=4
      enemies[this].hurt,enemies[this].hurtIndex='',0
      enemies[this].dir=directions[math.random(4)]
      enemies[this].move=true
      enemies[this].mov='s1'
      enemies[this].pic=jaredT.d
      enemies[this].speed=width/10
      enemies[this].r,enemies[this].g,enemies[this].b,enemies[this].a=150,150,175,255
      return jared(this)
    end
  else
    jaredT={}
    jaredT.speed=width/8
    jaredT.d=love.graphics.newImage('enemies/jaredDown.png')
    jaredT.d1=love.graphics.newImage('enemies/jaredDown1.png')
    jaredT.d2=love.graphics.newImage('enemies/jaredDown2.png')
    jaredT.u=love.graphics.newImage('enemies/jaredUp.png')
    jaredT.u1=love.graphics.newImage('enemies/jaredUp1.png')
    jaredT.u2=jaredT.u
    jaredT.l=love.graphics.newImage('enemies/jaredLeft.png')
    jaredT.l1=love.graphics.newImage('enemies/jaredLeft1.png')
    jaredT.l2=jaredT.l
    jaredT.r=love.graphics.newImage('enemies/jaredRight.png')
    jaredT.r1=love.graphics.newImage('enemies/jaredRight1.png')
    jaredT.r2=jaredT.r
    return jared(this)
  end  
end
function eemeli()
end
function albert(this,dt)
  if not this then return "albert" end
  if albertT then
    if enemies[this] then
      if enemies[this].health==-1 then return end
      if dt then
        if enemies[this].health==0 then
          dropShit(enemies[this])
          return
        end
        if enemies[this].hurtIndex<=0 then enemies[this].hurt=checkSword(enemies[this]) if enemies[this].hurt~=nil then enemies[this].hurtIndex=10 end end
        local spid=albertT.speed/2*dt
        if string.match(player.mov,'m') then  spid=spid*2 end
        enemies[this].size=enemies[this].size+math.pi/6
        if enemies[this].hurtIndex<=0 then
          if enemies[this].posX<x+(w/2) then enemies[this].posX=enemies[this].posX+spid else enemies[this].posX=enemies[this].posX-spid end
          if enemies[this].posY<y+(h/2) then enemies[this].posY=enemies[this].posY+spid else enemies[this].posY=enemies[this].posY-spid end
          enemies[this].posX,enemies[this].posY=enemies[this].posX+math.random(-spid,spid),enemies[this].posY+math.random(-spid,spid)
        else
          checkSword(enemies[this],dt)
          if enemies[this].move~=false then enemies[this].wid,enemies[this].hei=enemies[this].wid*.99,enemies[this].hei*.99 end
        end
        enemies[this].wid,enemies[this].hei=enemies[this].wid+math.sin(enemies[this].size),enemies[this].hei+math.sin(enemies[this].size)
      else
        return enemies[this]
      end
    else
      enemies[this]={}
      enemies[this].posX,enemies[this].posY=math.random(width*.8)+width*.1,math.random(height*.8)+height*.1
      enemies[this].size=math.pi/6
      enemies[this].wid,enemies[this].hei=w*.8,h*.5
      enemies[this].health=3
      enemies[this].hurt,enemies[this].hurtIndex='',0
      enemies[this].move=true
      enemies[this].pic=albertT.pic
      enemies[this].r,enemies[this].g,enemies[this].b,enemies[this].a=50,155,50,255
      return albert(this)
    end
  else
    albertT={}
    albertT.speed=width/10
    albertT.pic=love.graphics.newImage('enemies/albert.png')
    return albert(this)
  end
end
function makeItBleed(this)
  blood[map[mapLocale].bloodI]={}
  blood[map[mapLocale].bloodI].pic=bloody
  blood[map[mapLocale].bloodI].posX,blood[map[mapLocale].bloodI].posY=this.posX+math.random(-width/30,width/30),this.posY+math.random(-width/30,width/30)
  if this~=player then blood[map[mapLocale].bloodI].wid,blood[map[mapLocale].bloodI].hei=w/3,w/3 else blood[map[mapLocale].bloodI].wid,blood[map[mapLocale].bloodI].hei=w/2,w/2 end
  map[mapLocale].bloodI=map[mapLocale].bloodI+1
end
function dropShit(this)
  if this.dropIndex then
    if distance(this.posX,this.posY,player.posX,player.posY-(w/2))<=w/2 or this.dropIndex<=0 then
      if this.pic==heartDrop then
        health=health+1
        if health>playerData.health then health=playerData.health end
      end
      this.health=-1
    end
    this.wid,this.hei=this.wid+(this.wid/50)*math.sin(this.dropIndex),this.hei+(this.hei/50)*math.sin(this.dropIndex)
    this.dropIndex=this.dropIndex-math.pi/20
  else
    local drop={heartDrop}
    if math.random(10)==10 then 
      this.pic=drop[math.random(#drop)]
      if this.pic==heartDrop then
        this.wid,this.hei=width/25,width/25
        this.r,this.g,this.b=175,125,125
      end
    else
      this.health=-1
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
    if this.hurtIndex==0 then this.health=this.health-1 end
    return
  end
  local tX,tY,tW,tH=this.posX,this.posY,this.wid,this.hei
  local tT,tB,tL,tR=tY-tH/2,tY+tH/2,tX-tW/2,tX+tW/2
  if tR>x and tL<x+w and tB>y+h/3 and tT<y+h then 
    this.move=false
    if hurt<=0 then 
      hurtMe() 
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
