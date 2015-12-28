--
-- Author: Paul
-- Date: 2015-07-26 11:01:53
--
local BaseView = class("BaseView")

function BaseView:ctor(pageName,moduleName,initParam)
    self.pageName = pageName;
    self.moduleName = moduleName;
    self.initParam = initParam;
end

function BaseView:onInitView()
	-- body
end

function BaseView:onAssignVars()
	-- body
end


function BaseView:onUpdateData()
	-- body
end

function BaseView:onEnter()
	
end

function BaseView:onFinishedTransition()
	
end

function BaseView:onRemovePage()

end
--slider:滑块对象，toX：移动目标X，nil为x值不变, toY：移动目标Y,nil为有y值不变 t：移动时间
function BaseView:SliderMoveAction(slider, toX, toY, t)
	if nil == toX then 
		toX = slider:getPositionX() 
	end 

	if nil == toY then 
		toY = slider:getPositionY() 
	end 
    local actions = {};
    actions[#actions + 1] = CCEaseExponentialOut:create(CCMoveTo:create(t, ccp(toX,toY)));
    slider:runAction(transition.sequence(actions));
end

function BaseView:onPressKeyBack()
	echoInfo("press back on "..self.pageName);
	if gBaseLogic.sceneManager.inTransition==true or gBaseLogic.sceneManager.inBlockUI == true then
		return;
	end
	if(gBaseLogic.gameLogic ~= nil and gBaseLogic.gameLogic.gamePage ~= nil)then
		if gBaseLogic.gameLogic.judgeExitGame ~= nil then
			gBaseLogic.gameLogic:judgeExitGame()
		end
	-- elseif (self.pageName == "LoginScene" or self.pageName == "LobbyScene") then
	elseif (self.pageName == "LoginScene" or self.pageName == "LobbyScene" or self.pageName =="GameScene") then


		-- exit game
		-- if ()
		-- onPressKeyBack

		--大厅界面公告栏关闭
		if self.pageName == "LobbyScene" then 
			if gBaseLogic.lobbyLogic.lobbyScene.view.spriteContent~= nil and gBaseLogic.lobbyLogic.lobbyScene.view.tabViewLayer ~= nil then
			    gBaseLogic.lobbyLogic.lobbyScene.view.spriteContent:setVisible(false)
	            gBaseLogic.lobbyLogic.lobbyScene.view.tabViewLayer:unregisterScriptTouchHandler()
	            gBaseLogic.lobbyLogic.lobbyScene.view.tabViewLayer:removeAllChildrenWithCleanup(true);
	            gBaseLogic.lobbyLogic.lobbyScene.view.tabViewLayer = nil
	        end
	    end

		-- if gBaseLogic.inPayBox == 0 then
		-- 	if (gBaseLogic.lobbyLogic.payItemSMSCounter>0 or gBaseLogic.lobbyLogic.payItemNormalCounter>0) then
		-- 		local puid = gBaseLogic.lobbyLogic.userData.ply_guid_;
		-- 		if (puid) then
		-- 			local day = CCUserDefault:sharedUserDefault():getStringForKey("payday"..puid)
		-- 			if day==os.date("%x", os.time()) then
		-- 				CCUserDefault:sharedUserDefault():setStringForKey("payday"..puid,"0")
		-- 				local needMoney=CCUserDefault:sharedUserDefault():getIntegerForKey("paydayNeedMoney"..puid)
		-- 				gBaseLogic.lobbyLogic.selfTips.isTips = true;
		-- 				gBaseLogic:onNeedMoney("gameenter",needMoney,5);
		-- 			else
		-- 				gBaseLogic:confirmExit();
		-- 			end
		-- 		else
		-- 			gBaseLogic:confirmExit();
		-- 		end
		-- 	else
		-- 		gBaseLogic:confirmExit();	
		-- 	end	
		-- else
		-- 	gBaseLogic:confirmExit();	
		-- end
		if self.onPressBack then
			if self:onPressBack() then 
				gBaseLogic:confirmExit()
			end
		else
			gBaseLogic:confirmExit()	
		end
	else
		if (self.onPressBack) then
			self:onPressBack()
		elseif (self.onPressExit) then
			self:onPressExit()
		end
	end
end

function BaseView:onPressKeyMenu()
	-- body
end

function BaseView:onDidLoadFromCCB()
	self:onAssignVars();
	
end

function BaseView:onDidLoadFromCode()
	self:onAssignVars();
	
end

function BaseView:onAddToScene()
	-- body
end


function BaseView:onTouch(event, x, y)
    if event == "began" then
        return true
    end
end

function BaseView:showPopBoxCCB(ccbFileName,popBox,clickMaskToClose,maskType,zOrder)
	if (self.nodePopBox) then
		self:realClosePopBox();
	end

	local proxy = CCBProxy:create();
	self.nodePopBox = CCBuilderReaderLoad(ccbFileName,proxy,popBox);
	if nil == maskType or 0 == maskType then 
		self.maskLayerColor = display.newScale9Sprite("images/bg.png", display.cx,display.cy, CCSizeMake(display.width, display.height)); 
	--self.maskLayerColor = display.newColorLayer(ccc4(0, 0, 0, 80));	
	elseif 1 == maskType then
		self.maskLayerColor = display.newScale9Sprite("images/null.png", display.cx,display.cy, CCSizeMake(display.width, display.height)); 
	end

	self.maskLayerColor:setTouchEnabled(true);
	function clickMask(event, x, y, prevX, prevY)
		if (event=="began") then
			return true;
		end
		echoInfo(event..":MASK!");
		if (clickMaskToClose) then
			self:closePopBox();
		end	
		return true;
	end
	
	self.maskLayerColor:setTouchEnabled(true);
	self.maskLayerColor:addTouchEventListener(clickMask);
    self.maskLayerColor:setVisible(true);

    function clickSprite(event, x, y, prevX, prevY) 
		if (event=="began") then
            return true;
    	end 
	end
  	
  	self.nodePopBox:setAnchorPoint(ccp(0.5,0.5));
	self.nodePopBox:setPosition(display.cx,display.cy);
  	self.nodePopBox:setTouchEnabled(true);
    self.nodePopBox:addTouchEventListener(clickSprite);

	if (popBox.onAssignVars) then
		popBox:onAssignVars()
	end
	self.nodePopBox:setScale(0.1);
    actions = {};
    actions[#actions + 1] = CCEaseExponentialOut:create(CCScaleTo:create(0.1, 1));
    if (popBox.onAddToScene) then
		actions[#actions + 1] = CCCallFunc:create(handler(popBox,popBox.onAddToScene));
	end
    
    self.nodePopBox:runAction(transition.sequence(actions));
    local fadein = CCFadeIn:create(0.1);  
    self.nodePopBox:runAction(fadein);
	if zOrder ~= nil then
		self.rootNode:addChild(self.maskLayerColor,zOrder);
		self.rootNode:addChild(self.nodePopBox,zOrder+1);
	else
		self.rootNode:addChild(self.maskLayerColor,9998);
		self.rootNode:addChild(self.nodePopBox,9999);
	end
	self.currentPopBox = popBox;
	if self.scrollbarlayer then
		self.scrollbarlayer:setTouchEnabled(false)
	end
end

function BaseView:realClosePopBox()
	if self.currentPopBox == nil then
		return 
	end
	if (self.nodePopBox) then
		self.nodePopBox:removeFromParentAndCleanup(true);
		self.nodePopBox = nil;
	end
	if (self.maskLayerColor) then
		self.maskLayerColor:unregisterScriptHandler();
		self.maskLayerColor:removeFromParentAndCleanup(true);
		self.maskLayerColor = nil;
	end
	if (self.currentPopBox.onClosePopBox) then
		self.tempPopBox = self.currentPopBox
		self.currentPopBox = nil
		self.tempPopBox:onClosePopBox();
		self.tempPopBox = nil
	else
		self.currentPopBox = nil
	end
end

function BaseView:closePopBox()
	if self.currentPopBox == nil then
		return 
	end
	actions = {};
    actions[#actions + 1] = CCEaseExponentialIn:create(CCScaleTo:create(0.1, 0.1));
    actions[#actions + 1] = CCCallFunc:create(handler(self,self.realClosePopBox));
    self.nodePopBox:runAction(transition.sequence(actions));
    local fadeout = CCFadeOut:create(0.09);  
    self.nodePopBox:runAction(fadeout);
	if self.scrollbarlayer then
		self.scrollbarlayer:setTouchEnabled(true)
	end
end

function BaseView:addMaskLayer(color,popBox,clickMaskToClose)
	if (self.currentPopBox) then
		self:closePopBox();
	end

	self.maskLayerColor = display.newScale9Sprite("images/bg.png", display.cx,display.cy, CCSizeMake(display.width, display.height));
	--self.maskLayerColor = display.newColorLayer(ccc4(0, 0, 0, 80));	

	self.maskLayerColor:setTouchEnabled(true);
	function clickMask(event, x, y, prevX, prevY)
		if (event=="began") then
			return true;
		end
		echoInfo(event..":MASK!");
		if (clickMaskToClose) then
			self:closePopBox();
		end	
		return true;
	end
	
	-- 设置处理函数
	self.maskLayerColor:addTouchEventListener(clickMask);
    self.maskLayerColor:setVisible(true);
	self.rootNode:addChild(self.maskLayerColor);
	self.currentPopBox = popBox
end

function BaseView:showVipIcon(traget, level, status)
	if(gBaseLogic.MBPluginManager.distributions.novip) then
         traget:setVisible(false) 
         return
    end
	print("showVipIcon:"..level..":"..status) 
	if level > 10 then level = 10 end
	if level >= 0 then
		traget:setVisible(true) 
		--traget:setDisplayFrame(getFrameByName("viplbl"..level..".png"))
		setFrameTexture(traget,"viplbl"..level..".png")
	else 
		traget:setVisible(false) 
    end
end 


function BaseView:setCurrentPopBox(popBox)
	self.currentPopBox = popBox;
end

function BaseView:unschedule()

end


return BaseView;