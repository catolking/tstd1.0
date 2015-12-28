--
-- Author: Paul
-- Date: 2015-07-10 22:12:02
--
local AStar = import(".a_star")

function newCsb(self, fileName, initParam, isBindInSelf, isAddSelf)
	initParam = initParam or {}

	local initNodeName = function (node)
		local nodeBind = node
		local self = self
		-- print("isBindInSelf  ", isBindInSelf)
		if isBindInSelf == nil or isBindInSelf == true then
		else
			self = node
		end
		local bind_ = function(nodeName)    -- 根据控件名进行绑定
			local nNum = string.find(nodeName,"[bB][tT][nN]")   -- 查找btn
			if nNum ~= nil and nNum == 1 then
				local nLen = string.len(nodeName) 
				if nLen > 3 then
					local node = self[nodeName]
					if node.isTouchEnabled == nil then
						setTouchLayer(self, node)
					else--if  node:isTouchEnabled() == true then       -- 是否设定为可 交互性
						if initParam.swallow ~= nil then
							node:setSwallowTouches(initParam.swallow)
						end
						if initParam.type and initParam.type == "allListen" then
							node:onTouch(function(event) 
								self["onPress"..string.sub(nodeName,4, string.len(nodeName))](self, event)
							end)       		
						else
							node:onTouch(function(event) 
								if event.name == "ended" then
									local strFunName = "onPress"..string.sub(nodeName,4, string.len(nodeName))
									if self[strFunName] ~= nil then 
										self[strFunName](self, event)
									end
								end
							end)
						end
					end
				end
			end
		end

		-- print("ViewBase:initNodeName()", self.resourceNode_)
		-- print("node111", node)
		self.rootNode = node
		self[node:getName()] = node
		local bufItem = nil
		local strName = ""
		local queue = {}
		bind_(node:getName())
		table.insert(queue, self.rootNode)


		-- 层次遍历 UI树 并将控件名称绑定到 self 中
		while #queue > 0 do
			-- print("____________")
			bufItem = queue[1]
			
			table.remove(queue,1)
			for _, childItem in ipairs(bufItem:getChildren()) do
				strName = childItem:getName()
				-- print("strName",strName)
				self[strName] = self[strName] or childItem
				bind_(strName)
				table.insert(queue, childItem)
			end
		end
	end

	-- print("fileName", fileName)
	local node = cc.CSLoader:createNode(fileName)
	if node == nil then return nil end
	-- print("____________is not nil")
	initNodeName(node)

	if isAddSelf ~= false then
		self:addChild(node)
		node:setContentSize(cc.size(display.width,display.height))
		ccui.Helper:doLayout(node)
	end
	return node 
 end

function setTouchLayer(self, node, initParam)
	initParam = initParam or {}
	-- 创建一个事件监听器类型为 OneByOne 的单点触摸  
	local  listenner = cc.EventListenerTouchOneByOne:create()  
	  
	-- ture 吞并触摸事件,不向下级传递事件;  
	-- fasle 不会吞并触摸事件,会向下级传递事件;  
	-- 设置是否吞没事件，在 onTouchBegan 方法返回 true 时吞没  
	listenner:setSwallowTouches(((initParam.swallow == nil ) and false or true))
	  
	-- 实现 onTouchBegan 事件回调函数  
	listenner:registerScriptHandler(function(touch, event)  
		-- local location = touch:getLocationInView()  
		local location = node:convertToNodeSpace(touch:getLocation())
		if type(initParam.began) == "function" then
			initParam.began(location)
		end
		-- print("began____start")
		-- print(location.x, location.y)
		-- print(touch:getLocation().x, touch:getLocation().y)
		-- print(touch:getLocationInView().x, touch:getLocationInView().y)
		-- local location = node:convertToNodeSpace(touch:getLocation())
		-- print(touch:getLocationInView().x, touch:getLocationInView().y)
		-- print("began____end")
		-- print("EVENT_TOUCH_BEGAN",  location.x, location.y)  
		return true  
	end, cc.Handler.EVENT_TOUCH_BEGAN )  
	  
	-- 实现 onTouchMoved 事件回调函数  
	listenner:registerScriptHandler(function(touch, event)
		local location = node:convertToNodeSpace(touch:getLocation())
		if type(initParam.move) == "function" then
			initParam.move(location)
		end
		-- print("EVENT_TOUCH_MOVED",  location.x, location.y)  
	end, cc.Handler.EVENT_TOUCH_MOVED )  
	  
	-- 实现 onTouchEnded 事件回调函数  
	listenner:registerScriptHandler(function(touch, event)  
		local location = node:convertToNodeSpace(touch:getLocation())
		if type(initParam.ended) == "function" then
			initParam.ended(location)
		end
		-- print("EVENT_TOUCH_ENDED",  location.x, location.y) 
	end, cc.Handler.EVENT_TOUCH_ENDED )  
  
	local eventDispatcher = self:getEventDispatcher()  
	-- 添加监听器  

	eventDispatcher:addEventListenerWithSceneGraphPriority(listenner, node)  
	-- eventDispatcher:addEventListenerWithFixedPriority(listenner, ((initParam.level or 1))); 
  end


function getTextureByName(name)
	return cc.Director:getInstance():getTextureCache():addImage(name)
end

function getAPath(map, startPoint, endPoint, four_dir, isTranspose)
	if isTranspose ~= nil and isTranspose == true then
		startPoint.row,startPoint.col = startPoint.col,startPoint.row
		endPoint.row,endPoint.col = endPoint.col,endPoint.row
	end

	AStar:init(map, startPoint, endPoint, four_dir and true or false)
	local path = AStar:searchPath()
	if not path or #path == 1 then
		return nil
	end

	-- 得到的路径其实需要反转一下才是从起始到终点
	local resultPath = {}
	for i, v in ipairs(path) do
		resultPath[#path - i + 1] = v
	end


	-- print("+++++++++++++++++++++++++++")
	-- print("+++++++++++++++++++++++++++")
	-- print("resultPath", #resultPath)
	-- dump(resultPath, "resultPath")
	-- print("+++++++++++++++++++++++++++")
	-- print("+++++++++++++++++++++++++++")
	return resultPath
end

function getFrame(strPath)
	if not strPath then return nil end
	if string.byte(strPath) == 35 then
			strPath = string.sub(strPath, 2)
	end
	
	-- return CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(strPath)
	print("CCSpriteFrameCache:getSpriteFrame",CCSpriteFrameCache.getSpriteFrame)
	print("cc.SpriteFrameCache.getSpriteFrame",cc.SpriteFrameCache.getSpriteFrame)
	 -- sprite1->setSpriteFrame(SpriteFrameCache::getInstance()->getSpriteFrameByName(str1));
	return cc.SpriteFrameCache:getInstance():getSpriteFrame(strPath)
 end

function genParam(target_opt, default_opt)
	target_opt = target_opt or {}
	for k,v in pairs(default_opt) do
		if (type(v) == "number" or type(v) == "string" or type(v) == "boolean") then
			if (target_opt[k] == nil) then
				target_opt[k] = v;
			end
		elseif (type(v) == "table") then
			if (target_opt[k] == nil) then
				target_opt[k] = v;
			else
				genParam(target_opt[k],v);
			end
		elseif (type(v) == "function") then
			if (target_opt[k] == nil) then
				target_opt[k] = v;
			else
				genParam(target_opt[k],v);
			end
		else
			if (target_opt[k] == nil) then
				target_opt[k] = v;
			end
		end
	end
end

-- 两个属性列表合并
function tableAdd(target_opt, default_opt)
	target_opt = target_opt or {}
	for k,v in pairs(default_opt) do
		if (type(v) == "number") then
			if (target_opt[k] == nil) then
				target_opt[k] = v;
			else
				target_opt[k] = target_opt[k] + v
			end
		elseif (type(v) == "table") then
			if (target_opt[k] == nil) then
				target_opt[k] = v;
			else
				tableAdd(target_opt[k],v);
			end
		else
			if (target_opt[k] == nil) then
				target_opt[k] = v;
			end
		end
	end
end
-- function split(str, reps)  
--     local resultStrsList = {};  
--     string.gsub(str, '[^' .. reps ..']+', function(w) table.insert(resultStrsList, w) end );  
--     return resultStrsList;  
-- end  

function split(path,sep)
  local t = {}
  for w in path:gmatch("[^"..(sep or "/").."]+")do
    table.insert(t, w)
  end
  return t
end

function loadCsvFile(filePath, useId, isChangeNumber)   
	print("loadCsvFile", filePath, useId)
    -- 读取文件  
    local data = cc.FileUtils:getInstance():getStringFromFile(filePath);  
    if data == "" then
    	return {}
    end
    print(data)
    -- 按行划分  
    local lineStr = split(data, '\n\r');  

    --[[  
                从第3行开始保存（第一行是标题，第二行是注释，后面的行才是内容）   
              
                用二维数组保存：arr[ID][属性标题字符串]  
    ]]  
    local titles = split(lineStr[1], ",");  
    local ID = 0;  
    local arrs = {};  

    local nStartLine = 3
    local listNumber = {}
	if isChangeNumber == true then
		local Tmp = split(lineStr[3], ","); 
		for i, v in ipairs(Tmp) do
			if v == "1" then
				listNumber[i] = true
			end
		end
	end

    for i = nStartLine, #lineStr, 1 do  
        -- 一行中，每一列的内容  
        local content = split(lineStr[i], ",");  
  
        -- 以标题作为索引，保存每一列的内容，取值的时候这样取：arrs[1].Title  
	    if useId == true then
	    	ID = tonumber(content[1])
	    else
	    	ID = ID + 1
	    end

        arrs[ID] = {};  
        for j = 1, #titles, 1 do  
        	if isChangeNumber == true and listNumber[j] then
        		arrs[ID][titles[j]] = tonumber(content[j]);  
        	else
            	arrs[ID][titles[j]] = content[j];  
        	end
        end  
    end  
  	
    return arrs;  
end

function getStrLen(str)
	if not str then
		return -1
	end
	local code=0
	local pos = 1
	local len = 0;
	local length = string.len(str)
	while len < pos do
		code = string.byte(str,pos)
		if not code then
			break
		end
		--0,0xc0,0xe0,0xf0
		if code >= 0xf0 then
			pos = pos + 4;
			len = len + 2;
		elseif code >= 0xe0 then
			pos = pos + 3;
			len = len + 2;
		elseif code >= 0xc0 then
			pos = pos + 2
			len = len + 2;
		else
			pos = pos + 1
			len = len + 1;
		end

	end
	return len
end

function min(a, b) return ((a > b) and b or a) end
function max(a, b) return ((a > b) and a or b) end

function swapTable(src, des)
	local tmp = clone(src)
	local tmpList = {}
	for k,v in pairs(src) do
		tmpList[#tmpList + 1] = k
	end

	for i,v in ipairs(tmpList) do
		src[v] = nil
	end

	genParam(src, des)

	tmpList = {}
	for k,v in pairs(des) do
		tmpList[#tmpList + 1] = k
	end

	for i,v in ipairs(tmpList) do
		des[v] = nil
	end

	genParam(des, tmp)
end