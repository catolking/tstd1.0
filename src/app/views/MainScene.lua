
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

MainScene.RESOURCE_FILENAME = "MainScene.csb"

function MainScene:onCreate()
	printf("resource node = %s", tostring(self:getResourceNode()))
	gLobbyLogic.mainScene = self

	self:initCtrlButton()

	-- self.svChat:setVisible(true)
	self:initRichText()


    self.layer = display.newLayer()
    -- self.layer:addNodeEventListener(cc.KEYPAD_EVENT,handler(self,self.testKeypad))
    self:addChild(self.layer)

    print("ttttttttttttttttttttttest+++++++++++++")
    print(self.layer.onKeyPressed)
    print(self.layer.onKey)
    print(self.layer.keyPressed)
    print(self.layer.onTouchBegan)
    print(self.layer.onTouch)
    self.layer.onTouchBegan = function() print("sds")end
    self.layer:setKeyboardEnabled(true)

    -- 隐藏

    self:onPressPlus()
    self:onPressChat()

end

function MainScene:onPressHelp()
	print("MainScene:onPressHelp()")
	self.chatLayer:removeHead()
end

function MainScene:onPressPlusChat()
	self.chatLayer:addRichText()
	self.chatLayer:testAdd()
end

function MainScene:onPressChat()
	local tempString = ""
	if self.nodeChat:isVisible() then
		-- tempString = CCString:create("显示");
		tempString = "显示"
	else
		-- tempString = CCString:create("隐藏");
		tempString = "隐藏"
	end
	-- print("self.ctrlHBtnList[6]:setTitleForState", self.ctrlHBtnList[6].setTitleForState, tempString,CCControlStateNormal)
	print("self.ctrlHBtnList[6]:setTitleForState", self.ctrlHBtnList[6].setTitleTextForState, self.ctrlHBtnList[6].setTitleForState)
	-- self.ctrlHBtnList[6]:setTitleForState(tempString, CCControlStateNormal);
	-- self.ctrlHBtnList[6]:setTitleForState(CCString:create("hi"),CCControlStateHighlighted);
	self.ctrlHBtnList[6]:setTitleColorForState(cc.c3b(255, 0, 0), CCControlStateNormal);
	self.ctrlHBtnList[6]:setTitleForState(tempString, CCControlStateNormal);


	self.nodeChat:setVisible(not self.nodeChat:isVisible())
end

-- invalid arguments in function 'lua_cocos2dx_extension_ControlButton_setTitleForState'

function MainScene:initCtrlButton()
	print("MainScene:initCtrlButton()")
	print(CCControlButton)
	print(cc.ControlButton)
	self.ctrlLayer:setGlobalZOrder(5)
	self.btnPlus:setLocalZOrder(4)
	self.btnPlus:setGlobalZOrder(4)

	local initHButtons = {
			{text = "+++", name = "x1", image = "images/button/item_1.png", handle = self.onPressPlusChat, },
			{text = "部将", name = "x2", image = "images/button/item_1.png", handle = self.onPressHeros, },
			{text = "对话1", name = "x3", image = "images/button/item_1.png", handle = self.onPressHelp, },
			{text = "战斗", name = "x3", image = "images/button/item_1.png", handle = self.onPressTestFight, },
			{text = "物品", name = "items", image = "images/button/item_1.png", handle = self.onPressItems, },
			{text = "显示", name = "x3", image = "images/button/item_1.png", handle = self.onPressChat, },
		}

	local initVButtons = {
		{text = "---", name = "x4", image = "images/button/item_1.png", handle = self.onPressHelp, },
		{text = "信息2", name = "x5", image = "images/button/item_1.png" , handle = self.onPressHelp, },
		{text = "加点2", name = "x6", image = "images/button/item_1.png", handle = self.onPressHelp, },
	}

	-- local imgPath = "images/button/item_1.png"

	-- self.btnSoundState = CCControlButton:create(CCScale9Sprite:create(imgPath))
	-- self.btnSoundState:setPreferredSize(CCSize(64, 64));  
	-- self.btnSoundState:setBackgroundSpriteForState(CCScale9Sprite:create(imgPath), CCControlStateHighlighted)
	-- -- self.btnSoundState:registerControlEventHandler(clickSound, CCControlEventTouchDown)
	-- self.btnSoundState:setPosition(cc.p(-80, 0))
	-- self.ctrlLayer:addChild(self.btnSoundState)

	local btn = nil

	local createBtn = function(tag, btnInfo, nType)
		local tmpLabel =  cc.LabelTTF:create(btnInfo.text, display.DEFAULT_TTF_FONT, 24)
		btn = CCControlButton:create(tmpLabel, CCScale9Sprite:create(btnInfo.image))
		btn:registerControlEventHandler(handler(self, btnInfo.handle), CCControlEventTouchDown)
		btn:setPreferredSize(CCSize(64, 64));  
		btn:setTag(tag)
		local tempString = CCString:create(btnInfo.text);
		self.ctrlLayer:addChild(btn)
		btn:setGlobalZOrder(3)
		self[btnInfo.name] = btn
		if nType == 0 then
			-- btn:setPosition(cc.p(-10 - 75 * tag, 0))
		else
			-- btn:setPosition(cc.p(0, 10 + 75 * tag))
		end
		return btn
	end

	self.ctrlHBtnList = {}
	for tag, btnInfo in ipairs(initHButtons) do
		self.ctrlHBtnList[tag] = createBtn(tag, btnInfo, 0)
	end

	self.ctrlVBtnList = {}
	for tag, btnInfo in ipairs(initVButtons) do
		self.ctrlVBtnList[tag] = createBtn(tag, btnInfo, 1)
	end


	local eventDispatcher = self:getEventDispatcher()  
	-- 添加监听器  


	-- self:getEventDispatcher():addEventListenerWithFixedPriority(self.btnPlus, -10); 
	-- self:getEventDispatcher():addEventListenerWithFixedPriority(self.ctrlVBtnList[1], 10); 
	-- CCDirector:getInstance():getTouchDispatcher():addTargetedDelegate(self, 2, true);

	-- local initButtons = {
	--     {name = "btnStart", image = "images/items/start.png", handle = self.onPressStart, scale = 0.6, pos = cc.p(display.cx, 550 + 118)},
	--     {name = "btnHelp",  image = "images/items/help.png" , handle = self.onPressSound, scale = 0.8, pos = cc.p(81, 245)},
	--     {name = "btnSound", image = "images/items/sound.png", handle = self.onPressHelp, scale = 0.8, pos = cc.p(81, 95)},
	-- }

	-- local btn = nil
	-- for tag, btnInfo in ipairs(initButtons) do
	--     btn = ccui.Button:create(btnInfo.image, btnInfo.image)
	--     btn:onTouch(handler(self, btnInfo.handle))
	--     btn:setScale(btnInfo.scale)
	--     btn:setPosition(btnInfo.pos)
	--     btn:setTag(tag)
	--     self:addChild(btn)
	--     self[btnInfo.name] = btn
	-- end

	
end

--[[
==================
RichText
富文本
=================
]]--



-- function MainScene:ctor()
--     self.layer = display.newLayer()
--     self.layer:addNodeEventListener(cc.KEYPAD_EVENT,handler(self,self.testKeypad))
--     self:addChild(self.layer)
--     self.layer:setKeyboardEnabled(true)
-- end

function MainScene:onPressHeros()
	gLobbyLogic:createHeroInfoLayer({parent = self})
end

function MainScene:onPressTestFight()
	print("MainScene:onPressTestFight()")
	gLobbyLogic:createFightingLayer({parent = self})
end

function MainScene:testKeypad(event)
    print("event.name:"..event.name,"event.key:"..event.key)
end 


function MainScene:onPressItems()
	-- local node = newCsb(self, "BagLayer.csb")
	-- node:setAnchorPoint(cc.p(0.5,0.5))
	-- node:setPosition(display.cx, display.cy)
	-- node:setScale(0.9)

	gLobbyLogic:createBagLayer({parent = self})
	-- self.ItemLayer.onPressClick = function()
	-- 	print("···")
	-- end
end

function MainScene.___RichText(initParam)
	return gLobbyLogic:createChatLayer(initParam)
end

function MainScene.___RichText1()
	print("________++++++++++++++++++++++")
	print("cc.UIRichText", cc.UIRichText)
	print("ui", ui)
	print("ccui.UIRichText", ccui.UIRichText)
	print("UIRichText", UIRichText)
	print("________++++++++++++++++++++++")
	print("___RichText")
	local richText = ccui.RichText:create()


	richText:ignoreContentAdaptWithSize(false)

	-- richText:setAnchorPoint(cc.p(0.82,1))

	-- richText:setPosition(cc.p(420,500))

	print("TextHAlignment", cc.TextHAlignment)
	print("TextHAlignment", ccui.TextHAlignment)
	print("TextHAlignment", cc.ui)

	local re_next = {}

	local strTexts = {
		"[系] 1亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮",
		"[系] 2静静静静静静静静静静静静静静静静静",
		"[系] 3王王王王王王王王王王王王王王王王王.",
		"[系] 4玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉.",
		"[系] 5玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉.",
		"[系] 6玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉.",
		"[系] 7玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉.",
		"[系] 8玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉.",
	}
	for i,v in ipairs(strTexts) do
		if true then
			-- print("sizeeeeeee",)
			local nHeight = math.ceil(cc.LabelTTF:create(strTexts[i], display.DEFAULT_TTF_FONT, 20):getContentSize().width/400)*20+12
			local mapSize = cc.size(400,  nHeight); 
			local ttf =  cc.LabelTTF:create(strTexts[i], display.DEFAULT_TTF_FONT, 20, mapSize, cc.TEXT_ALIGNMENT_LEFT)
			ttf:setColor(cc.c3b(255 - 40* i, 40*i, 40*i)); 
			ttf:setPosition(cc.p(100,100))
			re_next[#re_next + 1] = ccui.RichElementCustomNode:create(12, cc.c3b(0, 0, 0), 255,ttf);
		else
			re_next[#re_next + 1] = ccui.RichElementText:create( i, cc.c3b(255, 255, 255), 255, "第" .. i .. "行\rn", "Helvetica", 24 )
		end
		richText:pushBackElement(re_next[i]);
	end
	richText:setLocalZOrder(10)
	return richText
end

function MainScene:onPressPlus()
	-- self.chatLayer:addRichText()
	-- self.chatLayer:testAdd()

	print("MainScene:onPressPlus")


	local nAniTime = 0.1
	if self.btnPlus:getNumberOfRunningActions() > 0 then    -- 说明有动作在执行
	else
		local nNowRotation = self.btnPlus:getRotation()
		if nNowRotation == 0 then -- 准备显示
			for tag, btn in ipairs(self.ctrlHBtnList) do
				btn:runAction(transition.sequence({
					cc.Show:create(),
					cc.Spawn:create(cc.MoveTo:create(nAniTime, cc.p(-10 - 75 * tag, 0)), cc.RotateTo:create(nAniTime, 0)),
					}))
			end
			
			for tag, btn in ipairs(self.ctrlVBtnList) do
				 btn:runAction(transition.sequence({
					cc.Show:create(),
					cc.Spawn:create(cc.MoveTo:create(nAniTime, cc.p(0, 10 + 75 * tag)), cc.RotateTo:create(nAniTime, 0)),
					}))
			end
		else    -- 准备隐藏
			
			for tag, btn in ipairs(self.ctrlHBtnList) do
				btn:runAction(transition.sequence({
					cc.Spawn:create(cc.MoveTo:create(nAniTime, cc.p(0,0)), cc.RotateTo:create(nAniTime, 90)),
					cc.Hide:create()
					}))
			end
			
			for tag, btn in ipairs(self.ctrlVBtnList) do
				 btn:runAction(transition.sequence({
					cc.Spawn:create(cc.MoveTo:create(nAniTime, cc.p(0,0)), cc.RotateTo:create(nAniTime, -90)),
					cc.Hide:create()
					}))
			end
		end
		self.btnPlus:runAction(cc.RotateTo:create(nAniTime, 45 - nNowRotation))
	end
end


function MainScene:onPressFighting()
	self.btnFighting:setVisible(false)
	-- local MapView = gLobbyLogic:createMapView({parent = self})
	-- MapView:setGlobalZOrder(-1)
	gLobbyLogic:objEvent(
	{
		name = "door",
		type = "测试",
	})
	-- self:addChild(MapView, -1)
end

function MainScene:hideTools()
	self.ctrlLayer:setVisible(false)
end

function MainScene:showTools()
	self.ctrlLayer:setVisible(true)
end

function MainScene:onPressFighting1()
	print("MainScene:onPressFighting()")

	local map=cc.TMXTiledMap:create("images/map/gongdian.tmx")
	-- local map= display.newSprite("images/map/npc.png")
	-- local map=cc.TMXTiledMap:create("images/map/wqd.tmx")
	map:setScale(1.1)
	map:setAnchorPoint(cc.p(0.5, 0.5))
	map:setPosition(display.cx, display.cy)
	self:addChild(map,-1--[[, 100000]])

	-- 获取
	local mapProperties = map:getProperties()
	local str = mapProperties["type"]

	local listMove = {1,1,2,3,4}

	-- 获取图层属性

	local sceneLayer = map:getLayer("scene");

	local layerProperties =  sceneLayer:getProperties();


	-- 获取图块属性


	--  获取对象属性
	local objectGroup = map:getObjectGroup("object");


	-- 修改区域颜色
	local chatObj = objectGroup:getObject("chat");
	local chatX = chatObj["x"]/32;
	local chatY = chatObj["y"]/32;
	local chatW = chatObj["width"]/32;
	local chatH = chatObj["height"]/32;
	local mapH = map:getMapSize().height
	local mapW = map:getMapSize().width

	for i=chatX,chatX+chatW - 1 do
		for j=chatY + 1,chatY+chatH  do
			local sprite = sceneLayer:getTileAt({x=i, y=(mapH -  j)})
			sprite:setColor(cc.c3b(255, 0, 0))
		end
	end


	-- 加载图片
	-- local npc = display.newSprite("images/map/gongdian.png")
	-- -- local npc = display.newSprite("images/map/npc.png")
	-- local _object = objectGroup:getObject("boss")
	-- npc:setPosition(_object["x"], _object["y"])
	-- npc:setAnchorPoint(cc.p(0,0))
	-- map:addChild(npc)



	-- 加入人物
	local tmp = objectGroup:getObject("chat")
	local spriteX = tmp["x"]
	local spriteY = tmp["y"]
	local spriteHero = gLobbyLogic:createHeroSprite({tiled = map})
	spriteHero:setPosition(tmp["x"], tmp["y"])
	map:addChild(spriteHero)

	setTouchLayer(self, map, {began = function(pos) 


		print("map..touch..", pos.x, pos.y) 
			if pos.x < 0 or pos.y < 0 then
				return 
			end

			local point = {}
			point.x = math.floor(pos.x/32)
			point.y = mapH - math.floor(pos.y/32) - 1
			print("ppppppppppoint__", point.x, point.y)
			local gid = sceneLayer:getTileGIDAt(point)
			local p = map:getPropertiesForGID(gid)

			if type(p) == "table" and p.move == "true" then
				spriteHero:heroMove(pos)
			end
		end})
end

function MainScene:initRichText()
	print("MainScene:initRichText()")
	-- self:initRichEdit()
	-- self:initComponent()
	print("___+++0")
	self.chatLayer = self.___RichText({parent = self.svChat})


	-- te:setVerticalSpace(5)
	-- self.svChat:onTouch(function() print("22222") return true end ,true, false)

	-- te:setPosition(-185, 1200)
	-- self.svChat:addChild(te)
	-- te:setGlobalZOrder(10)


	-- te:setSize(cc.size(400, 400))
	-- self._richChat:setAnchorPoint(cc.p(0, 0))
	-- self._richChat:setPosition(cc.p(20, 70))

	-- for i= 0,800,200 do
	--     local nodeTmp = display.newNode()
	--     nodeTmp:setPosition(cc.p(0,i))
	--     self.svChat:addChild(nodeTmp)
	-- end

	-- te:ignoreContentAdaptWithSize(false)
	-- -- self.svChat:
	-- te:setVerticalSpace(5)
	-- -- te:setContentSize(cc.size(400, 0))
	-- -- te:setAnchorPoint(cc.p(0.0, 0.0))


	-- -- setTouchLayer(self.svChat, te, {began = function(pos) print("xxx") end})

	-- -- getArraySize
	-- -- getAutoRenderSize


	-- print("RichText___",te:getLayoutSize().width, te:getLayoutSize().height)
	-- -- print("RichText___",te:getCustomSize().width, te:getCustomSize().height)
	-- -- print("RichText___",te:getVirtualRendererSize().width, te:getVirtualRendererSize().height)
	-- -- print(":getDimensions()___",te:getDimensions().width, te:getDimensions().height)

	-- local function callback(sender, eventType)
	-- print(sender, eventType)
	--     if eventType == ui.RICHTEXT_ANCHOR_CLICKED then
	--         print(">>>>>>>>>>>addEventListenerRichText")
	--     end
	-- end
	-- -- te:onTouch(function() print("xxxxxx") end )

	-- self.svChat:onTouch(function() print("22222") return true end ,true, false)

	-- te:setPosition(-185, 1200)
	-- print("___+++1")
	-- self.svChat:addChild(te)
	-- print("___+++2")
	-- -- self.svChat:setGlobalZOrder(0)
	-- te:setGlobalZOrder(10)


end

function MainScene:initRichEdit()    
	local widget = self
	if widget then
		--创建小喇叭控件

	-- local richText = ccui.RichText:create()
	--     richText:ignoreContentAdaptWithSize(false)
	--     richText:setContentSize(cc.size(100, 100))

		
		self._richBugle = ccui.RichText:create()
		self._richBugle:setSize(cc.size(940, 35))
		self._richBugle:setAnchorPoint(cc.p(0, 0))
		self._richBugle:setPosition(cc.p(100, 510))
		-- self._richBugle:setMaxLine(1)
		--创建聊天控件
		self._richChat= ccui.RichText:create()
		self._richChat:setSize(cc.size(940, 420))
		self._richChat:setAnchorPoint(cc.p(0, 0))
		self._richChat:setPosition(cc.p(20, 70))  

		widget:addChild(self._richBugle)
		widget:addChild(self._richChat)

		local function callback(sender, eventType)
			if eventType == ui.RICHTEXT_ANCHOR_CLICKED then
				print(">>>>>>>>>>>addEventListenerRichText")
			end
		end
		-- self._richChat:addEventListenerRichText(callback)
	end 
end

function MainScene:addChatMsg(channel, roleName, chatMsg, signs)
	local richText = (channel == Channel_ID_Bugle) and self._richBugle or self._richChat
	if richText and channel and roleName and chatMsg then
		local ChannelNameSwitch = 
		{
			[Channel_ID_Team] = "【队伍】",
			[Channel_ID_Privacy] = "【私聊】",
			[Channel_ID_Faction] = "【帮会】",
			[Channel_ID_World] = "【世界】",
			[Channel_ID_System] = "【系统】"
		}
		local ChannelColor = 
		{
			[Channel_ID_Team] = Color3B.ORANGE,
			[Channel_ID_Privacy] = Color3B.ORANGE,
			[Channel_ID_Faction] = Color3B.ORANGE,
			[Channel_ID_World] = Color3B.ORANGE,
			[Channel_ID_System] = Color3B.WHITE,
			[Channel_ID_Bugle] = Color3B.ORANGE
		}
		local linkColor = Color3B.YELLOW
		local linklineColor = Color4B.YELLOW   
		local outlineColor = Color4B.BLACK  

		if channel == Channel_ID_Bugle then
			richText:insertNewLine()
		end
		if ChannelNameSwitch[channel] then
			local rc = ui.RichItemText:create(channel, ChannelColor[channel], 255, strg2u(ChannelNameSwitch[channel]), "DFYuanW7-GB2312.ttf", 25)    
			rc:enableOutLine(outlineColor, 2)
			richText:insertElement(rc)
		end
		if channel ~= Channel_ID_System then
			local rcn = ui.RichItemText:create(channel, linkColor, 255, strg2u(roleName), "DFYuanW7-GB2312.ttf", 25)  
			rcn:enableLinkLine(linklineColor, 1)
			rcn:enableOutLine(outlineColor, 2)
			richText:insertElement(rcn)
			chatMsg = ":" .. chatMsg
		end
		local rcm = ui.RichItemText:create(channel, ChannelColor[channel], 255, strg2u(chatMsg), "DFYuanW7-GB2312.ttf", 25)  
		richText:insertElement(rcm)
		if channel ~= Channel_ID_Bugle then
			richText:insertNewLine()
		end
	end
end

function MainScene:initComponent()   
	self:addChatMsg(Channel_ID_Bugle, "王小二", "This is Bugle Msg")
	self:addChatMsg(Channel_ID_System, "", "This is System Msg")
	self:addChatMsg(Channel_ID_Team, "王小二", "This is Team Msg")
	self:addChatMsg(Channel_ID_World, "王小二", "This is World Msg")
	self:addChatMsg(Channel_ID_Faction, "王小二", "This is Faction Msg")

	self._channel = Channel_ID_World
	-- self:showChannel(Channel_ID_All)
	-- local btnChannel = self:getChild("Button_Channel")
	-- if btnChannel then
	--     btnChannel:setTitleText(strg2u("世界"))
	-- end    
end

return MainScene
