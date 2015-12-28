--
-- Author: Paul
-- Date: 2015-07-25 15:59:31
--
local BagItemNode = class("BagItemNode", function ( initParam )
	local node = newCsb(initParam.parent, "BagItemNode.csb", {type = "allListen", swallow = false}, false)
		-- local node = newCsb(initParam.parent, "BagLayer.csb", nil, false)
	-- node:setAnchorPoint(cc.p(0.5,0.5))
	-- node:setPosition(0, 200)
	-- node:setScale(0.5)

	return node
end)

-- {
-- index = 1,  
-- name = "包子",  
-- type = "Recovery",  
-- max = 99,  
-- icon = 1,  
-- hp = 30,  
-- mp = 0,  
-- force = 0,  
-- intelligence = 0,  
-- command = 0,  
-- agile = 0,  
-- luck = 0,  
-- introduction = "普通的馒头，可以恢复一点HP。"  
-- }

function BagItemNode:ctor(initParam)
	-- self.data = clone(initParam.data)
	self.data = gLobbyLogic:baseItemInfo()[initParam.data.id]
	-- self.index = initParam.data.index
	self.srcData = initParam.data
	self.parent = initParam.parent;
	self.isSelectClick = ((initParam.isSelectClick == nil) and false or initParam.isSelectClick);
	genParam(self.data, initParam.data)
	self.grandParent = initParam.parent.parent
	self.isSelect = false
	self:initView()
end

function BagItemNode:getSrcData()
	return self.srcData
end

function BagItemNode:getItemIndex()
	return self.index
end

function BagItemNode:initView()

	self.btnItem:setLocalZOrder(-2)
	local sprite = display.newSprite(string.format("images/items/%d.png", self.data.icon))
	sprite:setAnchorPoint(self.btnItem:getAnchorPoint())
	self:addChild(sprite, -1)

	if self.data.num == nil or self.data.num == 0 then
		self.lbNum:setVisible(false)
	else
		self.lbNum:setString(self.data.num)
	end

	local nItemLevel = self.data.lvl or 1

	self.lbName:setTextColor(gLobbyLogic.baseLevelColor[nItemLevel])
	self.lbName:setString(self.data.name)
	local nHeight = math.ceil(getStrLen(self.data.name) / 10) * 24
	local tmpSize = self.panelColorBg:getContentSize()
	tmpSize.height = nHeight + 5
	self.panelColorBg:setContentSize(tmpSize)
	

end

function BagItemNode:onPressItem(event)
	if event.name == "began" then
		self.posDiffY = self.parent:getInnerContainer():getPositionY()
	elseif event.name == "ended" then
		if math.abs(self.posDiffY - self.parent:getInnerContainer():getPositionY()) < 5 then
			if self.isSelect == true and self.isSelectClick then
				print("show")
				-- self.grandParent:equipItem(self.index)
				self.grandParent:equipItem(self:getSrcData())
			else
				self:select()
				self.grandParent:selectItem(self)
			end
		end
	else
	end
end

function BagItemNode:select()
	
	-- self.isSelectClick = false
	print("BagItemNode:select()")
	-- self.btnItem:setTouchEnabled(false)
	if self.isSelectClick then
		local bg = "images/common/itemBg2.png"
		self.btnItem:loadTextures(bg,bg,bg)
	else
		self.btnItem:setEnabled(false)
		self.btnItem:setBright(false)
	end
	self.isSelect = true
end

function BagItemNode:unSelect()
	-- self.isSelectClick = false
	print("BagItemNode:unSelect()")
	-- self.btnItem:setTouchEnabled(true)
	if self.isSelectClick then
		local bg = "images/common/itemBg.png"
		self.btnItem:loadTextures(bg,bg,bg)
	else
		self.btnItem:setEnabled(true)
		self.btnItem:setBright(true)
	end

	self.isSelect = false
end
-- {
-- index = 1,  
-- name = "包子",  
-- type = "Recovery",  
-- max = 99,  
-- icon = 1,  
-- hp = 30,  
-- mp = 0,  
-- force = 0,  
-- intelligence = 0,  
-- command = 0,  
-- agile = 0,  
-- luck = 0,  
-- introduction = "普通的馒头，可以恢复一点HP。"  
-- }

function BagItemNode:getDesc()
	local strDesc = "名称:" .. self.data.name .. "\n"
	if self.data.type == 1 then 
		-- strDesc = strDesc .. "编号:" .. self.data.index .. "\n"
		strDesc = strDesc .. "描述:" .. self.data.desc .. "\n"
	elseif self.data.type == 2 then 
		strDesc = strDesc .. "描述:" .. self.data.desc .. "\n"
	elseif self.data.type == 3 then 
		strDesc = strDesc .. "描述:" .. self.data.desc .. "\n"
	end
	print(strDesc)
	return strDesc
end

return BagItemNode