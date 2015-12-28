--
-- Author: Paul
-- Date: 2015-07-26 10:46:12
--
local BaseLogic = class("BaseLogic")
local _instance

function BaseLogic.getInstance()
    if not _instance then
        _instance = BaseLogic.new();
        _instance:init();
    end

    return _instance
end

function BaseLogic:ctor()
	require("cocos.framework.components.event"):bind(self);
	self.sceneManager = require("catol.SceneManager").new();
	self.currentState = self.stateUpgrade;

	
end

function BaseLogic:init()
	
	-- self.lobbyLogic = require("app.logic.LobbyLogic"):create()
	-- self.singleGameLogic = require("modulePopstar.logics.GameLogic").new();

-- 	print("CCNotificationCenter", CCNotificationCenter)
-- 	print("CCNotificationCenter", cc.NotificationCenter)
-- 	print("CCNotificationCenter", ccui.NotificationCenter)
-- 	print("CCNotificationCenter", NotificationCenter)
-- 	print("CCNotificationCenter", CCEventKeyboard)
-- 	print("CCNotificationCenter", cc.EventKeyboard)

-- 	for k,v in pairs(cc.EventKeyboard) do
-- 		print(k,v)
-- 	end


-- 	-- local count = 0

--  --        local callBack = function(evt)
--  --            count = count + 1;
--  --        end;

--  --        local customEvt = cc.EventListenerCustom:create("APP_ENTER_BACKGROUND", callBack);
--  --        --//注册自定义事件（处理优先级为12）   
--  --        cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(customEvt, 12);

--  --        --//抛出自定义事件   
--  --        cc.Director:getInstance():getEventDispatcher():dispatchCustomEvent("LAOD_PRECENT_EVENT");
--  -- --        cc.Director:getInstance():getEventDispatcher():dispatchCustomEvent("LAOD_PRECENT_EVENT");







-- local onKeyboardReleased = function()
-- 	print("eeeeeeeeeeeese")
-- end



-- local _eventDispatcher = cc.Director:getInstance():getEventDispatcher()
--  local _keyboardListener = cc.EventListenerKeyboard:create();
-- 	_keyboardListener.onKeyPressed = onKeyboardReleased



-- -- keyListener->onKeyPressed = [](EventKeyboard::KeyCode keyCode, Event* event){ log("Key %d pressed.", keyCode);  };
-- -- keyListener->onKeyReleased = [](EventKeyboard::KeyCode keyCode, Event* event){ log("Key %d released.", keyCode); };

-- -- // 添加监听器
-- -- _eventDispatcher->addEventListenerWithSceneGraphPriority(keyListener, this);













	
--     -- _keyboardListener.onKeyReleased = CC_CALLBACK_2(onKeyboardReleased, self);
--  	-- _keyboardListener.onKeyReleased = "sss"
--     _eventDispatcher:addEventListenerWithFixedPriority(_keyboardListener, 2);












-- 	-- self:setTouchMode(Touch.DispatchMode.ALL_AT_ONCE);
-- 	local  count = 3;
--     -- for  i = 0, count do
--     --     ImageView *w = ImageView:create("CloseNormal.png");
--     --     w:setTouchEnabled(true);
--     --     w:setTag(i);
--     --     w:setLayoutParameter(vparams);
      
--     --     w:addTouchEventListener(CC_CALLBACK_2(HelloWorld:onImageViewClicked, self));
--     --     _horizontalLayout:addChild(w);
--     --     if(i == 0){
--     --         w:requestFocus();
            
--     --     }
 
--     -- end


















        if true then return end



-- local onKeyboardReleased2 = function(keyCode, e)
-- {
--     Label *label = (Label*)self:getChildByTag(600);
--     if (label) {
--         char mm[10] = {};
--         sprintf(mm, "%d",keyCode);
--         label:setString(mm);
--     }
--     if (keyCode == EventKeyboard:KeyCode:KEY_DPAD_DOWN) {
--         MessageBox("down", "pressed");
--     }
--     else if (keyCode == EventKeyboard:KeyCode:KEY_DPAD_UP) {
--         MessageBox("up", "pressed");
--     }
--     if (keyCode == (EventKeyboard:KeyCode)28) {
--         //模拟android中的按键
--         cocos2d:EventKeyboard:KeyCode cocos2dKey =EventKeyboard:KeyCode:KEY_DPAD_UP;
--         cocos2d:EventKeyboard event(cocos2dKey, false);
--         cocos2d:Director:getInstance():getEventDispatcher():dispatchEvent(&event);
--     }else if (keyCode == (EventKeyboard:KeyCode)29){
        
--         cocos2d:EventKeyboard:KeyCode cocos2dKey =EventKeyboard:KeyCode:KEY_DPAD_DOWN;
--         cocos2d:EventKeyboard event(cocos2dKey, false);
--         cocos2d:Director:getInstance():getEventDispatcher():dispatchEvent(&event);
--     }else if(keyCode == (EventKeyboard:KeyCode)26){
       
--         cocos2d:EventKeyboard:KeyCode cocos2dKey =EventKeyboard:KeyCode:KEY_DPAD_LEFT;
--         cocos2d:EventKeyboard event(cocos2dKey, false);
--         cocos2d:Director:getInstance():getEventDispatcher():dispatchEvent(&event);
--     }else if(keyCode == (EventKeyboard:KeyCode)27){
        
--         cocos2d:EventKeyboard:KeyCode cocos2dKey =EventKeyboard:KeyCode:KEY_DPAD_RIGHT;
--         cocos2d:EventKeyboard event(cocos2dKey, false);
--         cocos2d:Director:getInstance():getEventDispatcher():dispatchEvent(&event);
--     }else if(keyCode == (EventKeyboard:KeyCode)35){
--         CCLOG(">>>>>>>tag=%d",tag);
--     }
 
-- }
	local notificationCenter = cc.EventListenerCustom:getInstance() 
    notificationCenter:registerScriptObserver(nil, handler(self, self.onEnterBackground), "APP_ENTER_BACKGROUND")
    notificationCenter:registerScriptObserver(nil, handler(self, self.onEnterForeground), "APP_ENTER_FOREGROUND")

    self.is_robot = 0
	self.currentGame = '';
	self.inPayBox = 0;
	self.onLogining = false;
	self.scheduler = require(cc.PACKAGE_NAME .. ".scheduler");
	
	self.debugCounter = 0;
	
	self.miniGameResPath = '';
	self.isForceUpgrade = false;
	self.isInCancelLogin = false;

	self.onbackGroundtime = 0
	self.inGround1 = 0;
	self.inGround2 = 0
	self.inGamelist = -1;--lobby 界面判断
	self.isshuangbeipay = 0; --pay double
	self:initLogCounter();
	self.gameItems = CONFIG_GAME_USE_ITEMS;
	
    CCUserDefault:sharedUserDefault():setStringForKey("currGameInfo", "0")
    CCUserDefault:sharedUserDefault():setStringForKey("chargeCancel", "0")

    self.servicePhone = ""
    --支付结果数据
	self.payCheckResult = {}
	--支付结果弹框时间
	self.paySchedule = nil
	--支付订单轮询
	self.orderCheckSchedule = nil
    return self
end 

function BaseLogic:initLogCounter()
	--自定义统一在这里说明，避免事件ID不统一，
	--页面停留直接使用该页面类名，不在这里定义
	self.logCounter = {
		ermj_matchCounter=0,--游戏局数，1，2,3,5,10
		scmj_matchCounter=0,
		lvlmj_matchCounter=0,
		sjzmj_matchCounter=0,
		shhmj_matchCounter=0,
		gdmj_matchCounter=0,
		ccmj_matchCounter=0,
		--payTypeCounter=0,--支付方式点击次数 use shopPay instead
		--payMoneryCounter=0,--支付次数 use shopPay instead
		--payOkCounter=0--支付成功次数 use payOkDuration instead
	}
	self.logDuration = {
		startDuration={start=0,duration_plus=0,stop=0},--启动到登录之间的时间
		-- loginDuration=0,--开始登录到登录完成的时间
		-- upper has changed function

		--gameDuration=0,--开始游戏到开始发牌的时间
		--gameLoginDuration=0,--点击场次到游戏开始的时间
		--shopDuration=0,--商店页面停留时间 
		--payOkDuration=0,--确认购买后到充值成功的时间 use begin end instead
		--payTipDuration={start=0,duration_plus=0,stop=0} use begin end instead
	}

	self.loglabelDuration ={
		gameTime={login=0,ready=0}
		--LOGIN_STEP={connectLobby=0,socketLobbyLogin=0,requestHTTGongGao=0}
	}

end

function BaseLogic:addLogCounter(tag,count)

	self.logCounter[tag] = self.logCounter[tag]+count;

	if (tag=="ermj_matchCounter"
	 or tag == "scmj_matchCounter" 
	 or tag == "lvlmj_matchCounter"
	 or tag == "sjzmj_matchCounter"
	 or tag == "shhmj_matchCounter"
	 or tag == "gdmj_matchCounter"
	 or tag == "ccmj_matchCounter"
	 ) then
		if (self.logCounter[tag]>=1 and self.logCounter[tag]<=10) then
			gBaseLogic.MBPluginManager:logEvent(tag..self.logCounter[tag]);
			gBaseLogic.MBPluginManager:logEvent("matchCounter"..(self.logCounter["ermj_matchCounter"]
				+self.logCounter["scmj_matchCounter"]
				+self.logCounter["lvlmj_matchCounter"]
				+self.logCounter["sjzmj_matchCounter"]
				+self.logCounter["shhmj_matchCounter"]
				+self.logCounter["gdmj_matchCounter"]
				+self.logCounter["ccmj_matchCounter"]
				));
		end
	else 
		gBaseLogic.MBPluginManager:logEvent(tag);
	end
end

function BaseLogic:logDurationSetPlus(tag,plus)
	if (self.logDuration[tag]==nil) then
		self.logDuration[tag] = {
			start = os.time(),
			duration_plus = plus,
			stop = 0
		}
	else
		self.logDuration[tag].duration_plus = self.logDuration[tag].duration_plus + plus;
	end
end

function BaseLogic:logDurationStart(tag)
	if (self.logDuration[tag]==nil) then
		self.logDuration[tag] = {
			start = os.time(),
			duration_plus = 0,
			stop = 0
		}
	else
		self.logDuration[tag].start = os.time();
	end
end

function BaseLogic:logDurationEnd(tag)
	if (self.logDuration[tag]==nil) then
		return;
	end
	self.logDuration[tag].stop = os.time();
	local duration = (self.logDuration[tag].stop-self.logDuration[tag].start)+self.logDuration[tag].duration_plus;
	gBaseLogic.MBPluginManager:logEventDuration(tag,duration*1000)
end

function BaseLogic:logEventLabelDuration(tag,label,duration)
	if self.loglabelDuration[tag]==nil or self.loglabelDuration[tag].label==nil then
		return
	end

	if duration == 0 then 
		self.loglabelDuration[tag][label] = os.time()
	elseif duration == 1 then  
		self.loglabelDuration[tag][label] = os.time() - self.loglabelDuration[tag][label]
		print(tag..":"..label..":"..self.loglabelDuration[tag][label])
		gBaseLogic.MBPluginManager:logEventLabelDuration(tag, label,self.loglabelDuration[tag][label]);
	else
		print(tag..":"..label..":"..self.loglabelDuration[tag][label])
		gBaseLogic.MBPluginManager:logEventLabelDuration(tag, label, self.loglabelDuration[tag][label]);
	end 	
end

function BaseLogic:addLogDdefine(tag,name,value)
	if tag == "gameType" then 
		print("addLogDdefine:",tag,name,name..value)
		local param = {};
		param[name] = name..value;
		gBaseLogic.MBPluginManager:logEventKV(tag,param)
	else
		print("addLogDdefine:",tag,name,value)
		local param = {};
		param[name] = value;
		gBaseLogic.MBPluginManager:logEventKV(tag,param)
	end
end


function BaseLogic:onEnterBackground()
	self.isInBackground = true;
	print("----------------BaseLogic:onEnterBackground");
	self.onbackGroundtime = 0
	self.inGround1 = os.time();
	self.lobbyLogic:dispatchLogicEvent({name = "msgEnterBack",
	        message = {}})
	print("----------------BaseLogic:onEnterBackground end");
	if self.lobbyLogic.lobbySocket~=nil then
		self.lobbyLogic.lobbySocket:setNeedReConn(false)
	end
	if self.gameLogic~=nil and self.gameLogic.gameSocket~=nil then
		self.gameLogic.gameSocket:setNeedReConn(false)
	end
end

function BaseLogic:onEnterForeground()
	self.isInBackground = false;
	print("----------------BaseLogic:onEnterForeground");
	self.inGround2 = os.time();
	if self.lobbyLogic.lobbySocket~=nil then
		self.lobbyLogic.lobbySocket:setNeedReConn(true)
	end
	if self.gameLogic~=nil and self.gameLogic.gameSocket~=nil then
		self.gameLogic.gameSocket:setNeedReConn(true)
	else --add by lxy
		izx.baseAudio:stopMusic();
	end
	self.onbackGroundtime = self.inGround2 - self.inGround1;
	if self.inGround1==0 or self.onbackGroundtime>=3600 then
	else
		self.lobbyLogic:dispatchLogicEvent({name = "msgEnterForeground",
	        message = {restime=self.onbackGroundtime}})
	end
	self.lobbyLogic:dispatchLogicEvent({name = "msgEnterFore",
	        message = {}})
	self.inGround2 = 0
	self.inGround1 = 0
	-- if(self.MBPluginManager ~= nil) then
	-- 	self.MBPluginManager:refreshConfig();
	-- end
end

function BaseLogic:runModule(gameModule,miniGameInfo)
	if (self.gameLogic == nil or self.currentGame ~=gameModule) then
		self.gameLogic = require(gameModule ..".logics.GameLogic").new();
		self.currentGame = gameModule;
	end
	self.gameLogic:setGameConfig(miniGameInfo);
	self.gameLogic:run();
	gBaseLogic:logEventLabelDuration("gameTime","login",1)
end
function BaseLogic:HTTPRequest(rst_url,pdata,cback)
	HTTPPostRequest(rst_url,pdata,cback);
end
-- is_test 参数 1:测试
function BaseLogic:HTTPGetdata(rst_url,is_test,cback)
 
	echoVerb("BaseLogic:HTTPGetdata")
 	
	local url
	if is_test ~= 0 then
		url = self.httpClient_url .. rst_url
	else
	 	url = rst_url
	end
	print ("BaseLogic:HTTPGetdata"..url)
    function callback(event)
    	print("HTTPPostRequest==ack11"..url)
    	if (event.name == "inprogress") then
    		return
    	end
	    local ok = (event.name == "completed")
	    local request = event.request
	    if not ok then
	        printx("HTTP err", request:getErrorCode() .. request:getErrorMessage())
	        if cback then cback(nil) end
	    else
	    	local code = request:getResponseStatusCode()
		    if code ~= 200 then
		        if cback then cback(nil) end
		    else
		    	local response = request:getResponseString()
		    	-- printx(response)
		    	--解析成table
		    	local thistable = json.decode(response)
		    	--返回table数据
		    	-- var_dump(table)
		    	if cback then cback(thistable) end
		    end
	    end
	end
	local request = network.createHTTPRequest(callback, url, "GET")	
	request:setTimeout(20);
	request:start()
end

function BaseLogic:LoadpayList()
	print("BaseLogic:LoadpayList")
	local mb = self.MBPluginManager;	
	self.payMidUse = nil;
	self.payMidUse = {};
	print(mb:getSimType())
	gBaseLogic.MBPluginManager.distributions.quickpay = false;
	local forceusesimtyp = gBaseLogic.MBPluginManager.distributions.forceusesimtyp
	if forceusesimtyp~=nil then
		forceusesimtyp = tonumber(forceusesimtyp)
	end
	if forceusesimtyp~=nil and forceusesimtyp>=1 and forceusesimtyp<=3 then
		for k,v in pairs(mb.allIAPSmsType) do 
			v.simTyp = tonumber(v.simTyp)
			local mid = tonumber(v.mid)
			if forceusesimtyp==v.simTyp  then
				table.insert(self.payMidUse,{mid=mid,imgPrev="",payTyp="SMS"})
	            gBaseLogic.MBPluginManager.IAPSmsType = v.pluginName;
	            gBaseLogic.MBPluginManager.IAPSmsNeedConfirm = v.needConfirm
	            gBaseLogic.MBPluginManager.distributions.quickpay = true;
				return self.payMidUse
	        end			
		end
		

	end
	local mbSimTyp = tonumber(mb:getSimType())

	if mbSimTyp~=nil then
		for k,v in pairs(mb.allIAPSmsType) do 
			-- if mb:getSimStatue() and ((tonumber(mb:getSimType())>0 and tonumber(mb:getSimType())==v.simTyp) or v.simTyp==0 )  then
			v.simTyp = tonumber(v.simTyp)
			local mid = tonumber(v.mid)
			if (mbSimTyp>0 and mbSimTyp==v.simTyp) or v.simTyp==0   then
				table.insert(self.payMidUse,{mid=mid,imgPrev="",payTyp="SMS"})
	            gBaseLogic.MBPluginManager.IAPSmsType = v.pluginName;
	            gBaseLogic.MBPluginManager.IAPSmsNeedConfirm = v.needConfirm
	            gBaseLogic.MBPluginManager.distributions.quickpay = true;
				break;                            
	        end
			
			
		end
	end
	if gBaseLogic.MBPluginManager.distributions.ios_review == true then 
		for k,v in pairs(mb.allIApTyp) do 
			if v=="IAPAppStore" then
				table.insert(self.payMidUse,{mid=tonumber(k),imgPrev=v,payTyp="Normal"})
				gBaseLogic.MBPluginManager.IAPType = v
				break;
			end
		end
	else
		local paymid = CCUserDefault:sharedUserDefault():getIntegerForKey("UserPayMid",-1)
		for k,v in pairs(mb.allIApTyp) do 
			table.insert(self.payMidUse,{mid=tonumber(k),imgPrev=v,payTyp="Normal"})
			if paymid == tonumber(k) then
				gBaseLogic.MBPluginManager.IAPType = v
			end
		end
	end
	
	return self.payMidUse;
end

function BaseLogic:getPayMidList()
	if self.payMidUse==nil then
		return self:LoadpayList()
	end
	return self.payMidUse;
end

function BaseLogic:initPluginManager()
	echoInfo("BaseLogic:initPluginManager");
	self.MBPluginManager = require("izxFW.MBPluginManager").new();
	self.MBPluginManager:loadPluginsConfig();
	self:setPackage(self.MBPluginManager.packetName);

end

function BaseLogic:run(updaterSuccOrFail)
	echoInfo('BEGIN!!!!!!BaseLogic:run');
	if (updaterSuccOrFail==nil) then
		self.updaterSuccOrFail = true;
	else
		self.updaterSuccOrFail = updaterSuccOrFail;
	end
	
	self:initPluginManager();

	self.MBPluginManager:loadPlugins();
	--self.MBPluginManager:refreshConfig();
	self:getStartData()
	if (self.updaterSuccOrFail == false) then
		--gBaseLogic.is_robot = 1
    	--gBaseLogic.lobbyLogic:startRobotGame()
    	self.singleGameLogic:showMainGame() 
		return;
	end
	
	local function startupPicCallback()
		print "startupPicCallback"
		gBaseLogic.lobbyLogic:getFunctionStatus()
	end
	if device.platform == "windows" and playStaticStartupPic(startupPicCallback) then
	else
		gBaseLogic.lobbyLogic:getFunctionStatus()
	end
	gBaseLogic.lobbyLogic:requestHTTPPaymentItems(2)
	gBaseLogic.lobbyLogic:requestHTTPPaymentItems(3)
	return
	-- gBaseLogic.lobbyLogic:requestHTTPHelpDesk()
	
	
	-- if (izx.resourceManager.netState == false) then
	-- 	self.lobbyLogic:onNoNet();
	-- 	return;
	-- end
		

	-- if (izx.resourceManager.wifiState == true) then
	-- 	-- because a lot of things run in beganing, lazy download start later
	-- 	echoInfo("izx.resourceManager.wifiState  = true");
	-- 	scheduler.performWithDelayGlobal(function()
	-- 		izx.resourceManager:startLazyDownload();
	-- 	end, 15);
	-- else
	-- 	echoInfo("izx.resourceManager.wifiState  = true");
	-- end

	-- gBaseLogic.lobbyLogic:addLogicEvent("MSG_userName_rst_send",handler(gBaseLogic.lobbyLogic, gBaseLogic.lobbyLogic.onUserNameUpdate),gBaseLogic.lobbyLogic)

	-- if gBaseLogic.MBPluginManager.distributions.closePromotionGoods ~= true then
	-- 	gBaseLogic.lobbyLogic:requestHTTPPaymentItems(2);
	-- end
end

function BaseLogic:prepareRelogin()
	self.lobbyLogic:closeSocket();
    self.lobbyLogic:resetUserInfo();
    self.isInCancelLogin = false;
    -- self:blockUI({autoUnblock=false,msg=LOGIN_LOADING_TIPS,hasCancel=true,callback=handler(self,self.onPressCancelLogin)});
end

function BaseLogic:onPressCancelLogin()
	echoInfo("BaseLogic:onPressCancelLogin");
	self:unblockUI();
	if (self.lobbyLogic.userHasLogined~=true) then
		self.isInCancelLogin = true;
	end
	self.lobbyLogic:closeSocket();
end

function BaseLogic:reqLogin()	

	--echoInfo "START LOOBY SESSION" --LOGIN_LOADING_TIPS..'…'
	-- self:blockUI({autoUnblock=false,msg=LOGIN_LOADING_TIPS,hasCancel=true,callback=handler(self,self.onPressCancelLogin)});
	-- if (self.lobbyLogic.lobbySocket) then
	-- 	self.lobbyLogic:reqLogin();
	-- else 

	-- 	self.lobbyLogic:startLobbySocket(self.socketConfig.lobbySocketConfig);
	-- end
end

function BaseLogic:setPackage(packageName)
	echoInfo("-----SET PACKAGE NAME:"..packageName.."-----");
	self.packageName = packageName;
	local packageInfo = split(packageName,'.');
	self.packagePlat = packageInfo[4] or "lua";
	self.packageVender = packageInfo[5] or "base";
end

function BaseLogic:setVersion(versionNum)
	self.versionNum = versionNum;
end

function BaseLogic:setSocketConfig(socketConfig)
	self.socketConfig = socketConfig;
end

function BaseLogic:setDefaultUser(userInfo,sessionType,writeToLocal)
	echoVerb("BaseLogic:setDefaultUser")
	local needSendRelogin = true;
	if (self.lobbyLogic.userData and (self.lobbyLogic.userData.ply_guid_ == userInfo.ply_guid_) and self.lobbyLogic.userHasLogined) then
		needSendRelogin = false;
		echoInfo("Same User!! Don't need resend login MSG");
		return;
	end

	self.lobbyLogic.userData = userInfo; 
	self.lobbyLogic.userHasLogined = false;
	if (writeToLocal) then
		CCUserDefault:sharedUserDefault():setStringForKey("ply_guid_", userInfo.ply_guid_)
	    CCUserDefault:sharedUserDefault():setStringForKey("ply_nickname_", userInfo.ply_nickname_)
	    CCUserDefault:sharedUserDefault():setStringForKey("ply_ticket_", userInfo.ply_ticket_)
	    CCUserDefault:sharedUserDefault():setBoolForKey("everLogin", true);
	    CCUserDefault:sharedUserDefault():setStringForKey("sessionType", sessionType);
	end
	return;
end

function BaseLogic:setTestUser(userInfo)
	CCUserDefault:sharedUserDefault():setStringForKey("ply_guid_", userInfo.ply_guid_)
    CCUserDefault:sharedUserDefault():setStringForKey("ply_nickname_", userInfo.ply_nickname_)
    CCUserDefault:sharedUserDefault():setStringForKey("ply_ticket_", userInfo.ply_ticket_)
    CCUserDefault:sharedUserDefault():setBoolForKey("everLogin", true)
end

function BaseLogic:checkLogin()
	echoInfo("checkLogin!!");
	

	self.lobbyLogic.userHasLogined = false;
	local everLogin = CCUserDefault:sharedUserDefault():getBoolForKey("everLogin");
	-- echoInfois_login = false;
	echoInfo("BaseLogic:checkLogin")

	if everLogin == true then
	    local sessionType = CCUserDefault:sharedUserDefault():getStringForKey("sessionType");
	    echoInfo("will load:sessionType:"..sessionType);
	    if device.platform=="ios" and sessionType=="SessionGuest" and self.MBPluginManager.distributions.ios_review == true then
	    	self.MBPluginManager.loginTypNum = 2
	    else
		    --write back the updater 
		    if (StartUpdater~=nil) then
		    	-- var_dump(StartUpdater);

		    	gBaseLogic.MBPluginManager:logEventDurationTable(StartUpdater);
		    	StartUpdater = nil;
		    end
		    gBaseLogic.MBPluginManager:logEventLabelMyBegin("LOGIN_STEP_DURA","sessionLogin");
		    
		    
		    if (self.MBPluginManager.allLoginTyp[sessionType]~=nil) then
		        scheduler.performWithDelayGlobal(function()
			    	self.MBPluginManager:sessionLogin(sessionType);
		        end, 0.5);
		    	return;
		    end
	    end
	end
	-- local canAutoReg = true;
	-- if (VenderAutoReg[self.packagePlat] and VenderAutoReg[self.packagePlat][self.packageVender]) then
	-- 	canAutoReg = false;
	-- end
	
	-- if (canAutoReg) then
	if self.MBPluginManager.distributions.noFirstAutoLogin == true then
		self.sceneManager:unblockUI();
		self.lobbyLogic:showLoginTypeLayer();
	else
		self:autoReg();
	end
	-- end

end

function BaseLogic:autoReg()
	echoVerb("=============================BaseLogic:autoReg")
	local hasSessionGuest = 0;
	local defaultSession = "";
	for sessionName,sessionInfo in pairs(self.MBPluginManager.allLoginTyp) do
		if (sessionName=="SessionGuest") then
			hasSessionGuest = 1;
		end
		defaultSession = sessionName;
	end
	if (hasSessionGuest==1) then
		defaultSession = "SessionGuest";
	end

	if device.platform=="ios" and defaultSession=="SessionGuest" and self.MBPluginManager.distributions.ios_review == true then
		defaultSession = "SessionIZhangxin"
		self.MBPluginManager.loginTypNum = 2
	end
    scheduler.performWithDelayGlobal(function()
		self.MBPluginManager:sessionLogin(defaultSession); 
    end, 0.5);

end

-- function BaseLogic:checkGameModules(gameModule)
-- 	self.upgradingGameModule = gameModule;
-- 	-- 检查版本
-- 	local url = string.gsub(URL.CHECK_PACAKGE_VERSION,"{moduleName}",gameModule);
-- 	echoInfo(url);

-- 	local upgradeManager = UpgradeManager:new(gameModule,url,RESOURCE_PATH);
--     upgradeManager:deleteVersion();
-- 	local needUpdate = upgradeManager:checkUpgrade();
-- 	echoInfo("needUpdate of "..gameModule.." is :"..needUpdate);
-- 	self.total_packages = 0;
-- 	if (needUpdate>0) then
-- 		self.total_packages = needUpdate;
        
--         -- 进入下载页面
        
--         upgradeManager:startDownload();
--         upgradeManager:registerScriptHandler(handler(self.lobbyLogic,self.lobbyLogic.onCheckGameModules));
--         self.lobbyLogic:dispatchLogicEvent({
-- 	        name = "MSG_PLUGIN_ASSET_START",
-- 	        message = {plugin=self.upgradingGameModule}
-- 	    })
-- 	elseif (needUpdate==0) then
-- 		-- 没下载也进下载页面
		
-- 	    function NO_NEW_VERSION()
-- 			self.lobbyLogic:dispatchLogicEvent({
-- 		        name = "MSG_PLUGIN_ASSET_SUCCESS",
-- 		        message = {plugin=self.upgradingGameModule,
-- 		    	typ="NO_NEW_VERSION"
-- 		    	}
-- 		    })
-- 		end
-- 	    self.scheduler.performWithDelayGlobal(NO_NEW_VERSION, 1)
-- 	else
-- 		-- 出错处理
		
-- 	end
	
-- end

function BaseLogic:checkGameUpdate(sessionInfo)
	if (true) then
		return false
	end
--  
--  {
--      nickname = 
--GT-N7100
--      reply = 
--0
--      first = 
--0
--      maxid = 
--213
--      ip = 
--s3.casino.hiigame.net
--      url = 
--http://www.baidu.com
--      face = 
--http://iface.b0.upaiyun.com/b2a6c527-dd96-476a-bc99-d8eca151d3fd.png!p300
--      tips = 
--登录成功!
--      ret = 
--0
--      vs = 
--2.1.9
--      port = 
--7200
--      ef = 
--0
--      sex = 
--0
--      plat = 
--11
--      vn = 
--11
--      pid = 
--1103134337925157
--      ticket = 
--8aa0371a0f406cabc48ef9a0d213d692
--  },
--  msg = 
--登录服务器成功
--  SessionResultCode = 
--0
--},
	local new_version = {};

	new_version.version_name = sessionInfo["vs"];
	new_version.version_code = tonumber(sessionInfo["vn"]);
	new_version.download_url = sessionInfo["url"];
	new_version.msg = sessionInfo["msg"];
	if new_version.version_name==nil or new_version.version_code ==nil then
		return false
	end

	local myVersion = self.MBPluginManager:getVersionInfo();
	if (new_version.version_code<=myVersion.version_code) then
		return false
	end

    if (tonumber(sessionInfo["ef"])==0) then
    	new_version.force_update = false;
    	if (new_version.msg==nil) then
    		new_version.msg = "发现新版本，是否升级？"
    	end
    	self.isForceUpgrade = false;
    else
    	new_version.force_update = true;
    	if (new_version.msg==nil) then
    		new_version.msg = "发现新版本，请升级!"
    	end
    	self.isForceUpgrade = true;
    end

	--local myVersion = self.MBPluginManager:getVersionInfo();
	local closeWhenClick = true;
	if (new_version.version_code>myVersion.version_code) then
		local buttonCount = 2;
		if (new_version.force_update) then
			-- self:prepareRelogin();
			buttonCount = 1;
			closeWhenClick = false;
		end
		self:confirmBox({
			callbackConfirm = function()
				CCNative:openURL(new_version.download_url);	
			end,
			msg = new_version.msg,
			title = '版本升级通知',
			buttonCount = buttonCount,
			closeWhenClick = closeWhenClick
			})
	return true;

	end
	return false;
end

function BaseLogic:onSessionResult(sessionRst)
	if (sessionRst.SessionResultCode == 0) then
		gBaseLogic.MBPluginManager:logEventLabelMyEnd("LOGIN_STEP_DURA","sessionLogin");
		-- self:unblockUI();
		if (self.isInCancelLogin) then
			return;
		end;
		if (self.onLogining) then
			print("Bloody Tencent QQ Login!!!!!!!!!!!!, is in login now...........");
			return
		end
		self.onLogining = true;
		
		local userInfo = {
			ply_guid_ = sessionRst.sessionInfo.pid,
			ply_nickname_ = sessionRst.sessionInfo.nickname,
			ply_ticket_ = string.sub(sessionRst.sessionInfo.ticket,1,32),
			ply_sex = tonumber(sessionRst.sessionInfo.sex),
			ply_age = (sessionRst.sessionInfo.age ~= nil and tonumber(sessionRst.sessionInfo.age) or 18),
		};
		self.ply_guid_ = userInfo.ply_guid_;
		self.bRegiLogin = (tonumber(sessionRst.sessionInfo.first) == 1 and true or false)
		if (sessionRst.sessionInfo.face==nil) then
			self.lobbyLogic.face = DEFAULT.URL.DEFAULT_FACE;
		else
			self.lobbyLogic.face = sessionRst.sessionInfo.face;
		end
		self:setDefaultUser(userInfo,self.MBPluginManager.sessionType,true);
		self:reqLogin();
		self.MBPluginManager.m_bPlatformLogined = true
		self.MBPluginManager:StartPushSDK();
		self.MBPluginManager:createToolbar();
		self.lobbyLogic:closeLoginTypeLayer()
		self.lobbyLogic:requestHTTPPaymentItems(2);
		self.lobbyLogic:requestHTTPPaymentItems(3);
	elseif (sessionRst.SessionResultCode == 3) then
		-- --switch user
		-- gBaseLogic.lobbyLogic.achieveListData = nil;
	 --    gBaseLogic.lobbyLogic.achieveListData = {};
		-- gBaseLogic.lobbyLogic:reShowLoginScene(false,nil,nil);
		-- gBaseLogic:prepareRelogin();
		-- self:unblockUI();
	elseif (sessionRst.SessionResultCode == 5) then
	elseif (sessionRst.SessionResultCode == 4) then
		-- self.lobbyLogic:showLoginTypeLayer()
	elseif (sessionRst.SessionResultCode == 7) then --kSessionUpdateSessionInfo
		-- local userInfo = {
		-- 	ply_guid_ = sessionRst.sessionInfo.pid,
		-- 	ply_nickname_ = sessionRst.sessionInfo.nickname,
		-- 	ply_ticket_ = string.sub(sessionRst.sessionInfo.ticket,1,32)
		-- };
		--self:setDefaultUser(userInfo,self.MBPluginManager.sessionType,true);
		-- echoInfo("------------测试改名")
		-- if gBaseLogic.lobbyLogic.userData.ply_lobby_data_ then 
		-- 	gBaseLogic.lobbyLogic.userData.ply_lobby_data_.nickname_ = sessionRst.sessionInfo.nickname
		-- end
		-- CCUserDefault:sharedUserDefault():setStringForKey("ply_nickname_", sessionRst.sessionInfo.nickname)
		-- gBaseLogic.lobbyLogic:dispatchLogicEvent({
  --                   name = "MSG_userName_rst_send",
  --                   message = sessionRst
  --               });
	else
		-- self:unblockUI();
		-- gBaseLogic.MBPluginManager:logEventLabelMyEnd("LOGIN_STEP_DURA","sessionLogin");
		-- if (self.isInCancelLogin) then
		-- 	return;
		-- end;
		-- --self.lobbyLogic:showLoginTypeLayer();
		-- if (gBaseLogic.MBPluginManager.distributions['showloginfaildialog']) then
	 --        self.lobbyLogic:onNoNet(0,sessionRst.msg);--2
	 --    end
		
	end
end

function BaseLogic:onPayResult(payRst)
	self.singleGameLogic.diamondSettlement:onPayResult(payRst)
	return

	-- self:unblockUI();
	-- gBaseLogic.MBPluginManager:logEventLabelDurationMyEnd("payDuration","res"..payRst.PayResultCode);
	-- self.inPayBox = 0;
	-- self.lobbyLogic.isShow = false;
	-- -- gBaseLogic.lobbyLogic:
	-- self.lobbyLogic:dispatchLogicEvent({
 --        name = "MSG_change_chongzhi_btn",
 --        message = {code=payRst.PayResultCode}
 --    });
 -- --    if self.gameLogic~=nil then
	-- -- 	if self.gameLogic.moneyNotEnough == 1 then
	-- -- 		self.gameLogic:LeaveGameScene(-1)
	-- -- 	end
	-- -- end

	-- local boxid = tonumber(payRst.payInfo.boxid);
	-- print("boxid:",boxid);
	-- print("payRst.PayResultCode:",payRst.PayResultCode);
	-- var_dump(payRst)

	-- local function getPayDesc(boxinfo)
	-- 	local items = self.lobbyLogic.userData.ply_items_
	-- 	local descStr = ""
	-- 	if items ~= nil then
	-- 		local tblItemName = {}
	-- 		for ki,vi in pairs(items) do
	-- 			tblItemName[vi.index_] = vi.name_
	-- 		end
	-- 		--print "tblItemName = "
	-- 		--var_dump(tblItemName)
	-- 		tblItemName[7] = "VIP"
	-- 		for ki,vi in pairs(boxinfo.content) do
	-- 			--print("ki = "..ki)
	-- 			--var_dump(vi)
	-- 			if tblItemName[vi.idx] ~= nil then
	-- 				--print("descStr1 = "..descStr)
					
	-- 				--print("descStr2 = "..descStr)
	-- 				if vi.idx == 0 then
	-- 					if self.isshuangbeipay==1 then
	-- 						descStr = descStr..(vi.num*2)
	-- 					else
	-- 						descStr = descStr..vi.num
	-- 					end
	-- 				elseif vi.idx == 5 or vi.idx == 7 then
	-- 					if self.isshuangbeipay==1 then
	-- 						descStr = descStr..(vi.num*2).."天"
	-- 					else
	-- 						descStr = descStr..vi.num.."天"
	-- 					end
	-- 				else
	-- 					if self.isshuangbeipay==1 then
	-- 						descStr = descStr..(vi.num*2).."个"
	-- 					else
	-- 						descStr = descStr..(vi.num).."个"
	-- 					end
	-- 				end
	-- 				--print("descStr3 = "..descStr)
	-- 				descStr = descStr..tblItemName[vi.idx].."，"
	-- 				--print("descStr4 = "..descStr)
	-- 			end
	-- 		end
	-- 		if descStr:len() > 0 then
	-- 			descStr = string.sub(descStr,1,descStr:len()-3)
	-- 			descStr = descStr.."。"
	-- 		end
	-- 		self.isshuangbeipay = 0
	-- 	end
	-- 	return descStr
	-- end

	-- -- boxid = 409
	-- local payItemName = "";
	-- local x = {};
	-- for k,v in pairs(self.lobbyLogic.paymentItemList) do
	-- 	if tonumber(v.boxid)==boxid then
	-- 		--var_dump(v)
	-- 		payItemName = getPayDesc(v)
	-- 		x = v
	-- 		break
	-- 	end
	-- end

	-- if payItemName=="" and self.lobbyLogic.addPaymentItemList then
	-- 	for k,v in pairs(self.lobbyLogic.addPaymentItemList) do
	-- 		if tonumber(v.boxid)==boxid then
	-- 			payItemName = getPayDesc(v)
	-- 			x = v
	-- 			break
	-- 		end
	-- 	end
	-- end

	-- if payItemName=="" and self.lobbyLogic.payVIPItemList then
	-- 	for k,v in pairs(self.lobbyLogic.payVIPItemList) do
	-- 		if tonumber(v.boxid)==boxid then
	-- 			payItemName = v.desc
	-- 			x=v
	-- 			break
	-- 		end
	-- 	end
	-- end

	-- if payItemName=="" and self.lobbyLogic.payItemPromotion then
	-- 	for k,v in pairs(self.lobbyLogic.payItemPromotion) do
	-- 		if tonumber(v.boxid)==boxid then
	-- 			payItemName = v.desc
	-- 			x=v
	-- 			self.lobbyLogic:reqSaledOnceData(true)
	-- 			break
	-- 		end
	-- 	end
	-- end

	-- if payItemName=="" and self.lobbyLogic.payItemListByMonthCard then
	-- 	for k,v in pairs(self.lobbyLogic.payItemListByMonthCard) do
	-- 		if tonumber(v.boxid)==boxid then
	-- 			payItemName = v.desc
	-- 			x=v
	-- 			break
	-- 		end
	-- 	end
	-- end

	-- if (payRst.PayResultCode~=0) then	
	-- 	if 0~= gBaseLogic.is_robot then 

	-- 		return
	-- 	end 
	-- 	if (self.lobbyLogic.userHasLogined ~= true) then 
	-- 		return;
	-- 	end
	-- 	if (payRst.PayResultCode==7 and x) then
	-- 		self.lobbyLogic:showAssistantTips({parentView = gBaseLogic.sceneManager.currentPage.view
	--             ,assistantType = self.lobbyLogic.assistantType.AssistantPayFail
	--             ,newbieCCBName = "interfaces/newbieguideSpirit3.ccbi"
	--             ,isOtherPay = true
	--             ,boxid = x.boxid});
	-- 	elseif (payRst.PayResultCode==8) then
	-- 		if self.lobbyLogic and self.lobbyLogic.shopScene and self.lobbyLogic.shopScene.view then
	-- 			self.lobbyLogic:showAssistantTips({parentView = gBaseLogic.sceneManager.currentPage.view
	-- 	            ,assistantType = self.lobbyLogic.assistantType.AssistantPayFail
	-- 	            ,newbieCCBName = "interfaces/newbieguideSpirit3.ccbi"
	-- 	            ,isOtherPay = true
	-- 	            ,boxid = x.boxid
	-- 	            ,showmsg = "主人，"..payRst.msg});
	-- 		else
	-- 			gBaseLogic.sceneManager:removePopUp("AssistantTips")
	-- 			self.lobbyLogic:notSmsPay(x.boxid, 3)
	-- 		end
	-- 	elseif (payRst.PayResultCode==2) then

	-- 	elseif (payRst.PayResultCode~=3 and payRst.PayResultCode~=5 and payRst.PayResultCode~=6) then
	-- 		self.lobbyLogic:showAssistantTips({parentView = gBaseLogic.sceneManager.currentPage.view
	--             ,assistantType = self.lobbyLogic.assistantType.AssistantPayFail
	--             ,newbieCCBName = "interfaces/newbieguideSpirit3.ccbi"
	--             ,isOtherPay = false
	--             ,boxid = x.boxid
	--             ,showmsg = payRst.msg});   		
	-- 	elseif (payRst.PayResultCode==6) then
	-- 		-- self.lobbyLogic:showAssistantTips({parentView = gBaseLogic.sceneManager.currentPage.view
	--   --           ,assistantType = self.lobbyLogic.assistantType.AssistantPayFail
	--   --           ,newbieCCBName = "interfaces/newbieguideSpirit3.ccbi"
	--   --           ,isOtherPay = false
	--   --           ,boxid = x.boxid
	--   --           ,showmsg = payRst.msg});
	-- 		self.lobbyLogic:showAssistantTips({parentView = gBaseLogic.sceneManager.currentPage.view
	--             ,assistantType = self.lobbyLogic.assistantType.AssistantPayFail
	--             ,newbieCCBName = "interfaces/newbieguideSpirit3.ccbi"
	--             ,isOtherPay = false
	--             ,boxid = x.boxid
	--             ,showmsg = payRst.msg});
	-- 	else
	-- 	end

	-- 	return;
	-- end
	
	-- --是否记录上次成功充值的宝箱ID
	-- if self.lobbyLogic.lastPaySuccess then
	-- 	self.lobbyLogic.lastPaySuccess = false;
	-- 	if payRst.PayResultCode==0 then
	-- 		local boxid = tonumber(payRst.payInfo.boxid);
	-- 		CCUserDefault:sharedUserDefault():setIntegerForKey("lastPaySuccessBoxId",boxid)
	-- 	end
	-- end


	-- gBaseLogic.MBPluginManager:logEvent("paySuccess");
	-- if self.gameLogic~=nil and self.currentState == gBaseLogic.stateInRealGame and self.gameLogic.diBaoMsg ~= "" then
	-- end
	-- local puid = self.lobbyLogic.userData.ply_guid_
	-- if puid then
	-- 	CCUserDefault:sharedUserDefault():setStringForKey("payday"..puid,"0")
	--     CCUserDefault:sharedUserDefault():setIntegerForKey("paydayNeedMoney"..puid,0)
	-- end

	-- -- self.lobbyLogic:showAssistantTips({parentView = gBaseLogic.sceneManager.currentPage.view
 -- --        ,assistantType = self.lobbyLogic.assistantType.AssistantPayOK
 -- --        ,newbieCCBName = "interfaces/newbieguideSpirit3.ccbi"
 -- --        ,boxInfo = x});

	-- self.lobbyLogic:showAssistantTips({parentView = gBaseLogic.sceneManager.currentPage.view
	--             ,assistantType = self.lobbyLogic.assistantType.AssistantPayOK
	--             ,newbieCCBName = "interfaces/newbieguideSpirit3.ccbi"
	--             ,boxInfo = x});

	-- if payRst.payInfo and payRst.payInfo.order and self.MBPluginManager.distributions.closePayOrderCheck ~= true then
	-- 	self:checkOrder(payRst.payInfo.order)
	-- end
end

-- INIT_HEADFACE_SUCCESS 	  	 = 0;
-- INIT_HEADFACE_FAIL 	 		 = 1;
-- UPLOAD_HEADFACE_SUCCESS       = 2;
-- UPLOAD_HEADFACE_FAIL 	     = 3;
function BaseLogic:onHeadImageResult(headImageRst)
	print("onHeadImageResult")
	self.lobbyLogic:dispatchLogicEvent({
			        name = "MSG_headImage_rst_send",
			        message = headImageRst
			    });
end 

function BaseLogic:switchEnv(env)
	PLUGIN_ENV = env;
	CCUserDefault:sharedUserDefault():setIntegerForKey("LAST_PLUGIN_ENV", PLUGIN_ENV+10);
	URL = getURL();
	self:setSocketConfig(SOCKET_CONFIGS[PLUGIN_ENV]);
	self.MBPluginManager:loadPluginsConfig();
	self.MBPluginManager.pluginProxy:switchPluginXRunEnv(PLUGIN_ENV);
	gBaseLogic.currentState = -1;
	self.lobbyLogic:reShowLoginScene(false,nil,true);
end

function BaseLogic:unblockUI()
	--echoError("who unblock me??");
	self.sceneManager:unblockUI();
end

function BaseLogic:waitingAni(target,tag)
	self:stopWaitingAni(tag);
	local contentSize = target:getContentSize();
	local ani = getAnimation("blockUI");
    local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
    local m_playAni = CCSprite:createWithSpriteFrame(frame);
    local action = CCRepeatForever:create(CCAnimate:create(ani));

    m_playAni:setPosition(contentSize.width/2,contentSize.height/2 + 40);
    m_playAni:setColor(ccc3(166,166,166));
    target:addChild(m_playAni);
    m_playAni:runAction(action);
    if (self.waitingAnis==nil) then
    	self.waitingAnis = {}
    end
    self.waitingAnis[tag] = m_playAni;
end

function BaseLogic:stopWaitingAni(tag)
	if (self.waitingAnis and self.waitingAnis[tag]) then
		self.waitingAnis[tag] = tolua.cast(self.waitingAnis[tag], "CCNode");
		if (self.waitingAnis[tag]~=nil) then
			self.waitingAnis[tag]:stopAllActions();
			self.waitingAnis[tag]:removeFromParentAndCleanup(true);
		end
		self.waitingAnis[tag] = nil;
	end
end

function BaseLogic:blockUI(opt)
	self.sceneManager:blockUI(opt)
end 
--  smsQuickPayEnterGame = 1,	//	进入游戏时游戏币不足
-- 	smsQuickPayPlayingGame,		//	游戏中游戏币不足
-- 	smsQuickPayCharge,			//  游戏时玩家主动充值
-- 	smsQuickPayLowMoney,		//	游戏中低保
-- 	smsQuickPayExitGame,		//  游戏退出时提示充值

function BaseLogic:onNeedMoney(msgTyp,money, status)
	local diffMoney = money - self.lobbyLogic.userData.ply_lobby_data_.money_;
	
	self.lobbyLogic:quickPay(diffMoney,status);--smsQuickPayEnterGame = 1,	//	进入游戏时游戏币不足
end


function BaseLogic:showMessageRstBox(msg,maskType,zOrder)
	if self.gameLogic ~= nil and self.gameLogic.isNewbieGuide == true then
		print "showMessageRstBox error !!! self.gameLogic.isNewbieGuide == true"
	else
	    self.sceneManager.currentPage.view.popChildren = require("moduleLobby.views.MessageRstBox").new(msg,self.sceneManager.currentPage.view);
	    self.sceneManager.currentPage.view:showPopBoxCCB("interfaces/MessageRstBox.ccbi",self.sceneManager.currentPage.view.popChildren,true,maskType,zOrder);
	end
end
-- 掉钱动画
function BaseLogic:coin_drop(cback)
	local Px = display.cx;
	local Py = display.cy; 
	local positionAni = {{Px+105,Py+40},
	{Px-150,Py+90},{Px+55,Py+160},{Px+215,Py+185},
	{Px-165,Py+245},{Px-220,Py+270},{Px+135,Py+270},
	{Px-75,Py+310},{Px+220,Py+370},{Px+135,Py+390},
	{Px-135,Py+390},{Px-55,Py+455},{Px+65,Py+430}}
	
	local winSize = CCDirector:sharedDirector():getWinSize();
	local ani = getAnimation("ani_coin_drop");
	local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
	
	local nodeAni = display.newNode();
	self.sceneManager.currentPage.scene:addChild(nodeAni)
	self.nodeAni = nodeAni
	local m_playAni_list = {}
	for k,v in pairs(positionAni) do
		local frame =  tolua.cast(ani:getFrames():objectAtIndex(k%6),"CCAnimationFrame"):getSpriteFrame()
		local m_playAni = CCSprite:createWithSpriteFrame(frame);
		
		self.nodeAni:addChild(m_playAni); 
		m_playAni:setTag(k);
		m_playAni:setPosition(v[1],v[2]);
		m_playAni:setVisible(true);	
		m_playAni:runAction(CCRepeatForever:create(CCAnimate:create(ani)));
		local pos = CCPointMake(v[1],-50);
		local action2 = CCMoveTo:create(1, pos);
		local FinishAni = function()
			print("FinishAni"..k)
			self.nodeAni:removeChildByTag(k)
			if k == #positionAni then
				print("FinishAni00"..k)
				self.nodeAni:removeAllChildrenWithCleanup(true);
				self.nodeAni = nil;
				if cback then
					cback();
				end
				
			end
		end
		local actionMoveDone = CCCallFuncN:create(FinishAni);
		m_playAni:runAction(transition.sequence({action2,CCDelayTime:create(0.2),actionMoveDone}))
	end
	scheduler.performWithDelayGlobal(function()
		izx.baseAudio:playSound("laba_drop");	
		end, 0.2)
	-- for i=1,20 do 
	-- 	self.audio:PlayAudio(40);
	-- end
	-- local actionMoveDone = CCCallFuncN:create(FinishAni);
	
	-- m_playAni:runAction(transition.sequence({CCAnimate:create(ani),CCDelayTime:create(10),actionMoveDone}));
end

function BaseLogic:confirmBox(initParam)
	local popBoxExit = {};
	function popBoxExit:onPressCancel()
		if (initParam.callbackCancel~=nil) then
			initParam.callbackCancel();
		end
		if (initParam.closeWhenClick~=false) then
			gBaseLogic.sceneManager.currentPage.view:closePopBox();
		end
	end
	function popBoxExit:onPressConfirm()
		if (initParam.callbackConfirm~=nil) then
			initParam.callbackConfirm();
		end
		if (initParam.closeWhenClick~=false) then
			--add by lxy
			--ios平台升级框确定的时候不消失提示框
			if (device.platform=="ios" and initParam.btnTitle~=nil and initParam.btnTitle.btnConfirm == "现在更新") then
			else
				gBaseLogic.sceneManager.currentPage.view:closePopBox();
			end
		end
	end
	function popBoxExit:onTouches(event,x,y)
		
	end
	function popBoxExit:onAssignVars()
		self.labelTips = tolua.cast(self["labelTips"],"CCLabelTTF");
		self.labelTipsBg = tolua.cast(self["labelTipsBg"],"CCLabelTTF");
		local gameInfo = CCUserDefault:sharedUserDefault():getStringForKey("currGameInfo");
		if(gameInfo ~= "0")then
			self.labelTips:setString(gameInfo)
			self.labelTipsBg:setString(gameInfo)
		end
		if nil ~= self["labelTitile"] then
	        self.labelTitle = tolua.cast(self["labelTitle"],"CCLabelTTF")
		end
		if nil ~= self["btnConfirm"] then
			self.btnConfirm = tolua.cast(self["btnConfirm"],"CCControlButton")
			-- self.btnConfirm:addTouchEventListener(function(event,x,y)
			-- 	print("btnConfirm====event:"..event);
			-- 	return true;
			-- end,false,-1,false);
			if initParam.btnTitle~=nil then
				if initParam.btnTitle.btnConfirm~=nil then
					local tempString = CCString:create(initParam.btnTitle.btnConfirm.."");
		            self.btnConfirm:setTitleForState(tempString,CCControlStateNormal);
				end
			end
	    end
		if nil ~= self["BtnCancel"] then
			self.BtnCancel = tolua.cast(self["BtnCancel"],"CCControlButton");
			-- self.BtnCancel:addTouchEventListener(function(event,x,y)
			-- 	print("btnConfirm====event:"..event);
			-- 	return true;
			-- end,false,-1,false);
			if initParam.btnTitle~=nil then
				if initParam.btnTitle.btnCancel~=nil then
					local tempString = CCString:create(initParam.btnTitle.btnCancel.."");
		            self.BtnCancel:setTitleForState(tempString,CCControlStateNormal);
				end
			end
	    end
	    if (initParam.msg~=nil) then
	    	self.labelTips:setString(initParam.msg);
	    end
		if (initParam.title~=nil) then
			local labelTitle = tolua.cast(self.labelTitle,"CCLabelTTF");
        	labelTitle:setString(initParam.title);
	    	--self.labelTitle:setString(initParam.title);
	    end
	    if (initParam.buttonCount~=nil and initParam.buttonCount==1) then
	    	self.BtnCancel:setVisible(false);
	    	local parent = self.btnConfirm:getParent();
	    	local contentSize = parent:getContentSize();

	    	self.btnConfirm:setPositionX(contentSize.width / 2);
	    	self.btnConfirm:setAnchorPoint(ccp(0.5,0.5));
	    end
	    
	    
	end
	
	self.sceneManager.currentPage.view:showPopBoxCCB("interfaces/TanChu.ccbi",popBoxExit,false);

end

function BaseLogic:gameExit()
	local pos = ccp(0, 150)
	gBaseLogic.singleGameLogic:showConfirm({pos=pos,
	title   = "提示",
	content = "您要离开游戏了吗？",
	onCancel = function()  end,
	onOK = function() 
    	CCDirector:sharedDirector():endToLua();
	 end,
	})
	return
end

function BaseLogic:confirmExit(notback)
	if self.isForceUpgrade then
		return
	end
	if self.inGamelist ~= -1 and notback == nil then
		if gBaseLogic.sceneManager.currentPage.pageName=="LobbyScene" then
			gBaseLogic.sceneManager.currentPage.view:onPressGameBack();
			return;
		end
	end

	var_dump(self.MBPluginManager.distributions);
	
	if (self.MBPluginManager.distributions.thirdplatformexitpage) then
		self.MBPluginManager:confirmExit();
		return;
	end

	if gBaseLogic.sceneManager.currentPage.pageName=="GameScene" then
		self:gameExit()
		return
	end

	--退出游戏小助手
	gBaseLogic.lobbyLogic:judgeShowAssistantTips(gBaseLogic.lobbyLogic.assistantType.AssistantExitGame)

	-- self:confirmBox({
	-- 	callbackConfirm = function()
	-- 		echoInfo("will exit game!!!");
	-- 		CCDirector:sharedDirector():endToLua();
	-- 		echoInfo("are you kidding me?");
	-- 	end})
end

-- type:0 单机赖子
function BaseLogic:showLaiZiTips(type,k,target)

    local LaiziTip = CCUserDefault:sharedUserDefault():getBoolForKey("laizitip")
    if true == LaiziTip then 
    	if type == 0 then 
        	gBaseLogic.sceneManager.currentPage.ctrller:initRobotInfo(1)
        else 
        	target:startGameByTypLevel2(type,k)
        end
        return
    end

    local popBoxLaiZiTips = {};
   
    function popBoxLaiZiTips:onPressNoTipAgain()
        print("onPressNoTipAgain") 
        if self.spriteNoTipAgain:isVisible() then 
            self.spriteNoTipAgain:setVisible(false) 
        else 
            self.spriteNoTipAgain:setVisible(true) 
        end
    end
    function popBoxLaiZiTips:onPressBack()
        print("onPressBack") 
        CCUserDefault:sharedUserDefault():setBoolForKey("laizitip",self.spriteNoTipAgain:isVisible())
        gBaseLogic.sceneManager.currentPage.view:closePopBox();
        if type == 0 then
            gBaseLogic.sceneManager.currentPage.view.logic:showWanFa()
        end
    end
    function popBoxLaiZiTips:onPressConfirm()
        print("onPressConfirm")        
        CCUserDefault:sharedUserDefault():setBoolForKey("laizitip",self.spriteNoTipAgain:isVisible())
        gBaseLogic.sceneManager.currentPage.view:closePopBox();
        if type == 0 then
        	gBaseLogic.sceneManager.currentPage.ctrller:initRobotInfo(1)
        else 
        	target:startGameByTypLevel2(type,k)
        end
    end

    function popBoxLaiZiTips:onAssignVars()
        self.spriteNoTipAgain = tolua.cast(self["spriteNoTipAgain"],"CCSprite");     
    end
    
    gBaseLogic.sceneManager.currentPage.view:showPopBoxCCB("interfaces/LaiZiTiShi.ccbi",popBoxLaiZiTips,false);
    gBaseLogic.sceneManager.currentPage.view.nodePopBox:setPosition(display.cx,display.cy);

end
--显示可变大小的提示框 target:父对象，typ：提示框类型，msg：提示的信息 x,y：位置 size：区域大小
function BaseLogic:showTips(target,typ,msg,x,y,size)
    target.maskLayerColor = display.newScale9Sprite("images/bg.png", display.cx,display.cy, CCSizeMake(display.width, display.height));
    target.maskLayerColor:setTouchEnabled(true);
    function clickMask(event, x, y, prevX, prevY)
        if (event=="began") then
            return true;
        end
        echoInfo(event..":MASK!");
        target.maskLayerColor:unregisterScriptHandler();
        target.maskLayerColor:removeFromParentAndCleanup(true);
        target.maskLayerColor = nil;
        target.nodeTipsBg:removeFromParentAndCleanup(true);
        target.nodeTipsBg = nil
        target.nodeTipsmsg:removeFromParentAndCleanup(true);
        target.nodeTipsmsg = nil
        return true;
    end
    
    target.maskLayerColor:setTouchEnabled(true);
    target.maskLayerColor:addTouchEventListener(clickMask);
    target:addChild(target.maskLayerColor)

    local size = CCSizeMake(400, 120)
    target.nodeTipsBg = createScaleSpt("BT_JieSuan_Lan1.png")
    target.nodeTipsBg:setAnchorPoint(ccp(.5,.5))
    target.nodeTipsBg:setPreferredSize(size)
    target.nodeTipsBg:setPosition(ccp(display.cx, display.cy))
    target:addChild(target.nodeTipsBg)

    target.nodeTipsmsg = CCLabelTTF:create(msg, "Helvetica", 28.0, size, ui.TEXT_ALIGN_LEFT, ui.TEXT_VALIGN_TOP)
    target.nodeTipsmsg:setAnchorPoint(ccp(0,1))
    target.nodeTipsmsg:setPosition(ccp(display.cx-size.width/2+5,display.cy+size.height/2-5))
    
    target:addChild(target.nodeTipsmsg)
end

function BaseLogic:showVersion(target)
	local runEnv = "正式环境"
    if (PLUGIN_ENV==ENV_TEST) then
        runEnv = "测试环境"
    elseif (PLUGIN_ENV== ENV_MIRROR ) then
        runEnv = "镜像环境"
    end
    --标题
   	local title = "游戏版本信息" 	
    --1.基本信息
	local msg1 = string.format("[INFO] # %s%s on %s ;\n[INFO] # DV:%s; PV:%d; FWV:%d;\n",gBaseLogic.packageName,SHOW_VERSION,runEnv, VERSION,CASINO_VERSION_DEFAULT,gBaseLogic.MBPluginManager.frameworkVersion);
	--2.插件信息
	local msg2 = ""
	for key, plugin_config in pairs(gBaseLogic.MBPluginManager.pluginConfigs) do  

	    plugin_SDKVersion = gBaseLogic.MBPluginManager.pluginProxy:getSDKVersion(key,plugin_config.type);
	    plugin_Version = gBaseLogic.MBPluginManager.pluginProxy:getPluginVersion(key,plugin_config.type);
	    msg2 = string.format("[INFO] # %s on SDK %s-%s \n",key,plugin_SDKVersion,plugin_Version);

	    msg1 = msg1..msg2
	end 
	--3.主版本信息
	local msg3 = ""

	--4.小游戏信息
	local msg4 = ""
	for k,v in pairs(izx.miniGameManager.miniGameCfg) do
       	msg4 = string.format("[INFO] # gameID:%d on %s:%s\n",k,v.gameName, v.version);
       	msg1 = msg1..msg4
    end

	local msgt = split(msg1,'\n')
	self:showTips(target,1,msgt,title,x,y,CCSizeMake(display.width, display.height))
    	
end

function BaseLogic:showTopTips(tips)
	if (self.topTips) then
		self.topTips:stopAllActions();
		self.topTips.removeFromParentAndCleanup(true);
		self.topTips = nil;
	end
	self.topTips = display.newNode();
	self.topTips:setPosition(display.cx, display.height+20);
	local bg = createScaleSpt("lobby_bg_gonggao.png");
	bg:setPreferredSize(CCSizeMake(888, bg:getContentSize().height))
	
	local label = CCLabelTTF:create(tips, "", 28);
	label:setColor(ccc3(254,254,254));

	
	self.topTips:addChild(bg);
	self.topTips:addChild(label);
	self.sceneManager.currentPage.scene:addChild(self.topTips);

	function releaseMe() 
		if (self.topTips) then
			self.topTips:removeFromParentAndCleanup(true);
			self.topTips = nil;
		end
	end

	actions = {};
    actions[#actions + 1] = CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(display.cx,display.height-20)));
    actions[#actions + 1] = CCDelayTime:create(5.0);
    actions[#actions + 1] = CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(display.cx,display.height+20)));
    actions[#actions + 1] = CCCallFunc:create(releaseMe);

    self.topTips:runAction(transition.sequence(actions));

end

function BaseLogic:getFormatServicePhone()
	-- body
	local formatPhone = gBaseLogic.servicePhone
	if formatPhone ~= "" and formatPhone:len() == 10 then
        local str1 = string.sub(formatPhone,1,3)
        local str2 = string.sub(formatPhone,4,6)
        local str3 = string.sub(formatPhone,7,10)
        formatPhone = str1.."-"..str2.."-"..str3
    end
	return formatPhone
end

function BaseLogic:checkOrder(order)
	-- body
	if order == nil or order:len() == 0 then
		return
	end
	self:resetOrderCheckSchedule()
	if self.lobbyLogic and self.lobbyLogic.userData.ply_guid_ and self.lobbyLogic.userData.ply_ticket_ then
		local curCheckCount = 0
		local function checkOrderIn(order)
			curCheckCount = curCheckCount + 1
			local tableRst = {pid=self.lobbyLogic.userData.ply_guid_,ticket=self.lobbyLogic.userData.ply_ticket_,order=order,pn=gBaseLogic.packageName};

			local listSrc = {'pid','ticket','order','pn'}
			local url = supplant(URL.CHECK_ORDER,listSrc,tableRst);
		 	print "checkOrderIn"
			print("#####"..url)
			gBaseLogic:HTTPGetdata(url,0,function(event)
				print "checkOrderIn event"
				var_dump(event)
		        if (event ~= nil and event.ret == 0) then
		        	if event.desc and event.desc:len() > 0 then
		        		event.desc = string.gsub(event.desc,'\n', '')
		        		print("event.desc = "..event.desc)
			        	self.lobbyLogic:showAssistantTips({parentView = gBaseLogic.sceneManager.currentPage.view
				            ,assistantType = self.lobbyLogic.assistantType.AssistantPayRet
				            ,newbieCCBName = "interfaces/newbieguideSpirit3.ccbi"
				            ,showmsg = "主人，"..event.desc
				            ,ret = event.ret});
			        	-- table.insert(self.payCheckResult, {parentView = gBaseLogic.sceneManager.currentPage.view
				        --     ,assistantType = self.lobbyLogic.assistantType.AssistantPayRet
				        --     ,newbieCCBName = "interfaces/newbieguideSpirit3.ccbi"
				        --     ,showmsg = "主人，"..event.desc
				        --     ,ret = event.ret})
			        	-- self:startPayResultSchedule()
			        end
			    elseif (event ~= nil and (event.ret == -2 or event.ret == -3)) then
			    	self.lobbyLogic:showAssistantTips({parentView = gBaseLogic.sceneManager.currentPage.view
			            ,assistantType = self.lobbyLogic.assistantType.AssistantPayRet
			            ,newbieCCBName = "interfaces/newbieguideSpirit3.ccbi"
			            ,showmsg = event.desc
			            ,ret = event.ret});
			    	-- table.insert(self.payCheckResult, {parentView = gBaseLogic.sceneManager.currentPage.view
			     --        ,assistantType = self.lobbyLogic.assistantType.AssistantPayRet
			     --        ,newbieCCBName = "interfaces/newbieguideSpirit3.ccbi"
			     --        ,showmsg = event.desc
			     --        ,ret = event.ret})
			    	-- self:startPayResultSchedule()
		        else
		        	if curCheckCount <= 5 then
						self.orderCheckSchedule = scheduler.performWithDelayGlobal(function()
							checkOrderIn(order)
						end, 5);
					else
						self.lobbyLogic:showAssistantTips({parentView = gBaseLogic.sceneManager.currentPage.view
				            ,assistantType = self.lobbyLogic.assistantType.AssistantPayRet
				            ,newbieCCBName = "interfaces/newbieguideSpirit3.ccbi"
				            ,ret = -2});
					end
			    end	    
		    end);
			
		end
		checkOrderIn(order)
	end
end

function BaseLogic:startPayResultSchedule()
	-- body
	print "BaseLogic:startPayResultSchedule"
	if self.paySchedule ~= nil then
		scheduler.unscheduleGlobal(self.paySchedule)
		self.paySchedule = nil
	end
	local function popSavedPayResult()
		-- print "popSavedPayResult"
		-- var_dump(self.payCheckResult)
		if self.payCheckResult and #self.payCheckResult > 0 then
			if self.lobbyLogic and gBaseLogic.sceneManager.popUps["AssistantTips"] == nil and self.lobbyLogic.lobbyScene ~= nil then
				local initParam = self.payCheckResult[1]
				initParam.parentView = gBaseLogic.sceneManager.currentPage.view
				self.lobbyLogic:showAssistantTips(initParam);
				table.remove(self.payCheckResult, 1)
			end
			self.paySchedule = scheduler.performWithDelayGlobal(popSavedPayResult, 1.0)
		else
			self:resetPayResult()
		end
	end
	popSavedPayResult()
end

function BaseLogic:resetPayResult()
	-- body
	print "BaseLogic:resetPayResult"
	self.payCheckResult = nil
	self.payCheckResult = {}
	if self.paySchedule ~= nil then
		scheduler.unscheduleGlobal(self.paySchedule)
		self.paySchedule = nil
	end
end

function BaseLogic:resetOrderCheckSchedule()
	-- body
	print "BaseLogic:resetOrderCheckSchedule"

	if self.orderCheckSchedule ~= nil then
		scheduler.unscheduleGlobal(self.orderCheckSchedule)
		self.orderCheckSchedule = nil
	end
end

function BaseLogic:getStartData()
	print "BaseLogic:getStartData~~~~~~"

	if (self.MBPluginManager.distributions.startdata) then
		print "self.MBPluginManager.distributions.startdata"
	    -- call Java method
	    local javaClassName = "com.izhangxin.utils.luaj"
	    local javaMethodName = "getStartData"
	    local javaParams = {
	                
	    }
	    local javaMethodSig = "()Ljava/lang/String;";
	     echoInfo("来自java StartData函数");
	     luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	    local rst,ret = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig);

	    var_dump(rst);
	    var_dump(ret);
	    echoInfo("来自java StartData函数");

	    if (rst == false) then
	    	return;
	    end

	    local startData = json.decode(ret);
	    if (startData.music) then
	    	izx.baseAudio:SetEffectValue(1.0,"ermj_effect_value");
	    	izx.baseAudio:SetAudioValue(1.0,"ermj_audio_value");
	    else
	    	izx.baseAudio:SetEffectValue(0,"ermj_effect_value");
	    	izx.baseAudio:SetAudioValue(0,"ermj_audio_value");
	    end
	end
end

function BaseLogic:getMilliseconds()
	-- body
	return self.MBPluginManager.pluginProxy:getMilliseconds()
end

return BaseLogic;