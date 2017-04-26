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
    playerData.difici=0
    playerData.health=3
    mapFile = love.filesystem.newFile("playerData")
    serialize ('playerData',playerData)
    return startTable()
   end
end
--generates details for maps
function createMap()
  local t={}
  enem={}
  if  map['4241']==nil and map['4243']==nil and map['4142']==nil and map['4342']==nil then
    t.type='grove'
    t.contains='dangerAlone'
    else  
      t.type='forest'
    t.enem={}
    if playerData.difici==1 then
      t.enem[1]=enemy('easy')
      t.enem[2]=enemy('easy')
    elseif playerData.difici==0 then
      t.enem[1]=enemy('easy')
      playerData.difici=1
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
      tabbb=tabbb..'["'..k..'"]='..srlz(v)..','
    end
    tabbb=tabbb..'}'
  elseif type(datas)=='number' then
    tabbb=datas
  elseif type(datas)=='string' then
    tabbb=string.format("%q",datas)
  else
    tabbb=datas()
  end
  return tabbb
end
function serialize (save,o)
  local tab=save.."="..srlz(o)
  love.filesystem.write(save,tab,all)
end
