function startTable()--initiates saves if one doesn't exist
  if love.filesystem.isFile('map') then
    love.filesystem.load('map')()
  else
    local u={}
    u['4242']={}
    u['4242'].type='forest'
    u['4242'].contains='start'
    local e={}
    mapFile = love.filesystem.newFile("map")
    serialize ('map',u)
    return startTable()
  end
   if love.filesystem.isFile('playerData') then love.filesystem.load('playerData')() else
    playerData={}
    playerData.whichUko = 'hikerDude'
    playerData.size=1
    playerData.speed=1
    playerData.weapon=0
    playerData.swordCool=12
    playerData.difici=1
    playerData.enemDead=0
    playerData.health=3
    mapFile = love.filesystem.newFile("playerData")
    serialize ('playerData',playerData)
    return startTable()
   end
end
--generates details for maps
function createMap()
  local mapX = tonumber(mapLocale:sub(1,2))
  local mapY = tonumber(mapLocale:sub(3,4))
  local t={}
  if mapX<=32 then t.doorBlock='l' elseif mapX>=52 then t.doorBlock='r' else t.doorBlock='' end
  if mapY<=32 then t.doorBlock=t.doorBlock..'u' elseif mapY>=52 then t.doorBlock=t.doorBlock..'d' elseif t.doorBlock=='' then t.doorBlock=nil end 
  if  map['4241']==nil and map['4243']==nil and map['4142']==nil and map['4342']==nil then
    t.type='grove'
    t.contains='dangerAlone'
  else
    t.type='forest'
    t.enem={}
    local dbl=false
    if math.random(3)>=2 then 
      t.obs={}
      t.obs={}
      t.obs.obj=obstacles.options[math.random(#obstacles.options)]
      t.obs.posX,t.obs.posY=math.random(width*.2,width*.8),math.random(height*.2,height*.8)
      local size=math.random(.85,1.05)*width*.1
      t.obs.wid,t.obs.hei=size,size
    end
    for i=1,math.random(playerData.difici) do
      if math.random(100)>math.floor(playerData.difici/2)^2 then
        t.enem[i]=enemy('easy')
      else
        t.enem[i]=enemy('hard')
        dbl=true
      end
      if type(t.enem[i])=='table' then
        local enemmm=t.enem[i][1]
        for j=0,t.enem[i][2]-1 do
          t.enem[j*100+i]=enemmm
        end
      end
      if dbl then i=i+2 end
    end
    t.contains='none'
  end
  map[mapLocale]=t
end
--this saves stuff, but be careful what you feed it it isn't universal (and i don't need it to be)
function srlz(datas)
  if map then for i in pairs(map) do
    map[i].enemies=nil
    map[i].blood=nil
    map[i].bloodI=nil
  end end
  local tabbb=''
  if type(datas)=='table' then
    tabbb='{'
    for k,v in pairs(datas) do
      if k~='pic' then
        tabbb=tabbb..'["'..k..'"]='..srlz(v)..','
      end
    end
    tabbb=tabbb..'}'
  elseif type(datas)=='number' then
    tabbb=math.floor(datas)
  elseif type(datas)=='string' then
    tabbb=string.format("%q",datas)
  elseif type(datas)=='boolean' then
    if datas then tabbb='true' else tabbb='false' end
  else
    tabbb=datas()
  end
  return tabbb
end
function serialize (save,o)
  local tab=save.."="..srlz(o)
  love.filesystem.write(save,tab,all)
end
