--
-- Author: Paul
-- Date: 2015-07-27 14:46:15
--
local FightingLayer = class("FightingLayer", function ( initParam )
	local node = newCsb(initParam.parent, "FightingLayer.csb", {type = "allListen", swallow = false}, false)
		-- local node = newCsb(initParam.parent, "BagLayer.csb", nil, false)
	-- node:setAnchorPoint(cc.p(0.5,0.5))
	-- node:setPosition(0, 200)
	-- node:setScale(0.5)

	return node
end)

local __state__attack__ = 0
local __state__item__ = 1
local __state__skill__ = 2

function FightingLayer:ctor(initParam)
	print("BagLayer create", initParam.parent)
	self.parent = initParam.parent;
	self.grandParent = initParam.parent.parent
	initParam.parent:hideTools()
	self.panelEnemy.parent = self
	self.ctrlState = __state__attack__
	self.data = {
		weather = getWeather(),
		zhenxing = 1,
		duifangzhenxing = 1,
		chengfang = 1,
	}



	local nAllHeight = self.panelEnemy:getContentSize().height
	local nAllWidth = self.panelEnemy:getContentSize().width

	self.heroList ={}

	for i=0,4 do
		local hero1 = gLobbyLogic:createFightItemNode({parent = self.panelEnemy, index = i + 1 , id = i + 1, clickEvent = self.onHeroEvent})
		hero1:setPosition(cc.p(nAllWidth * 0.72, nAllHeight * (0.88 - 0.195 * i)))
		-- hero1:selectAction()
		self.heroList[#self.heroList + 1] = hero1
		-- hero1:setPosition(100 , 100 + 100 * i)
		-- hero1:setPositionPercent(cc.p(nAllWidth * 0.80, nAllHeight * (0.88 - 0.18 * i)))
	end

	-- self.heroList[1]:addArrow(4)
	-- self.heroList[2]:addArrow(3)
	-- self.heroList[3]:addArrow(4)
	-- self.heroList[4]:addArrow(1)
	-- self.heroList[5]:addArrow(4)

	self.enemyList = {}

	for i=0,4 do
		local hero1 = gLobbyLogic:createFightItemNode({parent = self.panelEnemy, index = i + 1, id = i + 1 , isEnemy = true, clickEvent = self.onHeroEvent})
		hero1:setPosition(cc.p(nAllWidth * 0.28, nAllHeight * (0.88 - 0.195 * i)))
		self.enemyList[#self.enemyList + 1] = hero1

		-- hero1:setEnemy()
		-- hero1:selectAction()
		-- hero1:setPosition(100 , 100 + 100 * i)
		-- hero1:setPositionPercent(cc.p(nAllWidth * 0.80, nAllHeight * (0.88 - 0.18 * i)))
	end

	-- for i=0,4 do
	-- 	local hero1 = gLobbyLogic:createFightItemNode({parent = self.panelEnemy, index = 5+i + 1})
	-- 	hero1:setPosition(cc.p(nAllWidth * 0.14, nAllHeight * (0.88 - 0.195 * i)))
	-- 	hero1:setEnemy()
	-- 	hero1:selectAction()
	-- 	-- hero1:setPosition(100 , 100 + 100 * i)
	-- 	-- hero1:setPositionPercent(cc.p(nAllWidth * 0.80, nAllHeight * (0.88 - 0.18 * i)))
	-- end

	self.ctrlIndex = 1
	self.ctrlIndexMax = 5
	self.heroCtrlList = {}

	self:getCtrlInfo()


	-- 初始化 天气
	self.labelWeather:setString(self.data.weather.text)
	if self.data.weather.color then
		self.labelWeather:setColor(self.data.weather.color)
	end

-- 0.88
-- 0.69
-- 0.5
-- 0.31
-- 0.12
-- self:addChild(hero1)
end

function FightingLayer:delAllArrow()
	for i,heroItem in ipairs(self.heroList) do
		heroItem:delArrow()
	end
end

function FightingLayer:getCtrlInfo()
	print("FightingLayer:getCtrlInfo()",self.ctrlIndexMax , self.ctrlIndex)
	-- 先判断是否选择结束  结束直接跳到  showFightAni
	if self.ctrlIndexMax < self.ctrlIndex then
		self.heroList[self.ctrlIndexMax]:notAhead()
		self:delAllArrow()
		self:calcFightData()
		
		return
	end

	if self.ctrlIndex > 1 then
		self.heroList[self.ctrlIndex - 1]:notAhead()
	end

	self.heroList[self.ctrlIndex]:ahead()
	if self.ctrlState == __state__attack__ then
		self:enemySelect()
	end
	-- for i=1, 5 do
	-- end
end

function FightingLayer:getEnemyCtrlList()
	local rtList = {}
	for tag, enemy in ipairs(self.enemyList) do
		if not enemy:isDead() then
			rtList[#rtList + 1] = 
			{
				srcTag = tag,
				speed = enemy:getSpeed()
			}
		end
	end

	return rtList
end

function FightingLayer:calcFightData()
	-- 获得出手顺序列表
	-- local enemyCtrlList = self:getEnemyCtrlList()
	-- local ctrlOrderList = clone(enemyCtrlList)

	-- for i, v in ipairs(self.heroCtrlList) do
	-- 	table.insert(ctrlOrderList, clone(v))
	-- end

	-- table.sort(ctrlOrderList, function (a, b)
	-- 	return a.speed > b.speed
	-- end)

	-- for i,v in ipairs(ctrlOrderList) do
	-- 	print(i,v)
	-- end

	self:showFightAni()
end

function FightingLayer:showFightAni()
	-- 获得出手顺序列表
	local enemyCtrlList = self:getEnemyCtrlList()
	local ctrlOrderList = clone(enemyCtrlList)

	for i, v in ipairs(self.heroCtrlList) do
		table.insert(ctrlOrderList, clone(v))
	end

	table.sort(ctrlOrderList, function (a, b)
		return a.speed > b.speed
	end)


	dump(ctrlOrderList, "ctrlOrderList", 8)

	local ctrlAllList = {}
	local tmpState = ctrlOrderList[1].ctrlState
	local tmpList = {}
	for i,v in ipairs(ctrlOrderList) do
		if v.ctrlState == tmpState then
			if tmpState == nil or tmpState == __state__attack__ then
				tmpList[#tmpList + 1] = v
			else
				ctrlAllList[#ctrlAllList + 1] = clone(tmpList)
				tmpList = {}
				tmpList[#tmpList + 1] = v
			end
		else
			ctrlAllList[#ctrlAllList + 1] = clone(tmpList)
			tmpList = {}
			tmpList[#tmpList + 1] = v
			tmpState = v.ctrlState
		end
	end

	if #tmpList >= 1 then
		ctrlAllList[#ctrlAllList + 1] = clone(tmpList)
		tmpList = {}
	end

	dump(ctrlAllList, "ctrlAllList", 8)

	function fightItem (index)
		-- local ctrlInfo = self.heroCtrlList[index]
		local ctrlInfos = ctrlAllList[index]
		if ctrlInfos then
			for i=1, #ctrlInfos do
				print("level:"..i.."  start...")
				ctrlInfo = ctrlInfos[i]
				if ctrlInfo.ctrlState ~= nil then
					-- 我方英雄
					if ctrlInfo.ctrlState == __state__attack__ then	-- 攻击判定
						self.heroList[ctrlInfo.srcTag]:attack(self.enemyList[ctrlInfo.desTag], function (info)
							if info then print("info.att", info.att, info.isHit) end
							self.enemyList[ctrlInfo.desTag]:beAttack(self.heroList[ctrlInfo.srcTag], info, function ()
								if i == 1 then
									fightItem(index + 1)
								end
							end)
						end)
					end
				else
					-- 敌方英雄   目前先随意攻击
						self.enemyList[ctrlInfo.srcTag]:attack(self.heroList[1],function (info)
							if info then print("info.att", info.att, info.isHit) end
							self.heroList[1]:beAttack(self.enemyList[ctrlInfo.srcTag], info, function ()
								if i == 1 then
									fightItem(index + 1)
								end
							end)
						end
						)
				end
				print("level:"..i.."  end...")
			end

			for i=1,10 do
				print(i)
			end

			-- if ctrlInfo.ctrlState ~= nil then
			-- 	-- 我方英雄
			-- 	if ctrlInfo.ctrlState == __state__attack__ then	-- 攻击判定
			-- 		self.heroList[ctrlInfo.srcTag]:attack(self.enemyList[ctrlInfo.desTag], function (info)
			-- 			self.enemyList[ctrlInfo.desTag]:beAttack(self.heroList[ctrlInfo.srcTag], function ()
			-- 				fightItem(index + 1)
			-- 			end)
			-- 		end)
			-- 	end
			-- else
			-- 	-- 敌方英雄   目前先随意攻击
			-- 		self.enemyList[ctrlInfo.srcTag]:attack(self.heroList[1],function ()
			-- 			self.heroList[1]:beAttack(self.enemyList[ctrlInfo.srcTag], function ()
			-- 				fightItem(index + 1)
			-- 			end)
			-- 		end
			-- 		)
			-- end
		else
			print("the  new  role-----")
			self.ctrlIndex = 1
			self.heroCtrlList = {}
			self:getCtrlInfo()
		end
	end

	fightItem(1)
end

function FightingLayer:onHeroEvent(isHero, tag)
	print("onHeroEvent", isHero, tag)
	self.heroCtrlList[#self.heroCtrlList + 1] = 
	{
		ctrlState = __state__attack__,
		isHero = isHero,
		desTag = tag,
		srcTag = self.ctrlIndex,
		speed = self.heroList[self.ctrlIndex]:getSpeed()
	}

	self.heroList[self.ctrlIndex]:addArrow(tag)
	self.ctrlIndex = self.ctrlIndex + 1
	self:allSelect(false)
	self:getCtrlInfo()
end

function FightingLayer:enemySelect(isSelect)
	for i, enemyItem in ipairs(self.enemyList) do
		if isSelect == false then
			enemyItem:stopSelectAction()
		else
			enemyItem:selectAction()
		end
	end
end

function FightingLayer:heroSelect(isSelect)
	for i, heroItem in ipairs(self.heroList) do
		if isSelect == false then
			heroItem:stopSelectAction()
		else
			heroItem:selectAction()
		end
	end
end

function FightingLayer:allSelect(isSelect)
	self:enemySelect(isSelect)
	self:heroSelect(isSelect)
end

function FightingLayer:onPressAtt(event)
	if event.name == "began" then

	elseif event.name == "ended" then
		self.ctrlState = __state__attack__
	end
end


function FightingLayer:initView()
	
end

return FightingLayer