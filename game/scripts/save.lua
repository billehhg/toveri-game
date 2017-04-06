function startTable()--initiates saves if one doesn't exist
	if love.filesystem.isFile('map') then
		love.filesystem.load('map')()
	else
		local u={}
		u['4242']={}
		u['4242'].type='forest'
		u['4242'].contains='start'
		mapFile = love.filesystem.newFile("map")
		serialize ('map',u)
		return startTable()
	end
 	if love.filesystem.isFile('playerData') then love.filesystem.load('playerData')() else
		playerData={}
		playerData.whichUko = 'pepsoGirl'
		playerData.size=1
		playerData.speed=1
		playerData.weapon=0
		mapFile = love.filesystem.newFile("playerData")
		serialize ('playerData',playerData)
		return startTable()
 	end
end

--generates details for maps
function createMap()
	local t={}
	if  map['4241']==nil and map['4243']==nil and map['4142']==nil and map['4342']==nil then
		t.type='grove'
		t.contains='dangerAlone'
  	else	
  		t.type='forest'
  		t.contains='none'
  	end
  map[mapLocale]=t
end

--this saves stuff, but be careful what you feed it it isn't universal (and i don't need it to be)
function serialize (save,o)
	local tab=save.."={"
	for k,v in pairs(o)	do
		tab=tab..'["'..k..'"]='
		if type(v)=='table' then
			tab=tab..'{'
			for kk,vv in pairs(v)	do
				tab=tab..kk.."="
				if type(kk) == 'number' then
					tab=tab..kk
				elseif type(kk) == 'string' then
					tab=tab..string.format("%q",vv)
				end
				tab=tab..","
			end
			tab=tab.."}"
		elseif type(v) == 'number' then
			tab=tab..v
		elseif type(v) == 'string' then
			tab=tab..string.format('%q',v)
		end
		tab=tab..','
	end
	tab=tab.."}"
	love.filesystem.write(save,tab,all)
end
