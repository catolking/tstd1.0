--
-- Author: Paul
-- Date: 2015-08-05 15:44:00
--


getWeather = function (isBoss)

	if isBoss then
		return 		
		{ 
			text = "晴",
			heroRandNum = 1.1,
			enemyRandNum = 1.1,
			luckNum = math.random(10)/10 + 1,
		}
	else
		local weatherData = 
		{
			{
				text = "晴天",
				heroRandNum = 1.3,
				enemyRandNum = 1.3,
				luckNum = 1.0,
				weight = 8,
			},
			{ 
				text = "大风",
				heroRandNum = 1.3,
				enemyRandNum = 1.3,
				luckNum = 1.0,
				weight = 5,
			},
			{ 
				text = "多云",
				heroRandNum = 1.3,
				enemyRandNum = 1.3,
				luckNum = 1.0,
				weight = 4,
			},
			{ 
				text = "白雾",
				heroRandNum = 1.3,
				enemyRandNum = 1.3,
				luckNum = 1.0,
				weight = 2,
			},
			{ 
				text = "小雨",
				heroRandNum = 1.3,
				enemyRandNum = 1.3,
				luckNum = 1.0,
				weight = 2,
			},
			{ 
				text = "小雪",
				heroRandNum = 1.3,
				enemyRandNum = 1.3,
				luckNum = 1.0,
				weight = 2,
			},
			{ 
				text = "起霜",
				heroRandNum = 1.3,
				enemyRandNum = 1.3,
				luckNum = 1.0,
				weight = 2,
			},
			{ 
				text = "打雷",
				heroRandNum = 1.3,
				enemyRandNum = 1.3,
				luckNum = 1.0,
				weight = 3,
			},
			{ 
				text = "冰雹",
				heroRandNum = 1.3,
				enemyRandNum = 1.3,
				luckNum = 1.0,
				weight = 2,
			},
			{
				text = "五彩祥云",
				heroRandNum = 2,
				enemyRandNum = 0.5,
				luckNum = 3,
				weight = 1,
				color = cc.c3b(230,230,20)
			},
		}


		local weightList = {}
		local totalWeightNum = 0
		for i,v in ipairs(weatherData) do
			totalWeightNum = totalWeightNum + v.weight
			weightList[#weightList + 1] = totalWeightNum
		end

		-- for i,v in ipairs(weightList) do
		-- 	print(i,v)
		-- end

		local rnd = math.random(totalWeightNum)
		local selectNum = #weightList
		-- print("rnd", rnd, "#weightList", #weightList)
		for i,v in ipairs(weightList) do
			if v >= rnd then
				-- print("v <= rnd", v , rnd)
				selectNum = i
				break
			end
		end

		-- print("selectNum", selectNum)
		-- print("_________________________________")
		return weatherData[selectNum]
		-- return selectNum
		
	end
end

-- test random 
-- local  iii = {}
-- for i=1, 1000000 do
-- 	iii[#iii + 1] = getWeather()
-- end

-- local total_ = {}

-- for i=1,11 do
-- 	total_[i] = 0
-- end

-- for i=1, 1000000 do
-- 	local n = iii[i]
-- 	-- print("n", n)
-- 	total_[n] = total_[n] + 1
-- end

-- local weatherData = 
-- 		{
-- 			{
-- 				text = "晴天",
-- 				heroRandNum = 1.3,
-- 				enemyRandNum = 1.3,
-- 				luckNum = 1.0,
-- 				weight = 8,
-- 			},
-- 			{ 
-- 				text = "大风",
-- 				heroRandNum = 1.3,
-- 				enemyRandNum = 1.3,
-- 				luckNum = 1.0,
-- 				weight = 5,
-- 			},
-- 			{ 
-- 				text = "多云",
-- 				heroRandNum = 1.3,
-- 				enemyRandNum = 1.3,
-- 				luckNum = 1.0,
-- 				weight = 4,
-- 			},
-- 			{ 
-- 				text = "白雾",
-- 				heroRandNum = 1.3,
-- 				enemyRandNum = 1.3,
-- 				luckNum = 1.0,
-- 				weight = 2,
-- 			},
-- 			{ 
-- 				text = "小雨",
-- 				heroRandNum = 1.3,
-- 				enemyRandNum = 1.3,
-- 				luckNum = 1.0,
-- 				weight = 2,
-- 			},
-- 			{ 
-- 				text = "小雪",
-- 				heroRandNum = 1.3,
-- 				enemyRandNum = 1.3,
-- 				luckNum = 1.0,
-- 				weight = 2,
-- 			},
-- 			{ 
-- 				text = "起霜",
-- 				heroRandNum = 1.3,
-- 				enemyRandNum = 1.3,
-- 				luckNum = 1.0,
-- 				weight = 2,
-- 			},
-- 			{ 
-- 				text = "打雷",
-- 				heroRandNum = 1.3,
-- 				enemyRandNum = 1.3,
-- 				luckNum = 1.0,
-- 				weight = 3,
-- 			},
-- 			{ 
-- 				text = "冰雹",
-- 				heroRandNum = 1.3,
-- 				enemyRandNum = 1.3,
-- 				luckNum = 1.0,
-- 				weight = 2,
-- 			},
-- 			{
-- 				text = "五彩祥云",
-- 				heroRandNum = 2,
-- 				enemyRandNum = 0.5,
-- 				luckNum = 3,
-- 				weight = 1,
-- 				color = cc.c3b(230,230,20)
-- 			},
-- 		}

-- for i,v in ipairs(total_) do
-- 	print(i, v / weatherData[i].weight, weatherData[i].weight ,v)
-- end

-- print = s