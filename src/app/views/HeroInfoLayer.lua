--
-- Author: Paul
-- Date: 2015-07-28 20:49:12
--

local HeroInfoLayer = class("HeroInfoLayer", function(initParam)
	local node = newCsb(initParam.parent, "HeroInfoLayer.csb", nil, false)
	node:setAnchorPoint(cc.p(0.5,0.5))
	node:setPosition(display.cx, display.cy)
	node:setScale(0.9)
	return node
end)

function HeroInfoLayer:ctor(initParam)
	self:initData(initParam)
	self.parent:hideTools()
	self:changeNormal()
end

function HeroInfoLayer:initData(initParam)
	self.parent = initParam.parent
	self.svHero.parent = self
	self.panelNormal.parent = self
	self.panelItemLayer.parent = self
	-- 武将列表

	self.heroList = gLobbyLogic.heroInfo

	local nCount = #self.heroList
	local nColButtonCount = math.ceil(self.svHero:getInnerContainer():getContentSize().height / 60)

	self.svHero:setInnerContainerSize(cc.size(200, nCount * 60 + 5))

	self.heroNodeList = {}
	local posY = -30
	for i=1,nCount do

		if nCount <= nColButtonCount then
			nTempPosY = posY + self.svHero:getInnerContainer():getContentSize().height + (1 - i) * 60 - 5
		else
			nTempPosY = posY + (nCount - i + 1) * 60
		end

		local node = gLobbyLogic:createHeroInfoNode({parent = self.svHero,data = self.heroList[i]})
		node:setPosition(100, nTempPosY)
		self.heroNodeList[i] = node
		self.svHero:addChild(node)
	end

	self.equipNodeList = {}
	for i=1, 2 do
		for j=1, 5 do
			local tmpItemNode = gLobbyLogic:createHeroItemNode({parent = self.panelNormal, tag = #self.equipNodeList + 1, data = {id = 1}})
			tmpItemNode:setPosition(-2 + 108 * j ,120 * (3 - i))
			self.equipNodeList[#self.equipNodeList + 1] = tmpItemNode
			-- tmpItemNode:
			-- tmpItemNode:addChild(self.panelNormal)
		end
	end

	self.heroNodeList[1]:select()
	self:selectHero(self.heroNodeList[1])
end

function HeroInfoLayer:changeEquip(tag)
	self.selectTag = tag
	self.selectItemData = self.nowEquipList[tag]
	-- self.shuxing:setSizePercent(cc.p(0.18, 0.845))
	self.shuxing:setSizePercent(cc.p(0.32, 0.845))
	self.panelNormal:setVisible(false)
	-- self.panelHead:setSizePercent(cc.p(0.78, 0.07))
	self.panelHead:setSizePercent(cc.p(0.642, 0.07))
	self.lbChangeItem:setVisible(true)
	self.lbTeamInfo:setVisible(false)
	self.svHero:setVisible(false)
	self.panelItemLayer:setVisible(true)
	self.lbTalent:setVisible(false)
	self.lbTalentTip:setVisible(false)
	self.spriteFenGe:setVisible(false)

	self._labelHP:setVisible(true)
	self.labelHP:setVisible(true)
	self.labelHP_0:setVisible(true)


	local equipType = tag
	if equipType  > 8 then
		equipType  = 8
	end

	local node = gLobbyLogic:createBagLayer({parent = self.panelItemLayer, type = 1, equipType = equipType, item = self.nowEquipList[self.selectTag]})
	node:setPosition(self.panelItemLayer:getContentSize().width / 2 + 105, self.panelItemLayer:getContentSize().height / 2 + 20)
	node:setScaleY(0.9)
	node:setScaleX(0.9)
	node:setAnchorPoint(cc.p(0.5, 0.5))
end

function HeroInfoLayer:selectItem(item)
	print("HeroInfoLayer:selectItem(item)")
	dump(self.nowSelectHero:getCpmItemData(item:getSrcData(), self.selectTag), "self.nowSelectHero:getCpmItemData(item:getSrcData(), self.selectTag)")
	self:initChangeInfo(self.nowSelectHero:getCpmItemData(item:getSrcData(), self.selectTag))
end

-- 初始化对比的数据
function HeroInfoLayer:initChangeInfo(data)
	-- self.labelAtt_0:setString(data.des.att)
	-- self.labelDef_0:setString(data.des.def)
	-- self.labelFrc_0:setString(data.des.frc)
	-- self.labelCpt_0:setString(data.des.cpt)
	-- self.labelSpd_0:setString(data.des.spd)
	-- self.labelInt_0:setString(data.des.int)
	-- self.labelDck_0:setString(data.des.dck)
	-- self.labelHit_0:setString(data.des.hit)
	-- self.labelCrt_0:setString(data.des.crt)


	self.labelHP:setString(data.src.maxHp)


	local cmpList = {
		{self.labelAtt_0, "att"},
		{self.labelDef_0, "def"},
		{self.labelFrc_0, "frc"},
		{self.labelCpt_0, "cpt"},
		{self.labelSpd_0, "spd"},
		{self.labelInt_0, "int"},
		{self.labelDck_0, "dck"},
		{self.labelHit_0, "hit"},
		{self.labelCrt_0, "crt"},
		{self.labelHP_0, "maxHp"},
	}

	for i, cmp_ in ipairs(cmpList) do
		local strText = ""
		if data.src[cmp_[2]] > data.des[cmp_[2]] then
			strText = "↓"
			cmp_[1]:setTextColor(cc.c3b(255, 0, 0))
		elseif data.src[cmp_[2]] < data.des[cmp_[2]] then
			strText = "↑"
			cmp_[1]:setTextColor(cc.c3b(0, 255, 0))
		else
			strText = "→"
			cmp_[1]:setTextColor(cc.c3b(0, 229, 255))
		end

		cmp_[1]:setString(strText .. data.des[cmp_[2]])
	end
end

function HeroInfoLayer:equipItem(item)



	-- 如果身上有装备 则替换
	swapTable(item, self.selectItemData)
	self.nowSelectHero:useNewEquip(self.selectItemData, self.selectTag)
	-- 初始化 初始数值

	self:initViewWithData()

		-- dump(gLobbyLogic.heroInfo, "gLobbyLogic.heroInfo", 7)
		-- dump(gLobbyLogic.bagInfo, "gLobbyLogic.bagInfo", 7)
	-- self:changeNormal()
end

function HeroInfoLayer:changeNormal()
	self.shuxing:setSizePercent(cc.p(0.18, 0.845))
	self.panelNormal:setVisible(true)
	self.panelHead:setSizePercent(cc.p(0.78, 0.07))
	self.lbChangeItem:setVisible(false)
	self.lbTeamInfo:setVisible(true)
	self.svHero:setVisible(true)
	self.panelItemLayer:setVisible(false)
	self.lbTalent:setVisible(true)
	self.lbTalentTip:setVisible(true)
	self.spriteFenGe:setVisible(true)
	self._labelHP:setVisible(false)
	self.labelHP:setVisible(false)
	self.labelHP_0:setVisible(false)
end

function HeroInfoLayer:selectHero(item)
	if self.nowSelectHero ~= nil and self.nowSelectHero.getPositionX then
		self.nowSelectHero:unSelect()
	end

	self.nowSelectHero = item
	self:initViewWithData()
	-- self:onChangeDesc(item:getDesc())
end

function HeroInfoLayer:initViewWithData()
	data = self.nowSelectHero:getSelectData()
	self.nowEquipList = data.equip
	-- self.hp
	-- self.maxHp

	-- 设置文本信息
	self.labelAtt:setString(data.data.att)
	self.labelDef:setString(data.data.def)
	self.labelFrc:setString(data.data.frc)
	self.labelCpt:setString(data.data.cpt)
	self.labelSpd:setString(data.data.spd)
	self.labelInt:setString(data.data.int)
	self.labelDck:setString(data.data.dck)
	self.labelHit:setString(data.data.hit)
	self.labelCrt:setString(data.data.crt)

	-- 设置装备信息
	print("self.equipNodeList", self.equipNodeList)
	for tag, equipNode in ipairs(self.equipNodeList) do
		equipNode:initForData(data.equip[tag])
	end
	print("self.equipNodeList2", self.equipNodeList)
end



function HeroInfoLayer:onPressClose()
	self.parent:showTools()
	self:removeFromParent()
end

return HeroInfoLayer