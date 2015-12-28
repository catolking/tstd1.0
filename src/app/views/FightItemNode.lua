--
-- Author: Paul
-- Date: 2015-07-30 22:22:51
--

local FightItemNode = class("FightItemNode", function ( initParam )
	local node = newCsb(initParam.parent, "FightItemNode.csb", {--[[type = "allListen", swallow = false--]]}, false)
	-- local node = newCsb(initParam.parent, "BagLayer.csb", nil, false)
	-- node:setAnchorPoint(cc.p(0.5,0.5))
	-- node:setPosition(0, 200)
	-- node:setScale(0.5)
	return node
end)


function FightItemNode:ctor(initParam)
	self.isEnemy = initParam.isEnemy
	self.parent = initParam.parent
	self.grandParent = initParam.parent.parent
	self.index = initParam.index
	self.clickEvent = initParam.clickEvent
	if self.isEnemy then
		self.baseData = gLobbyLogic.enemyInfo[initParam.id]
	else
		self.baseData = gLobbyLogic.heroInfo[initParam.id]
	end
	self.hero = gLobbyLogic:createModelHero(self.baseData)
	self.heroIconIndex = self.hero:getIcon()
	-- local nRnd = math.random(15)
	-- print("nRnd", nRnd , self.heroIconIndex)

	if self.isEnemy then self:setEnemy() end

	self.nodeLabel = display.newNode()

	-- self:selectAction()
	self.spriteHero:setFlipX(self.isEnemy)
	self:stateNormal()
	self.hurtActionList = {}
	self:updateHp()
end

function FightItemNode:updateHp()
	-- self.labelHP:setString(self.hero:getMaxHp())
	self.labelHP:setString(self.hero:getCurrentHp())

	local nRnd = self.hero:getHPPercent()
	print("nRnd=========", nRnd, self.hero:getCurrentHp(),  self.hero:getMaxHp())
	nRnd = nRnd * 100
	if nRnd == 0 then
	elseif nRnd < 20  then
		self.spriteHp:setContentSize(20, 16)
		local nScaleNum = (0.25 + nRnd/20) /1.25
		self.spriteHp:setScaleX(nScaleNum)
	else
		self.spriteHp:setContentSize(1.5 * nRnd , 16) 
		self.spriteHp:setScale(1)
	end

		
	

end

function FightItemNode:setEnemy()
	self.spriteHero:setAnchorPoint(cc.p(0, 0))
	self.spriteHero:setPosition(cc.p(109, -20))
	self.spriteSelect:setPosition(cc.p(122, 33))
	self.labelHP:setPosition(cc.p(40, 15))
	self.labelName:setPosition(cc.p(-45, 15))
	-- self.labelHPTip:setPosition(cc.p(-25, 0))
end

function FightItemNode:showAni(nType, callBack)
	if self.spriteAni == nil or self.spriteAni.getPosition == nil then
		self.spriteAni = nil
		self.spriteAni = display.newSprite()
		self.spriteHero:addChild(self.spriteAni)
		self.spriteAni:setPosition(cc.p(self.spriteHero:getContentSize().width/2+ 5,self.spriteHero:getContentSize().height/2 + 10))
	else
		self.spriteAni:setVisible(true)
	end

	-- self.spriteAni:stopAllActions()

	local strAniName = "lei"
	if  math.random(100) < 50 then
		strAniName = "bing"
	end

	local completeFunc = function ()
		self.spriteAni:setVisible(false)
		if callBack then
			callBack()
		end
	end

	self.spriteAni:playAnimationOnce(display.getAnimationCache(strAniName), {onComplete = completeFunc})
end	

-- 常规动作
function FightItemNode:stateNormal()
	-- self.spriteHero:stopAllActions()
	self:stopSelectAction()
	local nActionTag = 2
	-- if self.isEnemy then
	-- 	nActionTag = 3
	-- end
	local action = self.spriteHero:playAnimationForever(display.getAnimationCache(string.format("hero_%d_%d",self.heroIconIndex, nActionTag)))
	action:setTag(111)
end

-- 闪避
function FightItemNode:duck(callBack)
	local nMoveXDiff = 25
	if self.isEnemy then
		nMoveXDiff = -25
	end

	local actions = {}
	actions[#actions + 1] = cc.MoveBy:create(0.15, cc.p(nMoveXDiff, 0))
	actions[#actions + 1] = cc.DelayTime:create(0.25)
	actions[#actions + 1] = cc.MoveBy:create(0.15, cc.p(-1*nMoveXDiff, 0))
	actions[#actions + 1] = cc.CallFunc:create(function() 
		if callBack then
			callBack()
		end
	end)

	self.spriteHero:runAction(transition.sequence(actions))
end

-- 出列
function FightItemNode:ahead(callBack, delayTime)
	local nMoveXDiff = -30
	if self.isEnemy then
		nMoveXDiff = 30
	end

	local actions = {}
	if delayTime ~= nil then
		actions[#actions + 1] = cc.DelayTime:create(delayTime)
	end
	actions[#actions + 1] = cc.MoveBy:create(0.15, cc.p(nMoveXDiff, 0))
	actions[#actions + 1] = cc.CallFunc:create(function() 
		if callBack then
			callBack()
		end
		if delayTime ~= nil then
			local tmpActions = {}
			tmpActions[#tmpActions + 1] = cc.DelayTime:create(2)
			tmpActions[#tmpActions + 1] = cc.CallFunc:create(function()
				self:notAhead()
			end)
			self:runAction(transition.sequence(tmpActions))
		end 
	end)

	self.spriteHero:runAction(transition.sequence(actions))
end

-- 退列
function FightItemNode:notAhead(callBack, delayTime)
	local nMoveXDiff = 30
	if self.isEnemy then
		nMoveXDiff = -30
	end

	local actions = {}
	if delayTime ~= nil then
		actions[#actions + 1] = cc.DelayTime:create(delayTime)
	end
	actions[#actions + 1] = cc.MoveBy:create(0.15, cc.p(nMoveXDiff, 0))
	actions[#actions + 1] = cc.CallFunc:create(function() 
		if callBack then
			callBack()
		end
	end)
	self.spriteHero:runAction(transition.sequence(actions))
end

function FightItemNode:onPressHero()
	self.clickEvent(self.grandParent, not self.isEnemy, self.index)
end

function FightItemNode:delArrow()
	self.spriteArrow:setVisible(false)
end

function FightItemNode:addArrow(nIndex)
	-- if initParam == nil or initParam.pos == nil then return end

	local nIndexTmp = self.index - nIndex

	if self.spriteArrow == nil or self.spriteArrow.getPosition == nil then
		self.spriteArrow = nil
		self.spriteArrow = display.newSprite("images/common/ArrowRed.png")
		self.spriteArrow:setOpacity(100)
		self:addChild(self.spriteArrow)
		self.spriteArrow:setPosition(-145, 0)
		self.spriteArrow:setAnchorPoint(cc.p(1, 0.5))
	else
		self.spriteArrow:setVisible(true)
	end

	local nHeight = self.parent:getContentSize().height * 0.195

	-- for i=1, 5 do
		-- local spriteArrow = nil
		-- spriteArrow = display.newSprite("images/common/ArrowRed.png")
		-- self:addChild(spriteArrow)
		-- spriteArrow:setPosition(-145, 0)
		-- spriteArrow:setAnchorPoint(cc.p(1, 0.5))

		-- local nAngle = math.asin((3 - i) * nHeight/ 140)
		-- local nAngle = math.sin(0.3*i)
		local nAngle = math.atan2(nIndexTmp * nHeight , 140) / math.pi * 180
		local nLen = ((nIndexTmp * nHeight) ^ 2 + 140 ^ 2) ^ 0.5 / 108

		self.spriteArrow:setScaleX(nLen)
		self.spriteArrow:setRotation(nAngle)
	-- end
end

function FightItemNode:showHurt(actionInfo)





	if actionInfo ~= nil then
		-- actionInfo.actions[#actionInfo.actions + 1] = cc.DelayTime:create(0.3)
		-- actionInfo.actions[#actionInfo.actions + 1] = cc.CallFunc:create(function ()
		-- 	table.remove(self.hurtActionList, 1)
		-- 	self:showHurt()
		-- 	actionInfo.target:removeFromParent()
		-- end)
		local target = actionInfo.target

		self.hurtActionList[#self.hurtActionList + 1] = actionInfo
		print("____________即将进行动作。。。。", self.isEnemy, self.index, #self.hurtActionList)
		if #self.hurtActionList > 1 then
			-- 有伤害文字正在运行
			print"老实添加..."
			self.hurtActionList[#self.hurtActionList] = actionInfo
		else
			print"直接运行..."


			local actionList = {
				cc.FadeIn:create(0),
				cc.MoveBy:create(0.15, cc.p(0, 15)),
				cc.CallFunc:create(function ()
					self:showHurt()
				end),
				cc.MoveBy:create(0.3, cc.p(0, 30)),
				cc.FadeOut:create(0.6),
				cc.CallFunc:create(function ()
					target:removeFromParent()
				end)
				-- cc.DelayTime:create(0.3),
			}

			self.hurtActionList[1].target:runAction(transition.sequence(actionList))
			-- self.hurtActionList[1].target:runAction(transition.sequence(self.hurtActionList[1].actions))
			-- nLabel:runAction(transition.sequence(actionList))
		end
	else
		print(self.isEnemy, self.index, "伤害动画结束",#self.hurtActionList)
		-- print(self.hurtActionList[1])
		-- print(self.hurtActionList[1].target)
		-- print(self.hurtActionList[1].target.getPosition)

		self.hurtActionList[1].target:removeFromParent()
		table.remove(self.hurtActionList, 1)


		if #self.hurtActionList >= 1 then
			-- dump(self.hurtActionList[1].actions, "self.hurtActionList[1].actions", 7)
			-- 有伤害文字正在运行

			local target = self.hurtActionList[1].target

			local actionList = {
				cc.FadeIn:create(0),
				cc.MoveBy:create(0.3, cc.p(0, 30)),
				cc.CallFunc:create(function ()
					self:showHurt()
				end),
				cc.MoveBy:create(0.5, cc.p(0, 50)),
				cc.FadeOut:create(0.6),
				cc.CallFunc:create(function ()
					target:removeFromParent()
				end)
				-- cc.DelayTime:create(0.3),
			}

			target:runAction(transition.sequence(actionList))
			-- self.hurtActionList[1].target:runAction(transition.sequence(self.hurtActionList[1].actions))
			-- self.hurtActionList[1].target:runAction(cc.MoveBy:create(1,cc.p(100,0)))
			-- self.hurtActionList[1].target:runAction(transition.sequence(self.hurtActionList[1].actions))
		else
			-- nLabel:runAction(transition.sequence(actionList))
		end
	end

end

function FightItemNode:beAttack(src, initParam, callBack)
	-- local nHurt = self:getHurt(src)
	local nLabel = nil
	if initParam == nil or initParam.isHit == nil or initParam.isHit == false then
		nLabel = cc.LabelTTF:create("闪避", "font/hyxl.ttf", 16)
		-- 闪避
		nLabel:setColor(cc.c3b(240, 240, 240))
		self:duck(callBack)
	else
		nLabel = cc.LabelTTF:create(initParam.att, "font/hyxl.ttf", 16)
		nLabel:setColor(cc.c3b(240, 0, 0))
		self:showAni(nil, callBack)
	end

	-- self:addChild(nLabel)
	self.spriteHero:addChild(nLabel)
	nLabel:setPosition(cc.p(self.spriteHero:getContentSize().width / 2, self.spriteHero:getContentSize().height / 2))
	-- nLabel:setPosition(cc.p((self.isEnemy and 125 or -122), -10))
	-- local actionList = {
	-- 	cc.MoveBy:create(0.3, cc.p(0, 30)),
	-- 	cc.FadeOut:create(0.6),
	-- 	cc.CallFunc:create(function ()
	-- 		nLabel:setVisible(false)
	-- 	end)
	-- }

	local actionList = {
		cc.MoveBy:create(0.3, cc.p(0, 30)),
		cc.FadeOut:create(0.6),
		-- cc.CallFunc:create(function ()
		-- 	nLabel:setVisible(false)
		-- end),
		cc.CallFunc:create(function ()
			
			table.remove(self.hurtActionList, 1)
			print("删掉自己的元素",#self.hurtActionList)
			dump(self.hurtActionList, "self.hurtActionList", 2)
			self:showHurt()
			nLabel:removeFromParent()
		end),
		cc.DelayTime:create(0.3),
	}


	nLabel:setOpacity(0)

	self:showHurt({
		target = nLabel,
		actions = actionList
		})
	-- nLabel:runAction(transition.sequence(actionList))
end

function FightItemNode:getHurt(src)
	return ((math.random(100) > 50)  and  100 or 0 )
end

function FightItemNode:isDead()
	return (self.hero:getCurrentHp() <= 0)
end

function FightItemNode:getSpeed()
	return math.ceil(self.hero:getCurrentSpd() * (90 + math.random(30)) / 100 + math.random(30)) 
end

function FightItemNode:attack(des, callBack)
	-- 判断是否命中,不命中无后续
	local srcAttribList = self.hero:getAllDatas()
	local desAttribList = self.hero:getAllDatas()
	local ar = srcAttribList.dck
	local dr = srcAttribList.hit
	local hitValue = (1 - ar / (ar + dr)) * 2 * self.hero:getLevel() / (des.hero:getLevel() + self.hero:getLevel()) * 100

	if hitValue > 98 then
		hitValue = 98
	elseif hitValue < 5 then
		hitValue = 5
	end

	print("hitValue", hitValue)


	local isHit = (math.random(100) < hitValue)
	local attValue = 0

	if isHit then
		-- hp
		-- att
		-- def
		-- frc
		-- cpt
		-- spd
		-- int
		-- maxHp
		-- dck
		-- hit
		-- crt
		-- skill
		-- srcAttribList.att
		-- local huixin 
		local huixin = srcAttribList.crt

		if math.random(1000) < huixin then
			huixin = 1.2
		else
			huixin = 1.0
		end

		local werther =self.grandParent.data.weather
		local zhenxing = 1
		local duifangzhenxing = 1
		local chengfang = 1

		if not self.isEnemy then 
			rnd = self.grandParent.data.weather.heroRandNum
			attValue = srcAttribList.att*
				srcAttribList.frc*
				srcAttribList.hp*
				20/
				desAttribList.def*
				(1 + srcAttribList.level / 100)*
				rnd*
				huixin*
				zhenxing*
				duifangzhenxing*
				chengfang/
				10000

				print("-------------------------------------------")
				print(srcAttribList.att,
				srcAttribList.frc,
				srcAttribList.hp,
				20,
				desAttribList.def,
				(1 + srcAttribList.level / 100),
				rnd,
				huixin,
				zhenxing,
				duifangzhenxing,
				chengfang,
				10000)
				print("-------------------------------------------")

		else
			rnd = self.grandParent.data.weather.enemyRandNum
			attValue = srcAttribList.att*
				srcAttribList.frc*
				srcAttribList.hp*
				10/
				(desAttribList.def + desAttribList.level)*
				rnd*
				huixin*
				zhenxing*
				duifangzhenxing*
				chengfang/
				10000

				print("++++++++++++++++++++++++++++++++++++++++++++")
				print(srcAttribList.att,
				srcAttribList.frc,
				srcAttribList.hp,
				10,
				(desAttribList.def + desAttribList.level),
				rnd,
				huixin,
				zhenxing,
				duifangzhenxing,
				chengfang,
				10000)
				print("++++++++++++++++++++++++++++++++++++++++++++")
		end

		attValue = math.ceil(attValue)

		-- 敌军攻击实际效果=攻击力*
		-- 武力*
		-- 兵力*
		-- 10/(目标防御力+等级)*
		-- (乱数)*
		-- (会心一击补正)*
		-- (阵型补正)*
		-- (目标阵型补正)*
		-- (防御指令补正)÷10000 



	else
		-- 打空了。。。
	end

	-- 往前走
	-- 攻击
	-- 攻击完之后恢复往前走
	-- 对方受伤动画
	-- 往回退

	self:ahead(function()

		-- 停止往前走的动作
		self.spriteHero:stopActionByTag(111)

		local endFunction = function ()
			-- self:notAhead(function ( ... )
				self:stateNormal()
				if type(callBack) == "function" then
					callBack({
						isHit = isHit,
						att = attValue
					})
				end
			-- end, 0.2)
		end
		self.spriteHero:playAnimationOnce(display.getAnimationCache("hero_".. self.heroIconIndex .. "_5"), {onComplete = endFunction})
	end, 0.2)
end

function FightItemNode:stopSelectAction()
	self.spriteSelect:setVisible(false)
	self.spriteSelect:stopAllActions()
	self.spriteSelect:setPositionY(23)
end

function FightItemNode:selectAction()
	self.spriteSelect:setVisible(true)
	local nWidthPos = (self.isEnemy and 125 or -122)
	self.spriteSelect:runAction(cc.RepeatForever:create(transition.sequence({
		cc.MoveTo:create(0.5, cc.p(nWidthPos, 33)),
		cc.MoveTo:create(0.5, cc.p(nWidthPos, 23)),
		})))
end

return FightItemNode