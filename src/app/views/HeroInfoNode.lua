--
-- Author: Paul
-- Date: 2015-07-28 21:43:29
--
local HeroInfoNode = class("HeroInfoNode", function ( initParam )
	print(initParam.parent)
	local node = newCsb(initParam.parent, "HeroInfoNode.csb", {type = "allListen", swallow = false}, false, false)
	-- local node = newCsb(initParam.parent, "BagLayer.csb", nil, false)
	node:setAnchorPoint(cc.p(0,0))
	-- node:setPosition(0, 200)
	-- node:setScale(0.5)

	return node
end)

function HeroInfoNode:ctor(initParam)
	self:initData(initParam)
end

function HeroInfoNode:initData(initParam)
	print("HeroInfoNode:initData(initParam)")
	dump(initParam, "initParam", 2)
	self.data = initParam.data
	self.hero = gLobbyLogic:createModelHero(initParam.data)
	self.parent = initParam.parent
	self.grandParent = self.parent.parent
	self.heroIconIndex = self.hero:getIcon()
	self:initView()
end

function HeroInfoNode:initView()

	self.labelName:setString(self.hero:getName())
	self.labelHP:setString(string.format("兵力:%d/%d", self.hero:getCurrentHp(), self.hero:getMaxHp()))

	local posTmp = cc.p(self.spriteHero:getPosition())
	-- self.spriteHero:removeFromParent()
	self.spriteHero = display.newSprite("#hero_" .. self.heroIconIndex .. "_01.png")
	-- self.spriteHero = display.newSprite("images/map/npc.png")
	-- self.spriteHero:setScale(1000)
	self.spriteHero:setPosition(-75,0)
	self:addChild(self.spriteHero)

	local strTalent = self.hero:getTalent()
	if strTalent == nil or strTalent == "" then
		self.labelTalent:setVisible(false)
	else
		self.labelTalent:setString(strTalent)
	end

	-- self.heroIconIndex
end

function HeroInfoNode:useNewEquip(data, tag)
	self.hero:useNewEquip(data, tag)
end

function HeroInfoNode:onPressItem(event)
	print("=============",self.parent)
	if event.name == "began" then
		self.posDiffY = self.parent:getInnerContainer():getPositionY()
	elseif event.name == "ended" then
		if math.abs(self.posDiffY - self.parent:getInnerContainer():getPositionY()) < 5 then
			self:select()
			self.grandParent:selectHero(self, self:getSelectData())
		end
	else
	end
end

function HeroInfoNode:getCpmItemData(item, ItemIndex)
	return self.hero:getCpmItemData(item, ItemIndex)
end

function HeroInfoNode:getSelectData()
	return {data = self.hero:getAllDatas(), equip = self.hero:getSrcEquipList()}
end

function HeroInfoNode:select()
	print("HeroInfoNode:select()")
	-- self.btnItem:setTouchEnabled(false)
	self.btnItem:setEnabled(false)
	self.btnItem:setBright(false)
end

function HeroInfoNode:unSelect()
	print("HeroInfoNode:unSelect()")
	-- self.btnItem:setTouchEnabled(true)
	self.btnItem:setEnabled(true)
	self.btnItem:setBright(true)
end

return HeroInfoNode