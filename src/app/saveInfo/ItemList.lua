--
-- Author: Paul
-- Date: 2015-07-29 12:59:53
--
local itemData = {}

itemData[1] = 
	{
		{
			id = 1,
			num = 7,
		},
		{
			id = 2,
			num = 13,
		},
		{
			id = 2,
			num = 13,
		},
		{
			id = 2,
			num = 13,
		},
		{
			id = 2,
			num = 13,
		},
		{
			id = 2,
			num = 13,
		},
		{
			id = 2,
			num = 13,
		},
		{
			id = 2,
			num = 13,
		},
		{
			id = 2,
			num = 13,
		},
		{
			id = 2,
			num = 13,
		},
		{
			id = 2,
			num = 13,
		},
		{
			id = 2,
			num = 13,
		},
		{
			id = 2,
			num = 13,
		},
		{
			id = 2,
			num = 13,
		},
	}


	itemData[2] = 
	{
		{
			id = 1001,
		},
		{
			id = 1002,
		},
		{
			id = 1003,
		},
	}


	itemData[3] = 
	{
		{
			id = 2001,
		},
	}



	for i=1001,1020 do
		itemData[2][#itemData[2] + 1] = 
		{
			id = i
		}
	end


return itemData