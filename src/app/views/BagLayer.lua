--
-- Author: Paul
-- Date: 2015-07-24 23:34:33
--

local _layerTypeNormal = 0
local _layerTypeMin    = 1

local BagLayer = class("BagLayer", function(initParam)
	print("BagLayer create", initParam.parent)
	-- self.layerType = initParam.type or _layerTypeNormal
	local node = newCsb(initParam.parent, "BagLayer.csb", nil, false)
	-- node.parent = initParam.parent
	node:setAnchorPoint(cc.p(0.5,0.5))
	node:setPosition(display.cx, display.cy)
	node:setScale(0.9)
	return node
end
)

function BagLayer:ctor(initParam)
	print("BagLayer:ctor(initParam)")
	self.layerType = initParam.type or _layerTypeNormal
	if self.layerType == _layerTypeNormal then
		initParam.parent:hideTools()
	else
		self.parent = initParam.parent
		self.grandParent = self.parent.parent
		self.equipType = initParam.equipType or 100
		self.useEquip = initParam.item
	end
	self:initData(initParam)
	self.tabIndex = 1;
	self:initTabView()
	self:initType()
	-- self.btnEquip:setVisible(false)
end

function BagLayer:initType()
	if self.layerType == _layerTypeNormal then
		self.panelBg:setVisible(true)
		self.btnTabAllItems:setVisible(true)
		self.btnTabEquip:setVisible(true)
		self.btnTabNormal:setVisible(true)
		self.btnTabExp:setVisible(true)
		self.spriteBg:setSizePercent(cc.p(1, 0.903))
		self.svItems:setSizePercent(cc.p(0.9668, 0.859))
		self.labelGold:setVisible(true)
		self.spriteGold:setVisible(true)
		-- self.spriteFenGe1:setPositionPercent(cc.p(0.5331, 0.9454))
		self.spriteFenGe1:setVisible(true)
		self.spriteFenGe2:setVisible(true)
		self.btnEquip:setVisible(true)
		self.btnView:setVisible(true)
		self.btnSell:setVisible(true)
		self.svContent:setSizePercent(cc.p(0.9332, 0.7350))
		self.svContent:setPositionPercent(cc.p(0.5, 0.8929))
		self.panelNowItem:setVisible(false)
		self.panelInfo:setSizePercent(cc.p(0.315, 0.83))
		self.panelItems:setSizePercent(cc.p(0.64, 0.83))

	else
		self.panelBg:setVisible(false)
		self.btnTabAllItems:setVisible(false)
		self.btnTabEquip:setVisible(false)
		self.btnTabNormal:setVisible(false)
		self.btnTabExp:setVisible(false)
		self.svItems:setSizePercent(cc.p(0.9668, 0.96))
		self.spriteBg:setSizePercent(cc.p(1.0, 1.0))
		self.labelGold:setVisible(false)
		self.spriteGold:setVisible(false)
		-- self.spriteFenGe1:setPositionPercent(cc.p(0.5331, 0.6873))
		self.spriteFenGe1:setVisible(false)
		self.spriteFenGe2:setVisible(false)
		self.btnEquip:setVisible(false)
		self.btnView:setVisible(false)
		self.btnSell:setVisible(false)
		self.svContent:setSizePercent(cc.p(0.9332, 0.750))
		self.svContent:setPositionPercent(cc.p(0.5, 0.7702))
		self.panelNowItem:setVisible(true)
		self.panelInfo:setSizePercent(cc.p(0.315, 0.85))
		self.panelItems:setSizePercent(cc.p(0.395, 0.85))
		self.btnClose:setScale(1.1111)

		self.btnClose:setPosition(cc.p(self.btnClose:getPositionX() * 1.11111, self.btnClose:getPositionY() * 1.11111 ))
	end

	-- self.svItems:setInnerContainerSize(cc.size(420, nRow * 120 + 5))
	-- self.svItems:setInnerContainerSize(self.svItems:getContentSize())
end

function BagLayer:initData(initParam)
	self.parent = initParam.parent
	self.svItems.parent = self 
	self.tabList = {self.btnTabAllItems, self.btnTabEquip, self.btnTabNormal, self.btnTabExp}
	self.datas = gLobbyLogic.bagInfo


	



	-- for i=1, 32 do
	-- 	self.datas.normal[i] 
	-- 	= 
	-- 	{
	-- 	index = self.tempIndex,  
	-- 	name = "包子",  
	-- 	type = 1,  
	-- 	max = 99,  
	-- 	icon = 1,  
	-- 	hp = 30,  
	-- 	mp = 0,  
	-- 	force = 0,  
	-- 	intelligence = 0,  
	-- 	command = 0,  
	-- 	agile = 0,  
	-- 	luck = 0,  
	-- 	introduction = "普通的馒头，可以恢复一点HP。"  
	-- 	}
	-- end


	-- self.datas[2] = 
	self.tempIndex = 1001
end

function BagLayer:initTabView()
	-- init ui

	self.nowSelectItem = nil
	local btnImgNormal = "images/common/itemsTabButton.png"
	local btnImgHL = "images/common/itemsTabButton2.png"
	for tag, tabItem in ipairs(self.tabList) do
		if tag == self.tabIndex then
			tabItem:setSizePercent(cc.p(0.15,0.1205))
			-- tabItem:loadTextures(btnImgHL,btnImgHL,btnImgHL)
			tabItem:setEnabled(false)
			tabItem:setBright(false)
		else
			tabItem:setSizePercent(cc.p(0.15,0.1116))
			-- tabItem:loadTextures(btnImgNormal,btnImgNormal,btnImgNormal)
			tabItem:setEnabled(true)
			tabItem:setBright(true)
		end
	end

	local tmpItemDatas = {}

	if self.tabIndex == 1 then
		if self.layerType == _layerTypeMin then
			for i,v in ipairs(self.datas[2] or {}) do
				if gLobbyLogic:baseItemInfo()[v.id].subtype == self.equipType then
					tmpItemDatas[#tmpItemDatas + 1] = v
				end
			end
		else
			for _,data in ipairs(self.datas) do
				for i,v in ipairs(data) do
					table.insert(tmpItemDatas, v)
				end 
			end
		end
	else
		tmpItemDatas = self.datas[self.tabIndex - 1] or {}
	end
	
	local posX = -10
	local posY = 0
	local nItemCount = #tmpItemDatas
	local nColNum = ((self.layerType == _layerTypeMin) and 3 or 5)
	local nRow = math.ceil(nItemCount / nColNum)
	local nMoreNum = nItemCount - math.ceil(nItemCount / nColNum) * nColNum + nColNum


	print("++++++++++++ 背包测试  ++++++++++++++++++")

	print("nItemCount", nItemCount)
	print("nRow", nRow)
	print("nMoreNum", nMoreNum)


	print("++++++++++++ 背包测试  ++++++++++++++++++")


	self.svItems:setInnerContainerSize(cc.size(self.svItems:getContentSize().width, nRow * 120 + 5))
	self.svItems:removeAllChildren()

	local Item1 = nil

	self.showItems = {}

	local nInnerHeight = self.svItems:getInnerContainer():getContentSize().height
	local nColButtonCount = math.ceil(nInnerHeight / 120)

	local nTempPosY = 0


	if self.layerType == _layerTypeMin then
		self.panelNowItem.parent = self
		self.useEquip = gLobbyLogic:createBagItemNode({parent = self.panelNowItem, data = clone(self.useEquip)})
		self.useEquip:setScale(0.5)
		-- self.ccmo
		self.useEquip:setPosition(self.nodeUseEquip:getPosition())
		posX = -2
	end

	for i=1,nRow do
		for j = 1,nColNum do
			if i == nRow and  j > nMoreNum then
				break
			end

			if nRow <= nColButtonCount then
				nTempPosY = posY + self.svItems:getInnerContainer():getContentSize().height + (1 - i) * 120 - 5
			else
				nTempPosY = posY + (nRow - i + 1) * 120
			end

			self.showItems[#self.showItems + 1] = gLobbyLogic:createBagItemNode({parent = self.svItems, data = tmpItemDatas[#self.showItems + 1], isSelectClick = true})
			self.showItems[#self.showItems]:setPosition(cc.p(posX + j * 121, nTempPosY))
		end
	end

	if self.showItems[1] ~= nil then
		self:selectItem(self.showItems[1])
		self.nowSelectItem:select()
	end
	self.svItems:scrollToTop(0.3, true)

	print("self.svItems.getContentOffset", self.svItems.setContentOffset)
	-- print("self.svItems.getContentOffset", self.svItems:getInnerContainer().getPositionY())
end

function BagLayer:equipItem(item)
	-- self.grandParent:equipItem(self.datas[2][index])
	self.grandParent:equipItem(item)
	self:onPressClose()
end

function BagLayer:selectItem(item)
	print("BagLayer:selectItem(item)")
	if self.nowSelectItem ~= nil and self.nowSelectItem.getPositionX then
		print("self.nowSelectItem" , self.nowSelectItem == item)
		self.nowSelectItem:unSelect()
	end

	self.nowSelectItem = item
	print("self.nowSelectItem" , self.nowSelectItem == item)
	self:onChangeDesc(item:getDesc())

	if self.layerType ~= _layerTypeNormal then
		self.grandParent:selectItem(item)
	end
end

function BagLayer:onChangeDesc(strText)
	self.lbDesc:setString(strText)
end

function BagLayer:onPressClose()
	print("BagLayer:onPressClose()")
	if self.layerType == _layerTypeNormal then
		self.parent:showTools()
	else
		self.grandParent:changeNormal()
	end
	self:removeFromParent()
end
-- 642.53 /5   336.15 / 3
function BagLayer:onPressTabAllItems()
	print("BagLayer:onPressTabAllItems()")
	self.tabIndex = 1;
	self:initTabView()
end

function BagLayer:onPressTabEquip()
	print("BagLayer:onPressTabEquip()")
	self.tabIndex = 2;
	self:initTabView()
end

function BagLayer:onPressTabNormal()
	print("BagLayer:onPressTabNormal()")
	self.tabIndex = 3;
	self:initTabView()
end

function BagLayer:onPressTabExp()
	print("BagLayer:onPressTabExp()")
	self.tabIndex = 4;
	self:initTabView()
end

return BagLayer