--
-- Author: Paul
-- Date: 2015-07-14 11:57:06
--

local MapView = class("MapView", function (initParam)
    if initParam == nil then return nil end
    local path = initParam.path or "images/map/xuzhoucheng.tmx"
	-- local path = initParam.path or "images/map/gongdian.tmx"
    if initParam.stackInfo ~= nil and initParam.stackInfo.path ~= nil then
        path = initParam.stackInfo.path
    end
    return cc.TMXTiledMap:create(path)
    -- return cc.FastTiledMap:create(path)
end)


function MapView:ctor(initParam)
	print("MapView:ctor")
    self:setScale(1)
	if initParam == nil then print("return") return end
	self.parent = initParam.parent

    local path = initParam.path or "images/map/xuzhoucheng.tmx"

    if initParam.stackInfo ~= nil and initParam.stackInfo.path ~= nil then
        path = initParam.stackInfo.path
    end
    self.path = path

	local map = self

    self.tileHeight = map:getTileSize().height
    self.tileWidth  = map:getTileSize().width

    self:initMap()

    map:setAnchorPoint(cc.p(0, 0))


    self.parent:addChild(map,-1--[[, 100000]])
    local mapH = map:getMapSize().height
    local mapW = map:getMapSize().width

    local sceneLayer = map:getLayer("scene");
    local objectGroup = map:getObjectGroup("object");
    local tmpDoor = objectGroup:getObject("door")

    -- 加入人物
    -- local tmp = objectGroup:getObject("chat")
    
    print("____-设置人物位置 end ")
    local spriteHero = gLobbyLogic:createHeroSprite({tiled = map, mapList = self.mapList, objList = self.objList})
    
    map:addChild(spriteHero)
    self.spriteHero = spriteHero


    print("____-设置人物位置 start ")
    -- dump(self.objList, 5)
    if initParam.stackInfo == nil then
        local tmp = self:getObjsByNameAndType("born", "1")
        -- local tmp = self.objList.chat
        local spriteX = tmp["x"]
        local spriteY = tmp["y"]

        local wTmpPos = map:convertToWorldSpace(cc.p(tmp["x"], tmp["y"]))
        print("wTmpPos", wTmpPos.x, wTmpPos.y)

        -- 如果太低了..看不到或者不在中间
        local yDiffTmp = display.cy - wTmpPos.y 
        local  nGidY = tmp.gid[1].y
        local  nGidX = tmp.gid[1].x

        local nMaxMoveGridX = math.floor(display.cx / self.tileWidth)
        local nMaxMoveGridY = math.floor(display.cy / self.tileHeight)




        local nDiffX = map:getPositionX()
        local nDiffY = map:getPositionY()

        -- 调整上下
        -- print("wTmpPos.y < (display.height * 0.4)", wTmpPos.y < (display.height * 0.4))
        -- print("nMaxMoveGridY < (mapH - nGidY)", nMaxMoveGridY < (mapH - nGidY))
        -- print("wTmpPos.y > (display.height * 0.6)", wTmpPos.y > (display.height * 0.6))
        -- print("nMaxMoveGridY > (mapH - nGidY)", nMaxMoveGridY > (mapH - nGidY))
        -- print("wTmpPos.x < (display.width * 0.3)", wTmpPos.x < (display.width * 0.3))
        -- print("nMaxMoveGridX < (nGidX - 1)", nMaxMoveGridX < (nGidX - 1))
        -- print("wTmpPos.x > (display.width * 0.7)", wTmpPos.x > (display.width * 0.7))
        -- print("nMaxMoveGridX > (nGidX - 1)", nMaxMoveGridX > (nGidX - 1))

        --[[
        if wTmpPos.y < (display.height * 0.4) then
            if nMaxMoveGridY < (mapH - nGidY) then
                nDiffY = nDiffY - wTmpPos.y  + (nMaxMoveGridY)*self.tileHeight
            else
                nDiffY = nDiffY - wTmpPos.y  + (mapH - nGidY)*self.tileHeight
            end
        elseif wTmpPos.y > (display.height * 0.6) then
            print("nMaxMoveGridY > (mapH - nGidY)", nMaxMoveGridY , (mapH - nGidY))
            if nMaxMoveGridY > (mapH - nGidY) then
                nDiffY = nDiffY + wTmpPos.y  - (nMaxMoveGridY)*self.tileHeight
            else
                -- 
                print("nDiffY", nDiffY)
                nDiffY = nDiffY + wTmpPos.y  - (mapH - nGidY)*self.tileHeight
            end
        end

        -- 调整左右
        if wTmpPos.x < (display.width * 0.3) then
            if nMaxMoveGridX < (nGidX - 1) then
                nDiffX = nDiffX - wTmpPos.x  + (nMaxMoveGridX)*self.tileWidth
            else
                nDiffX = nDiffX - wTmpPos.x  + (nGidX - 1) * self.tileWidth
            end
        elseif wTmpPos.x > (display.width * 0.7) then
            print("nMaxMoveGridX > (nGidX - 1)", nMaxMoveGridX , (nGidX - 1))
            if nMaxMoveGridX > (nGidX - 1) then
                nDiffX = nDiffX + wTmpPos.x  - (nMaxMoveGridX)*self.tileWidth
            else
                --
                nDiffX = nDiffX + wTmpPos.x  - (nGidX - 1) * self.tileWidth
                print("nDiffX", nDiffX)
            end
        end
        --]]

        -- 不超过屏幕宽度则居中
        if mapW <= nMaxMoveGridX * 2 then
            nDiffX = math.ceil(((display.width / self.tileWidth) - mapW)/2) * self.tileWidth      -- 因为锚点的问题
        elseif nGidX < nMaxMoveGridX then
            nDiffX = -wTmpPos.x - (-nGidX + 1) * self.tileWidth
        elseif (nGidX + nMaxMoveGridX) > mapW then
            nDiffX = -wTmpPos.x + (2*nMaxMoveGridX - (mapW-nGidX)) * self.tileWidth
        else
            nDiffX = -wTmpPos.x + nMaxMoveGridX * self.tileWidth
        end


        -- 不超过屏幕高度则居中
        nGidY = mapH - nGidY
        if mapH <= math.ceil(display.height / self.tileHeight) then
            nDiffY = math.ceil(((display.height / self.tileHeight) - mapH)/2) * self.tileHeight      -- 因为锚点的问题
        elseif nGidY <= nMaxMoveGridY then  --底部不够
            nDiffY = -wTmpPos.y - (-nGidY ) * self.tileHeight
        elseif (nGidY + nMaxMoveGridY) >= mapH then  -- 高度不够
            -- nDiffY = -wTmpPos.y + (math.ceil(display.height / self.tileHeight) - ( nGidY) + 1) * self.tileHeight
            nDiffY = -wTmpPos.y - (math.ceil(display.height / self.tileHeight) - (nGidY) + 1) * self.tileHeight
        else
            nDiffY = -wTmpPos.y + nMaxMoveGridY * self.tileHeight
        end

        -- map:setPositionX(nDiffX)
        -- map:setPositionY(nDiffY)
        map:setPositionX(nDiffX)
        -- map:setPositionY(-wTmpPos.y + nMaxMoveGridY * self.tileHeight)
        map:setPositionY(-wTmpPos.y)
        map:setPositionY(nDiffY)

        spriteHero:setPosition(tmp["x"], tmp["y"])
    else
        map:setPosition(initParam.stackInfo.mapPos)
        spriteHero:setPosition(initParam.stackInfo.spritePos)
    end


    -- local spriteHero__Temp = displ
    print("init____Listen__")
    setTouchLayer(self.parent, map, {
        swallow = true,
        began = function(pos)
            print(map:getTileSize().width, map:getTileSize().height)
            print(map:getMapSize().width, map:getMapSize().height)
            print(map:getContentSize().width, map:getContentSize().height)
            print(pos.x > map:getContentSize().width, pos.y >  map:getContentSize().height)
            print("pos______________",pos.x, pos.y)



            if pos.x < 0 or pos.x > map:getContentSize().width or  pos.y < 0  or pos.y >  map:getContentSize().height  then
                -- return  false

            else
                local point = {}
                point.x = math.floor(pos.x/self.tileWidth)
                point.y = mapH - math.floor(pos.y/self.tileHeight) - 1
                local gid = sceneLayer:getTileGIDAt(point)
                local p = map:getPropertiesForGID(gid)

                if type(p) == "table" and p.move == "true" then
                    spriteHero:heroMove(pos, p)
                end
            end
        end})
end

function MapView:gotoDoor()

end

function MapView:initView()
end

function MapView:getObjsByNameAndType(strName, strType)
    if self.objList == nil then return {} end
    local rtList = {}
    for i, obj in ipairs(self.objList) do
        if obj.name == strName then
            if strType == nil then
                rtList[#rtList + 1] = obj
            else
                return obj
            end
        end
    end
    return rtList
end

function MapView:initMap()
	print("MapView:initMap()")
    local map = self
	local mapH = map:getMapSize().height
    local mapW = map:getMapSize().width

    local objectGroup = map:getObjectGroup("object");

    -- 获取所有属性信息
    self.prpList = objectGroup:getProperties() or {}

    -- 获取对象信息
    self.objList = objectGroup:getObjects() or {}
    -- 设置gid的坐标

    for tag, obj in ipairs(self.objList) do
        local nwidthNum  = math.ceil(obj.width/self.tileWidth)
        local nheightNum = math.ceil(obj.height/self.tileHeight)
        local nGidWidth  = math.floor(obj.x / self.tileWidth)
        local nGidHeight = math.floor(obj.y / self.tileHeight)

        local gidList = {}
        for i=1, nwidthNum do
            for j=1, nheightNum do
                print(obj.type, "gid x  y", nGidWidth + i - 1,  nGidHeight + j - 1)
                gidList[#gidList + 1] = {x = nGidWidth + i, y = mapH - nGidHeight + j - 1}
            end
        end
        obj.gid = gidList
    end

    -- 获取位置信息
    local mapTable = {}
    local sceneLayer = map:getLayer("scene");
    for i=0,mapH-1 do
        mapTable[i+1] = {}
        str = string.format("__%2d_", i)
        for j=0, mapW-1 do

            --  local gid = sceneLayer:getTileGIDAt(point)
            -- print("gid", gid)
            -- local p = map:getPropertiesForGID(gid)

            local item_ = map:getPropertiesForGID((sceneLayer:getTileGIDAt({x=j,y=i})))
            -- print(i,j,type(item_))

            if type(item_) == "table" then
                -- print(i,j,"______________", item_.move)
                -- for k,v in pairs(item_) do
                --     print(k,v)
                -- end
                -- print("________________item.move ==== true")
                mapTable[i+1][j+1] = 0
            else
                mapTable[i+1][j+1] = 1
            end
            -- str = str.." "..mapTable[i+1][j+1]
        end
        -- print(str)
    end

    -- for i=1, mapH do
    --     local str = i .. "  "
    --     for j=1, mapW do
    --         if mapTable[i] ~= nil then
    --         str = str .." " .. (mapTable[i][j] or "x")
    --         end
    --     end
    --     print(str)
    -- end
    
    self.mapList = mapTable
end

function MapView:getInfo()
    local rtInfo = {}
    rtInfo.path = self.path
    rtInfo.mapPos = cc.p(self:getPosition())
    rtInfo.spritePos = cc.p(self.spriteHero:getPosition())
    return rtInfo
end

return MapView