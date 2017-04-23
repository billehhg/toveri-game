function enemy(input)
	if enemyList==nil then
		enemyList={}
		enemyList.hard={}
		enemyList.hard['1']=eemeli
		enemyList.hard.index=1
		enemyList.easy={}
		enemyList.easy[1]=albert   -- jared
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
function moveEnemies(dt) for i in pairs(map[mapLocale].enemies) do map[mapLocale].enemies[i](i,dt) end end
function jared()
end
function eemeli()
end
function albert(this,dt)
	if not this then return "albert" end
	if albertT then
		if enemies[this] then
			if enemies[this].health==0 then return end
			if dt then
				if enemies[this].hurtIndex<=0 then enemies[this].hurt=checkSword(enemies[this]) if enemies[this].hurt~=nil then enemies[this].hurtIndex=10 end end
				local spid=albertT.speed/2*dt
				if string.match(mov,'m') then  spid=spid*2 end
				enemies[this].size=enemies[this].size+math.pi/6
				if enemies[this].hurtIndex<=0 then
					if enemies[this].posX<x+(w/2) then enemies[this].posX=enemies[this].posX+spid else enemies[this].posX=enemies[this].posX-spid end
					if enemies[this].posY<y+(h/2) then enemies[this].posY=enemies[this].posY+spid else enemies[this].posY=enemies[this].posY-spid end
					enemies[this].posX,enemies[this].posY=enemies[this].posX+math.random(-spid,spid),enemies[this].posY+math.random(-spid,spid)
				else
					if enemies[this].hurt=='l' then enemies[this].posX=enemies[this].posX-4*spid
					elseif enemies[this].hurt=='r' then enemies[this].posX=enemies[this].posX+4*spid
					elseif enemies[this].hurt=='u' then enemies[this].posY=enemies[this].posY-4*spid
					elseif enemies[this].hurt=='d' then enemies[this].posY=enemies[this].posY+4*spid
					end
					enemies[this].hurtIndex=enemies[this].hurtIndex-1
					if enemies[this].move==false then return end
					enemies[this].wid,enemies[this].hei=enemies[this].wid*.99,enemies[this].hei*.99
					if enemies[this].hurtIndex==0 then enemies[this].health=enemies[this].health-1 end
				end
			end
			return albertT.pic,enemies[this].posX,enemies[this].posY,enemies[this].wid+math.sin(enemies[this].size)*1,enemies[this].hei+math.sin(enemies[this].size)*1
		else
			enemies[this]={}
			enemies[this].posX,enemies[this].posY=math.random(width*.8)+width*.1,math.random(height*.8)+height*.1
			enemies[this].size=math.pi/6
			enemies[this].wid,enemies[this].hei=w*.8,h*.5
			enemies[this].health=5
			enemies[this].hurt,enemies[this].hurtIndex='',0
			enemies[this].move=true
			return albert(this)
		end
	else
		albertT={}
		albertT.speed=width/8
		albertT.pic=love.graphics.newImage('enemies/albert.png')
		return albert(this)
	end
end
function checkSword(this)
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
		if dir=='l' and tR>x-sword.hei*.8 and tL<x+w and tB>y and tT<y+h 
		or dir=='r' and tR>x and tL<x+sword.hei*.8+w and tB>y and tT<y+h
		or dir=='u' and tR>x and tL<x+w and tB>y-sword.hei*.2 and tT<y+h
		or dir=='d' and tR>x and tL<x+w and tB>y and tT<y+h-sword.hei then
			return dir
		end
	end
end
