--
-- Author: Paul
-- Date: 2015-07-12 02:54:26
--
local heroSprite = class("MainScene", cc.Sprite)

function heroSprite:ctor(initParam)
	print("heroSprite:ctor(initParam)")
	print("self", self)
	print("self.setTexture", self.setTexture)
	self.initParam = initParam or {}
	self.mapList = initParam.mapList or {}
	self.objList = initParam.objList or {}
	self.node_ = display.newNode()

	self:addChild(self.node_)
	if self.initParam.tiled ~= nil then 
		self.tiled = self.initParam.tiled
	end
	self.mapH = self.tiled:getMapSize().height
	self.mapW = self.tiled:getMapSize().width

	self.preParam = {}
	self.data = {}
	self.data.heroId = gLobbyLogic.data._fighting_list_[1]
	-- 1.下
	-- 2.左
	-- 3.右
	-- 4.上
	self.data.direction = initParam.direction or 4
	local xx = getFrame("#hero_1_01.png")
	self:setAnchorPoint(cc.p(0, 0))
	self:setSpriteFrame(xx)
	self.listMove = {}

	local animation = display.getAnimationCache(string.format("hero_%d_%d",self.data.heroId, self.data.direction))
	self:playAnimationForever(animation)
	self:onWalk()
end

function heroSprite:heroMove(pos, initParam)
	print("heroSprite:heroMove",pos, initParam)
	local posX = pos.x
	local posY = pos.y

	self.preParam = initParam

	self.continuePosX = posX
	self.continuePosY = posY
	self.listMove = {}
	self:onWalk()
end

-- 当没有移动的时候 调用此方法
function heroSprite:onContinueWalk()
	print("heroSprite:onContinueWalk()",self.continuePosX)
	if self.continuePosX == nil or  self.continuePosX < 0 then return end 

	local posX = self.continuePosX
	local posY = self.continuePosY

	self.continuePosX = -1
	self.continuePosY = -1

	local nNowMove = self.listMove[1]
	self.listMove = {} -- 先不让进行后续动作

	-- if self.temp == true then return end 
	self.temp = true
	local map = self.tiled
	local mapH = map:getMapSize().height
    local mapW = map:getMapSize().width

	-- local nowPos = self.tiled:convertToNodeSpace(cc.p(self:getPosition()))
	local nowPos = cc.p(self:getPosition())
	print("nowPosXY",nowPos.x, nowPos.y)
	local endPoint = {}
	endPoint.row = math.floor(posX / 32) + 1
	endPoint.col = mapH - math.floor(posY / 32) 
	-- local t = sceneLayer:getTileAt(endPoint)

	local startPoint = {}
	startPoint.row = math.floor(nowPos.x/32) + 1
	startPoint.col = mapH - math.floor(nowPos.y/32) 

	print("startPoint", startPoint.row, startPoint.col)
	print("  endPoint", endPoint.row, endPoint.col)

	-- if nNowMove ~= nil and self:getNumberOfRunningActions() > 1 then
	-- 	-- 1.下
	-- 	-- 2.左
	-- 	-- 3.右
	-- 	-- 4.上
	-- 	print("_____nNowMovenNowMove", nNowMove)
	-- 	if nNowMove == 1 then
	-- 		startPoint.col = startPoint.col + 1
	-- 	elseif nNowMove == 2 then
	-- 		startPoint.row = startPoint.row - 1
	-- 	elseif nNowMove == 3 then
	-- 		startPoint.row = startPoint.row + 1
	-- 	elseif nNowMove == 4 then
	-- 		startPoint.col = startPoint.col - 1
	-- 	end
	-- end
	
	local path_ = getAPath(self.mapList, startPoint, endPoint, true ,true)

	if path_ == nil then return end
	print("____path num ******** ", #path_)

	if #path_ > 1 then
	    local listDir = {}
	    for i = 2, #path_ do
	        print("loop", i)
	        local nDir = 1
	        if path_[i].row == path_[i-1].row then
	            -- col 不一样
	            if (path_[i].col - path_[i-1].col) > 0 then 
	                -- 左
	                nDir = 3
	            else
	                -- 右
	                nDir = 2
	            end
	        else
	            if (path_[i].row - path_[i-1].row) > 0 then 
	                -- 下
	                nDir = 1
	            else
	                -- 上
	                nDir = 4
	            end
	        end
	        listDir[#listDir + 1] = nDir
	    end
	    self:onWalk(listDir)
	end
end

function heroSprite:setPosition1(x,y)
	-- local mapH = map:getMapSize().height
	-- endPoint.row = math.floor(posX / 32) + 1
	-- endPoint.col = mapH - math.floor(posY / 32) 

	-- self.posX = 
	-- self.posY =
	-- self:setPosition(x,y)
end

function heroSprite:checkObj()
	local nowGid = self:getGid()
	print("检查是否有触发的行为")
	for tag, obj in ipairs(self.objList) do
		if obj.name == "door" then
			for _, gid__ in ipairs(obj.gid) do
				print("gid__.x == nowGid.row and gid__.y == nowGid.col",gid__.x , nowGid.row , gid__.y , nowGid.col)
				if gid__.x == nowGid.row and gid__.y == nowGid.col then
					print("____当前触发行为。。。")
					dump(obj)

					if gLobbyLogic:objEvent(obj, self.tiled) == true then
						-- self.tiled:removeFromParent()
						return true
					end

				end
			end
		end
	end
	return false
end

function heroSprite:onWalk(tb)
	print("heroSprite:onWalk", tb)
	
	local function run_(isFirst) 
		local nMoveTime = 0.2
		local actions = {}
		local nDirction = self.listMove[1]
		-- print("nDirction", nDirction)
		-- print("run dirction", nDirction)
		local target = self
		if nDirction == nil then
			-- check 
			
			self.node_:runAction(transition.sequence({
				cc.CallFunc:create(function() self:onContinueWalk() end)
				}))
			return
		else
			if (self.direction or -1) == nDirction then
			else
				self:stopAllActions()
				self:playAnimationForever(display.getAnimationCache(string.format("hero_%d_%d",self.data.heroId, nDirction)))
				self.direction = nDirction
			end
			-- print("stopAnimation()", self.stopAnimation)
			
			local intX = 0
			local intY = 0
			-- 1.上
			-- 2.左
			-- 3.右
			-- 4.下
			if nDirction == 1 then
				intX = 0
				intY = -32
			elseif nDirction == 2 then
				intX = -32
				intY = 0
			elseif nDirction == 3 then
				intX = 32
				intY = 0
			elseif nDirction == 4 then
				intX = 0
				intY = 32
			end

			-- 世界坐标
			local wPos = self.tiled:convertToWorldSpace(cc.p(self:getPosition()))

			-- 判断是否超过边界 并且还有未显示的底图 如果超过 则滚动底图

			local posWLT = cc.p(0, display.height)  --世界坐标左上
			local posLT = self.tiled:convertToNodeSpace(posWLT)
			local posWRB = cc.p(display.width, 0)	--世界坐标右下
			local posRB = self.tiled:convertToNodeSpace(posWRB)

			local mapSize = self.tiled:getContentSize()

			print("nDirction", nDirction)
			if nDirction == 1 then
				print(" wPos.y  posRB.y",wPos.y  ,posRB.y, mapSize.height)
				if wPos.y <= (display.height * 0.40) and posRB.y > 0 + 30 then
					self.tiled:runAction(CCMoveBy:create(nMoveTime, cc.p(-intX, -intY)))
				end
			elseif nDirction == 2 then
				print(" wPos.x  posRB.x",wPos.y  ,posLT.x, mapSize.height)
				if wPos.x <= (display.width * 0.30) and posLT.x > 30  then
					self.tiled:runAction(CCMoveBy:create(nMoveTime, cc.p(-intX, -intY)))
				end
			elseif nDirction == 3 then
				print(" wPos.x  posLT.x",wPos.y  ,posRB.x, mapSize.height)
				if wPos.x > (display.width * 0.70) and posRB.x <= mapSize.width  - 30 then
					self.tiled:runAction(CCMoveBy:create(nMoveTime, cc.p(-intX, -intY)))
				end
			elseif nDirction == 4 then
				print(" wPos.y  posLT.y",wPos.y  ,posLT.y, mapSize.height)
				if (wPos.y > (display.height * 0.60) --[[and posLT.y >= display.height]]) and posLT.y < mapSize.height - 30 then
					self.tiled:runAction(CCMoveBy:create(nMoveTime, cc.p(-intX, -intY)))
				end
			end
			
			actions[#actions + 1] = CCMoveBy:create(nMoveTime, cc.p(intX, intY));
		end

		actions[#actions + 1] = cc.CallFunc:create(function() 
			table.remove(self.listMove, 1)
			if self:checkObj() then
				return 
			end
			run_(false)
			end)

		self:runAction(transition.sequence(actions))
	end

	if tb ~= nil then
		self.listMove = tb
	end

	print("self:getNumberOfRunningActions()", self:getNumberOfRunningActions())
	if self:getNumberOfRunningActions() > 1 then
		--现在已经有动作了
		print("____ 已有")
	else
		--现在还没有动作。。
		print("____ run()")
		run_(true)
	end
end

function heroSprite:getGid()
	print("heroSprite:getGid()")
	local nowPos = cc.p(self:getPosition())

	local startPoint = {}
	startPoint.row = math.floor(nowPos.x/32) + 1
	startPoint.col = self.mapH - math.floor(nowPos.y/32) 

	return startPoint
end

function heroSprite:setViewPointByPlayer() 
    if (m_sprite == NULL) then
        return;  
    end

    local parent = self:getParent();  
  
    --[[ 地图方块数量 --]]
    local m_map = map;
    local mapTiledNum = m_map:getMapSize();  
  
    --[[ 地图单个格子大小 --]]  
    local tiledSize = m_map:getTileSize();  
  
    --[[地图大小 --]]  
    local mapSize = cc.Size(  
        mapTiledNum.width * tiledSize.width,  
        mapTiledNum.height * tiledSize.height);  
  
    --[[ 屏幕大小 --]]  
    local visibleSize = cc.Director:getInstance():getVisibleSize();  
  
    --[[ 主角坐标 --]]  
    -- local spritePos = getPosition();  
    local spritePos = self.tiled:convertToWorldSpace(cc.p(self:getPosition()))
     local std_max = function (x,y)
    	return ((x > y) and x or y ) 
    end 
    --[[ 如果主角坐标小于屏幕的一半，则取屏幕中点坐标，否则取主角的坐标 --]]  
    local x = std_max(spritePos.x, visibleSize.width / 2);  
    local y = std_max(spritePos.y, visibleSize.height / 2);  
  
    --[[ 如果X、Y的坐标大于右上角的极限值，则取极限值的坐标（极限值是指不让地图超出 
    屏幕造成出现黑边的极限坐标） --]] 
    local std_min = function (x,y)
    	return ((x > y) and y or x ) 
    end 

    x = std_min(x, mapSize.width - visibleSize.width / 2);  
    y = std_min(y, mapSize.height - visibleSize.height / 2);  
  
    if (x >= visibleSize.width) then end  
    --[[ 目标点 --]]  
    local destPos = cc.p(x, y);  
  
    --[[ 屏幕中点 --]] 
    local centerPos = cc.p(visibleSize.width / 2, visibleSize.height / 2);  
  
    --[[ 计算屏幕中点和所要移动的目的点之间的距离 --]]  
    local viewPos = centerPos - destPos;  
  
    parent:setPosition(viewPos);  
end

return heroSprite