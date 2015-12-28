--
-- Author: Paul
-- Date: 2015-07-25 15:59:31
--

local HeroItemNode = class("HeroItemNode", function ( initParam )
	local node = newCsb(initParam.parent, "BagItemNode.csb", {--[[type = "allListen",]] swallow = false}, false)
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

function HeroItemNode:ctor(initParam)
	print("HeroItemNode:ctor(initParam)")


	-- self.data = clone(initParam.data)
	-- self.srcData = initParam.data
	self.tag = initParam.tag
	self.parent = initParam.parent;
	self.grandParent = initParam.parent.parent
	self:setScale(0.8)

	-- self.data = gLobbyLogic.baseItemInfo[initParam.data.id]
	-- genParam(self.data, initParam.data)
	-- self:initView()

	self.lbNum:setVisible(false)
	self.btnItem:setLocalZOrder(-2)
	self.spriteAnchPos = self.btnItem:getAnchorPoint()
	self:initForData(initParam.data)
end

function HeroItemNode:getSrcData()
	return self.srcData
end

function HeroItemNode:initForData(data)
	self.srcData = data
	self.data = gLobbyLogic:baseItemInfo()[data.id]
	genParam(self.data, data)
	self:initView(data.id == nil)
end

function HeroItemNode:createSprite(index_)
	if self:getChildByTag(100) then
		self:removeChildByTag(100)
	end

	if index_ == nil then return end 
	-- print("createSprite(index_)1", string.format("images/items/%d.png", index_))

	-- if index_ == 1005 then index_ = 1004 end
	-- local sprite = cc.Sprite:create(string.format("images/items/%d.png", index_))
	local sprite = display.newSprite(string.format("images/items/%d.png", index_))
	sprite:setAnchorPoint(self.spriteAnchPos)
	self:addChild(sprite, -1, 100)
end

function HeroItemNode:initView(isEmpty)                    
	

	self.lbName:setVisible(not isEmpty)
	self.panelColorBg:setVisible(not isEmpty)
	if isEmpty then
		self:createSprite()
	else
		self:createSprite(self.data.icon)
		local nItemLevel = self.data.lvl or 1
		self.lbName:setTextColor(gLobbyLogic.baseLevelColor[nItemLevel])
		self.lbName:setString(self.data.name)
		local nHeight = math.ceil(getStrLen(self.data.name) / 10) * 24
		local tmpSize = self.panelColorBg:getContentSize()
		tmpSize.height = nHeight + 5
		self.panelColorBg:setContentSize(tmpSize)
	end
end

function HeroItemNode:onPressItem(event)
	-- if event.name == "began" then
		-- self.posDiffY = self.parent:getInnerContainer():getPositionY()
	-- elseif event.name == "ended" then
		-- if math.abs(self.posDiffY - self.parent:getInnerContainer():getPositionY()) < 5 then
			-- self:select()

			-- self.grandParent:selectItem(self)
			self.grandParent:changeEquip(self.tag)
	-- 	end
	-- else
	-- end
end

function HeroItemNode:select()
	print("HeroItemNode:select()")
	-- self.btnItem:setTouchEnabled(false)
	self.btnItem:setEnabled(false)
	self.btnItem:setBright(false)
end

function HeroItemNode:unSelect()
	print("HeroItemNode:unSelect()")
	-- self.btnItem:setTouchEnabled(true)
	self.btnItem:setEnabled(true)
	self.btnItem:setBright(true)
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

function HeroItemNode:getDesc()
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

return HeroItemNode