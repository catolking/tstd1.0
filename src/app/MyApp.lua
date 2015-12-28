
local MyApp = class("MyApp", cc.load("mvc").AppBase)



require("app.data.NormalData")
gBaseLogic = require("catol.BaseLogic"):create();
gBaseLogic:init();
gLobbyLogic = require("app.logic.LobbyLogic"):create()
display.loadSpriteFrames("images/heroWalk/heroList.plist", "images/heroWalk/heroList.png")
-- display.loadSpriteFrames("images/heroWalk/hero.plist", "images/heroWalk/hero.png")
display.loadSpriteFrames("images/animation/attack.plist", "images/animation/attack.png")





function MyApp:onCreate()


	-- for i=0,15 do
	-- 	local frames = display.newFrames("hero_%02d.png", i*4+1, 4)
	-- 	local animation = display.newAnimation(frames, 0.2)
	-- 	display.setAnimationCache(string.format("hero_%d_%d",math.floor(i/4+1), i%4+1), animation)
	-- end

	local frames = nil
	local animation = nil
	local strFrameName = nil
	for i=1, 5 do
		-- 初始化 方向
		for j=1, 4 do
			-- hero_5_19.png
			strFrameName = "hero_" .. i .. "_%02d.png"
			frames = display.newFrames(strFrameName, j * 4 - 3, 4)
			animation = display.newAnimation(frames, 0.2)
			display.setAnimationCache(string.format("hero_%d_%d",i, j), animation)
		end
		-- 初始化 攻击
		frames = display.newFrames(strFrameName, 18, 2)
		animation = display.newAnimation(frames, 0.5)
		display.setAnimationCache(string.format("hero_%d_5",i), animation)
	end


	local resList = 
	{
		{
			"bing",
			"bing%d.png",
			1,5
		},
		{
			"lei",
			"lei_%02d.png",
			1,4
		},
	}


	for i, resData in ipairs(resList) do
		local frames = display.newFrames(resData[2], resData[3], resData[4])
		local animation = display.newAnimation(frames, 0.2)
		display.setAnimationCache(resData[1], animation)
	end





    math.randomseed(os.time())
end



return MyApp
