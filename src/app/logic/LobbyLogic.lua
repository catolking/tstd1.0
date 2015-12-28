--
-- Author: Paul
-- Date: 2015-07-12 03:06:24
--

local LobbyLogic = class("LobbyLogic");

function LobbyLogic:ctor()
	self.data = {
		_fighting_list_ = {1,2,3},	-- 行走的主角
	}

	self.stackMap = {}
	self.nowMap = nil

	self.baseItemInfo_ = loadCsvFile("data/ItemInfo.csv", true, true)	
	self.baseHeroInfo_ = loadCsvFile("data/HeroInfo.csv", true, true)	


	-- 暂存信息
	self.heroInfo = require("app.saveInfo.HeroList")
	self.enemyInfo = require("app.saveInfo.EnemyList")
	self.bagInfo = require("app.saveInfo.ItemList")

	print("self.baseItemInfo")
	-- dump(self.baseItemInfo)
	-- 白 绿 蓝 紫 橙  红  金
	self.baseLevelColor = {
		cc.c3b(255, 255, 255),
		cc.c3b(000, 192, 000),
		cc.c3b(000, 000, 230),
		cc.c3b(128, 000, 128),
		cc.c3b(255, 156, 000),
		cc.c3b(230, 030, 030),
		cc.c3b(240, 240, 000),
	}
	-- --监听手机返回键
	--     local key_listener = cc.EventListenerKeyboard:create()
	--     --返回键回调
	--     local function key_return(keycode)
	--         print(keycode)
	--         if keycode ~= cc.KeyCode.KEY_BACKSPACE then
	--             --return 
	--         end
	        
	--         local sence = cc.Director:getInstance():getRunningScene()

	--         local chlid = sence:getChildren()
	        
	--         chlid[#chlid]:Toback()
	--        -- print("EVENT_KEYBOARD_PRESSED")
	--     end
	--     -- --lua中得回调，分清谁绑定，监听谁，事件类型是什么
	--     -- key_listener:registerScriptHandler(key_return,cc.Handler.EVENT_KEYBOARD_PRESSED)
	--     -- local eventDispatch = self:getEventDispatcher()
	--     -- eventDispatch:addEventListenerWithSceneGraphPriority(key_listener,self)
	
end

function LobbyLogic:baseItemInfo()
	return clone(self.baseItemInfo_)
end

function LobbyLogic:baseHeroInfo()
	return clone(self.baseHeroInfo_)
end

function LobbyLogic:createHeroSprite(initParam)
	local spriteHero = require("app.views.HeroSprite"):create(initParam)
	return spriteHero
end

function LobbyLogic:createMapView(initParam)
	local MapView = require("app.views.MapView"):create(initParam)
	return MapView
end

function LobbyLogic:createBagLayer(initParam)
	local BagLayer = require("app.views.BagLayer"):create(initParam)
	return BagLayer
end

function LobbyLogic:createHeroInfoLayer(initParam)
	local HeroInfoLayer = require("app.views.HeroInfoLayer"):create(initParam)
	return HeroInfoLayer
end

function LobbyLogic:createFightingLayer(initParam)
	local FightingLayer = require("app.views.FightingLayer"):create(initParam)
	return FightingLayer
end

function LobbyLogic:createFightItemNode(initParam)
	local FightItemNode = require("app.views.FightItemNode"):create(initParam)
	return FightItemNode
end

function LobbyLogic:createBagItemNode(initParam)
	local BagItemNode = require("app.views.BagItemNode"):create(initParam)
	return BagItemNode
end

function LobbyLogic:createHeroInfoNode(initParam)
	local HeroInfoNode = require("app.views.HeroInfoNode"):create(initParam)
	return HeroInfoNode
end

function LobbyLogic:createHeroItemNode(initParam)
	local HeroInfoNode = require("app.views.HeroItemNode"):create(initParam)
	return HeroInfoNode
end

function LobbyLogic:createChatLayer(initParam)
	print("LobbyLogic:createChatLayer(initParam)")
	local ChatLayer = require("app.views.ChatLayer"):create(initParam)
	return ChatLayer
end

function LobbyLogic:createModelHero(initParam)
	local Hero = require("app.Model.Hero"):create(initParam)
	return Hero
end

function LobbyLogic:createModelItem(initParam)
	local Item = require("app.Model.Item"):create(initParam)
	return Item
end

function LobbyLogic:popUpMap(obj)
	print("#self.stackMap", #self.stackMap)
	if #self.stackMap <= 0 then

	else
		print("LobbyLogic:popUpMap(obj)")
		dump(self.stackMap, "self.stackMap[nTopStack]")
		local nTopStack = #self.stackMap
		self.nowMap = gLobbyLogic:createMapView({parent = gLobbyLogic.mainScene, stackInfo = self.stackMap[nTopStack]})
		table.remove(self.stackMap, nTopStack)
	end
end

function LobbyLogic:pushMap()
	print("LobbyLogic:pushMap()")
	if self.nowMap ~= nil then
		dump(self.nowMap:getInfo(), "self.nowMap:getInfo()")
		self.stackMap[#self.stackMap + 1] = self.nowMap:getInfo()
	end
end

function LobbyLogic:objEvent(obj)
	if obj.name == "door" then -- 传送
		if obj.type == "宫殿" then
			self:pushMap()
			self.nowMap:removeFromParent()
			self.nowMap = gLobbyLogic:createMapView({parent = gLobbyLogic.mainScene, path = "images/map/gongdian.tmx"})
			return true
		end

		if obj.type == "训" then
			self:pushMap()
			self.nowMap:removeFromParent()
			self.nowMap = gLobbyLogic:createMapView({parent = gLobbyLogic.mainScene, path = "images/map/wqd.tmx"})
			return true
		end

		if obj.type == "道" then
			self:pushMap()
			self.nowMap:removeFromParent()
			self.nowMap = gLobbyLogic:createMapView({parent = gLobbyLogic.mainScene, path = "images/map/daojv.tmx"})
			return true
		end

		if obj.type == "役" then
			self:pushMap()
			self.nowMap:removeFromParent()
			self.nowMap = gLobbyLogic:createMapView({parent = gLobbyLogic.mainScene, path = "images/map/wqd.tmx"})
			return true
		end

		if obj.type == "宿" then
			self:pushMap()
			self.nowMap:removeFromParent()
			self.nowMap = gLobbyLogic:createMapView({parent = gLobbyLogic.mainScene, path = "images/map/wqd.tmx"})
			return true
		end

		if obj.type == "武" then
			self:pushMap()
			self.nowMap:removeFromParent()
			self.nowMap = gLobbyLogic:createMapView({parent = gLobbyLogic.mainScene, path = "images/map/wqd.tmx"})
			return true
		end


		if obj.type == "城门" then
			-- self:pushMap()
			self.nowMap:removeFromParent()
			self.nowMap = gLobbyLogic:createMapView({parent = gLobbyLogic.mainScene, path = "images/map/BigMap.tmx"})
			return true
		end



		if obj.type == "离开" then
			-- self.nowMap = gLobbyLogic:createMapView({parent = gLobbyLogic.mainScene, path = "images/map/xuzhoucheng.tmx"})
			self.nowMap:removeFromParent()
			self:popUpMap(obj)

			return true
		end


		if obj.type == "测试" then
			self.nowMap = gLobbyLogic:createMapView({parent = gLobbyLogic.mainScene, path = "images/map/xuzhoucheng.tmx"})
			-- self:popUpMap(obj)
			-- self.nowMap:removeFromParent()

			return true
		end
	else
		
	end
end



return LobbyLogic