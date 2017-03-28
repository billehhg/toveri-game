function startTable()
	if love.filesystem.isFile('map') then
		love.filesystem.load('map')()
	else
		local u={}
		local t={}
		t.type='forest'
		t.special='start'
		u['loc4242']=t
		mapFile = love.filesystem.newFile("map")
		serialize (u)
		dangerAlone=true
		return startTable()
	end
end
function createMap(locale)
	local t={}
	if  dangerAlone then
    	t.type='grove'
    	t.special='dangerAlone'
    	dangerAlone=false
  else
  	t.type='forest'
  	t.special='none'
  end
  map[locale]=t
end
function serialize (o)
	local tab="map={"
	for k,v in pairs(o)	do
		tab=tab..k.."={"
		for kk,vv in pairs(v)	do
			tab=tab..kk.."="
			if type(kk) == 'number' then
				tab=tab..kk
			elseif type(kk) == 'string' then
				tab=tab..string.format("%q",vv)
			end
			tab=tab..","
		end
		tab=tab.."},"
	end
	tab=tab.."}"
	love.filesystem.write('map',tab,all)
end